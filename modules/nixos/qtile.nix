{
	flake,
	lib,
	pkgs,
	config,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "qtile";
	configs = {
		services.xserver.windowManager.qtile = {
			enable = true;
			extraPackages = python3Packages:
				with python3Packages; [
					qtile-extras
				];
		};
	};
}
