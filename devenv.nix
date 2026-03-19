{pkgs, ...}: {
	cachix.enable = false;
	languages.nix = {
		enable = true;
	};
	packages = with pkgs; [
		alejandra
	];
}
