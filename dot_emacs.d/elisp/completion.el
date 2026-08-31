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

;; Path-aware editing: DEL removes a whole directory component, RET on a
;; directory descends into it instead of confirming it, and shadowed prefixes
;; (`~/foo//etc') are tidied away.
(use-package vertico-directory
  :ensure nil ; ships inside vertico
  :after vertico
  :bind (:map vertico-map
              ("RET"   . vertico-directory-enter)
              ("DEL"   . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Space-separated components in any order; each component also matches as a
;; subsequence (`fbz' finds foo_bar.zig), so short fuzzy queries work the way
;; they do in VS Code or Telescope.  Prefix-style dispatchers still apply:
;; `=foo' literal, `!foo' exclude, `foo~' forces flex, `foo,' regexp.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (orderless-matching-styles '(orderless-literal orderless-regexp orderless-flex))
  (completion-category-overrides '((file (styles partial-completion orderless)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format
        xref-show-definitions-function #'consult-xref
        xref-show-xrefs-function #'consult-xref)
  :bind
  (("C-x b"   . consult-buffer)
   ("C-x C-r" . consult-recent-file)
   ("C-x r b" . consult-bookmark)
   ("M-y"     . consult-yank-pop)
   ("M-g g"   . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("M-g i"   . consult-imenu)
   ("M-g I"   . consult-imenu-multi)
   ("M-g o"   . consult-outline)
   ("M-g m"   . consult-mark)
   ("M-g M"   . consult-global-mark)
   ("M-g f"   . consult-flymake)
   ("M-s l"   . consult-line)
   ("M-s L"   . consult-line-multi)
   ("M-s r"   . consult-ripgrep)
   ("M-s f"   . consult-fd)
   ("M-s k"   . consult-keep-lines)
   ("M-s u"   . consult-focus-lines)
   :map minibuffer-local-map
   ("M-s" . consult-history)
   ("M-r" . consult-history)))

;; Tree-sitter-aware region expansion: repeat to grow from symbol to
;; expression to statement to defun.
(use-package expreg
  :bind (("C-="   . expreg-expand)
         ("C-M-=" . expreg-contract)))

;; Replace the symbol at point across the buffer, defun, or above/below
;; point, without a query loop.  Bound under `C-c s u' in keys.el.
(use-package substitute
  :custom (substitute-highlight t))

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
