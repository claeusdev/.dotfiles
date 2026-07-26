;;; early-init.el --- Pre-frame initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; Runs before init.el and before the first frame is drawn.  Keep it small:
;; anything that does not have to happen this early belongs in elisp/core.el.

;;; Code:

;; Raise the GC ceiling for startup; core.el restores a working value once the
;; session is up.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; use-package drives installation, so package.el must not activate first.
(setq package-enable-at-startup nil)

;; Drop UI chrome before the first frame renders, to avoid a visible reflow.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Default frame geometry, measured in characters rather than pixels.
;; `fill-column' is 100, so 120 columns fits a full-width line alongside the
;; line numbers and the fill indicator.  For a maximized frame instead, use
;; (push '(fullscreen . maximized) default-frame-alist).
(push '(width  . 120) default-frame-alist)
(push '(height . 45)  default-frame-alist)

(setq inhibit-splash-screen t
      inhibit-startup-message t
      frame-inhibit-implied-resize t)

;; `native-comp-deferred-compilation' was renamed in Emacs 29.1.  Note that a
;; stock Homebrew `emacs' build has no native compilation at all; `emacs-plus'
;; with --with-native-comp does.
(when (and (fboundp 'native-comp-available-p) (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-jit-compilation t))

(provide 'early-init)
;;; early-init.el ends here
