;;; --- 9. TERMINAL & KEYS ---
(defun my/toggle-vterm ()
  "Toggle vterm terminal at bottom."
  (interactive)
  (if (get-buffer "*vterm*")
      (if (string= (buffer-name) "*vterm*")
          (delete-window)
        (pop-to-buffer "*vterm*"))
    (vterm)))

(global-set-key (kbd "C-`") 'my/toggle-vterm)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-c w") 'delete-window)
(global-set-key (kbd "C-c r") 'replace-string)

;; Embark (Actions menu)
(use-package embark
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult))

(provide 'el-bindings)
