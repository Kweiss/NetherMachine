local L = NetherMachine.locale.get

local GetClassInfoByID = GetClassInfoByID

NetherMachine.rotation = {
  rotations = { },
  oocrotations =  { },
  custom = { },
  ooccustom = { },
  cdesc = { },
  buttons = { },
  specId = { },
  classSpecId = { },
  currentStringComp = "",
  activeRotation = false,
  activeOOCRotation = false,
}

NetherMachine.rotation.specId[62] = L('arcane_mage')
NetherMachine.rotation.specId[63] = L('fire_mage')
NetherMachine.rotation.specId[64] = L('frost_mage')
NetherMachine.rotation.specId[65] = L('holy_paladin')
NetherMachine.rotation.specId[66] = L('protection_paladin')
NetherMachine.rotation.specId[70] = L('retribution_paladin')
NetherMachine.rotation.specId[71] = L('arms_warrior')
NetherMachine.rotation.specId[72] = L('furry_warrior')
NetherMachine.rotation.specId[73] = L('protection_warrior')
NetherMachine.rotation.specId[102] = L('balance_druid')
NetherMachine.rotation.specId[103] = L('feral_combat_druid')
NetherMachine.rotation.specId[104] = L('guardian_druid')
NetherMachine.rotation.specId[105] = L('restoration_druid')
NetherMachine.rotation.specId[250] = L('blood_death_knight')
NetherMachine.rotation.specId[251] = L('frost_death_knight')
NetherMachine.rotation.specId[252] = L('unholy_death_knight')
NetherMachine.rotation.specId[253] = L('beast_mastery_hunter')
NetherMachine.rotation.specId[254] = L('marksmanship_hunter')
NetherMachine.rotation.specId[255] = L('survival_hunter')
NetherMachine.rotation.specId[256] = L('discipline_priest')
NetherMachine.rotation.specId[257] = L('holy_priest')
NetherMachine.rotation.specId[258] = L('shadow_priest')
NetherMachine.rotation.specId[259] = L('assassination_rogue')
NetherMachine.rotation.specId[260] = L('combat_rogue')
NetherMachine.rotation.specId[261] = L('subtlety_rogue')
NetherMachine.rotation.specId[262] = L('elemental_shaman')
NetherMachine.rotation.specId[263] = L('enhancement_shaman')
NetherMachine.rotation.specId[264] = L('restoration_shaman')
NetherMachine.rotation.specId[265] = L('affliction_warlock')
NetherMachine.rotation.specId[266] = L('demonology_warlock')
NetherMachine.rotation.specId[267] = L('destruction_warlock')
NetherMachine.rotation.specId[268] = L('brewmaster_monk')
NetherMachine.rotation.specId[269] = L('windwalker_monk')
NetherMachine.rotation.specId[270] = L('mistweaver_monk')

NetherMachine.rotation.classSpecId[62] = 8
NetherMachine.rotation.classSpecId[63] = 8
NetherMachine.rotation.classSpecId[64] = 8
NetherMachine.rotation.classSpecId[65] = 2
NetherMachine.rotation.classSpecId[66] = 2
NetherMachine.rotation.classSpecId[70] = 2
NetherMachine.rotation.classSpecId[71] = 1
NetherMachine.rotation.classSpecId[72] = 1
NetherMachine.rotation.classSpecId[73] = 1
NetherMachine.rotation.classSpecId[102] = 11
NetherMachine.rotation.classSpecId[103] = 11
NetherMachine.rotation.classSpecId[104] = 11
NetherMachine.rotation.classSpecId[105] = 11
NetherMachine.rotation.classSpecId[250] = 6
NetherMachine.rotation.classSpecId[251] = 6
NetherMachine.rotation.classSpecId[252] = 6
NetherMachine.rotation.classSpecId[253] = 3
NetherMachine.rotation.classSpecId[254] = 3
NetherMachine.rotation.classSpecId[255] = 3
NetherMachine.rotation.classSpecId[256] = 5
NetherMachine.rotation.classSpecId[257] = 5
NetherMachine.rotation.classSpecId[258] = 5
NetherMachine.rotation.classSpecId[259] = 4
NetherMachine.rotation.classSpecId[260] = 4
NetherMachine.rotation.classSpecId[261] = 4
NetherMachine.rotation.classSpecId[262] = 7
NetherMachine.rotation.classSpecId[263] = 7
NetherMachine.rotation.classSpecId[264] = 7
NetherMachine.rotation.classSpecId[265] = 9
NetherMachine.rotation.classSpecId[266] = 9
NetherMachine.rotation.classSpecId[267] = 9
NetherMachine.rotation.classSpecId[268] = 10
NetherMachine.rotation.classSpecId[269] = 10
NetherMachine.rotation.classSpecId[270] = 10

NetherMachine.rotation.register = function(specId, spellTable, arg1, arg2)
  local name = NetherMachine.rotation.specId[specId] or GetClassInfoByID(specId)

  local buttons, oocrotation = nil, nil

  if type(arg1) == "table" then
    oocrotation = arg1
  end
  if type(arg1) == "function" then
    buttons = arg1
  end
  if type(arg2) == "table" then
    oocrotation = arg2
  end
  if type(arg2) == "function" then
    buttons = arg2
  end

  NetherMachine.rotation.rotations[specId] = spellTable

  if oocrotation then
    NetherMachine.rotation.oocrotations[specId] = oocrotation
  end

  if buttons and type(buttons) == 'function' then
    NetherMachine.rotation.buttons[specId] = buttons
  end

  NetherMachine.debug.print('Loaded Rotation for ' .. name, 'rotation')
end


NetherMachine.rotation.register_custom = function(specId, _desc, _spellTable, arg1, arg2)

  local _oocrotation, _buttons = false

  if type(arg1) == "table" then
    _oocrotation = arg1
  end
  if type(arg1) == "function" then
    _buttons = arg1
  end
  if type(arg2) == "table" then
    _oocrotation = arg2
  end
  if type(arg2) == "function" then
    _buttons = arg2
  end

  if _oocrotation then
    NetherMachine.rotation.ooccustom[specId] = _oocrotation
  end

  if not NetherMachine.rotation.custom[specId] then
    NetherMachine.rotation.custom[specId] = { }
  end

  table.insert(NetherMachine.rotation.custom[specId], {
    desc = _desc,
    spellTable = _spellTable,
    oocrotation = _oocrotation,
    buttons = _buttons,
  })

  NetherMachine.debug.print('Loaded Custom Rotation for ' .. NetherMachine.rotation.specId[specId], 'rotation')
end

-- Lower memory used, no need in storing rotations for other classes
NetherMachine.rotation.auto_unregister = function()
  local classId = select(3, UnitClass("player"))
  for specId,_ in pairs(NetherMachine.rotation.rotations) do
    if NetherMachine.rotation.classSpecId[specId] ~= classId and specId ~= classId then
      local name = NetherMachine.rotation.specId[specId] or GetClassInfoByID(specId)
      NetherMachine.debug.print('AutoUnloaded Rotation for ' .. name, 'rotation')
      NetherMachine.rotation.classSpecId[specId] = nil
      NetherMachine.rotation.specId[specId] = nil
      NetherMachine.rotation.rotations[specId] = nil
      NetherMachine.rotation.buttons[specId] = nil
    end
  end
  collectgarbage('collect')
end

NetherMachine.rotation.add_buttons = function()
  -- Default Buttons
  if NetherMachine.rotation.buttons[NetherMachine.module.player.specID] then
    NetherMachine.rotation.buttons[NetherMachine.module.player.specID]()
  end

  -- Custom Buttons
  if NetherMachine.rotation.custom[NetherMachine.module.player.specID] then
    for _, rotation in pairs(NetherMachine.rotation.custom[NetherMachine.module.player.specID]) do
      if NetherMachine.rotation.currentStringComp == rotation.desc then
        if rotation.buttons then
          rotation.buttons()
        end
      end
    end
  end
end
