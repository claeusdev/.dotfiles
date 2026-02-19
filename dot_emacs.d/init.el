;;; init.el --- Minimal Emacs configuration -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "elisp/core" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "elisp/plugins" user-emacs-directory))

(require 'el-packages)
(require 'el-core)
(require 'el-theme)
(require 'el-lsp)
(require 'el-languages)
(require 'el-bindings)

;; Load OPAM setup if present.
(let ((opam-setup (expand-file-name "opam-user-setup.el" user-emacs-directory)))
  (when (file-exists-p opam-setup)
    (load opam-setup nil 'nomessage)))

(provide 'init)
;;; init.el ends here
