;;; completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

;;; Commentary:
;; Vertico + Orderless + Marginalia + Consult for the minibuffer; Corfu + Cape
;; in the buffer.  Embark supplies context actions over both.

;;; Code:

(defun my/setup-prog-completion ()
  "Add supplemental completion sources to programming buffers."
  (setq-local completion-cycle-threshold 3
              tab-always-indent 'complete)
  (add-hook 'completion-at-point-functions #'cape-file nil t)
  (add-hook 'completion-at-point-functions #'cape-dabbrev t t))

(defun my/setup-text-completion ()
  "Add supplemental completion sources to text buffers."
  (setq-local completion-cycle-threshold 3
              tab-always-indent 'complete)
  (add-hook 'completion-at-point-functions #'cape-dabbrev nil t)
  (add-hook 'completion-at-point-functions #'cape-file t t))

;; --- Minibuffer ----------------------------------------------------------

(use-package vertico
  :init (vertico-mode)
  :custom (vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format
        xref-show-definitions-function #'consult-xref
        xref-show-xrefs-function #'consult-xref)
  :bind
  (("C-x b" . consult-buffer)
   ("M-y"   . consult-yank-pop)
   ("M-g g" . consult-goto-line)
   ("M-g i" . consult-imenu)
   ("M-g o" . consult-outline)))

(use-package embark
  :bind
  (("C-."   . embark-act)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; --- In-buffer -----------------------------------------------------------

;; TAB cycles candidates, RET inserts.  Snippet-free, so TAB never fights
;; indentation the way a yasnippet binding would.
(use-package corfu
  :init (global-corfu-mode)
  :bind (:map corfu-map
         ("TAB"     . corfu-next)
         ([tab]     . corfu-next)
         ("S-TAB"   . corfu-previous)
         ([backtab] . corfu-previous))
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current 'insert)
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-min-width 30)
  (corfu-max-width 90)
  (corfu-count 14)
  :config
  (corfu-history-mode 1)
  (corfu-popupinfo-mode 1))

(use-package cape
  :init
  (add-hook 'prog-mode-hook #'my/setup-prog-completion)
  (add-hook 'text-mode-hook #'my/setup-text-completion))

(use-package nerd-icons-completion
  :if my/nerd-font-installed-p
  :after marginalia
  :config (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :if my/nerd-font-installed-p
  :after corfu
  :config (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(provide 'completion)
;;; completion.el ends here
