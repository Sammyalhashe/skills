{ marketplace, plugin, skillsFlake }:
{ pkgs, lib, config, ... }:

let
  cfg = config.ai-skills;
  system = pkgs.stdenv.hostPlatform.system;
  composeSkills = import ./compose-skills.nix { inherit pkgs; };

  effectivePackage =
    if cfg.selectedSkills == [] && cfg.selectedAgents == [] then
      cfg.package
    else
      composeSkills {
        skills = cfg.selectedSkills;
        agents = cfg.selectedAgents;
        rules = cfg.rules;
        name = "ai-skills-selected";
      };
in
{
  options = {
    ai-skills.enable = lib.mkEnableOption "Install AI skills and agents";

    ai-skills.package = lib.mkOption {
      type = lib.types.package;
      default = skillsFlake.packages.${system}.ai-skills;
      description = "The full AI skills package (used when no selections are made)";
    };

    ai-skills.selectedSkills = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = ''
        List of individual skill packages to install. When non-empty,
        composes only these skills into the output instead of the full package.
      '';
    };

    ai-skills.selectedAgents = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = ''
        List of individual agent persona packages to install. When non-empty
        (along with selectedSkills), composes only these into the output.
      '';
    };

    ai-skills.rules = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = skillsFlake.packages.${system}.rules;
      description = "Rules package to include in the composed bundle.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".claude/skills" = {
      source = "${effectivePackage}/claude";
      recursive = true;
    };
  };
}
