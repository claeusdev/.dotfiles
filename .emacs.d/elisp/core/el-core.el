;;; el-core.el --- Core editor defaults -*- lexical-binding: t; -*-

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(setq-default
 inhibit-startup-screen t
 initial-scratch-message ";; Clean slate loaded.\n"
 indent-tabs-mode nil
 tab-width 2
 fill-column 100
 truncate-lines t
 require-final-newline t
 sentence-end-double-space nil)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook
          (lambda ()
            (setq show-trailing-whitespace t)
            (display-fill-column-indicator-mode 1)))

(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)

(setq select-enable-clipboard t
      select-enable-primary t
      history-length 200)

(provide 'el-core)
;;; el-core.el ends here
