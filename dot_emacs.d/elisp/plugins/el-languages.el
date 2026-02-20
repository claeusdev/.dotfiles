;;; el-languages.el --- Programming language modes -*- lexical-binding: t; -*-

;;; Code:

;; --- Tree-sitter readiness ---
(defun my/treesit-available-p (lang)
  "Check if tree-sitter is available for LANG."
  (and (fboundp 'treesit-ready-p)
       (treesit-ready-p lang t)))

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
      :hook ((c-ts-mode . (lambda () (my/eglot-ensure-when-executable "clangd")))
             (c++-ts-mode . (lambda () (my/eglot-ensure-when-executable "clangd")))))
  ;; Fallback without tree-sitter
  (add-hook 'c-mode-hook (lambda ()
                           (setq c-basic-offset 4)
                           (my/eglot-ensure-when-executable "clangd")))
  (add-hook 'c++-mode-hook (lambda ()
                              (setq c-basic-offset 4)
                              (my/eglot-ensure-when-executable "clangd"))))

;; --- Python ---
(if (my/treesit-available-p 'python)
    (use-package python
      :ensure nil
      :mode ("\\.py\\'" . python-ts-mode)
      :custom (python-indent-offset 4))
  (use-package python
    :ensure nil
    :mode ("\\.py\\'" . python-mode)
    :custom (python-indent-offset 4)))

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
      :hook (rust-ts-mode . (lambda () (my/eglot-ensure-when-executable "rust-analyzer"))))
  (use-package rust-mode
    :mode "\\.rs\\'"
    :custom (rust-format-on-save t)
    :hook (rust-mode . (lambda () (my/eglot-ensure-when-executable "rust-analyzer")))))

(use-package cargo
  :hook ((rust-mode . cargo-minor-mode)
         (rust-ts-mode . cargo-minor-mode)))

;; --- OCaml ---
(use-package tuareg
  :hook (tuareg-mode . (lambda () (my/eglot-ensure-when-executable "ocamllsp"))))

(use-package merlin
  :after tuareg
  :hook (tuareg-mode . merlin-mode))

;; --- Haskell ---
(use-package haskell-mode
  :hook ((haskell-mode . interactive-haskell-mode)
         (haskell-mode . (lambda () (my/eglot-ensure-when-executable "haskell-language-server-wrapper")))))

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
  :mode ("\\.md\\'" "\\.markdown\\'"))

;; --- YAML ---
(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(provide 'el-languages)
;;; el-languages.el ends here
