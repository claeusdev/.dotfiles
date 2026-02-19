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

(provide 'el-org)
;;; el-org.el ends here
