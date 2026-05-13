{ pkgs, agentSrc, agentName }:

pkgs.stdenvNoCC.mkDerivation {
  name = "agent-${agentName}";
  src = agentSrc;

  phases = [ "installPhase" ];

  installPhase = ''
    for platform in claude gemini openai; do
      mkdir -p "$out/$platform/agents/${agentName}"
      cp -r $src/. "$out/$platform/agents/${agentName}/"
    done
  '';
}
