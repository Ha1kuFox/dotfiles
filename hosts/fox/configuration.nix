{
	flake,
	pkgs,
	...
}: {
	imports = [./hardware-configuration.nix] ++ builtins.attrValues flake.nixosModules;

	config.mods = {
		#theming.enable = true;

		gnome.enable = true;
		#hyprland.enable = true;
		dms.enable = true;
		pointerCursor.enable = true;

		vscode.enable = true;
		#godot.enable = true;

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
			#hytale = true;
			minecraft = true;
		};
	};

	config = {
		services.flatpak.enable = true;

		environment.systemPackages = with pkgs; [
			keepassxc
			ayugram-desktop
			obsidian

			godsvg
		];

		home-manager = {
			backupFileExtension = "backup";
			overwriteBackup = true;
		};

		nixpkgs.hostPlatform = "x86_64-linux";
		system.stateVersion = "25.05";
	};
}
