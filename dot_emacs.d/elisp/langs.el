;;; langs.el --- Tree-sitter grammars and per-language setup -*- lexical-binding: t; -*-

;;; Commentary:
;; Scope: TypeScript, JavaScript, React/TSX, Rust, OCaml, Python, SQL, plus
;; YAML, Dockerfile, JSON, TOML and Markdown for configuration and notes.

;;; Code:

;; --- Tree-sitter ---------------------------------------------------------

;; Emacs ships tree-sitter support but no grammars.  Compile them once with
;; `M-x my/install-missing-grammars'.
(setq treesit-language-source-alist
      '((bash       "https://github.com/tree-sitter/tree-sitter-bash")
        (css        "https://github.com/tree-sitter/tree-sitter-css")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (json       "https://github.com/tree-sitter/tree-sitter-json")
        (python     "https://github.com/tree-sitter/tree-sitter-python")
        (rust       "https://github.com/tree-sitter/tree-sitter-rust")
        (toml       "https://github.com/tree-sitter/tree-sitter-toml")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src")
        (yaml       "https://github.com/ikatyang/tree-sitter-yaml")))

(defun my/install-missing-grammars (&optional force)
  "Compile every tree-sitter grammar that is not already available.
With prefix argument FORCE, reinstall grammars that are already present."
  (interactive "P")
  (let (installed failed)
    (dolist (lang (mapcar #'car treesit-language-source-alist))
      (when (or force (not (treesit-language-available-p lang)))
        (condition-case err
            (progn (treesit-install-language-grammar lang)
                   (push lang installed))
          (error (push (cons lang (error-message-string err)) failed)))))
    (message "Grammars installed: %s%s"
             (if installed (mapconcat #'symbol-name (nreverse installed) ", ") "none")
             (if failed (format " | failed: %s" (mapcar #'car failed)) ""))))

;; Prefer the tree-sitter major modes wherever a grammar is present.  This is
;; the Emacs 30 idiom, and degrades to the classic mode when one is missing.
(dolist (pair '((js-mode         . js-ts-mode)
                (javascript-mode . js-ts-mode)
                (python-mode     . python-ts-mode)
                (css-mode        . css-ts-mode)
                (json-mode       . json-ts-mode)
                (js-json-mode    . json-ts-mode)
                (conf-toml-mode  . toml-ts-mode)
                (sh-mode         . bash-ts-mode)))
  (when (treesit-language-available-p
         (intern (string-remove-suffix "-ts-mode" (symbol-name (cdr pair)))))
    (add-to-list 'major-mode-remap-alist pair)))

(when (treesit-language-available-p 'typescript)
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode)))
(when (treesit-language-available-p 'tsx)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode)))
(when (treesit-language-available-p 'rust)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode)))
(when (treesit-language-available-p 'yaml)
  (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode)))
(when (treesit-language-available-p 'dockerfile)
  (add-to-list 'auto-mode-alist '("\\(?:Dockerfile\\|\\.dockerfile\\)\\'" . dockerfile-ts-mode)))
(when (treesit-language-available-p 'toml)
  (add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode)))

;; --- Shared helpers ------------------------------------------------------

(defun my/set-local-compile-command (command)
  "Set the buffer-local `compile-command' to COMMAND."
  (setq-local compile-command command))

(defun my/project-file-path (name)
  "Return the absolute path to NAME at the project root, or nil."
  (when-let* ((project (project-current nil)))
    (let ((path (expand-file-name name (project-root project))))
      (when (file-exists-p path) path))))

;; --- JavaScript / TypeScript / React -------------------------------------

(defun my/node-project-root ()
  "Return the current Node project root, if there is one."
  (when-let* ((project (project-current nil)))
    (let ((root (project-root project)))
      (when (file-exists-p (expand-file-name "package.json" root)) root))))

(defun my/node-package-manager (root)
  "Return the package manager command for ROOT, detected from the lockfile."
  (cond
   ((file-exists-p (expand-file-name "bun.lockb" root)) "bun")
   ((file-exists-p (expand-file-name "bun.lock" root)) "bun")
   ((file-exists-p (expand-file-name "pnpm-lock.yaml" root)) "pnpm")
   ((file-exists-p (expand-file-name "yarn.lock" root)) "yarn")
   (t "npm")))

(defun my/node-run-script-command (script)
  "Return a command that runs package SCRIPT with the project's package manager."
  (when-let* ((root (my/node-project-root)))
    (let ((manager (my/node-package-manager root)))
      (if (string= manager "yarn")
          (format "yarn %s" script)
        (format "%s run %s" manager script)))))

(defun my/node-test-command ()
  "Return the test command for the current Node project."
  (or (my/node-run-script-command "test") "npm test"))

(defun my/js-mode-defaults ()
  "Defaults for JavaScript, TypeScript and TSX buffers."
  (setq-local tab-width 2 fill-column 100)
  (when-let* ((cmd (or (my/node-run-script-command "typecheck")
                       (my/node-run-script-command "build"))))
    (my/set-local-compile-command cmd))
  (my/eglot-ensure-when-executable "vtsls"))

(dolist (hook '(js-ts-mode-hook typescript-ts-mode-hook tsx-ts-mode-hook))
  (add-hook hook #'my/js-mode-defaults))

;; --- Rust ----------------------------------------------------------------

(defun my/rust-mode-defaults ()
  "Defaults for Rust buffers."
  (my/set-local-compile-command "cargo check")
  (setq-local fill-column 100)
  (my/eglot-ensure-when-executable "rust-analyzer"))

(add-hook 'rust-ts-mode-hook #'my/rust-mode-defaults)

;; --- OCaml ---------------------------------------------------------------

(defun my/ocaml-mode-defaults ()
  "Defaults for OCaml buffers."
  (my/set-local-compile-command "dune build")
  (setq-local fill-column 100)
  (my/eglot-ensure-when-executable "ocamllsp"))

(use-package tuareg
  :mode (("\\.ml\\'" . tuareg-mode)
         ("\\.mli\\'" . tuareg-mode))
  :hook (tuareg-mode . my/ocaml-mode-defaults))

;; --- Python --------------------------------------------------------------

(defun my/python-interpreter ()
  "Return the project virtualenv interpreter when present, else the system one."
  (or (my/project-file-path ".venv/bin/python")
      (my/project-file-path "venv/bin/python")
      (executable-find "python3")
      "python3"))

(defun my/python-test-command ()
  "Return a pytest command for the current project."
  (format "%s -m pytest" (shell-quote-argument (my/python-interpreter))))

(defun my/python-mode-defaults ()
  "Defaults for Python buffers."
  (setq-local tab-width 4
              fill-column 88
              python-shell-interpreter (my/python-interpreter))
  (my/set-local-compile-command
   (format "%s %s"
           (shell-quote-argument (my/python-interpreter))
           (shell-quote-argument (or buffer-file-name ""))))
  (my/eglot-ensure-when-executable "basedpyright-langserver"))

(add-hook 'python-ts-mode-hook #'my/python-mode-defaults)

;; --- SQL, YAML, Docker ---------------------------------------------------

;; SQL has no LSP worth the weight; `sql-mode' is built in and Apheleia
;; handles formatting via sql-formatter.
(defun my/simple-web-defaults ()
  "Shared indentation defaults for config and markup buffers."
  (setq-local tab-width 2 fill-column 100))

(dolist (hook '(sql-mode-hook css-ts-mode-hook json-ts-mode-hook toml-ts-mode-hook))
  (add-hook hook #'my/simple-web-defaults))

(defun my/yaml-mode-defaults ()
  "Defaults for YAML buffers."
  (my/simple-web-defaults)
  (my/eglot-ensure-when-executable "yaml-language-server"))

(add-hook 'yaml-ts-mode-hook #'my/yaml-mode-defaults)

(defun my/dockerfile-mode-defaults ()
  "Defaults for Dockerfile buffers."
  (my/simple-web-defaults)
  (my/eglot-ensure-when-executable "docker-langserver"))

(add-hook 'dockerfile-ts-mode-hook #'my/dockerfile-mode-defaults)

;; --- Markdown and Emacs Lisp ---------------------------------------------

(use-package markdown-mode
  :mode ("\\.md\\'" "\\.markdown\\'")
  :hook (markdown-mode . visual-line-mode))

(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)

(provide 'langs)
;;; langs.el ends here
