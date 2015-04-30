NetherMachine.listener.register("PLAYER_STARTED_MOVING", function(...)
	NetherMachine.module.player.moving = true
	NetherMachine.module.player.movingTime = GetTime()
end)

NetherMachine.listener.register("PLAYER_STOPPED_MOVING", function(...)
	NetherMachine.module.player.moving = false
	NetherMachine.module.player.movingTime = GetTime()
end)
