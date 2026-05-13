{ pkgs, src, marketplace, plugin }:

let
  buildSkill = import ./build-skill.nix;
  buildAgent = import ./build-agent.nix;
  buildRules = import ./build-rules.nix;
  composeSkills = import ./compose-skills.nix { inherit pkgs; };

  skillNames = builtins.attrNames (
    pkgs.lib.filterAttrs (_: type: type == "directory")
      (builtins.readDir "${src}/skills")
  );

  agentNames = builtins.attrNames (
    pkgs.lib.filterAttrs (_: type: type == "directory")
      (builtins.readDir "${src}/agents")
  );

  individualSkills = map (name:
    buildSkill {
      inherit pkgs;
      skillName = name;
      skillSrc = "${src}/skills/${name}";
    }
  ) skillNames;

  individualAgents = map (name:
    buildAgent {
      inherit pkgs;
      agentName = name;
      agentSrc = "${src}/agents/${name}";
    }
  ) agentNames;

  rules = buildRules {
    inherit pkgs;
    rulesSrc = "${src}/rules";
  };
in
composeSkills {
  skills = individualSkills;
  agents = individualAgents;
  inherit rules;
  binSrc = "${src}/bin";
  hooksSrc = "${src}/hooks";
  name = "ai-skills";
}
