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

    # Track skills for AGENTS.md
    for platform in claude gemini openai; do
      agents_file=$out/$platform/AGENTS.md
      echo "# AI Agents Skills & Instructions" > $agents_file
      echo "This file contains consolidated instructions for all available skills for the $platform platform." >> $agents_file
    done

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

          # Append to AGENTS.md for each platform
          if [ -f "$skillDir/SKILL.md" ]; then
            for platform in claude gemini openai; do
              echo -e "\n\n---" >> $out/$platform/AGENTS.md
              echo "# Skill: $skillName" >> $out/$platform/AGENTS.md
              cat "$skillDir/SKILL.md" >> $out/$platform/AGENTS.md
            done
          fi
        fi
      done
    fi

    # Install binaries
    if [ -d bin ]; then
      for platform in claude gemini openai; do
        mkdir -p "$out/$platform/bin"
        cp -r bin/* "$out/$platform/bin/"
      done
    fi
  '';
}
