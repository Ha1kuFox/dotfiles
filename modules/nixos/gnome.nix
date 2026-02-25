{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.gnome;
  extensions = with pkgs.gnomeExtensions; [
    appindicator
    accent-directories
    window-tricks
    vitals
    luminus-desktop
    dash-to-dock
  ];
in
flake.lib.mkMod {
  inherit lib config;
  name = "gnome";

  options = {
    debloat = flake.lib.mkBool lib true "Убрать стандратные GNOME приложения";
    extensions = flake.lib.mkBool lib true "Вкл. GNOME расширения и темы";
  };

  configs = lib.mkIf cfg.enable {
    services.displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    services.desktopManager.gnome.enable = true;

    home-manager.users.${config.mods.user.name} = lib.mkIf cfg.extensions {
      home.packages =
        extensions
        ++ (with pkgs; [
          morewaita-icon-theme
          bibata-cursors
        ]);
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = map (ext: ext.extensionUuid) extensions;
        };
        "org/gnome/desktop/interface" = {
          "color-scheme" = "prefer-dark";
          "cursor-theme" = "Bibata-Modern-Ice";
          "icon-theme" = "MoreWaita";
        };
      };
      home.pointerCursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 16;
        gtk.enable = true;
        x11.enable = true;
      };
    };
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    environment.systemPackages = with pkgs; [
      gnome-console
      nautilus
      adwaita-icon-theme
    ];

    services.gnome = lib.mkIf cfg.debloat {
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };

    environment.gnome.excludePackages = lib.mkIf cfg.debloat (
      with pkgs;
      [
        gnome-tour
        gnome-user-docs
        epiphany
        geary
        evince
        totem
        cheese
      ]
    );

    services.xserver.excludePackages = lib.mkIf cfg.debloat [ pkgs.xterm ];
    documentation.nixos.enable = lib.mkIf cfg.debloat false;
  };
}
