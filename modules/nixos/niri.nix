{
	flake,
	inputs,
	lib,
	pkgs,
	config,
	...
}: let
	cfg = config.mods.niri;
	monitorSubmodule = _: {
		options = {
			enable = lib.mkEnableOption "Enable this output" // {default = true;};
			mode =
				lib.mkOption {
					type =
						lib.types.nullOr (lib.types.submodule {
								options = {
									width = lib.mkOption {type = lib.types.ints.positive;};
									height = lib.mkOption {type = lib.types.ints.positive;};
									refresh = lib.mkOption {type = lib.types.numbers.positive;};
								};
							});
					default = null;
					description = "Resolution and refresh rate.";
				};
			scale =
				lib.mkOption {
					type = lib.types.nullOr lib.types.float;
					default = null;
				};
			position =
				lib.mkOption {
					type =
						lib.types.nullOr (lib.types.submodule {
								options = {
									x = lib.mkOption {type = lib.types.int;};
									y = lib.mkOption {type = lib.types.int;};
								};
							});
					default = null;
				};
			transform =
				lib.mkOption {
					type = lib.types.nullOr (lib.types.enum ["normal" "90" "180" "270" "flipped" "flipped-90" "flipped-180" "flipped-270"]);
					default = null;
				};
			variableRefreshRate =
				lib.mkOption {
					type = lib.types.nullOr lib.types.bool;
					default = null;
				};
			backgroundColor =
				lib.mkOption {
					type = lib.types.nullOr lib.types.str;
					default = null;
				};
		};
	};
in
	flake.lib.mkMod {
		inherit lib config;
		name = "niri";

		options = {
			monitorConfig =
				lib.mkOption {
					type = lib.types.attrsOf (lib.types.submodule monitorSubmodule);
					default = {};
					description = "Configuration for monitors, referencing niri `outputs` block.";
				};
		};

		configs = {
			programs.niri = {
				enable = true;
				package = pkgs.niri-unstable;
			};
			nixpkgs.overlays = [inputs.niri.overlays.niri];
		};

		home = {
			imports = [
				inputs.niri.homeModules.niri
			];

			gtk.iconTheme = {
				package = pkgs.papirus-icon-theme;
				name = "Papirus";
			};

			home.sessionVariables = {
				XDG_CURRENT_DESKTOP = "Niri";
				XDG_SESSION_DESKTOP = "Niri";
				XDG_SESSION_TYPE = "wayland";

				MOZ_ENABLE_WAYLAND = "1";
				ANKI_WAYLAND = "1";
				NIXOS_OZONE_WL = "1";

				QT_AUTO_SCREEN_SCALE_FACTOR = "1";
				QT_QPA_PLATFORM = "wayland;xcb";
				QT_QPA_PLATFORMTHEME = "gtk3";
				QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

				ELECTRON_OZONE_PLATFORM_HINT = "auto";

				WLR_NO_HARDWARE_CURSORS = "1";
				SDL_VIDEODRIVER = "wayland";
				CLUTTER_BACKEND = "wayland";

				PROTON_USE_WINED3D = "0";
				PROTON_NO_FSYNC = "1";

				DIRENV_LOG_FORMAT = "";
			};

			home.packages = with pkgs; [
				ghostty
				cups
				yazi
				brightnessctl
				playerctl
				xwayland-satellite
				papirus-icon-theme
				onagre
			];

			programs = {
				niri = {
					enable = true;
					settings = {
						prefer-no-csd = true;
						outputs = let
							filterOutput = value:
								lib.filterAttrs (k: v: v != null && k != "enable") value;
						in
							lib.mapAttrs (_: filterOutput) (
								lib.filterAttrs (_: value: value.enable) cfg.monitorConfig
							);
						cursor = {
							hide-when-typing = true;
							hide-after-inactive-ms = 1000;
						};

						hotkey-overlay = {
							skip-at-startup = true;
						};

						layout = {
							gaps = 12;
							default-column-width = {proportion = 0.5;};
						};

						input = {
							keyboard = {
								xkb = {
									layout = "us,ru";
									options = "grp:alt_shift_toggle";
								};
								repeat-delay = 300;
								repeat-rate = 50;
							};
						};

						binds = let
							workspaceBinds =
								builtins.listToAttrs (
									builtins.concatLists (
										builtins.genList (
											i: let
												ws = i + 1;
											in [
												{
													name = "Super+${toString ws}";
													value = {action.focus-workspace = ws;};
												}
												{
													name = "Super+Shift+${toString ws}";
													value = {action.move-window-to-workspace = ws;};
												}
											]
										)
										9
									)
								);
						in
							{
								"Super+T" = {action.spawn = ["ghostty"];};
								"Super+E" = {action.spawn = ["ghostty" "-e" "yazi"];};
								"Super+Space" = {action.spawn = ["onagre"];};

								"Super+C" = {action."close-window" = [];};

								"Super+V" = {action."toggle-window-floating" = [];};
								"Super+Shift+F" = {action."fullscreen-window" = [];};

								"Super+H" = {action."focus-column-left" = [];};
								"Super+J" = {action."focus-window-down" = [];};
								"Super+K" = {action."focus-window-up" = [];};
								"Super+L" = {action."focus-column-right" = [];};

								"Super+Left" = {action."focus-column-left" = [];};
								"Super+Down" = {action."focus-window-down" = [];};
								"Super+Up" = {action."focus-window-up" = [];};
								"Super+Right" = {action."focus-column-right" = [];};

								"Super+Shift+H" = {action."move-column-left" = [];};
								"Super+Shift+J" = {action."move-window-down" = [];};
								"Super+Shift+K" = {action."move-window-up" = [];};
								"Super+Shift+L" = {action."move-column-right" = [];};

								"XF86MonBrightnessUp" = {action.spawn = ["brightnessctl" "set" "5%+"];};
								"XF86MonBrightnessDown" = {action.spawn = ["brightnessctl" "set" "5%-"];};

								"XF86AudioMute" = {action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];};
								"XF86AudioRaiseVolume" = {action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.5+"];};
								"XF86AudioLowerVolume" = {action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.5-"];};

								"XF86AudioPlay" = {action.spawn = ["playerctl" "play-pause"];};
								"XF86AudioPause" = {action.spawn = ["playerctl" "play-pause"];};
								"XF86AudioNext" = {action.spawn = ["playerctl" "next"];};
								"XF86AudioPrev" = {action.spawn = ["playerctl" "previous"];};
								"XF86AudioStop" = {action.spawn = ["playerctl" "stop"];};
							}
							// workspaceBinds;
					};
					package = pkgs.niri-unstable;
				};
			};
		};
	}
