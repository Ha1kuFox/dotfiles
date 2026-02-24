{
  flake,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.network;
in
flake.lib.mkMod {
  inherit lib config;
  name = "tailscale";

  options = { };

  configs = {
    services.tailscale = {
      enable = cfg.enable;
      openFirewall = true;
    };
    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [
        41641
        22555
        25569
        25565
        21116
        3000 # For fluxer
      ];
      checkReversePath = "loose";
    };
  };
}
