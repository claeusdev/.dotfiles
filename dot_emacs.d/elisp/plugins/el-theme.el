;;; el-theme.el --- Theme and appearance -*- lexical-binding: t; -*-

;;; Code:

(defun my/font-installed-p (font-name)
  "Return non-nil if FONT-NAME is available."
  (member font-name (font-family-list)))

(defconst my/nerd-font-installed-p
  (or (my/font-installed-p "Inconsolata Nerd Font")
      (my/font-installed-p "Symbols Nerd Font Mono")
      (my/font-installed-p "SauceCodePro Nerd Font")
      (my/font-installed-p "JetBrainsMono Nerd Font"))
  "Whether a Nerd Font is available for icons.")

(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-org-blocks 'gray-background)
  :config
  (load-theme 'modus-vivendi :no-confirm))

;; Font
(let ((font-height (if (eq system-type 'darwin) 165 140)))
  (when (my/font-installed-p "Inconsolata Nerd Font")
    (set-face-attribute 'default nil
                        :family "Inconsolata Nerd Font"
                        :height font-height)))

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
  (doom-modeline-project-detection 'project)
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-icon my/nerd-font-installed-p)
  (doom-modeline-major-mode-icon my/nerd-font-installed-p)
  (doom-modeline-minor-modes nil)
  :init (doom-modeline-mode 1))

(provide 'el-theme)
;;; el-theme.el ends here
