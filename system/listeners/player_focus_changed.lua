NetherMachine.listener.register("PLAYER_FOCUS_CHANGED", function(...)
  NetherMachine.module.player.focus = Unit
end)

NetherMachine.listener.register("PLAYER_TARGET_CHANGED", function(...)
  if NetherMachine.faceroll.rolling then
  	NetherMachine.faceroll.activeFrame:Hide()
  end
end)
