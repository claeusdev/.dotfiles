;;; --- 7. LSP (EGLOT) ---
;; NOTE: You need to install language servers for Eglot to work.

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
  :defer t
  :commands (consult-eglot-symbols))

(use-package eglot
  :ensure nil ; Built-in
  :commands (eglot eglot-ensure)
  :config
  ;; Better throughput for language servers during large typechecks/indexing.
  (setq read-process-output-max (* 1024 1024))

  ;; C/C++
  (add-to-list 'eglot-server-programs '((c-mode c++-mode) . ("clangd")))
  (add-to-list 'eglot-server-programs '((c-ts-mode c++-ts-mode) . ("clangd")))

  ;; OCaml
  (add-to-list 'eglot-server-programs `(tuareg-mode . (,my/ocaml-lsp-command)))
  (add-to-list 'eglot-server-programs `(tuareg-ts-mode . (,my/ocaml-lsp-command)))

  ;; Haskell
  (add-to-list 'eglot-server-programs `(haskell-mode . (,my/haskell-lsp-command "--lsp")))
  (add-to-list 'eglot-server-programs `(haskell-ts-mode . (,my/haskell-lsp-command "--lsp")))

  ;; Nix (optional, if nil is installed)
  (when (executable-find "nil")
    (add-to-list 'eglot-server-programs '(nix-mode . ("nil"))))

  ;; Standard ML (optional, if millet-ls is installed)
  (when (executable-find "millet-ls")
    (add-to-list 'eglot-server-programs '(sml-mode . ("millet-ls"))))

  ;; Racket (optional, if racket-langserver is installed)
  (when (executable-find "racket-langserver")
    (add-to-list 'eglot-server-programs '(racket-mode . ("racket-langserver"))))

  ;; Coq (optional, if coq-lsp is installed)
  (when (executable-find "coq-lsp")
    (add-to-list 'eglot-server-programs '(coq-mode . ("coq-lsp"))))

  ;; Python (pyright preferred, pylsp fallback)
  (cond
   ((executable-find "pyright")
    (add-to-list 'eglot-server-programs '(python-ts-mode . ("pyright" "--stdio")))
    (add-to-list 'eglot-server-programs '(python-mode . ("pyright" "--stdio"))))
   ((executable-find "pylsp")
    (add-to-list 'eglot-server-programs '(python-ts-mode . ("pylsp")))
    (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))))

  ;; Julia (optional, if julia is installed)
  (when (executable-find "julia")
    (add-to-list 'eglot-server-programs
                 '(julia-mode . ("julia" "--startup-file=no" "--history-file=no"
                                 "-e" "using LanguageServer; runserver()"))))

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
