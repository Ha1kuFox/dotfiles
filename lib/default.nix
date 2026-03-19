_: {
	mkBool = lib: default: description:
		lib.mkOption {
			inherit default description;
			type = lib.types.bool;
		};
	mkEnable = lib: description:
		lib.mkOption {
			inherit description;
			default = true;
			type = lib.types.bool;
		};
	mkStr = lib: default: description:
		lib.mkOption {
			inherit default description;
			type = lib.types.str;
		};
	mkSubm = lib: opts:
		lib.mkOption {
			type = lib.types.submodule {options = opts;};
			default = {};
		};

	mkMod = {
		name,
		options ? {},
		configs ? {},
		home ? {},
		lib,
		config,
	}: let
		cfg = config.mods.${name};
		user = config.mods.user.name or "user";
	in {
		options.mods.${name} =
			{
				enable = lib.mkEnableOption "Enable ${name} mod";
			}
			// options;

		config =
			lib.mkIf cfg.enable (
				lib.mkMerge [
					configs
					(lib.mkIf (home != {}) {
							home-manager.users.${user} = home;
						})
				]
			);
	};
}
