;;; el-dap.el --- DAP mode debugging -*- lexical-binding: t; -*-

;;; Code:

(use-package dap-mode
  :after eglot
  :commands (dap-debug dap-debug-restart dap-breakpoint-toggle dap-disconnect)
  :custom
  (dap-auto-configure-features '(sessions locals controls tooltip))
  :bind (:map dap-mode-map
         ("C-c d b" . dap-breakpoint-toggle)
         ("C-c d d" . dap-debug)
         ("C-c d n" . dap-next)
         ("C-c d c" . dap-continue)
         ("C-c d s" . dap-step-in)
         ("C-c d o" . dap-step-out)
         ("C-c d r" . dap-debug-restart)
         ("C-c d q" . dap-disconnect))
  :config
  (dap-auto-configure-mode 1))

(provide 'el-dap)
;;; el-dap.el ends here
