{
	flake,
	pkgs,
	inputs,
	...
}: {
	imports = [./hardware-configuration.nix] ++ builtins.attrValues flake.nixosModules;

	config.mods = {
		godot.enable = true;
		lemurs.enable = true;
		codeTools.enable = true;
		fonts.enable = true;
		dms.enable = true;
		pointerCursor.enable = true;
		language.enable = true;
		hardware.enable = true;
		user.enable = true;
		boot = {
			enable = true;
			silent = true;
		};
		firefox.enable = true;
		tailscale.enable = true;
		network = {
			enable = true;
			hostName = "fox";
			bypass = true;
			netgate = true;
		};
		git = {
			enable = true;
			userName = "ha1ku";
			email = "darknekodev@yandex.ru";
		};
		nix = {
			enable = true;
			helpers = {
				enable = true;
				flakePath = "/home/user/workspace/nix/dotfiles";
			};
		};
		gaming = {
			enable = true;
			steam = {
				enable = true;
				deckMode = true;
				piracy = true;
			};
			minecraft = true;
		};
	};

	config = {
		services.flatpak.enable = true;

		environment.systemPackages = with pkgs; [
			keepassxc
			ayugram-desktop
			obsidian
			inputs.bookokrat.packages.${system}.default
			#inputs.tgt.packages.${system}.default

			godsvg

			whosthere
			pastel
			netscanner
			hygg
		];

		home-manager = {
			backupFileExtension = "backup";
			overwriteBackup = true;
		};

		nixpkgs.hostPlatform = "x86_64-linux";
		system.stateVersion = "25.05";
	};
}
