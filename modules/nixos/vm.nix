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
    host = flake.lib.mkStr lib "nixos" "The flake configuration name to build";
    memory = flake.lib.mkStr lib "4096" "Amount of RAM for the VM (in MB)";
    cores = flake.lib.mkStr lib "4" "Number of CPU cores";
    autoLogin = flake.lib.mkBool lib true "Enable auto-login in VM";
  };

  configs = {
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
