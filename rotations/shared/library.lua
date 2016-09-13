bbLib = {}
--TODO: Alpha, Beta, and Raid Ready Alert

--IsBoss: (function() return IsEncounterInProgress() and SpecialUnit() end)
--LifeSpirit: (function() return GetItemCount(89640, false, false) > 0 and GetItemCooldown(89640) == 0 end)
--HealPot: (function() return GetItemCount(76097, false, false) > 0 and GetItemCooldown(76097) == 0 end)
--AgiPot: (function() return GetItemCount(76089, false, false) > 0 and GetItemCooldown(76089) == 0 end)
--HealthStone: (function() return GetItemCount(5512, false, true) > 0 and GetItemCooldown(5512) == 0 end)
--Stats (function() return select(1,GetRaidBuffTrayAuraInfo(1)) != nil end)
--Stamina (function() return select(1,GetRaidBuffTrayAuraInfo(2)) != nil end)
--AttackPower (function() return select(1,GetRaidBuffTrayAuraInfo(3)) != nil end)
--AttackSpeed (function() return select(1,GetRaidBuffTrayAuraInfo(4)) != nil end)
--SpellPower (function() return select(1,GetRaidBuffTrayAuraInfo(5)) != nil end)
--SpellHaste (function() return select(1,GetRaidBuffTrayAuraInfo(6)) != nil end)
--CritialStrike (function() return select(1,GetRaidBuffTrayAuraInfo(7)) != nil end)
--Mastery (function() return select(1,GetRaidBuffTrayAuraInfo(8)) != nil end)

--UnitsAroundUnit(unit, distance[, combat])
--Distance(unit, unit)
--FaceUnit(unit)
--IterateObjects(callback, filter)

--timeout(name, duration) -- Used to add a rate limit or stop double casting.

-- GetFollowDistance(), SetFollowDistance(Distance), GetFollowTarget(), SetFollowTarget(Target).
--SetFollowDistance(5)
-- WorldToScreen and GetCameraPosition
-- UnitCanInteract(Unit, Other). Other can be a unit or game object.


function bbLib.prePot()
	-- DBM Options -> Global and Spam Filters -> un-check "Do not show Pull/Break Timer bar"
	-- /script if DBM.Bars.numBars and DBM.Bars.numBars > 0 then for bar in pairs(DBM.Bars.bars) do if bar.id == "Pull in" and bar.timer < 3 then print("Found pull bar! ID: "..bar.id.."  Time Left: "..bar.timer.."  Total Time: "..bar.totalTime) end end end
	if DBM.Bars.numBars and DBM.Bars.numBars > 0 then
		for bar in pairs(DBM.Bars.bars) do
			if bar.id == "Pull in" and bar.timer < 3 then
				-- print("Found pull bar! ID: "..bar.id.."  Time Left: "..bar.timer.."  Total Time: "..bar.totalTime)
				return true
				-- TODO: force usage of pot because pe is dumb. based on class
			end
		end
	end
	return false
end



function bbLib.NeedHealsAroundUnit(spell, unit, count, distance, threshold)
	if not FireHack then return false end
	if not unit or ( unit and unit == 'lowest' ) then
		unit = NetherMachine.raid.lowestHP(spell)
	end
	if UnitExists(unit) then
		if not count then count = 2 end
		if not distance then distance = 15 end
		if not threshold then threshold = 80 end
		local total = 0
		local totalObjects = ObjectCount() or 0
		for i = 1, totalObjects do
			local object = ObjectWithIndex(i)
			if ObjectExists(object) and ObjectIsType(object, ObjectTypes.Player)
				and UnitCanAssist("player", object)
				and ((UnitHealth(object) / UnitHealthMax(object)) * 100) <= threshold
				and Distance(object, unit) <= distance then
					total = total + 1
			end
			if total >= count then return true end
		end
	end
	return false
end


function bbLib.GCDOver(spell)
	local spellID
	if spell == nil then
		spellID = 61304
	else
		spellID = GetSpellID(spell)
	end
	local _, _, lagHome, lagWorld = GetNetStats()
	local lagSeconds = (lagHome + lagWorld) / 1000 + .025
	if lagSeconds < 0.05 then
		lagSeconds = 0.05
	elseif lagSeconds > 0.3 then
		lagSeconds = 0.3
	end
	if GetSpellCooldown(spellID) - lagSeconds <= 0 then
		return true
	end
	return false
end


function bbLib.rateLimit(miliseconds)
    return ((GetTime()*1000) % miliseconds) == 0
end


function bbLib.engaugeUnit(unitName, searchRange, isMelee)
	if not FireHack then return false end
	if UnitIsDeadOrGhost("player")
	or ( UnitExists("target") and UnitIsFriend("player", "target") )
	or ((UnitHealth("player") / UnitHealthMax("player")) * 100) < 70
	or GetUnitSpeed("player") > 0 then
		return false
	end

	if UnitClass("player") == "Hunter" and UnitBuff("player", "Sniper Training") ~= nil then
		searchRange = searchRange + 5
	end

	if UnitExists("target") then
		if UnitIsDeadOrGhost("target")
		or ( UnitIsTapped("target") and not UnitIsTappedByPlayer("target")
		and UnitThreatSituation("player", "target")
		and UnitThreatSituation("player", "target") < 2 ) then
			ClearTarget()
		end
	end

	-- ObjectTypes={Object=0x1,Item=0x2,Container=0x4,Unit=0x8,Player=0x10,GameObject=0x20,DynamicObject=0x40,Corpse=0x80,AreaTrigger=0x100,SceneObject=0x200,All=0xFFFFFFFF,}
	-- Find closest unit.
	if not UnitExists("target") then
		local totalObjects = ObjectCount() or 0
		local closestUnitObject = nil
		local closestUnitDistance = 9999
		local objectCount = 0
		for i = 1, totalObjects do
			local object = ObjectWithIndex(i)
			if ObjectExists(object) and ObjectIsType(object, 0x8) then
				local canAttack = UnitCanAttack("player", object)
				local isDeadOrGhost = UnitIsDeadOrGhost(object)
				local objectName = ObjectName(object)
				local isVisible = UnitIsVisible(object)
				local isTapped = UnitIsTapped(object)
				local isTappedByPlayer = UnitIsTappedByPlayer(object)
				local reaction = UnitReaction(object, "player")
				if canAttack and isVisible and not isDeadOrGhost and reaction and reaction < 4 and (unitName == "ANY" or string.find(objectName, unitName) ~= nil) then
					if not isTapped or isTappedByPlayer or ( UnitThreatSituation("player", object) and UnitThreatSituation("player", object) > 1 ) then
						local objectDistance = Distance("player", object)
						if objectDistance <= searchRange and objectDistance < closestUnitDistance and LineOfSight("player", object) then
							closestUnitObject = object
							closestUnitDistance = objectDistance
							objectCount = objectCount + 1
						end
					end
				end
			end
		end
		if objectCount == 0 or closestUnitObject == nil then return false end
		TargetUnit(closestUnitObject)
		FaceUnit(closestUnitObject)
		if not UnitAffectingCombat("player") then AttackTarget() end
		if isMelee and closestUnitDistance >= 5 then
			MoveTo(ObjectPosition(closestUnitObject))
		end
	end
	return false
end



function bbLib.stopFalling()
	if not FireHack then return false end
	local movementFlags = UnitMovementFlags("player")
	-- MovementFlags={Forward=0x1,Backward=0x2,StrafeLeft=0x4,StrafeRight=0x8,TurnLeft=0x10,TurnRight=0x20,PitchUp=0x40,PitchDown=0x80,Walking=0x100,Levitating=0x200,Immobilized=0x400,Falling=0x800,FallingFar=0x1000,PendingStop=0x2000,PendingStrafeStop=0x4000,PendingForward=0x8000,PendingBackward=0x10000,PendingStrafeLeft=0x20000,PendingStrafeRight=0x40000,PendingImmobilize=0x80000,Swimming=0x100000,Ascending=0x200000,Descending=0x400000,CanFly=0x800000,Flying=0x1000000,SplineElevation=0x2000000,SplineEnabled=0x4000000,WaterWalking=0x8000000,SlowFall=0x10000000,Hover=0x20000000,}
	-- /script print(bit.band(UnitMovementFlags("player"), 0x1) > 0)
	if bit.band(movementFlags, 0x1000) > 0 then
		StopFalling()
	end
	return false
end



function bbLib.bossMods()
	-- Darkmoon Faerie Cannon
	-- if select(7, UnitBuffID("player", 102116))
	--   and select(7, UnitBuffID("player", 102116)) - GetTime() < 1.07 then
	-- 	CancelUnitBuff("player", "Magic Wings")
	-- end

	-- -- Raid Boss Checks
	-- if UnitExists("boss1") then
	-- 	for i = 1,4 do
	-- 		local bossCheck = "boss"..i
	-- 		if UnitExists(bossCheck) then
	-- 			local npcID = tonumber(UnitGUID(bossCheck):sub(6, 10), 16)
	-- 			--local bossCasting,_,_,_,_,castEnd = UnitCastingInfo(bossCheck)
	-- 			--local paragons = {71161, 71157, 71156, 71155, 71160, 71154, 71152, 71158, 71153}
	-- 			if npcID == 71515 then  -- SoO: Paragons of the Klaxxi
	-- 				--if UnitBuffID("target", 71) then
	-- 					--SpellStopCasting()
	-- 					--return true
	-- 				--end
	-- 			end
	-- 		end
	-- 	end
	-- end
	-- StrafeRightStart() StrafeRightStop()
	return false
end



function bbLib.pauses()
	if UnitExists("target") and (UnitIsEnemy("player", "target")) then
		-- WoD Dungeons
		if UnitAura("target", "Reckless Provocation") -- Iron Docks - Fleshrender
			or UnitAura("target", "Sanguine Sphere") -- Iron Docks - Enforcers
		-- WoD Raids
			-- Highmaul: Twin Ogron - Interrupting Shout
			or (UnitCastingInfo("player") and UnitCastingInfo("target") and select(1,UnitCastingInfo("target")) == "Interrupting Shout")
		then
			SpellStopCasting()
			--StopAttack()
			return true
		end
	end

	-- General
	if UnitAura("player", "Food") -- Eating
	or GetNumLootItems() > 0 -- Looting
	then
		return true
	end

	return false
end



function bbLib.stackCheck(spell, otherTank, stacks)
	local spellName, _ = GetSpellInfo(spell)
	if spellName then
		local name, _, _, count, _, duration, expires, caster, _, _, spellID, _ = UnitAura(otherTank, spellName)
		if name and count >= stacks and not UnitAura("player", spellName) then
			return true
		end
	end
	return false
end



function bbLib.bossTaunt()
	-- TODO: May be double taunting if we dont get a stack before taunt comes back up.
	-- Thanks to Rubim for the idea!
	-- Make sure we're a tank first and we're in a raid
	if IsInRaid() and UnitGroupRolesAssigned("player") == "TANK" then
		local otherTank
		if UnitExists("focus") and UnitIsFriend("player", "focus") and not UnitIsDeadOrGhost("focus") then
			otherTank = "focus"
		else
			otherTank = nil
		end
		-- for i = 1, GetNumGroupMembers() do
			-- local other = "raid" .. i
			-- if not otherTank and not UnitIsUnit("player", other) and UnitGroupRolesAssigned(other) == "TANK" then
				-- otherTank = other
			-- end
		-- end

		if otherTank then
			for j = 1, 4 do
				local bossID = "boss" .. j
				local boss = UnitID(bossID)
				--local bossName, _ = UnitName(bossID)

				-- START Highmaul
				if     boss == 78714 then -- Kargath Bladefist
					if bbLib.stackCheck("Impale", otherTank, 0) then
						NetherMachine.dsl.parsedTarget = bossID
						return true
					end
				elseif boss == 77404 then -- The Butcher
					if bbLib.stackCheck("The Tenderizer", otherTank, 2) then
						NetherMachine.dsl.parsedTarget = bossID
						return true
					end
				elseif boss == 78491 then -- Brackenspore
					if bbLib.stackCheck("Rot", otherTank, 4) then
						NetherMachine.dsl.parsedTarget = bossID
						return true
					end
				elseif boss == 79015 then -- Ko'ragh
					if bbLib.stackCheck("Expel Magic: Arcane", otherTank, 0) then
						NetherMachine.dsl.parsedTarget = bossID
						return true
					end
				elseif boss == 77428 then -- Imperator Mar'gok
					local name, _, _, count = UnitAura(bossID, "Accelerated Assault")
					if bbLib.stackCheck("Mark of Chaos", otherTank, 0)
					 or (name and count >= 3) then
						NetherMachine.dsl.parsedTarget = bossID
						return true
					end
				end
				-- END Highmaul

				-- START Siege of Orgrimmar
				-- if     boss == 71543 then -- Immersus
				-- 	if bbLib.stackCheck("Corrosive Blast", otherTank, 1) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 72276 then -- Norushen
				-- 	if bbLib.stackCheck("Self Doubt", otherTank, 3) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71734 then -- Sha of Pride
				-- 	if bbLib.stackCheck("Wounded Pride", otherTank, 1) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 72249 then -- Galakras
				-- 	if bbLib.stackCheck("Flames of Galakrond", otherTank, 3) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71466 then -- Iron Juggernaut
				-- 	if bbLib.stackCheck("Ignite Armor", otherTank, 2) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71859 then -- Kor'kron Dark Shaman -- Earthbreaker Haromm
				-- 	if bbLib.stackCheck("Froststorm Strike", otherTank, 5) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71515 then -- General Nazgrim
				-- 	if bbLib.stackCheck("Sundering Blow", otherTank, 3) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71454 then -- Malkorok
				-- 	if bbLib.stackCheck("Fatal Strike", otherTank, 12) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71529 then -- Thok the Bloodsthirsty
				-- 	if bbLib.stackCheck("Panic", otherTank, 3)
				-- 	  or bbLib.stackCheck("Acid Breath", otherTank, 3)
				-- 	  or bbLib.stackCheck("Freezing Breath", otherTank, 3)
				-- 	  or bbLib.stackCheck("Scorching Breath", otherTank, 3) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71504 then -- Siegecrafter Blackfuse
				-- 	if bbLib.stackCheck("Electrostatic Charge", otherTank, 4) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 71865 then -- Garrosh Hellscream
				-- 	if bbLib.stackCheck("Gripping Despair", otherTank, 3)
				-- 	  or bbLib.stackCheck("Empowered Gripping Despair", otherTank, 3) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- end
				-- END Siege of Orgrimmar

				-- START Throne of Thunder
				-- if boss == 69465 then -- Jin’rokh the Breaker
				-- 	local debuffName, _, _, debuffCount = UnitDebuff(otherTank, "Static Wound")
				-- 	local debuffName2, _, _, debuffCount2 = UnitDebuff("player", "Static Wound")
				-- 	if debuffName
				-- 	  and ( not debuffName2 or debuffCount > debuffCount2) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 68476 then -- Horridon
				-- 	if bbLib.stackCheck("Triple Puncture", otherTank, 9) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 69131 then -- Council of Elders - Frost King Malakk
				-- 	if bbLib.stackCheck("Frigid Assault", otherTank, 13) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 69712 then -- Ji-Kun
				-- 	if bbLib.stackCheck("Talon Rake", otherTank, 2) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 68036 then -- Durumu the Forgotten
				-- 	if bbLib.stackCheck("Hard Stare", otherTank, 5) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 69017 then -- Primordius
				-- 	if bbLib.stackCheck("Malformed Blood", otherTank, 8) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 69699 then -- Dark Animus - Massive Anima Golem -- TODO: May not show up in boss frames.
				-- 	if bbLib.stackCheck("Explosive Slam", otherTank, 5) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 68078 then -- Iron Qon -- TODO: check if boss id stays same during encounter
				-- 	if bbLib.stackCheck("Impale", otherTank, 4) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 68905 then -- Twin Consorts - Lu’lin
				-- 	if bbLib.stackCheck("Beast of Nightmare", otherTank, 1) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 68904 then -- Twin Consorts - Suen
				-- 	if bbLib.stackCheck("Fan of Flames", otherTank, 3) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- elseif boss == 68397 then -- Lei Shen
				-- 	if bbLib.stackCheck("Decapitate", otherTank, 1)
				-- 	  or bbLib.stackCheck("Fusion Slash", otherTank, 1)
				-- 	  or bbLib.stackCheck("Overwhelming Power", otherTank, 12) then
				-- 		NetherMachine.dsl.parsedTarget = bossID
				-- 		return true
				-- 	end
				-- end
				-- END Throne of Thunder
			end
		end
	end
	return false
end



-- Thanks to PCMD
bbLib.darkSimSpells = { "Froststorm Bolt", "Arcane Shock", "Rage of the Empress", "Chain Lightning", "Hex", "Mind Control", "Cyclone", "Polymorph", "Pyroblast", "Tranquility", "Divine Hymn", "Hymn of Hope", "Ring of Frost", "Entangling Roots" }
function bbLib.canDarkSimulacrum(unit)
	for _,v in pairs(bbLib.darkSimSpells) do
 		if NetherMachine.condition["casting"](unit, v) then
			return true
		end
	end
	return false
end



-- function bbLib.BGFlag()
	-- if GetBattlefieldStatus(1)=='active'
	  -- or GetBattlefieldStatus(2)=='active' then
		-- InteractUnit('Horde flag')
		-- InteractUnit('Alliance flag')
	-- end
	-- return false
-- end



function bbLib.isTank(unit)
	if unit and UnitExists(unit) then
		if GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned(unit) == "TANK" then
			return true
		end
	end
	return false
end

function bbLib.isNotTank(unit)
	if unit and UnitExists(unit) then
		if GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned(unit) == "TANK" then
			return false
		end
	end
	return true
end



-- --function bbLib.worthDotting()
-- --	if UnitHealth("target") > UnitHealth("player") or GetNumGroupMembers() < 2 then
-- --		return true
-- --	end
-- --	return false
-- --end

-- function bbLib.worthDotting()
-- UnitHealth("target")
-- UnitHealth("player")
-- if GetItemCount(76097) > 1
-- and GetItemCooldown(76097) == 0 then
-- return true
-- end
-- return false
-- end



-- START HUNTER
function bbLib.canDireBeast()
  local _, activeRegen = GetPowerRegen()
  local DBname, _, _, DBcastTime = GetSpellInfo("Dire Beast")
	local ASname, _, _, AScastTime = GetSpellInfo("Aimed Shot")
  if DBname and ASname and activeRegen then
    local db_cast_regen = DBcastTime/1000 * activeRegen
		local as_cast_regen = AScastTime/1000 * activeRegen
    local focus_deficit = UnitPowerMax("player", 2) - UnitPower("player", 2)
		return (db_cast_regen + as_cast_regen) < focus_deficit
  end
  return false
end
function bbLib.poolSteady()
	local _, activeRegen = GetPowerRegen()
	local name, _, _, castTime = GetSpellInfo("Steady Shot")
	local start, duration, enabled = GetSpellCooldown("Rapid Fire")
	if name and activeRegen and start then
		local rapid_cooldown = 0
		if start ~= 0 then rapid_cooldown = start + duration - GetTime() end
		if castTime == 0 then castTime = 1500 end
		local cast_regen = castTime/1000 * activeRegen
		local focus_deficit = UnitPowerMax("player", 2) - UnitPower("player", 2)
		if focus_deficit == 0 then focus_deficit = 1 end
		return (focus_deficit * (castTime/1000) % (14 + cast_regen)) > rapid_cooldown
	end
	return false
end
function bbLib.poolFocusing()
	local _, activeRegen = GetPowerRegen()
	local name, _, _, castTime = GetSpellInfo("Focusing Shot")
	local start, duration, enabled = GetSpellCooldown("Rapid Fire")
	if name and activeRegen and start then
		local rapid_cooldown = 0
		if start ~= 0 then rapid_cooldown = start + duration - GetTime() end
		if castTime == 0 then castTime = 1500 end
		local cast_regen = castTime/1000 * activeRegen
		local focus_deficit = UnitPowerMax("player", 2) - UnitPower("player", 2)
		if focus_deficit == 0 then focus_deficit = 1 end
		return (focus_deficit * (castTime/1000) % (50 + cast_regen)) > rapid_cooldown
	end
	return false
end
function bbLib.steadyFocus()
	local _, activeRegen = GetPowerRegen()
	local SSname, _, _, SScastTime = GetSpellInfo("Steady Shot")
	local ASname, _, _, AScastTime = GetSpellInfo("Aimed Shot")
	if SSname and ASname and activeRegen then
		local ss_cast_regen = SScastTime/1000 * activeRegen
		local as_cast_regen = AScastTime/1000 * activeRegen
		local focus_deficit = UnitPowerMax("player", 2) - UnitPower("player", 2)
		return (14 + ss_cast_regen + as_cast_regen) <= focus_deficit
	end
	return false
end
function bbLib.aimedShot()
	local _, activeRegen = GetPowerRegen()
	local name, _, _, castTime = GetSpellInfo("Aimed Shot")
	if name and activeRegen then
		local cast_regen = castTime/1000 * activeRegen
		local focus = UnitPower("player", 2)
		local minFocus = 85
		if UnitBuff("player", "Thrill of the Hunt") then minFocus = 65 end
		return (focus + cast_regen) >= minFocus
	end
	return false
end
function bbLib.focusingShot()
	local _, activeRegen = GetPowerRegen()
	local name, _, _, castTime = GetSpellInfo("Focusing Shot")
	if name and activeRegen then
		local cast_regen = castTime/1000 * activeRegen
		local focus_deficit = UnitPowerMax("player", 2) - UnitPower("player", 2)
		return (50 + cast_regen - 10) < focus_deficit
	end
	return false
end
-- bbLib.badMisdirectTargets = { "Kor'kron Warshaman" }
-- function bbLib.canMisdirect()
-- local targetName = UnitName("target")
-- for _,v in pairs(bbLib.badMisdirectTargets) do
-- if v == targetName then
-- return false
-- end
-- end
-- return true
-- end
-- END HUNTER


-- START SHADOW PRIEST
function bbLib.PriestCoPAdvancedMFIDots()
	--(shadow_orb>=4|target.dot.shadow_word_pain.ticking|target.dot.vampiric_touch.ticking|target.dot.devouring_plague.ticking)
	if UnitPower(target, SPELL_POWER_SHADOW_ORBS) >= 4
		or UnitAura("target", "Shadow Word: Pain", nil, "HARMFUL|PLAYER")
		or UnitAura("target", "Vampiric Touch", nil, "HARMFUL|PLAYER")
		or UnitAura("target", "Devouring Plague", nil, "HARMFUL|PLAYER") then
			return true
	end
	return false
end
function bbLib.PriestCoPAdvancedMFIDotsMindSpike()
	--((target.dot.shadow_word_pain.ticking&target.dot.shadow_word_pain.remains<gcd)|(target.dot.vampiric_touch.ticking&target.dot.vampiric_touch.remains<gcd))&!target.dot.devouring_plague.ticking
	if UnitAura("target", "Devouring Plague", nil, "HARMFUL|PLAYER") == nil then
		local SWPname, _, _, _, _, _, SWPexpires = UnitAura("target", "Shadow Word: Pain", nil, "HARMFUL|PLAYER")
		local VTname, _, _, _, _, _, VTexpires = UnitAura("target", "Vampiric Touch", nil, "HARMFUL|PLAYER")
		local MSname, _, _, MScastTime = GetSpellInfo("Mind Spike")
		if ( SWPname and SWPexpires - GetTime() < MScastTime )
		or ( VTname and VTexpires - GetTime() < MScastTime ) then
			return true
		end
	end
	return false
end
function bbLib.PriestCoPAdvancedMFIDotsMindSpikeX2()
	--((target.dot.shadow_word_pain.ticking&target.dot.shadow_word_pain.remains<gcd)|(target.dot.vampiric_touch.ticking&target.dot.vampiric_touch.remains<gcd))&!target.dot.devouring_plague.ticking
	if UnitAura("target", "Devouring Plague", nil, "HARMFUL|PLAYER") == nil then
		local SWPname, _, _, _, _, _, SWPexpires = UnitAura("target", "Shadow Word: Pain", nil, "HARMFUL|PLAYER")
		local VTname, _, _, _, _, _, VTexpires = UnitAura("target", "Vampiric Touch", nil, "HARMFUL|PLAYER")
		local MSname, _, _, MScastTime = GetSpellInfo("Mind Spike")
		if ( SWPname and SWPexpires - GetTime() < MScastTime )
		or ( VTname and VTexpires - GetTime() < 2 * MScastTime ) then
			return true
		end
	end
	return false
end
function bbLib.PriestCoPAdvancedMFIDotsInsanity()
	--buff.shadow_word_insanity.remains<0.5*gcd
	if UnitAura("target", "Devouring Plague", nil, "HARMFUL|PLAYER") == nil then
		local SWPname, _, _, _, _, _, SWPexpires = UnitAura("target", "Shadow Word: Pain", nil, "HARMFUL|PLAYER")
		local VTname, _, _, _, _, _, VTexpires = UnitAura("target", "Vampiric Touch", nil, "HARMFUL|PLAYER")
		local MSname, _, _, MScastTime = GetSpellInfo("Mind Spike")
		if ( SWPname and SWPexpires - GetTime() < MScastTime )
		or ( VTname and VTexpires - GetTime() < MScastTime ) then
			return true
		end
	end
	return false
end
-- END SHADOW PRIEST



-- START BALANCE DRUID
--[[
NetherMachine.condition.register("balance.eclipsechange", function(target, spell)
  -- Eclipse power goes from -100 to 100, and its use as solar or lunar power is determined by what buff is active on the player.
  -- Buffs activate at -100 and 11 respectively and remain on the player until the power crosses the 0 threshold.
  -- moon == moving toward Lunar Eclipse
  -- sun == moving toward Solar Eclipse
  -- /script print("Eclipse direction: "..GetEclipseDirection().."  Eclipse: "..UnitPower("player", 8))
    if not spell then return false end
    local direction = GetEclipseDirection()
    if not direction or direction == "none" then return false end
    local name, _, _, casttime = GetSpellInfo(spell)
    if name and casttime then casttime = casttime / 1000 else return false end
    local eclipse = UnitPower("player", 8)
    local timetozero = 0
    local eclipsepersecond = 5

    -- Euphoria Check
    local group = GetActiveSpecGroup()
    local _, _, _, selected, active = GetTalentInfo(7, 1, group)
    if selected and active then
      eclipsepersecond = 10
    end

    if direction == "moon" and eclipse > 0 then
      timetozero = eclipse / eclipsepersecond
    elseif direction == "moon" and eclipse <= 0 then
      timetozero = ( 100 + ( 100 - math.abs(eclipse) ) ) / eclipsepersecond
    elseif direction == "sun" and eclipse >= 0 then
      timetozero = ( 100 + ( 100 - eclipse ) ) / eclipsepersecond
    elseif direction == "sun" and eclipse < 0 then
      timetozero = math.abs(eclipse) / eclipsepersecond
    end

    if timetozero > casttime then return true end
    return false
end)
]]--
-- END BALANCE DRUID



-- START PROT PALADIN
function bbLib.uthersLessJudge()
	local name, _, _, count, _, duration, expirationTime, unitCaster, isStealable = UnitAura("player", "Uther's Insight")
	local start, duration, enabled = GetSpellCooldown("Judgement")

	if name and expirationTime and start then
		local utherRemains = expirationTime - GetTime()
		local judgeCD = start + duration - GetTime()
		--buff.uthers_insight.remains<cooldown.judgment.remains
		if utherRemains < judgeCD then
			return true
		end
	end
	return false
end
function bbLib.uthersGreaterJudge()
	local name, _, _, count, _, duration, expirationTime, unitCaster, isStealable = UnitAura("player", "Uther's Insight")
	local start, duration, enabled = GetSpellCooldown("Judgement")

	if name and expirationTime and start then
		local utherRemains = expirationTime - GetTime()
		local judgeCD = start + duration - GetTime()
		--buff.uthers_insight.remains>cooldown.judgment.remains
		if utherRemains > judgeCD then
			return true
		end
	end
	return false
end
function bbLib.liadrinGreaterJudge()
	local name, _, _, count, _, duration, expirationTime, unitCaster, isStealable = UnitAura("player", "Liadrin's Righteousness")
	local start, duration, enabled = GetSpellCooldown("Judgement")

	if name and expirationTime and start then
		local remains = expirationTime - GetTime()
		local judgeCD = start + duration - GetTime()
		--buff.liadrins_righteousness.remains>cooldown.judgment.remains
		if remains > judgeCD then
			return true
		end
	end
	return false
end
-- END PROT PALADIN


-- local LibDraw = LibStub("LibDraw-1.0")
-- LibDraw.SetColor(255, 0, 0, 255) -- Sets the RGB color in values of 0-255
-- LibDraw.SetWidth(3) -- Sets the width of the line in pixels
-- LibDraw.helper = true
-- local s = 0.5
-- local cubeShape = {
-- 	-- This looks confusing but its really not too bad
-- 	-- This image helps it make sense: http://i.imgur.com/yBbUQSA.png
-- 	-- It's just 2 sets of points per row, drawing a line between them
-- 	{-s,  s,  s, -s, -s,  s}, -- v1 to v2
-- 	{ s,  s,  s,  s, -s,  s}, -- v4 to v3
-- 	{-s,  s, -s, -s, -s, -s}, -- v5 to v8
-- 	{ s,  s, -s,  s, -s, -s}, -- v6 to v7
-- 	{-s,  s,  s,  s,  s,  s}, -- v1 to v4
-- 	{-s, -s,  s,  s, -s,  s}, -- v2 to v3
-- 	{-s,  s, -s,  s,  s, -s}, -- v5 to v6
-- 	{-s, -s, -s,  s, -s, -s}, -- v8 to v7
-- 	{-s,  s,  s, -s,  s, -s}, -- v1 to v5
-- 	{ s,  s,  s,  s,  s, -s}, -- v4 to v6
-- 	{-s, -s,  s, -s ,-s, -s}, -- v2 to v8
-- 	{ s, -s,  s,  s, -s, -s}, -- v3 to v7
-- }
-- local texture = {
-- 	texture = "Interface\\PvPRankBadges\\PvPRankAlliance",
-- 	width = 32, height = 32
-- }
-- -- /script showRange()
-- function showRange()
-- 	if not showRangeEnabled then
-- 		LibDraw.Sync(function()
-- 			showRangeEnabled = true
-- 			if FireHack and UnitExists("target") then
-- 				local playerX, playerY, playerZ = ObjectPosition("player")
-- 				local targetX, targetY, targetZ = ObjectPosition("target")
-- 				local distance = Distance("player", "target")
-- 				local rotation = ObjectFacing("player")
--
-- 				if distance > 40 then
-- 					LibDraw.SetColor(255, 0, 0, 255)
-- 					LibDraw.Line(playerX, playerY, playerZ+2, targetX, targetY, targetZ + 2)
-- 					LibDraw.Text(distance, "GameFontNormal", targetX, targetY, targetZ + 4)
-- 				else
-- 					LibDraw.SetColor(0, 0, 255, 255)
-- 					LibDraw.Line(playerX, playerY, playerZ+2, targetX, targetY, targetZ + 2)
-- 					LibDraw.SetColor(0, 255, 0, 255)
-- 					LibDraw.Text(distance, "GameFontNormal", targetX, targetY, targetZ + 4)
-- 				end
-- 			end
-- 		end)
-- 	end
-- end


-- function bossDraw()
-- 	if not FireHack then return false end
-- 	if IsInRaid() then
-- 		local playerRole = UnitGroupRolesAssigned("player") -- TANK  HEALER  DAMAGER  NONE
-- 		for j = 1, 4 do
-- 			local bossID = "boss" .. j
-- 			local boss = UnitID(bossID)
--
-- 			-- START Highmaul
-- 			if     boss == 78714 then -- Kargath Bladefist
-- 				if playerRole == "TANK" then
-- 					--Perform a tank switch for every Impale Icon Impale cast. Make sure to have an active defensive cooldown for each Impale you go through
-- 					--If in the stands, make sure to pick up any adds present there, and face the Drunken Bileslingers away from other raid members.
-- 					--Tank Kargath away from Fire Pillar and Ravenous Bloodmaws.
-- 				elseif playerRole == "HEALER" then
-- 					--Beware of intense tank damage whenever Impale Icon Impale is being cast, and be prepared to use a defensive cooldown on the tank.
-- 				elseif playerRole == "DAMAGER" or playerRole == "NONE" then
-- 					--ranged DPS players should switch to and kill any Ravenous Bloodmaws that leave their pits.
-- 				end
-- 				-- if player within 5 yds of another display red circle
-- 				--Keep an eye on where the active Fire Pillars are, and if you are chased by Kargath during Berserker Rush Icon Berserker Rush, kite him into one of them to stop the chase. Tanks do not need to worry about this.
-- 				--Move out of Kargath's path when he is casting Berserker Rush.
-- 				--If fixated on by a Ravenous Bloodmaw, kite it in range of a Fire Pillar.
-- 				--Avoid being hit by Flame Gout Icon Flame Gout (the areas about to be hit are indicated with a ground effect).
-- 			elseif boss == 77404 then -- The Butcher
-- 				if playerRole == "TANK" then
-- 					-- The two tanks should stand within 5 yards of each other (preferably on top of each other).
-- 					-- Perform a regular tank switch to deal with the debuffs applied by The Cleaver Icon The Cleaver and The Tenderizer Icon The Tenderizer.
-- 				elseif playerRole == "HEALER" then
-- 				elseif playerRole == "DAMAGER" or playerRole == "NONE" then
-- 				end
-- 				-- In Mythic mode, make sure not to stand in the void zones left behind by the Night-Twisted Cadavers.
-- 			elseif boss == 78491 then -- Brackenspore
-- 				if playerRole == "TANK" then
-- 					--Perform a tank switch to handle Rot Icon Rot and Necrotic Breath Icon Necrotic Breath.
-- 					-- Use a defensive cooldown to survive Necrotic Breath Icon Necrotic Breath, and make sure not to face Brackenspore towards any other players at this time.
-- 					-- Pick up and tank the Fungal Flesh-Eaters.
-- 					-- Move Brackenspore near any beneficial mushrooms that spawn, so that the raid can remain stacked up.
-- 				elseif playerRole == "HEALER" then
-- 				elseif playerRole == "DAMAGER" or playerRole == "NONE" then
-- 					-- The adds are a higher priority than Brackenspore, so always DPS them first.
-- 				end
-- 			elseif boss == 79015 then -- Ko'ragh
-- 				if playerRole == "TANK" then
-- 				elseif playerRole == "HEALER" then
-- 				elseif playerRole == "DAMAGER" or playerRole == "NONE" then
-- 				end
-- 			elseif boss == 77428 then -- Imperator Mar'gok
-- 				if playerRole == "TANK" then
-- 				elseif playerRole == "HEALER" then
-- 				elseif playerRole == "DAMAGER" or playerRole == "NONE" then
-- 				end
-- 				--local name, _, _, count = UnitAura(bossID, "Accelerated Assault")
-- 			end
-- 			-- END Highmaul
--
-- 			-- START Blackrock Foundry
-- 			-- END Blackrock Foundry
--
-- 		end
-- 	end
--
-- 	LibDraw.Sync(function()
-- 		if FireHack and UnitExists("target") then
-- 			local playerX, playerY, playerZ = ObjectPosition("player")
-- 			local targetX, targetY, targetZ = ObjectPosition("target")
-- 			local distance = Distance("player", "target")
-- 			local rotation = ObjectFacing("player")
--
-- 			-- LibDraw.Line(startX, startY, startZ, endX, endY, endZ)
-- 			-- LibDraw.Circle(centerX, centerY, centerZ, size)
-- 			-- LibDraw.Box(centerX, centerY, centerZ, width, height, rotationZ, offsetX, offsetY)
-- 			-- LibDraw.Arc(originX, originY, originZ, size, degrees, rotationZ)
-- 			-- LibDraw.Texture(texuteStruct, centerX, centerY, centerZ)
-- 			-- LibDraw.Text(text, fontObject, centerX, centerY, centerZ)
-- 			-- LibDraw.Array(shapeArray, originX, originY, originZ, rotationX, rotationY, rotationZ)
-- 			-- LibDraw.Draw2DLine(startX, startY, endX, endY) -- TOPLEFT is screen space origin with Y being a negative value
-- 			-- LibDraw.Distance(startX, startY, startZ, endX, endY, endZ)
-- 			-- LibDraw.Camera()
-- 			-- LibDraw.rotateX/Y/Z(originX, originY, originZ, pointX, pointY, pointZ, rotation)
--
-- 			--if distance <= 5 then
-- 			--	LibDraw.SetColor(255, 0, 0, 255)
-- 			--	LibDraw.Circle(playerX, playerY, playerZ+2, 5)
-- 			--else
-- 			--	LibDraw.SetColor(0, 255, 0, 255)
-- 			--	LibDraw.Circle(playerX, playerY, playerZ+2, 5)
-- 			--end
--
-- 			-- Draw a 5 yard by 5 yard box around the player.
-- 			--LibDraw.Box(playerX, playerY, playerZ, 5, 5)
--
-- 			-- Draw a 5 yard by 5 yard box around the player and match it to the players rotation.
-- 			--local rotation = ObjectFacing("player")
-- 			--LibDraw.Box(playerX, playerY, playerZ, 5, 5, rotation)
--
-- 			-- Draw a 5 yard by 15 yard box around the player and match it to the players rotation, offset to be infront of the player.
-- 			--LibDraw.Box(playerX, playerY, playerZ, 5, 15, rotation, 0, 7.5)
--
-- 			-- Draw a 10 yard, 70 degree arc / cone and rotate to match the players facing. e.g. Cone of Cold
-- 			--LibDraw.Arc(playerX, playerY, playerZ, 10, 70, rotation)
--
-- 			-- Draw a cube above the players head
-- 			--LibDraw.Array(cubeShape, playerX, playerY, playerZ)
--
-- 			-- Draw a texture above the targets head.  The texture is scaled based on this distance to the unit.
-- 			--LibDraw.Texture(texture, targetX, targetY, targetZ + 3)
-- 		end
-- 	end)
--
-- 	return false
-- end



-- REGISTER LIB
NetherMachine.library.register("bbLib", bbLib)



-- CUSTOM FRAMES
-- TODO: Auto accept rez AcceptResurrect()
if not myErrorFrame then
	local myErrorFrame = CreateFrame('Frame')
	myErrorFrame:RegisterEvent('UI_ERROR_MESSAGE')
	myErrorFrame:SetScript('OnEvent', function(self, event, message)
		if message then
			-- Face Target on Error
			if FireHack and string.find(message, "front of you") and UnitExists("target") and select(1,GetUnitSpeed("player")) == 0 then
				FaceUnit("target")
			end

			-- Shapeshift Errors
			--local ssmessages = { ERR_MOUNT_SHAPESHIFTED, ERR_NO_ITEMS_WHILE_SHAPESHIFTED, ERR_NOT_WHILE_SHAPESHIFTED, ERR_TAXIPLAYERSHAPESHIFTED, ERR_CANT_INTERACT_SHAPESHIFTED }
			if string.find(message, "shapeshifted") and GetShapeshiftForm() ~= 0 then
				--for amessage in ssmessages do
					--if message == amessage then
						CancelShapeshiftForm()
					--end
				--end
			end
		end
	end)
end
















NOC = {}

function NOC.immuneEvents(unit)
	if NOC.isException(unit) then return true end
	if not UnitAffectingCombat(unit) then return false end
	-- Crowd Control
	local cc = {
		49203, -- Hungering Cold
		6770, -- Sap
		1776, -- Gouge
		51514, -- Hex
		9484, -- Shackle Undead
		118, -- Polymorph
		28272, -- Polymorph (pig)
		28271, -- Polymorph (turtle)
		61305, -- Polymorph (black cat)
		61025, -- Polymorph (serpent) -- FIXME: gone ?
		61721, -- Polymorph (rabbit)
		61780, -- Polymorph (turkey)
		3355, -- Freezing Trap
		19386, -- Wyvern Sting
		20066, -- Repentance
		90337, -- Bad Manner (Monkey) -- FIXME: to check
		2637, -- Hibernate
		82676, -- Ring of Frost
		115078, -- Paralysis
		76780, -- Bind Elemental
		9484, -- Shackle Undead
		1513, -- Scare Beast
		115268, -- Mesmerize
		6358, -- Seduction
		339, -- Entangling Roots
	}
	if NOC.hasDebuffTable(unit, cc) then return false end
	if UnitAura(unit,GetSpellInfo(116994))
	or UnitAura(unit,GetSpellInfo(122540))
	or UnitAura(unit,GetSpellInfo(123250))
	or UnitAura(unit,GetSpellInfo(106062))
	or UnitAura(unit,GetSpellInfo(110945))
	or UnitAura(unit,GetSpellInfo(143593)) -- General Nazgrim: Defensive Stance
	or UnitAura(unit,GetSpellInfo(143574)) -- Heroic Immerseus: Swelling Corruption
	--or UnitAura(unit,GetSpellInfo(166591)) -- Sanguine Sphere?
	then return false end
	return true
end


-- Props to CML for this function
-- if getCreatureType(Unit) == true then
function NOC.getCreatureType(Unit)
	local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
	for i=1, #CreatureTypeList do
		if UnitCreatureType(Unit) == CreatureTypeList[i]
		then
			return false
		end
	end
	if UnitIsBattlePet(Unit) and UnitIsWildBattlePet(Unit)then
		return false
	else
		return true
	end
end

-- Various checks to ensure that we can SEF the mouseover unit
function NOC.canSEF()
	if (UnitGUID('target')) ~= (UnitGUID('mouseover'))
	and UnitCanAttack("player", "mouseover")
	and not UnitIsDeadOrGhost("mouseover")
	and getCreatureType("mouseover")
	then
		return true
	end
	return false
end

function NOC.StaggerValue ()
	local staggerLight, _, iconLight, _, _, remainingLight, _, _, _, _, _, _, _, _, valueStaggerLight, _, _ = UnitAura("player", GetSpellInfo(124275), "", "HARMFUL")
	local staggerModerate, _, iconModerate, _, _, remainingModerate, _, _, _, _, _, _, _, _, valueStaggerModerate, _, _ = UnitAura("player", GetSpellInfo(124274), "", "HARMFUL")
	local staggerHeavy, _, iconHeavy, _, _, remainingHeavy, _, _, _, _, _, _, _, _, valueStaggerHeavy, _, _ = UnitAura("player", GetSpellInfo(124273), "", "HARMFUL")
	local staggerTotal= (remainingLight or remainingModerate or remainingHeavy or 0) * (valueStaggerLight or valueStaggerModerate or valueStaggerHeavy or 0)
	local percentOfHealth=(100/UnitHealthMax("player")*staggerTotal)
	local ticksTotal=(valueStaggerLight or valueStaggerLight or valueStaggerLight or 0)
	return percentOfHealth;
end

function NOC.DrinkStagger()
	if (UnitPower("player", 12) >= 1 or UnitBuff("player", GetSpellInfo(138237))) then
		if UnitDebuff("player", GetSpellInfo(124273))
		then return true
		end
		if UnitDebuff("player", GetSpellInfo(124274))
		and NOC.StaggerValue() > 25
		then return true
		end
	end
	return false
end

-- Props to CML? for this code
function NOC.noControl()
	local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _, _, text = C_LossOfControl.GetEventInfo(eventIndex)
		-- Hunter
		if select(3, UnitClass("player")) == 3 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		-- Monk
		if select(3, UnitClass("player")) == 10 then
			if text == LOSS_OF_CONTROL_DISPLAY_STUN or text == LOSS_OF_CONTROL_DISPLAY_FEAR or text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_HORROR then
				return true
			end
		end
		eventIndex = eventIndex - 1
	end
	return false
end

-- return true when the rotation should be paused
function NOC.pause()
	--if (IsMounted() and not UnitBuffID("player",164222) and not UnitBuffID("player",165803))
	--if (IsMounted() and getUnitID("target") ~= 56877 and not UnitBuffID("player",164222) and not UnitBuffID("player",165803))
	if SpellIsTargeting()
	or UnitInVehicle("Player")
	or (not UnitCanAttack("player", "target") and not UnitIsPlayer("target") and UnitExists("target"))
	--or UnitCastingInfo("player")
	--or UnitChannelInfo("player")
	or UnitIsDeadOrGhost("player")
	or (UnitIsDeadOrGhost("target") and not UnitIsPlayer("target"))
	or UnitBuff("player",80169) -- Eating
	or UnitBuff("player",87959) -- Drinking
	or UnitBuff("target",104934) -- Eating
	or UnitBuff("player",11392) -- Invisibility
	or UnitBuff("player",9265) -- Deep Sleep(SM)
	then
		return true;
	else
		return false;
	end
end

-- thanks to CML for this routine
function NOC.isException(Unit)
	if Unit == nil then Unit = "target"; else Unit = tostring(Unit) end
	dummies = {
		31144, --Training Dummy - Lvl 80
		31146, --Raider's Training Dummy - Lvl ??
		32541, --Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
		32542, --Disciple's Training Dummy - Lvl 65
		32545, --Initiate's Training Dummy - Lvl 55
		32546, --Ebon Knight's Training Dummy - Lvl 80
		32666, --Training Dummy - Lvl 60
		32667, --Training Dummy - Lvl 70
		46647, --Training Dummy - Lvl 85
		60197, --Scarlet Monastery Dummy
		67127, --Training Dummy - Lvl 90
		87761, --Dungeoneer's Training Dummy <Damage> (Frostall)
		87318, --Dungeoneer's Training Dummy <Damage> (Lunarfall)
		88314, --Dungeoneer's Training Dummy <Tanking> (Lunarefall)
		88288, --Dungeoneer's Training Dummy <Tanking> (Frostwall)
		87322, --Dungeoneer's Training Dummy <Tanking> (Stormshield)
		88836, --Dungeoneer's Training Dummy <Tanking> (Warspear)
		88316, --Training Dummy <Healing>
		89078, --Training Dummy (Garrison)
		76585, --Ragewing <Boss in UBRS>
		76267, --Solar Zealot <Skyreach Final Boss Mob>
		76598, --Ritual of Bones?
		76518 --Ritual of Bones?
	}
	for i=1, #dummies do
		if UnitExists(Unit) and UnitGUID(Unit) then
			dummyID = tonumber(string.match(UnitGUID(Unit), "-(%d+)-%x+$"))
		else
			dummyID = 0
		end
		if dummyID == dummies[i] then
			return true
		end
	end
end

function GetSpellCD(MySpell)
	if GetSpellCooldown(MySpell) == 0 then
		return 0
	else
		local Start ,CD = GetSpellCooldown(MySpell)
		local MyCD = Start + CD - GetTime()
		return MyCD
	end
end

-- Return the amount of energy you will have by the time KS is ready to use
function NOC.KSEnergy()
	local MyNRG = UnitPower("player", 3)
	local MyNRGregen = select(2, GetPowerRegen("player"))
	local NRGforKS = MyNRG + (MyNRGregen * GetSpellCD(121253))
	return NRGforKS
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function NOC.guidtoUnit(guid)
	local inGroup = GetNumGroupMembers()
	if inGroup then
		if IsInRaid("player") then
			for i=1,inGroup do
				if guid == UnitGUID("RAID".. i .. "TARGET") then
					return "RAID".. i .. "TARGET"
				end
			end
		else
			for i=1,inGroup do
				if guid == UnitGUID("PARTY".. i .. "TARGET") then
					return "PARTY".. i .. "TARGET"
				end
			end
			if guid == UnitGUID("PLAYERTARGET") then
				return "PLAYERTARGET"
			end
		end
	else
		if guid == UnitGUID("PLAYERTARGET") then
			return "PLAYERTARGET"
		end
		if guid == UnitGUID("mouseover") then
			return "mouseover"
		end
	end
	return false
end

function NOC.autoSEF()
	-- Initialize 'targets' every call of the function
	local targets = {}

	-- loop through all of the combatTracker enemies and insert only those
	-- that are 'qualified' targets
	for i,_ in pairs(NetherMachine.module.combatTracker.enemy) do

		-- because we can't do most of the required operations on the GUID, we
		-- need to translate the GUID to a UnitID. However a UnitID will only
		-- be valid for those units that are essentially currently targetted by the
		-- player or a player's group-mate, or mouseover, which will result in some
		-- situations where there are enemy actors in combat with the player but
		-- not able to be identified. This is a limitation of not using an
		-- ObjectManager based solution
		local unit = NOC.guidtoUnit(NetherMachine.module.combatTracker.enemy[i]['guid'])

		if unit
		and UnitGUID(unit) ~= UnitGUID("target")
		--and not UnitIsUnit("target",unit)
		and not NetherMachine.condition["debuff"](unit,138130)
		and NetherMachine.condition["distance"](unit) < 40
		and getCreatureType(unit)
		and NOC.immuneEvents(unit)
		and (UnitAffectingCombat(unit) or isException(unit))
		and IsSpellInRange(GetSpellInfo(137639), unit)
		then
			table.insert(targets, { Name = UnitName(unit), Unit = unit, HP = UnitHealth(unit), Range = NetherMachine.condition["distance"](unit) } )
		end
	end

	-- sort the qualified targets by health
	table.sort(targets, function(x,y) return x.HP > y.HP end)

	-- auto-cast SE&F on 1 or 2 targets depending on how many enemies are around us
	if #targets > 0 then
		--print(targets[1].Unit..","..targets[1].Name..","..#targets)
		NetherMachine.dsl.parsedTarget = targets[1].Unit
		return true
	end
	return false
end


NetherMachine.library.register("NOC", NOC)
