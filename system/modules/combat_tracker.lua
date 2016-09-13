-- NetherMachine.module.register("combatTracker", {
--   units = { },
-- })
--
-- local playerGUID = UnitGUID('player')
--
-- local units = NetherMachine.module.combatTracker.units
-- local function isUnit(object, guid)
--     if bit.band(ObjectType(object), ObjectTypes.Unit, ObjectTypes.Object) and not UnitIsPlayer(guid) then
--
--     end
-- end
--
-- NetherMachine.timer.register("updateCTHealth", function()
--
--     table.empty(units)
--
--     local totalObjects = ObjectCount()
--     for i = 1, totalObjects do
--         local object = ObjectWithIndex(i)
--         local guid = UnitGUID(object)
--         if isUnit(object, guid) then
--             local combat = UnitAffectingCombat(guid)
--             print(guid, combat)
--             if combat then
--                 table.insert(units, guid)
--             end
--         end
--     end
--
-- end, 100)


-- Implementing native API combat tracker for # of enemies
local band = bit.band

local HostileEvents = {
  ['SWING_DAMAGE'] = true,
  ['SWING_MISSED'] = true,
  ['RANGE_DAMAGE'] = true,
  ['RANGE_MISSED'] = true,
  ['SPELL_DAMAGE'] = true,
  ['SPELL_PERIODIC_DAMAGE'] = true,
  ['SPELL_MISSED'] = true
}

NetherMachine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
  local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _ = ...
  if sourceName and destName and sourceName ~= '' and destName ~= '' then
    if HostileEvents[event] then
      if band(destFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 0 and band(sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
        NetherMachine.module.combatTracker.tagUnit(sourceGUID, sourceName, timeStamp)
      elseif band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 0 and band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
        NetherMachine.module.combatTracker.tagUnit(destGUID, destName, timeStamp)
      end
    end
  elseif (event == 'UNIT_DIED' or event == 'UNIT_DESTROYED' or event == 'UNIT_DISSIPATES') then
    NetherMachine.module.combatTracker.killUnit(destGUID)
  end
end)

NetherMachine.module.register("combatTracker", {
  current = 0,
  expire = 15,
  friendly = { },
  enemy = { },
  dead = { },
  named = { },
  blacklist = { },
  healthCache = { },
  healthCacheCount = { },
  units = { },
})

-- TODO: merge this with aquireRange so we accomplish both in the same function
NetherMachine.module.combatTracker.aquireHealth = function(guid, maxHealth, name)
  if maxHealth then health = UnitHealthMax else health = UnitHealth end
  local inGroup = GetNumGroupMembers()
  if inGroup then
    if IsInRaid("player") then
      for i=1,inGroup do
        if guid == UnitGUID("RAID".. i .. "TARGET") then
          return health("RAID".. i .. "TARGET")
        end
      end
    else
      for i=1,inGroup do
        if guid == UnitGUID("PARTY".. i .. "TARGET") then
          return health("PARTY".. i .. "TARGET")
        end
      end
      if guid == UnitGUID("PLAYERTARGET") then
        return health("PLAYERTARGET")
      end
    end
  else
    print(guid, UnitGUID("PLAYERTARGET"))
    if guid == UnitGUID("PLAYERTARGET") then
      return health("PLAYERTARGET")
    end
    if guid == UnitGUID("MOUSEOVER") then
      return health("MOUSEOVER")
    end
  end
  -- All health checks failed, do we have a cache of this units health ?
  if maxHealth then
    if NetherMachine.module.combatTracker.healthCache[name] ~= nil then
      return NetherMachine.module.combatTracker.healthCache[name]
    end
  end
  return false
end

NetherMachine.module.combatTracker.aquireRange = function(guid)
  range = NetherMachine.condition["distance"]
  local inGroup = GetNumGroupMembers()
  if inGroup then
    if IsInRaid("player") then
      for i=1,inGroup do
        if guid == UnitGUID("RAID".. i .. "TARGET") then
          return range("RAID".. i .. "TARGET")
        end
      end
    else
      for i=1,inGroup do
        if guid == UnitGUID("PARTY".. i .. "TARGET") then
          return range("PARTY".. i .. "TARGET")
        end
      end
      if guid == UnitGUID("PLAYERTARGET") then
        return range("PLAYERTARGET")
      end
    end
  else
    print(guid, UnitGUID("PLAYERTARGET"))
    if guid == UnitGUID("PLAYERTARGET") then
      return range("PLAYERTARGET")
    end
    if guid == UnitGUID("MOUSEOVER") then
      return range("MOUSEOVER")
    end
  end
  return false
end

NetherMachine.module.combatTracker.combatCheck = function()
  local inGroup = GetNumGroupMembers()
  local inCombat = false
  if inGroup then
    if IsInRaid("player") then
      for i = 1, inGroup do
        if UnitAffectingCombat("RAID".. i) then return true end
      end
    else
      for i = 1, inGroup do
        if UnitAffectingCombat("PARTY".. i) then return true end
      end
    end
    if UnitAffectingCombat("PLAYER") then return true end
  else
    if UnitAffectingCombat("PLAYER") then return true end
  end
  return false
end

-- TODO: rename this to just updateCT
NetherMachine.timer.register("updateCTHealth", function()
  if NetherMachine.module.combatTracker.combatCheck() then
    for guid,table in pairs(NetherMachine.module.combatTracker.enemy) do
      local health = NetherMachine.module.combatTracker.aquireHealth(guid)
      if health then
        -- attempt to aquire max health again
        if NetherMachine.module.combatTracker.enemy[guid]['maxHealth'] == false then
          local name = NetherMachine.module.combatTracker.enemy[guid]['name']
          NetherMachine.module.combatTracker.enemy[guid]['maxHealth'] = NetherMachine.module.combatTracker.aquireHealth(guid, true, name)
        end
        NetherMachine.module.combatTracker.enemy[guid].health = health
      end
      local range = NetherMachine.module.combatTracker.aquireRange(guid)
      if range then
        NetherMachine.module.combatTracker.enemy[guid].range = range
      end
    end
  else
    NetherMachine.module.combatTracker.cleanCT()
  end
end, 100)

NetherMachine.module.combatTracker.insert = function(guid, unitname, timestamp)
  if NetherMachine.module.combatTracker.enemy[guid] == nil then

    local maxHealth = NetherMachine.module.combatTracker.aquireHealth(guid, true, unitname)
    local health = NetherMachine.module.combatTracker.aquireHealth(guid)
    local range = NetherMachine.module.combatTracker.aquireRange(guid)

    NetherMachine.module.combatTracker.enemy[guid] = { }
    NetherMachine.module.combatTracker.enemy[guid]['maxHealth'] = maxHealth
    NetherMachine.module.combatTracker.enemy[guid]['health'] = health
    NetherMachine.module.combatTracker.enemy[guid]['range'] = range
    NetherMachine.module.combatTracker.enemy[guid]['name'] = unitname
    NetherMachine.module.combatTracker.enemy[guid]['time'] = false
    NetherMachine.module.combatTracker.enemy[guid]['guid'] = guid

    if maxHealth then
      -- we got a health value from aquire, store it for later usage
      if NetherMachine.module.combatTracker.healthCacheCount[unitname] then
        -- we've alreadt seen this type, average it
        local currentAverage = NetherMachine.module.combatTracker.healthCache[unitname]
        local currentCount = NetherMachine.module.combatTracker.healthCacheCount[unitname]
        local newAverage = (currentAverage + maxHealth) / 2
        NetherMachine.module.combatTracker.healthCache[unitname] = newAverage
        NetherMachine.module.combatTracker.healthCacheCount[unitname] = currentCount + 1
      else
        -- this is new to use, save it
        NetherMachine.module.combatTracker.healthCache[unitname] = maxHealth
        NetherMachine.module.combatTracker.healthCacheCount[unitname] = 1
      end
    end
  end
end

NetherMachine.module.combatTracker.cleanCT = function()
  -- clear tables but save the memory
  for k,_ in pairs(NetherMachine.module.combatTracker.enemy) do
    NetherMachine.module.combatTracker.enemy[k] = nil
  end
  for k,_ in pairs(NetherMachine.module.combatTracker.blacklist) do
    NetherMachine.module.combatTracker.blacklist[k] = nil
  end
end

NetherMachine.module.combatTracker.remove = function(guid)
  NetherMachine.module.combatTracker.enemy[guid] = nil
end

NetherMachine.module.combatTracker.tagUnit = function(guid, name)
  if not NetherMachine.module.combatTracker.blacklist[guid] then
    NetherMachine.module.combatTracker.insert(guid, name)
  end
end

NetherMachine.module.combatTracker.killUnit = function(guid)
  NetherMachine.module.combatTracker.remove(guid, name)
  NetherMachine.module.combatTracker.blacklist[guid] = true
end
