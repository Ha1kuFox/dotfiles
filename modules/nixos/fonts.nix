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
		fonts.packages = with pkgs; [
			(nerdfonts.override {fonts = ["CascadiaCode"];})
		];
		Cfonts.fontconfig.defaultFonts = {
			monospace = ["Cascadia Code NF"];
			sansSerif = ["Cascadia Code NF"];
			serif = ["Cascadia Code NF"];
		};
	};
}
