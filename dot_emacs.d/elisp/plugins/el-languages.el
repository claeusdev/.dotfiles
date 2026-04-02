;;; el-languages.el --- Programming language modes -*- lexical-binding: t; -*-

;;; Code:

;; --- Tree-sitter readiness ---
(defun my/treesit-available-p (lang)
  "Check if tree-sitter is available for LANG."
  (and (fboundp 'treesit-ready-p)
       (treesit-ready-p lang t)))

(defun my/set-local-compile-command (command)
  "Set buffer-local `compile-command' to COMMAND."
  (setq-local compile-command command))

(defun my/project-file-path (name)
  "Return absolute path to NAME at the current project root, or nil."
  (when-let ((project (project-current nil)))
    (let ((path (expand-file-name name (project-root project))))
      (when (file-exists-p path)
        path))))

(defun my/python-interpreter ()
  "Return the preferred Python interpreter for the current project."
  (or (my/project-file-path ".venv/bin/python")
      (my/project-file-path "venv/bin/python")
      (executable-find "python3")
      (executable-find "python")
      "python3"))

(defun my/python-lsp-available-p ()
  "Return non-nil when a Python language server is available."
  (or (executable-find "ty")
      (executable-find "pyright-langserver")
      (executable-find "basedpyright-langserver")))

(defun my/python-run-command ()
  "Return a Python command for running the current file."
  (format "%s %s"
          (shell-quote-argument (my/python-interpreter))
          (shell-quote-argument (or buffer-file-name ""))))

(defun my/python-test-command ()
  "Return a pytest command for the current Python context."
  (if (and buffer-file-name (project-current nil))
      (format "%s -m pytest %s"
              (shell-quote-argument (my/python-interpreter))
              (shell-quote-argument
               (file-relative-name buffer-file-name (my/project-root))))
    (format "%s -m pytest" (shell-quote-argument (my/python-interpreter)))))

(defun my/cpp-test-command ()
  "Return the default C/C++ project test command."
  "cmake --build build && ctest --test-dir build --output-on-failure")

(defun my/python-mode-defaults ()
  "Set Python defaults for programming workflows."
  (my/set-local-compile-command
   (if buffer-file-name
       (my/python-run-command)
     (format "%s" (shell-quote-argument (my/python-interpreter)))))
  (setq-local tab-width 4
              fill-column 88
              python-shell-interpreter (my/python-interpreter))
  (when-let ((venv-path (file-name-directory (directory-file-name python-shell-interpreter))))
    (setq-local python-shell-virtualenv-root
                (directory-file-name (file-name-directory venv-path))))
  (when (my/python-lsp-available-p)
    (eglot-ensure)))

(defun my/rust-mode-defaults ()
  "Set Rust defaults for programming workflows."
  (my/set-local-compile-command "cargo check")
  (setq-local fill-column 100)
  (my/eglot-ensure-when-executable "rust-analyzer"))

(defun my/c-ts-mode-defaults ()
  "Set C/C++ defaults for programming workflows."
  (my/set-local-compile-command "cmake --build build")
  (setq-local c-ts-mode-indent-offset 4
              fill-column 100)
  (my/eglot-ensure-when-executable "clangd"))

(defun my/cc-mode-defaults ()
  "Set fallback C/C++ defaults when tree-sitter modes are unavailable."
  (my/set-local-compile-command "cmake --build build")
  (setq-local c-basic-offset 4
              fill-column 100)
  (my/eglot-ensure-when-executable "clangd"))

(defun my/ocaml-mode-defaults ()
  "Set OCaml defaults for programming workflows."
  (my/set-local-compile-command "dune build")
  (setq-local fill-column 100)
  (if (executable-find "ocamllsp")
      (my/eglot-ensure-when-executable "ocamllsp")
    (when (fboundp 'merlin-mode)
      (merlin-mode 1))))

;; --- C/C++ ---
(if (my/treesit-available-p 'c)
    (use-package c-ts-mode
      :ensure nil
      :mode (("\\.c\\'" . c-ts-mode)
             ("\\.h\\'" . c-ts-mode)
             ("\\.cpp\\'" . c++-ts-mode)
             ("\\.cc\\'" . c++-ts-mode)
             ("\\.hpp\\'" . c++-ts-mode))
      :custom (c-ts-mode-indent-offset 4)
      :hook ((c-ts-mode . my/c-ts-mode-defaults)
             (c++-ts-mode . my/c-ts-mode-defaults)))
  ;; Fallback without tree-sitter
  (add-hook 'c-mode-hook #'my/cc-mode-defaults)
  (add-hook 'c++-mode-hook #'my/cc-mode-defaults))

;; --- Python ---
(if (my/treesit-available-p 'python)
    (use-package python
      :ensure nil
      :mode ("\\.py\\'" . python-ts-mode)
      :custom
      (python-indent-offset 4)
      (python-shell-interpreter "python3")
      :hook (python-ts-mode . my/python-mode-defaults))
  (use-package python
    :ensure nil
    :mode ("\\.py\\'" . python-mode)
    :custom
    (python-indent-offset 4)
    (python-shell-interpreter "python3")
    :hook (python-mode . my/python-mode-defaults)))

;; Ruff + ty via eglot-python-preset (handles multi-server for eglot)
(use-package eglot-python-preset
  :after eglot
  :custom
  (eglot-python-preset-lsp-server 'ty)
  :config
  (eglot-python-preset-setup))

;; --- Rust ---
(if (my/treesit-available-p 'rust)
    (use-package rust-ts-mode
      :ensure nil
      :mode "\\.rs\\'"
      :custom (rust-ts-mode-indent-offset 4)
      :hook (rust-ts-mode . my/rust-mode-defaults))
  (use-package rust-mode
    :mode "\\.rs\\'"
    :custom (rust-format-on-save t)
    :hook (rust-mode . my/rust-mode-defaults)))

(use-package cargo
  :hook ((rust-mode . cargo-minor-mode)
         (rust-ts-mode . cargo-minor-mode)))

;; --- OCaml ---
(use-package tuareg
  :hook (tuareg-mode . my/ocaml-mode-defaults))

(use-package merlin
  :after tuareg
  :hook (tuareg-mode . (lambda ()
                         (unless (bound-and-true-p eglot--managed-mode)
                           (merlin-mode 1)))))

;; --- Haskell ---
(use-package haskell-mode
  :hook ((haskell-mode . interactive-haskell-mode)
         (haskell-mode . (lambda ()
                           (my/set-local-compile-command "cabal test")
                           (my/eglot-ensure-when-executable "haskell-language-server-wrapper")))))

;; --- SML ---
(use-package sml-mode
  :mode "\\.\\(sml\\|sig\\|fun\\)\\'"
  :custom (sml-indent-level 2)
  :hook (sml-mode . (lambda () (my/eglot-ensure-when-executable "millet-ls"))))

;; --- Racket ---
(use-package racket-mode
  :hook (racket-mode . (lambda () (my/eglot-ensure-when-executable "racket-langserver"))))

;; --- Nix ---
(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . (lambda () (my/eglot-ensure-when-executable "nil"))))

;; --- Coq ---
(use-package proof-general
  :mode ("\\.v\\'" . coq-mode)
  :custom (proof-splash-enable nil)
  :hook (coq-mode . (lambda () (my/eglot-ensure-when-executable "coq-lsp"))))

;; --- Lean 4 (not on MELPA; install via package-vc) ---
(when (executable-find "lean")
  (unless (package-installed-p 'lean4-mode)
    (package-vc-install "https://github.com/leanprover-community/lean4-mode"))
  (use-package lean4-mode
    :ensure nil
    :mode "\\.lean\\'"
    :commands lean4-mode))

;; --- Agda ---
(let ((agda-mode-path
       (when (executable-find "agda-mode")
         (ignore-errors
           (car (split-string
                 (shell-command-to-string "agda-mode locate") "\n"))))))
  (when (and agda-mode-path (file-exists-p agda-mode-path))
    (load-file agda-mode-path)))

;; --- Lisp / Scheme (built-in) ---
(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)

;; --- Markdown ---
(use-package markdown-mode
  :mode ("\\.md\\'" "\\.markdown\\'")
  :hook (markdown-mode . visual-line-mode))

;; --- YAML ---
(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(provide 'el-languages)
;;; el-languages.el ends here
