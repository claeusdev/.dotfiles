;;; init.el --- Configuration entry point -*- lexical-binding: t; -*-

;;; Commentary:
;; Modules live in elisp/ and load in dependency order.  keys.el is last so
;; every map it binds into already exists.

;;; Code:

(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))

;; Machine-local overrides that should not live in the dotfiles repo.
(let ((local-pre (expand-file-name "local-pre.el" user-emacs-directory)))
  (when (file-exists-p local-pre)
    (load local-pre nil 'nomessage)))

;; --- Package bootstrap ---------------------------------------------------

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/"))
      ;; Prefer stable GNU/NonGNU where a package exists in both.
      package-archive-priorities '(("gnu" . 3) ("nongnu" . 2) ("melpa" . 1)))

(package-initialize)

;; use-package is built into Emacs since 29; no bootstrap needed.
(require 'use-package)
(setq use-package-always-ensure t)

;; --- Modules -------------------------------------------------------------

(require 'core)
(require 'completion)
(require 'dev)
(require 'langs)
(require 'notes)
(require 'keys)

;; Keep Customize's scribbles out of this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

(let ((local-post (expand-file-name "local-post.el" user-emacs-directory)))
  (when (file-exists-p local-post)
    (load local-post nil 'nomessage)))

(provide 'init)
;;; init.el ends here
