{
  flake,
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.mods.gaming;
  hytalePkg = inputs.hytale.packages.${pkgs.system}.default;
in
flake.lib.mkMod {
  inherit lib config;
  name = "gaming";

  options = {
    steam = flake.lib.mkBool lib true "Вкл. Steam";
    minecraft = flake.lib.mkBool lib true "Вкл. Minecraft";
    hytale = flake.lib.mkBool lib true "Вкл. Hytale";
  };

  configs = lib.mkIf cfg.enable {
    programs.steam = lib.mkIf cfg.steam {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    environment.systemPackages = lib.flatten [
      (lib.optional cfg.minecraft (
        pkgs.prismlauncher.override {
          jdks = [
            pkgs.temurin-bin-8
            pkgs.temurin-bin-17
            pkgs.temurin-bin-21
          ];
        }
      ))

      (lib.optional cfg.hytale hytalePkg)

      (lib.optional cfg.steam pkgs.r2modman)
    ];
  };
}
