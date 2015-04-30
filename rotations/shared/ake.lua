--[[------------------------------------------------------------------------------------------------

ObjectManager.lua

Written by: StinkyTwitch
Version: 0.5
Object Manager License
This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

------------------------------------------------------------------------------------------------]]--
local _, Ake = ...


Ake.specialCCDebuffs = {
    -- CROWD CONTROL
    [   118] = "118",       -- Polymorph: Sheep
    [  2094] = "2094",      -- Blind
    [  1776] = "1776",      -- Gouge
    [  3355] = "3355",      -- Freezing Trap
    [  6770] = "6770",      -- Sap
    [  9484] = "9484",      -- Shackle Undead
    [ 19386] = "19386",     -- Wyvern Sting
    [ 20066] = "20066",     -- Repentance
    [ 28271] = "28271",     -- Polymorph: Turtle
    [ 28272] = "28272",     -- Polymorph: Pig
    [ 51514] = "51514",     -- Hex
    [ 61305] = "61305",     -- Polymorph: Black Cat
    [ 61721] = "61721",     -- Polymorph: Rabbit
    [115078] = "115078",    -- Paralysis
    [115268] = "115268",    -- Mesmerize
    [126819] = "126819",    -- Polymorph: Porcupine
    [161353] = "161353",    -- Polymorph: Polar Bear Cub
    [161354] = "161354",    -- Polymorph: Monkey
    [161355] = "161355",    -- Polymorph: Penguin
    [161372] = "161372",    -- Polymorph: Peacock
}


Ake.specialImmuneBuffs = {
    -- WOD DUNGEONS/RAIDS/ELITES
    [155176] = "155176",    -- Damage Shield (Primal Elementalists - BRF)
    [155185] = "155185",    -- Cotainment (Primal Elementalists - BRF)
    [155265] = "155265",    -- Cotainment (Primal Elementalists - BRF)
    [155266] = "155266",    -- Cotainment (Primal Elementalists - BRF)
    [155267] = "155267",    -- Cotainment (Primal Elementalists - BRF)
}


Ake.specialEnemyTargets = {
    -- TRAINING DUMMIES
    [ 31144] = "31144",     -- Training Dummy - Lvl 80
    [ 31146] = "31146",     -- Raider's Training Dummy - Lvl ??
    [ 32541] = "32541",     -- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
    [ 32542] = "32542",     -- Disciple's Training Dummy - Lvl 65
    [ 32545] = "32545",     -- Initiate's Training Dummy - Lvl 55
    [ 32546] = "32546",     -- Ebon Knight's Training Dummy - Lvl 80
    [ 32666] = "32666",     -- Training Dummy - Lvl 60
    [ 32667] = "32667",     -- Training Dummy - Lvl 70
    [ 46647] = "46647",     -- Training Dummy - Lvl 85
    [ 60197] = "60197",     -- Scarlet Monastery Dummy
    [ 67127] = "67127",     -- Training Dummy - Lvl 90
    [ 87318] = "87318",     -- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
    [ 87761] = "87761",     -- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
    [ 87322] = "87322",     -- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
    [ 88314] = "88314",     -- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
    [ 88836] = "88836",     -- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
    [ 88288] = "88288",     -- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
    -- CATA DUNGEONS/RAIDS
    [ 52577] = "52577",     -- Left Foot (Lord Rhyolith - Firelands)
    [ 53087] = "53087",     -- Right Foot (Lord Rhyolith - Firelands)
    -- WOD DUNGEONS/RAIDS
    [ 75966] = "75966",     -- Defiled Spirit (Shadowmoon Burial Grounds)
    [ 76220] = "76220",     -- Blazing Trickster (Auchindoun Normal)
    [ 76222] = "76222",     -- Rallying Banner (UBRS Black Iron Grunt)
    [ 76267] = "76267",     -- Solar Zealot (Skyreach)
    [ 76518] = "76518",     -- Ritual of Bones (Shadowmoon Burial Grounds)
    [ 77252] = "77252",     -- Ore Crate (BRF Oregorger)
    [ 77665] = "77665",     -- Iron Bomber (BRF Blackhand)
    [ 77891] = "77891",     -- Grasping Earth (BRF Kromog)
    [ 77893] = "77893",     -- Grasping Earth (BRF Kromog)
    [ 78583] = "78583",     -- Dominator Turret (BRF Iron Maidens)
    [ 78584] = "78584",     -- Dominator Turret (BRF Iron Maidens)
    [ 79504] = "79504",     -- Ore Crate (BRF Oregorger)
    [ 79511] = "79511",     -- Blazing Trickster (Auchindoun Heroic)
    [ 81638] = "81638",     -- Aqueous Globule (The Everbloom)
    [ 86644] = "86644",     -- Ore Crate (BRF Oregorger)
    [ 86752] = "86752",     -- Stone Pillars (BRF Mythic Kromog)
}


--[[------------------------------------------------------------------------------------------------
    Name: CombatReach
    Type: Function
    Arguments:  unit - Valid in game unit
    Return: number representing the units combat reach in yards
    Description:
--]]
function Ake.CombatReach(unit)
    if not UnitExists(unit) then
        return 0
    end

    if FireHack then
        local _, distance = pcall(UnitCombatReach, unit)
        return distance
    elseif WOWSX_ISLOADED then
        return UnitCombatReach(unit)
    else
        return 0
    end
end


--[[------------------------------------------------------------------------------------------------
    Name: Distance
    Type: Function
    Arguments:  a - Point 1
                b - Point 2
                precision - Number of decimal places to track
                reach - Use combat reach in the factoring of distance
    Return: Distance
    Description:
--]]
function Ake.Distance(a, b, precision, reach)
    if not UnitExists(a) or not UnitExists(b) or not UnitIsVisible(a) or not UnitIsVisible(b) then
        return 0
    end

    if FireHack then
        local ax, ay, az = ObjectPosition(a)
        local bx, by, bz = ObjectPosition(b)

        if precision then
            if reach then
                local value = math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((Ake.CombatReach(a)) + (Ake.CombatReach(b)))
                return math.floor( (value * 10^precision) + 0.5) / (10^precision)
            else
                local value = math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
                return math.floor( (value * 10^precision) + 0.5) / (10^precision)
            end
        else
            if reach then
                return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((Ake.CombatReach(a)) + (Ake.CombatReach(b)))
            else
                return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
            end
        end
    elseif WOWSX_ISLOADED then
        local ax, ay, az = ObjectPosition(UnitGUID(a))
        local bx, by, bz = ObjectPosition(UnitGUID(b))

        if precision then
            if reach then
                local value = math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((Ake.CombatReach(a)) + (Ake.CombatReach(b)))
                return math.floor( (value * 10^precision) + 0.5) / (10^precision)
            else
                local value = math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
                return math.floor( (value * 10^precision) + 0.5) / (10^precision)
            end
        else
            if reach then
                return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((Ake.CombatReach(a)) + (Ake.CombatReach(b)))
            else
                return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
            end
        end
    else
        return 0
    end
end


--[[------------------------------------------------------------------------------------------------
    Name: ObjectManager
    Type: Function
    Arguments: range - int variable representing radius in yards to search from 'player'
    Return: None
    Description:
--]]
Ake.objectCacheAll = { }
Ake.objectCache = { }
function Ake.ObjectManager(range)
    wipe(Ake.objectCacheAll)
    wipe(Ake.objectCache)

    if range == nil then
        range = 40
    end

    if FireHack and NetherMachine.module.player.combat then
        local totalObjects = ObjectCount()

        for i=1, totalObjects do
            local object = ObjectWithIndex(i)
            local _, objectExists = pcall(ObjectExists, object)

            if objectExists then
                local _, objectType = pcall(ObjectType, object)

                if bit.band(objectType, ObjectTypes.Unit) > 0 then
                    local objectDistance = Ake.Distance("player", object, 2)

                    if objectDistance <= range then
                        local objectHealth = UnitHealth(object)
                        local objectIsDead = UnitIsDead(object)
                        local objectAttackable = UnitCanAttack("player", object)

                        if objectHealth > 0 and objectAttackable and not objectIsDead then
                            local objectHealthMax = UnitHealthMax(object)
                            local objectHealthPercentage = math.floor((objectHealth / objectHealthMax) * 100)
                            local objectName = UnitName(object)
                            local reaction = UnitReaction("player", object)

                            if reaction and reaction <= 4 then
                                local specialEnemy = Ake.SpecialEnemyTarget(object)
                                local ccDebuff = Ake.SpecialCCDebuff(object)
                                local immuneBuff = Ake.SpecialImmuneBuff(object)
                                local tappedByPlayer = UnitIsTappedByPlayer(object)
                                local tappedByAll = UnitIsTappedByAllThreatList(object)

                                Ake.objectCacheAll[#Ake.objectCacheAll+1] = { object = object }

                                if not ccDebuff and not immuneBuff and (tappedByPlayer or tappedByAll or specialEnemy) then
                                    Ake.objectCache[#Ake.objectCache+1] = {
                                        object = object,
                                        name = objectName,
                                        health = objectHealthPercentage,
                                        distance = objectDistance
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif WOWSX_ISLOADED and NetherMachine.module.player.combat then
        local totalObjects = GetNumObjects()

        for i=1, totalObjects do
            local object = GetObjectGuid(i)
            local objectExists = UnitExists(object)

            if objectExists then
                local objectType = ObjectType(object)

                if objectType == objectTypes.Unit then
                    local objectDistance = Ake.Distance("player", object, 2)

                    if objectDistance <= range then
                        local objectHealth = UnitHealth(object)
                        local objectIsDead = UnitIsDead(object)
                        local objectAttackable = UnitCanAttack("player", object)

                        if objectHealth > 0 and objectAttackable and not objectIsDead then
                            local objectHealthMax = UnitHealthMax(object)
                            local objectHealthPercentage = math.floor((objectHealth / objectHealthMax) * 100)
                            local objectName = UnitName(object)
                            local reaction = UnitReaction("player", object)

                            if reaction and reaction <= 4 then
                                local specialEnemy = Ake.SpecialEnemyTarget(object)
                                local ccDebuff = Ake.SpecialCCDebuff(object)
                                local immuneBuff = Ake.SpecialImmuneBuff(object)
                                local tappedByPlayer = UnitIsTappedByPlayer(object)
                                local tappedByAll = UnitIsTappedByAllThreatList(object)

                                Ake.objectCacheAll[#Ake.objectCacheAll+1] = { object = object }

                                if not ccDebuff and not immuneBuff and (tappedByPlayer or tappedByAll or specialEnemy) then
                                    Ake.objectCache[#Ake.objectCache+1] = {
                                        object = object,
                                        name = objectName,
                                        health = objectHealthPercentage,
                                        distance = objectDistance
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        if (FireHack or WOWSX_ISLOADED) and not NetherMachine.module.player.combat then
            return
        -- Generic Unlocker
        else
            if UnitExists("target") then
                local object = UnitGUID("target")
                local objectHealth = UnitHealth("target")
                local objectHealthMax = UnitHealthMax("target")
                local objectHealthPercentage = math.floor((objectHealth / objectHealthMax) * 100)
                local objectName = UnitName("target")
                local objectDistance = 0

                Ake.objectCacheAll[#Ake.objectCacheAll+1] = { object = object }
                Ake.objectCache[#Ake.objectCache+1] = {
                    object = object,
                    name = objectName,
                    health = objectHealthPercentage,
                    distance = objectDistance
                }
            end
        end
    end
end


--[[------------------------------------------------------------------------------------------------
    Name: Ake.PositionBetweenObjects
    Type: Function
    Arguments: distance, a, b
    Return: x, y, z
    Description:
--]]
function Ake.PositionBetweenObjects(distance, a, b)
    local ax, ay, az = ObjectPosition(a)
    local bx, by, bz = ObjectPosition(b or "player")

    local facing = math.atan2(by - ay, bx - ax) % (math.pi * 2)
    local pitch = math.atan((bz - az) / math.sqrt(((ax - bx) ^ 2) + ((ay - by) ^ 2))) % (math.pi * 2)

    return math.cos(facing) * distance + ax,
        math.sin(facing) * distance + ay,
        math.sin(pitch) * distance + az
end


--[[------------------------------------------------------------------------------------------------
    Name: SpecialCCDebuff
    Type: Function
    Arguments: unit - Valid game unit
    Return: Boolean
    Description: Run through the specialCCDebuffs table checking to see if the supplied 'unit'
    has a matching debuff. If a match is found return true, otherwise return false.
--]]
function Ake.SpecialCCDebuff(unit)
    if not UnitExists(unit) then
        return false
    end

    for k,v in pairs(Ake.specialCCDebuffs) do
        debuff = GetSpellInfo(k)
        if UnitDebuff(unit, debuff) then
            return true
        end
    end
    return false
end


--[[------------------------------------------------------------------------------------------------
    Name: SpecialImmuneBuff
    Type: Function
    Arguments: unit - Valid game unit
    Return: Boolean
    Description: Run through the specialImmuneBuffs table checking to see if the supplied 'unit'
    has a matching buff. If a match is found return true, otherwise return false.
--]]
function Ake.SpecialImmuneBuff(unit)
    if not UnitExists(unit) then
        return false
    end

    for k,v in pairs(Ake.specialImmuneBuffs) do
        buff = GetSpellInfo(k)
        if UnitBuff(unit, buff) then
            return true
        end
    end
    return false
end


--[[------------------------------------------------------------------------------------------------
    Name: SpecialEnemyTarget
    Type: Function
    Arguments: unit - Valid game unit
    Return: Boolean
    Description: If the UnitID matches a Special Enemy Unit in the table then return true.
    Otherwise the unit is not a Special Enemy.
--]]
function Ake.SpecialEnemyTarget(unit)
    if not UnitExists(unit) then
        return false
    end
    local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))
    if Ake.specialEnemyTargets[tonumber(unitID)] ~= nil then
        return true
    else
        return false
    end
end


--[[------------------------------------------------------------------------------------------------
    Name: UnitsAroundUnit
    Type: Function
    Arguments: unit - Valid game unit
               distance -
               ignoreCombat -
    Return: total -
    Description:
--]]
Ake.uauCacheSize = Ake.uauCacheSize or 0
local uauCacheTime = uauCacheTime or { }
local uauCacheCount = uauCacheCount or { }
local uauCacheDuration = uauCacheDuration or 0.1
function Ake.UnitsAroundUnit(unit, distance, ignoreCombat)
    local uauCacheTime_C = uauCacheTime[unit..distance..tostring(ignoreCombat)]
    if uauCacheTime_C and ((uauCacheTime_C + uauCacheDuration) > GetTime()) then
        return uauCacheCount[unit..distance..tostring(ignoreCombat)]
    end
    if UnitExists(unit) then
        local total = 0
        for i=1, #Ake.objectCache do
            local unitDistance = Ake.Distance(Ake.objectCache[i].object, unit)
            if unitDistance <= distance then
                total = total + 1
            end
        end
        uauCacheCount[unit..distance..tostring(ignoreCombat)] = total
        uauCacheTime[unit..distance..tostring(ignoreCombat)] = GetTime()
        Ake.uauCacheSize = total
        return total
    else
        Ake.uauCacheSize = 0
        return 0
    end
end




















----------------------------------------------------------------------------------------------------
-- CUSTOM NM REGISTERS
----------------------------------------------------------------------------------------------------


--[[------------------------------------------------------------------------------------------------
    Name: akearea.enemies
    Type: NM Register
    Arguments: target, distance
    Return: total
    Description:
--]]
NetherMachine.condition.register("akearea.enemies", function(target, distance)
    if Ake.UnitsAroundUnit then
        local total = Ake.UnitsAroundUnit(target, tonumber(distance))
        return total
    end
    return 0
end)


--[[------------------------------------------------------------------------------------------------
    Name: distancetotarget
    Type: NM Register
    Arguments: target - Valid game unit
    Return: distance - Integer representing distance in yards between 'target' and  "target"
    Description:
--]]
NetherMachine.condition.register("distancetotarget", function(target)
    local targetExists = UnitExists(target)
    local unitExists = UnitExists("target")
    if not targetExists or not unitExists then
        return false
    end

    local isAttackable = UnitCanAttack(target, "target")
    local isDead = UnitIsDead("target")

    if isAttackable and not isDead then
        if FireHack or WOWSX_ISLOADED then
            return Ake.Distance(target, "target", 2, "reach")
        else
            return 0
        end
    else
        return 0
    end
end)




















----------------------------------------------------------------------------------------------------
-- NM OVERRIDES
----------------------------------------------------------------------------------------------------

Ake.NMOverrides = {
    {"", (function()
        -- We only want to override this once.
        if not Ake.overloadFirstRun then
            if FireHack then
                CastGround = nil
                LineOfSight = nil

                function CastGround(spell, target)
                    if UnitExists(target) then
                        local _,_,_,_,_, maxRange,_ = GetSpellInfo(spell)
                        local reachPlayer = UnitCombatReach("player")
                        local reachTarget = UnitCombatReach(target)
                        local combatDistance = Distance(target, "player")
                        local trueDistance = combatDistance + reachTarget + reachPlayer

                        if combatDistance < maxRange and trueDistance > maxRange then
                            local x, y, z = PositionBetweenObjects((maxRange-3), "player", target)
                            CastSpellByName(spell)
                            CastAtPosition(x, y, z)
                            CancelPendingSpell()
                            return
                        else
                            CastSpellByName(spell)
                            CastAtPosition(ObjectPosition(target))
                            CancelPendingSpell()
                            return
                        end
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
                function LineOfSight(a, b)
                    if UnitExists(a) and UnitExists(b) then
                        -- Ignore Line of Sight on these units with very weird combat.
                        local ignoreLOS = {
                            [76585] = true,     -- Ragewing the Untamed (UBRS)
                            [77063] = true,     -- Ragewing the Untamed (UBRS)
                            [77182] = true,     -- Oregorger (BRF)
                            [77891] = true,     -- Grasping Earth (BRF)
                            [77893] = true,     -- Grasping Earth (BRF)
                            [78981] = true,     -- Iron Gunnery Sergeant (BRF)
                            [81318] = true,     -- Iron Gunnery Sergeant (BRF)
                            [83745] = true,     -- Ragewing Whelp (UBRS)
                            [86252] = true,     -- Ragewing the Untamed (UBRS)
                        }
                        local losFlags =  bit.bor(0x10, 0x100)
                        local _, ax, ay, az = pcall(ObjectPosition, a)
                        local _, bx, by, bz = pcall(ObjectPosition, b)

                        -- Variables
                        local aCheck = select(6,strsplit("-",UnitGUID(a)))
                        local bCheck = select(6,strsplit("-",UnitGUID(b)))

                        if ignoreLOS[tonumber(aCheck)] ~= nil then return true end
                        if ignoreLOS[tonumber(bCheck)] ~= nil then return true end
                        if TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags) then return false end
                        return true
                    end
                end
                print("NM Overloads loaded.")
            elseif WOWSX_ISLOADED then
                CastGround = nil
                LineOfSight = nil

                function CastGround(spell, target)
                    if UnitExists(target) then
                        local _,_,_,_,_, maxRange,_ = GetSpellInfo(spell)
                        local reachPlayer = UnitCombatReach("player")
                        local reachTarget = UnitCombatReach(target)
                        local combatDistance = Distance(target, "player")
                        local trueDistance = combatDistance + reachTarget + reachPlayer

                        if combatDistance < maxRange and trueDistance > maxRange then
                            local x, y, z = Ake.PositionBetweenObjects((maxRange-3), "player", target)
                            CastSpellByName(spell)
                            CastAtPosition(x, y, z)
                            CancelPendingSpell()
                            return
                        else
                            CastSpellByName(spell)
                            CastAtPosition(ObjectPosition(target))
                            CancelPendingSpell()
                            return
                        end
                    end
                    if not NetherMachine.timeout.check('groundCast') then
                        NetherMachine.timeout.set('groundCast', 0.05, function()
                            Cast(spell)

                                SetCVar("deselectOnClick", "0")
                                CameraOrSelectOrMoveStart(1)
                                CameraOrSelectOrMoveStop(1)
                                SetCVar("deselectOnClick", "1")
                                SetCVar("deselectOnClick", stickyValue)
                                CancelPendingSpell()

                        end)
                    end
                end
                function LineOfSight(a, b)
                    if UnitExists(a) and UnitExists(b) then
                        -- Ignore Line of Sight on these units with very weird combat.
                        local ignoreLOS = {
                            [76585] = true,     -- Ragewing the Untamed (UBRS)
                            [77063] = true,     -- Ragewing the Untamed (UBRS)
                            [77182] = true,     -- Oregorger (BRF)
                            [77891] = true,     -- Grasping Earth (BRF)
                            [77893] = true,     -- Grasping Earth (BRF)
                            [78981] = true,     -- Iron Gunnery Sergeant (BRF)
                            [81318] = true,     -- Iron Gunnery Sergeant (BRF)
                            [83745] = true,     -- Ragewing Whelp (UBRS)
                            [86252] = true,     -- Ragewing the Untamed (UBRS)
                        }
                        -- Variables
                        local aCheck = select(6,strsplit("-",UnitGUID(a)))
                        local bCheck = select(6,strsplit("-",UnitGUID(b)))

                        if ignoreLOS[tonumber(aCheck)] ~= nil then return true end
                        if ignoreLOS[tonumber(bCheck)] ~= nil then return true end

                        if ObjectIsLineOfSight(a, b) then
                            return true
                        else
                            return false
                        end
                    end
                end
                print("NM Overloads loaded.")
            end

            -- Only load once
            if NetherMachine.protected.unlocked then Ake.overloadFirstRun = true end
        end
    end)},
}




















----------------------------------------------------------------------------------------------------
-- OBJECT MANAGER TIMER
----------------------------------------------------------------------------------------------------
C_Timer.NewTicker(0.25,
    (function()
        if NetherMachine.config.read('button_states', 'MasterToggle', false) then
            if FireHack or WOWSX_ISLOADED then
                Ake.ObjectManager(40)
            end
        end
    end),
nil)
