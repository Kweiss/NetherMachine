
local L = NetherMachine.locale.get
local ldb = LibStub("LibDataBroker-1.1")

NetherMachine.dataBroker = { }

NetherMachine.dataBroker.icon = ldb:NewDataObject("NMToggle", {
  type = "launcher",
  icon = "Interface\\Icons\\SPELL_HOLY_REBUKE",
  label = "NetherMachine",
  tocname = "NetherMachine",
  OnClick = function(self, button)
    if IsShiftKeyDown() or IsAltKeyDown() or IsControlKeyDown() then
      if not self.button_moving then
        NetherMachine.buttons.frame:Show()
        self.button_moving = true
      else
        NetherMachine.buttons.frame:Hide()
        self.button_moving = false
      end
    else
      if button == 'RightButton' then
        NetherMachine.interface.showNetherMachineConfig()
      else
        NetherMachine.buttons.toggle('MasterToggle')
      end
    end
  end,
  OnTooltipShow = function(tooltip)
      tooltip:AddDoubleLine('|r|cffffffff'..L('left_click')..'|r', L('help_toggle'))
      tooltip:AddDoubleLine('|r|cffffffff'..L('mod_click')..'|r', L('unlock_buttons'))
      tooltip:AddDoubleLine('|r|cffffffff'..L('right_click')..'|r', L('open_config'))
  end
})

NetherMachine.dataBroker.spell = ldb:NewDataObject("NMCurrentSpell", {
  type = "data source",
  text = L('none'),
  label = L('current_spell'),
})

NetherMachine.dataBroker.previous_spell = ldb:NewDataObject("NMPreviousSpell", {
  type = "data source",
  text = L('none'),
  label = L('previous_spell'),
})
