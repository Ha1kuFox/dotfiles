{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.catppuccin;
in
flake.lib.mkMod {
  inherit lib config;
  name = "catppuccin";

  options = { };

  configs = lib.mkIf cfg.enable {
    home-manager.users.${config.mods.user.name} = {
      catppuccin = {
        enable = true;
        accent = "peach";
      };
    };
  };
}
