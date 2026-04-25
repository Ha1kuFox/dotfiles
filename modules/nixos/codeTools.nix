{
	flake,
	pkgs,
	lib,
	config,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "codeTools";

	home = {
		home.packages = with pkgs; [
			just
			devenv
			fzf
			helix
			zellij
		];

		programs.fish = {
			enable = true;
			interactiveShellInit = ''
				set fish_greeting # Disable greeting
			'';
		};

		programs.starship = {
			enable = true;
			enableFishIntegration = true;
		};

		programs.zellij = {
			enable = true;
			enableFishIntegration = true;
		};

		programs.zoxide = {
			enable = true;
			enableFishIntegration = true;
			options = [
				"--cmd cd"
			];
		};

		programs.direnv = {
			enable = true;
			nix-direnv.enable = true;
			enableFishIntegration = true;
		};
	};
}
