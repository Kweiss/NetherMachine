NetherMachine.module = {}
local module = NetherMachine.module

function module.register(name, struct)
  module[name] = struct
end

function module.unregister(name)
  module[name] = nil
end
