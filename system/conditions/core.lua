local GetTime = GetTime
local GetSpellBookIndex = GetSpellBookIndex
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitClassification = UnitClassification
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local stringFind = string.find
local stringLower = string.lower
local stringGmatch = string.gmatch

local NetherMachineTempTable1 = { }
local rangeCheck = LibStub("LibRangeCheck-2.0")
local LibDispellable = LibStub("LibDispellable-1.0")
local LibBoss = LibStub("LibBossIDs-1.0")

-- Dynamically evaluate a condition
function dynamicEval(condition, spell)
  if not condition then return false end
  return NetherMachine.dsl.parse(condition, spell or '')
end

-- Display interface function
function displayFrame(frame)
	if not createFrame then
		windowRef = NetherMachine.interface.buildGUI(frame)
		createFrame = true
		frameState = true
		windowRef.parent:SetEventListener('OnClose', function()
			createFrame = false
			frameState = false
		end)
	elseif createFrame == true and frameState == true then
		windowRef.parent:Hide()
		frameState = false
	elseif createFrame == true and frameState == false then
		windowRef.parent:Show()
		frameState = true
	end
end

--Blessings
function setBlessing(setting)
  local fetch = NetherMachine.interface.fetchKey
  local blessing = fetch(setting, 'set_blessing')

  if blessing ~= "none" then
    if dynamicEval("!player.buff("..blessing..")") then CastSpellByID(blessing) end
  end
end

-- local buff, _, _, count, _, duration, expires, caster = UnitBuff(target, spell)
local UnitBuff = function(target, spell, owner)
    local buff, count, caster, expires, spellID
    if tonumber(spell) then
      local i = 0; local go = true
      while i <= 40 and go do
        i = i + 1
        buff,_,_,count,_,_,expires,caster,_,_,spellID = _G['UnitBuff'](target, i)
        if not owner then
          if spellID == tonumber(spell) and caster == "player" then go = false end
        elseif owner == "any" then
          if spellID == tonumber(spell) then go = false end
        end
      end
    else
    buff,_,_,count,_,_,expires,caster = _G['UnitBuff'](target, spell)
    end
    return buff, count, expires, caster
end

-- local debuff, _, _, count, _, duration, expires, caster = UnitDebuff(target, spell)
local UnitDebuff = function(target, spell, owner)
    local debuff, count, caster, expires, spellID
    if tonumber(spell) then
      local i = 0; local go = true
      while i <= 40 and go do
        i = i + 1
        debuff,_,_,count,_,_,expires,caster,_,_,spellID,_,_,_,power = _G['UnitDebuff'](target, i)
        if not owner then
          if spellID == tonumber(spell) and caster == "player" then go = false end
        elseif owner == "any" then
          if spellID == tonumber(spell) then go = false end
        end
      end
    else
      debuff,_,_,count,_,_,expires,caster = _G['UnitDebuff'](target, spell)
    end
    return debuff, count, expires, caster, power
end

NetherMachine.condition.register("dispellable", function(target, spell)
    if LibDispellable:CanDispelWith(target, GetSpellID(GetSpellName(spell))) then
      return true
    end
    return false
end)

NetherMachine.condition.register("race", function(target, spell)
    if UnitExists(target) then
      local race, raceEn = UnitRace(target)
      if race and raceEn and (string.lower(race) == string.lower(spell) or string.lower(raceEn) == string.lower(spell)) then
        return true
      end
    end
    return false
end)

NetherMachine.condition.register("buff", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local buff,_,_,caster = UnitBuff(target, spell)
    if buff and (caster == 'player' or caster == 'pet') then
      return true
    end
    return false
end)

NetherMachine.condition.register("buff.any", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local buff,_,_,caster = UnitBuff(target, spell, "any")
    if not not buff then
      return true
    end
    return false
end)

NetherMachine.condition.register("buff.count", function(target, spell) -- returns 0 for count if buff doesnt stack
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local buff,count,_,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
      return count
    end
    return 0
end)

NetherMachine.condition.register("debuff", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local debuff,_,_,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
      return true
    end
    return false
end)

NetherMachine.condition.register("debuff.any", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local debuff,_,_,caster = UnitDebuff(target, spell, "any")
    if not not debuff then
      return true
    end
    return false
end)

NetherMachine.condition.register("debuff.count", function(target, spell) -- returns 0 for count if buff doesnt stack
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local debuff,count,_,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
      return count
    end
    return 0
end)

NetherMachine.condition.register("debuff.remains", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local debuff,_,expires,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
      return (expires - GetTime())
    end
    return 0
end)

-- TODO: should be the initial duration when cast.
NetherMachine.condition.register("debuff.duration", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local debuff,_,expires,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
      return (expires - GetTime())
    end
    return 0
end)

NetherMachine.condition.register("buff.remains", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local buff,_,expires,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
      return (expires - GetTime())
    end
    return 0
end)

-- TODO: should be the initial duration when cast.
NetherMachine.condition.register("buff.duration", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local buff,_,expires,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
      return (expires - GetTime())
    end
    return 0
end)

--[[
NetherMachine.condition.register("aura.", function(target, spell)
    local guid = UnitGUID(target)
    if guid then
        local unit = NetherMachine.module.tracker.units[guid]
        if unit then
            local aura = unit.auras[GetSpellID(spell)]
            local track = false
            if aura['damage'] and not aura['heal'] then
                track = aura['damage']
            elseif aura['heal'] and not aura['damage'] then
                track = aura['heal']
            end
            if track then
                return track.
            end
        end
    end
    return false
end)
]]

local function smartQueryTracker(target, spell, key)
    local guid = UnitGUID(target)
    if guid then
        local unit = NetherMachine.module.tracker.units[guid]
        if unit then
            local aura = unit.auras[GetSpellID(spell)]
            if aura then
                local track = false
                if key == 'stacks' or key == 'time' then
                    track = aura
                else
                    if aura['damage'] and not aura['heal'] then
                        track = aura['damage']
                    elseif aura['heal'] and not aura['damage'] then
                        track = aura['heal']
                    end
                end
                if track then
                    return track[key]
                end
            end
        end
    end
    return false
end

NetherMachine.condition.register("aura.crit", function(target, spell)
    return smartQueryTracker(target, spell, 'crit')
end)

NetherMachine.condition.register("aura.crits", function(target, spell)
    return smartQueryTracker(target, spell, 'crits')
end)

NetherMachine.condition.register("aura.avg", function(target, spell)
    return smartQueryTracker(target, spell, 'avg')
end)

NetherMachine.condition.register("aura.last", function(target, spell)
    return smartQueryTracker(target, spell, 'last')
end)

NetherMachine.condition.register("aura.low", function(target, spell)
    return smartQueryTracker(target, spell, 'low')
end)

NetherMachine.condition.register("aura.high", function(target, spell)
    return smartQueryTracker(target, spell, 'high')
end)

NetherMachine.condition.register("aura.total", function(target, spell)
    return smartQueryTracker(target, spell, 'total')
end)

NetherMachine.condition.register("aura.stacks", function(target, spell)
    return smartQueryTracker(target, spell, 'stacks')
end)

NetherMachine.condition.register("aura.time", function(target, spell)
    return smartQueryTracker(target, spell, 'time')
end)

NetherMachine.condition.register("aura.uptime", function(target, spell)
    return smartQueryTracker(target, spell, 'time') - GetTime()
end)

NetherMachine.condition.register("stance", function(target, spell)
    return GetShapeshiftForm()
end)

NetherMachine.condition.register("form", function(target, spell)
    return GetShapeshiftForm()
end)

NetherMachine.condition.register("seal", function(target, spell)
    return GetShapeshiftForm()
end)

NetherMachine.condition.register("focus", function(target, spell)
    return UnitPower(target, SPELL_POWER_FOCUS)
end)

NetherMachine.condition.register("focus.deficit", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_FOCUS) - UnitPower(target, SPELL_POWER_FOCUS)
end)

NetherMachine.condition.register("holypower", function(target, spell)
    return UnitPower(target, SPELL_POWER_HOLY_POWER)
end)

NetherMachine.condition.register("holypower.deficit", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_HOLY_POWER) - UnitPower(target, SPELL_POWER_HOLY_POWER)
end)

NetherMachine.condition.register("shadoworbs", function(target, spell)
    return UnitPower(target, SPELL_POWER_SHADOW_ORBS)
end)

NetherMachine.condition.register("shadoworbs.deficit", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_SHADOW_ORBS) - UnitPower(target, SPELL_POWER_SHADOW_ORBS)
end)

NetherMachine.condition.register("energy", function(target, spell)
    return UnitPower(target, SPELL_POWER_ENERGY)
end)

NetherMachine.condition.register("energy.deficit", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_ENERGY) - UnitPower(target, SPELL_POWER_ENERGY)
end)

NetherMachine.condition.register("energy.regen", function(target, spell)
  local inactiveRegen, activeRegen = GetPowerRegen()
  if UnitAffectingCombat(target) then
    return activeRegen
  end
  return inactiveRegen
end)

NetherMachine.condition.register("timetomax", function(target, spell)
    local max = UnitPowerMax(target)
    local curr = UnitPower(target)
    local regen = select(2, GetPowerRegen(target))
    return (max - curr) * (1.0 / regen)
end)

NetherMachine.condition.register("tomax", function(target, spell)
    return NetherMachine.condition["timetomax"](toggle)
end)

NetherMachine.condition.register("stealable", function(target, spellCast, spell)
  for i=1, 40 do
    local name, _, _, _, _, _, _, _, isStealable, _ = UnitAura(target, i)
    if isStealable then
      if spell then
        if spell == GetSpellName(spell) then
          return true
        else
          return false
        end
      end
      return true
    end
  end
  return false
  end)

NetherMachine.condition.register("rage", function(target, spell)
    return UnitPower(target, SPELL_POWER_RAGE)
end)

NetherMachine.condition.register("rage.deficit", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_RAGE) - UnitPower(target, SPELL_POWER_RAGE)
end)

NetherMachine.condition.register("chi", function(target, spell)
    return UnitPower(target, SPELL_POWER_CHI)
end)

NetherMachine.condition.register("chi.deficit", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_CHI) - UnitPower(target, SPELL_POWER_CHI)
end)

NetherMachine.condition.register("chidiff", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_CHI) - UnitPower(target, SPELL_POWER_CHI)
end)

NetherMachine.condition.register("demonicfury", function(target, spell)
    return UnitPower(target, SPELL_POWER_DEMONIC_FURY)
end)

NetherMachine.condition.register("embers", function(target, spell)
    return UnitPower(target, SPELL_POWER_BURNING_EMBERS, true)
end)

NetherMachine.condition.register("soulshards", function(target, spell)
    return UnitPower(target, SPELL_POWER_SOUL_SHARDS)
end)

NetherMachine.condition.register("behind", function(target, spell)
  if FireHack then
    return not UnitInfront(target, 'player')
  end
  return NetherMachine.module.player.behind
end)

NetherMachine.condition.register("infront", function(target, spell)
  if FireHack then
    return UnitInfront(target, 'player')
  end
  return NetherMachine.module.player.infront
end)

NetherMachine.condition.register("disarmable", function(target, spell)
    return NetherMachine.module.disarm.check(target)
end)

NetherMachine.condition.register("combopoints", function()
    return GetComboPoints('player', 'target')
end)

NetherMachine.condition.register("alive", function(target, spell)
    if UnitExists(target) and UnitHealth(target) > 0 then
    return true
    end
    return false
end)

NetherMachine.condition.register('dead', function (target)
    return UnitIsDeadOrGhost(target)
end)

NetherMachine.condition.register('swimming', function ()
    return IsSwimming()
end)

NetherMachine.condition.register("target", function(target, spell)
    return ( UnitGUID(target .. "target") == UnitGUID(spell) )
end)

NetherMachine.condition.register("targeting", function(unit, otherunit)
  return ( UnitGUID(unit .. "target") == UnitGUID(otherunit) )
end)

NetherMachine.condition.register("istheplayer", function(target)
    return UnitIsUnit("player", target)
end)

NetherMachine.condition.register("player", function (target)
    return UnitIsPlayer(target)
end)

NetherMachine.condition.register("exists", function(target)
    return (UnitExists(target))
end)

NetherMachine.condition.register("modifier.looting", function()
    return GetNumLootItems() > 0
end)

NetherMachine.condition.register("modifier.shift", function()
    return IsShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.control", function()
    return IsControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.alt", function()
    return IsAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.lshift", function()
    return IsLeftShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.lcontrol", function()
    return IsLeftControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.lalt", function()
    return IsLeftAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.rshift", function()
    return IsRightShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.rcontrol", function()
    return IsRightControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.ralt", function()
    return IsRightAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

NetherMachine.condition.register("modifier.player", function()
    return UnitIsPlayer("target")
end)

NetherMachine.condition.register("classification", function (target, spell)
    if not spell then return false end
    if UnitExists(target) and (string.find(UnitName(target), "Dummy")) then return false end
    local classification = UnitClassification(target)
    if stringFind(spell, '[%s,]+') then
      for classificationExpected in stringGmatch(spell, '%a+') do
          if classification == stringLower(classificationExpected) then
            return true
          end
      end
      return false
    else
      return UnitClassification(target) == stringLower(spell)
    end
end)

NetherMachine.condition.register("boss", function (target, spell)
    local classification = UnitClassification(target)
    if spell == "true" and (classification == "rareelite" or classification == "rare") then
      return true
    end
    if classification == "worldboss" or LibBoss.BossIDs[tonumber(UnitID(target))] then
      return true
    end
    if UnitExists(target) and string.find(UnitName(target), "Dummy") then
      return true
    end
    return false
end)

NetherMachine.condition.register("id", function(target, id)
    local expectedID = tonumber(id)
    if expectedID and UnitID(target) == expectedID then
        return true
    end
    return false
end)

NetherMachine.condition.register("toggle", function(toggle)
    return NetherMachine.condition["modifier.toggle"](toggle)
end)

NetherMachine.condition.register("modifier.toggle", function(toggle)
    return NetherMachine.config.read('button_states', toggle, false)
end)

NetherMachine.condition.register("modifier.taunt", function()
    if NetherMachine.condition["modifier.toggle"]('taunt') then
        if UnitThreatSituation("player", "target") then
            local status = UnitThreatSituation("player", "target")
            return (status < 3)
        end
        return false
    end
    return false
end)

NetherMachine.condition.register("threat", function(unit)
    if UnitThreatSituation("player", unit) then
    local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", unit)
    return scaledPercent
    end
    return 0
end)

NetherMachine.condition.register("highthreat", function(unit, otherunit)
  if not otherunit then
    otherunit = unit
    unit = "player"
  end
  if UnitExists(unit) and UnitExists(otherunit) then
    local status = UnitThreatSituation(unit, otherunit)
    if status and status >= 1 then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("agro", function(unit, otherunit)
  if not otherunit then
    otherunit = unit
    unit = "player"
  end
  if UnitExists(unit) and UnitExists(otherunit) then
    local status = UnitThreatSituation(unit, otherunit)
    if status and status >= 2 then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("aggro", function(unit, otherunit)
  return NetherMachine.condition["agro"](unit, otherunit)
end)

NetherMachine.condition.register("balance.sun", function(target)
    local direction = GetEclipseDirection()
    if direction and direction == "sun" then return true end
    return false
end)

NetherMachine.condition.register("balance.moon", function(target)
    local direction = GetEclipseDirection()
    if direction and direction == "moon" then return true end
    return false
end)

NetherMachine.condition.register("balance.eclipse", function(target)
    local eclipse = UnitPower("player", 8)
    return eclipse
end)

NetherMachine.condition.register("balance.lunarmax", function(target)
    local eclipsepersecond = 10
    local group = GetActiveSpecGroup()
    local _, _, _, selected, active = GetTalentInfo(7, 1, group)
    if selected and active then
      eclipsepersecond = 20
    end
    if UnitBuff("player", "Lunar Peak") then
      if selected and active then
        return 20
      else
        return 40
      end
    end
    local direction = GetEclipseDirection()
    local eclipse = UnitPower("player", 8)
    if not direction or not eclipse or direction == "none" then return 99 end
    if direction == "moon" and eclipse < 0 then
      return (100 - abs(eclipse)) / eclipsepersecond
    elseif direction == "moon" and eclipse >= 0 then
      return (100 + eclipse) / eclipsepersecond
    elseif direction == "sun" and eclipse < 0 then
      return (300 + abs(eclipse)) / eclipsepersecond
    elseif direction == "sun" and eclipse >= 0 then
      return (200 + (100 - eclipse)) / eclipsepersecond
    end
    return 99
end)

NetherMachine.condition.register("balance.solarmax", function(target)
    local eclipsepersecond = 10
    local group = GetActiveSpecGroup()
    local _, _, _, selected, active = GetTalentInfo(7, 1, group)
    if selected and active then
      eclipsepersecond = 20
    end
    if UnitBuff("player", "Solar Peak") then
      if selected and active then
        return 20
      else
        return 40
      end
    end
    local direction = GetEclipseDirection()
    local eclipse = UnitPower("player", 8)
    if not direction or not eclipse or direction == "none" then return 99 end
    if direction == "sun" and eclipse < 0 then
      return (100 + abs(eclipse)) / eclipsepersecond
    elseif direction == "sun" and eclipse >= 0 then
      return (100 - eclipse) / eclipsepersecond
    elseif direction == "moon" and eclipse < 0 then
      return (200 + (100 - abs(eclipse))) / eclipsepersecond
    elseif direction == "moon" and eclipse >= 0 then
      return (300 + eclipse) / eclipsepersecond
    end
    return 99
end)

NetherMachine.condition.register("eclipse.change", function(target, spell)
  local timetozero = 40.0 / 4
  local eclipse = UnitPower("player", 8)
  local direction = GetEclipseDirection()
  local _, _, _, selected, active = GetTalentInfo(7, 1, GetActiveSpecGroup())
  if selected and active then
    timetozero = timetozero / 2
  end
  if (direction == "sun" and eclipse < 0) or (direction == "moon" and eclipse >= 0) then
    timetozero = timetozero * ( abs(eclipse) / 100 )
  elseif (direction == "sun" and eclipse >= 0) or (direction == "moon" and eclipse < 0) then
    timetozero = timetozero * ( (200 - abs(eclipse)) / 100 )
  end
  return timetozero
end)

NetherMachine.condition.register("balance.neweclipsechange", function(target, spell)
    local timetozero = 40.0 / 4
    local eclipse = UnitPower("player", 8)
    local direction = GetEclipseDirection()
    local _, _, _, selected, active = GetTalentInfo(7, 1, GetActiveSpecGroup())
    if selected and active then
      timetozero = timetozero / 2
    end

    if (direction == "sun" and eclipse < 0)
     or (direction == "moon" and eclipse >= 0) then
      timetozero = timetozero * ( (100 - abs(eclipse)) / 100 )
    elseif (direction == "sun" and eclipse >= 0)
     or (direction == "moon" and eclipse < 0) then
      timetozero = timetozero * ( (200 - abs(eclipse)) / 100 )
    end

    if spell then
      local name, _, _, castingTime = GetSpellInfo(spell)
      if name and castingTime then
        castingTime = castingTime / 1000
        if (spell == "Wrath" and eclipse > 0 and timetozero > castingTime)
         or (spell == "Starfire" and eclipse < 0 and timetozero > castingTime) then
           return true
        end
      end
    end
    return timetozero > 2
end)

NetherMachine.condition.register("balance.eclipsechange", function(target, spell)
  local eclipsepersecond = 10
  local group = GetActiveSpecGroup()
  local _, _, _, selected, active = GetTalentInfo(7, 1, group)
  if selected and active then
    eclipsepersecond = 20
  end
  local timetozero = 20
  local eclipse = UnitPower("player", 8)
  if UnitBuff("player", "Solar Peak") or UnitBuff("player", "Lunar Peak") then
    if selected and active then
      timetozero = 10
    end
  else
    local direction = GetEclipseDirection()
    if not direction or not eclipse or direction == "none" then return false end
    if direction == "sun" and eclipse < 0 then
      timetozero = abs(eclipse) / eclipsepersecond
      elseif direction == "sun" and eclipse >= 0 then
        timetozero = (200 - eclipse) / eclipsepersecond
        elseif direction == "moon" and eclipse < 0 then
          timetozero = (200 - abs(eclipse)) / eclipsepersecond
          elseif direction == "moon" and eclipse >= 0 then
            timetozero = eclipse / eclipsepersecond
          end
        end
        if spell then
          local casttime = 1.5
          local name, _, _, castingTime = GetSpellInfo(spell)
          if name and castingTime then
            casttime = castingTime / 1000
          end
          if spell == "Wrath" then
            if (eclipse > 0 and timetozero > casttime) then
              return true
            end
            elseif spell == "Starfire" then
              if (eclipse < 0 and timetozero > casttime) then
                return true
              end
            end
          end
          return false
end)

NetherMachine.condition.register("solar", function(target, spell)
  return GetEclipseDirection() == 'sun'
end)

NetherMachine.condition.register("lunar", function(target, spell)
  return GetEclipseDirection() == 'moon'
end)

NetherMachine.condition.register("eclipse", function(target, spell)
  return UnitPower(target, SPELL_POWER_ECLIPSE)
end)

NetherMachine.condition.register("eclipseRaw", function(target, spell)
  return UnitPower(target, SPELL_POWER_ECLIPSE)
end)

NetherMachine.condition.register("moving", function(target)
    local speed, _ = GetUnitSpeed(target)
    return speed ~= 0
end)

local movingCache = { }
NetherMachine.condition.register("lastmoved", function(target)
    if target == 'player' then
        if not NetherMachine.module.player.moving then
            return GetTime() - NetherMachine.module.player.movingTime
        end
        return false
    else
        if UnitExists(target) then
            local guid = UnitGUID(target)
            if movingCache[guid] then
                local moving = (GetUnitSpeed(target) > 0)
                if not movingCache[guid].moving and moving then
                    movingCache[guid].last = GetTime()
                    movingCache[guid].moving = true
                    return false
                elseif moving then
                    return false
                elseif not moving then
                    movingCache[guid].moving = false
                    return GetTime() - movingCache[guid].last
                end
            else
                movingCache[guid] = { }
                movingCache[guid].last = GetTime()
                movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                return false
            end
        end
        return false
    end
end)

NetherMachine.condition.register("movingfor", function(target)
    if target == 'player' then
        if NetherMachine.module.player.moving then
            return GetTime() - NetherMachine.module.player.movingTime
        end
        return false
    else
        if UnitExists(target) then
            local guid = UnitGUID(target)
            if movingCache[guid] then
                local moving = (GetUnitSpeed(target) > 0)
                if not movingCache[guid].moving then
                    movingCache[guid].last = GetTime()
                    movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                    return false
                elseif moving then
                    return GetTime() - movingCache[guid].last
                elseif not moving then
                    movingCache[guid].moving = false
                    return false
                end
            else
                movingCache[guid] = { }
                movingCache[guid].last = GetTime()
                movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                return false
            end
        end
        return false
    end
end)

-- DK Power

NetherMachine.condition.register("runicpower", function(target, spell)
    return UnitPower(target, SPELL_POWER_RUNIC_POWER)
end)

NetherMachine.condition.register("runicpower.deficit", function(target, spell)
  return UnitPowerMax(target, SPELL_POWER_RUNIC_POWER) - UnitPower(target, SPELL_POWER_RUNIC_POWER)
end)

NetherMachine.condition.register("runes", function(target)
  local runeCount = 0
  for i=1, 6 do
      local _, _, runeReady = GetRuneCooldown(i)
      if runeReady then
          runeCount = runeCount+1
      end
  end
  -- print(runeCount)
  return runeCount
end)

NetherMachine.condition.register("runes.frac", function(target, rune)
  -- 12 b, 34 f, 56 u
  runes_t[1], runes_t[2], runes_t[3], runes_t[4], runes_c[1], runes_c[2], runes_c[3], runes_c[4] = 0,0,0,0,0,0,0,0
  for i=1, 6 do
    local r, d, c = GetRuneCooldown(i)
    local frac = 1-(r/d)
    local t = GetRuneType(i)
    runes_t[t] = runes_t[t] + 1
    if c then
      runes_c[t] = runes_c[t] + frac
    end
  end
  if rune == 'frost' then
    return runes_c[3]
  elseif rune == 'blood' then
    return runes_c[1]
  elseif rune == 'unholy' then
    return runes_c[2]
  elseif rune == 'death' then
    return runes_c[4]
  elseif rune == 'Frost' then
    return runes_c[3] + runes_c[4]
  elseif rune == 'Blood' then
    return runes_c[1] + runes_c[4]
  elseif rune == 'Unholy' then
    return runes_c[2] + runes_c[4]
  end
  return 0
end)

NetherMachine.condition.register("runes.cooldown_min", function(target, rune)
  -- 12 b, 34 f, 56 u
  runes_t[1], runes_t[2], runes_t[3], runes_t[4], runes_c[1], runes_c[2], runes_c[3], runes_c[4] = 0,0,0,0,0,0,0,0
  for i=1, 6 do
    local r, d, c = GetRuneCooldown(i)
    local cd = (r + d) - GetTime()
    local t = GetRuneType(i)
    runes_t[t] = runes_t[t] + 1
    if cd > 0 and runes_c[t] > cd then
      runes_c[t] = cd
    else
      runes_c[t] = 8675309
    end
  end
  if rune == 'frost' then
    return runes_c[3]
  elseif rune == 'blood' then
    return runes_c[1]
  elseif rune == 'unholy' then
    return runes_c[2]
  elseif rune == 'death' then
    return runes_c[4]
  elseif rune == 'Frost' then
    if runes_c[3] < runes_c[4] then
      return runes_c[3]
    end
    return runes_c[4]
  elseif rune == 'Blood' then
    if runes_c[1] < runes_c[4] then
      return runes_c[1]
    end
    return runes_c[4]
  elseif rune == 'Unholy' then
    if runes_c[2] < runes_c[4] then
      return runes_c[2]
    end
    return runes_c[4]
  end
  return 0
end)

NetherMachine.condition.register("runes.cooldown_max", function(target, rune)
  -- 12 b, 34 f, 56 u
  runes_t[1], runes_t[2], runes_t[3], runes_t[4], runes_c[1], runes_c[2], runes_c[3], runes_c[4] = 0,0,0,0,0,0,0,0
  for i=1, 6 do
    local r, d, c = GetRuneCooldown(i)
    local cd = (r + d) - GetTime()
    local t = GetRuneType(i)
    runes_t[t] = runes_t[t] + 1
    if cd > 0 and runes_c[t] < cd then
      runes_c[t] = cd
    end
  end
  if rune == 'frost' then
    return runes_c[3]
  elseif rune == 'blood' then
    return runes_c[1]
  elseif rune == 'unholy' then
    return runes_c[2]
  elseif rune == 'death' then
    return runes_c[4]
  elseif rune == 'Frost' then
    if runes_c[3] > runes_c[4] then
      return runes_c[3]
    end
    return runes_c[4]
  elseif rune == 'Blood' then
    if runes_c[1] > runes_c[4] then
      return runes_c[1]
    end
    return runes_c[4]
  elseif rune == 'Unholy' then
    if runes_c[2] > runes_c[4] then
      return runes_c[2]
    end
    return runes_c[4]
  end
  return 0
end)


NetherMachine.condition.register("runes.depleted", function(target, spell)
  local regeneration_threshold = 1
  for i=1,6,2 do
    local start, duration, runeReady = GetRuneCooldown(i)
    local start2, duration2, runeReady2 = GetRuneCooldown(i+1)
    if not runeReady and not runeReady2 and duration > 0 and duration2 > 0 and start > 0 and start2 > 0 then
      if (start-GetTime()+duration)>=regeneration_threshold and (start2-GetTime()+duration2)>=regeneration_threshold then
        return true
      end
    end
  end
  return false
end)

NetherMachine.condition.register("runes.depleted.count", function(target, rune)
  local depletedCount = 0
  for i=1,6 do
    local _, _, runeReady = GetRuneCooldown(i)
    if not runeReady then
      depletedCount = depletedCount + 1
    end
  end
  return depletedCount
end)

NetherMachine.condition.register("runes", function(target, rune)
    return NetherMachine.condition["runes.count"](target, rune)
end)

NetherMachine.condition.register("health", function(target)
    if UnitExists(target) then
        return math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100)
    end
    return 0
end)

NetherMachine.condition.register("health.actual", function(target)
    return UnitHealth(target)
end)

NetherMachine.condition.register("health.max", function(target)
    return UnitHealthMax(target)
end)

NetherMachine.condition.register("health.deficit", function(target)
  if UnitExists(target) then
    return math.floor(((UnitHealthMax(target) - UnitHealth(target)) / UnitHealthMax(target)) * 100)
  end
  return 0
end)

NetherMachine.condition.register("health.deficit.actual", function(target)
  return UnitHealthMax(target) - UnitHealth(target)
end)

NetherMachine.condition.register("mana", function(target, spell)
    if UnitExists(target) then
        return math.floor((UnitMana(target) / UnitManaMax(target)) * 100)
    end
    return 0
end)

NetherMachine.condition.register("mana.deficit", function(target)
  if UnitExists(target) then
    return math.floor(((UnitManaMax(target) - UnitMana(target)) / UnitManaMax(target)) * 100)
  end
  return 0
end)

NetherMachine.condition.register("mana.deficit.actual", function(target)
  return UnitManaMax(target) - UnitMana(target)
end)

NetherMachine.condition.register("mana.regen", function(target, spell)
  local inactiveRegen, activeRegen = GetPowerRegen()
  if UnitAffectingCombat(target) then
    return activeRegen
  end
  return inactiveRegen
end)

NetherMachine.condition.register("raid.health", function()
    return NetherMachine.raid.raidPercent()
end)

NetherMachine.condition.register("modifier.multitarget", function()
    return NetherMachine.condition["modifier.toggle"]('multitarget')
end)

NetherMachine.condition.register("modifier.cooldowns", function()
    return NetherMachine.condition["modifier.toggle"]('cooldowns')
end)

NetherMachine.condition.register("modifier.cooldown", function()
    return NetherMachine.condition["modifier.toggle"]('cooldowns')
end)

NetherMachine.condition.register("modifier.interrupts", function()
    if NetherMachine.condition["modifier.toggle"]('interrupt') then
      local stop = NetherMachine.condition["casting"]('target')
      if stop then
        StopCast()
        return true
      end
    end
    return false
end)

NetherMachine.condition.register("modifier.interrupt", function()
    if NetherMachine.condition["modifier.toggle"]('interrupt') then
      return NetherMachine.condition["casting"]('target')
    end
    return false
end)

NetherMachine.condition.register("interrupts", function(unit)
  if NetherMachine.condition["modifier.toggle"]('interrupt') then
    if NetherMachine.condition["casting"](unit) then
      StopCast()
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("interrupt", function(unit)
  if NetherMachine.condition["modifier.toggle"]('interrupt') then
    return NetherMachine.condition["casting"](unit)
  end
  return false
end)

NetherMachine.condition.register('interruptsAt', function (unit, spell)
  if NetherMachine.condition['modifier.toggle']('interrupt') and NetherMachine.condition["casting"](unit) then
    if UnitName('player') == UnitName(unit) then return false end
    local stopAt = tonumber(spell) or 50
    local secondsLeft, castLength = NetherMachine.condition['casting.delta'](unit)
    if secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt then
      StopCast()
      return true
    end
  end
  return false
end)

NetherMachine.condition.register('interruptAt', function (unit, spell)
  if NetherMachine.condition['modifier.toggle']('interrupt') and NetherMachine.condition["casting"](unit) then
    if UnitName('player') == UnitName(unit) then return false end
    local stopAt = tonumber(spell) or 50
    local secondsLeft, castLength = NetherMachine.condition['casting.delta'](unit)
    if secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("modifier.last", function(target, spell)
  return NetherMachine.parser.lastCast == GetSpellName(spell)
end)

NetherMachine.condition.register("lastcast", function(unit, spell)
  return NetherMachine.parser.lastCast == GetSpellName(spell)
end)

NetherMachine.condition.register("lastcast.time", function()
  return (NetherMachine.parser.lastCastTime - GetTime())
end)

NetherMachine.condition.register("enchant.mainhand", function()
    return (select(1, GetWeaponEnchantInfo()) == 1)
end)

NetherMachine.condition.register("enchant.offhand", function()
    return (select(5, GetWeaponEnchantInfo()) == 1)
end)

NetherMachine.condition.register("totem", function(target, totem)
    for index = 1, 4 do
        local _, totemName, startTime, duration = GetTotemInfo(index)
        if totemName == GetSpellName(totem) then
            return true
        end
    end
    return false
end)

NetherMachine.condition.register("totem.duration", function(target, totem)
    for index = 1, 4 do
      local _, totemName, startTime, duration = GetTotemInfo(index)
      if totemName == GetSpellName(totem) then
          return floor(startTime + duration - GetTime())
      end
    end
    return 0
end)

NetherMachine.condition.register("mushrooms", function ()
    local count = 0
    for slot = 1, 3 do
    if GetTotemInfo(slot) then
        count = count + 1 end
    end
    return count
end)

local function checkChanneling(target)
  local name, _, _, _, startTime, endTime, _, notInterruptible = UnitChannelInfo(target)
  if name then return name, startTime, endTime, notInterruptible end
  return false
end

local function checkCasting(target)
    local name, startTime, endTime, notInterruptible = checkChanneling(target)
    if name then return name, startTime, endTime, notInterruptible end

    local name, _, _, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(target)
    if name then return name, startTime, endTime, notInterruptible end

    return false
end

NetherMachine.condition.register("busy", function(target, spell)
  local name, startTime, endTime, notInterruptible = checkCasting(target)
  if name or GetNumLootItems() > 0 then
    return true
  end
  return false
end)

NetherMachine.condition.register('casting.time', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if not endTime or not startTime then return false end
    if name then return (endTime - startTime) / 1000 end
    return false
end)

NetherMachine.condition.register('casting.delta', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if not endTime or not startTime then return false end
    if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000  - GetTime()
    return secondsLeft, castLength
    end
    return false
end)

NetherMachine.condition.register('casting.percent', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000  - GetTime()
    return ((secondsLeft/castLength)*100)
    end
    return false
end)

NetherMachine.condition.register('channeling', function (target, spell)
    return checkChanneling(target)
end)

NetherMachine.condition.register("casting", function(target, spell)
    local castName,_,_,_,_,endTime,_,_,notInterruptibleCast = UnitCastingInfo(target)
    local channelName,_,_,_,_,endTime,_,notInterruptibleChannel = UnitChannelInfo(target)
    spell = GetSpellName(spell)
    if (castName == spell or channelName == spell) and not not spell then
      return true
    elseif notInterruptibleCast == false or notInterruptibleChannel == false then
      return true
    end
    return false
end)

NetherMachine.condition.register("spell.cooldown", function(target, spell)
    local start, duration, enabled = GetSpellCooldown(spell)
    if not start then return false end
    if start ~= 0 then
      return (start + duration - GetTime())
    end
    return 0
end)

NetherMachine.condition.register("spell.recharge", function(target, spell)
    local currentCharges, maxCharges, cooldownStart, cooldownDuration = GetSpellCharges(spell)
    if cooldownStart and cooldownDuration then
      return (cooldownStart + cooldownDuration - GetTime())
    end
    return 9999
end)

NetherMachine.condition.register("spell.usable", function(target, spell)
    return (IsUsableSpell(spell) ~= nil)
end)

NetherMachine.condition.register("spell.exists", function(target, spell)
    if GetSpellBookIndex(spell) then
    return true
    end
    return false
end)

NetherMachine.condition.register("spell.casted", function(target, spell)
    return NetherMachine.module.player.casted(GetSpellName(spell))
end)

NetherMachine.condition.register("spell.charges", function(target, spell)
    local currentCharges, maxCharges, cooldownStart, cooldownDuration = GetSpellCharges(spell)
    if currentCharges then
      return currentCharges
    end
    return 0
end)

NetherMachine.condition.register("spell.cd", function(target, spell)
    return NetherMachine.condition["spell.cooldown"](target, spell)
end)

NetherMachine.condition.register("spell.range", function(target, spell)
    local spellIndex, spellBook = GetSpellBookIndex(spell)
    if not spellIndex then return false end
    return spellIndex and IsSpellInRange(spellIndex, spellBook, target)
end)

NetherMachine.condition.register("spell.castingtime", function(target, spell)
    local name, _, _, castingTime = GetSpellInfo(spell)
    if name and castingTime then
      return castingTime / 1000
    end
    return 9999
end)

NetherMachine.condition.register("spell.castregen", function(unit, spell)
  local regen = 0.0
  local name, _, _, castTime = GetSpellInfo(spell)
  local inactiveRegen, activeRegen = GetPowerRegen()
  if name and (inactiveRegen or activeRegen) then
    if UnitAffectingCombat(unit) then
      regen = activeRegen
    else
      regen = inactiveRegen
    end
    if castTime == 0 then
      castTime = 1500
    end
    return (castTime/1000) * regen
  end
  return 0
end)

NetherMachine.condition.register("talent", function(args)
    local row, col = strsplit(",", args, 2)
    return hasTalent(tonumber(row), tonumber(col))
end)

NetherMachine.condition.register("friend", function(target, spell)
    return ( not UnitCanAttack("player", target) )
end)

NetherMachine.condition.register("enemy", function(target, spell)
    return ( UnitCanAttack("player", target) )
end)

NetherMachine.condition.register("glyph", function(target, spell)
    local spellId = tonumber(spell)
    local glyphName, glyphId

    for i = 1, 6 do
    glyphId = select(4, GetGlyphSocketInfo(i))
    if glyphId then
        if spellId then
        if select(4, GetGlyphSocketInfo(i)) == spellId then
            return true
        end
        else
        glyphName = GetSpellName(glyphId)
        if glyphName:find(spell) then
            return true
        end
        end
    end
    end
    return false
end)

NetherMachine.condition.register("range", function(target)
    return NetherMachine.condition["distance"](target)
end)

NetherMachine.condition.register("range.actual", function(target)
  return NetherMachine.condition["distance.actual"](target)
end)

NetherMachine.condition.register("distance", function(target, otherTarget)
    if Distance then
      if otherTarget == "pet" then
        return math.floor(Distance("pet", target))
      end
        return math.floor(Distance("player", target))
    else -- fall back to libRangeCheck
        local minRange, maxRange = rangeCheck:GetRange(target)
        return maxRange or minRange
    end
end)

NetherMachine.condition.register("distance.actual", function(target, otherTarget)
  if DistanceActual then
    if otherTarget and otherTarget == "pet" then
      return math.floor(DistanceActual("pet", target))
    else
      return math.floor(DistanceActual("player", target))
    end
  else -- fall back to libRangeCheck
    local minRange, maxRange = rangeCheck:GetRange(target)
    return maxRange or minRange
  end
end)

NetherMachine.condition.register("level", function(target, range)
    return UnitLevel(target)
end)

NetherMachine.condition.register("combat", function(target, range)
    return UnitAffectingCombat(target)
end)

NetherMachine.condition.register("time", function(target, range)
    if NetherMachine.module.player.combatTime then
        return GetTime() - NetherMachine.module.player.combatTime
    end
    return false
end)

NetherMachine.condition.register("ooctime", function(target, range)
    if NetherMachine.module.player.oocombatTime then
        return GetTime() - NetherMachine.module.player.oocombatTime
    end
    return false
end)

local deathTrack = { }
NetherMachine.condition.register("deathin", function(target, range)
    local guid = UnitGUID(target)
    if deathTrack[target] and deathTrack[target].guid == guid then
        local start = deathTrack[target].time
        local currentHP = UnitHealth(target)
        local maxHP = deathTrack[target].start
        local diff = maxHP - currentHP
        local dura = GetTime() - start
        local hpps = diff / dura
        local death = currentHP / hpps
        if death == math.huge then
            return 8675309
        elseif death < 0 then
            return 0
        else
            return death
        end
    elseif deathTrack[target] then
        table.empty(deathTrack[target])
    else
        deathTrack[target] = { }
    end
    deathTrack[target].guid = guid
    deathTrack[target].time = GetTime()
    deathTrack[target].start = UnitHealth(target)
    return 8675309
end)

NetherMachine.condition.register("ttd", function(target, range)
    return NetherMachine.condition["deathin"](target)
end)

NetherMachine.condition.register("role", function(target, role)
    role = role:upper()

    local damageAliases = { "DAMAGE", "DPS", "DEEPS" }

    local targetRole = UnitGroupRolesAssigned(target)
    if targetRole == role then return true
    elseif role:find("HEAL") and targetRole == "HEALER" then return true
    else
    for i = 1, #damageAliases do
        if role == damageAliases[i] then return true end
    end
    end

    return false
end)

NetherMachine.condition.register("name", function (target, expectedName)
  return UnitExists(target) and UnitName(target):lower():find(expectedName:lower()) ~= nil
end)

NetherMachine.condition.register("modifier.party", function()
    return IsInGroup()
end)

NetherMachine.condition.register("modifier.raid", function()
    return IsInRaid()
end)

NetherMachine.condition.register("party", function(target)
    return UnitInParty(target)
end)

NetherMachine.condition.register("raid", function(target)
    return UnitInRaid(target)
end)

NetherMachine.condition.register("modifier.members", function()
    return (GetNumGroupMembers() or 0)
end)

NetherMachine.condition.register("creatureType", function (target, expectedType)
    return UnitCreatureType(target) == expectedType
end)

NetherMachine.condition.register("class", function (target, expectedClass)
    local class, _, classID = UnitClass(target)

    if tonumber(expectedClass) then
    return tonumber(expectedClass) == classID
    else
    return expectedClass == class
    end
end)

NetherMachine.condition.register("falling", function()
    return IsFalling()
end)

NetherMachine.condition.register("timeout", function(args)
    local name, time = strsplit(",", args, 2)
    if tonumber(time) then
        if NetherMachine.timeout.check(name) then
            return false
        end
        NetherMachine.timeout.set(name, tonumber(time))
        return true
    end
    return false
end)

local heroismBuffs = { 32182, 90355, 80353, 2825, 146555, 178207 }

NetherMachine.condition.register("hashero", function(unit, spell)
    for i = 1, #heroismBuffs do
      if UnitBuff('player', GetSpellName(heroismBuffs[i])) then
          return true
      end
    end
    return false
end)

NetherMachine.condition.register("hashero.remains", function(unit, spell)
    for i = 1, #heroismBuffs do
      local buff,_,expires,caster = UnitBuff('player', GetSpellName(heroismBuffs[i]))
      if buff and expires then
        return (expires - GetTime())
      end
    end
    return 0
end)

NetherMachine.condition.register("buffs.stats", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(1) ~= nil)
end)

NetherMachine.condition.register("buffs.stamina", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(2) ~= nil)
end)

NetherMachine.condition.register("buffs.attackpower", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(3) ~= nil)
end)

NetherMachine.condition.register("buffs.attackspeed", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(4) ~= nil)
end)

NetherMachine.condition.register("buffs.haste", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(4) ~= nil)
end)

NetherMachine.condition.register("buffs.spellpower", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(5) ~= nil)
end)

NetherMachine.condition.register("buffs.crit", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

NetherMachine.condition.register("buffs.critical", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

NetherMachine.condition.register("buffs.criticalstrike", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

NetherMachine.condition.register("buffs.mastery", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(7) ~= nil)
end)

NetherMachine.condition.register("buffs.multistrike", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(8) ~= nil)
end)

NetherMachine.condition.register("buffs.multi", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(8) ~= nil)
end)

NetherMachine.condition.register("buffs.vers", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(9) ~= nil)
end)

NetherMachine.condition.register("buffs.versatility", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(9) ~= nil)
end)

NetherMachine.condition.register("charmed", function(unit, _)
    return (UnitIsCharmed(unit) == true)
end)

NetherMachine.condition.register("defense", function(unit, _)
  return GetCombatRating(CR_DEFENSE_SKILL)
end)

NetherMachine.condition.register("defense.percent", function(unit, _)
  return GetCombatRatingBonus(CR_DEFENSE_SKILL)
end)

NetherMachine.condition.register("dodge", function(unit, _)
  return GetCombatRating(CR_DODGE)
end)

NetherMachine.condition.register("dodge.percent", function(unit, _)
  return GetCombatRatingBonus(CR_DODGE)
end)

NetherMachine.condition.register("parry", function(unit, _)
  return GetCombatRating(CR_PARRY)
end)

NetherMachine.condition.register("parry.percent", function(unit, _)
  return GetCombatRatingBonus(CR_PARRY)
end)

NetherMachine.condition.register("block", function(unit, _)
  return GetCombatRating(CR_BLOCK)
end)

NetherMachine.condition.register("block.percent", function(unit, _)
  return GetCombatRatingBonus(CR_BLOCK)
end)

NetherMachine.condition.register("hit", function(unit, _)
  --CR_HIT_MELEE = 6;
  --CR_HIT_RANGED = 7;
  --CR_HIT_SPELL = 8;
  return GetCombatRating(CR_HIT_RANGED)
end)

NetherMachine.condition.register("hit.percent", function(unit, _)
  return GetCombatRatingBonus(CR_HIT_RANGED)
end)

NetherMachine.condition.register("crit", function(unit, _)
  return GetCombatRating(CR_CRIT_RANGED)
end)

NetherMachine.condition.register("crit.percent", function(unit, _)
  return GetCombatRatingBonus(CR_CRIT_RANGED)
end)

NetherMachine.condition.register("multistrike", function(unit, _)
  return GetCombatRating(CR_MULTISTRIKE)
end)

NetherMachine.condition.register("multistrike.percent", function(unit, _)
  return GetCombatRatingBonus(CR_MULTISTRIKE)
end)

NetherMachine.condition.register("readiness", function(unit, _)
  return GetCombatRating(CR_READINESS)
end)

NetherMachine.condition.register("readiness.percent", function(unit, _)
  return GetCombatRatingBonus(CR_READINESS)
end)

NetherMachine.condition.register("speed", function(unit, _)
  return GetCombatRating(CR_SPEED)
end)

NetherMachine.condition.register("speed.percent", function(unit, _)
  return GetCombatRatingBonus(CR_SPEED)
end)

NetherMachine.condition.register("lifesteal", function(unit, _)
  return GetCombatRating(CR_LIFESTEAL)
end)

NetherMachine.condition.register("lifesteal.percent", function(unit, _)
  return GetCombatRatingBonus(CR_LIFESTEAL)
end)

NetherMachine.condition.register("haste", function(unit, _)
  return GetCombatRating(CR_HASTE_RANGED)
end)

NetherMachine.condition.register("haste.percent", function(unit, _)
  return GetCombatRatingBonus(CR_HASTE_RANGED)
end)

NetherMachine.condition.register("mastery", function(unit, _)
  return GetCombatRating(CR_MASTERY)
end)

NetherMachine.condition.register("mastery.percent", function(unit, _)
  return GetCombatRatingBonus(CR_MASTERY)
end)

NetherMachine.condition.register("versatility", function(unit, _)
  return GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
end)

NetherMachine.condition.register("versatility.percent", function(unit, _)
  return GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
end)

NetherMachine.condition.register("vengeance", function(unit, spell)
    local vengeance = select(15, _G['UnitBuff']("player", GetSpellName(132365)))
    if not vengeance then
        return 0
    end
    if spell then
        return vengeance
    end
    return vengeance / UnitHealthMax("player") * 100
end)

NetherMachine.condition.register("area.enemies", function(unit, distance)
    if UnitsAroundUnit then
        local total = UnitsAroundUnit(unit, tonumber(distance))
        return total
    end
    return 0
end)

NetherMachine.condition.register("area.friendly", function(unit, distance)
  if FriendlyUnitsAroundUnit then
    local total = FriendlyUnitsAroundUnit(unit, tonumber(distance))
    return total
  end
  return 0
end)

NetherMachine.condition.register("area.needheals", function(unit, distance)
  if NeedHealsAroundUnit then
    local total = NeedHealsAroundUnit(unit, tonumber(distance), tonumber(health))
    return total
  end
  return 0
end)


NetherMachine.condition.register("crowdcontrolled", function(unit, _)
  local CC = { 118,28272,28271,61305,61721,61780,9484,3355,19386,339,6770,6358,20066,51514,115078,115268 }
  for i = 1, #CC do
    if UnitDebuff(unit, GetSpellInfo(CC[i])) then return true end
  end
  return false
end)

NetherMachine.condition.register("ilevel", function(unit, _)
    return math.floor(select(1,GetAverageItemLevel()))
end)

NetherMachine.condition.register("firehack", function(unit, _)
    return FireHack or false
end)

NetherMachine.condition.register("offspring", function(unit, _)
    return type(opos) == 'function' or false
end)

NetherMachine.condition.register("ininstance", function(unit, type)
    local inInstance, instanceType = IsInInstance()
    if inInstance and not type then
      return true
    end
    if inInstance and type and string.lower(instanceType) == string.lower(type) then
      return true
    end
    return false
end)

NetherMachine.condition.register("spell.wontcap", function(unit, spell)
  local inactiveRegen, activeRegen = GetPowerRegen()
  local name, _, _, castTime = GetSpellInfo(spell)
  if name and inactiveRegen then
    local regen = inactiveRegen
    if UnitAffectingCombat(unit) then regen = activeRegen end
    if castTime == 0 then castTime = 1500 end
    local power_type, _ = UnitPowerType(unit)
    return (castTime/1000) * regen <= (UnitPowerMax(unit, power_type) - UnitPower(unit, power_type))
  end
  return false
end)

NetherMachine.condition.register("indoors", function(unit)
    return IsIndoors() -- Returns true if you are indoors. Returns false for indoor areas where you can still mount.
end)

NetherMachine.condition.register("outdoors", function(unit)
    return IsOutdoors() -- Returns true if you are outdoors. Returns true for indoor areas where you can still mount.
end)

NetherMachine.condition.register("flying", function(unit)
    return IsFlying() -- Returns true if you are flying.
end)

NetherMachine.condition.register("mounted", function(unit)
    return IsMounted()
end)

NetherMachine.condition.register("isfriendlynpc", function(unit)
    if unit and UnitExists(unit) then
      if string.find(UnitGUID(unit), "Creature") and UnitReaction("player", unit) == 5 then
        return true
      end
    end
    return false
end)

NetherMachine.condition.register("spellsteal", function(unit)
    for i=1,40 do
      local name, _, _, _, _, _, _, _, isStealable = UnitAura(unit, i);
      if isStealable then
        print("Casting Spellsteal on "..unit..". Found "..name.."!")
        return true
      end
    end
    return false
end)

NetherMachine.condition.register("twohand", function(unit)
  return IsEquippedItemType("Two-Hand")
end)

NetherMachine.condition.register("onehand", function(unit)
  return IsEquippedItemType("One-Hand")
end)

NetherMachine.condition.register("engage", function (unit, searchRange)
  if not searchRange then local searchRange = 30 end
  if UnitIsDeadOrGhost("player")
  or ( UnitExists("target") and UnitIsFriend("player", "target") )
  or ((UnitHealth("player") / UnitHealthMax("player")) * 100) < 70
  or GetUnitSpeed("player") > 0 then
    return false
  end
  local localizedClass, englishClass, classIndex = UnitClass("player")
  if englishClass == 1 or englishClass == 2 or englishClass == 4 or englishClass == 6 or englishClass == 10 then
    local melee = true
  end
  if englishClass == "HUNTER" and UnitBuff("player", "Sniper Training") ~= nil then
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
    if melee and closestUnitDistance >= 5 then
      MoveTo(ObjectPosition(closestUnitObject))
    end
  end
  return false
end)

NetherMachine.condition.register("bleedratio", function (unit, spell)
  if not WA_event_frame then
    WA_event_frame = CreateFrame('Frame')
    WA_event_frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
    WA_event_frame:RegisterEvent('PLAYER_REGEN_ENABLED')
    WA_event_frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    WA_event_frame:RegisterEvent('PLAYER_ALIVE')
    WA_event_frame:SetScript('OnEvent', function (event, _, param, _, source, ...)
      Rip_sDamage = Rip_sDamage or {}
      Rake_sDamage = Rake_sDamage or {}
      Thrash_sDamage = Thrash_sDamage or {}

      if event == "COMBAT_LOG_EVENT_UNFILTERED" and source == UnitGUID("player") then
        local _, _, _, destination, _, _, _, spell = ...

        -- snapshot on spellcast
        if spell == 1079 and param == "SPELL_CAST_SUCCESS" then
          WA_calcStats_feral()
          Rip_sDamage_cast = WA_stats_RipTick
        elseif spell == 1822 and (param == "SPELL_CAST_SUCCESS" or param == "SPELL_DAMAGE" or param == "SPELL_MISSED") then
          WA_calcStats_feral()
          Rake_sDamage_cast = WA_stats_RakeTick
        elseif spell == 106830 and param == "SPELL_CAST_SUCCESS" then
          WA_calcStats_feral()
          Thrash_sDamage_cast = WA_stats_ThrashTick
        end

        -- but only record the snapshot if it successfully applied
        if spell == 1079 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
          Rip_sDamage[destination] = Rip_sDamage_cast
        elseif spell == 155722 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
          Rake_sDamage[destination] = Rake_sDamage_cast
        elseif spell == 106830 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
          Thrash_sDamage[destination] = Thrash_sDamage_cast
        end

      -- clean up out of combat
      elseif (not UnitAffectingCombat("player")) and (not IsEncounterInProgress()) then
        Rip_sDamage = {}
        Rake_sDamage = {}
        Thrash_sDamage = {}
      end
    end)
  end

  if not spell then return 0 end

  local DamageMult = 1 --select(7, UnitDamage("player"))

  local CP = GetComboPoints("player", unit)
  if CP == 0 then CP = 5 end

  if UnitBuff("player", "Tiger's Fury") then
    DamageMult = DamageMult * 1.15
  end

  if UnitBuff("player", "Savage Roar") then
    DamageMult = DamageMult * 1.4
  end

  WA_stats_BTactive = WA_stats_BTactive or  0
  if UnitBuff("player", "Bloodtalons") then
    WA_stats_BTactive = GetTime()
    DamageMult = DamageMult * 1.3
  elseif GetTime() - WA_stats_BTactive < .2 then
    DamageMult = DamageMult * 1.3
  end

  local RakeMult = 1
  WA_stats_prowlactive = WA_stats_prowlactive or  0
  if UnitBuff("player", "Incarnation: King of the Jungle") then
    RakeMult = 2
  elseif UnitBuff("player", "Prowl") or UnitBuff("player", "Shadowmeld") then
    WA_stats_prowlactive = GetTime()
    RakeMult = 2
  elseif GetTime() - WA_stats_prowlactive < .2 then
    RakeMult = 2
  end

  WA_stats_RipTick = CP*DamageMult
  WA_stats_RipTick5 = 5*DamageMult
  WA_stats_RakeTick = DamageMult*RakeMult
  WA_stats_ThrashTick = DamageMult

  local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spell)

  -- Rake
  if spellId == 155722 and UnitAura(unit, 155722) then
    Rake_sDamage = Rake_sDamage or {}
    if Rake_sDamage[UnitGUID(unit)] then
      local RatioPercent = floor(WA_stats_RakeTick/Rake_sDamage[UnitGUID(unit)]*100 + .5)
      return RatioPercent
    end
  end

  -- Rip
  if name == "Rip" and UnitAura(unit, "Rip") then
    Rip_sDamage = Rip_sDamage or {}
    if Rip_sDamage[UnitGUID(unit)] then
      local RatioPercent = floor(WA_stats_RipTick5/Rip_sDamage[UnitGUID(unit)]*100 + .5)
      return RatioPercent
    end
  end

  -- Thrash
  if spellId == 106830 and UnitAura(unit, 106830) then
    Thrash_sDamage = Thrash_sDamage or {}
    if Thrash_sDamage[UnitGUID(unit)] then
      local RatioPercent = floor(WA_stats_ThrashTick/Thrash_sDamage[UnitGUID(unit)]*100 + .5)
      return RatioPercent
    end
  end

  return 200
end)


NetherMachine.condition.register("spell.ingroup", function (unit, spell)
  local group = "party"
  local maxplayers = 4
  if IsInRaid() then
    group = "raid"
    maxplayers = 40
  end
  for i=1,maxplayers do
    local name, _, _, count, _, duration, expirationTime, unitCaster, _, _, spellId = UnitAura(group..i, GetSpellName(spell), nil, "PLAYER|HELPFUL")
    if name then return true end  --and UnitIsUnit(unitCaster, "player")
  end
  return false
end)

NetherMachine.condition.register("minimapzone", function (unit, spell)
  if GetMinimapZoneText() == spell then
    return true
  end
  return false
end)

NetherMachine.condition.register("unitname", function (target, unit)
  if UnitExists(target) and UnitName(target) == unit then
    return true
  end
  return false
end)

-- TODO: Currently Hunter Only
NetherMachine.condition.register("petinmelee", function(target)
  return (IsSpellInRange(GetSpellInfo(2649), target) == 1)
end)

NetherMachine.condition.register("modifier.enemies", function()
  local count = 0
  for _ in pairs(NetherMachine.module.combatTracker.enemy) do count = count + 1 end
  return count
end)




NetherMachine.condition.register("isnpc", function(unit)
  if unit and UnitExists(unit) then
    if string.find(UnitGUID(unit), "Creature") and UnitReaction("player", unit) == 5 then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("isplayer", function(unit)
  if unit and UnitExists(unit) then
    if string.find(UnitGUID(unit), "Player") then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("iscreature", function(unit)
  if unit and UnitExists(unit) then
    if string.find(UnitGUID(unit), "Creature") then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("ispet", function(unit)
  if unit and UnitExists(unit) then
    if string.find(UnitGUID(unit), "Pet") then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("isobject", function(unit)
  if unit and UnitExists(unit) then
    if string.find(UnitGUID(unit), "GameObject") then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("isvehicle", function(unit)
  if unit and UnitExists(unit) then
    if string.find(UnitGUID(unit), "Vehicle") then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("isvignette", function(unit)
  if unit and UnitExists(unit) then
    if string.find(UnitGUID(unit), "Vignette") then
      return true
    end
  end
  return false
end)

NetherMachine.condition.register("spell.damage", function(unit, spell)
  local desc = GetSpellDescription(spell)
  local damage
  if desc then
    damage, _ = string.match(desc, "dealing (.-) ")
    if not damage then
      damage, _ = string.match(desc, "deals (.-) ")
    end
    if not damage then
      damage, _ = string.match(desc, "causes (.-) ")
    end
    if not damage then
      damage, _ = string.match(desc, "for (.-) ")
    end
    if damage then
      damage, _ = string.gsub(damage, ",", "")
      return tonumber(damage)
    end
  end
  return 0
end)

NetherMachine.condition.register("spell.healing", function(unit, spell)
  local desc = GetSpellDescription(spell)
  local healing
  if desc then
    healing, _ = string.match(desc, "for (.-) ")
    if healing then
      healing, _ = string.gsub(healing, ",", "")
      return tonumber(healing)
    end
  end
  return 0
end)

-- Check if a unit is crowd controlled
NetherMachine.condition.register("cc", function(target, spell)
  if miLib.CC(target) then return true else return false end
end)

-- Universal Haste proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
NetherMachine.condition.register("haste.procs", function(target, spell)
  if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
    if miLib.hasteProcTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return NetherMachine.HasteProcs end
  else
    return NetherMachine.HasteProcs
  end
end)

-- Universal Mastery proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
NetherMachine.condition.register("mastery.procs", function(target, spell)
  if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
    if miLib.mastProcTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return NetherMachine.MasteryProcs end
  else
    return NetherMachine.MasteryProcs
  end
end)

-- Universal Crit proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
NetherMachine.condition.register("crit.procs", function(target, spell)
  if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
    if miLib.critTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return NetherMachine.CriticalStrikeProcs end
  else
    return NetherMachine.CriticalStrikeProcs
  end
end)

-- Universal intellect proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
NetherMachine.condition.register("int.procs", function(target, spell)
  if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
    if miLib.intProcTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return NetherMachine.IntellectProcs end
  else
    return NetherMachine.IntellectProcs
  end
end)

-- Pet Special Ability check
NetherMachine.condition.register("pet.spell", function(target, spell)
  return IsSpellKnown(spell, true)
end)

-- Register a new movement command with Fox/KJC
NetherMachine.condition.register("moving", function(target)
  local speed, _ = GetUnitSpeed(target)
  if UnitBuff("player", 172106) or UnitBuff("player", 137587) then return false end
  return speed ~= 0
end)

-- Small condition for spell traveling (Note: Only works for Haunt yet!)
NetherMachine.condition.register("spell.traveling", function(target, spell)
  if miLib.hauntCasted then return false else return true end
end)

-- Countdown to when a Soulshard is regenerating
NetherMachine.condition.register("shardregen", function(target, spell)
  if miLib.shardTimer > 0 and miLib.shardTimer <= 20 then
    return GetTime() - miLib.shardTimer
  end
  return 0
end)

-- Check last cast Corruption against our current target
NetherMachine.condition.register("corruption", function(target)
  if not miLib.lastCorrupt or miLib.lastCorrupt ~= UnitGUID("target") then return true end
  return false
end)

NetherMachine.condition.register("judgement", function(target, spell)
  if lastTarget[20271] and lastTarget[20271] == UnitGUID(target) then return false end
  return true
end)

NetherMachine.condition.register("trinket.any", function(unit, spell)
  return NetherMachine.StrengthProcs + NetherMachine.AgilityProcs
  + NetherMachine.IntellectProcs + NetherMachine.SpiritProcs
  + NetherMachine.StaminaProcs + NetherMachine.AttackPowerProcs
  + NetherMachine.SpellPowerProcs + NetherMachine.VersatilityProcs
  + NetherMachine.HasteProcs + NetherMachine.CriticalStrikeProcs
  + NetherMachine.MultistrikeProcs + NetherMachine.MasteryProcs
end)

NetherMachine.condition.register("trinket.strength", function(unit, spell)
  return NetherMachine.StrengthProcs
end)

NetherMachine.condition.register("trinket.agility", function(unit, spell)
  return NetherMachine.AgilityProcs
end)

NetherMachine.condition.register("trinket.intellect", function(unit, spell)
  return NetherMachine.IntellectProcs
end)

NetherMachine.condition.register("trinket.spirit", function(unit, spell)
  return NetherMachine.SpiritProcs
end)

NetherMachine.condition.register("trinket.stamina", function(unit, spell)
  return NetherMachine.StaminaProcs
end)

NetherMachine.condition.register("trinket.attackpower", function(unit, spell)
  return NetherMachine.AttackPowerProcs
end)

NetherMachine.condition.register("trinket.spellpower", function(unit, spell)
  return NetherMachine.SpellPowerProcs
end)

NetherMachine.condition.register("trinket.versatility", function(unit, spell)
  return NetherMachine.VersatilityProcs
end)

NetherMachine.condition.register("trinket.haste", function(unit, spell)
  return NetherMachine.HasteProcs
end)

NetherMachine.condition.register("trinket.crit", function(unit, spell)
  return NetherMachine.CriticalStrikeProcs
end)

NetherMachine.condition.register("trinket.multistrike", function(unit, spell)
  return NetherMachine.MultistrikeProcs
end)

NetherMachine.condition.register("trinket.mastery", function(unit, spell)
  return NetherMachine.MasteryProcs
end)

--NetherMachine.condition.register("gcd", function(unit, spell)
--	if (1.5/((GetHaste("player")/100)+1)) > 1 then
--		return math.floor(1.5/((GetHaste("player")/100)+1))
--	end
--	return 1
--end)
