{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mods.cinny;
in
flake.lib.mkMod {
  inherit lib config;
  name = "cinny";

  options = {
    domain = flake.lib.mkStr lib "localhost" "Домен для клиента";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Порт клиента";
    };
  };

  configs = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.cinny = {
      image = "ajbura/cinny:latest";
      ports = [ "${toString cfg.port}:80" ];
      environment = {
        # IDK
      };
      volumes = [
        # Если хотим сохранять конфиг, пока тестим
      ];
    };

    # systemd-сервис для запуска при старте пк
    systemd.services.cinny = {
      description = "Cinny Matrix Client";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.docker}/bin/docker run --rm -p ${toString cfg.port}:80 ajbura/cinny:latest";
        Restart = "always";
        RestartSec = 5;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [ cfg.port ];
  };
}
