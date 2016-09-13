local behindResolution = 2
NetherMachine.timer.register("player", function()
  if not NetherMachine.module.player.behind then
    NetherMachine.module.player.behind = true
  end
end, 3000)
