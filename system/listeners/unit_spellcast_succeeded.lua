local GetSpellInfo = GetSpellInfo

local ignoreSpells = { 75 } -- Auto Shot

NetherMachine.listener.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
  local unitID, spell, rank, lineID, spellID = ...
  if unitID == "player" then
    local name, _, icon = GetSpellInfo(spell)
    if NetherMachine.module.queue.spellQueue == name then
      NetherMachine.module.queue.spellQueue = nil
    end
    NetherMachine.actionLog.insert('Spell Cast Succeed', name, icon)
    NetherMachine.module.player.cast(spell)
    NetherMachine.module.player.infront = true
  end
end)

NetherMachine.listener.register("visualCast", "UNIT_SPELLCAST_SUCCEEDED", function(...)
  local activeFrame = NetherMachine.faceroll.activeFrame
  local unitID, spell, rank, lineID, spellID = ...
  if unitID == "player" then
    if spell == NetherMachine.current_spell then
      activeFrame:Hide()
      NetherMachine.current_spell = false
    end
  end
end)
