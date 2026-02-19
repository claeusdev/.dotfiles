;;; el-latex.el --- LaTeX editing with AUCTeX, pdf-tools, cdlatex -*- lexical-binding: t; -*-

(use-package tex
  :ensure auctex
  :defer t
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-PDF-mode t)
  (setq-default TeX-master nil)
  ;; Viewer: macOS uses `open` (Skim picks up .pdf), Linux uses zathura.
  (setq TeX-view-program-selection
        (if (eq system-type 'darwin)
            '((output-pdf "open"))
          '((output-pdf "Zathura"))))
  (when (eq system-type 'darwin)
    (add-to-list 'TeX-view-program-list '("open" "open %o"))))

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

(use-package cdlatex
  :ensure t
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (org-mode . org-cdlatex-mode)))

(provide 'el-latex)
;;; el-latex.el ends here
