{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mods.network;
in
flake.lib.mkMod {
  inherit lib config;
  name = "network";

  options = {
    hostName = flake.lib.mkStr lib "nixos" "Имя хоста";
    bypass = flake.lib.mkBool lib true "ВПН";
  };

  configs = lib.mkIf cfg.enable {
    services.v2raya = {
      enable = cfg.bypass;
      cliPackage = pkgs.xray;
    };
    networking = {
      inherit (cfg) hostName;
      networkmanager.enable = true;
    };
  };
}
