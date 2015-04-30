NetherMachine.listener.register("UNIT_HEALTH_FREQUENT", function(unitID)
  NetherMachine.raid.updateHealth(unitID)
end)
