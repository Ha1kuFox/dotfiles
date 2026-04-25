{
  flake,
  lib,
  config,
  ...
}:
flake.lib.mkMod {
  inherit lib config;
  name = "ssh";
  configs = {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = true;
    };
  };
}
