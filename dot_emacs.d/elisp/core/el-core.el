;;; el-core.el --- Editor defaults and UI settings -*- lexical-binding: t; -*-

;;; Code:

;; Reset GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

(defconst my/cache-dir (expand-file-name "var/" user-emacs-directory)
  "Directory for cache-like Emacs state.")

(dolist (dir (list my/cache-dir
                   (expand-file-name "auto-save/" my/cache-dir)
                   (expand-file-name "backup/" my/cache-dir)))
  (make-directory dir t))

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
      make-backup-files t
      version-control t
      kept-new-versions 10
      kept-old-versions 3
      delete-old-versions t
      backup-directory-alist `(("." . ,(expand-file-name "backup/" my/cache-dir)))
      auto-save-default t
      auto-save-timeout 20
      auto-save-interval 200
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" my/cache-dir) t)))

;; UTF-8 everywhere
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

;; --- UI ---
(setq ring-bell-function #'ignore
      use-short-answers t
      completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)
(global-font-lock-mode 1)
(column-number-mode 1)

;; Relative line numbers in programming modes
(add-hook 'prog-mode-hook #'font-lock-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Show trailing whitespace in prog-mode
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; Fill column indicator
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'text-mode-hook #'visual-line-mode)

;; Smooth scrolling
(setq scroll-margin 3
      scroll-conservatively 101
      scroll-preserve-screen-position t)

;; --- Session ---
(recentf-mode 1)
(setq recentf-max-saved-items 200
      recentf-save-file (expand-file-name "recentf" my/cache-dir))

(savehist-mode 1)
(setq savehist-file (expand-file-name "history" my/cache-dir)
      history-length 200)

(save-place-mode 1)
(setq save-place-file (expand-file-name "places" my/cache-dir))

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

;; Prefer the built-in project workflow across the config.
(setq project-switch-commands
      '((project-find-file "Find file")
        (project-find-regexp "Find regexp")
        (project-find-dir "Find dir")
        (project-dired "Dired")
        (project-vc-dir "VC-Dir")
        (project-shell "Shell")
        (project-eshell "Eshell")
        (my/project-vterm "VTerm")
        (my/project-compile "Compile")
        (my/project-test "Test")))

(defconst my/emacs-health-checks
  '((required "rg" "Ripgrep for project search")
    (required "git" "Project and Magit workflows")
    (required "python3" "Python interpreter")
    (optional "fd" "Fast file finder fallback command")
    (optional "ty" "Python LSP via eglot-python-preset")
    (optional "rust-analyzer" "Rust LSP")
    (optional "clangd" "C/C++ LSP")
    (optional "ocamllsp" "OCaml LSP")
    (optional "haskell-language-server-wrapper" "Haskell LSP")
    (optional "millet-ls" "SML LSP")
    (optional "racket-langserver" "Racket LSP")
    (optional "nil" "Nix LSP")
    (optional "coq-lsp" "Coq LSP")
    (optional "zathura" "Linux PDF viewer")
    (optional "skim" "macOS PDF viewer")
    (optional "vterm-module" "Native vterm module built by the package"))
  "External tool checks for the local Emacs environment.")

(defun my/emacs-health-check ()
  "Report the availability of important external tools."
  (interactive)
  (with-current-buffer (get-buffer-create "*Emacs Health*")
    (erase-buffer)
    (insert (format "Emacs health check on %s\n\n" (system-name)))
    (dolist (entry my/emacs-health-checks)
      (pcase-let ((`(,kind ,command ,description) entry))
        (insert (format "[%s] %-28s %s%s\n"
                        (if (executable-find command) "ok" "missing")
                        command
                        (if (eq kind 'required) "required" "optional")
                        (if (string-empty-p description)
                            ""
                          (format "  %s" description))))))
    (insert "\nLocal override files:\n")
    (dolist (file '("local-pre.el" "local-post.el"))
      (insert (format "- %s: %s\n"
                      file
                      (if (file-exists-p (expand-file-name file user-emacs-directory))
                          "present"
                        "missing"))))
    (goto-char (point-min))
    (special-mode)
    (pop-to-buffer (current-buffer))))

(provide 'el-core)
;;; el-core.el ends here
