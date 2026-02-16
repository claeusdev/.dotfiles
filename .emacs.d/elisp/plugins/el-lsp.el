;;; --- 7. LSP (EGLOT) ---
;; NOTE: You need to install the language servers for eglot to work.
;; For example, for rust, you would run: rustup component add rust-analyzer
;; To enable LSP for a specific mode, use M-x eglot or add hooks for specific modes

(defconst my/ocaml-lsp-command
  (or (executable-find "ocamllsp")
      (executable-find "ocaml-lsp-server")
      "ocamllsp")
  "Preferred OCaml language server command.")

(defconst my/haskell-lsp-command
  (or (executable-find "haskell-language-server-wrapper")
      "haskell-language-server-wrapper")
  "Preferred Haskell language server command.")

(use-package consult-eglot
  :ensure t
  :after (consult eglot))

(use-package eglot
  :ensure nil ; Built-in
  :commands (eglot eglot-ensure)
  ;; Optional: uncomment specific hooks for modes you actively use
  ;; :hook ((rust-mode rust-ts-mode) . eglot-ensure)
  ;; :hook ((python-mode python-ts-mode) . eglot-ensure)
  :config
  ;; Better throughput for language servers during large typechecks/indexing.
  (setq read-process-output-max (* 1024 1024))

  (add-to-list 'eglot-server-programs '(elixir-mode . ("elixir-ls")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(rust-ts-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs `(haskell-mode . (,my/haskell-lsp-command "--lsp")))
  (add-to-list 'eglot-server-programs `(haskell-ts-mode . (,my/haskell-lsp-command "--lsp")))
  (add-to-list 'eglot-server-programs '(js-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(js-ts-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(typescript-ts-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(tsx-ts-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(web-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '((c-mode c++-mode) . ("clangd")))
  (add-to-list 'eglot-server-programs '((c-ts-mode c++-ts-mode) . ("clangd")))
  (add-to-list 'eglot-server-programs `(tuareg-mode . (,my/ocaml-lsp-command)))
  (add-to-list 'eglot-server-programs `(tuareg-ts-mode . (,my/ocaml-lsp-command)))
  (add-to-list 'eglot-server-programs '(sql-mode . ("sqls")))

  ;; Web/Data languages
  (add-to-list 'eglot-server-programs '(css-mode . ("vscode-css-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(yaml-mode . ("yaml-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(python-ts-mode . ("pyright-langserver" "--stdio")))
  
  ;; Functional languages - ML family
  (add-to-list 'eglot-server-programs '(elm-mode . ("elm-language-server")))
  
  ;; Functional languages - Lisp family
  (add-to-list 'eglot-server-programs '(racket-mode . ("racket-langserver")))
  
  ;; Functional languages - Other
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))

  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0
        eglot-send-changes-idle-time 0.1
        eglot-hover-eldoc-documentation t
        eldoc-echo-area-use-multiline-p t)
  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l r" . eglot-rename)
              ("C-c l d" . eglot-find-declaration)
              ("C-c l i" . eglot-find-implementation)
              ("C-c l t" . eglot-find-type-definition)
              ("C-c l s" . consult-eglot-symbols)))

(provide 'el-lsp)
