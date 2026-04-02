{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		blueprint = {
			url = "github:numtide/blueprint";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		# hytale = {
		# 	url = "github:TNAZEP/HytaleLauncherFlake";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
		hyprland.url = "github:hyprwm/Hyprland";
		# hypr-dynamic-cursors = {
		# 	url = "github:VirtCode/hypr-dynamic-cursors";
		# 	inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
		# };
		dms = {
			url = "github:AvengeMedia/DankMaterialShell/stable";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		niri = {
			url = "github:sodiboo/niri-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		danksearch = {
			url = "github:AvengeMedia/danksearch";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		android-nixpkgs = {
			url = "github:tadfisher/android-nixpkgs/stable";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		stylix = {
			url = "github:nix-community/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		caelestia-shell = {
			url = "github:caelestia-dots/shell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		# flclashx = {
		#   url = "github:ha1kufox/flclashx-flake";
		#   inputs.nixpkgs.follows = "nixpkgs";
		# };
		# catppuccin = {
		# 	url = "github:catppuccin/nix";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		treefmt-nix = {
			url = "github:numtide/treefmt-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs:
		inputs.blueprint {
			inherit inputs;
			systems = ["x86_64-linux"];
		};
}
