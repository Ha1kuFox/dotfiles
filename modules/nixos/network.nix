{
  flake,
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.mods.network;
in
  flake.lib.mkMod {
    inherit lib config;
    name = "network";

    options = {
      hostName = flake.lib.mkStr lib "nixos" "Имя хоста";
      bypass = flake.lib.mkBool lib true "ВПН";
      netgate = flake.lib.mkBool lib false "Мост от одного пк к другому";
    };

    configs = {
      systemd.services.force-forwarding = lib.mkIf cfg.netgate {
        description = "Force IP forwarding enabled after v2rayA initialization";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/sh -c 'sleep 10; ${pkgs.procps}/bin/sysctl -w net.ipv4.ip_forward=1'";
        };
      };
      boot.kernel.sysctl =
        if cfg.netgate
        then {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
        }
        else {};

      services = {
        avahi =
          if cfg.netgate
          then {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
            reflector = true;
            publish = {
              enable = true;
              addresses = true;
              workstation = true;
            };
          }
          else {enable = false;};

        dnsmasq =
          if cfg.netgate
          then {
            enable = true;
            settings = {
              interface = "enp5s0";
              bind-interfaces = true;
              dhcp-host = "d8:43:ae:42:95:5b,10.0.0.2,deer";
              dhcp-range = "10.0.0.2,10.0.0.20,24h";
              dhcp-option = ["3,10.0.0.1" "6,8.8.8.8,1.1.1.1"];
              domain-needed = true;
              bogus-priv = true;
              expand-hosts = true;
              local = "/lan/";
              domain = "lan";
            };
          }
          else {enable = false;};
      };
      environment.systemPackages = [
        inputs.flclashx.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      networking = {
        inherit (cfg) hostName;
        networkmanager = {
          enable = true;
          unmanaged =
            if cfg.netgate
            then ["enp5s0"]
            else [];
        };
        firewall = lib.mkIf cfg.netgate {
          enable = true;
          checkReversePath = "loose";
          trustedInterfaces =
            if cfg.netgate
            then ["enp5s0"]
            else [];
          interfaces."enp5s0" = {
            allowedTCPPorts = [53 67 68 22 27040];
            allowedUDPPorts = [53 67 68 27031 27032 27033 27034 27035 27036];
          };
        };
        nat =
          if cfg.netgate
          then {
            enable = true;
            externalInterface = "wlp4s0";
            internalInterfaces = ["enp5s0"];
          }
          else {enable = false;};
        interfaces = lib.mkIf cfg.netgate {
          "enp5s0".ipv4.addresses = [
            {
              address = "10.0.0.1";
              prefixLength = 24;
            }
          ];
        };
      };
    };
  }
