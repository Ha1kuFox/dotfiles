{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.vscode;
in
flake.lib.mkMod {
  inherit lib config;
  name = "vscode";

  options = { };

  configs = lib.mkIf cfg.enable {
    home-manager.users.${config.mods.user.name} = {
      home.packages = with pkgs; [
        nil
        just
        devenv
      ];

      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;

        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            #golang.go
            jnoortheen.nix-ide
            mkhl.direnv
            christian-kohler.path-intellisense
          ];

          userSettings = {
            "editor.minimize.enabled" = false;
            "workbench.activityBar.location" = "top";
            "workbench.statusBar.visible" = true;
            "editor.showFoldingControls" = "never";
            "workbench.layoutControl.enabled" = false;
            "editor.lineNumbers" = "on";
            "editor.glyphMargin" = false;
            "workbench.editor.showTabs" = "single";
            "terminal.integrated.fontSize" = 14;
            "window.menuBarVisibility" = "toggle";
            "editor.fontSize" = 15;
            "editor.cursorBlinking" = "solid";
            "workbench.startupEditor" = "hidden";

            "editor.formatOnSave" = true;
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";

            "go.useLanguageServer" = true;
            "go.lintTool" = "golangci-lint";

            "direnv.silent" = true;
          };
        };
      };
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
