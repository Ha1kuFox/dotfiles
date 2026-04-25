{
  flake,
  lib,
  config,
  ...
}:
flake.lib.mkMod {
  inherit lib config;
  name = "i3";

  configs = {
    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
      displayManager.startx.enable = true;
    };
  };
}
