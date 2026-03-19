{
	pkgs,
	flake,
	lib,
	config,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "godot";

	options = {};

	configs = {
		environment.systemPackages = with pkgs; [
			godot
			godotPackages.export-template
			gdscript-formatter
		];
	};
}
