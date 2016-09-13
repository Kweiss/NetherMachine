local L = NetherMachine.locale.get
NetherMachine.rotation.list_custom = (function()
  local classId = select(3, UnitClass("player"))
  local mySpecId = NetherMachine.module.player.specID


  --info = { }
  --info.isTitle = false
  --info.notCheckable = true
  --info.text = '|cff2c9800Rotation Manager|r'
  --info.func = function()
  --  NetherMachine.interface.manager()
  --end
  --UIDropDownMenu_AddButton(info)


  info = { }
  info.isTitle = true
  info.notCheckable = true
  info.text = L('rtn_default')
  UIDropDownMenu_AddButton(info)

  for specId,_ in pairs(NetherMachine.rotation.rotations) do
    if specId == mySpecId then
      info = { }
      info.text = NetherMachine.rotation.specId[specId] or NetherMachine.module.player.specName
      info.value = info.text
      info.checked = (NetherMachine.rotation.currentStringComp == info.text or NetherMachine.rotation.currentStringComp == "")
      info.func = function()
        local text = NetherMachine.rotation.specId[specId] or NetherMachine.module.player.specName
        NetherMachine.rotation.currentStringComp = text
        NetherMachine.rotation.activeRotation = NetherMachine.rotation.rotations[specId]
        if NetherMachine.rotation.oocrotations[NetherMachine.module.player.specID] then
          NetherMachine.rotation.activeOOCRotation = NetherMachine.rotation.oocrotations[NetherMachine.module.player.specID]
        else
          NetherMachine.rotation.activeOOCRotation = false
        end
        NetherMachine.buttons.resetButtons()
        if NetherMachine.rotation.buttons[specId] then
          NetherMachine.rotation.add_buttons()
        end
        NetherMachine.print(L('rtn_switch') .. text)
        NetherMachine.config.write('lastRotation_' .. mySpecId, '')
      end
      UIDropDownMenu_AddButton(info)
    end
  end

  info = { }
  info.isTitle = true
  info.notCheckable = true
  info.text = L('rtn_custom')
  UIDropDownMenu_AddButton(info)

  if NetherMachine.rotation.custom[mySpecId] then
    for _,rotation in pairs(NetherMachine.rotation.custom[mySpecId]) do
      info = { }
      info.text = rotation.desc
      info.value = info.text
      info.checked = (NetherMachine.rotation.currentStringComp == info.text)
      info.func = function()
        local text = rotation.desc
        NetherMachine.rotation.currentStringComp = text
        NetherMachine.rotation.activeRotation = rotation.spellTable
        if rotation.oocrotation then
          NetherMachine.rotation.activeOOCRotation = rotation.oocrotation
        else
          NetherMachine.rotation.activeOOCRotation = false
        end
        NetherMachine.buttons.resetButtons()
        if rotation.buttons then
          rotation.buttons()
        end
        NetherMachine.print(L('rtn_switch') .. text)
        NetherMachine.config.write('lastRotation_' .. mySpecId, NetherMachine.rotation.currentStringComp)
      end
      UIDropDownMenu_AddButton(info)
    end
  else
    info = { }
    info.isTitle = false
    info.notCheckable = true
    info.text = L('rtn_nocustom')
    UIDropDownMenu_AddButton(info)
  end



end)

NetherMachine.rotation.loadLastRotation = function ()
  local specID = NetherMachine.module.player.specID

  local lastRotation = NetherMachine.config.read('lastRotation_' .. specID, '')
  if NetherMachine.rotation.custom[specID] and lastRotation ~= '' then
    for _, rotation in pairs(NetherMachine.rotation.custom[specID]) do
      if rotation.desc == lastRotation then
        local text = rotation.desc
        NetherMachine.rotation.currentStringComp = text
        NetherMachine.rotation.activeRotation = rotation.spellTable
        if rotation.oocrotation then
          NetherMachine.rotation.activeOOCRotation = rotation.oocrotation
        else
          NetherMachine.rotation.activeOOCRotation = false
        end
        NetherMachine.buttons.resetButtons()
        if rotation.buttons then
          rotation.buttons()
        end
        NetherMachine.print(L('rtn_switch') .. text)
        break
      end
    end
  end
end
