local GetSpellInfo = GetSpellInfo
local L = NetherMachine.locale.get

NetherMachine.current_spell = false

NetherMachine.cycleTime = NetherMachine.cycleTime or 50


-- faceroll

NetherMachine.faceroll.faceroll = function()
  if NetherMachine.faceroll.rolling then
    local spell, target
    if NetherMachine.module.player.combat and NetherMachine.rotation.activeRotation then
      spell, target = NetherMachine.parser.table(NetherMachine.rotation.activeRotation)
    elseif not NetherMachine.module.player.combat and NetherMachine.rotation.activeOOCRotation then
      spell, target = NetherMachine.parser.table(NetherMachine.rotation.activeOOCRotation, 'player')
    end

    if spell then
      local spellIndex, spellBook = GetSpellBookIndex(spell)
      local spellID, name, icon
      if spellBook ~= nil then
        _, spellID = GetSpellBookItemInfo(spellIndex, spellBook)
        name, _, icon = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon = GetSpellInfo(spellID)
      end
      if UnitExists(target) or target == 'ground' or string.sub(target, -7) == ".ground" then
        NetherMachine.buttons.icon('MasterToggle', icon)
        NetherMachine.current_spell = name
      else
        NetherMachine.current_spell = false
      end
    else
      NetherMachine.current_spell = false
    end
  end
end

NetherMachine.timer.register("faceroll", function()
  NetherMachine.faceroll.faceroll()
end, 50)

NetherMachine.cycle = function(skip_verify)

  local turbo = NetherMachine.config.read('pe_turbo', false)
  local cycle =
    ( UnitBuff('player', GetSpellName(165803)) or UnitBuff('player', GetSpellName(164222)) or IsMounted() == false )
    and UnitHasVehicleUI("player") == false
    and NetherMachine.module.player.combat
    and NetherMachine.config.read('button_states', 'MasterToggle', false)
    and NetherMachine.module.player.specID
    and (NetherMachine.protected.unlocked or IsMacClient())

  if cycle or skip_verify and NetherMachine.rotation.activeRotation then

    local spell, target = false

    local queue = NetherMachine.module.queue.spellQueue
    if queue ~= nil and NetherMachine.parser.can_cast(queue) then
      spell = queue
      target = 'target'
      NetherMachine.module.queue.spellQueue = nil
    elseif NetherMachine.parser.lastCast == queue then
      NetherMachine.module.queue.spellQueue = nil
    else
      spell, target = NetherMachine.parser.table(NetherMachine.rotation.activeRotation)
    end

    if not spell then
      spell, target = NetherMachine.parser.table(NetherMachine.rotation.activeRotation)
    end

    if spell then
      local spellIndex, spellBook = GetSpellBookIndex(spell)
      local spellID, name, icon
      if spellBook ~= nil then
        _, spellID = GetSpellBookItemInfo(spellIndex, spellBook)
        name, _, icon = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon = GetSpellInfo(spellID)
      end

      NetherMachine.buttons.icon('MasterToggle', icon)
      NetherMachine.current_spell = name
      NetherMachine.dataBroker.spell.text = NetherMachine.current_spell

      if target == "ground" then
        CastGround(name, 'target')
      elseif string.sub(target, -7) == ".ground" then
        target = string.sub(target, 0, -8)
        CastGround(name, target)
      else
        if spellID == 110309 then
          Macro("/target " .. target)
          target = "target"
        end

        -- some spells just won't cast normally, so we use macros
        if spellID == 139139 then -- Insanity for spriests
          Macro('/cast ' .. GetSpellName(15407))
        else
          Cast(name, target or "target")
        end

        if spellID == 110309 then
          Macro("/targetlasttarget")
        end
        if icon then
          NetherMachine.actionLog.insert('Spell Cast', name, icon, target or "target")
        end
      end

      if target ~= "ground" and UnitExists(target or 'target') then
        NetherMachine.debug.print(L('casting') .. " |T"..icon..":10:10|t ".. name .. L('on') .. " ( " .. UnitName(target or 'target') .. " )", 'spell_cast')
      else
        NetherMachine.debug.print(L('casting') .. " |T"..icon..":10:10|t ".. name .. L('on_the_ground'), 'spell_cast')
      end

    end

  end
end

NetherMachine.timer.register("rotation", function()
  NetherMachine.cycle()
end, NetherMachine.cycleTime)

NetherMachine.ooc_cycle = function()
  local cycle =
    ( UnitBuff('player', GetSpellName(165803)) or UnitBuff('player', GetSpellName(164222)) or IsMounted() == false )
    and UnitHasVehicleUI("player") == false
    and not NetherMachine.module.player.combat
    and NetherMachine.config.read('button_states', 'MasterToggle', false)
    and NetherMachine.module.player.specID ~= 0
    and NetherMachine.rotation.activeOOCRotation ~= false
    and (NetherMachine.protected.unlocked or IsMacClient())

  if cycle and NetherMachine.rotation.activeOOCRotation then
    local spell, target = ''
    spell, target = NetherMachine.parser.table(NetherMachine.rotation.activeOOCRotation, 'player')

    if target == nil then target = 'player' end
    if spell then
      local spellIndex, spellBook = GetSpellBookIndex(spell)
      local spellID, name, icon
      if spellBook ~= nil then
        _, spellID = GetSpellBookItemInfo(spellIndex, spellBook)
        name, _, icon = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon = GetSpellInfo(spellID)
      end

      NetherMachine.buttons.icon('MasterToggle', icon)
      NetherMachine.current_spell = name
      NetherMachine.dataBroker.spell.text = NetherMachine.current_spell

      if target == "ground" then
        CastGround(name, 'target')
      elseif string.sub(target, -7) == ".ground" then
        target = string.sub(target, 0, -8)
        CastGround(name, target)
      else
        if spellID == 110309 then
          Macro("/target " .. target)
          target = "target"
        end
        Cast(name, target)
        if spellID == 110309 then
          Macro("/targetlasttarget")
        end
        if icon then
          NetherMachine.actionLog.insert('Spell Cast', name, icon, target)
        end
      end

      if target ~= "ground" and UnitExists(target or 'target') then
        NetherMachine.debug.print(L('casting') .. " |T"..icon..":10:10|t ".. name .. L('on') .. " ( " .. UnitName(target or 'target') .. " )", 'spell_cast')
      else
        NetherMachine.debug.print(L('casting') .. " |T"..icon..":10:10|t ".. name .. L('on_the_ground'), 'spell_cast')
      end

      --soon... soon
      --Purrmetheus.api:UpdateIntent("default", NetherMachine.ooc_cycle, name, nil, target or "target")

    end
  end
end

NetherMachine.timer.register("oocrotation", function()
  NetherMachine.ooc_cycle()
end, NetherMachine.cycleTime)


NetherMachine.timer.register("detectUnlock", function()
  if NetherMachine.config.read('button_states', 'MasterToggle', false) then
    NetherMachine.protected.FireHack()
    NetherMachine.protected.OffSpring()
    NetherMachine.protected.WoWSX()
    NetherMachine.protected.Generic()
  end
end, 1000)
