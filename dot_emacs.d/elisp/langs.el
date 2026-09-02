;;; langs.el --- Tree-sitter grammars and per-language setup -*- lexical-binding: t; -*-

;;; Commentary:
;; Scope: Python (incl. notebooks), the FP stack (Racket, Standard ML, Haskell,
;; OCaml), systems programming (C, C++, Rust, CMake), TypeScript/JavaScript,
;; Go, Lua, shell, SQL, plus YAML, Dockerfile, JSON, TOML, CSV and Markdown.

;;; Code:

;; --- Tree-sitter ---------------------------------------------------------

;; Grammars support more highlighting than the default level 3 enables.
(setq treesit-font-lock-level 4)

;; Emacs ships tree-sitter support but no grammars.  Compile them once with
;; `M-x my/install-missing-grammars'.  Racket, SML, Haskell and OCaml use
;; their classic major modes, which are still more complete than the
;; tree-sitter ones.
(setq treesit-language-source-alist
      '((bash       "https://github.com/tree-sitter/tree-sitter-bash")
        (go         "https://github.com/tree-sitter/tree-sitter-go")
        (c          "https://github.com/tree-sitter/tree-sitter-c")
        (cpp        "https://github.com/tree-sitter/tree-sitter-cpp")
        (cmake      "https://github.com/uyha/tree-sitter-cmake")
        (css        "https://github.com/tree-sitter/tree-sitter-css")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (json       "https://github.com/tree-sitter/tree-sitter-json")
        (lua        "https://github.com/tree-sitter-grammars/tree-sitter-lua")
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

;; `treesit-language-available-p' dlopens the grammar to answer, ~5ms each
;; and there are fifteen; at startup a file check is enough.
(defun my/grammar-installed-p (lang)
  "Whether the compiled grammar for LANG exists in the user grammar directory."
  (file-exists-p (expand-file-name (format "libtree-sitter-%s%s" lang module-file-suffix)
                                   (expand-file-name "tree-sitter" user-emacs-directory))))

;; Prefer the tree-sitter major modes wherever a grammar is present.  This is
;; the Emacs 30 idiom, and degrades to the classic mode when one is missing.
(dolist (pair '((js-mode         . js-ts-mode)
                (javascript-mode . js-ts-mode)
                (python-mode     . python-ts-mode)
                (css-mode        . css-ts-mode)
                (json-mode       . json-ts-mode)
                (js-json-mode    . json-ts-mode)
                (conf-toml-mode  . toml-ts-mode)
                (sh-mode         . bash-ts-mode)
                (go-mode         . go-ts-mode)))
  (when (my/grammar-installed-p
         (intern (string-remove-suffix "-ts-mode" (symbol-name (cdr pair)))))
    (add-to-list 'major-mode-remap-alist pair)))

;; The C++ grammar is named `cpp', which the suffix rule above cannot derive,
;; so the C family is remapped explicitly (c-or-c++-ts-mode needs both).
(when (and (my/grammar-installed-p 'c)
           (my/grammar-installed-p 'cpp))
  (dolist (pair '((c-mode        . c-ts-mode)
                  (c++-mode      . c++-ts-mode)
                  (c-or-c++-mode . c-or-c++-ts-mode)))
    (add-to-list 'major-mode-remap-alist pair)))

(when (my/grammar-installed-p 'typescript)
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode)))
(when (my/grammar-installed-p 'tsx)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode)))
(when (my/grammar-installed-p 'rust)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode)))
(when (my/grammar-installed-p 'yaml)
  (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode)))
(when (my/grammar-installed-p 'dockerfile)
  (add-to-list 'auto-mode-alist '("\\(?:Dockerfile\\|\\.dockerfile\\)\\'" . dockerfile-ts-mode)))
(when (my/grammar-installed-p 'toml)
  (add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode)))
(when (my/grammar-installed-p 'lua)
  (add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode)))
;; cmake-ts-mode registers CMakeLists.txt / *.cmake itself once its grammar
;; is present.

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
  (my/set-local-compile-command
   (if (my/project-file-path "CMakeLists.txt") "cmake --build build" "make -k"))
  (setq-local tab-width 4 fill-column 100)
  (setq-local c-ts-mode-indent-offset 4)
  (my/eglot-ensure-when-executable "clangd"))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook #'my/c-mode-defaults))

(use-package c-ts-mode
  :ensure nil
  :custom (c-ts-mode-indent-style 'linux))

;; --- Lisps: Racket and Emacs Lisp ----------------------------------------

;; Structural editing for s-expression languages only; elsewhere the plain
;; `electric-pair-mode' from core.el stays in charge.  REPL buffers are left
;; out so RET always submits input.
(defconst my/lisp-mode-hooks
  '(emacs-lisp-mode-hook lisp-interaction-mode-hook lisp-mode-hook
    scheme-mode-hook racket-mode-hook)
  "Hooks of source modes that get paredit.")

(use-package paredit
  :init
  (dolist (hook my/lisp-mode-hooks)
    (add-hook hook #'enable-paredit-mode))
  :config
  ;; paredit inserts and balances its own pairs.
  (add-hook 'paredit-mode-hook (lambda () (electric-pair-local-mode -1)))
  ;; Keep M-j for avy (core.el) and M-s for consult's search map.
  (define-key paredit-mode-map (kbd "M-j") nil)
  (define-key paredit-mode-map (kbd "M-s") nil))

;; racket-mode talks to a Racket back end of its own, which gives it
;; check-syntax-driven navigation, rename, eldoc and Flymake diagnostics
;; (`racket-xp-mode') without an LSP.  C-c C-c runs the file, C-c C-z visits
;; the REPL, C-M-x sends the definition at point.
(defun my/racket-mode-defaults ()
  "Defaults for Racket buffers."
  (my/set-local-compile-command "raco test .")
  (setq-local fill-column 100))

(use-package racket-mode
  :mode ("\\.rkt\\'" . racket-mode)
  :hook ((racket-mode . my/racket-mode-defaults)
         (racket-mode . racket-xp-mode))
  :custom
  (racket-program "racket")
  (racket-show-functions '(racket-show-echo-area)))

;; --- Standard ML ---------------------------------------------------------

;; sml-mode drives the SML/NJ REPL (`sml-run', C-c C-l loads the buffer,
;; C-c C-r the region).  millet-ls adds diagnostics and navigation; it
;; expects a `millet.toml' or a lone project root and is optional.
(defun my/sml-mode-defaults ()
  "Defaults for Standard ML buffers."
  (setq-local fill-column 100)
  (my/eglot-ensure-when-executable "millet-ls"))

(use-package sml-mode
  :mode (("\\.sml\\'" . sml-mode)
         ("\\.sig\\'" . sml-mode)
         ("\\.fun\\'" . sml-mode))
  :hook (sml-mode . my/sml-mode-defaults)
  :custom
  (sml-program-name "sml")
  (sml-indent-level 2))

;; --- Go, Haskell, Lua and shell ------------------------------------------

(defun my/go-mode-defaults ()
  (my/set-local-compile-command "go test ./...")
  (setq-local tab-width 4 fill-column 100)
  (my/eglot-ensure-when-executable "gopls"))
(add-hook 'go-ts-mode-hook #'my/go-mode-defaults)

(defun my/haskell-mode-defaults ()
  (my/set-local-compile-command "cabal build all")
  (setq-local fill-column 100)
  (my/eglot-ensure-when-executable "haskell-language-server-wrapper"))
(use-package haskell-mode
  :mode ("\\.hs\\'" . haskell-mode)
  :hook ((haskell-mode . my/haskell-mode-defaults)
         ;; Owns C-c C-l (load into GHCi), C-c C-z (switch to REPL), etc.
         (haskell-mode . interactive-haskell-mode)))

;; `lua-ts-mode' is built in since Emacs 30; needs the lua grammar.
(defun my/lua-mode-defaults ()
  (setq-local tab-width 2 fill-column 100)
  (my/eglot-ensure-when-executable "lua-language-server"))
(add-hook 'lua-ts-mode-hook #'my/lua-mode-defaults)

(defun my/shell-mode-defaults ()
  (my/set-local-compile-command "shellcheck .")
  (my/eglot-ensure-when-executable "bash-language-server"))
(add-hook 'bash-ts-mode-hook #'my/shell-mode-defaults)

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

;; dune.el ships with the opam dune package: syntax for `dune',
;; `dune-project' and `dune-workspace' files.
(use-package dune
  :ensure nil
  :if (file-exists-p "~/.opam/default/share/emacs/site-lisp/dune.el")
  :load-path "~/.opam/default/share/emacs/site-lisp"
  :mode ("\\(?:\\`\\|/\\)dune\\(?:-project\\|-workspace\\)?\\'" . dune-mode))

;; Home-grown: inline evaluation results for utop (eros-style overlays).
;; Lives in ~/workspace/elisp/utop-eros, not ELPA.
(use-package utop-eros
  :ensure nil
  :if (file-directory-p "~/workspace/elisp/utop-eros")
  :load-path "~/workspace/elisp/utop-eros"
  :hook (tuareg-mode . utop-eros-mode))

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

(defun my/python-set-interpreter ()
  "Point `run-python' at the best interpreter for this buffer.
Prefers the project venv's ipython, then its python, then a global ipython
\(installed with `uv tool install ipython'), then python3.  envrc has
already put the venv on PATH, so `executable-find' sees it."
  (let ((ipython (executable-find "ipython")))
    (if ipython
        (setq-local python-shell-interpreter ipython
                    python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")
      (setq-local python-shell-interpreter (or (executable-find "python3") "python3")
                  python-shell-interpreter-args "-i"))))

(defun my/python-mode-defaults ()
  "Defaults for Python buffers."
  (setq-local tab-width 4 fill-column 88)
  (my/set-local-compile-command
   (let ((file (shell-quote-argument (or buffer-file-name ""))))
     (if (my/python-uv-project-p)
         (format "uv run python %s" file)
       (format "python3 %s" file))))
  (my/python-set-interpreter)
  (if (executable-find "basedpyright-langserver")
      (eglot-ensure) ; flymake-ruff attaches from eglot-managed-mode-hook (dev.el)
    (when (fboundp 'flymake-ruff-load)
      (flymake-ruff-load)
      (flymake-mode 1))))

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
