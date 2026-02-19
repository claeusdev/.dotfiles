;;; el-lsp.el --- Eglot configuration -*- lexical-binding: t; -*-

(defconst my/ocaml-lsp-command
  (or (executable-find "ocamllsp")
      (executable-find "ocaml-lsp-server")
      "ocamllsp")
  "Preferred OCaml language server command.")

(defconst my/haskell-lsp-command
  (or (executable-find "haskell-language-server-wrapper")
      "haskell-language-server-wrapper")
  "Preferred Haskell language server command.")

(use-package eglot
  :ensure nil
  :commands (eglot eglot-ensure)
  :config
  (setq read-process-output-max (* 1024 1024)
        eglot-autoshutdown t
        eglot-events-buffer-size 0
        eglot-send-changes-idle-time 0.1)

  ;; C/C++
  (add-to-list 'eglot-server-programs '((c-mode c++-mode c-ts-mode c++-ts-mode) . ("clangd")))

  ;; OCaml
  (add-to-list 'eglot-server-programs `(tuareg-mode . (,my/ocaml-lsp-command)))
  (add-to-list 'eglot-server-programs `(tuareg-ts-mode . (,my/ocaml-lsp-command)))

  ;; Haskell
  (add-to-list 'eglot-server-programs `(haskell-mode . (,my/haskell-lsp-command "--lsp")))
  (add-to-list 'eglot-server-programs `(haskell-ts-mode . (,my/haskell-lsp-command "--lsp")))

  ;; Optional servers
  (when (executable-find "millet-ls")
    (add-to-list 'eglot-server-programs '(sml-mode . ("millet-ls"))))
  (when (executable-find "racket-langserver")
    (add-to-list 'eglot-server-programs '(racket-mode . ("racket-langserver"))))
  (when (executable-find "nil")
    (add-to-list 'eglot-server-programs '(nix-mode . ("nil"))))
  (when (executable-find "coq-lsp")
    (add-to-list 'eglot-server-programs '(coq-mode . ("coq-lsp"))))

  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l d" . xref-find-definitions)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l r" . eglot-rename)
              ("C-c l i" . eglot-find-implementation)
              ("C-c l t" . eglot-find-type-definition)))

(provide 'el-lsp)
;;; el-lsp.el ends here
