{
  flake,
  lib,
  config,
  ...
}:
flake.lib.mkMod {
  inherit lib config;
  name = "firefox";

  options = { };

  configs = {
    programs.firefox.enable = true;
  };
}
