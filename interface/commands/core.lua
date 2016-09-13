local L = NetherMachine.locale.get
NetherMachine.command.help = {}

NetherMachine.command.register_help = function(key, help)
  NetherMachine.command.help[key] = help
end

NetherMachine.command.register_handler({'version', 'ver', 'v'}, function()
  NetherMachine.command.print('|cff' .. NetherMachine.addonColor .. 'NetherMachine |r' .. NetherMachine.version)
end)
NetherMachine.command.register_help('version', L('help_version'))

NetherMachine.command.register_handler({'toggleui', 'ui'}, function()
  NetherMachine.config.write('uishown', not NetherMachine.config.read('uishown'))
  if NetherMachine.config.read('uishown') then
    NetherMachine.buttons.buttonFrame:Show()
  else
    NetherMachine.buttons.buttonFrame:Hide()
  end
end)
NetherMachine.command.register_help('toggleui', L('help_toggleui'))

NetherMachine.command.register_handler({'help', '?', 'wat'}, function()
  NetherMachine.command.print('|cff' .. NetherMachine.addonColor .. 'NetherMachine |r' .. NetherMachine.version)
  for command, help in pairs(NetherMachine.command.help) do
    NetherMachine.command.print('|cff' .. NetherMachine.addonColor .. '/nm ' ..command .. '|r ' .. help)
  end
end)
NetherMachine.command.register_help('help', L('help_help'))

NetherMachine.command.register_handler({'cycle', 'pew', 'run'}, function()
  NetherMachine.cycle(true)
end)
NetherMachine.command.register_help('cycle', L('help_cycle'))

NetherMachine.command.register_handler({'toggle'}, function()
  NetherMachine.buttons.toggle('MasterToggle')
end)
NetherMachine.command.register_handler({'enable'}, function()
  NetherMachine.buttons.setActive('MasterToggle')
end)
NetherMachine.command.register_handler({'disable'}, function()
  NetherMachine.buttons.setInactive('MasterToggle')
end)

NetherMachine.command.register_help('toggle', L('help_toggle'))

NetherMachine.command.register_handler({'cd', 'cooldown', 'cooldowns'}, function()
  NetherMachine.buttons.toggle('cooldowns')
end)
NetherMachine.command.register_help('cd', L('cooldowns_tooltip'))

NetherMachine.command.register_handler({'kick', 'interrupts', 'interrupt', 'silence'}, function()
  NetherMachine.buttons.toggle('interrupt')
end)
NetherMachine.command.register_help('kick', L('interrupt_tooltip'))


NetherMachine.command.register_handler({'aoe', 'multitarget'}, function()
  NetherMachine.buttons.toggle('multitarget')
end)
NetherMachine.command.register_help('aoe', L('multitarget_tooltip'))


NetherMachine.command.register_handler({'al', 'log', 'actionlog'}, function()
  NM_ActionLog:Show()
end)
NetherMachine.command.register_help('al', L('help_al'))

NetherMachine.command.register_handler({'lag', 'cycletime'}, function()
  NM_CycleLag:Show()
end)

NetherMachine.command.register_handler({'turbo', 'godmode'}, function()
  local state = NetherMachine.config.toggle('pe_turbo')
  if state then
    NetherMachine.print(L('turbo_enable'))
    SetCVar('maxSpellStartRecoveryOffset', 1)
    SetCVar('reducedLagTolerance', 10)
    NetherMachine.cycleTime = 10
  else
    NetherMachine.print(L('turbo_disable'))
    SetCVar('maxSpellStartRecoveryOffset', 1)
    SetCVar('reducedLagTolerance', 100)
    NetherMachine.cycleTime = 100
  end
end)
NetherMachine.command.register_help('turbo', L('help_turbo'))

NetherMachine.command.register_handler({'bvt'}, function()
  local state = NetherMachine.config.toggle('buttonVisualText')
  NetherMachine.buttons.resetButtons()
  NetherMachine.rotation.add_buttons()
end)
