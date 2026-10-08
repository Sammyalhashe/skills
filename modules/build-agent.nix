{ pkgs, agentSrc, agentName }:

let
  python = pkgs.python3.withPackages (pythonPackages: [
    pythonPackages.pyyaml
    pythonPackages.tomli-w
  ]);
in

pkgs.stdenvNoCC.mkDerivation {
  name = "agent-${agentName}";
  src = agentSrc;

  phases = [ "installPhase" ];

  installPhase = ''
    for platform in claude gemini openai; do
      mkdir -p "$out/$platform/agents"
      cp "$src/AGENT.md" "$out/$platform/agents/${agentName}.md"
    done

    ${python}/bin/python ${./build-agent.py} \
      "$src/AGENT.md" \
      "$out/codex/agents/${agentName}.toml"
  '';
}
