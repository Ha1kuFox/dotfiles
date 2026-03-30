{
	flake,
	lib,
	config,
	pkgs,
	...
}: let
	cfg = config.mods.gammastep;
in
	flake.lib.mkMod {
		inherit lib config;
		name = "gammastep";

		options = {
			latitude =
				lib.mkOption {
					type = lib.types.str;
					default = "55.75";
					description = "Широта для Gammastep";
				};
			longitude =
				lib.mkOption {
					type = lib.types.str;
					default = "37.61";
					description = "Долгота для Gammastep";
				};
		};

		configs = {
			environment.systemPackages = with pkgs; [
				gammastep
			];
		};

		home = {
			services.gammastep = {
				enable = true;
				provider = "manual";

				inherit (cfg) latitude;
				inherit (cfg) longitude;

				temperature = {
					day = 6500;
					night = 3500;
				};

				settings = {
					general = {
						adjustment-method = "wayland";
						fade = 1;
					};
				};
			};
		};
	}
