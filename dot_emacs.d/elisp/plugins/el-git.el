;;; el-git.el --- Git integration -*- lexical-binding: t; -*-

;;; Code:

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (diff-hl-flydiff-mode 1))

(provide 'el-git)
;;; el-git.el ends here
