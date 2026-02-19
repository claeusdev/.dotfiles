;;; el-core.el --- Editor defaults and UI settings -*- lexical-binding: t; -*-

;;; Code:

;; Reset GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;; Inherit PATH on macOS
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

;; --- Editor defaults ---
(setq-default indent-tabs-mode nil
              tab-width 2
              fill-column 100)
(setq require-final-newline t
      sentence-end-double-space nil
      delete-by-moving-to-trash t
      create-lockfiles nil
      make-backup-files nil
      auto-save-default nil)

;; UTF-8 everywhere
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

;; --- UI ---
(setq ring-bell-function #'ignore
      use-short-answers t)
(column-number-mode 1)

;; Relative line numbers in programming modes
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Show trailing whitespace in prog-mode
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; Fill column indicator
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Smooth scrolling
(setq scroll-margin 3
      scroll-conservatively 101
      scroll-preserve-screen-position t)

;; --- Session ---
(recentf-mode 1)
(setq recentf-max-saved-items 200)

(savehist-mode 1)

(save-place-mode 1)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Clipboard integration
(setq select-enable-clipboard t
      select-enable-primary t)

;; Electric pairs
(electric-pair-mode 1)

;; Highlight matching parens
(show-paren-mode 1)
(setq show-paren-delay 0)

(provide 'el-core)
;;; el-core.el ends here
