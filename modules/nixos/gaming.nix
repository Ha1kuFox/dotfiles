{
	flake,
	lib,
	pkgs,
	config,
	#inputs,
	...
}: let
	cfg = config.mods.gaming;
in
	flake.lib.mkMod {
		inherit lib config;
		name = "gaming";

		options = {
			steam =
				flake.lib.mkSubm lib {
					enable = flake.lib.mkBool lib true "Вкл. Steam";
					deckMode = flake.lib.mkBool lib false "Вкл. DeckMode";
					piracy = flake.lib.mkBool lib false "Программы для пиратства";
				};
			minecraft = flake.lib.mkBool lib false "Вкл. Minecraft";
		};

		configs = {
			programs.steam =
				lib.mkIf cfg.steam.enable {
					enable = true;
					remotePlay.openFirewall = true;
					dedicatedServer.openFirewall = true;
					extraCompatPackages = [pkgs.proton-ge-bin];

					package =
						lib.mkIf cfg.steam.deckMode (
							pkgs.steam.override {
								extraPkgs = pkgs':
									with pkgs'; [
										libXcursor
										libXi
										libXinerama
										libXScrnSaver
										libpng
										libpulseaudio
										libvorbis
										stdenv.cc.cc.lib # Provides libstdc++.so.6
										libkrb5
										keyutils
										# Add other libraries as needed
									];
							}
						);
					gamescopeSession.enable = lib.mkIf cfg.steam.deckMode true;
				};

			programs.gamescope =
				lib.mkIf cfg.steam.deckMode {
					enable = true;
					capSysNice = true;
				};

			environment.systemPackages =
				lib.flatten [
					(lib.optional cfg.minecraft (
							pkgs.prismlauncher.override {
								jdks = [
									pkgs.temurin-bin-8
									pkgs.temurin-bin-17
									pkgs.temurin-bin-21
								];
							}
						))

					(lib.optional cfg.steam.piracy pkgs.rar)
					(lib.optional cfg.steam.piracy pkgs.qbittorrent)
					(lib.optional cfg.steam.piracy pkgs.winePackages.full)

					(lib.optional cfg.steam.enable pkgs.r2modman)
					(lib.optional cfg.steam.enable pkgs.protonup-qt)
					(lib.optional cfg.steam.enable pkgs.winetricks)
					(lib.optional cfg.steam.enable pkgs.usbutils)
				];
		};
	}
