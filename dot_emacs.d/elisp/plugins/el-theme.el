;;; el-theme.el --- Theme and appearance -*- lexical-binding: t; -*-

;;; Code:

(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-org-blocks 'gray-background)
  :config
  (load-theme 'modus-operandi :no-confirm))

;; Font
(let ((font-height (if (eq system-type 'darwin) 165 140)))
  (set-face-attribute 'default nil
                      :family "Inconsolata Nerd Font"
                      :height font-height))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Nerd icons
(use-package nerd-icons)

;; Doom modeline
(use-package doom-modeline
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-project-detection 'projectile)
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-minor-modes nil)
  :init (doom-modeline-mode 1))

(provide 'el-theme)
;;; el-theme.el ends here
