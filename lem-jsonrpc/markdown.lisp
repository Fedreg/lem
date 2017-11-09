(defpackage :lem-jsonrpc.markdown
  (:use :cl :lem :lem-jsonrpc))
(in-package :lem-jsonrpc.markdown)

(define-major-mode markdown-mode ()
    (:name "markdown"
     :keymap *markdown-mode-keymap*)
  (import-electron-module "./markdown-preview/markdown-preview")
  (markdown-update)
  (add-hook (variable-value 'after-change-functions
                            :buffer (current-buffer))
            (lambda (&rest args)
              (declare (ignore args))
              (markdown-update))))

(defun send-markdown-text (text)
  (notify "markdown-update"
          (alexandria:plist-hash-table `("text" ,text)
                                       :test #'equal)))

(define-command markdown-update () ()
  (let ((buffer (current-buffer)))
    (send-markdown-text
     (points-to-string (buffer-start-point buffer)
                       (buffer-end-point buffer)))))

(pushnew (cons "\\.md$" 'markdown-mode) *auto-mode-alist* :test #'equal)
