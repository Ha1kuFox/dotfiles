_: {
  mkBool =
    lib: default: description:
    lib.mkOption {
      inherit default description;
      type = lib.types.bool;
    };

  mkStr =
    lib: default: description:
    lib.mkOption {
      inherit default description;
      type = lib.types.str;
    };

  mkMod =
    {
      name,
      options ? { },
      configs ? { },
      lib,
      config,
    }:
    let
      cfg = config.mods.${name};
    in
    {
      options.mods.${name} = {
        enable = lib.mkEnableOption "Enable ${name} mod";
      }
      // options;

      config = lib.mkIf cfg.enable configs;
    };
}
