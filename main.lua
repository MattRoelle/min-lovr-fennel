-- bootstrap the compiler
fennel = require("lib.fennel")
table.insert(package.loaders, fennel.make_searcher({correlate=true}))
pp = function(x) print(fennel.view(x)) end

local make_lovr_searcher = function(env)
   return function(module_name)
      local path = module_name:gsub("%.", "/") .. ".fnl"
      if lovr.filesystem.isFile(path) then
         return function(...)
            local code = lovr.filesystem.read(path)
            return fennel.eval(code, {env=env}, ...)
         end, path
      end
   end
end

table.insert(package.loaders, make_lovr_searcher(_G))
table.insert(fennel["macro-searchers"], make_lovr_searcher("_COMPILER"))

require("wrap")
