NetherMachine.listener.register("PLAYER_REGEN_ENABLED", function(...)
  NetherMachine.module.player.combat = false
  NetherMachine.module.player.oocombatTime = GetTime()
  NetherMachine.module.player.castCache = {}
end)
