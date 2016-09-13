NetherMachine.listener.register("ADDON_ACTION_BLOCKED", function(...)
  -- We can attempt to hide these without totally raping the UI
  local addon, event = ...
  if addon == NetherMachine.addonReal then
    StaticPopup1:Hide()
    NetherMachine.full = false
    NetherMachine.debug.print("Event Blocked: " .. event, 'action_block')
  end
end)
