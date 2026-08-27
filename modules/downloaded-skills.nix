{ pkgs, marketplace, plugin }:

let
  buildSkill = import ./build-skill.nix;

  # Skills fetched from other people's repos. Empty is fine — the aggregate
  # below just becomes an empty tree.
  externalSkills = [
  ];

  fetchSkill = { owner, repo, rev, sha256 }: pkgs.fetchFromGitHub {
    inherit owner repo rev sha256;
  };

  # skillType: "single" = repo root is the skill, "multi" = skills/ subdir with skillNames list
  buildExternalSkillPackages = { owner, repo, rev, sha256, skillType ? "single", skillNames ? [] }:
    let
      src = fetchSkill { inherit owner repo rev sha256; };
    in
    if skillType == "multi" then
      map (name: {
        inherit name;
        drv = buildSkill {
          inherit pkgs;
          skillName = name;
          skillSrc = "${src}/skills/${name}";
        };
      }) skillNames
    else
      [{
        name = repo;
        drv = buildSkill {
          inherit pkgs;
          skillName = repo;
          skillSrc = src;
        };
      }];

  allExternalSkills = builtins.concatLists (map buildExternalSkillPackages externalSkills);

  individualSkills = builtins.listToAttrs (
    map (s: { name = s.name; value = s.drv; }) allExternalSkills
  );

  aggregate = pkgs.symlinkJoin {
    name = "downloaded-skills";
    paths = map (s: s.drv) allExternalSkills;
  };
in
{
  inherit aggregate individualSkills;
}
