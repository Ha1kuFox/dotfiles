{
	flake,
	pkgs,
	lib,
	config,
	...
}: let
	cfg = config.mods.boot;
	# emptyLogo = pkgs.runCommand "empty-logo.png" { } ''
	#   ${pkgs.imagemagick}/bin/convert -size 1x1 xc:transparent $out
	# '';
in
	flake.lib.mkMod {
		inherit lib config;
		name = "boot";

		options = {
			silent = flake.lib.mkBool lib false "";
			#fastboot = flake.lib.mkBool lib false "Вкл. Fastboot";
		};

		configs = {
			boot = {
				loader.systemd-boot = {
					enable = true;
					consoleMode = "max";
				};
				kernelPackages = pkgs.linuxPackages;

				# plymouth = {
				#   enable = cfg.plymouth;
				#   logo = "${emptyLogo}";
				#   theme = "catppuccin-mocha";
				#   themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
				# };
				kernelParams =
					if cfg.silent
					then [
						"quiet"
						"loglevel=3"
						"udev.log_level=3"
						"systemd.show_status=auto"
						"rd.udev.log_level=3"
						"vt.global_cursor_default=0"
						"fbcon=nodefer"
						"plymouth.ignore-serial-consoles"
						"plymouth.use-simpledrm=0"
					]
					else [];
				initrd.verbose =
					if cfg.silent
					then false
					else true;
				consoleLogLevel =
					if cfg.silent
					then 0
					else 3;
				loader.timeout =
					if cfg.silent
					then 0
					else 3;
			};
			systemd = {
				# services = {
				#   plymouth-halt.enable = if cfg.plymouth then false else true;
				#   plymouth-reboot.enable = if cfg.plymouth then false else true;
				#   plymouth-poweroff.enable = if cfg.plymouth then false else true;
				#   plymouth-kexec.enable = if cfg.plymouth then false else true;
				# };
				settings.Manager = {
					DefaultTimeoutStopSec = "10s";
				};
			};
		};
	}
