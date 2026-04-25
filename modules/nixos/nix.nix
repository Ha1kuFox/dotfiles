{
  flake,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.mods.nix;
in
  flake.lib.mkMod {
    inherit lib config;
    name = "nix";

    options = {
      automaticGC = flake.lib.mkBool lib true "Автоматическая сборка мусора, лучше использовать helpers";
      helpers = lib.mkOption {
        default = {};
        type = lib.types.submodule {
          options = {
            enable = flake.lib.mkBool lib false "Доп. утилиты для nix";
            flakePath = flake.lib.mkStr lib "/home/user/dotfiles" "Путь к папке с flake";
          };
        };
      };
    };

    configs = lib.mkMerge [
      {
        nixpkgs.config.allowUnfree = true;
        nix = {
          settings = {
            warn-dirty = false;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            auto-optimise-store = true;
          };
        };
      }
      (lib.mkIf cfg.helpers.enable {
        environment.sessionVariables.FLAKE = cfg.helpers.flakePath;
        environment.systemPackages = with pkgs; [
          nix-output-monitor
          nix-index
        ];
        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 10";
          flake = cfg.helpers.flakePath;
        };
      })
    ];
  }
