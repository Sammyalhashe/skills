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

              if [ -f "$skillDir/SKILL.md" ]; then
                echo -e "\n\n---" >> "$out/$platform/AGENTS.md"
                echo "# Skill: $skillName" >> "$out/$platform/AGENTS.md"
                cat "$skillDir/SKILL.md" >> "$out/$platform/AGENTS.md"
              fi
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

    # Start AGENTS.md — copy from rules package or create header
    for platform in claude gemini openai; do
      agents_file="$out/$platform/AGENTS.md"
      if [ -n "${rulesFlag}" ] && [ -f "${rulesFlag}/$platform/AGENTS.md" ]; then
        cat "${rulesFlag}/$platform/AGENTS.md" > "$agents_file"
      else
        echo "# AI Agents Skills & Instructions" > "$agents_file"
        echo "" >> "$agents_file"
        echo "This file contains consolidated skill instructions for the $platform platform." >> "$agents_file"
      fi
    done

    # Install skills and append to AGENTS.md
    ${skillInstalls}

    # Build routing table
    routing_table=""
    ${routingInstalls}

    # Generate platform entrypoints
    cat > $out/claude/CLAUDE.md << ENTRYEOF
# Claude Code Instructions

All agent rules and skill instructions are defined in @AGENTS.md — follow them.

## Context Routing

When a topic arises, load the relevant skill file directly — don't rely solely on the AGENTS.md summary.

| Topic | Path |
|-------|------|
| Global rules | @AGENTS.md (top section) |
$routing_table

## Customizations

User overrides live at \`~/.claude/customizations/<skill-name>.md\`. Check before applying a skill.
ENTRYEOF

    cat > $out/gemini/GEMINI.md << ENTRYEOF
# Gemini Instructions

All agent rules and skill instructions are defined in @AGENTS.md — follow them.

## Context Routing

| Topic | Path |
|-------|------|
| Global rules | @AGENTS.md (top section) |
$routing_table
ENTRYEOF

    cat > $out/openai/OPENAI.md << ENTRYEOF
# OpenAI Instructions

All agent rules and skill instructions are defined in @AGENTS.md — follow them.

## Context Routing

| Topic | Path |
|-------|------|
| Global rules | @AGENTS.md (top section) |
$routing_table
ENTRYEOF

    # Install bin/ and hooks/
    ${binInstall}
    ${hooksInstall}
  '';
}
