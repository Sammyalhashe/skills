{ marketplace, plugin }:
{ pkgs, lib, config, ... }:

let
  cfg = config.ai-skills;
in
{
  options = {
    ai-skills.enable = lib.mkEnableOption "Install AI skills and agents";
    ai-skills.package = lib.mkOption {
      type = lib.types.package;
      description = "The AI skills package to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".claude/plugins/marketplaces/${marketplace}" = {
      source = "${cfg.package}/claude";
      recursive = true;
    };
  };
}
