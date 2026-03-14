{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  # theme = {
  #   base00 = "000000";
  #   base01 = "1a1a1a";
  #   base02 = "2d2d2d";
  #   base03 = "4d4d4d";
  #   base04 = "95a5a6";
  #   base05 = "e0e0e0";
  #   base06 = "f5f5f5";
  #   base07 = "ffffff";
  #   base08 = "d35400";
  #   base09 = "e67e22";
  #   base0A = "f39c12";
  #   base0B = "a04000";
  #   base0C = "7f8c8d";
  #   base0D = "ff8c00";
  #   base0E = "cf4a30";
  #   base0F = "5d4037";
  # };
  theme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
in
flake.lib.mkMod {
  inherit lib config;
  name = "theming";

  options = { };

  home = {
    stylix = {
      enable = true;
      base16Scheme = theme;
      polarity = "dark";

      fonts = {
        serif = {
          package = pkgs.monocraft;
          name = "monocraft";
        };

        sansSerif = {
          package = pkgs.monocraft;
          name = "monocraft";
        };

        monospace = {
          package = pkgs.monocraft;
          name = "monocraft";
        };
      };

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
}
