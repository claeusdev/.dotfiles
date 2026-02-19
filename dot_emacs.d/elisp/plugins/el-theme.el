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

(provide 'el-theme)
;;; el-theme.el ends here
