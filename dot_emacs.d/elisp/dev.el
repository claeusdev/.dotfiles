;;; dev.el --- Projects, LSP, formatting, Git, terminal, debugging -*- lexical-binding: t; -*-

;;; Code:

;; --- Projects ------------------------------------------------------------

(defun my/project-root ()
  "Return the current project root, or signal an error."
  (expand-file-name
   (project-root (or (project-current t)
                     (user-error "Not in a project")))))

(defun my/project-read-root ()
  "Prompt for a known project and return its root directory."
  (expand-file-name (project-prompt-project-dir)))

(defun my/project-open-root ()
  "Open Dired at the current project root."
  (interactive)
  (dired (my/project-root)))

(defun my/project-switch-find-file ()
  "Switch to a known project and immediately find a file in it."
  (interactive)
  (let ((default-directory (my/project-read-root)))
    (project-find-file)))

(defun my/project-remember-current ()
  "Record the current directory as a known project."
  (interactive)
  (project-remember-project (expand-file-name default-directory))
  (message "Remembered project: %s" (expand-file-name default-directory)))

(defun my/project-search ()
  "Ripgrep the current project."
  (interactive)
  (consult-ripgrep (my/project-root)))

(defun my/project-vterm ()
  "Open a vterm at the current project root."
  (interactive)
  (let ((default-directory (my/project-root)))
    (vterm (format "*vterm: %s*"
                   (file-name-nondirectory
                    (directory-file-name default-directory))))))

(defvar my/project-test-command-alist
  '((typescript-ts-mode . my/node-test-command)
    (tsx-ts-mode        . my/node-test-command)
    (js-ts-mode         . my/node-test-command)
    (python-ts-mode     . my/python-test-command)
    (rust-ts-mode       . "cargo test")
    (tuareg-mode        . "dune test"))
  "Default test command per major mode.
Values are either a literal string or a function returning one.")

(defun my/project-default-test-command ()
  "Return an appropriate test command for the current buffer."
  (let ((entry (alist-get major-mode my/project-test-command-alist)))
    (cond
     ((stringp entry) entry)
     ((and (symbolp entry) (fboundp entry)) (funcall entry))
     (t compile-command))))

(defun my/project-compile ()
  "Compile from the project root, saving modified buffers first."
  (interactive)
  (let ((default-directory (my/project-root)))
    (save-some-buffers t)
    (call-interactively #'project-compile)))

(defun my/project-test ()
  "Run a mode-appropriate test command from the project root."
  (interactive)
  (let ((default-directory (my/project-root))
        (compile-command (my/project-default-test-command)))
    (save-some-buffers t)
    (call-interactively #'compile)))

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers
   '(".envrc" "package.json" "pyproject.toml" "Cargo.toml" "dune-project" "justfile"))
  :config
  (setq project-list-file (expand-file-name "projects" my/cache-dir)
        compilation-scroll-output 'first-error))

;; Applies each project's direnv environment buffer-locally, so PATH,
;; VIRTUAL_ENV and friends resolve per project — LSP servers, ruff and
;; python all come from the project's own environment.  Enabled from
;; after-init as the envrc README advises, so envrc-mode is active before
;; other buffer-local setup runs.
(use-package envrc
  :if (executable-find "direnv")
  :hook (after-init . envrc-global-mode))

;; --- LSP -----------------------------------------------------------------

(defun my/eglot-ensure-when-executable (command)
  "Start Eglot only when COMMAND is on PATH, so buffers stay usable without it."
  (when (executable-find command)
    (eglot-ensure)))

(use-package eglot
  :ensure nil
  :custom
  (eglot-autoshutdown t)
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t)
  ;; `eglot-events-buffer-size' was obsoleted in Eglot 1.16 in favour of this
  ;; plist.
  (eglot-events-buffer-config '(:size 2000000 :format full))
  :config
  ;; NOTE: never add `flymake' to `eglot-stay-out-of'.  That list is matched as
  ;; a regexp against variable names, so "flymake" also matches
  ;; `flymake-diagnostic-functions' and prevents Eglot from installing its
  ;; diagnostics backend — silently disabling every LSP diagnostic.
  ;; Eglot enables eldoc and flymake itself; do not hook them on again here.
  (dolist (entry
           '(((js-ts-mode typescript-ts-mode tsx-ts-mode) . ("vtsls" "--stdio"))
             ((rust-ts-mode)      . ("rust-analyzer"))
             ((tuareg-mode)       . ("ocamllsp"))
             ((python-ts-mode)    . ("basedpyright-langserver" "--stdio"))
             ((yaml-ts-mode)      . ("yaml-language-server" "--stdio"))
             ((dockerfile-ts-mode). ("docker-langserver" "--stdio"))))
    (add-to-list 'eglot-server-programs entry))
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local completion-category-defaults nil
                          completion-category-overrides
                          '((eglot (styles orderless basic))
                            (file (styles partial-completion)))))))

(with-eval-after-load 'flymake
  (setq flymake-fringe-indicator-position 'right-fringe
        flymake-show-diagnostics-at-end-of-line 'short))

;; --- Formatting ----------------------------------------------------------

;; Apheleia formats asynchronously on save without moving point.
(use-package apheleia
  :custom
  (apheleia-mode-alist
   '((typescript-ts-mode . prettier)
     (tsx-ts-mode        . prettier)
     (js-ts-mode         . prettier)
     (json-ts-mode       . prettier)
     (yaml-ts-mode       . prettier)
     (css-ts-mode        . prettier)
     (markdown-mode      . prettier)
     (python-ts-mode     . ruff-format)
     (rust-ts-mode       . rustfmt)
     (tuareg-mode        . ocamlformat)
     (sql-mode           . sql-formatter)))
  :config (apheleia-global-mode 1))

;; --- Git -----------------------------------------------------------------

(use-package magit
  :bind ("C-x g" . magit-status)
  :custom
  (magit-diff-refine-hunk 'all)
  (magit-save-repository-buffers 'dontask))

;; Forge puts GitHub pull requests and issues in the Magit status buffer.
;; It reuses the token from `gh auth`, read via auth-source.
(use-package forge
  :after magit
  :custom (forge-add-default-bindings t))

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config (diff-hl-flydiff-mode 1))

;; Editable grep buffers: export from consult with `C-.' then E, edit, C-c C-c.
(use-package wgrep)

;; --- Terminal ------------------------------------------------------------

(use-package vterm
  :commands vterm
  :custom (vterm-max-scrollback 10000)
  :init
  ;; Open vterm in a split to the right instead of replacing the current
  ;; window; reuse the window if a vterm is already showing.
  (add-to-list 'display-buffer-alist
               '("\\*vterm"
                 (display-buffer-reuse-window display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.5))))

;; --- Debugging -----------------------------------------------------------

;; dape is the DAP client built for Eglot; it replaces dap-mode, which belonged
;; to the lsp-mode ecosystem.  Adapters ship as built-in configurations, so
;; only the binaries need installing.  lldb-dap is a global install; debugpy
;; is a Python module dape imports via the project's own `python' (envrc puts
;; the venv on PATH), so add it per project with `uv add --dev debugpy' —
;; dape errors clearly when it is missing.
(use-package dape
  :commands (dape dape-breakpoint-toggle)
  :custom
  (dape-buffer-window-arrangement 'right)
  (dape-inlay-hints t)
  :config
  (dape-breakpoint-global-mode 1))

(provide 'dev)
;;; dev.el ends here
