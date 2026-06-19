;;; el-completion.el --- Completion framework -*- lexical-binding: t; -*-

;;; Code:

(defun my/add-capf-local (fn append)
  "Add FN buffer-locally to `completion-at-point-functions' if available.
When APPEND is non-nil, add FN at the end of the local hook list."
  (when (fboundp fn)
    (add-hook 'completion-at-point-functions fn append t)))

(defun my/setup-prog-completion ()
  "Add lightweight supplemental completion sources to programming buffers."
  (setq-local completion-cycle-threshold 3
              tab-always-indent 'complete)
  (my/add-capf-local #'cape-file nil)
  (my/add-capf-local #'cape-dabbrev t))

(defun my/setup-text-completion ()
  "Add lightweight completion sources to text buffers."
  (setq-local completion-cycle-threshold 3
              tab-always-indent 'complete)
  (my/add-capf-local #'cape-dabbrev nil)
  (my/add-capf-local #'cape-file t))

(defun my/nerd-font-available-p ()
  "Return non-nil when a Nerd Font is installed for completion icons."
  (or (bound-and-true-p my/nerd-font-installed-p)
      (seq-some (lambda (family)
                  (string-match-p "Nerd Font" family))
                (font-family-list))))

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
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format
        xref-show-definitions-function #'consult-xref
        xref-show-xrefs-function #'consult-xref)
  :bind
  (("M-s l" . consult-line)
   ("M-y"   . consult-yank-pop)
   ("C-x b" . consult-buffer)
   ("M-s r" . consult-ripgrep)
   ("M-s f" . consult-find)
   ("M-s g" . consult-grep)
   ("M-g g" . consult-goto-line)
   ("M-g i" . consult-imenu)
   ("M-g o" . consult-outline)
   ("C-c b" . consult-bookmark)))

;; Embark — context actions
(use-package embark
  :bind
  (("C-."   . embark-act)
   ("M-."   . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Corfu — in-buffer completion.  TAB cycles candidates; RET inserts.
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
  (corfu-count 14))

(with-eval-after-load 'corfu
  (require 'corfu-history nil t)
  (require 'corfu-popupinfo nil t)
  (when (fboundp 'corfu-history-mode)
    (corfu-history-mode 1))
  (when (fboundp 'corfu-popupinfo-mode)
    (corfu-popupinfo-mode 1)))

;; Cape — completion-at-point extensions
(use-package cape
  :init
  (add-hook 'prog-mode-hook #'my/setup-prog-completion)
  (add-hook 'text-mode-hook #'my/setup-text-completion))

;; Nerd icons for completion UI
(use-package nerd-icons-completion
  :if (my/nerd-font-available-p)
  :after marginalia
  :config (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :if (my/nerd-font-available-p)
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(provide 'el-completion)
;;; el-completion.el ends here
