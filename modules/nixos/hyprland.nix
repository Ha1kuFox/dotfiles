{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mods.hyprland;
in
flake.lib.mkMod {
  inherit lib config;
  name = "hyprland";

  options = { };

  configs = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;
    environment.systemPackages = with pkgs; [
      wezterm
      pavucontrol
      brightnessctl
      wayland-utils
      wayland-protocols
    ];

    home-manager.users.user = {
      programs.caelestia = {
        enable = true;
        systemd = {
          enable = true;
          target = "graphical-session.target";
          environment = [ ];
        };
        settings = {
          bar.status = {
            showBattery = false;
          };
          general = {
            apps = {
              terminal = [ "wezterm" ];
              audio = [ "pavucontrol" ];
              explorer = [ "nautilus" ];
            };
            idle = {
              timeouts = [ ];
            };
          };
          paths.wallpaperDir = "~/Images";
        };
        cli = {
          enable = true;
        };
      };

      services.cliphist = {
        enable = true;
        allowImages = true;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          exec-once = [
            "swww init"
          ];

          bind = [
            "SUPER, Q, exec, wezterm"
            "SUPER, E, exec, nautilus"
            "SUPER, SPACE, global, caelestia:launcher"

            "SUPER, C, killactive,"
            "SUPER, M, exit,"
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
            "DISABLE_QT5_COMPAT,0"
            "DIRENV_LOG_FORMAT,"
            "WLR_DRM_NO_ATOMIC,1"
            "WLR_BACKEND,vulkan"
            "WLR_RENDERER,vulkan"
            "WLR_NO_HARDWARE_CURSORS,1"
            "SDL_VIDEODRIVER,wayland"
            "CLUTTER_BACKEND,wayland"
          ];

          cursor = {
            no_hardware_cursors = true;
          };

          misc = {
            vfr = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            disable_autoreload = true;
            focus_on_activate = true;
          };

          input = {
            kb_layout = "us,ru";

            kb_options = "caps:escape";
            follow_mouse = 1;
            sensitivity = 0.5;
            repeat_delay = 300;
            repeat_rate = 50;
            numlock_by_default = true;

            touchpad = {
              natural_scroll = true;
              clickfinger_behavior = true;
            };
          };

          monitor = ",preferred,auto,1";
        };
      };
    };
  };
}
