;;; el-packages.el --- Package management -*- lexical-binding: t; -*-

;;; Code:

;; Configure package archives
(require 'package)
(setq package-archives
      '(("melpa"    . "https://melpa.org/packages/")
        ("gnu"      . "https://elpa.gnu.org/packages/")
        ("nongnu"   . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

;; Bootstrap use-package (built into Emacs 29+)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'el-packages)
;;; el-packages.el ends here
