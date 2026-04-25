{
	flake,
	lib,
	config,
	pkgs,
	...
}: let
	cfg = config.mods.user;
in
	flake.lib.mkMod {
		inherit lib config;
		name = "user";

		options = {
			name = flake.lib.mkStr lib "user" "Имя пользователя";
			description = flake.lib.mkStr lib cfg.name "Отображаемое имя";
		};

		configs = {
			programs.fish.enable = true;

			nix.settings.trusted-users = ["root" "@wheel" cfg.name];
			users.users.${cfg.name} = {
				isNormalUser = true;
				inherit (cfg) description;
				extraGroups = [
					"networkmanager"
					"wheel"
					"seat"
				];
				shell = pkgs.fish;
			};
		};
	}
