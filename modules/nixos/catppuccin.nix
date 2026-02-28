{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.catppuccin;
  theme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  wallpaper = pkgs.runCommand "image.png" { } ''
    COLOR=$(${lib.getExe pkgs.yq} -r .palette.base00 ${theme})
    ${lib.getExe pkgs.imagemagick} -size 1920x1080 xc:$COLOR $out
  '';
in
flake.lib.mkMod {
  inherit lib config;
  name = "catppuccin";

  options = { };

  configs = lib.mkIf cfg.enable {
    home-manager.users.${config.mods.user.name} = {
      stylix = {
        enable = true;
        base16Scheme = theme;
        image = wallpaper;

        cursor = {
          package = pkgs.catppuccin-cursors.mochaDark;
          name = "catppuccin-mocha-dark-cursors";
          size = 24;
        };
        icons = {
          enable = true;
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "peach";
          };
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };
      };
    };
  };
}
