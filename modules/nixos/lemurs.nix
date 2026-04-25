{
  flake,
  lib,
  pkgs,
  config,
  ...
}:
flake.lib.mkMod {
  inherit lib config;
  name = "lemurs";
  configs = {
    services.displayManager.lemurs = {
      enable = true;
      package = pkgs.lemurs;
    };
  };
}
