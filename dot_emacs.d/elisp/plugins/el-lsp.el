;;; el-lsp.el --- Eglot LSP configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package eglot
  :ensure nil ; built-in
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size (* 1024 1024))
  (eglot-send-changes-idle-time 0.1)
  :config
  ;; Server table
  (add-to-list 'eglot-server-programs '((c-mode c++-mode c-ts-mode c++-ts-mode) . ("clangd")))
  (add-to-list 'eglot-server-programs '(tuareg-mode . ("ocamllsp")))
  (add-to-list 'eglot-server-programs '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
  (add-to-list 'eglot-server-programs '(sml-mode . ("millet-ls")))
  (add-to-list 'eglot-server-programs '(racket-mode . ("racket-langserver")))
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(coq-mode . ("coq-lsp")))
  (add-to-list 'eglot-server-programs '((rust-mode rust-ts-mode) . ("rust-analyzer")))

  ;; LSP keybindings
  :bind (:map eglot-mode-map
         ("C-c l a" . eglot-code-actions)
         ("C-c l d" . xref-find-definitions)
         ("C-c l f" . eglot-format)
         ("C-c l r" . eglot-rename)
         ("C-c l i" . eglot-find-implementation)
         ("C-c l t" . eglot-find-typeDefinition)
         ("C-c l D" . xref-find-references)))

(defun my/eglot-ensure-when-executable (cmd)
  "Add `eglot-ensure' to the current mode hook only if CMD is on PATH."
  (when (executable-find cmd)
    (eglot-ensure)))

(provide 'el-lsp)
;;; el-lsp.el ends here
