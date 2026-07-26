;;; core.el --- Editor defaults, session state, appearance -*- lexical-binding: t; -*-

;;; Code:

;; Restore a working GC threshold now that startup is done.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

(defconst my/cache-dir (expand-file-name "var/" user-emacs-directory)
  "Directory for cache-like state that should never be version controlled.")

(dolist (dir (list my/cache-dir
                   (expand-file-name "auto-save/" my/cache-dir)
                   (expand-file-name "backup/" my/cache-dir)))
  (make-directory dir t))

;; GUI Emacs on macOS does not inherit the shell PATH, so language servers and
;; formatters would be invisible without this.
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

;; --- Editor defaults -----------------------------------------------------

(setq-default indent-tabs-mode nil
              tab-width 2
              fill-column 100)

(setq require-final-newline t
      sentence-end-double-space nil
      delete-by-moving-to-trash t
      create-lockfiles nil
      make-backup-files t
      version-control t
      kept-new-versions 10
      kept-old-versions 3
      delete-old-versions t
      backup-directory-alist `(("." . ,(expand-file-name "backup/" my/cache-dir)))
      auto-save-default t
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" my/cache-dir) t)))

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

(setq ring-bell-function #'ignore
      use-short-answers t
      completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

(column-number-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)

(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))
(add-hook 'text-mode-hook #'visual-line-mode)

(setq scroll-margin 3
      scroll-conservatively 101
      scroll-preserve-screen-position t)

;; --- Session -------------------------------------------------------------

(setq recentf-save-file (expand-file-name "recentf" my/cache-dir)
      recentf-max-saved-items 200
      savehist-file (expand-file-name "history" my/cache-dir)
      history-length 200
      save-place-file (expand-file-name "places" my/cache-dir))

(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(use-package which-key
  :ensure nil ; built in since Emacs 29
  :custom (which-key-idle-delay 0.3)
  :config (which-key-mode 1))

(use-package editorconfig
  :ensure nil ; built in since Emacs 30
  :config (editorconfig-mode 1))

;; --- Appearance ----------------------------------------------------------

(defun my/font-installed-p (family)
  "Return non-nil when FAMILY is available."
  (member family (font-family-list)))

(defconst my/nerd-font-installed-p
  (and (display-graphic-p)
       (seq-some (lambda (f) (string-match-p "Nerd Font" f)) (font-family-list)))
  "Whether any Nerd Font is present, for icon-dependent packages.")

;; Plain modus is pure white on pure black (#ffffff / #000000).  The `-tinted'
;; pair uses a warmer background and a distinctly different syntax palette,
;; not merely a recoloured background; swap these two values to try it.
;; `M-x modus-themes-select' previews every variant interactively.
(defvar my/light-theme 'modus-operandi "Theme used in light mode.")
(defvar my/dark-theme 'modus-vivendi "Theme used in dark mode.")

(defun my/load-theme (theme)
  "Load THEME, first disabling any currently enabled themes."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme :no-confirm))

(defun my/toggle-theme ()
  "Toggle between `my/light-theme' and `my/dark-theme'."
  (interactive)
  (my/load-theme (if (memq my/light-theme custom-enabled-themes)
                     my/dark-theme
                   my/light-theme))
  (message "Theme: %s" (car custom-enabled-themes)))

;; Emacs bundles the modus theme *files*, but not `modus-themes.el' itself,
;; which is where the customization options and the newest palettes live.
(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-org-blocks 'gray-background)
  :config
  (my/load-theme my/light-theme))

;; First installed family wins.  `:height' is in tenths of a point, so 155 is
;; 15.5pt.
(let ((size (if (eq system-type 'darwin) 155 130)))
  (when-let* ((family (seq-find #'my/font-installed-p
                                '("JetBrainsMono Nerd Font"
                                  "FiraCode Nerd Font"
                                  "Inconsolata Nerd Font"))))
    (set-face-attribute 'default nil :family family :height size)))

(use-package nerd-icons
  :if my/nerd-font-installed-p)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-modeline
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-project-detection 'project)
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-icon my/nerd-font-installed-p)
  (doom-modeline-major-mode-icon my/nerd-font-installed-p)
  (doom-modeline-minor-modes nil)
  :init (doom-modeline-mode 1))

;; --- Health check --------------------------------------------------------

(defconst my/emacs-health-checks
  '((required "git"                      "Magit, Forge, and project detection")
    (required "rg"                       "Project search via consult")
    (required "node"                     "TypeScript and JavaScript toolchain")
    (optional "fd"                       "Faster file finding")
    (optional "vtsls"                    "TypeScript / JavaScript LSP")
    (optional "rust-analyzer"            "Rust LSP")
    (optional "ocamllsp"                 "OCaml LSP")
    (optional "basedpyright-langserver"  "Python LSP")
    (optional "yaml-language-server"     "YAML LSP")
    (optional "docker-langserver"        "Dockerfile LSP")
    (optional "ruff"                     "Python lint and format")
    (optional "prettier"                 "Web, JSON, YAML, Markdown format")
    (optional "sql-formatter"            "SQL format")
    (optional "ocamlformat"              "OCaml format")
    (optional "debugpy"                  "dape: Python debugging")
    (optional "lldb-dap"                 "dape: Rust / native debugging")
    (optional "gh"                       "Forge authentication")
    (optional "enchant-2"                "jinx spellchecker backend"))
  "External tools this configuration expects, checked by `my/emacs-health-check'.")

(defun my/emacs-health-check ()
  "Report which expected external tools are available on PATH."
  (interactive)
  (with-current-buffer (get-buffer-create "*Emacs Health*")
    (let ((inhibit-read-only t)
          (missing-required 0))
      (erase-buffer)
      (insert (format "Emacs health check — %s\n\n" (system-name)))
      (pcase-dolist (`(,kind ,command ,description) my/emacs-health-checks)
        (let ((found (executable-find command)))
          (when (and (eq kind 'required) (not found))
            (cl-incf missing-required))
          (insert (format "[%-7s] %-26s %-9s %s\n"
                          (if found "ok" "MISSING")
                          command
                          (if (eq kind 'required) "required" "optional")
                          description))))
      (insert (format "\nGrammars: %s\n"
                      (mapconcat
                       (lambda (l)
                         (format "%s%s" l (if (treesit-language-available-p l) "" "(!)")))
                       '(typescript tsx javascript rust python yaml json toml dockerfile)
                       " ")))
      (insert "\nLocal overrides:\n")
      (dolist (file '("local-pre.el" "local-post.el" "custom.el"))
        (insert (format "  %-16s %s\n" file
                        (if (file-exists-p (expand-file-name file user-emacs-directory))
                            "present" "absent"))))
      (unless (zerop missing-required)
        (insert (format "\n%d required tool(s) missing.\n" missing-required)))
      (goto-char (point-min))
      (special-mode)
      (pop-to-buffer (current-buffer)))))

(provide 'core)
;;; core.el ends here
