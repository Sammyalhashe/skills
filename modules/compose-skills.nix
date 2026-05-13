{ pkgs }:

{ skills ? []
, rules ? null
, binSrc ? null
, hooksSrc ? null
, name ? "ai-skills-composed"
}:

pkgs.stdenvNoCC.mkDerivation {
  inherit name;

  phases = [ "installPhase" ];

  installPhase = let
    rulesFlag = if rules != null then rules else "";
    skillInstalls = pkgs.lib.concatStringsSep "\n" (map (skillPkg: ''
      for platform in claude gemini openai; do
        if [ -d "${skillPkg}/$platform" ]; then
          for skillDir in ${skillPkg}/$platform/*/; do
            if [ -d "$skillDir" ]; then
              skillName=$(basename "$skillDir")
              mkdir -p "$out/$platform/$skillName"
              cp -r "$skillDir/." "$out/$platform/$skillName/"
            fi
          done
        fi
      done
    '') skills);

    routingInstalls = pkgs.lib.concatStringsSep "\n" (map (skillPkg: ''
      for skillDir in ${skillPkg}/claude/*/; do
        if [ -d "$skillDir" ] && [ -f "$skillDir/SKILL.md" ]; then
          skillName=$(basename "$skillDir")
          routing_table="$routing_table| $skillName | @$skillName/SKILL.md |
"
        fi
      done
    '') skills);

    binInstall = if binSrc != null then ''
      for platform in claude gemini openai; do
        mkdir -p "$out/$platform/bin"
        cp -r ${binSrc}/* "$out/$platform/bin/" 2>/dev/null || true
      done
    '' else "";

    hooksInstall = ''
      for platform in claude gemini openai; do
        mkdir -p "$out/$platform/hooks"
      done
    '' + (if hooksSrc != null then ''
      for platform in claude gemini openai; do
        find ${hooksSrc} -maxdepth 1 -type f ! -name '.gitkeep' -exec cp {} "$out/$platform/hooks/" \; 2>/dev/null || true
      done
    '' else "");
  in ''
    mkdir -p $out/claude $out/gemini $out/openai

    # Build routing table from installed skills
    ${skillInstalls}
    routing_table=""
    ${routingInstalls}

    # Generate AGENTS.md: global rules + routing table (no skill content)
    for platform in claude gemini openai; do
      agents_file="$out/$platform/AGENTS.md"

      # Start with global rules
      if [ -n "${rulesFlag}" ] && [ -f "${rulesFlag}/$platform/AGENTS.md" ]; then
        cat "${rulesFlag}/$platform/AGENTS.md" > "$agents_file"
      else
        echo "# AI Agents Skills & Instructions" > "$agents_file"
        echo "" >> "$agents_file"
      fi

      # Append routing table
      cat >> "$agents_file" << ROUTINGEOF


---

## Context Routing

When a topic arises, load the relevant skill file directly.

| Topic | Path |
|-------|------|
$routing_table

## Customizations

User overrides live at \`~/.claude/customizations/<skill-name>.md\`. Check before applying a skill.
ROUTINGEOF
    done

    # Platform entrypoints — thin shims that reference AGENTS.md
    cat > $out/claude/CLAUDE.md << 'ENTRYEOF'
@AGENTS.md
ENTRYEOF

    cat > $out/gemini/GEMINI.md << 'ENTRYEOF'
@AGENTS.md
ENTRYEOF

    cat > $out/openai/OPENAI.md << 'ENTRYEOF'
@AGENTS.md
ENTRYEOF

    # Install bin/ and hooks/
    ${binInstall}
    ${hooksInstall}
  '';
}
