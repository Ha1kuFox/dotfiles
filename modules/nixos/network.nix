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
			systemd.services.force-forwarding =
				lib.mkIf cfg.netgate {
					description = "Force IP forwarding enabled after v2rayA initialization";
					after = ["network.target" "v2raya.service"];
					wantedBy = ["multi-user.target"];
					serviceConfig = {
						Type = "oneshot";
						ExecStart = "${pkgs.bash}/bin/sh -c 'sleep 10; ${pkgs.procps}/bin/sysctl -w net.ipv4.ip_forward=1'";
					};
				};
			boot.kernel.sysctl =
				lib.mkIf cfg.netgate {
					"net.ipv4.ip_forward" = 1;
					"net.ipv6.conf.all.forwarding" = 1;
				};

			services = {
				v2raya = {
					enable = cfg.bypass;
					cliPackage = pkgs.xray;
				};

				avahi =
					lib.mkIf cfg.netgate {
						enable = true;
						nssmdns4 = true;
						openFirewall = true;
						reflector = true;
						publish = {
							enable = true;
							addresses = true;
							workstation = true;
						};
					};

				dnsmasq =
					lib.mkIf cfg.netgate {
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
					};
			};
			environment.systemPackages = [
				inputs.flclashx.packages.${pkgs.system}.default
			];
			networking = {
				inherit (cfg) hostName;
				networkmanager = {
					enable = true;
					unmanaged = lib.mkIf cfg.netgate ["enp5s0"];
				};
				firewall =
					lib.mkIf cfg.netgate {
						enable = true;
						checkReversePath = "loose";
						trustedInterfaces = ["enp5s0"];
						interfaces."enp5s0" = {
							allowedTCPPorts = [53 67 68 22 27040];
							allowedUDPPorts = [53 67 68 27031 27032 27033 27034 27035 27036];
						};
					};
				nat =
					lib.mkIf cfg.netgate {
						enable = true;
						externalInterface = "wlp4s0";
						internalInterfaces = ["enp5s0"];
					};
				interfaces."enp5s0".ipv4.addresses =
					lib.mkIf cfg.netgate [
						{
							address = "10.0.0.1";
							prefixLength = 24;
						}
					];
			};
		};
	}
