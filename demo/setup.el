(require 'ox-beamer)

(setq startup-dir (with-current-buffer "*Messages*" default-directory))
(defun tobeamer (&optional dir)
  "Export current org buffer to a latex file in directory DIR."
  (interactive "DDirectory: ")
  (let ((name (file-name-base (buffer-file-name))))
    (org-beamer-export-as-latex)
    (cd startup-dir)
    (write-file (concat (file-name-as-directory dir) name ".tex"))))
