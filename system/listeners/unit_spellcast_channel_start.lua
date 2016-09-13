local function channelStart(unitID)
  if unitID == 'player' then
    if NetherMachine.module.queue.spellQueue == name then
      NetherMachine.module.queue.spellQueue = nil
    end
    NetherMachine.module.player.casting = true
    NetherMachine.parser.lastCast = UnitChannelInfo('player')
    NetherMachine.parser.lastCastTime = GetTime()
    NetherMachine.dataBroker.previous_spell.text = NetherMachine.parser.lastCast
  elseif unitID == 'pet' then
    NetherMachine.module.pet.casting = true
  end
end

NetherMachine.listener.register('UNIT_SPELLCAST_CHANNEL_START', channelStart)
