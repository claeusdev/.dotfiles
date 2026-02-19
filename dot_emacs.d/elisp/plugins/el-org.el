;;; el-org.el --- Org workflow for planning and research -*- lexical-binding: t; -*-

(defconst my/org-directory (expand-file-name "~/org")
  "Primary directory for Org files.")

(defconst my/org-inbox-file (expand-file-name "inbox.org" my/org-directory))
(defconst my/org-projects-file (expand-file-name "projects.org" my/org-directory))
(defconst my/org-research-file (expand-file-name "research.org" my/org-directory))
(defconst my/org-reading-file (expand-file-name "reading.org" my/org-directory))
(defconst my/org-journal-file (expand-file-name "journal.org" my/org-directory))
(defconst my/org-bibliography-file (expand-file-name "references.bib" my/org-directory))
(defconst my/org-papers-directory (expand-file-name "papers" my/org-directory))

(defun my/org-setup-writing ()
  "Set sensible defaults for long-form writing and notes."
  (visual-line-mode 1)
  (setq-local line-spacing 0.12))

(use-package org
  :ensure nil
  :hook (org-mode . my/org-setup-writing)
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :config
  (unless (file-directory-p my/org-directory)
    (make-directory my/org-directory t))

  (setq org-directory my/org-directory
        org-default-notes-file my/org-inbox-file
        org-agenda-files
        (list my/org-inbox-file
              my/org-projects-file
              my/org-research-file
              my/org-reading-file
              my/org-journal-file)
        org-log-done 'time
        org-log-into-drawer t
        org-startup-indented t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-ellipsis " ▾"
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-targets '((org-agenda-files :maxlevel . 3))
        org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

  (setq org-capture-templates
        `(("t" "Todo" entry
           (file+headline ,my/org-inbox-file "Inbox")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n")
          ("i" "Idea" entry
           (file+headline ,my/org-research-file "Ideas")
           "* %^{Idea title}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?")
          ("p" "Paper note" entry
           (file+headline ,my/org-reading-file "Papers")
           "* TODO Read %^{Paper title}\n:PROPERTIES:\n:CREATED: %U\n:AUTHORS: %^{Authors}\n:VENUE: %^{Venue}\n:END:\n%?")
          ("j" "Journal" entry
           (file+olp+datetree ,my/org-journal-file)
           "* %U %?\n")))

  ;; Enable citations automatically if a bibliography exists.
  (when (file-exists-p my/org-bibliography-file)
    (setq org-cite-global-bibliography (list my/org-bibliography-file)))

  ;; Org-babel — execute source blocks in org files.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (julia . t)
     (shell . t)
     (latex . t)))
  (setq org-confirm-babel-evaluate nil
        org-babel-python-command "python3"
        org-src-preserve-indentation t))

(use-package citar
  :ensure t
  :after org
  :bind (("C-c b i" . citar-insert-citation)
         ("C-c b o" . citar-open)
         ("C-c b n" . citar-open-notes)
         ("C-c b a" . citar-add-file-to-library))
  :custom
  (citar-bibliography (list my/org-bibliography-file))
  (citar-library-paths (list my/org-papers-directory))
  (citar-notes-paths (list my/org-reading-file))
  :config
  (unless (file-directory-p my/org-papers-directory)
    (make-directory my/org-papers-directory t))
  (setq org-cite-insert-processor 'citar
        org-cite-follow-processor 'citar
        org-cite-activate-processor 'citar))

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (expand-file-name "roam" my/org-directory))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n c" . org-roam-capture)
         ("C-c n d" . org-roam-dailies-goto-today))
  :config
  (unless (file-directory-p org-roam-directory)
    (make-directory org-roam-directory t))
  (org-roam-db-autosync-mode))

(provide 'el-org)
;;; el-org.el ends here
