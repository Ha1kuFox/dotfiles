{
	flake,
	config,
	lib,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "autologin";

	configs = {
		services.greetd = {
			enable = true;
			settings = {
				default_session = {
					command = "${config.programs.niri.package}/bin/niri-session";
					user = "user";
				};
			};
		};
	};
}
