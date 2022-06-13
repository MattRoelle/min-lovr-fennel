local fennel = require("lib.fennel")
local lovr = require("lovr")
lovr.event = require("lovr.event")
lovr.thread = require("lovr.thread")
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
local function looper(event)
  local channel = lovr.thread.getChannel("fennel-repl")
  local channel_data = channel:pop(true)
  if channel_data then
    local _2_ = type(channel_data)
    if (_2_ == "string") then
      io.write(channel_data)
      io.write("\n")
    elseif (_2_ == "number") then
      lovr.event.push(event, prompt((channel_data < 0)))
    else
    end
  else
  end
  return looper(event)
end
do
  local _5_ = ...
  if (_5_ == "eval") then
    looper("eval")
  else
  end
end
local function start_repl()
  local luac = lovr.filesystem.read("lib/lovr-stdio-repl.lua")
  local thread = lovr.thread.newThread(luac)
  local io_channel = lovr.thread.getChannel("fennel-repl")
  local coro = coroutine.create(fennel.repl)
  local options
  local function _9_(_7_)
    local _arg_8_ = _7_
    local stack_size = _arg_8_["stack-size"]
    io_channel:push(stack_size)
    return coroutine.yield()
  end
  local function _10_(vals)
    return io_channel:push(table.concat(vals, "\9"))
  end
  local function _11_(errtype, err)
    return io_channel:push(err)
  end
  options = {readChunk = _9_, onValues = _10_, onError = _11_}
  coroutine.resume(coro, options)
  local function _12_(input)
    return coroutine.resume(coro, input)
  end
  lovr.handlers.eval = _12_
  return thread:start("eval")
end
return {start = start_repl}
