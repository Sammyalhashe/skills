{ pkgs, marketplace, plugin }:

let
  buildSkill = import ./build-skill.nix;

  externalSkills = [
    { owner = "juliusbrussee"; repo = "caveman"; rev = "main"; sha256 = "14i2vxkddimy7kvwpfa3bbd3q59asgjbb9mm2d67r8pr0bwccq7x"; skillType = "single"; }
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
