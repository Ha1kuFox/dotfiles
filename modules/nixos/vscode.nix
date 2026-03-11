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

  options = { };

  home = {
    home.packages = with pkgs; [
      nil
      just
      devenv
      kdePackages.qtdeclarative
    ];

    programs.fish.enable = true;
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          mkhl.direnv
          christian-kohler.path-intellisense
        ];

        userSettings = {
          "workbench.activityBar.location" = "top";
          "workbench.statusBar.visible" = true;
          "editor.showFoldingControls" = "never";
          "workbench.layoutControl.enabled" = false;
          "editor.lineNumbers" = "on";
          "editor.glyphMargin" = false;
          "workbench.editor.showTabs" = "single";
          "window.menuBarVisibility" = "toggle";
          "editor.cursorBlinking" = "solid";
          "workbench.startupEditor" = "none";
          "editor.formatOnSave" = true;

          "json.schemaDownload.trustedDomains" = {
            "https://schemastore.azurewebsites.net/" = true;
            "https://raw.githubusercontent.com/" = true;
            "https://www.schemastore.org/" = true;
            "https://json.schemastore.org/" = true;
            "https://json-schema.org/" = true;
            "https://esm.sh/" = true;
          };

          "direnv.restart.automatic" = true;

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
        };
      };
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
    };
  };
}
