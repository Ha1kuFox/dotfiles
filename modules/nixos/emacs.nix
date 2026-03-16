{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
flake.lib.mkMod {
  inherit lib config;
  name = "emacs";

  home = {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages =
        epkgs: with epkgs; [
          use-package
          org
          org-modern
        ];

      extraConfig = ''
        ;; ====================== BOOTSTRAP ======================
        (setq user-emacs-directory (expand-file-name "~/.config/emacs/"))
        (load-file (expand-file-name "init.el" user-emacs-directory))
      '';
    };

    services.emacs = {
      enable = true;
      client.enable = true;
    };

    xdg.configFile."emacs" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flake}/emacs";
      recursive = true;
    };
  };
}
