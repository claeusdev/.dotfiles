;;; el-completion.el --- Completion framework -*- lexical-binding: t; -*-

;;; Code:

(defun my/corfu-visible-p ()
  "Return non-nil when the Corfu popup is visible."
  (and (boundp 'corfu--frame)
       (frame-live-p corfu--frame)
       (frame-visible-p corfu--frame)))

(defun my/yas-expandable-p ()
  "Return non-nil if a Yasnippet expansion makes sense at point."
  (and (bound-and-true-p yas-minor-mode)
       (or (and (fboundp 'yas-active-snippets)
                (yas-active-snippets))
           (and (fboundp 'yas--templates-for-key-at-point)
                (yas--templates-for-key-at-point)))))

(defun my/yas-active-p ()
  "Return non-nil when point is inside an active Yasnippet field."
  (and (bound-and-true-p yas-minor-mode)
       (fboundp 'yas-active-snippets)
       (yas-active-snippets)))

(defun my/add-capf-local (fn append)
  "Add FN buffer-locally to `completion-at-point-functions' if available.
When APPEND is non-nil, add FN at the end of the local hook list."
  (when (fboundp fn)
    (add-hook 'completion-at-point-functions fn append t)))

(defun my/tab-dwim ()
  "Use a single IDE-like TAB behavior for completion, snippets, and indentation."
  (interactive)
  (cond
   ((my/yas-active-p)
    (yas-next-field-or-maybe-expand))
   ((my/corfu-visible-p)
    (corfu-next))
   ((my/yas-expandable-p)
    (yas-next-field-or-maybe-expand))
   (t
    (indent-for-tab-command))))

(defun my/backtab-dwim ()
  "Use a single IDE-like backtab behavior for completion and snippets."
  (interactive)
  (cond
   ((and (my/yas-active-p)
         (fboundp 'yas-prev-field))
    (yas-prev-field))
   ((my/corfu-visible-p)
    (corfu-previous))
   (t
    (indent-for-tab-command))))

(defun my/complete-dwim ()
  "Trigger completion explicitly in an IDE-like way."
  (interactive)
  (completion-at-point))

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

;; Corfu — in-buffer completion
(use-package corfu
  :bind
  (("C-<tab>" . my/complete-dwim)
   ("C-M-i" . my/complete-dwim)
   :map prog-mode-map
   ("TAB" . my/tab-dwim)
   ("<tab>" . my/tab-dwim)
   ("<backtab>" . my/backtab-dwim)
   :map text-mode-map
   ("C-<tab>" . my/complete-dwim))
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
  (corfu-on-exact-match nil)
  (corfu-min-width 30)
  (corfu-max-width 90)
  (corfu-count 14)
  (corfu-scroll-margin 2)
  :init (global-corfu-mode))

(with-eval-after-load 'corfu
  (require 'corfu-history nil t)
  (require 'corfu-popupinfo nil t)
  (require 'corfu-echo nil t)
  (when (fboundp 'corfu-history-mode)
    (corfu-history-mode 1))
  (when (fboundp 'corfu-popupinfo-mode)
    (corfu-popupinfo-mode 1))
  (when (fboundp 'corfu-echo-mode)
    (corfu-echo-mode 1))
  (define-key corfu-map (kbd "TAB") #'my/tab-dwim)
  (define-key corfu-map (kbd "<tab>") #'my/tab-dwim)
  (define-key corfu-map (kbd "S-TAB") #'my/backtab-dwim)
  (define-key corfu-map (kbd "<backtab>") #'my/backtab-dwim)
  (define-key corfu-map (kbd "RET") #'corfu-insert)
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous)
  (when (fboundp 'corfu-popupinfo-toggle)
    (define-key corfu-map (kbd "M-d") #'corfu-popupinfo-toggle)))

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
