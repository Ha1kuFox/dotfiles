{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mods.user;
in
flake.lib.mkMod {
  inherit lib config;
  name = "user";

  options = {
    name = flake.lib.mkStr lib "user" "Имя пользователя";
    description = flake.lib.mkStr lib cfg.name "Отображаемое имя";
  };

  configs = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) description;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.fish;

      initialPassword = "1234"; # TODO: Make passw safe
    };
  };
}
