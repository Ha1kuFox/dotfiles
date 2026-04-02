{
	flake,
	lib,
	config,
	pkgs,
	inputs,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "hyprland";

	options = {};

	configs = {
		environment.systemPackages = with pkgs; [
			wezterm
			pavucontrol
			brightnessctl
			wayland-utils
			wayland-protocols
			jq

			sunsetr
		];
		programs.hyprland = {
			enable = true;
			package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
			portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
		};
	};

	home = {
		imports = [
			inputs.hyprland.homeManagerModules.default
		];

		programs.caelestia = {
			enable = true;
			systemd = {
				enable = true;
				target = "graphical-session.target";
				environment = [];
			};
			settings = {
				background.enabled = true;
				paths.wallpaperDir = "~/Wallpapers";
				bar = {
					status = {
						showBattery = false;
					};
					clock.showIcon = false;
					popouts.activeWindow = false;
					persistent = true;
					workspaces = {
						activeIndicator = true;
						activeTrail = false;
						occupiedBg = true;
						rounded = true;
						showWindows = false;
						shown = 5;
					};
				};
				appearance = {
					font.family = {
						clock = "monocraft";
						mono = "monocraft";
						sans = "monocraft";
					};
					rounding.scale = 0;
					transparency.enabled = false;
				};
				general = {
					apps = {
						terminal = ["wezterm"];
						audio = ["pavucontrol"];
						explorer = ["nautilus"];
					};
					idle = {
						timeouts = [];
					};
				};
				bar.border.rounding = 0;
			};
			cli = {
				enable = true;
				settings.theme = {
					enableTerm = false;
					enableDiscord = false;
					enableSpicetify = false;
					enableBtop = false;
					enableCava = false;
					enableHypr = false;
					enableGtk = false;
					enableQt = false;
				};
			};
		};

		services.cliphist = {
			enable = true;
			allowImages = true;
		};

		wayland.windowManager.hyprland = {
			enable = true;
			xwayland.enable = true;

			package = null;
			portalPackage = null;

			# https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
			systemd.variables = ["--all"];

			plugins = [
				# inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
			];

			settings = {
				exec-once = [
					"sunsetr"
				];
				general = {
					resize_on_border = true;
					gaps_in = 5;
					gaps_out = 10;
					border_size = 2;
					layout = "master";
				};

				master = {
					new_status = true;
					allow_small_split = true;
					mfact = 0.5;
				};

				decoration = {
					rounding = 0;
				};

				bind =
					[
						"SUPER, T, exec, wezterm"
						"SUPER, E, exec, nautilus"
						"SUPER, SPACE, global, caelestia:launcher"
						"SUPER SHIFT, G, exec, godot"

						# VIM motions
						"SUPER, H, movefocus, l" # Move focus left
						"SUPER, J, movefocus, d" # Move focus Down
						"SUPER, K, movefocus, u" # Move focus Up
						"SUPER, L, movefocus, r" # Move focus Rightzzz

						# Default motions
						"SUPER, left, movefocus, l" # Move focus left
						"SUPER, down, movefocus, d" # Move focus Down
						"SUPER, up, movefocus, u" # Move focus Up
						"SUPER, right, movefocus, r" # Move focus Right

						"SUPER, Tab, exec, hyprctl keyword general:layout $(hyprctl getoption general:layout -j | jq -r '.str' | grep -q 'master' && echo 'scrolling' || echo 'master')"

						"SUPER, period, layoutmsg, focus r"
						"SUPER, comma, layoutmsg, focus l"

						"SUPER SHIFT, period, layoutmsg, swapcol r"
						"SUPER SHIFT, comma, layoutmsg, swapcol l"

						"SUPER, C, killactive,"
					]
					++ (builtins.concatLists (
							builtins.genList (
								i: let
									ws = i + 1;
								in [
									"SUPER,code:1${toString i}, workspace, ${toString ws}"
									"SUPER SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
								]
							)
							9
						));

				bindm = [
					"SUPER,mouse:272, movewindow"
					"SUPER,R, resizewindow"
				];

				bindl = [
					# Brightness
					", XF86MonBrightnessUp, global, caelestia:brightnessUp"
					", XF86MonBrightnessDown, global, caelestia:brightnessDown"

					# Media
					", XF86AudioPlay, global, caelestia:mediaToggle"
					", XF86AudioPause, global, caelestia:mediaToggle"
					", XF86AudioNext, global, caelestia:mediaNext"
					", XF86AudioPrev, global, caelestia:mediaPrev"
					", XF86AudioStop, global, caelestia:mediaStop"

					# Sound
					", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
					", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
					", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				];

				env = [
					"XDG_CURRENT_DESKTOP,Hyprland"
					"MOZ_ENABLE_WAYLAND,1"
					"ANKI_WAYLAND,1"
					"DISABLE_QT5_COMPAT,0"
					"NIXOS_OZONE_WL,1"
					"XDG_SESSION_TYPE,wayland"
					"XDG_SESSION_DESKTOP,Hyprland"
					"QT_AUTO_SCREEN_SCALE_FACTOR,1"
					"QT_QPA_PLATFORM,wayland;xcb"
					"QT_QPA_PLATFORMTHEME,gtk3"
					"QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
					"ELECTRON_OZONE_PLATFORM_HINT,auto"
					"__GL_GSYNC_ALLOWED,0"
					"__GL_VRR_ALLOWED,0"
					"DIRENV_LOG_FORMAT,"
					#"WLR_DRM_NO_ATOMIC,1"
					#"WLR_BACKEND,vulkan"
					#"WLR_RENDERER,vulkan"
					"WLR_NO_HARDWARE_CURSORS,1"
					"SDL_VIDEODRIVER,wayland"
					"CLUTTER_BACKEND,wayland"
				];

				cursor = {
					no_hardware_cursors = true;
				};

				misc = {
					vfr = false; # What is this
					disable_hyprland_logo = true;
					disable_splash_rendering = true;
					disable_autoreload = true;
					focus_on_activate = true;
				};

				input = {
					kb_layout = "us,ru";

					kb_options = "grp:alt_shift_toggle";
					follow_mouse = 1;
					repeat_delay = 300;
					repeat_rate = 50;
				};

				animations = {
					enabled = true;
					bezier = [
						"linear, 0, 0, 1, 1"
						"md3_standard, 0.2, 0, 0, 1"
						"md3_decel, 0.05, 0.7, 0.1, 1"
						"md3_accel, 0.3, 0, 0.8, 0.15"
						"overshot, 0.05, 0.9, 0.1, 1.1"
						"crazyshot, 0.1, 1.5, 0.76, 0.92"
						"hyprnostretch, 0.05, 0.9, 0.1, 1.0"
						"menu_decel, 0.1, 1, 0, 1"
						"menu_accel, 0.38, 0.04, 1, 0.07"
						"easeInOutCirc, 0.85, 0, 0.15, 1"
						"easeOutCirc, 0, 0.55, 0.45, 1"
						"easeOutExpo, 0.16, 1, 0.3, 1"
						"softAcDecel, 0.26, 0.26, 0.15, 1"
						"md2, 0.4, 0, 0.2, 1"
					];

					animation = [
						"windows, 1, 2.5, md3_decel, popin 60%"
						"windowsIn, 1, 2.5, md3_decel, popin 60%"
						"windowsOut, 1, 2.5, md3_accel, popin 60%"
						"border, 1, 6, default"
						"fade, 1, 2.5, md3_decel"
						"layersIn, 1, 2.5, menu_decel, slide"
						"layersOut, 1, 2.5, menu_accel"
						"fadeLayersIn, 1, 2.5, menu_decel"
						"fadeLayersOut, 1, 2.5, menu_accel"
						"workspaces, 1, 2.5, menu_decel, slide"
						"specialWorkspace, 1, 2.5, md3_decel, slidevert"
					];
				};

				monitor = ",1920x1080@100,auto,1";
			};
		};
	};
}
