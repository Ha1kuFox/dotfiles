{
	flake,
	lib,
	config,
	pkgs,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "fonts";

	configs = {
		fonts.fontDir.enable = true;
		fonts.packages = with pkgs; [
			nerd-fonts.caskaydia-cove
		];
		fonts.fontconfig.defaultFonts = {
			monospace = ["CaskaydiaCove NFM"];
			sansSerif = ["CaskaydiaCove NFM"];
			serif = ["CaskaydiaCove NFM"];
		};
	};
}
