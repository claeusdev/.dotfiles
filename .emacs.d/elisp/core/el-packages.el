;;; --- 3. PACKAGE SYSTEM ---
(require 'package)
(require 'seq)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa")))

(package-initialize)

(defun my/packages-archive-stale-p ()
  "Return non-nil if package archive metadata is missing or older than 24h."
  (let* ((max-age-seconds (* 24 60 60))
         (archive-files
          (mapcar
           (lambda (archive)
             (expand-file-name
              (format "elpa/archives/%s/archive-contents" (car archive))
              user-emacs-directory))
           package-archives)))
    (or (null package-archive-contents)
        (seq-some
         (lambda (file)
           (or (not (file-exists-p file))
               (> (float-time
                   (time-subtract
                    (current-time)
                    (file-attribute-modification-time (file-attributes file))))
                  max-age-seconds)))
         archive-files))))

(when (my/packages-archive-stale-p)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (condition-case nil
      (package-install 'use-package)
    (error
     ;; Retry once after a forced refresh in case archive metadata was stale.
     (package-refresh-contents)
     (package-install 'use-package))))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'el-packages)
