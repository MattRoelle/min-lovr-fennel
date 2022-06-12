{:draw (fn draw [message]
         (lovr.graphics.print "hello from fennel" 0 1.7 -3 0.5))
 :update (fn update [dt set-mode])
 :keypressed (fn keypressed [key set-mode])}
