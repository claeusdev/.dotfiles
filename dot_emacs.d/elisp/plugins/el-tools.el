;;; el-tools.el --- Utilities and tools -*- lexical-binding: t; -*-

;;; Code:

(defun my/project-read-root ()
  "Prompt for a known project root and return it as an absolute directory."
  (expand-file-name (project-prompt-project-dir)))

(defun my/project-open-root ()
  "Open `dired' at the current project root."
  (interactive)
  (dired (my/project-root)))

(defun my/project-switch-find-file ()
  "Switch to a known project and immediately find a file in it."
  (interactive)
  (let ((default-directory (my/project-read-root)))
    (project-find-file)))

(defun my/project-switch-dired ()
  "Switch to a known project and open its root in `dired'."
  (interactive)
  (let ((default-directory (my/project-read-root)))
    (project-dired)))

(defun my/project-switch-vterm ()
  "Switch to a known project and open a `vterm' there."
  (interactive)
  (let ((default-directory (my/project-read-root)))
    (my/project-vterm)))

(defun my/project-remember-current ()
  "Remember the current directory as a known project."
  (interactive)
  (project-remember-project (expand-file-name default-directory))
  (message "Remembered project: %s" (expand-file-name default-directory)))

;; Project.el
(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".projectile" ".envrc" "pyproject.toml" "Cargo.toml" "compile_commands.json"))
  :config
  (setq project-list-file (expand-file-name "projects" my/cache-dir)
        compilation-scroll-output 'first-error)
  (global-set-key (kbd "C-c p") project-prefix-map)
  (define-key project-prefix-map (kbd "p") #'project-switch-project)
  (define-key project-prefix-map (kbd "P") #'my/project-switch-find-file)
  (define-key project-prefix-map (kbd "f") #'project-find-file)
  (define-key project-prefix-map (kbd "b") #'project-switch-to-buffer)
  (define-key project-prefix-map (kbd "a") #'my/project-remember-current)
  (define-key project-prefix-map (kbd "d") #'project-find-dir)
  (define-key project-prefix-map (kbd "D") #'project-dired)
  (define-key project-prefix-map (kbd "o") #'my/project-open-root)
  (define-key project-prefix-map (kbd "O") #'my/project-switch-dired)
  (define-key project-prefix-map (kbd "t") #'my/project-test)
  (define-key project-prefix-map (kbd "m") #'my/project-compile)
  (define-key project-prefix-map (kbd "s") #'my/project-search)
  (define-key project-prefix-map (kbd "v") #'my/project-vterm)
  (define-key project-prefix-map (kbd "V") #'my/project-switch-vterm))

(defun my/project-root ()
  "Return the current project root or error."
  (expand-file-name
   (project-root
    (or (project-current t)
        (user-error "Not in a project")))))

(defun my/project-vterm ()
  "Open `vterm' in the current project root."
  (interactive)
  (let ((default-directory (my/project-root)))
    (vterm (format "*vterm: %s*" (file-name-nondirectory
                                  (directory-file-name default-directory))))))

(defvar my/project-test-command-alist
  '((python-mode . my/python-test-command)
    (python-ts-mode . my/python-test-command)
    (rust-mode . "cargo test")
    (rust-ts-mode . "cargo test")
    (js-mode . my/node-test-command)
    (js-ts-mode . my/node-test-command)
    (typescript-ts-mode . my/node-test-command)
    (tsx-ts-mode . my/node-test-command)
    (c-mode . "cmake --build build && ctest --test-dir build --output-on-failure")
    (c-ts-mode . "cmake --build build && ctest --test-dir build --output-on-failure")
    (c++-mode . "cmake --build build && ctest --test-dir build --output-on-failure")
    (c++-ts-mode . "cmake --build build && ctest --test-dir build --output-on-failure")
    (tuareg-mode . "dune test")
    (haskell-mode . "cabal test"))
  "Per-major-mode default test commands.")

(defun my/project-default-test-command ()
  "Return the default test command for the current buffer."
  (let ((entry (alist-get major-mode my/project-test-command-alist)))
    (cond
     ((stringp entry) entry)
     ((and (symbolp entry) (fboundp entry)) (funcall entry))
     ((functionp entry) (funcall entry))
     (t compile-command))))

(defun my/project-compile ()
  "Run `project-compile' from the current project."
  (interactive)
  (let ((default-directory (my/project-root)))
    (save-some-buffers t)
    (call-interactively #'project-compile)))

(defun my/project-test ()
  "Run a mode-appropriate test command in the current project."
  (interactive)
  (let ((default-directory (my/project-root))
        (compile-command (my/project-default-test-command)))
    (save-some-buffers t)
    (call-interactively #'compile)))

(defun my/project-search ()
  "Search the current project with `consult-ripgrep'."
  (interactive)
  (consult-ripgrep (my/project-root)))

;; Avy — jump to visible text
(use-package avy
  :bind ("C-c j" . avy-goto-char-timer))

;; Which-key
(use-package which-key
  :custom (which-key-idle-delay 0.3)
  :config (which-key-mode 1))

;; Vterm
(use-package vterm
  :commands vterm
  :custom (vterm-max-scrollback 10000))

;; Apheleia — auto-format on save
(use-package apheleia
  :custom
  (apheleia-mode-alist
   '((python-mode . ruff-format)
     (python-ts-mode . ruff-format)
     (rust-mode . rustfmt)
     (rust-ts-mode . rustfmt)
     (c-mode . clang-format)
     (c-ts-mode . clang-format)
     (c++-mode . clang-format)
     (c++-ts-mode . clang-format)
     (js-mode . prettier)
     (js-ts-mode . prettier)
     (typescript-ts-mode . prettier)
     (tsx-ts-mode . prettier)
     (mhtml-mode . prettier)
     (css-mode . prettier)
     (css-ts-mode . prettier)
     (json-mode . prettier)
     (json-ts-mode . prettier)
     (yaml-mode . prettier)
     (yaml-ts-mode . prettier)
     (markdown-mode . prettier)
     (sql-mode . sql-formatter)))
  :config (apheleia-global-mode 1))

;; Wgrep — editable grep buffers
(use-package wgrep)

;; Editorconfig
(use-package editorconfig
  :config (editorconfig-mode 1))

;; --- Writing & Focus ---

;; Olivetti — centered writing mode
(use-package olivetti
  :custom (olivetti-body-width 90)
  :hook ((org-mode . olivetti-mode)
         (markdown-mode . olivetti-mode)))

;; Jinx — fast spell-checking
(use-package jinx
  :hook ((text-mode . jinx-mode)
         (org-mode . jinx-mode))
  :bind ("M-$" . jinx-correct))

;; Writegood — highlight weak writing patterns
(use-package writegood-mode
  :hook ((org-mode . writegood-mode)
         (markdown-mode . writegood-mode)))

(provide 'el-tools)
;;; el-tools.el ends here
