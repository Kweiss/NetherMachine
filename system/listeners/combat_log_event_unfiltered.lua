local HostileEvents = {
        ['SWING_DAMAGE'] = true,
        ['SWING_MISSED'] = true,
        ['RANGE_DAMAGE'] = true,
        ['RANGE_MISSED'] = true,
        ['SPELL_DAMAGE'] = true,
        ['SPELL_PERIODIC_DAMAGE'] = true,
        ['SPELL_MISSED'] = true
}

local playerGUID = false

NetherMachine.StrengthProcs = 0
NetherMachine.AgilityProcs = 0
NetherMachine.IntellectProcs = 0
NetherMachine.SpiritProcs = 0
NetherMachine.StaminaProcs = 0
NetherMachine.AttackPowerProcs = 0
NetherMachine.SpellPowerProcs = 0
NetherMachine.VersatilityProcs = 0
NetherMachine.HasteProcs = 0
NetherMachine.CriticalStrikeProcs = 0
NetherMachine.MultistrikeProcs = 0
NetherMachine.MasteryProcs = 0

local StrengthProcsList = { }
local AgilityProcsList = { }
local IntellectProcsList = { [177594] = true, [126683] = true, [126705] = true }
local SpiritProcsList = { }
local StaminaProcsList = { }
local AttackPowerProcsList = { }
local SpellPowerProcsList = { }
local VersatilityProcsList = { }
local HasteProcsList = { [177051] = true, [176875] = true, [90355] = true, [2825] = true, [80353] = true, [32182] = true }
local CriticalStrikeProcsList = { [162915] = true, [162919] = true, [177046] = true }
local MultistrikeProcsList = { }
local MasteryProcsList = { [176941] = true }

lastTarget = {}
local spellToTrack = 20271

NetherMachine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)

	if not playerGUID then
		local guid = UnitGUID("player")
		if guid then playerGUID = guid end
	end

	local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = ...

	if sourceGUID == playerGUID then
		NetherMachine.module.tracker.handleEvent(...)
	end

  if event == "SPELL_AURA_APPLIED" and sourceGUID == UnitGUID("player") then
    if StrengthProcsList[spellID] ~= nil then NetherMachine.StrengthProcs = NetherMachine.StrengthProcs + 1 end
    if AgilityProcsList[spellID] ~= nil then NetherMachine.AgilityProcs = NetherMachine.AgilityProcs + 1 end
    if IntellectProcsList[spellID] ~= nil then NetherMachine.IntellectProcs = NetherMachine.IntellectProcs + 1 end
    if SpiritProcsList[spellID] ~= nil then NetherMachine.SpiritProcs = NetherMachine.SpiritProcs + 1 end
    if StaminaProcsList[spellID] ~= nil then NetherMachine.StaminaProcs = NetherMachine.StaminaProcs + 1 end
    if AttackPowerProcsList[spellID] ~= nil then NetherMachine.AttackPowerProcs = NetherMachine.AttackPowerProcs + 1 end
    if SpellPowerProcsList[spellID] ~= nil then NetherMachine.SpellPowerProcs = NetherMachine.SpellPowerProcs + 1 end
    if VersatilityProcsList[spellID] ~= nil then NetherMachine.VersatilityProcs = NetherMachine.VersatilityProcs + 1 end
    if HasteProcsList[spellID] ~= nil then NetherMachine.HasteProcs = NetherMachine.HasteProcs + 1 end
    if CriticalStrikeProcsList[spellID] ~= nil then NetherMachine.CriticalStrikeProcs = NetherMachine.CriticalStrikeProcs + 1 end
    if MultistrikeProcsList[spellID] ~= nil then NetherMachine.MultistrikeProcs = NetherMachine.MultistrikeProcs + 1 end
    if MasteryProcsList[spellID] ~= nil then NetherMachine.MasteryProcs = NetherMachine.MasteryProcs + 1 end
  end

  if event == "SPELL_AURA_REMOVED" and sourceGUID == UnitGUID("player") then
    if StrengthProcsList[spellID] ~= nil then NetherMachine.StrengthProcs = NetherMachine.StrengthProcs - 1 end
    if AgilityProcsList[spellID] ~= nil then NetherMachine.AgilityProcs = NetherMachine.AgilityProcs - 1 end
    if IntellectProcsList[spellID] ~= nil then NetherMachine.IntellectProcs = NetherMachine.IntellectProcs - 1 end
    if SpiritProcsList[spellID] ~= nil then NetherMachine.SpiritProcs = NetherMachine.SpiritProcs - 1 end
    if StaminaProcsList[spellID] ~= nil then NetherMachine.StaminaProcs = NetherMachine.StaminaProcs - 1 end
    if AttackPowerProcsList[spellID] ~= nil then NetherMachine.AttackPowerProcs = NetherMachine.AttackPowerProcs - 1 end
    if SpellPowerProcsList[spellID] ~= nil then NetherMachine.SpellPowerProcs = NetherMachine.SpellPowerProcs - 1 end
    if VersatilityProcsList[spellID] ~= nil then NetherMachine.VersatilityProcs = NetherMachine.VersatilityProcs - 1 end
    if HasteProcsList[spellID] ~= nil then NetherMachine.HasteProcs = NetherMachine.HasteProcs - 1 end
    if CriticalStrikeProcsList[spellID] ~= nil then NetherMachine.CriticalStrikeProcs = NetherMachine.CriticalStrikeProcs - 1 end
    if MultistrikeProcsList[spellID] ~= nil then NetherMachine.MultistrikeProcs = NetherMachine.MultistrikeProcs - 1 end
    if MasteryProcsList[spellID] ~= nil then NetherMachine.MasteryProcs = NetherMachine.MasteryProcs - 1 end
  end

  -- Double Jeapardy
  if event == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
    if spellID == spellToTrack then
      if not lastTarget[spellID] then
        table.insert(lastTarget, { spellID = UnitGUID(destGUID) })
      end
      if lastTarget[spellID] ~= destGUID then lastTarget[spellID] = destGUID end
    end
  end

end)

NetherMachine.listener.register("UPDATE_MOUSEOVER_UNIT", function(...)

end)


-- Double Jeapardy
lastTarget = {}
local spellToTrack = 20271

NetherMachine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
	local event	= select(2, ...)
	local source	= select(4, ...)
	local target	= select(8, ...)
	local spell	= select(12, ...)

	if event == "SPELL_CAST_SUCCESS" and source == UnitGUID("player") then
		if spell == spellToTrack then
			if not lastTarget[spell] then
				table.insert(lastTarget, {spell = UnitGUID(target)})
			end
			if lastTarget[spell] ~= target then lastTarget[spell] = target end
		end
	end
return end)
