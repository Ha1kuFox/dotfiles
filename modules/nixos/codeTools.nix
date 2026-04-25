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
		];

		programs.fish.enable = true;
		programs.starship = {
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
