{
	flake,
	pkgs,
	lib,
	config,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "vscode";

	options = {};

	home = {
		programs.vscode = {
			enable = true;
			package = pkgs.vscodium;
			mutableExtensionsDir = false;

			profiles.default = {
				enableUpdateCheck = false;
				enableExtensionUpdateCheck = false;
				extensions = with pkgs.vscode-extensions;
					[
						jnoortheen.nix-ide
						mkhl.direnv

						christian-kohler.path-intellisense
						usernamehw.errorlens
						rust-lang.rust-analyzer
					]
					++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
						{
							name = "slint";
							publisher = "slint";
							version = "1.15.1";
							sha256 = "4kpW3bwXWrhWOslp/GQjCT2bv/kBCktsFo30orIII5U=";
						}
					];

				userSettings = {
					"workbench.activityBar.location" = "top";
					"workbench.statusBar.visible" = true;
					"editor.showFoldingControls" = "never";
					"workbench.layoutControl.enabled" = false;
					"editor.lineNumbers" = "on";
					"editor.glyphMargin" = false;
					"workbench.editor.showTabs" = "multiple";
					"window.menuBarVisibility" = "toggle";
					"editor.cursorBlinking" = "solid";
					"workbench.startupEditor" = "none";
					"editor.formatOnSave" = true;
					#"workbench.colorTheme" = "Dynamic Base16 DankShell (Dark)";

					# "json.schemaDownload.trustedDomains" = {
					# 	"https://schemastore.azurewebsites.net/" = true;
					# 	"https://raw.githubusercontent.com/" = true;
					# 	"https://www.schemastore.org/" = true;
					# 	"https://json.schemastore.org/" = true;
					# 	"https://json-schema.org/" = true;
					# 	"https://esm.sh/" = true;
					# };

					"direnv.restart.automatic" = true;

					"nix.enableLanguageServer" = true;
					"nix.serverPath" = "nixd";
					"nix.serverSettings" = {
						"nixd" = {
							"formatting" = {
								"command" = ["alejandra"];
							};
						};
					};
				};
			};
		};
	};
}
