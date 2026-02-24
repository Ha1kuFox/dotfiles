{
  flake,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.hardware;
in
flake.lib.mkMod {
  inherit lib config;
  name = "hardware";

  options = {
    bluetooth = flake.lib.mkBool lib true "Enable Bluetooth support";
    sound = flake.lib.mkBool lib true "Enable Pipewire sound";
  };

  configs = {
    services.pipewire = lib.mkIf cfg.sound {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.bluetooth = lib.mkIf cfg.bluetooth {
      enable = true;
      powerOnBoot = true;
    };
  };
}
