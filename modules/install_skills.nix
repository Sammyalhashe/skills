{ pkgs, src, marketplace, plugin }:

let
  buildSkill = import ./build-skill.nix;
  buildRules = import ./build-rules.nix;
  composeSkills = import ./compose-skills.nix { inherit pkgs; };

  skillNames = builtins.attrNames (
    pkgs.lib.filterAttrs (_: type: type == "directory")
      (builtins.readDir "${src}/skills")
  );

  individualSkills = map (name:
    buildSkill {
      inherit pkgs;
      skillName = name;
      skillSrc = "${src}/skills/${name}";
    }
  ) skillNames;

  rules = buildRules {
    inherit pkgs;
    rulesSrc = "${src}/rules";
  };
in
composeSkills {
  skills = individualSkills;
  inherit rules;
  binSrc = "${src}/bin";
  hooksSrc = "${src}/hooks";
  name = "ai-skills";
}
