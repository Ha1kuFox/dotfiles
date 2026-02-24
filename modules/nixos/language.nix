{
  flake,
  lib,
  config,
  ...
}:
flake.lib.mkMod {
  inherit lib config;
  name = "language";

  options = { };
  configs = {
    # TODO: Steam and many apps dont use my lang by default
    time.timeZone = "Asia/Omsk";
    i18n = {
      defaultLocale = "ru_RU.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_PAPER = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
      };
    };
  };
}
