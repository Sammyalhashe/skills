{ pkgs, agentSrc, agentName }:

pkgs.stdenvNoCC.mkDerivation {
  name = "agent-${agentName}";
  src = agentSrc;

  phases = [ "installPhase" ];

  installPhase = ''
    for platform in claude gemini openai; do
      mkdir -p "$out/$platform/agents"
      cp "$src/AGENT.md" "$out/$platform/agents/${agentName}.md"
    done
  '';
}
