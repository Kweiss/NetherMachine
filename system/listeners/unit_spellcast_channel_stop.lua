local function channelStop(unitID)
  if unitID == 'player' then
    NetherMachine.module.player.casting = false
  elseif unitID == 'pet' then
    NetherMachine.module.pet.casting = false
  end
end

NetherMachine.listener.register('UNIT_SPELLCAST_CHANNEL_STOP', channelStop)
