;;; --- 11. FILE EXPLORER ---
(use-package treemacs
  :ensure t
  :defer t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-project-follow-mode t)
  (treemacs-git-mode 'simple)
  :bind
  (:map global-map
        ("M-0" . treemacs-select-window)
        ("C-x t t" . treemacs)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-all-the-icons
  :after treemacs
  :ensure t
  :config (treemacs-load-theme "all-the-icons"))

(provide 'el-treemacs)
