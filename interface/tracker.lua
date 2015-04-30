local L = NetherMachine.locale.get

local function HexToRGBPerc(hex)
  local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
  return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255
end

local max_tracking = NetherMachine.config.read('ct_maxtracking', 10)
local tracking_height = 16
local tracking_width = 250
local colorR, colorB, colorG = HexToRGBPerc(NetherMachine.addonColor)

UnitTracker = CreateFrame("Frame", "NM_Tracker", UIParent)
UnitTracker:IsResizable(true)
UnitTracker:SetWidth(tracking_width)
UnitTracker:SetHeight(max_tracking*tracking_height+(max_tracking*2))
UnitTracker:SetPoint("CENTER", UIParent)
UnitTracker:SetResizable(true)
UnitTracker:SetMovable(true)
UnitTracker:Hide()

UnitTracker.toggle = function(load)
  if load then
    local toggleState = NetherMachine.config.read('ut_toggle')
    if toggleState then
      UnitTracker:Show()
    end
  else
    if UnitTracker:IsShown() then
      UnitTracker:Hide()
      NetherMachine.config.write('ut_toggle', false)
    else
      UnitTracker:Show()
      NetherMachine.config.write('ut_toggle', true)
    end
  end
end

UnitTrackerSizer = CreateFrame("Frame", nil, NM_Tracker)
UnitTrackerSizer:SetWidth(10)
UnitTrackerSizer:SetHeight(10)
UnitTrackerSizer:SetPoint("BOTTOMRIGHT", NM_Tracker)
UnitTrackerSizer:SetFrameStrata("MEDIUM")

local UnitTrackerSizer_texture = UnitTrackerSizer:CreateTexture(nil, "BACKGROUND")
UnitTrackerSizer_texture:SetTexture(1,1,1,0.5)
UnitTrackerSizer_texture:SetAllPoints(UnitTrackerSizer)
UnitTrackerSizer.texture = UnitTrackerSizer_texture


UnitTrackerHeader = CreateFrame("Frame", nil, NM_Tracker)
UnitTrackerHeader:SetHeight(tracking_height)
UnitTrackerHeader:SetPoint("TOPLEFT", NM_Tracker, "TOPLEFT")
UnitTrackerHeader:SetPoint("TOPRIGHT", NM_Tracker, "TOPRIGHT")

local UnitTrackerHeader_texture = UnitTrackerHeader:CreateTexture(nil, "BACKGROUND")
UnitTrackerHeader_texture:SetTexture(0,0,0,1)
UnitTrackerHeader_texture:SetAllPoints(UnitTrackerHeader)
UnitTrackerHeader.texture = UnitTrackerHeader_texture


UnitTrackerHeader.statusText = UnitTrackerHeader:CreateFontString('NM_StatusText')
UnitTrackerHeader.statusText:SetFont("Fonts\\ARIALN.TTF", 10)
UnitTrackerHeader.statusText:SetPoint("CENTER", UnitTrackerHeader)
UnitTrackerHeader.statusText:SetText(L('combat_tracker'))

local displayTTD = NetherMachine.config.read('ct_dttd', false)
local displayTotal = NetherMachine.config.read('ct_dtotal', false)

UnitTrackerToggle = CreateFrame("Button", "NM_TrackerToggle", NM_Tracker)
UnitTrackerToggle:SetWidth(20)
UnitTrackerToggle:SetHeight(tracking_height)
UnitTrackerToggle:SetPoint("TOPLEFT", UnitTrackerHeader, 5, 0)
UnitTrackerToggle.statusText = UnitTrackerToggle:CreateFontString('NM_StatusText')
UnitTrackerToggle.statusText:SetFont("Fonts\\ARIALN.TTF", 10)
UnitTrackerToggle.statusText:SetPoint("LEFT", UnitTrackerToggle, 0, 0)

UnitTrackerTotal = CreateFrame("Button", "NM_TrackerTotal", NM_Tracker)
UnitTrackerTotal:SetWidth(20)
UnitTrackerTotal:SetHeight(tracking_height)
UnitTrackerTotal:SetPoint("TOPRIGHT", UnitTrackerHeader, -5, 0)
UnitTrackerTotal.statusText = UnitTrackerTotal:CreateFontString('NM_StatusText')
UnitTrackerTotal.statusText:SetFont("Fonts\\ARIALN.TTF", 10)
UnitTrackerTotal.statusText:SetPoint("RIGHT", UnitTrackerTotal, 0, 0)
UnitTrackerTotal.statusText:SetText("T")

if displayTTD then
  UnitTrackerToggle.statusText:SetText(L('ttd'))
else
  UnitTrackerToggle.statusText:SetText(L('hpr'))
end

if displayTotal then
  UnitTrackerTotal.statusText:SetTextColor(0.2,0.7,0.2,1)
else
  UnitTrackerTotal.statusText:SetTextColor(1,1,1,1)
end

UnitTrackerToggle:SetScript("OnClick", function(self, button)
  displayTTD = not displayTTD
  if displayTTD then
    UnitTrackerToggle.statusText:SetText(L('ttd'))
  else
    UnitTrackerToggle.statusText:SetText(L('hpr'))
  end
  NetherMachine.config.write('ct_dttd', displayTTD)
end)

UnitTrackerTotal:SetScript("OnClick", function(self, button)
  displayTotal = not displayTotal
  if displayTotal then
    UnitTrackerTotal.statusText:SetTextColor(0.2,0.7,0.2,1)
  else
    UnitTrackerTotal.statusText:SetTextColor(1,1,1,1)
  end
  NetherMachine.config.write('ct_dtotal', displayTotal)
end)

UnitTrackerSizer:SetScript("OnMouseDown", function(self, button)
  if not UnitTracker.isMoving then
   UnitTracker:StartSizing()
   UnitTracker.isMoving = true
  end
end)
UnitTrackerSizer:SetScript("OnMouseUp", function(self, button)
  if UnitTracker.isMoving then
   UnitTracker:StopMovingOrSizing()
   UnitTracker.isMoving = false
  end
end)
UnitTrackerSizer:SetScript("OnHide", function(self)
  if UnitTracker.isMoving then
   UnitTracker:StopMovingOrSizing()
   UnitTracker.isMoving = false
  end
end)
UnitTrackerSizer:SetScript("OnUpdate", function(self)
  if UnitTracker.isMoving then
   UnitTracker:SetHeight(max_tracking*tracking_height+(max_tracking*4)-tracking_height)
  end
end)

UnitTracker:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
   self:StartMoving()
   self.isMoving = true
  end
end)
UnitTracker:SetScript("OnMouseUp", function(self, button)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
UnitTracker:SetScript("OnHide", function(self)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)


local UnitTracker_texture = UnitTracker:CreateTexture(nil, "BACKGROUND")
UnitTracker_texture:SetTexture(0,0,0,0.5)
UnitTracker_texture:SetAllPoints(UnitTracker)
UnitTracker.texture = UnitTracker_texture

UnitTracker:SetPoint("CENTER", 0, 0)
CombatTableUnit = { }

if displayTotal then max_tracking = max_tracking + 1 end

for i = 1, (max_tracking) do
  CombatTableUnit[i] = CreateFrame("StatusBar", nil, UnitTracker)
  CombatTableUnit[i]:SetStatusBarTexture(1,1,1,0.8)
  CombatTableUnit[i]:GetStatusBarTexture():SetHorizTile(false)
  CombatTableUnit[i]:SetMinMaxValues(0, 100)
  CombatTableUnit[i]:SetHeight(tracking_height)
  CombatTableUnit[i]:SetPoint("LEFT", NM_Tracker, "LEFT")
  CombatTableUnit[i]:SetPoint("RIGHT", NM_Tracker, "RIGHT")

  CombatTableUnit[i]:SetValue(100)
  CombatTableUnit[i]:SetStatusBarColor(colorR,colorB,colorG)

  CombatTableUnit[i].unitName = CombatTableUnit[i]:CreateFontString('unitName')
  CombatTableUnit[i].unitName:SetFont("Fonts\\ARIALN.TTF", 10)
  CombatTableUnit[i].unitName:SetShadowColor(0,0,0, 0.8)
  CombatTableUnit[i].unitName:SetShadowOffset(-1,-1)
  CombatTableUnit[i].unitName:SetPoint("LEFT", CombatTableUnit[i])


  CombatTableUnit[i].unitHealth = CombatTableUnit[i]:CreateFontString('unitHealth')
  CombatTableUnit[i].unitHealth:SetFont("Fonts\\ARIALN.TTF", 10)
  CombatTableUnit[i].unitHealth:SetShadowColor(0,0,0, 0.8)
  CombatTableUnit[i].unitHealth:SetShadowOffset(-1,-1)
  CombatTableUnit[i].unitHealth:SetPoint("RIGHT", CombatTableUnit[i])

  local position = 0
  position = ((((i * tracking_height) + (i * 1)) - 1) * -1)
  CombatTableUnit[i]:SetPoint("TOPLEFT", UnitTracker, "TOPLEFT", 0, position)

end
--[[
NetherMachine.timer.register("updateCTHealthUI", function()

  local incombatwith = #NetherMachine.module.combatTracker.enemy
  local currentRow
  if displayTotal then currentRow = 2 else currentRow = 1 end

  local totalHP = 0
  local totalCurrentHP = 0
  local totalDPS = 0

  for guid, unit in ipairs(NetherMachine.module.combatTracker.enemy) do

    if unit.health and unit.health <= 1 then
      -- shits dead yo
      NetherMachine.module.combatTracker.enemy[guid] = nil
    else
      if currentRow <= max_tracking then

        CombatTableUnit[currentRow].unitName:SetText(unit.name)
        if unit.health and unit.maxHealth then

          totalHP = totalHP + unit.maxHealth
          totalCurrentHP = totalCurrentHP + unit.health

          local percent = math.floor(((unit.health / unit.maxHealth) * 100))
          local remaining = math.floor(unit.health / 1000)
          -- We have the unitHP and max HP
          -- show a nice % bar
          CombatTableUnit[currentRow]:SetValue(percent)

          if displayTTD then
            if NetherMachine.module.combatTracker.enemy[guid]['ttd'] then
              seconds = NetherMachine.module.combatTracker.enemy[guid]['ttd']
              deaht_in = string.format("%.2d:%.2d", seconds/60, seconds%60)
            else
              deaht_in = L('est')
            end
            CombatTableUnit[currentRow].unitHealth:SetText(deaht_in)
          else
            CombatTableUnit[currentRow].unitHealth:SetText(remaining)
          end

        elseif unit.maxHealth then
          -- We have the units max HP but we don't know its current HP
          -- This happens often as we NetherMachine are guessing the units HP
          totalHP = totalHP + unit.maxHealth
          local remaining = math.floor(unit.maxHealth / 1000)
          CombatTableUnit[currentRow]:SetValue(100)
          CombatTableUnit[currentRow].unitHealth:SetText(remaining .. L('k'))
        elseif unit.health then
          -- We have the units HP now, but not its max HP
          -- this should never happen.. but here it is
          totalCurrentHP = totalCurrentHP + unit.health
          local remaining = math.floor(unit.health / 1000)
          CombatTableUnit[currentRow]:SetValue(100)
          CombatTableUnit[currentRow].unitHealth:SetText(remaining .. L('k'))
        else
          -- we actually don't know the units health :'(
          CombatTableUnit[currentRow]:SetValue(100)
          CombatTableUnit[currentRow].unitHealth:SetText(L('na'))
        end
        currentRow = currentRow + 1
      end

    end

  end

  local totalPercent = 0
  local totalRemaining = 0
  if totalCurrentHP and totalHP and displayTotal then
    totalPercent = math.floor(((totalCurrentHP / totalHP) * 100))
    totalRemaining = math.floor(totalCurrentHP / 1000)
  end

  if displayTotal then
    CombatTableUnit[1].unitName:SetText(L('all_units'))
    CombatTableUnit[1]:SetPoint("TOPLEFT", UnitTracker, "TOPLEFT", 0, tracking_height*-1)
    CombatTableUnit[1]:SetValue(totalPercent)
    CombatTableUnit[1].unitHealth:SetText(totalRemaining .. L('k'))
  end

  for i = currentRow, max_tracking do
    CombatTableUnit[i]:SetValue(0)
    CombatTableUnit[i].unitName:SetText('')
    CombatTableUnit[i].unitHealth:SetText('')
  end
end, 100)
]]
NetherMachine.interface.cleanCT = function()
  for i = 1, max_tracking do
    CombatTableUnit[i]:SetValue(0)
    CombatTableUnit[i].unitName:SetText('')
    CombatTableUnit[i].unitHealth:SetText('')
  end
end
