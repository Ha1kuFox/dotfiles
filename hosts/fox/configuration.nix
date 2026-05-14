{
	flake,
	pkgs,
	...
}: {
	imports =
		[
			./hardware-configuration.nix
		]
		++ builtins.attrValues flake.nixosModules;

	config.mods = {
		godot.enable = true;
		# lemurs.enable = true;
		autologin.enable = true;
		codeTools.enable = true;
		fonts.enable = true;
		niri = {
			enable = true;
			monitorConfig = {
				"HDMI-A-1" = {
					mode = {
						width = 1920;
						height = 1080;
						refresh = 100.0;
					};
				};
			};
		};
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
				flakePath = "/home/user/.config/dotfiles";
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
			godsvg
			activitywatch
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
