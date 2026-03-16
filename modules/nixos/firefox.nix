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

  options = { };

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
          force = true;
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            ublock-origin
            smartproxy
            keepassxc-browser
            darkreader
            sponsorblock
            steam-database
          ];
          settings = {
            ### uBlock ###
            "uBlock0@raymondhill.net".settings = {
              selectedFilterLists = [
                "user-filters"
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                "easylist"
                "easyprivacy"
                "urlhaus-1"
                "plowe-0"
                "fanboy-cookiemonster"
                "ublock-cookies-easylist"
                "adguard-cookies"
                "ublock-cookies-adguard"
                "fanboy-social"
                "adguard-social"
                "fanboy-ai-suggestions"
                "easylist-chat"
                "easylist-newsletters"
                "easylist-notifications"
                "easylist-annoyances"
                "adguard-mobile-app-banners"
                "adguard-other-annoyances"
                "adguard-popup-overlays"
                "adguard-widgets"
                "ublock-annoyances"
                "RUS-0"
                "RUS-1"
              ];
              userFilters = "*$font,third-party";
            };

            ### SmartProxy ###
            "smartproxy@salarcode.com" = {
              settings = {
                "activeProfileId" = "InternalProfile_SmartRules";
                "defaultProxyServerId" = "0";
                "options" = {
                  "syncSettings" = false;
                  "proxyPerOrigin" = true;
                  "themeType" = 0;
                };
                "proxyServers" = [
                  {
                    "name" = "FlClashX";
                    "id" = "0";
                    "host" = "127.0.0.1";
                    "port" = "7890";
                    "protocol" = "HTTP";
                    "proxyDNS" = true;
                  }
                ];
              };
            };
          };
        };
      };
    };
  };
}
