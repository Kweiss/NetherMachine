NetherMachine.listener.register("UI_ERROR_MESSAGE", function(...)
  local error = ...
  if error == SPELL_FAILED_NOT_BEHIND then
    NetherMachine.module.player.behind = false
    NetherMachine.module.player.behindTime = time()
  elseif error == SPELL_FAILED_UNIT_NOT_INFRONT then
    NetherMachine.module.player.infront = false
    NetherMachine.module.player.infrontTime = time()
  elseif error == SPELL_FAILED_TARGET_NO_RANGED_WEAPONS then
    NetherMachine.module.disarm.fail()
  elseif error == SPELL_FAILED_BAD_TARGETS then
    NetherMachine.module.disarm.fail(NetherMachine.parser.lastCast)
  end
end)
