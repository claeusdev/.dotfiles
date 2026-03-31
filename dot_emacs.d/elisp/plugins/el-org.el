;;; el-org.el --- Org mode configuration -*- lexical-binding: t; -*-

;;; Code:

(defun my/org-path (name)
  "Return absolute path to NAME under `org-directory'."
  (expand-file-name name org-directory))

(defun my/org-ensure-directory (dir)
  "Create DIR if needed and return it."
  (make-directory dir t)
  dir)

(defun my/org-ensure-file (path content)
  "Create PATH with CONTENT if it does not already exist."
  (unless (file-exists-p path)
    (make-directory (file-name-directory path) t)
    (with-temp-file path
      (insert content))))

(defun my/org-bootstrap-files ()
  "Ensure the core Org directories and files exist."
  (my/org-ensure-directory (file-name-as-directory org-directory))
  (my/org-ensure-directory (my/org-path "roam/projects"))
  (my/org-ensure-directory (my/org-path "roam/literature"))
  (my/org-ensure-directory (my/org-path "roam/daily"))
  (my/org-ensure-directory (my/org-path "pdfs"))
  (my/org-ensure-directory (my/org-path "images"))
  (my/org-ensure-file (my/org-path "inbox.org")
                      "#+title: Inbox\n\n* Tasks\n\n* Ideas\n")
  (my/org-ensure-file (my/org-path "projects.org")
                      "#+title: Projects\n\n* Active\n\n* Someday\n")
  (my/org-ensure-file (my/org-path "papers.org")
                      "#+title: Papers\n\n* Inbox\n\n* Reading\n\n* Done\n")
  (my/org-ensure-file (my/org-path "journal.org")
                      "#+title: Journal\n"))

(defun my/org-notes-search ()
  "Search the Org and org-roam note directories."
  (interactive)
  (consult-ripgrep (list (file-name-as-directory org-directory)
                         (my/org-path "roam/"))))

(defun my/org-open-inbox ()
  "Open the main Org inbox."
  (interactive)
  (find-file (my/org-path "inbox.org")))

(defun my/org-open-projects ()
  "Open the main Org projects file."
  (interactive)
  (find-file (my/org-path "projects.org")))

(defun my/org-open-papers ()
  "Open the main Org papers file."
  (interactive)
  (find-file (my/org-path "papers.org")))

(defun my/org-open-journal ()
  "Open the main Org journal file."
  (interactive)
  (find-file (my/org-path "journal.org")))

(defun my/org-roam-find-literature ()
  "Find a literature note in org-roam."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (member "literature" (org-roam-node-tags node)))))

(use-package org
  :ensure nil
  :custom
  (org-directory "~/org/")
  (org-default-notes-file "~/org/inbox.org")
  (org-agenda-files '("~/org/inbox.org" "~/org/projects.org" "~/org/papers.org" "~/org/journal.org"))
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@)" "|" "DONE(d)" "CANCELLED(c@)")))
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
  (org-hide-block-startup nil)
  (org-use-fast-todo-selection 'expert)
  (org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (org-outline-path-complete-in-steps nil)
  (org-refile-use-outline-path 'file)
  (org-confirm-babel-evaluate #'my/org-confirm-babel-evaluate)
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks")
      "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n%a" :clock-in t :clock-resume t)
     ("i" "Idea" entry (file+headline "~/org/inbox.org" "Ideas")
      "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n%a")
     ("p" "Project task" entry (file+headline "~/org/projects.org" "Active")
      "* NEXT %^{Task}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%a\n\n** Notes\n%?")
     ("R" "Paper" entry (file+headline "~/org/papers.org" "Papers")
      "* TODO Read %^{Title}\n:PROPERTIES:\n:AUTHOR: %^{Author}\n:YEAR: %^{Year}\n:CREATED: %U\n:END:\n** Why it matters\n%?\n** Notes\n")
     ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
      "* %?\nEntered on %U\n")))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   :map org-mode-map
   ("C-c n s" . my/org-notes-search)
   ("C-c n i" . my/org-open-inbox)
   ("C-c n p" . my/org-open-projects))
  :hook (org-mode . (lambda ()
                      (visual-line-mode 1)
                      (setq line-spacing 0.1)))
  :config
  (my/org-bootstrap-files)
  (defun my/org-confirm-babel-evaluate (lang _body)
    "Only skip confirmation for trusted LANG values."
    (not (member lang '("emacs-lisp" "python" "latex"))))
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-agenda-span 1)))
            (todo "TODO" ((org-agenda-overriding-header "Inbox")))
            (todo "NEXT")
            (tags-todo "@research")
            (tags-todo "@coding")))
          ("r" "Research" tags-todo "@research")
          ("w" "Writing" tags-todo "@writing")
          ("i" "Inbox" tags-todo "+LEVEL=1")
          ("p" "Projects" tags-todo "+@coding|+@research")))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (latex . t))))

;; Org-superstar
(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

;; Citar — bibliography management
(use-package citar
  :custom
  (citar-bibliography '("~/org/references.bib"))
  (citar-notes-paths '("~/org/roam/literature/"))
  (citar-library-paths '("~/org/pdfs/"))
  (citar-open-note-function #'citar-open-notes)
  :bind
  (:map org-mode-map
   :prefix-map my/citar-map
   :prefix "C-c b"
   ("o" . citar-open)
   ("i" . citar-insert-citation)
   ("n" . citar-open-notes)))

;; Org-noter — PDF annotation alongside org notes
(use-package org-noter
  :after org
  :custom
  (org-noter-notes-search-path '("~/org/roam/"))
  (org-noter-auto-save-last-location t)
  (org-noter-default-notes-file-names '("notes.org"))
  :bind (:map org-mode-map
         ("C-c N" . org-noter)))

;; Org-download — drag-and-drop images into org
(use-package org-download
  :after org
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "~/org/images/")
  (org-download-heading-lvl nil)
  :hook (org-mode . org-download-enable))

;; Org-present — present from org files
(use-package org-present
  :commands org-present
  :hook ((org-present-mode
          . (lambda ()
              (org-present-big)
              (org-display-inline-images)
              (org-present-hide-cursor)
              (org-present-read-only)))
         (org-present-mode-quit
          . (lambda ()
              (org-present-small)
              (org-remove-inline-images)
              (org-present-show-cursor)
              (org-present-read-write)))))

;; Org-roam
(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam/")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "${slug}.org" "#+title: ${title}\n#+created: %U\n\n* Summary\n\n")
      :unnarrowed t)
     ("p" "project" plain "%?"
      :if-new (file+head "projects/${slug}.org" "#+title: ${title}\n#+filetags: :project:\n#+created: %U\n\n* Context\n\n* Next Actions\n\n* References\n\n")
      :unnarrowed t)
     ("l" "literature" plain "%?"
      :if-new (file+head "literature/${slug}.org" "#+title: ${title}\n#+filetags: :literature:\n#+created: %U\n\n* Summary\n\n* Notes\n\n* Quotes\n\n")
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %<%H:%M> %?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n\n* Plan\n\n* Log\n\n* Reading\n\n"))))
  :config
  (org-roam-db-autosync-mode 1))

;; Citar-org-roam — bridge bibliography and roam notes
(use-package citar-org-roam
  :after (citar org-roam)
  :config (citar-org-roam-mode 1))

(provide 'el-org)
;;; el-org.el ends here
