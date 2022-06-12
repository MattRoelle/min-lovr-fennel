require("lovr")
require("lovr.system")
require("lovr.filesystem")
require("lovr.event")
require("lovr.thread")
local function prompt(cont_3f)
  local function _1_()
    if cont_3f then
      return ".."
    else
      return ">> "
    end
  end
  io.write(_1_())
  io.flush()
  return (tostring(io.read()) .. "\n")
end
local function looper(event, channel)
  do
    local _2_ = channel:demand()
    if ((_G.type(_2_) == "table") and ((_2_)[1] == "write") and (nil ~= (_2_)[2])) then
      local vals = (_2_)[2]
      io.write(table.concat(vals, "\9"))
      io.write("\n")
    elseif ((_G.type(_2_) == "table") and ((_2_)[1] == "read") and (nil ~= (_2_)[2])) then
      local cont_3f = (_2_)[2]
      lovr.event.push(event, prompt(cont_3f))
    else
    end
  end
  return looper(event, channel)
end
do
  local _4_, _5_ = ...
  if ((nil ~= _4_) and (nil ~= _5_)) then
    local event = _4_
    local channel = _5_
    looper(event, channel)
  else
  end
end
local function start_repl()
  local luac = lovr.filesystem.read("lib/stdio.lua")
  local thread = lovr.thread.newThread(luac)
  local io_channel = lovr.thread.getChannel("fennel-repl")
  local coro = coroutine.create(fennel.repl)
  local options
  local function _9_(_7_)
    local _arg_8_ = _7_
    local stack_size = _arg_8_["stack-size"]
    io_channel:push({"read", (0 < stack_size)})
    return coroutine.yield()
  end
  local function _10_(vals)
    return io_channel:push({"write", vals})
  end
  local function _11_(errtype, err)
    return io_channel:push({"write", {err}})
  end
  options = {readChunk = _9_, onValues = _10_, onError = _11_, moduleName = "lib.fennel"}
  coroutine.resume(coro, options)
  thread:start("eval", io_channel)
  local function _12_(input)
    return coroutine.resume(coro, input)
  end
  lovr.handlers.eval = _12_
  return nil
end
return {start = start_repl}
