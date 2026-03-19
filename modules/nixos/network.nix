{
	flake,
	lib,
	config,
	pkgs,
	# inputs,
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
		};

		configs = {
			services.v2raya = {
				enable = cfg.bypass;
				cliPackage = pkgs.xray;
			};
			# environment.systemPackages = [
			#   inputs.flclashx.packages.${pkgs.system}.default
			# ];
			networking = {
				inherit (cfg) hostName;
				networkmanager.enable = true;
			};
		};
	}
