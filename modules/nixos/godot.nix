{
	pkgs,
	flake,
	lib,
	config,
	inputs,
	...
}: let
	user = config.mods.user.name or "user";
	sdkPath = "/home/${user}/.android/sdk";
in
	flake.lib.mkMod {
		inherit lib config;
		name = "godot";

		options = {};

		home = {
			imports = [inputs.android-nixpkgs.hmModule];
			android-sdk.enable = true;

			# Optional; default path is "~/.local/share/android".
			android-sdk.path = sdkPath;

			android-sdk.packages = sdkPkgs:
				with sdkPkgs; [
					build-tools-34-0-0
					cmdline-tools-latest
					platforms-android-34
					platform-tools
				];

			home.sessionVariables = {
				ANDROID_HOME = sdkPath;
			};
		};

		configs = {
			nixpkgs.overlays = [
				inputs.android-nixpkgs.overlays.default
			];

			environment.systemPackages = with pkgs; [
				godot
				gdscript-formatter
				openjdk21
				android-tools
			];

			environment.variables = {
				JAVA_HOME = "${pkgs.openjdk21}";
			};
		};
	}
