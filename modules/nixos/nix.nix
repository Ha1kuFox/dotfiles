{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mods.nix;
in
flake.lib.mkMod {
  inherit lib config;
  name = "nix";

  options = {
    automaticGC = flake.lib.mkBool lib true "Automatically run garbage collector";
    helpers = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = flake.lib.mkBool lib true "Enable additional utilites for nix";
          flakePath = flake.lib.mkStr lib "/home/user/dotfiles" "Path to the flake directory";
        };
      };
    };
  };

  configs =
    let
      usingNhClean = cfg.helpers.enable && config.programs.nh.clean.enable;
    in
    lib.mkMerge [
      {
        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            auto-optimise-store = true;
          };

          gc = {
            automatic = lib.mkIf (!usingNhClean) cfg.automaticGC;
            dates = "weekly";
            options = "--delete-older-than 4d";
          };
        };
      }
      (lib.mkIf cfg.helpers.enable {
        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 10";
          flake = cfg.helpers.flakePath;
        };

        environment.systemPackages = [ pkgs.nix-output-monitor ];
      })
    ];
}
