{
  flake,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.firefox;
in
flake.lib.mkMod {
  inherit lib config;
  name = "firefox";

  options = { };

  configs = {
    packages.firefox.enable = cfg.enable;
  };
}
