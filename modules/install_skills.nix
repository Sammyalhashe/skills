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
    agents_file=$out/openai/AGENTS.md
    echo "# AI Agents Skills & Instructions" > $agents_file
    echo "This file contains consolidated instructions for all available skills." >> $agents_file

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

          # Append to AGENTS.md
          if [ -f "$skillDir/SKILL.md" ]; then
            echo -e "\n\n---" >> $agents_file
            echo "# Skill: $skillName" >> $agents_file
            cat "$skillDir/SKILL.md" >> $agents_file
          fi
        fi
      done
    fi
  '';
}
