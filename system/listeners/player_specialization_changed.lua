NetherMachine.listener.register("PLAYER_SPECIALIZATION_CHANGED", function(unitID)
  if unitID ~= 'player' then return end

  NetherMachine.module.player.updateSpec()
end)
