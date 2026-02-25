{
  flake,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.gaming;
in
flake.lib.mkMod {
  inherit lib config;
  name = "gaming";

  options = {

  };

  configs = lib.mkIf cfg.enable {
  };
}
