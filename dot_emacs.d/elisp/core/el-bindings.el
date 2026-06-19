;;; el-bindings.el --- Global keybindings -*- lexical-binding: t; -*-

;;; Code:

;; --- Global bindings ---
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-c w") 'delete-window)
(global-set-key (kbd "C-c r") 'replace-string)
(global-set-key (kbd "C-c e h") 'my/emacs-health-check)

(defvar my/search-map (make-sparse-keymap)
  "Keymap for search and navigation commands.")

(global-set-key (kbd "C-c s") my/search-map)
(define-key my/search-map (kbd "r") #'consult-ripgrep)
(define-key my/search-map (kbd "s") #'my/project-search)
(define-key my/search-map (kbd "l") #'consult-line)
(define-key my/search-map (kbd "o") #'consult-outline)
(define-key my/search-map (kbd "i") #'consult-imenu)

(defvar my/notes-map (make-sparse-keymap)
  "Keymap for note and research commands.")

(global-set-key (kbd "C-c n") my/notes-map)
(define-key my/notes-map (kbd "f") #'org-roam-node-find)
(define-key my/notes-map (kbd "i") #'my/org-open-inbox)
(define-key my/notes-map (kbd "I") #'org-roam-node-insert)
(define-key my/notes-map (kbd "p") #'my/org-open-projects)
(define-key my/notes-map (kbd "P") #'my/org-open-papers)
(define-key my/notes-map (kbd "j") #'my/org-open-journal)
(define-key my/notes-map (kbd "b") #'org-roam-buffer-toggle)
(define-key my/notes-map (kbd "c") #'org-roam-capture)
(define-key my/notes-map (kbd "d") #'org-roam-dailies-goto-today)
(define-key my/notes-map (kbd "l") #'my/org-roam-find-literature)
(define-key my/notes-map (kbd "s") #'my/org-notes-search)

;; --- FP REPL helpers ---
(defun my/run-repl (name start-fn &optional fallback-cmd)
  "Launch a REPL named NAME using START-FN.
If START-FN is not available and FALLBACK-CMD is given, run it as a shell command."
  (if (fboundp start-fn)
      (call-interactively start-fn)
    (if fallback-cmd
        (progn
          (message "Running %s via shell..." fallback-cmd)
          (let ((buf (make-comint name fallback-cmd)))
            (pop-to-buffer buf)))
      (user-error "%s is not available" name))))

(defvar my/repl-map (make-sparse-keymap)
  "Keymap for language REPL commands under C-c f.")

(global-set-key (kbd "C-c f") my/repl-map)

(define-key my/repl-map (kbd "h")
  (lambda () (interactive)
    (my/run-repl "haskell" 'haskell-interactive-switch "ghci")))

(define-key my/repl-map (kbd "o")
  (lambda () (interactive)
    (my/run-repl "ocaml" 'utop "utop")))

(define-key my/repl-map (kbd "e")
  (lambda () (interactive)
    (ielm)))

(provide 'el-bindings)
;;; el-bindings.el ends here
