-- NetherMachine Rotations
-- Released under modified BSD, see attached LICENSE.

local L = NetherMachine.locale.get

NetherMachine.buttons = {
  frame = CreateFrame("Frame", "NM_Buttons", UIParent),
  buttonFrame = CreateFrame("Frame", "NM_Buttons_Container", UIParent),
  buttons = { },
  size = 28,
  scale = 1,
  padding = 2,
  count = 0,
}

-- Masque ?!
local MSQ = LibStub("Masque", true)
local NetherMachineSkinGroup
if MSQ then
  NetherMachineSkinGroup = MSQ:Group("NetherMachine", "Buttons")
end
-- ElvUI ?!
local E, _L, V, P, G
if IsAddOnLoaded("ElvUI") then
  E, _L, V, P, G = unpack(ElvUI)
  ElvSkin = E:GetModule('ActionBars')
  NetherMachine.buttons.padding = 3
  NetherMachine.buttons.size = 31
end

NetherMachine.buttons.frame:SetPoint("CENTER", UIParent)
NetherMachine.buttons.frame:SetWidth(170)
NetherMachine.buttons.frame:SetHeight(NetherMachine.buttons.size+5)
NetherMachine.buttons.frame:SetMovable(true)
NetherMachine.buttons.frame:SetFrameStrata('HIGH')
NetherMachine.buttons.frame:SetAlpha(0.8)

NetherMachine.buttons.frame:Hide()
NetherMachine.buttons.buttonFrame:Hide()

NetherMachine.buttons.statusText = NetherMachine.buttons.frame:CreateFontString('NM_StatusText')
NetherMachine.buttons.statusText:SetFont("Fonts\\ARIALN.TTF", 16)
NetherMachine.buttons.statusText:SetShadowColor(0,0,0, 0.8)
NetherMachine.buttons.statusText:SetShadowOffset(-1,-1)
NetherMachine.buttons.statusText:SetPoint("CENTER", NetherMachine.buttons.frame)
NetherMachine.buttons.statusText:SetText("|cffffffff"..L('drag_to_position').."|r")

NetherMachine.buttons.frame.texture = NetherMachine.buttons.frame:CreateTexture()
NetherMachine.buttons.frame.texture:SetAllPoints(NetherMachine.buttons.frame)
NetherMachine.buttons.frame.texture:SetTexture(0,0,0,0.6)

NetherMachine.buttons.frame:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
    self:StartMoving()
    self.isMoving = true
  end
  end)
  NetherMachine.buttons.frame:SetScript("OnMouseUp", function(self, button)
    if self.isMoving then
      self:StopMovingOrSizing()
      self.isMoving = false
    end
    end)
    NetherMachine.buttons.frame:SetScript("OnHide", function(self)
      if self.isMoving then
        self:StopMovingOrSizing()
        self.isMoving = false
      end
      end)

      NetherMachine.buttons.create = function(name, icon, callback, tooltipl1, tooltipl2)
        if _G['NM_Buttons_' .. name] then
          NetherMachine.buttons.buttons[name] = _G['NM_Buttons_' .. name]
          _G['NM_Buttons_' .. name]:Show()
        else
          NetherMachine.buttons.buttons[name] = CreateFrame("CheckButton", "NM_Buttons_"..name, NetherMachine.buttons.buttonFrame, "ActionButtonTemplate")
        end
        NetherMachine.buttons.buttons[name]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        local button = NetherMachine.buttons.buttons[name]

        button:SetPoint("TOPLEFT", NetherMachine.buttons.frame, "TOPLEFT",
        (
        (NetherMachine.buttons.size*NetherMachine.buttons.count)
        +
        (NetherMachine.buttons.count*NetherMachine.buttons.padding)
        + 4
        )
        , -3)
        button:SetWidth(NetherMachine.buttons.size)
        button:SetHeight(NetherMachine.buttons.size)
        button:SetAlpha(1)

        -- theme it, Masque ?
        if NetherMachineSkinGroup then
          NetherMachineSkinGroup:AddButton(button)
        end
        -- theme it, ElvUI ?
        if ElvSkin then
          ElvSkin.db = E.db.actionbar
          button:CreateBackdrop("ClassColor")
          ElvSkin:StyleButton(button, nil, true)
          button:SetCheckedTexture(nil)
          button:SetPushedTexture(nil)
          button.customTheme = function ()
            button:SetCheckedTexture(nil)
            local state = button.checked
            if state then
              button.backdrop:Show()
            else
              button.backdrop:Hide()
            end
          end
          local originalCallback = callback or false
          callback = function (self, mouseButton)
            if originalCallback then
              originalCallback(self, mouseButton)
            end
            button.customTheme()
          end
        end

        if icon == nil then
          button.icon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
        else
          button.icon:SetTexture(icon)
        end

        button:SetScript("OnClick", callback)

        if tooltipl1 ~= nil then
          button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:AddLine("|cffffffff" .. tooltipl1 .. "|r")
            if tooltipl2 then
              GameTooltip:AddLine(tooltipl2)
            end
            GameTooltip:Show()
            end)
            button:SetScript("OnLeave", function(self)
              GameTooltip:Hide()
              end)
            end

            button.checked = false

            button:SetPushedTexture(nil)

            _G['NM_Buttons_'..name.."HotKey"]:SetText('Off')
            _G['NM_Buttons_'..name.."HotKey"]:Hide()

            if NetherMachine.config.read('buttonVisualText', false) then
              _G['NM_Buttons_'..name.."HotKey"]:Show()
            end

            NetherMachine.buttons.count = NetherMachine.buttons.count + 1

            NetherMachine.buttons.frame:SetWidth(NetherMachine.buttons.count * (NetherMachine.buttons.size+NetherMachine.buttons.padding))

          end

          NetherMachine.buttons.text = function(name, text)
            local hotkey = _G['NM_Buttons_'.. name .."HotKey"]
            hotkey:SetText(text);
            hotkey:Show();
          end

          NetherMachine.buttons.setActive = function(name)
            if _G['NM_Buttons_'.. name] then
              _G['NM_Buttons_'.. name].checked = true
              _G['NM_Buttons_'.. name]:SetChecked(true)
              _G['NM_Buttons_'..name.."HotKey"]:SetText('On')
              if _G['NM_Buttons_'.. name].customTheme then
                _G['NM_Buttons_'.. name].customTheme()
              end
              NetherMachine.config.write('button_states', name, true)
            end
          end

          NetherMachine.buttons.setInactive = function(name)
            if _G['NM_Buttons_'.. name] then
              _G['NM_Buttons_'.. name].checked = false
              _G['NM_Buttons_'.. name]:SetChecked(false)
              _G['NM_Buttons_'..name.."HotKey"]:SetText('Off')
              if _G['NM_Buttons_'.. name].customTheme then
                _G['NM_Buttons_'.. name].customTheme()
              end
              NetherMachine.config.write('button_states', name, false)
            end
          end

          NetherMachine.buttons.toggle = function(name)
            if _G['NM_Buttons_'.. name] then
              local state = _G['NM_Buttons_'.. name].checked
              if state then
                NetherMachine.buttons.setInactive(name)
              else
                NetherMachine.buttons.setActive(name)
              end
            end
          end

          NetherMachine.buttons.icon = function(name, icon)
            _G['NM_Buttons_'.. name ..'Icon']:SetTexture(icon)
          end

          NetherMachine.buttons.loadStates = function()
            if NetherMachine.config.read('uishown', true) then
              NetherMachine.buttons.frame:Hide()
              NetherMachine.buttons.buttonFrame:Show()
            end
            for name in pairs(NetherMachine.buttons.buttons) do
              local state = NetherMachine.config.read('button_states', name, false)
              if state == true then
                NetherMachine.buttons.setActive(name)
              else
                NetherMachine.buttons.setInactive(name)
              end
            end
          end

          NetherMachine.buttons.resetButtons = function ()
            if NetherMachine.buttons.buttons then
              local defaultButtons = { 'MasterToggle', 'cooldowns', 'multitarget', 'interrupt' }
              for name, button in pairs(NetherMachine.buttons.buttons) do
                -- button text toggles
                if NetherMachine.config.read('buttonVisualText', false) then
                  _G['NM_Buttons_'..name.."HotKey"]:Show()
                else
                  _G['NM_Buttons_'..name.."HotKey"]:Hide()
                end
                local original = false
                for _, buttonName in pairs(defaultButtons) do
                  if name == buttonName then
                    original = true
                    break
                  end
                end
                if not original then
                  NetherMachine.buttons.buttons[name] = nil
                  button:Hide()
                end
              end
              NetherMachine.buttons.count = table.length(NetherMachine.buttons.buttons)
            end
            NetherMachine.buttons.frame:SetWidth(NetherMachine.buttons.count * (NetherMachine.buttons.size+NetherMachine.buttons.padding))
          end
