NetherMachine.listener.register("ADDON_ACTION_FORBIDDEN", function(...)
  -- We can attempt to hide these without totally raping the UI
  local addon, event = ...
  if addon == NetherMachine.addonName or addon == string.lower(NetherMachine.addonName) then
    StaticPopup1:Hide()
    NetherMachine.full = false
    NetherMachine.debug.print("Event Forbidden: " .. event, 'action_block')
  end
end)
