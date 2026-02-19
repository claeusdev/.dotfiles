;;; el-theme.el --- Theme and appearance -*- lexical-binding: t; -*-

(use-package modus-themes
  :init
  (setq modus-themes-bold-constructs t
        modus-themes-italic-constructs t)
  :config
  (load-theme 'modus-operandi t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(when (display-graphic-p)
  (let ((font-height (if (eq system-type 'darwin) 165 140)))
    (set-face-attribute 'default nil :font "Inconsolata Nerd Font" :height font-height)))

(provide 'el-theme)
;;; el-theme.el ends here
