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

    # Build AGENTS.md for each platform: global rules first, then skills
    for platform in claude gemini openai; do
      agents_file=$out/$platform/AGENTS.md
      echo "# AI Agents Skills & Instructions" > $agents_file
      echo "" >> $agents_file
      echo "This file contains global rules and consolidated skill instructions for the $platform platform." >> $agents_file

      # Inject global rules
      if [ -d rules ]; then
        for ruleFile in rules/*.md; do
          if [ -f "$ruleFile" ]; then
            echo -e "\n\n---" >> $agents_file
            cat "$ruleFile" >> $agents_file
          fi
        done
      fi
    done

    # Install skills into each platform's structure
    if [ -d skills ]; then
      for skillDir in skills/*/; do
        if [ -d "$skillDir" ]; then
          skillName=$(basename "$skillDir")

          for platform in claude gemini openai; do
            mkdir -p "$out/$platform/$skillName"
            cp -r "$skillDir/." "$out/$platform/$skillName/"
          done

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

    # Build context routing table from installed skills
    routing_table=""
    if [ -d skills ]; then
      for skillDir in skills/*/; do
        if [ -f "$skillDir/SKILL.md" ]; then
          skillName=$(basename "$skillDir")
          routing_table="$routing_table| $skillName | @$skillName/SKILL.md |
"
        fi
      done
    fi

    # Generate platform-specific entrypoint files with routing table
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

    # Install binaries
    if [ -d bin ]; then
      for platform in claude gemini openai; do
        mkdir -p "$out/$platform/bin"
        cp -r bin/* "$out/$platform/bin/"
      done
    fi

    # Install hooks directory (always create, copy contents if any)
    for platform in claude gemini openai; do
      mkdir -p "$out/$platform/hooks"
      if [ -d hooks ]; then
        find hooks -maxdepth 1 -type f ! -name '.gitkeep' -exec cp {} "$out/$platform/hooks/" \; 2>/dev/null || true
      fi
    done
  '';
}
