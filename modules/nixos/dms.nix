{
	flake,
	inputs,
	lib,
	pkgs,
	config,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "dms";

	home = {
		imports = [
			inputs.dms.homeModules.dank-material-shell
			inputs.niri.homeModules.niri
			inputs.danksearch.homeModules.dsearch
		];

		programs.dsearch = {
			enable = true;
		};
		programs.dank-material-shell = {
			enable = true;
			enableSystemMonitoring = true;
			dgop.package = pkgs.dgop;
			quickshell.package = pkgs.quickshell;
			systemd = {
				enable = true;
				restartIfChanged = true;
			};
		};
	};
}
