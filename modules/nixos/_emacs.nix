{
	flake, # ← уже приходит от blueprint
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
			extraPackages = epkgs:
				with epkgs; [
					use-package
					org
					which-key
					vertico
					nix-mode
					ob-nix
				];
			extraConfig = ''
				;; -*- lexical-binding: t; -*-

				; Cleanup
				(menu-bar-mode -1)
				(tool-bar-mode -1)
				(scroll-bar-mode -1)
				(setq inhibit-startup-screen t)

				; which-key
				(use-package which-key
				  :init (which-key-mode))

				; vertico
				(use-package vertico
				  :init (vertico-mode))

				; nix-mode
				(use-package nix-mode
				  :mode "\\.nix\\'")

				(setq user-emacs-directory "~/.config/emacs/")
				(use-package org
				  :demand t
				  :config
				  (setq
				   org-directory "~/org/"
				   org-agenda-files '("~/org/")

				   ; TODO's
				   org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
				   org-log-done 'time

				   ; Visual
				   org-startup-folded t
				   org-hide-leading-stars t
				   org-src-fontify-natively t
				   org-src-tab-acts-natively t

				   org-confirm-babel-evaluate nil

				   (org-babel-do-load-languages
				   'org-babel-load-languages
				   '((emacs-lisp . t)  ; Lisp
				     (nix . t)         ; Nix
				     (shell . t))))    ; bash/sh
				)
			'';
		};

		services.emacs = {
			enable = true;
			client.enable = true;
		};
	};
}
