local L = NetherMachine.locale.get

function NetherMachine.protected.FireHack()

    if FireHack then

        NetherMachine.faceroll.rolling = false

        local stickyValue = GetCVar("deselectOnClick")

        NetherMachine.pmethod = "FireHack"

        function IterateObjects(callback, ...)
            local totalObjects = ObjectCount()
            for i = 1, totalObjects do
                local object = ObjectWithIndex(i)
                if bit.band(ObjectType(object), ...) > 0 then
                    callback(object)
                end
            end
        end

        function ObjectFromUnitID(unit)
            local unitGUID = UnitGUID(unit)
            local totalObjects = ObjectCount()
            for i = 1, totalObjects do
                local object = ObjectWithIndex(i)
                if UnitExists(object) and UnitGUID(object) == unitGUID then
                    return object
                end
            end
            return false
        end

        function Distance(a, b)
            if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
                local ax, ay, az = ObjectPosition(a)
                local bx, by, bz = ObjectPosition(b)
                return (math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitCombatReach(a)) + (UnitCombatReach(b))))
            end
            return 0
        end

        function DistanceActual(a, b)
          if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
            local ax, ay, az = ObjectPosition(a)
            local bx, by, bz = ObjectPosition(b)
            return (math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)))
          end
          return 0
        end

        local function SmartPositionOfEnemies(reach, size)
          local units = Player:GetNearbyEnemies(reach)
          local win = 0
          local winners = {}
          for _, enemy in ipairs(units) do
            local neighbors = 0
            for _, neighbor in ipairs(units) do
              if enemy:GetDistance(neighbor) <= size then
                neighbors = neighbors + 1
              end
            end
            if neighbors >= win and neighbors > 0 then
              table.insert(winners, enemy)
              win = neighbors
            end
          end
          return GetAveragePositionOfObjects(winners)
        end

--        local uau_cache_time = { }
--        local uau_cache_count = { }
--        local uau_cache_dura = 0.1
--        function UnitsAroundUnit(unit, distance, ignoreCombat)
--            local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)]
--            if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
--                return uau_cache_count[unit..distance..tostring(ignoreCombat)]
--            end
--            if UnitExists(unit) then
--                local total = 0
--                local totalObjects = ObjectCount()
--                for i = 1, totalObjects do
--                    local object = ObjectWithIndex(i)
--                    local _, oType = pcall(ObjectType, object)
--                    local unitisunit = bit.band(oType, ObjectTypes.Unit)
--                    if unitisunit and unitisunit > 0 then
--                        local reaction = UnitReaction("player", object)
--                        local combat = UnitAffectingCombat(object)
--                        local health = UnitHealth(object)
--                        if reaction and reaction <= 4 and (ignoreCombat or combat) then
--                            if Distance(object, unit) <= distance and health > 0 then
--                                total = total + 1
--                            end
--                        end
--                    end
--                end
--                uau_cache_count[unit..distance..tostring(ignoreCombat)] = total
--                uau_cache_time[unit..distance..tostring(ignoreCombat)] = GetTime()
--                return total
--            else
--                return 0
--            end
--        end

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
                local totalObjects = ObjectCount()
                for i = 1, totalObjects do
                    local object = ObjectWithIndex(i)
                    local _, oType = pcall(ObjectType, object)
                    if bit.band(oType, ObjectTypes.Unit) > 0 then
                        local reaction = UnitReaction("player", object)
                        local combat = UnitAffectingCombat(object)
                        local _, special_target = pcall(SpecialTargetCheck, object)
                        local _, tapped_by_me = pcall(UnitIsTappedByPlayer, object)
                        local _, tapped_by_all = pcall(UnitIsTappedByAllThreatList, object)
                        --if reaction and reaction <= 4 and (ignoreCombat or combat) then
                        if reaction and reaction <= 4 and (ignoreCombat or tapped_by_me or tapped_by_all or special_target) then
                            if Distance(object, unit) <= distance then
                                total = total + 1
                            end
                        end
                    end
                end
                uau_cache_count[unit..distance..tostring(ignoreCombat)] = total
                uau_cache_time[unit..distance..tostring(ignoreCombat)] = GetTime()
                return total
            else
                return 0
            end
        end

--        local fuau_cache_time = { }
--        local fuau_cache_count = { }
--        local fuau_cache_dura = 0.1
--        function FriendlyUnitsAroundUnit(unit, distance, ignoreCombat)
--            local fuau_cache_time_c = fuau_cache_time[unit..distance..tostring(ignoreCombat)..'f']
--            if fuau_cache_time_c and ((fuau_cache_time_c + fuau_cache_dura) > GetTime()) then
--                return fuau_cache_count[unit..distance..tostring(ignoreCombat)..'f']
--            end
--            if UnitExists(unit) then
--                local total = 0
--                local totalObjects = ObjectCount()
--                for i = 1, totalObjects do
--                    local object = ObjectWithIndex(i)
--                    local _, oType = pcall(ObjectType, object)
--                    local unitisunit = bit.band(oType, ObjectTypes.Unit)
--                    if unitisunit and unitisunit > 0 then
--                        local reaction = UnitReaction("player", object)
--                        local combat = UnitAffectingCombat(object)
--                        local health = UnitHealth(object)
--                        if reaction and reaction >= 5 and (ignoreCombat or combat) then
--                            if Distance(object, unit) <= distance and health > 0 then
--                                total = total + 1
--                            end
--                        end
--                    end
--                end
--                fuau_cache_count[unit..distance..tostring(ignoreCombat)..'f'] = total
--                fuau_cache_time[unit..distance..tostring(ignoreCombat)..'f'] = GetTime()
--                return total
--            else
--                return 0
--            end
--        end

		function FriendlyUnitsAroundUnit(unit, distance, ignoreCombat)
            local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)..'f']
            if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
                return uau_cache_count[unit..distance..tostring(ignoreCombat)..'f']
            end
            if UnitExists(unit) then
                local total = 0
                local totalObjects = ObjectCount()
                for i = 1, totalObjects do
                    local object = ObjectWithIndex(i)
                    local _, oType = pcall(ObjectType, object)
                    if bit.band(oType, ObjectTypes.Unit) > 0 then
                        local reaction = UnitReaction("player", object)
                        local combat = UnitAffectingCombat(object)
                        if reaction and reaction >= 5 and (ignoreCombat or combat) then
                            if Distance(object, unit) <= distance then
                                total = total + 1
                            end
                        end
                    end
                end
                uau_cache_count[unit..distance..tostring(ignoreCombat)..'f'] = total
                uau_cache_time[unit..distance..tostring(ignoreCombat)..'f'] = GetTime()
                return total
            else
                return 0
            end
        end

        local nhau_cache_time = { }
        local nhau_cache_count = { }
        local nhau_cache_dura = 0.1
        function NeedHealsAroundUnit(unit, distance, health)
          local nhau_cache_time_c = nhau_cache_time[unit..distance..health]
          if nhau_cache_time_c and ((nhau_cache_time_c + nhau_cache_dura) > GetTime()) then
            return nhau_cache_count[unit..distance..health]
          end
          if UnitExists(unit) then
            local total = 0
            local totalObjects = ObjectCount()
            for i = 1, totalObjects do
              local object = ObjectWithIndex(i)
              local _, oType = pcall(ObjectType, object)
              local unitisunit = bit.band(oType, ObjectTypes.Player)
              if unitisunit and unitisunit > 0 then
                local health = UnitHealth(object)
                local healthpct = math.floor((UnitHealth(object)/UnitHealthMax(object))*100)
                if healthpct and healthpct <= health
                 and health and health > 0
                 and UnitIsFriend("player", object)
                 and Distance(object, unit) <= distance then
                    total = total + 1
                end
              end
            end
            nhau_cache_count[unit..distance..health..'h'] = total
            nhau_cache_time[unit..distance..health..'h'] = GetTime()
            return total
          else
            return 0
          end
        end

        function FaceUnit(unit)
            if UnitExists(unit) and UnitIsVisible(unit) then
                local ax, ay, az = ObjectPosition('player')
                local bx, by, bz = ObjectPosition(unit)
                local angle = rad(atan2(by - ay, bx - ax))
                if angle < 0 then
                    return FaceDirection(rad(atan2(by - ay, bx - ax) + 360))
                else
                    return FaceDirection(angle)
                end
            end
        end

        local losFlags =  bit.bor(0x10, 0x100)
        function LineOfSight(a, b)
            local ax, ay, az = ObjectPosition(a)
            local bx, by, bz = ObjectPosition(b)
            if TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags) then
                return false
            end
            return true
        end

        --[[
        function UnitInfront(unit)
            local aX, aY, aZ = ObjectPosition(unit)
            local bX, bY, bZ = ObjectPosition('player')
            local playerFacing = GetPlayerFacing()
            local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
            return math.abs( math.abs(playerFacing - facing) - 180 ) < 1.5707963267949
        end
        ]]

        function UnitInfront(unit1, unit2)
          if not UnitExists(unit1) or not UnitExists(unit2) then return false end
          local aX, aY, aZ = ObjectPosition(unit1)
          local bX, bY, bZ = ObjectPosition(unit2)
          local playerFacing = GetPlayerFacing()
          local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
          return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
        end

        --[[
        function UnitInfront(unit1, unit2)
            if not (UnitExists(unit1) and UnitExists(unit2)) then return end
            local x1, y1, _ = ObjectPosition(unit1)
            local x2, y2, _ = ObjectPosition(unit2)
            local facing = ObjectFacing(unit1)
            local angle = atan2(y1 - y2, x1 - x2) - deg(facing)
            if angle < 0 then
                angle = angle + 360
            end
            return (angle > 120 and angle < 240)
        end
        ]]

        function CastGround(spell, target)
            if ObjectExists(target) and UnitExists(target) then
              Cast(spell, target)
              CastAtPosition(ObjectPosition(target))
              CancelPendingSpell()
              return
            end
            if not NetherMachine.timeout.check('groundCast') then
                NetherMachine.timeout.set('groundCast', 0.05, function()
                    Cast(spell)
                    if IsAoEPending() then
                        SetCVar("deselectOnClick", "0")
                        CameraOrSelectOrMoveStart(1)
                        CameraOrSelectOrMoveStop(1)
                        SetCVar("deselectOnClick", "1")
                        SetCVar("deselectOnClick", stickyValue)
                        CancelPendingSpell()
                    end
                end)
            end
        end

        function Macro(text)
            return RunMacroText(text)
        end

        function UseItem(name, target)
            return UseItemByName(name, target)
        end

        function UseInvItem(slot)
          return UseInventoryItem(slot)
        end

        function Cast(spell, target)
            if type(spell) == "number" then
                CastSpellByID(spell, target)
            else
                CastSpellByName(spell, target)
            end
        end

        NetherMachine.protected.unlocked = true
        NetherMachine.protected.method = "firehack"
        NetherMachine.timer.unregister('detectUnlock')
        NetherMachine.print(L('unlock_firehack'))

    end

end
