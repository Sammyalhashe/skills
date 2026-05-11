{ pkgs, marketplace, plugin }:
let
  # Add external GitHub skill repositories here
  externalSkills = [
    # Example: { owner = "someone"; repo = "cool-skill"; rev = "..."; sha256 = "..."; }
  ];

  fetchSkill = { owner, repo, rev, sha256 }: pkgs.fetchFromGitHub {
    inherit owner repo rev sha256;
  };

  downloadedPaths = map fetchSkill externalSkills;
in
pkgs.stdenvNoCC.mkDerivation {
  name = "downloaded-skills";
  
  # This derivation doesn't have a single source, it aggregates fetched ones
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/claude
    mkdir -p $out/gemini
    mkdir -p $out/openai

    ${pkgs.lib.concatStringsSep "\n" (map (path: ''
      # Copy skills from each downloaded repo
      if [ -d "${path}/skills" ]; then
        cp -r ${path}/skills/* $out/claude/ 2>/dev/null || true
        cp -r ${path}/skills/* $out/gemini/ 2>/dev/null || true
        cp -r ${path}/skills/* $out/openai/ 2>/dev/null || true
      elif [ -f "${path}/SKILL.md" ]; then
        # If the repo itself is a single skill
        skillName=$(basename ${path})
        mkdir -p $out/claude/$skillName $out/gemini/$skillName $out/openai/$skillName
        cp -r ${path}/* $out/claude/$skillName/
        cp -r ${path}/* $out/gemini/$skillName/
        cp -r ${path}/* $out/openai/$skillName/
      fi
    '') downloadedPaths)}
  '';
}
