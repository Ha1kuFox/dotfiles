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
    hostName = flake.lib.mkStr lib "nixos" "The hostname of the machine";
    bypass = flake.lib.mkBool lib true "Add v2raya vpn with xray and zapret with simple config";
  };

  configs = {
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
