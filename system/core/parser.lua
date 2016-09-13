local GetSpellBookIndex = GetSpellBookIndex
local GetSpellInfo = GetSpellInfo
local BOOKTYPE_PET = BOOKTYPE_PET

NetherMachine.parser = {
  lastCast = '',
  lastCastTime = 0.000,
  items = {
    head     = "HeadSlot",
    helm     = "HeadSlot",
    neck     = "NeckSlot",
    shoulder = "ShoulderSlot",
    shirt    = "ShirtSlot",
    chest    = "ChestSlot",
    belt     = "WaistSlot",
    waist    = "WaistSlot",
    legs     = "LegsSlot",
    pants    = "LegsSlot",
    feet     = "FeetSlot",
    boots    = "FeetSlot",
    wrist    = "WristSlot",
    bracers  = "WristSlot",
    gloves   = "HandsSlot",
    hands    = "HandsSlot",
    finger1  = "Finger0Slot",
    finger2  = "Finger1Slot",
    trinket1 = "Trinket0Slot",
    trinket2 = "Trinket1Slot",
    back     = "BackSlot",
    cloak    = "BackSlot",
    mainhand = "MainHandSlot",
    offhand  = "SecondaryHandSlot",
    weapon   = "MainHandSlot",
    weapon1  = "MainHandSlot",
    weapon2  = "SecondaryHandSlot",
    ranged   = "RangedSlot"
  }
}

NetherMachine.turbo = {
  modifier = NetherMachine.config.read('turbo_modifier', 1.3)
}

NetherMachine.parser.can_cast =  function(spell, unit, stopCasting)
  local turbo = NetherMachine.config.read('pe_turbo', false)


  -- works by canceling a cast just before it goes off. aka, clipping
  if turbo then
    -- Turbo Mode Engage
    local castEnds = select(6, UnitCastingInfo("player"))
    local channelEnds = select(6, UnitChannelInfo("player"))
    if castEnds or channelEnds then
      local endTime = castEnds or channelEnds
      local timeNow = GetTime()
      local canCancel = ((endTime / 1000) - timeNow) * 1000
      if canCancel < (NetherMachine.lag*NetherMachine.turbo.modifier) then
        StopCast()
      end
    end
  end

  -- resolve units
  if spell == nil then return false end
  if unit == nil then
    unit = UnitExists("target") and "target" or "player"
  end
  if unit == "ground" then unit = nil end
  if unit then
    if string.sub(unit, -7) == ".ground" then unit = nil end
  end

  if unit and unit ~= "player" and UnitExists(unit) and UnitIsVisible(unit) and LineOfSight then
    local unitID = UnitID(unit)

    if unitID ~= 76585 and unitID ~= 76267 and unitID ~= 77891 and unitID ~= 77893 and unitID ~= 77182 then
      if not LineOfSight('player', unit) then
        return false
      end
    end
  end

  -- check for spell
  local spellIndex, spellBook = GetSpellBookIndex(spell)
  if not spellIndex then
    return false
  end
  local skillType, spellId
  if spellBook ~= nil then
    skillType, spellId = GetSpellBookItemInfo(spellIndex, spellBook)
    if skillType == 'FUTURESPELL' or not spellId then
      return false
    end
  else
    spellId = spellIndex
  end

  -- is spell usable
  local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange
  local isUsable, notEnoughMana
  if spellBook ~= nil then
    isUsable, notEnoughMana = IsUsableSpell(spellIndex, spellBook)
    name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellIndex, spellBook)
  else
    isUsable, notEnoughMana = IsUsableSpell(spellId)
    name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellId)
  end


  -- Savage Roar is broken as fuuuuuck
  --if spellId ~= 127538 and spellId ~= 33876 then
  --  local isSpellKnown = IsSpellKnown(spellId)
  --  local isPlayerSpell = IsPlayerSpell(spellId)
  --  if not isSpellKnown and not isPlayerSpell then
  --    if not IsSpellKnown(spellId) then return false end
  --  end
  --end

  if not isUsable then return false end
  if notEnoughMana then return false end
  if unit then
    if not UnitExists(unit) then return false end
    if not UnitIsVisible(unit) then return false end
    if UnitIsDeadOrGhost(unit) then return false end
    if spellBook ~= BOOKTYPE_PET then
      if spellBook ~= nil then
        if SpellHasRange(spellIndex, spellBook) == 1 then
          if IsSpellInRange(spellIndex, spellBook, unit) == 0 then return false end
          if IsHarmfulSpell(spellIndex, spellBook) and not UnitCanAttack("player", unit) then return false end
        end
      else
        if SpellHasRange(name) == 1 then
          if IsSpellInRange(name, unit) == 0 then return false end
          if IsHarmfulSpell(name) and not UnitCanAttack("player", unit) then return false end
        end
      end
    end
  end
  if UnitBuff("player", GetSpellInfo(80169)) then return false end -- Eat
  if UnitBuff("player", GetSpellInfo(87959)) then return false end -- Drink
  if UnitBuff("player", GetSpellInfo(11392)) then return false end -- Invis
  if UnitBuff("player", GetSpellInfo(3680)) then return false end  -- L. Invis

  if not NetherMachine.faceroll.rolling then
    if spellBook ~= nil and select(2, GetSpellCooldown(spellIndex, spellBook)) > 0 then return false end
    if spellBook == nil and select(2, GetSpellCooldown(spellId)) > 0 then return false end
  else
    if spellBook ~= nil and select(2, GetSpellCooldown(spellIndex, spellBook)) > 1.5 then return false end
    if spellBook == nil and select(2, GetSpellCooldown(spellId)) > 1.5 then return false end
  end


  if spellBook == BOOKTYPE_PET then
    if not UnitExists('pet') then return false end
    if not unit then return true end
    if NetherMachine.module.pet.casting then return false end
    if UnitCastingInfo('pet') ~= nil then return false end
    if UnitChannelInfo('pet') ~= nil then return false end
    return true
  end

  if stopCasting then
    StopCast()
    return true
  end

  -- handle Surging Mists manually :(
  if spellId == 116694 or spellId == 124682 or spellId == 123273 then return true end
  if NetherMachine.module.player.casting == true and turbo == false then return false end
  if UnitChannelInfo("player") ~= nil then return false end
  return true
end

NetherMachine.parser.can_cast_queue =  function(spell)
  local isUsable, notEnoughMana = IsUsableSpell(spell)
  if not isUsable then return false end
  if notEnoughMana then return false end
  if select(2, GetSpellCooldown(spell)) ~= 0 then return false end
  return true
end


NetherMachine.parser.nested = function(evaluationTable, event, target)
  local eval
  for _, evaluation in pairs(evaluationTable) do
    local evaluationType, eval = type(evaluation), true
    if evaluationType == "function" then
      eval = evaluation()
    elseif evaluationType == "table" then
      eval = NetherMachine.parser.nested(evaluation, event, target) -- for the lulz
    elseif evaluationType == "string" then
      if string.sub(evaluation, 1, 1) == '@' then
        eval = NetherMachine.library.parse(event, evaluation, target)
      else
        eval = NetherMachine.dsl.parse(evaluation, event)
      end
    elseif evaluationType == "nil" then
      eval = false
    elseif evaluationType == "boolean" then
      eval = evaluation
    end
    if not eval then return false end
  end
  return true
end

NetherMachine.parser.table = function(spellTable, fallBackTarget)

  for _, arguments in pairs(spellTable) do

    NetherMachine.dsl.parsedTarget = nil

    local eventType = type(arguments[1])
    local event = arguments[1]
    local evaluationType = type(arguments[2])
    local evaluation = arguments[2]
    local target = arguments[3] or fallBackTarget
    local slotId = 0
    local itemName = ''
    local itemTexture = ''
    local itemId = 0
    local stopCasting = false

    if eventType == "string" then
      if string.sub(event, 1, 1) == '!' then
        stopCasting = true
        event = string.sub(event, 2)
      elseif string.sub(event, 1, 1) == '#' then
        eventType = "item"
        event = string.sub(event, 2)
      elseif string.sub(event, 1, 1) == '/' then
        eventType = "macro"
      elseif string.sub(event, 1, 1) == '@' then
        event = NetherMachine.library.parse(false, event, target)
      end
    end

    -- is our eval a lib call ?
    if evaluationType == "string" then
      if string.sub(evaluation, 1, 1) == '@' then
        evaluationType = "library"
      end
    end

    -- healing?
    if target == "lowest" then
      target = NetherMachine.raid.lowestHP(event)
      if target == false then return end
    elseif target == "tank" then
      target = NetherMachine.raid.tank(event)
      if target == false then return end
    end

    if eventType == "string" or eventType == "number" then
      if evaluationType == "string"  then
        evaluation = NetherMachine.dsl.parse(evaluation, event)
      elseif evaluationType == "table" then
        evaluation = NetherMachine.parser.nested(evaluation, event, target)
      elseif evaluationType == "function" then
        evaluation = evaluation()
      elseif evaluationType == "library" then
        evaluation = NetherMachine.library.parse(event, evaluation, target)
      elseif evaluationType == "nil" then
        evaluation = true
      end
    elseif eventType == "table" or eventType == "macro" or eventType == "item" then
      if evaluationType == "string"  then
        evaluation = NetherMachine.dsl.parse(evaluation, '')
      elseif evaluationType == "table" then
        evaluation = NetherMachine.parser.nested(evaluation, '', target)
      elseif evaluationType == "function" then
        evaluation = evaluation()
      elseif evaluationType == "library" then
        evaluation = NetherMachine.library.parse(event, evaluation, target)
      elseif evaluationType == "nil" then
        evaluation = true
      end
    end

    if NetherMachine.dsl.parsedTarget ~= nil then
      target = NetherMachine.dsl.parsedTarget
    end

    if target == nil then
      target = "target"
    end

    if eventType == "item" then
      local slot = event
      if NetherMachine.parser.items[slot] then
        slotId, itemTexture = GetInventorySlotInfo(NetherMachine.parser.items[slot])
        if slotId then
          local itemStart, itemDuration, itemEnable = GetInventoryItemCooldown("player", slotId)
          itemId = GetInventoryItemID("player", slotId)
          local isUsable, notEnoughMana = IsUsableItem(itemId)
          if not isUsable then
            evaluation = false
          end
          if itemStart > 0 then
            evaluation = false
          elseif not GetItemSpell(itemId) then
            evaluation = false
          end
        end
      else
        eventType = "bagItem"
        local item = slot
        if not tonumber(item) then
          item = GetItemID(item)
        end
        itemId = item
        if itemId then
          itemName, _, _, _, _, _, _, _, _, itemTexture, _ = GetItemInfo(itemId)
          local itemStart, itemDuration, itemEnable = GetItemCooldown(itemId)
          local isUsable, notEnoughMana = IsUsableItem(itemId)
          if not isUsable then
            evaluation = false
          end
          if itemStart > 0 then
            evaluation = false
          elseif GetItemCount(itemId) == 0 then
            evaluation = false
          end
        end
      end
    end

    if evaluation then
      if eventType == "table" then
        local tableNestSpell, tableNestTarget = NetherMachine.parser.table(event, target)
        if tableNestSpell ~= false then return tableNestSpell, tableNestTarget end
      elseif eventType == "macro" then
        Macro(event)
        return false
      elseif eventType == "item" then
        if stopCasting then StopCast() end
        UseInventoryItem(slotId)
        NetherMachine.actionLog.insert('Use Inventory Item', itemName, itemTexture, target)
        return false
      elseif eventType == "bagItem" then
        if stopCasting then StopCast() end
        if not NetherMachine.timeout.check(itemName) then
          NetherMachine.timeout.set(itemName, 0.15, function()
            UseItem(itemName, target)
          end)
        end
        NetherMachine.actionLog.insert('Use Bag Item', itemName, itemTexture, target)
        return false
      elseif event == "pause" then
        return false
      else
        if NetherMachine.parser.can_cast(event, target, stopCasting) then
          return event, target
        end
      end
    end

  end

  return false
end
