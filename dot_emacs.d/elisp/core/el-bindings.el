;;; el-bindings.el --- Global keybindings -*- lexical-binding: t; -*-

;;; Code:

;; --- Global bindings ---
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-c w") 'delete-window)
(global-set-key (kbd "C-c r") 'replace-string)

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

(defvar my/fp-repl-map (make-sparse-keymap)
  "Keymap for FP REPL commands under C-c f.")

(global-set-key (kbd "C-c f") my/fp-repl-map)

(define-key my/fp-repl-map (kbd "h")
  (lambda () (interactive)
    (my/run-repl "haskell" 'haskell-interactive-switch "ghci")))

(define-key my/fp-repl-map (kbd "o")
  (lambda () (interactive)
    (my/run-repl "ocaml" 'utop "utop")))

(define-key my/fp-repl-map (kbd "s")
  (lambda () (interactive)
    (my/run-repl "sml" 'sml-run "sml")))

(define-key my/fp-repl-map (kbd "r")
  (lambda () (interactive)
    (my/run-repl "racket" 'racket-repl "racket")))

(define-key my/fp-repl-map (kbd "l")
  (lambda () (interactive)
    (my/run-repl "lisp" 'sly "sbcl")))

(define-key my/fp-repl-map (kbd "e")
  (lambda () (interactive)
    (ielm)))

(define-key my/fp-repl-map (kbd "n")
  (lambda () (interactive)
    (my/run-repl "lean" 'lean4-repl)))

(define-key my/fp-repl-map (kbd "c")
  (lambda () (interactive)
    (my/run-repl "coq" 'proof-shell-start)))

(define-key my/fp-repl-map (kbd "a")
  (lambda () (interactive)
    (my/run-repl "agda" 'agda2-mode)))

(provide 'el-bindings)
;;; el-bindings.el ends here
