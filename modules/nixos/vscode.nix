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
    # programs.nix-ld.enable = true;
    # programs.nix-ld.libraries = with pkgs; [
    #   stdenv.cc.cc
    #   zlib
    #   fuse3
    #   icu
    #   nss
    #   openssl
    #   curl
    #   expat
    #   portaudio # For sounddevice python lib
    # ];

    home-manager.users.user = {
      home.packages = with pkgs; [
        nil
        just
        devenv
        kdePackages.qtdeclarative
        # uv # For python
      ];
      # Fix uv cant update $PATH
      # home.sessionPath = [
      #   "$HOME/.local/bin"
      # ];

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
            #golang.go
            jnoortheen.nix-ide
            mkhl.direnv
            christian-kohler.path-intellisense

            #ms-python.python
            #ms-python.vscode-pylance
          ];
          #           ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          #              {
          #                name = "qt-python-pack";
          #                publisher = "TheQtCompany";
          #               version = "1.0.1";
          #                sha256 = "sha256-cF6DwuVfwM5Lna4eh1O/moe2BZP+15Tcyiibw/3v6AU=";
          #              }
          #              {
          #                name = "felgo";
          #                publisher = "felgo";
          #                version = "2.0.1";
          #                sha256 = "sha256-5bPbnDduGDAOU56TYRaWM1jxu1D7eczxCX1+xjwkTP8=";
          #              }
          #            ];

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

            "catppuccin.accentColor" = "peach";
            "json.schemaDownload.trustedDomains" = {
              "https://schemastore.azurewebsites.net/" = true;
              "https://raw.githubusercontent.com/" = true;
              "https://www.schemastore.org/" = true;
              "https://json.schemastore.org/" = true;
              "https://json-schema.org/" = true;
              "https://esm.sh/" = true;
            };

            # "qt-qml.doNotAskForQmllsDownload" = true;
            # "qt-qml.qmlls.customExePath" = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
            # "qt-qml.qmlls.additionalImportPaths" = [
            #   "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
            # ];
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
  };
}
