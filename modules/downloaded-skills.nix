{ pkgs, marketplace, plugin }:

let
  buildSkill = import ./build-skill.nix;

  # Skills fetched from other people's repos. Empty is fine — the aggregate
  # below just becomes an empty tree.
  externalSkills = [
    {
      owner = "janestreet";
      repo = "agent_skills";
      rev = "469868f4489cbdbe178c775a0af05bb6bef63689";
      sha256 = "sha256-EuYu0C7d2T4Y3RlsTm5/22jZcCrrTPpdnGhcx7SOOeM=";
      skillType = "multi";
      skillsDir = ".";
      skillNames = [ "socratic-tutor" ];
    }
  ];

  fetchSkill = { owner, repo, rev, sha256 }: pkgs.fetchFromGitHub {
    inherit owner repo rev sha256;
  };

  # skillType: "single" = repo root is the skill, "multi" = skillsDir subdir with skillNames list
  buildExternalSkillPackages = { owner, repo, rev, sha256, skillType ? "single", skillNames ? [], skillsDir ? "skills" }:
    let
      src = fetchSkill { inherit owner repo rev sha256; };
    in
    if skillType == "multi" then
      map (name: {
        inherit name;
        drv = buildSkill {
          inherit pkgs;
          skillName = name;
          skillSrc = "${src}/${skillsDir}/${name}";
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
