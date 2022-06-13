;; This module is a port from the widely used Love2D fennel repl, found here
;; https://gitlab.com/alexjgriffith/min-love2d-fennel

;; This module exists in order to expose stdio over a channel so that it
;; can be used in a non-blocking way from another thread.

(local fennel (require :lib.fennel))

;; When ran from a thread, we must manually require in lovr modules
(local lovr (require :lovr))
(set lovr.event (require :lovr.event))
(set lovr.thread (require :lovr.thread))

(fn prompt [cont?]
  (io.write (if cont? ".." ">> "))
  (io.flush)
  (.. (tostring (io.read)) "\n"))

(fn looper [event]
  (let [channel (lovr.thread.getChannel :fennel-repl)
        channel-data (channel:pop true)]
    (when channel-data
      (match (type channel-data)
        :string (do (io.write channel-data)
                    (io.write "\n"))
        :number (lovr.event.push event (prompt (< channel-data 0)))))
    (looper event)))

;; This module is loaded twice: initially in the main thread where ... is nil,
;; and then again in a separate thread where ... contains the string :eval, used to
;; start the looper
(match ...
  (:eval) (looper :eval))

{:start (fn start-repl []
          (let [luac (lovr.filesystem.read "lib/lovr-stdio-repl.lua")
                thread (lovr.thread.newThread luac)
                io-channel (lovr.thread.getChannel :fennel-repl)
                coro (coroutine.create fennel.repl)
                options {:readChunk (fn [{: stack-size}]
                                      (io-channel:push stack-size)
                                      (coroutine.yield))
                         :onValues (fn [vals]
                                     (io-channel:push (table.concat vals "\t")))
                         :onError (fn [errtype err]
                                    (io-channel:push err))}]
            ;; this thread will send "eval" events for us to consume:
            (coroutine.resume coro options)
            ;(thread:start "eval" io-channel)
            (set lovr.handlers.eval
                 (fn [input]
                   (coroutine.resume coro input)))
            (thread:start "eval")))}
