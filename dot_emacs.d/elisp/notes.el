;;; notes.el --- Org, Denote, writing and presentations -*- lexical-binding: t; -*-

;;; Commentary:
;; Org handles capture and agenda over a small fixed set of files.  Denote
;; handles durable, linkable notes: plain files whose names encode date, title
;; and keywords, with no database to rebuild.

;;; Code:

;; --- Org -----------------------------------------------------------------

(use-package org
  :ensure nil
  :custom
  (org-directory "~/org/")
  (org-default-notes-file "~/org/inbox.org")
  (org-agenda-files '("~/org/inbox.org" "~/org/projects.org" "~/org/journal.org"))
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@)" "|" "DONE(d)" "CANCELLED(c@)")))
  (org-tag-alist '(("@research" . ?r) ("@coding" . ?c) ("@writing" . ?w) ("@admin" . ?a)))
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-return-follows-link t)
  (org-catch-invisible-edits 'show)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-edit-src-content-indentation 0)
  (org-use-fast-todo-selection 'expert)
  (org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks")
      "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n%a")
     ("i" "Idea" entry (file+headline "~/org/inbox.org" "Ideas")
      "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n%a")
     ("p" "Project task" entry (file+headline "~/org/projects.org" "Active")
      "* NEXT %^{Task}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%a\n\n** Notes\n%?")
     ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
      "* %?\nEntered on %U\n")))
  :hook (org-mode . visual-line-mode)
  :config
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-agenda-span 1)))
            (todo "NEXT")
            (todo "TODO" ((org-agenda-overriding-header "Inbox")))
            (tags-todo "@coding")
            (tags-todo "@research")))
          ("r" "Research" tags-todo "@research")
          ("w" "Writing" tags-todo "@writing")))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t) (shell . t)))
  ;; SVG previews stay crisp on retina displays; dvisvgm ships with MacTeX.
  (when (executable-find "dvisvgm")
    (setq org-preview-latex-default-process 'dvisvgm)))

;; --- Denote --------------------------------------------------------------

(use-package denote
  :custom
  (denote-directory (expand-file-name "~/notes/"))
  (denote-file-type 'org)
  (denote-known-keywords
   '("emacs" "typescript" "rust" "ocaml" "python" "sql"
     "systems" "research" "project" "reading"))
  (denote-prompts '(title keywords))
  (denote-date-prompt-use-org-read-date t)
  :config
  (make-directory denote-directory t)
  ;; Show the readable title in the buffer name rather than the raw filename.
  (denote-rename-buffer-mode 1))

(defun my/denote-search ()
  "Ripgrep across all Denote notes."
  (interactive)
  (consult-ripgrep denote-directory))

(defun my/denote-find ()
  "Find a Denote note by filename."
  (interactive)
  (let ((default-directory denote-directory))
    (call-interactively #'find-file)))

;; --- Writing -------------------------------------------------------------

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-star 'replace)
  (org-modern-table nil)) ; leave table alignment to Org itself

(use-package olivetti
  :hook ((org-mode . olivetti-mode)
         (markdown-mode . olivetti-mode))
  :custom (olivetti-body-width 90))

;; --- Math ------------------------------------------------------------------

;; Fast LaTeX math entry inside Org: ` opens a symbol menu, _ and ^ insert
;; scripts with braces, TAB expands templates like fr and env names.
(use-package cdlatex
  :hook (org-mode . org-cdlatex-mode))

;; Render a LaTeX fragment when the cursor leaves it, un-render on re-entry.
(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

;; Just-in-time spellchecker; needs the enchant library.
(use-package jinx
  :hook ((text-mode . jinx-mode)
         (org-mode . jinx-mode))
  :bind ("M-$" . jinx-correct))

;; --- Presentations -------------------------------------------------------

;; Defined before the `use-package' form that hooks them, so the byte-compiler
;; sees the definitions first.
(declare-function org-present-big "org-present")
(declare-function org-present-small "org-present")
(declare-function org-present-hide-cursor "org-present")
(declare-function org-present-show-cursor "org-present")
(declare-function org-present-read-only "org-present")
(declare-function org-present-read-write "org-present")

(defun my/org-present-start ()
  "Enter a distraction-free presentation view."
  (org-present-big)
  (org-display-inline-images)
  (org-present-hide-cursor)
  (org-present-read-only)
  (display-line-numbers-mode -1)
  (olivetti-mode 1))

(defun my/org-present-stop ()
  "Restore the buffer after presenting."
  (org-present-small)
  (org-remove-inline-images)
  (org-present-show-cursor)
  (org-present-read-write))

(use-package org-present
  :commands org-present
  :hook ((org-present-mode . my/org-present-start)
         (org-present-mode-quit . my/org-present-stop)))

;; --- LLM -----------------------------------------------------------------

;; The API key is read from ~/.authinfo.gpg, never from the shell environment,
;; so it cannot leak into the dotfiles repo:
;;   machine api.anthropic.com login apikey password sk-ant-...
(use-package gptel
  :commands (gptel gptel-send gptel-menu)
  :custom
  (gptel-default-mode 'org-mode)
  :config
  (setq gptel-model 'claude-sonnet-5
        gptel-backend (gptel-make-anthropic "Claude"
                        :stream t
                        :key (lambda ()
                               (or (auth-source-pick-first-password
                                    :host "api.anthropic.com" :user "apikey")
                                   (getenv "ANTHROPIC_API_KEY"))))))

(provide 'notes)
;;; notes.el ends here
