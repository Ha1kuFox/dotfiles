{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.boot;
in
flake.lib.mkMod {
  inherit lib config;
  name = "boot";

  options = {
    plymouth = flake.lib.mkBool lib false "Enable Plymouth";
    fastboot = flake.lib.mkBool lib false "Enable Fastboot";
  };

  configs = {
    boot = {
      loader.systemd-boot.enable = true;
      kernelPackages = pkgs.linuxPackages;

      plymouth.enable = cfg.plymouth;
      kernelParams =
        if cfg.plymouth then
          [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
          ]
        else
          [ ];
      consoleLogLevel = if cfg.plymouth then 0 else 3;
    };
  };
}
