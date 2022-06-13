{:draw (fn draw [message]
         (lovr.graphics.print "hello from fennel" 0 1.7 -3 0.5)
         (lovr.graphics.print "Press e to test error handling" 0 1.0 -3 0.25))
 :update (fn update [dt set-mode])
 :keypressed (fn keypressed [key set-mode]
               (when (= :e key)
                 (error :oops)))}
