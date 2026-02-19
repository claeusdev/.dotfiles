;;; el-latex.el --- LaTeX configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . LaTeX-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil) ; query for master file
  (TeX-PDF-mode t)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-start-server t)
  :config
  ;; Viewer: Skim on macOS, Zathura on Linux
  (cond
   ((eq system-type 'darwin)
    (setq TeX-view-program-selection '((output-pdf "Skim"))
          TeX-view-program-list
          '(("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b"))))
   (t
    (setq TeX-view-program-selection '((output-pdf "Zathura"))))))

;; PDF Tools
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

;; CDLaTeX
(use-package cdlatex
  :hook ((LaTeX-mode . cdlatex-mode)
         (org-mode . org-cdlatex-mode)))

(provide 'el-latex)
;;; el-latex.el ends here
