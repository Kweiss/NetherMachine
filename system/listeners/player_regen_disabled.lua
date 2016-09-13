NetherMachine.listener.register("PLAYER_REGEN_DISABLED", function(...)
  NetherMachine.module.player.combat = true
  NetherMachine.module.player.combatTime = GetTime()
end)
