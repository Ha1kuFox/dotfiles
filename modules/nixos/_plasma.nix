{
	flake,
	lib,
	config,
	pkgs,
	...
}: let
	cfg = config.mods.plasma;
in
	flake.lib.mkMod {
		inherit lib config;
		name = "plasma";

		options = {};

		configs =
			lib.mkIf cfg.enable {
				services = {
					desktopManager.plasma6.enable = true;
					displayManager.sddm.enable = true;
					displayManager.sddm.wayland.enable = true;
				};

				qt = {
					enable = true;
					platformTheme = "kde";
					style = "kvantum";
				};

				environment.systemPackages = with pkgs; [
					kdePackages.kirigami
					kdePackages.qtstyleplugin-kvantum
					libsForQt5.qtstyleplugin-kvantum

					kdePackages.kcalc # Calculator
					kdePackages.kcharselect # Character map
					kdePackages.kclock # Clock app
					kdePackages.kcolorchooser # Color picker
					kdePackages.kolourpaint # Simple paint program
					kdePackages.ksystemlog # System log viewer
					kdePackages.sddm-kcm # SDDM configuration module
					kdiff3 # File/directory comparison tool

					# Hardware/System Utilities (Optional)
					kdePackages.isoimagewriter # Write hybrid ISOs to USB
					kdePackages.partitionmanager # Disk and partition management
					hardinfo2 # System benchmarks and hardware info
					wayland-utils # Wayland diagnostic tools
					wl-clipboard # Wayland copy/paste support
					vlc # Media player

					kdePackages.plasma-systemmonitor
					kdePackages.qqc2-desktop-style # Helps with the QML errors
					kdePackages.plasma-desktop
				];

				home-manager.users.user = {
					programs.plasma = {
						enable = true;
						overrideConfig = true;

						krunner = {
							position = "center";
						};

						panels = [
							{
								location = "top";
								height = 24;
								widgets = [
									# {
									#   kickoff = {
									#     sortAlphabetically = true;
									#     icon = "nix-snowflake-white";
									#   };
									# }
									# "org.kde.plasma.icontasks"
									# "org.kde.plasma.marginsseparator"
									# "org.kde.plasma.systemtray"
									"org.kde.plasma.digitalclock"
								];
							}
						];

						hotkeys.commands = {
							launch-konsole = {
								name = "Launch konsole";
								key = "Meta+K";
								command = "konsole";
							};
						};
					};
				};
			};
	}
