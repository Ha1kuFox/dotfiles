;; -*- lexical-binding: t; -*-

;; ==================== БАЗОВАЯ НАСТРОЙКА ====================

(use-package org
  :demand t
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-directory "~/org/"
        org-default-notes-file (concat org-directory "inbox.org")
        org-agenda-files (list org-directory)
        ;; ... весь ваш org-config как раньше
        ))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "●")
        org-modern-list '((?- . "–") (?+ . "•") (?* . "★"))))

;; ==================== HOT-RELOAD ====================

(defun my/emacs-reload-config ()
  "Перезагрузить весь конфиг Emacs без перезапуска."
  (interactive)
  (let ((init-file (expand-file-name "init.el" user-emacs-directory)))
    (load-file init-file)
    (message "✅ Emacs конфиг перезагружен!")))

(global-set-key (kbd "C-c r") #'my/emacs-reload-config)

;; Чтобы можно было редактировать и сразу применять изменения в use-package
(setq use-package-always-ensure nil)