local warningSent = false

NetherMachine.timer.register("lag", function()
  local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
  NetherMachine.lag = latencyWorld
  -- Dynamic rotation timing
  if NetherMachine.config.read('pe_dynamic', false) then
    if NetherMachine.lag < 500 then
      NetherMachine.cycleTime = NetherMachine.lag
      NetherMachine.timer.updatePeriod("rotation", NetherMachine.cycleTime)
      NetherMachine.debug.print("Dynamic Cycle Update: " .. NetherMachine.cycleTime .. "ms" , 'dynamic')
    end
  else
    NetherMachine.cycleTime = NetherMachine.config.read('dyncycletime', 100)
  end
end, 2000)
