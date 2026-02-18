;;; --- 4. THEME & APPEARANCE ---
(use-package nerd-icons
  :if (display-graphic-p))

;; Modus theme (light)
(use-package modus-themes
  :ensure t
  :init
  (setq modus-themes-bold-constructs t
        modus-themes-italic-constructs t)
  :config
  (load-theme 'modus-operandi t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 5)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-project-detection 'auto))

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Font configuration - adjust height per platform
(let ((font-height (if (eq system-type 'darwin) 165 140)))
  (set-face-attribute 'default nil :font "Inconsolata Nerd Font" :height font-height))

(provide 'el-theme)
