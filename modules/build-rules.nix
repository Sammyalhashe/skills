{ pkgs, rulesSrc }:

pkgs.stdenvNoCC.mkDerivation {
  name = "ai-rules";
  src = rulesSrc;

  phases = [ "installPhase" ];

  installPhase = ''
    for platform in claude gemini openai; do
      mkdir -p "$out/$platform"
      agents_file="$out/$platform/AGENTS.md"

      echo "# AI Agents Skills & Instructions" > "$agents_file"
      echo "" >> "$agents_file"
      echo "This file contains global rules and consolidated skill instructions for the $platform platform." >> "$agents_file"

      for ruleFile in $src/*.md; do
        if [ -f "$ruleFile" ]; then
          echo -e "\n\n---" >> "$agents_file"
          cat "$ruleFile" >> "$agents_file"
        fi
      done
    done
  '';
}
