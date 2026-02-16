;;; --- 9. TERMINAL & KEYS ---
(require 'comint)

(defun my/toggle-vterm ()
  "Toggle vterm terminal at bottom."
  (interactive)
  (if (get-buffer "*vterm*")
      (if (string= (buffer-name) "*vterm*")
          (delete-window)
        (pop-to-buffer "*vterm*"))
    (vterm)))

(global-set-key (kbd "C-`") 'my/toggle-vterm)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-c w") 'delete-window)
(global-set-key (kbd "C-c r") 'replace-string)

;; Enable CUA mode for familiar copy/paste/undo bindings (Cmd on Mac, Ctrl on Linux/Windows)
;; This uses Command key on macOS (s-c, s-v, s-x, s-z, s-a) which won't conflict
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ; Don't tabify after rectangle commands
(setq cua-keep-region-after-copy t)   ; Keep region active after copy

;; Additional undo/redo bindings
(global-set-key (kbd "C-z") 'undo-tree-undo)     ; Undo (Ctrl+Z)
(global-set-key (kbd "C-S-z") 'undo-tree-redo)   ; Redo (Ctrl+Shift+Z)

(defun my/fp-open-comint-repl (buffer-name program &rest args)
  "Open BUFFER-NAME running PROGRAM with ARGS in a comint session."
  (unless (executable-find program)
    (user-error "Executable not found: %s" program))
  (unless (comint-check-proc buffer-name)
    (apply #'make-comint-in-buffer buffer-name buffer-name program nil args))
  (pop-to-buffer buffer-name))

(defun my/fp-open-haskell-repl ()
  "Open Haskell REPL."
  (interactive)
  (if (fboundp 'haskell-interactive-switch)
      (haskell-interactive-switch)
    (my/fp-open-comint-repl "*haskell-repl*" "ghci")))

(defun my/fp-load-haskell-file ()
  "Load current file into Haskell REPL."
  (interactive)
  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))
  (if (fboundp 'haskell-process-load-file)
      (haskell-process-load-file)
    (progn
      (save-buffer)
      (my/fp-open-comint-repl "*haskell-repl*" "ghci")
      (let ((proc (get-buffer-process "*haskell-repl*")))
        (comint-send-string proc (format ":load \"%s\"\n" (expand-file-name buffer-file-name)))))))

(defun my/fp-open-ocaml-repl ()
  "Open OCaml REPL."
  (interactive)
  (cond
   ((fboundp 'utop) (utop))
   ((fboundp 'tuareg-run-ocaml) (call-interactively 'tuareg-run-ocaml))
   ((executable-find "utop") (my/fp-open-comint-repl "*ocaml-repl*" "utop"))
   (t (my/fp-open-comint-repl "*ocaml-repl*" "ocaml"))))

(defun my/fp-load-ocaml-file ()
  "Load current file into OCaml REPL."
  (interactive)
  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))
  (if (fboundp 'tuareg-eval-buffer)
      (tuareg-eval-buffer)
    (progn
      (save-buffer)
      (my/fp-open-ocaml-repl)
      (let ((proc (or (get-buffer-process "*ocaml-repl*")
                      (get-buffer-process "*inferior-caml*")
                      (get-buffer-process "*ocaml*"))))
        (unless proc
          (user-error "No OCaml REPL process found"))
        (comint-send-string proc (format "#use \"%s\";;\n" (expand-file-name buffer-file-name)))))))

(defun my/fp-open-racket-repl ()
  "Open Racket REPL."
  (interactive)
  (if (fboundp 'racket-repl)
      (racket-repl)
    (my/fp-open-comint-repl "*racket-repl*" "racket")))

(defun my/fp-open-elixir-repl ()
  "Open Elixir REPL."
  (interactive)
  (my/fp-open-comint-repl "*elixir-repl*" "iex"))

(define-prefix-command 'my/fp-map)
(global-set-key (kbd "C-c f") 'my/fp-map)
(define-key my/fp-map (kbd "h") #'my/fp-open-haskell-repl)
(define-key my/fp-map (kbd "H") #'my/fp-load-haskell-file)
(define-key my/fp-map (kbd "o") #'my/fp-open-ocaml-repl)
(define-key my/fp-map (kbd "O") #'my/fp-load-ocaml-file)
(define-key my/fp-map (kbd "r") #'my/fp-open-racket-repl)
(define-key my/fp-map (kbd "e") #'my/fp-open-elixir-repl)

;; Embark (Actions menu)
(use-package embark
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult))

(provide 'el-bindings)
