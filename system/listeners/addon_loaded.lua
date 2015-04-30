local L = NetherMachine.locale.get

NetherMachine.listener.register("ADDON_LOADED", function(...)

  local addon = ...

  if string.lower(addon) ~= string.lower(NetherMachine.addonReal) then return end

  -- load all our config data
  NetherMachine.config.load(NetherMachine_ConfigData)

  -- load our previous button states
  NetherMachine.buttons.loadStates()

  -- Turbo
  NetherMachine.config.read('pe_turbo', false)

  -- Dynamic Cycle
  NetherMachine.config.read('pe_dynamic', false)

end)
