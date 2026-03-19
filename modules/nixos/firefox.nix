{
	flake,
	lib,
	config,
	inputs,
	pkgs,
	...
}:
flake.lib.mkMod {
	inherit lib config;
	name = "firefox";

	options = {};

	home = {
		programs.firefox = {
			enable = true;
			profiles.default = {
				id = 0;
				isDefault = true;
				settings = {
					"extensions.autoDisableScopes" = 0;

					# Anti-AI
					"browser.ai.control.default" = "blocked";
					"browser.ai.control.linkPreviewKeyPoints" = "blocked";
					"browser.ai.control.pdfjsAltText" = "blocked";
					"browser.ai.control.sidebarChatbot" = "blocked";
					"browser.ai.control.smartTabGroups" = "blocked";
					"browser.ai.control.translations" = "blocked";
					"browser.ml.chat.enabled" = false;
					"browser.ml.chat.page" = false;
					"browser.ml.linkPreview.enabled" = false;
					"browser.tabs.groups.smart.enabled" = false;
					"browser.tabs.groups.smart.userEnabled" = false;
					"browser.translations.enable" = false;
					"extensions.ml.enabled" = false;
					"pdfjs.enableAltText" = false;
				};

				extensions = {
					force = false;
					packages = with inputs.firefox-addons.packages.${pkgs.system}; [
						ublock-origin
						smartproxy
						keepassxc-browser
						darkreader
						sponsorblock
						steam-database
					];
				};
			};
		};
	};
}
