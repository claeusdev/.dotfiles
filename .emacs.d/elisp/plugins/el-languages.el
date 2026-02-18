;;; el-languages.el --- Language-specific modes and tooling -*- lexical-binding: t; -*-

(defun my/eglot-ensure-local ()
  "Start Eglot only for local projects."
  (unless (file-remote-p default-directory)
    (eglot-ensure)))

(defun my/sml-maybe-eglot ()
  "Start SML LSP only when Millet is available."
  (when (executable-find "millet-ls")
    (my/eglot-ensure-local)))

(defun my/treesit-ready-p (language)
  "Return non-nil when tree-sitter LANGUAGE grammar is available."
  (and (fboundp 'treesit-available-p)
       (treesit-available-p)
       (fboundp 'treesit-ready-p)
       (treesit-ready-p language t)))

(defun my/c-or-c-ts-mode ()
  "Use `c-ts-mode' when ready, otherwise fall back to `c-mode'."
  (if (my/treesit-ready-p 'c)
      (c-ts-mode)
    (c-mode)))

(defun my/cpp-or-cpp-ts-mode ()
  "Use `c++-ts-mode' when ready, otherwise fall back to `c++-mode'."
  (if (my/treesit-ready-p 'cpp)
      (c++-ts-mode)
    (c++-mode)))

(defun my/proof-general-load ()
  "Load Proof General if available."
  (or (featurep 'proof-general)
      (featurep 'proof-site)
      (require 'proof-site nil t)
      (require 'proof-general nil t)))

(defun my/coq-file-mode ()
  "Open Coq files using Proof General when available."
  (interactive)
  (my/proof-general-load)
  (if (fboundp 'coq-mode)
      (coq-mode)
    (fundamental-mode)))

(defun my/isabelle-file-mode ()
  "Open Isabelle theory files using Proof General when available."
  (interactive)
  (my/proof-general-load)
  (cond
   ((fboundp 'isar-mode) (isar-mode))
   ((fboundp 'isabelle-mode) (isabelle-mode))
   (t (fundamental-mode))))

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

(defun my/python-or-python-ts-mode ()
  "Use `python-ts-mode' when ready, otherwise fall back to `python-mode'."
  (if (my/treesit-ready-p 'python)
      (python-ts-mode)
    (python-mode)))

(defun my/lean-installed-p ()
  "Return non-nil when Lean and `lean4-mode` are installed."
  (and (executable-find "lean")
       (locate-library "lean4-mode")))

;;; C/C++
(add-to-list 'auto-mode-alist '("\\.c\\'" . my/c-or-c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . my/c-or-c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . my/cpp-or-cpp-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . my/cpp-or-cpp-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cxx\\'" . my/cpp-or-cpp-ts-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . my/cpp-or-cpp-ts-mode))
(add-to-list 'auto-mode-alist '("\\.hxx\\'" . my/cpp-or-cpp-ts-mode))
(add-hook 'c-mode-hook #'my/eglot-ensure-local)
(add-hook 'c++-mode-hook #'my/eglot-ensure-local)
(add-hook 'c-ts-mode-hook #'my/eglot-ensure-local)
(add-hook 'c++-ts-mode-hook #'my/eglot-ensure-local)
(setq c-basic-offset 4
      c-ts-mode-indent-offset 4)

;;; OCaml
(use-package tuareg
  :ensure t
  :mode ("\\.ml[ily]?\\'" . tuareg-mode)
  :hook (tuareg-mode . my/eglot-ensure-local))

(add-to-list 'auto-mode-alist '("dune\\'" . tuareg-mode))
(add-to-list 'auto-mode-alist '("dune-project\\'" . tuareg-mode))

;; Use OPAM Merlin integration if available.
(let ((opam-share (ignore-errors (car (process-lines "opam" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" "Merlin mode" t)
    (add-hook 'tuareg-mode-hook 'merlin-mode)
    (add-hook 'caml-mode-hook 'merlin-mode)))

;;; Standard ML
(use-package sml-mode
  :ensure t
  :mode (("\\.sml\\'" . sml-mode)
         ("\\.sig\\'" . sml-mode)
         ("\\.fun\\'" . sml-mode)
         ("\\.cm\\'" . sml-mode))
  :hook (sml-mode . my/sml-maybe-eglot)
  :config
  (setq sml-indent-level 2))

;;; Lisp + Racket
(use-package lisp-mode
  :ensure nil
  :mode (("\\.lisp\\'" . lisp-mode)
         ("\\.lsp\\'" . lisp-mode)
         ("\\.cl\\'" . lisp-mode)))

(use-package scheme
  :ensure nil
  :mode "\\.scm\\'")

(define-derived-mode racket-mode scheme-mode "Racket"
  "Major mode for Racket source files."
  (setq-local comment-start ";")
  (setq-local comment-end ""))

(add-to-list 'auto-mode-alist '("\\.rkt\\'" . racket-mode))
(add-hook 'racket-mode-hook #'my/eglot-ensure-local)

;;; Haskell
(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :hook ((haskell-mode . my/eglot-ensure-local)
         (haskell-mode . interactive-haskell-mode))
  :config
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t))

;;; Lean + Nix
(use-package lean4-mode
  :if (my/lean-installed-p)
  :ensure nil
  :mode "\\.lean\\'")

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :hook (nix-mode . my/eglot-ensure-local))

;;; Coq + Isabelle (Proof General)
(use-package proof-general
  :ensure t
  :defer t
  :init
  (setq proof-splash-enable nil))

(add-to-list 'auto-mode-alist '("\\.v\\'" . my/coq-file-mode))
(add-to-list 'auto-mode-alist '("\\.thy\\'" . my/isabelle-file-mode))
(add-hook 'coq-mode-hook #'my/eglot-ensure-local)

;;; Python
(add-to-list 'auto-mode-alist '("\\.py\\'" . my/python-or-python-ts-mode))
(add-hook 'python-mode-hook #'my/eglot-ensure-local)
(add-hook 'python-ts-mode-hook #'my/eglot-ensure-local)

;;; Julia
(use-package julia-mode
  :ensure t
  :mode "\\.jl\\'"
  :hook (julia-mode . my/eglot-ensure-local))

;;; Agda
(my/setup-agda-mode)

(provide 'el-languages)
;;; el-languages.el ends here
