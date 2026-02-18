;;; el-languages.el --- Language-specific modes and tooling -*- lexical-binding: t; -*-

(defun my/eglot-ensure-local ()
  "Start Eglot only for local projects."
  (unless (file-remote-p default-directory)
    (eglot-ensure)))

(defun my/sml-maybe-eglot ()
  "Start SML LSP only when Millet is available."
  (when (executable-find "millet-ls")
    (my/eglot-ensure-local)))

(defun my/lean-installed-p ()
  "Return non-nil when Lean and `lean4-mode` are installed."
  (and (executable-find "lean")
       (locate-library "lean4-mode")))

(defun my/coq-installed-p ()
  "Return non-nil when Coq and Proof General are installed."
  (and (executable-find "coqtop")
       (or (locate-library "proof-site")
           (locate-library "proof-general"))))

(defun my/sml-installed-p ()
  "Return non-nil when SML and `sml-mode` are installed."
  (and (executable-find "sml")
       (locate-library "sml-mode")))

(defun my/setup-agda-mode ()
  "Load Agda mode from `agda-mode locate` when available."
  (let* ((agda-mode-bin (executable-find "agda-mode"))
         (agda-mode-file
          (when agda-mode-bin
            (ignore-errors (car (process-lines agda-mode-bin "locate"))))))
    (when (and agda-mode-file (file-readable-p agda-mode-file))
      (load-file agda-mode-file)
      (add-to-list 'auto-mode-alist '("\\.agda\\'" . agda2-mode))
      (add-to-list 'auto-mode-alist '("\\.lagda\\'" . agda2-mode))
      (add-to-list 'auto-mode-alist '("\\.lagda\\.md\\'" . agda2-mode))
      t)))

;; Web and SQL modes
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.tsx\\'" . web-mode))
  :hook (web-mode . my/eglot-ensure-local)
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-css-colorization t
        web-mode-enable-current-element-highlight t
        web-mode-enable-current-column-highlight t
        web-mode-content-types-alist
        '(("jsx" . "\\.jsx?\\'")
          ("tsx" . "\\.tsx?\\'"))))

;; TypeScript and JavaScript
(use-package typescript-mode
  :ensure t
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.mts\\'" . typescript-mode))
  :hook (typescript-mode . my/eglot-ensure-local)
  :config
  (setq typescript-indent-level 2))

;; Use tree-sitter modes for JS when available.
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode))
(add-hook 'js-ts-mode-hook #'my/eglot-ensure-local)
(setq js-indent-level 2)

;; Emmet mode for HTML/JSX expansion
(use-package emmet-mode
  :ensure t
  :hook ((web-mode . emmet-mode)
         (css-mode . emmet-mode)
         (typescript-mode . emmet-mode)
         (js-ts-mode . emmet-mode))
  :config
  (setq emmet-expand-jsx-className? t
        emmet-self-closing-tag-style " /"))

;; Prettier integration for code formatting
(use-package prettier-js
  :ensure t
  :hook ((web-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode)
         (js-ts-mode . prettier-js-mode)
         (css-mode . prettier-js-mode))
  :config
  (setq prettier-js-args '("--single-quote" "--jsx-single-quote")))

;; Python
(use-package python
  :ensure nil ; Built-in
  :mode ("\\.py\\'" . python-ts-mode)
  :hook (python-ts-mode . my/eglot-ensure-local)
  :config
  (setq python-indent-offset 4))

;; CSS
(use-package css-mode
  :ensure nil ; Built-in
  :mode "\\.css\\'"
  :hook (css-mode . my/eglot-ensure-local))

;; YAML
(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'"
  :hook (yaml-mode . my/eglot-ensure-local))

(use-package sql
  :ensure nil ; Built-in
  :mode ("\\.sql\\'" . sql-mode)
  :hook (sql-mode . my/eglot-ensure-local))

;; Elixir mode
(use-package elixir-mode
  :ensure t
  :mode "\\.exs?\\'")

;; Use tree-sitter Rust mode when available, otherwise fall back to rust-mode.
(if (fboundp 'rust-ts-mode)
    (progn
      (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
      (add-hook 'rust-ts-mode-hook #'my/eglot-ensure-local))
  (use-package rust-mode
    :ensure t
    :mode "\\.rs\\'"
    :hook (rust-mode . my/eglot-ensure-local)))

;; C/C++ with tree-sitter
(use-package c-ts-mode
  :ensure nil ; Built-in
  :mode (("\\.c\\'" . c-ts-mode)
         ("\\.h\\'" . c-ts-mode)
         ("\\.cpp\\'" . c++-ts-mode)
         ("\\.cc\\'" . c++-ts-mode)
         ("\\.cxx\\'" . c++-ts-mode)
         ("\\.hpp\\'" . c++-ts-mode)
         ("\\.hxx\\'" . c++-ts-mode))
  :hook ((c-ts-mode . my/eglot-ensure-local)
         (c++-ts-mode . my/eglot-ensure-local))
  :config
  (setq c-ts-mode-indent-offset 4
        c-ts-mode-indent-style 'linux))

;; Functional languages - ML family
(my/setup-agda-mode)

(use-package elm-mode
  :ensure t
  :mode "\\.elm\\'"
  :hook (elm-mode . my/eglot-ensure-local))

(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :hook ((haskell-mode . my/eglot-ensure-local)
         (haskell-mode . interactive-haskell-mode))
  :config
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t))

;; Functional languages - Lisp family
(define-derived-mode racket-mode scheme-mode "Racket"
  "Major mode for Racket programming language."
  (setq-local comment-start ";")
  (setq-local comment-end ""))
(add-to-list 'auto-mode-alist '("\\.rkt\\'" . racket-mode))
(add-hook 'racket-mode-hook #'my/eglot-ensure-local)

(use-package scheme-mode
  :ensure nil ; Built-in
  :mode "\\.scm\\'")

;; Functional languages - BEAM ecosystem
(use-package erlang
  :ensure t
  :mode ("\\.erl\\'" "\\.hrl\\'")
  :hook (erlang-mode . my/eglot-ensure-local))

;; Functional languages - Other
(use-package lean4-mode
  :if (my/lean-installed-p)
  :ensure nil
  :mode "\\.lean\\'")

(use-package proof-general
  :if (my/coq-installed-p)
  :ensure nil
  :defer t
  :init
  (setq proof-splash-enable nil))

(when (my/coq-installed-p)
  (add-to-list 'auto-mode-alist '("\\.v\\'" . coq-mode)))

(use-package sml-mode
  :if (my/sml-installed-p)
  :ensure nil
  :mode (("\\.sml\\'" . sml-mode)
         ("\\.sig\\'" . sml-mode)
         ("\\.fun\\'" . sml-mode)
         ("\\.cm\\'" . sml-mode))
  :hook (sml-mode . my/sml-maybe-eglot)
  :config
  (setq sml-indent-level 2))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :hook (nix-mode . my/eglot-ensure-local))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-language-source-alist
        '(;; Systems languages
          (rust "https://github.com/tree-sitter/tree-sitter-rust")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")

          ;; Web languages
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (css "https://github.com/tree-sitter/tree-sitter-css")

          ;; Data formats
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (yaml "https://github.com/tree-sitter/tree-sitter-yaml")
          (toml "https://github.com/tree-sitter/tree-sitter-toml")
          (markdown "https://github.com/ikatyang/tree-sitter-markdown")

          ;; Scripting languages
          (lua "https://github.com/tree-sitter/tree-sitter-lua")
          (vim "https://github.com/tree-sitter/tree-sitter-vim")
          (bash "https://github.com/tree-sitter/tree-sitter-bash")
          (python "https://github.com/tree-sitter/tree-sitter-python")

          ;; Functional languages - ML family
          (ocaml "https://github.com/tree-sitter/tree-sitter-ocaml" "master" "ocaml/src")
          (ocaml-interface "https://github.com/tree-sitter/tree-sitter-ocaml" "master" "interface/src")
          (haskell "https://github.com/tree-sitter/tree-sitter-haskell")
          (elm "https://github.com/elm-tooling/tree-sitter-elm")

          ;; Functional languages - Lisp family
          (racket "https://github.com/6cdh/tree-sitter-racket")
          (scheme "https://github.com/6cdh/tree-sitter-scheme")
          (commonlisp "https://github.com/theHamsta/tree-sitter-commonlisp")

          ;; Functional languages - BEAM ecosystem
          (erlang "https://github.com/WhatsApp/tree-sitter-erlang")
          (elixir "https://github.com/elixir-lang/tree-sitter-elixir")
          (heex "https://github.com/phoenixframework/tree-sitter-heex")

          ;; Functional languages - Other
          (nix "https://github.com/nix-community/tree-sitter-nix")))
  (global-treesit-auto-mode))

;;; --- 8. OCAML CONFIGURATION ---
(use-package tuareg
  :mode ("\\.ml[ily]?\\'" . tuareg-mode)
  :hook (tuareg-mode . my/eglot-ensure-local))

;; OCaml project files.
(add-to-list 'auto-mode-alist '("dune\\'" . tuareg-mode))
(add-to-list 'auto-mode-alist '("dune-project\\'" . tuareg-mode))

;; Use your existing opam setup if available.
(let ((opam-share (ignore-errors (car (process-lines "opam" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" "Merlin mode" t)
    (add-hook 'tuareg-mode-hook 'merlin-mode)
    (add-hook 'caml-mode-hook 'merlin-mode)))

(provide 'el-languages)
;;; el-languages.el ends here
