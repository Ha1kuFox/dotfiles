{
	flake,
	lib,
	config,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "lemurs";
	configs = {
		services.displayManager.lemurs.enable = true;
	};
}
