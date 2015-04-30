local L = NetherMachine.locale.get
local icon = LibStub("LibDBIcon-1.0")


NetherMachine.interface.minimap = { }

function NetherMachine.interface.minimap.create()
  if not NetherMachine_ConfigData.minimap then
    NetherMachine_ConfigData.minimap = {
      hide = false,
    }
  end
  icon:Register("NetherMachine", NetherMachine.dataBroker.icon, NetherMachine_ConfigData.minimap)
end
