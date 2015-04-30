local function castSent(unitID, spell)
  if unitID == 'player' then
    NetherMachine.parser.lastCast = spell
    NetherMachine.parser.lastCastTime = GetTime()
    NetherMachine.dataBroker.previous_spell.text = NetherMachine.parser.lastCast
    if NetherMachine.module.queue.spellQueue == spell then
      NetherMachine.module.queue.spellQueue = nil
    end
  end
end

NetherMachine.listener.register('UNIT_SPELLCAST_SENT', castSent)
