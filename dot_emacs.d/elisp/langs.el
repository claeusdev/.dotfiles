;;; langs.el --- Tree-sitter grammars and per-language setup -*- lexical-binding: t; -*-

;;; Commentary:
;; Scope: TypeScript, JavaScript, React/TSX, Rust, OCaml, Python, SQL, plus
;; YAML, Dockerfile, JSON, TOML, CSV and Markdown for configuration, data
;; and notes.

;;; Code:

;; --- Tree-sitter ---------------------------------------------------------

;; Emacs ships tree-sitter support but no grammars.  Compile them once with
;; `M-x my/install-missing-grammars'.
(setq treesit-language-source-alist
      '((bash       "https://github.com/tree-sitter/tree-sitter-bash")
        (c          "https://github.com/tree-sitter/tree-sitter-c")
        (cpp        "https://github.com/tree-sitter/tree-sitter-cpp")
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

;; The C++ grammar is named `cpp', which the suffix rule above cannot derive,
;; so the C family is remapped explicitly (c-or-c++-ts-mode needs both).
(when (and (treesit-language-available-p 'c)
           (treesit-language-available-p 'cpp))
  (dolist (pair '((c-mode        . c-ts-mode)
                  (c++-mode      . c++-ts-mode)
                  (c-or-c++-mode . c-or-c++-ts-mode)))
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

;; --- C / C++ -------------------------------------------------------------

;; clangd reads compile_commands.json for flags; generate one in Makefile
;; projects with `bear -- make'.  A project .clang-format or .editorconfig
;; overrides the indentation defaults below.
(defun my/c-mode-defaults ()
  "Defaults for C and C++ buffers."
  (my/set-local-compile-command "make -k")
  (setq-local tab-width 4 fill-column 100)
  (setq-local c-ts-mode-indent-offset 4)
  (my/eglot-ensure-when-executable "clangd"))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook #'my/c-mode-defaults))

;; --- OCaml ---------------------------------------------------------------

(defun my/ocaml-mode-defaults ()
  "Defaults for OCaml buffers."
  (my/set-local-compile-command "dune build")
  ;; matches the janestreet ocamlformat profile's margin (~/.config/ocamlformat)
  (setq-local fill-column 90)
  ;; utop.el reads a buffer-local `utop-command' from the buffer that
  ;; launches it: project libraries via dune inside a project, bare utop
  ;; elsewhere.
  (setq-local utop-command
              (if (my/project-file-path "dune-project")
                  "opam exec -- dune utop . -- -emacs"
                "opam exec -- utop -- -emacs"))
  (my/eglot-ensure-when-executable "ocamllsp"))

(use-package tuareg
  :mode (("\\.ml\\'" . tuareg-mode)
         ("\\.mli\\'" . tuareg-mode))
  :hook (tuareg-mode . my/ocaml-mode-defaults))

;; utop.el ships with the opam utop package, not ELPA, so the elisp always
;; matches the installed utop binary.
(use-package utop
  :ensure nil
  :if (file-exists-p "~/.opam/default/share/emacs/site-lisp/utop.el")
  :load-path "~/.opam/default/share/emacs/site-lisp"
  :commands (utop utop-minor-mode)
  :hook (tuareg-mode . utop-minor-mode)
  :custom
  (utop-edit-command nil))

;; Merlin features plain Eglot drops: `ocaml-eglot-construct' fills a typed
;; hole, `ocaml-eglot-destruct' generates exhaustive match arms, plus
;; type-driven search and enclosing-type navigation.
(use-package ocaml-eglot
  :after tuareg
  :hook (tuareg-mode . ocaml-eglot))

;; --- Python --------------------------------------------------------------

;; No hand-rolled venv detection: envrc supplies the project environment where
;; an .envrc exists, uv runs commands inside the project venv without
;; activation, and basedpyright finds a root-level .venv on its own.
(defun my/python-uv-project-p ()
  "Whether the current project should be driven through uv."
  (and (executable-find "uv") (my/project-file-path "pyproject.toml")))

(defun my/python-test-command ()
  "Return a test command for the current Python project."
  (if (my/python-uv-project-p) "uv run pytest" "python3 -m pytest"))

(defun my/python-mode-defaults ()
  "Defaults for Python buffers."
  (setq-local tab-width 4 fill-column 88)
  (my/set-local-compile-command
   (let ((file (shell-quote-argument (or buffer-file-name ""))))
     (if (my/python-uv-project-p)
         (format "uv run python %s" file)
       (format "python3 %s" file))))
  (my/eglot-ensure-when-executable "basedpyright-langserver"))

(add-hook 'python-ts-mode-hook #'my/python-mode-defaults)

;; --- Notebooks and data files ---------------------------------------------

;; Cell-based editing over plain .py files with `# %%' markers; cells are sent
;; to the inferior Python REPL with C-c C-c.  With jupytext on PATH, .ipynb
;; notebooks open transparently as scripts and convert back on save.
(use-package code-cells
  :init
  (when (executable-find "jupytext")
    (add-to-list 'auto-mode-alist '("\\.ipynb\\'" . code-cells-convert-ipynb)))
  :hook (python-ts-mode . code-cells-mode-maybe)
  :bind (:map code-cells-mode-map
              ("M-p"     . code-cells-backward-cell)
              ("M-n"     . code-cells-forward-cell)
              ("C-c C-c" . code-cells-eval)))

;; tsv-mode derives from csv-mode, so the alignment hook covers both.
(use-package csv-mode
  :mode (("\\.csv\\'" . csv-mode)
         ("\\.tsv\\'" . tsv-mode))
  :hook (csv-mode . csv-align-mode))

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
