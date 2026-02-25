{
  flake,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.language;
in
flake.lib.mkMod {
  inherit lib config;
  name = "language";

  options = { };
  configs = lib.mkIf cfg.enable {
    # TODO: Стим и тп не используют русский из коробки
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
