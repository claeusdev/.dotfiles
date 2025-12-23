;; Web, GraphQL, and SQL modes
(use-package web-mode
  :ensure t
  :mode (("\.html?\'" . web-mode)
         ("\.jsx\\'" . web-mode)))
(use-package astro-mode
  :ensure nil
  :mode ("\.astro\\'" . astro-mode)
  :config
  (define-derived-mode astro-mode web-mode "astro"))

(use-package graphql-mode
  :ensure t
  :mode ("\.graphql\\'" . graphql-mode)
  :hook (graphql-mode . eglot-ensure))

(use-package sql
  :ensure nil ; Built-in
  :mode ("\.sql\\'" . sql-mode)
  :hook (sql-mode . eglot-ensure))

;; Elixir, Ruby, and Rails modes
(use-package elixir-mode
  :ensure t
  :mode "\.exs?\'")

(use-package ruby-mode
  :ensure nil ; Built-in
  :mode "\.rb\'")

(use-package rust-ts-mode
  :ensure t
  :mode ("\.rs\\'" . rust-ts-mode)
  :hook (rust-ts-mode . eglot-ensure))

(use-package go-mode
  :ensure t
  :mode "\.go\'")

(use-package projectile-rails
  :ensure t
  :after projectile
  :config (projectile-rails-global-mode))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-language-source-alist
        '((rust "https://github.com/tree-sitter/tree-sitter-rust")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (haskell "https://github.com/tree-sitter/tree-sitter-haskell")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
  (global-treesit-auto-mode))

;;; --- 8. OCAML CONFIGURATION ---
(use-package tuareg
  :mode ("\.ml[ily]?\\'" . tuareg-mode))

;; Ensure Opam environment is loaded into Emacs
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; Use your existing opam-user-setup if needed
(let ((opam-share (ignore-errors (car (process-lines "opam" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" "Merlin mode" t)
    (add-hook 'tuareg-mode-hook 'merlin-mode)
    (add-hook 'caml-mode-hook 'merlin-mode)))

;; Load OPAM setup if it exists
(let ((opam-setup (expand-file-name "~/.emacs.d/opam-user-setup.el")))
  (when (file-exists-p opam-setup)
    (load opam-setup)))

(provide 'el-languages)
