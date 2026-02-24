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
    programs.firefox.enable = cfg.enable;
  };
}
