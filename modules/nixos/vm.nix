{
  flake,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.vm;
in
flake.lib.mkMod {
  inherit lib config;
  name = "vm";

  options = {
    host = flake.lib.mkStr lib "nixos" "Имя хоста под который будем собирать";
    memory = flake.lib.mkStr lib "4096" "Кол-во RAM для VM (в MB)";
    cores = flake.lib.mkStr lib "4" "Кол-во CPU ядер";
    autoLogin = flake.lib.mkBool lib true "Авто-логин в VM";
  };

  configs = lib.mkIf cfg.enable {
    environment.shellAliases = {
      nhvm = "rm -f ${cfg.host}.qcow2 && nixos-rebuild build-vm --flake .#${cfg.host} && ./result/bin/run-${cfg.host}-vm";
    };

    virtualisation.vmVariant = {
      virtualisation = {
        memorySize = lib.toInt cfg.memory;
        cores = lib.toInt cfg.cores;
      };

      services.displayManager.autoLogin = lib.mkIf cfg.autoLogin {
        enable = true;
        user = config.mods.user.name;
      };
    };
  };
}
