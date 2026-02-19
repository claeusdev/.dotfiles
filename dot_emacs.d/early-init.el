;;; early-init.el --- Pre-init startup optimization -*- lexical-binding: t; -*-

;; Maximize GC threshold during startup for faster load.
(setq gc-cons-threshold most-positive-fixnum)

;; Prevent package.el from loading before elpaca/straight takes over.
(setq package-enable-at-startup nil)

;; Disable UI elements before the first frame is drawn (avoids flash).
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Native compilation settings (Emacs 29+)
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors nil)
  (setq native-comp-deferred-compilation t)
  (setq native-comp-speed 2))

(provide 'early-init)
;;; early-init.el ends here
