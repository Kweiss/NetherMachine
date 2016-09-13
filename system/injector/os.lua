-- lua functions (call it from lua addon, or type in chat or macro/console. example: "/run olog()", "/run ohelp()")
--   oexecute(some lua protected code) - wrapper function for protected lua functions
-- 	UnitWorldClick(unit) - "click" aoe-spell to unit location (like warlock's rain of fire or monk's healing sphere)
-- 	UnitInLos(unit) - return true if unit in los, false otherwise
-- 	BehindUnit(unit) - return true if player behind a unit, false otherwise
-- 	UnitPosition(unit) - shows info about a unit (x,y,z,facing)
-- 	FaceToUnit(unit) - turn player face to unit
-- 	UnitAuraByID(unit, spellId, isMine) - returns aura info from unit:
-- 	olog() - toggle log output in wow chat for warden scanner
-- 	ohelp() - shows help info in wow chat
-- 	ObjectsCount() - returns objects count near specific unit
-- 	pointer = ObjectByIndex(index) - returns a pointer to object - can be used in standart wow functions like a UnitName, UnitHealth, UnitReaction and other object fields/values
-- 	ObjectDescriptorInt(pointer, idx) - returns int descriptor (all descriptors you can get from dump threads in memory edition section)
-- 	ObjectDescriptorFloat(pointer, idx) - returns float descriptor, BoundingRadius for example, idx = 0x188 and 392 as dec
-- 	ObjectDescriptorGUID(pointer, idx) - returns guid descriptor (as string), need to compare creator and player for example

local L = NetherMachine.locale.get

function NetherMachine.protected.OffSpring()

	if oexecute then

		NetherMachine.faceroll.rolling = false

		NetherMachine.pmethod = "OffSpring"

		function Cast(spell, target)
			if type(spell) == "number" then
				if target then
					oexecute("CastSpellByID(".. spell ..", \""..target.."\")")
				else
					oexecute("CastSpellByID(".. spell ..")")
				end
			else
				if target then
					oexecute("CastSpellByName(\"".. spell .."\", \""..target.."\")")
				else
					oexecute("CastSpellByName(\"".. spell .."\")")
				end
			end
		end

		local CastGroundOld = CastGround
		function CastGround(spell, target)
			if UnitExists(target) then
				Cast(spell, target)
				UnitWorldClick(target)
				return
			end
			CastGroundOld(spell, target) -- try the old one ?
		end

		function LineOfSight(a, b)
			if a ~= 'player' then
				NetherMachine.print(L('offspring_los_warn'))
			end
			return not UnitInLos(b)
		end

		function Macro(text)
			oexecute("RunMacroText(\""..text.."\")")
		end

		function Distance(a, b)
			if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
				local ax, ay, az, ar = UnitPosition(a)
				local bx, by, bz, br = UnitPosition(b)
				return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
			end
			return 0
		end

		function FaceUnit(unit)
			if UnitExists(unit) and UnitIsVisible(unit) then
				FaceToUnit(unit)
			end
		end

		function UseItem(name, target)
			if type(spell) == "number" then
				if target then
					oexecute("UseItemByName(".. spell ..", \""..target.."\")")
				else
					oexecute("UseItemByName(".. spell ..")")
				end
			else
				if target then
					oexecute("UseItemByName(\"".. spell .."\", \""..target.."\")")
				else
					oexecute("UseItemByName(\"".. spell .."\")")
				end
			end
		end

		function UseInvItem(slot)
			return oexecute("UseInventoryItem(\""..slot.."\")")
		end

		function UnitInfront(unit1, unit2)
			if unit1 == 'player' then
				return not BehindUnit(unit2)
			else
				return not BehindUnit(unit1)
			end
		end

		local uau_cache_time = { }
		local uau_cache_count = { }
		local uau_cache_dura = 0.1
		function UnitsAroundUnit(unit, distance, ignoreCombat)
			local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)]
			if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
				return uau_cache_count[unit..distance..tostring(ignoreCombat)]
			end
			if UnitExists(unit) then
				local total = 0
				local totalObjects = ObjectsCount(unit, distance)
				for i = 1, totalObjects do
					local pointer, id, name, bounding, x, y, z, facing, summonedbyme, createdbyme, combat, target = ObjectByIndex(i)
					local _, oType = pcall(ObjectType, pointer)
					local reaction = UnitReaction("player", pointer)
					if reaction then
						local combat = UnitAffectingCombat(pointer)
						if reaction and reaction <= 4 and (ignoreCombat or combat) then
							total = total + 1
						end
					end
				end
				uau_cache_count[unit..distance..tostring(ignoreCombat)] = total
				uau_cache_time[unit..distance..tostring(ignoreCombat)] = GetTime()
				return total - 1
			else
				return 0
			end
		end

		function FriendlyUnitsAroundUnit(unit, distance, ignoreCombat)
		local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)..'f']
		if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
			return uau_cache_count[unit..distance..tostring(ignoreCombat)..'f']
		end
		if UnitExists(unit) then
			local total = 0
			local totalObjects = ObjectsCount(unit, distance)
			for i = 1, totalObjects do
				local pointer, id, name, bounding, x, y, z, facing, summonedbyme, createdbyme, combat, target = ObjectByIndex(i)
				local reaction = UnitReaction("player", pointer)
				if reaction then
					local combat = UnitAffectingCombat(pointer)
					if reaction and reaction >= 5 and (ignoreCombat or combat) then
						total = total + 1
					end
				end
			end
			uau_cache_count[unit..distance..tostring(ignoreCombat)..'f'] = total
			uau_cache_time[unit..distance..tostring(ignoreCombat)..'f'] = GetTime()
			return total - 1
		else
			return 0
		end
	end

	function StopCast()
		oexecute("SpellStopCasting()")
	end

	NetherMachine.protected.unlocked = true
	NetherMachine.protected.method = "offspring"
	NetherMachine.timer.unregister('detectUnlock')
	NetherMachine.print(L('unlock_offspring'))

end

end
