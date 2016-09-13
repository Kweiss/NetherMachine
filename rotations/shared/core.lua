NetherMachine.rotation.shared = {
	-- Shared spells for all rotations
}

local LibDispellable = LibStub("LibDispellable-1.0")

-- No one was supposed to use this, fucking retarded...
NetherMachine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return NetherMachine.raid.needsHealing(tonumber(percent)) >= count
  end,
  canDispell = function(spell)
    for _, unit in pairs(NetherMachine.raid.roster) do
      if LibDispellable:CanDispelWith(unit.unit, GetSpellID(spell)) then
        NetherMachine.dsl.parsedTarget = unit.unit
        return true
      end
    end
  end,
  needsDispelled = function(spell)
    for _, unit in pairs(NetherMachine.raid.roster) do
      if UnitDebuff(unit.unit, spell) then
        NetherMachine.dsl.parsedTarget = unit.unit
        return true
      end
    end
  end,
})


-- Register commands
NetherMachine.command.register('ake', function(msg, box)
	local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == "config" or command == "settings" then
 		if GetSpecializationInfo(GetSpecialization()) == 262 then
			displayFrame(akeon_ele_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 66 then
			displayFrame(akeon_prot_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 70 then
			displayFrame(akeon_retri_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 63 then
			displayFrame(akeon_fire_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 62 then
			displayFrame(akeon_arcane_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 64 then
 			displayFrame(akeon_frost_config)
		end
	end
end)
