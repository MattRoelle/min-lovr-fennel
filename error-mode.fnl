;; This mode has two purposes:
;; * display the stack trace that caused the error
;; * allow the user to decide whether to retry after reloading or quit

;; Since we can't know which module needs to be reloaded, we rely on the user
;; doing a ,reload foo in the repl.

(var state nil)

(local explanation "Press escape to quit.
Press space to return to the previous mode after reloading in the repl.")

(fn draw []
  (lovr.graphics.print explanation 0 1.7 -3 0.5)
  (lovr.graphics.print state.traceback 0 2.7 -3 0.5))

(fn keypressed [key set-mode]
  (match key
    :escape (lovr.quit)
    :space (set-mode state.old-mode)))

(fn activate [old-mode msg traceback]
  (print msg)
  (print traceback)
  (set state {: old-mode : msg : traceback}))

{: draw : keypressed : activate}
