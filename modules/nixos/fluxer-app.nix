{
  lib,
  config,
  flake,
  ...
}:

let
  cfg = config.mods.fluxer;
in
flake.lib.mkMod {
  inherit lib config;
  name = "fluxer";

  options = { };

  configs = {
    virtualisation.docker.enable = cfg.enable;
    virtualisation.oci-containers.containers."fluxer" = cfg.enable {
      image = "ghcr.io/fluxerapp/fluxer:latest";
      ports = [ "3000:3000" ];
      volumes = [
        "/var/lib/fluxer/data:/app/data" # Persist chats/files here
      ];
      environment = {
        DATABASE_URL = "sqlite:///app/data/fluxer.db"; # Simplest for local work
      };
    };
  };
}
