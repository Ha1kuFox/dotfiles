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
    name = flake.lib.mkStr lib "user" "The default username";
    description = flake.lib.mkStr lib "User" "The user's full name";
  };

  configs = {
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
