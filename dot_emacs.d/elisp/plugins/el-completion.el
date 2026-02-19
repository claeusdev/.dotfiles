;;; el-completion.el --- Completion framework -*- lexical-binding: t; -*-

;;; Code:

;; Vertico — vertical minibuffer completion
(use-package vertico
  :init (vertico-mode)
  :custom
  (vertico-cycle t))

;; Orderless — flexible matching
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

;; Marginalia — rich annotations in the minibuffer
(use-package marginalia
  :init (marginalia-mode))

;; Consult — search and navigation commands
(use-package consult
  :bind
  (("M-s l" . consult-line)
   ("M-y"   . consult-yank-pop)
   ("C-x b" . consult-buffer)
   ("M-s r" . consult-ripgrep)
   ("M-s f" . consult-find)
   ("M-g g" . consult-goto-line)
   ("M-g i" . consult-imenu)))

;; Embark — context actions
(use-package embark
  :bind
  (("C-."   . embark-act)
   ("M-."   . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Corfu — in-buffer completion
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :init (global-corfu-mode))

;; Cape — completion-at-point extensions
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; Nerd icons for completion UI
(use-package nerd-icons-completion
  :after marginalia
  :config (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(provide 'el-completion)
;;; el-completion.el ends here
