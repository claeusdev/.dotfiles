;;; --- 10. ORG MODE ---
(use-package org
  :ensure nil
  :config
  (setq org-agenda-files '("~/org"))
  (use-package org-superstar
    :ensure t
    :hook (org-mode . org-superstar-mode))
  :bind (("C-c a" . org-agenda)))

(provide 'el-org)
