;;; init.el --- Emacs configuration entry point -*- lexical-binding: t; -*-

;;; Code:

;; Add module directories to load-path
(add-to-list 'load-path (expand-file-name "elisp/core" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "elisp/plugins" user-emacs-directory))

;; Machine-local overrides that should not live in shared dotfiles.
(let ((local-pre (expand-file-name "local-pre.el" user-emacs-directory)))
  (when (file-exists-p local-pre)
    (load local-pre nil 'nomessage)))

;; Load modules in order (bindings last so all mode maps are available)
(require 'el-packages)
(require 'el-core)
(require 'el-theme)
(require 'el-completion)
(require 'el-git)
(require 'el-lsp)
(require 'el-languages)
(require 'el-org)
(require 'el-latex)
(require 'el-tools)
(require 'el-dap)
(require 'el-bindings)

;; Load OPAM setup if present
(let ((opam-setup (expand-file-name "opam-user-setup.el" user-emacs-directory)))
  (when (file-exists-p opam-setup)
    (load opam-setup nil 'nomessage)))

;; Send custom-set-variables to a separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

(let ((local-post (expand-file-name "local-post.el" user-emacs-directory)))
  (when (file-exists-p local-post)
    (load local-post nil 'nomessage)))

(provide 'init)
;;; init.el ends here
