;;; el-tools.el --- Utilities and tools -*- lexical-binding: t; -*-

;;; Code:

;; Projectile
(use-package projectile
  :bind-keymap ("C-c p" . projectile-command-map)
  :custom
  (projectile-project-search-path '("~/projects/" "~/src/"))
  :config
  (projectile-mode 1))

;; Avy — jump to visible text
(use-package avy
  :bind ("C-c j" . avy-goto-char-timer))

;; Smartparens
(use-package smartparens
  :hook (prog-mode . smartparens-strict-mode)
  :config
  (require 'smartparens-config))

;; Yasnippet
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;; Which-key
(use-package which-key
  :custom (which-key-idle-delay 0.3)
  :config (which-key-mode 1))

;; Treemacs
(use-package treemacs
  :bind (("M-0"     . treemacs-select-window)
         ("C-x t t" . treemacs)))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-nerd-icons
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))

;; Vterm
(use-package vterm
  :commands vterm
  :custom (vterm-max-scrollback 10000))

;; Apheleia — auto-format on save
(use-package apheleia
  :config (apheleia-global-mode 1))

;; Wgrep — editable grep buffers
(use-package wgrep)

;; Editorconfig
(use-package editorconfig
  :config (editorconfig-mode 1))

;; --- Writing & Focus ---

;; Olivetti — centered writing mode
(use-package olivetti
  :custom (olivetti-body-width 90)
  :hook ((org-mode . olivetti-mode)
         (markdown-mode . olivetti-mode)))

;; Jinx — fast spell-checking
(use-package jinx
  :hook ((text-mode . jinx-mode)
         (org-mode . jinx-mode))
  :bind ("M-$" . jinx-correct))

;; Writegood — highlight weak writing patterns
(use-package writegood-mode
  :hook ((org-mode . writegood-mode)
         (markdown-mode . writegood-mode)
         (LaTeX-mode . writegood-mode)))

(provide 'el-tools)
;;; el-tools.el ends here
