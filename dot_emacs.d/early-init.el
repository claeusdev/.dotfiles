;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; Runs before init.el. Optimizes startup and disables UI chrome early.

;;; Code:

;; Maximize GC threshold during startup (reset later in el-core.el)
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Prevent package.el from loading packages before use-package
(setq package-enable-at-startup nil)

;; Disable UI elements before first frame renders
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-splash-screen t
      inhibit-startup-message t)

;; Native compilation settings
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-deferred-compilation t))

;; Prevent frame resizing when setting font
(setq frame-inhibit-implied-resize t)

(provide 'early-init)
;;; early-init.el ends here
