if NetherMachine.hardcore_debug == true then
  SetCVar('scriptProfile', 0) -- enable profiling
  NetherMachine.timer.register("profiling", function()
    UpdateAddOnCPUUsage()
    UpdateAddOnMemoryUsage()
    NetherMachine.cpu = GetAddOnCPUUsage(NetherMachine.addonReal)
    NetherMachine.mem = GetAddOnMemoryUsage(NetherMachine.addonReal)
    print(NetherMachine.cpu)
    print(NetherMachine.mem)
  end, 1000)
end
