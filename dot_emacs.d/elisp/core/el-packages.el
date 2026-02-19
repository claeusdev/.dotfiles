;;; el-packages.el --- Package bootstrap -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

(provide 'el-packages)
;;; el-packages.el ends here
