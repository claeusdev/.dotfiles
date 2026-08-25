;;; keys.el --- Global keybindings -*- lexical-binding: t; -*-

;;; Commentary:
;; Loaded last so every referenced command and map already exists.
;; Prefixes: C-c p project, C-c s search, C-c l LSP, C-c n notes,
;;           C-c d debug, C-c f REPL, C-c t toggles, C-c e Emacs.

;;; Code:

;; --- Global --------------------------------------------------------------

(global-set-key (kbd "<escape>") #'keyboard-escape-quit)
(global-set-key (kbd "M-o") #'other-window)
(global-set-key (kbd "C-c w") #'delete-window)

(defvar my/toggle-map (make-sparse-keymap) "Appearance and editor toggles.")
(global-set-key (kbd "C-c t") my/toggle-map)
(define-key my/toggle-map (kbd "t") #'my/toggle-theme)
(define-key my/toggle-map (kbd "l") #'display-line-numbers-mode)
(define-key my/toggle-map (kbd "w") #'visual-line-mode)
(define-key my/toggle-map (kbd "o") #'olivetti-mode)

(defvar my/emacs-map (make-sparse-keymap) "Commands about Emacs itself.")
(global-set-key (kbd "C-c e") my/emacs-map)
(define-key my/emacs-map (kbd "h") #'my/emacs-health-check)
(define-key my/emacs-map (kbd "g") #'my/install-missing-grammars)

;; --- Search --------------------------------------------------------------

(defvar my/search-map (make-sparse-keymap) "Search and navigation.")
(global-set-key (kbd "C-c s") my/search-map)
(define-key my/search-map (kbd "s") #'my/project-search)
(define-key my/search-map (kbd "r") #'consult-ripgrep)
(define-key my/search-map (kbd "l") #'consult-line)
(define-key my/search-map (kbd "o") #'consult-outline)
(define-key my/search-map (kbd "i") #'consult-imenu)

;; --- Projects ------------------------------------------------------------

(with-eval-after-load 'project
  (global-set-key (kbd "C-c p") project-prefix-map)
  (define-key project-prefix-map (kbd "p") #'project-switch-project)
  (define-key project-prefix-map (kbd "P") #'my/project-switch-find-file)
  (define-key project-prefix-map (kbd "f") #'project-find-file)
  (define-key project-prefix-map (kbd "b") #'project-switch-to-buffer)
  (define-key project-prefix-map (kbd "a") #'my/project-remember-current)
  (define-key project-prefix-map (kbd "d") #'project-find-dir)
  (define-key project-prefix-map (kbd "D") #'project-dired)
  (define-key project-prefix-map (kbd "o") #'my/project-open-root)
  (define-key project-prefix-map (kbd "s") #'my/project-search)
  (define-key project-prefix-map (kbd "m") #'my/project-compile)
  (define-key project-prefix-map (kbd "t") #'my/project-test)
  (define-key project-prefix-map (kbd "v") #'my/project-vterm)
  (define-key project-prefix-map (kbd "g") #'my/project-agent))

;; --- LSP -----------------------------------------------------------------

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c l a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c l d") #'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c l D") #'xref-find-references)
  (define-key eglot-mode-map (kbd "C-c l i") #'eglot-find-implementation)
  (define-key eglot-mode-map (kbd "C-c l t") #'eglot-find-typeDefinition)
  (define-key eglot-mode-map (kbd "C-c l r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l f") #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c l e") #'flymake-show-buffer-diagnostics)
  (define-key eglot-mode-map (kbd "C-c l n") #'flymake-goto-next-error)
  (define-key eglot-mode-map (kbd "C-c l p") #'flymake-goto-prev-error))

(with-eval-after-load 'flymake
  (define-key flymake-mode-map (kbd "M-g n") #'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-g p") #'flymake-goto-prev-error))

;; --- Debugging -----------------------------------------------------------

(defvar my/debug-map (make-sparse-keymap) "Debugger commands (dape).")
(global-set-key (kbd "C-c d") my/debug-map)
(define-key my/debug-map (kbd "d") #'dape)
(define-key my/debug-map (kbd "b") #'dape-breakpoint-toggle)
(define-key my/debug-map (kbd "n") #'dape-next)
(define-key my/debug-map (kbd "i") #'dape-step-in)
(define-key my/debug-map (kbd "o") #'dape-step-out)
(define-key my/debug-map (kbd "c") #'dape-continue)
(define-key my/debug-map (kbd "q") #'dape-quit)

;; --- Notes ---------------------------------------------------------------

(defvar my/notes-map (make-sparse-keymap) "Notes, capture and agenda.")
(global-set-key (kbd "C-c n") my/notes-map)
(define-key my/notes-map (kbd "n") #'denote)
(define-key my/notes-map (kbd "l") #'denote-link)
(define-key my/notes-map (kbd "b") #'denote-backlinks)
(define-key my/notes-map (kbd "r") #'denote-rename-file)
(define-key my/notes-map (kbd "f") #'my/denote-find)
(define-key my/notes-map (kbd "s") #'my/denote-search)
(define-key my/notes-map (kbd "c") #'citar-open)
(define-key my/notes-map (kbd "C") #'my/citar-insert-pandoc)
(define-key my/notes-map (kbd "i") (lambda () (interactive) (find-file "~/org/inbox.org")))
(define-key my/notes-map (kbd "p") (lambda () (interactive) (find-file "~/org/projects.org")))
(define-key my/notes-map (kbd "j") (lambda () (interactive) (find-file "~/org/journal.org")))

(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)

;; --- Terminal agent -----------------------------------------------------

(defvar my/agent-map (make-sparse-keymap) "Shared terminal-agent commands.")
(global-set-key (kbd "C-c g") my/agent-map)
(define-key my/agent-map (kbd "g") #'my/project-agent)
(define-key my/agent-map (kbd "c") #'my/agent-context)

;; --- REPLs ---------------------------------------------------------------

;; Only REPLs with real Emacs support; for node, a project vterm (C-c p v)
;; beats a bare comint buffer.  utop qualifies: utop.el speaks a dedicated
;; -emacs protocol with completion and phrase evaluation.
(defvar my/repl-map (make-sparse-keymap) "Language REPLs.")
(global-set-key (kbd "C-c f") my/repl-map)
(define-key my/repl-map (kbd "p") #'run-python)
(define-key my/repl-map (kbd "s") #'sql-product-interactive)
(define-key my/repl-map (kbd "e") #'ielm)
(define-key my/repl-map (kbd "o") #'utop)

(provide 'keys)
;;; keys.el ends here
