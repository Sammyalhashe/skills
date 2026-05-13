{ pkgs }:

{ skills ? []
, agents ? []
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

    skillRouting = pkgs.lib.concatStringsSep "\n" (map (skillPkg: ''
      for skillDir in ${skillPkg}/claude/*/; do
        if [ -d "$skillDir" ] && [ -f "$skillDir/SKILL.md" ]; then
          skillName=$(basename "$skillDir")
          skill_routing="$skill_routing| $skillName | @$skillName/SKILL.md |
"
        fi
      done
    '') skills);

    agentInstalls = pkgs.lib.concatStringsSep "\n" (map (agentPkg: ''
      for platform in claude gemini openai; do
        if [ -d "${agentPkg}/$platform/agents" ]; then
          mkdir -p "$out/$platform/agents"
          cp -r "${agentPkg}/$platform/agents/." "$out/$platform/agents/"
        fi
      done
    '') agents);

    agentRouting = pkgs.lib.concatStringsSep "\n" (map (agentPkg: ''
      for agentDir in ${agentPkg}/claude/agents/*/; do
        if [ -d "$agentDir" ] && [ -f "$agentDir/AGENT.md" ]; then
          agentName=$(basename "$agentDir")
          agent_routing="$agent_routing| $agentName | @agents/$agentName/AGENT.md |
"
          companions_line=$(grep "^companions:" "$agentDir/AGENT.md" 2>/dev/null || true)
          if [ -n "$companions_line" ]; then
            companions=$(echo "$companions_line" | sed 's/^companions:[[:space:]]*//' | tr -d ' \r')
            for companion in $(echo "$companions" | tr ',' ' '); do
              agent_routing="$agent_routing| $agentName + $companion | @agents/$agentName/AGENT.md @agents/$companion/AGENT.md |
"
            done
          fi
        fi
      done
    '') agents);

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

    # Install skills and agents
    ${skillInstalls}
    ${agentInstalls}

    # Build routing tables
    skill_routing=""
    ${skillRouting}
    agent_routing=""
    ${agentRouting}

    # Generate AGENTS.md: global rules + routing tables
    for platform in claude gemini openai; do
      agents_file="$out/$platform/AGENTS.md"

      # Start with global rules
      if [ -n "${rulesFlag}" ] && [ -f "${rulesFlag}/$platform/AGENTS.md" ]; then
        cat "${rulesFlag}/$platform/AGENTS.md" > "$agents_file"
      else
        echo "# AI Agents Skills & Instructions" > "$agents_file"
        echo "" >> "$agents_file"
      fi

      # Append routing tables
      cat >> "$agents_file" << ROUTINGEOF


---

## Context Routing

When a topic arises, load the relevant skill or agent file directly.

### Skills

| Topic | Path |
|-------|------|
$skill_routing

### Agent Personas

When asked to adopt a persona, or when the task matches an agent's expertise, load their profile.

| Agent | Path |
|-------|------|
$agent_routing

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
