(local fennel (require :lib.fennel))
(local repl (require :lib.lovr-stdio-repl))

;; set the first mode
(var (mode mode-name) nil)

(fn set-mode [new-mode-name ...]
  (set (mode mode-name) (values (require new-mode-name) new-mode-name))
  (when mode.activate
    (match (pcall mode.activate ...)
      (false msg) (print mode-name "activate error" msg))))

(fn lovr.load [args]
  (set-mode :mode-intro)
  (when (~= :web (. args 1)) (repl.start)))

(fn safely [f]
  (xpcall f #(set-mode :error-mode mode-name $ (fennel.traceback))))

(fn lovr.draw []
  (safely mode.draw))

(fn lovr.update [dt]
  (when mode.update
    (safely #(mode.update dt set-mode))))

(fn lovr.keypressed [key]
  (safely #(mode.keypressed key set-mode)))
