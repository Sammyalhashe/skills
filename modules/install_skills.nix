{ pkgs, src, marketplace, plugin }:

pkgs.stdenvNoCC.mkDerivation {
  name = "ai-skills";
  inherit src;

  installPhase = ''
    # Remove any stale result symlink from source
    rm -rf $out/result

    # Create top-level platform directories
    mkdir -p $out/claude
    mkdir -p $out/gemini
    mkdir -p $out/openai

    # Install skills into each platform's structure
    if [ -d skills ]; then
      for skillDir in skills/*/; do
        if [ -d "$skillDir" ]; then
          skillName=$(basename "$skillDir")
          
          # Claude structure
          mkdir -p "$out/claude/$skillName"
          cp -r "$skillDir/." "$out/claude/$skillName/"

          # Gemini structure
          mkdir -p "$out/gemini/$skillName"
          cp -r "$skillDir/." "$out/gemini/$skillName/"

          # OpenAI structure
          mkdir -p "$out/openai/$skillName"
          cp -r "$skillDir/." "$out/openai/$skillName/"
        fi
      done
    fi
  '';
}
