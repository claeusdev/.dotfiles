;;; el-org.el --- Org mode configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package org
  :ensure nil
  :custom
  (org-directory "~/org/")
  (org-default-notes-file "~/org/inbox.org")
  (org-agenda-files '("~/org/"))
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@)" "|" "DONE(d)" "CANCELLED(c@)")))
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-return-follows-link t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-confirm-babel-evaluate nil)
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks")
      "* TODO %?\n%U\n%a" :clock-in t :clock-resume t)
     ("i" "Idea" entry (file+headline "~/org/inbox.org" "Ideas")
      "* %?\n%U")
     ("p" "Paper" entry (file+headline "~/org/papers.org" "Papers")
      "* %^{Title}\n:PROPERTIES:\n:AUTHOR: %^{Author}\n:YEAR: %^{Year}\n:END:\n%?")
     ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
      "* %?\nEntered on %U\n")))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture))
  :hook (org-mode . (lambda ()
                      (visual-line-mode 1)
                      (setq line-spacing 0.1)))
  :config
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
  :bind
  (("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n b" . org-roam-buffer-toggle)
   ("C-c n c" . org-roam-capture)
   ("C-c n d" . org-roam-dailies-goto-today))
  :config
  (org-roam-db-autosync-mode 1))

;; Citar-org-roam — bridge bibliography and roam notes
(use-package citar-org-roam
  :after (citar org-roam)
  :config (citar-org-roam-mode 1))

(provide 'el-org)
;;; el-org.el ends here
