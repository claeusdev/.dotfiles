;;; el-packages.el --- Package management -*- lexical-binding: t; -*-

;;; Code:

;; Configure package archives
(require 'package)
(setq package-archives
      '(("melpa"    . "https://melpa.org/packages/")
        ("gnu"      . "https://elpa.gnu.org/packages/")
        ("nongnu"   . "https://elpa.nongnu.org/nongnu/")))

;; Allow unsigned packages — avoids GPG keyring bootstrap issues
(setq package-gnupghome-dir (expand-file-name "gnupg" package-user-dir))
(setq package-check-signature 'allow-unsigned)

(package-initialize)

;; Bootstrap use-package (built into Emacs 29+)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'el-packages)
;;; el-packages.el ends here
