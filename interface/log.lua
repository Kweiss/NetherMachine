local L = NetherMachine.locale.get

local stringLen = string.len

local log_height = 16
local log_items = 10
local abs_height = log_height * log_items + log_height
local delta = 0

NM_ActionLog = CreateFrame("Frame", "NM_ActionLog", UIParent)
local ActionLog = NM_ActionLog
ActionLog.show = false
ActionLog:SetFrameLevel(90)
ActionLog:SetWidth(450)
ActionLog:SetHeight(abs_height)
ActionLog:SetPoint("CENTER", UIParent)
ActionLog:SetMovable(true)
ActionLog:EnableMouseWheel(true)

local ActionLog_texture = ActionLog:CreateTexture(nil, "BACKGROUND")
ActionLog_texture:SetTexture(0,0,0,0.5)
ActionLog_texture:SetAllPoints(ActionLog)
ActionLog.texture = ActionLogHeader_texture

ActionLog:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
   self:StartMoving()
   self.isMoving = true
  end
end)
ActionLog:SetScript("OnMouseUp", function(self, button)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
ActionLog:SetScript("OnHide", function(self)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
ActionLog:SetScript("OnMouseWheel", function(self, mouse)
  local top = #NetherMachine.actionLog.log - log_items

  if IsShiftKeyDown() then
    if mouse == 1 then
      delta = top
    elseif mouse == -1 then
      delta = 0
    end
  else
    if mouse == 1 then
      if delta < top then
        delta = delta + mouse
      end
    elseif mouse == -1 then
      if delta > 0 then
        delta = delta + mouse
      end
    end
  end

  NetherMachine.actionLog.update()
end)


local ActionLogDivA = CreateFrame("Frame", nil , NM_ActionLog)
ActionLogDivA:SetFrameLevel(99)
ActionLogDivA:SetWidth(1)
ActionLogDivA:SetHeight(abs_height)
--ActionLogDivA:SetPoint("LEFT", NM_ActionLog, 100, 0)
ActionLogDivA:SetMovable(true)

local ActionLogDivA_texture = ActionLogDivA:CreateTexture(nil, "BACKGROUND")
ActionLogDivA_texture:SetTexture(0,0,0,0.5)
ActionLogDivA_texture:SetAllPoints(ActionLogDivA)
ActionLogDivA.texture = ActionLogDivA_texture

local ActionLogDivB = CreateFrame("Frame", nil , NM_ActionLog)
ActionLogDivB:SetFrameLevel(99)
ActionLogDivB:SetWidth(1)
ActionLogDivB:SetHeight(abs_height)
--ActionLogDivB:SetPoint("LEFT", NM_ActionLog, 400, 0)
ActionLogDivB:SetMovable(true)

local ActionLogDivB_texture = ActionLogDivB:CreateTexture(nil, "BACKGROUND")
ActionLogDivB_texture:SetTexture(0,0,0,0.5)
ActionLogDivB_texture:SetAllPoints(ActionLogDivB)
ActionLogDivB.texture = ActionLogDivB_texture


NM_ActionLog:Hide()

local ActionLogHeader = CreateFrame("Frame", nil, NM_ActionLog)
ActionLogHeader:SetFrameLevel(92)
ActionLogHeader:SetHeight(log_height)
ActionLogHeader:SetPoint("TOPLEFT", NM_ActionLog, "TOPLEFT")
ActionLogHeader:SetPoint("TOPRIGHT", NM_ActionLog, "TOPRIGHT")
local ActionLogHeader_texture = ActionLogHeader:CreateTexture(nil, "BACKGROUND")
ActionLogHeader_texture:SetTexture(0.15,0.15,0.15,0.5)
ActionLogHeader_texture:SetGradient("VERTICAL", 0.8,0.8,0.8, 0,0,0)
ActionLogHeader_texture:SetAllPoints(ActionLogHeader)
ActionLogHeader.texture = ActionLogHeader_texture


ActionLogHeader.statusTextA = ActionLogHeader:CreateFontString('NM_ActionLogHeaderText')
ActionLogHeader.statusTextA:SetFont("Fonts\\ARIALN.TTF", 10)
ActionLogHeader.statusTextA:SetPoint("LEFT", ActionLogHeader, 5, 0)
ActionLogHeader.statusTextA:SetText("Action")

ActionLogHeader.statusTextB = ActionLogHeader:CreateFontString('NM_ActionLogHeaderText')
ActionLogHeader.statusTextB:SetFont("Fonts\\ARIALN.TTF", 10)
ActionLogHeader.statusTextB:SetPoint("LEFT", ActionLogHeader, 205, 0)
ActionLogHeader.statusTextB:SetText("Description")

ActionLogHeader.statusTextC = ActionLogHeader:CreateFontString('NM_ActionLogHeaderText')
ActionLogHeader.statusTextC:SetFont("Fonts\\ARIALN.TTF", 10)
ActionLogHeader.statusTextC:SetPoint("LEFT", ActionLogHeader, 405, 0)
ActionLogHeader.statusTextC:SetText("Time")

local ActionLogClose = CreateFrame("Button", "NM_TrackerClose", NM_ActionLog)
ActionLogClose:SetFrameLevel(93)
ActionLogClose:SetWidth(20)
ActionLogClose:SetHeight(log_height)
ActionLogClose:SetPoint("TOPRIGHT", ActionLogHeader, 2, -1)

ActionLogClose.statusText = ActionLogHeader:CreateFontString('NM_ActionLogCloseX')
ActionLogClose.statusText:SetFont("Fonts\\ARIALN.TTF", 20)ActionLogClose.statusText:SetPoint("CENTER", ActionLogClose)
ActionLogClose.statusText:SetText("×")

ActionLogClose:SetScript("OnMouseUp", function(self, button)
  NM_ActionLog:Hide()
end)

local ActionLogItem = { }

for i = 1, (log_items) do

  ActionLogItem[i] = CreateFrame("Frame", nil, NM_ActionLog)
  ActionLogItem[i]:SetFrameLevel(94)
  local texture = ActionLogItem[i]:CreateTexture(nil, "BACKGROUND")
  texture:SetAllPoints(ActionLogItem[i])

  if (i % 2) == 1 then
    texture:SetTexture(0.15,0.15,0.15,0.3)
  else
    texture:SetTexture(0.1,0.1,0.1,0.3)
  end

  ActionLogItem[i].texture = texture


  ActionLogItem[i]:SetHeight(log_height)
  ActionLogItem[i]:SetPoint("LEFT", NM_ActionLog, "LEFT")
  ActionLogItem[i]:SetPoint("RIGHT", NM_ActionLog, "RIGHT")


  ActionLogItem[i].itemA = ActionLogItem[i]:CreateFontString('itemA')
  ActionLogItem[i].itemA:SetFont("Fonts\\ARIALN.TTF", 10)
  ActionLogItem[i].itemA:SetShadowColor(0,0,0, 0.8)
  ActionLogItem[i].itemA:SetShadowOffset(-1,-1)
  ActionLogItem[i].itemA:SetPoint("LEFT", ActionLogItem[i], 5, 0)

  ActionLogItem[i].itemB = ActionLogItem[i]:CreateFontString('itemA')
  ActionLogItem[i].itemB:SetFont("Fonts\\ARIALN.TTF", 10)
  ActionLogItem[i].itemB:SetShadowColor(0,0,0, 0.8)
  ActionLogItem[i].itemB:SetShadowOffset(-1,-1)
  ActionLogItem[i].itemB:SetPoint("LEFT", ActionLogItem[i], 105, 0)

  ActionLogItem[i].itemC = ActionLogItem[i]:CreateFontString('itemA')
  ActionLogItem[i].itemC:SetFont("Fonts\\ARIALN.TTF", 10)
  ActionLogItem[i].itemC:SetShadowColor(0,0,0, 0.8)
  ActionLogItem[i].itemC:SetShadowOffset(-1,-1)
  ActionLogItem[i].itemC:SetPoint("LEFT", ActionLogItem[i], 405, 0)


  local position = ((i * log_height) * -1)
  ActionLogItem[i]:SetPoint("TOPLEFT", NM_ActionLog, "TOPLEFT", 0, position)

end

NetherMachine.actionLog = {
  log = {}
}

NetherMachine.actionLog.insert = function(type, spell, spellIcon, target)
  if spellIcon then
    if NetherMachine.actionLog.log[1] and NetherMachine.actionLog.log[1]['event'] == type and NetherMachine.actionLog.log[1]['description'] == spell and NetherMachine.actionLog.log[1]['target'] == target then
      NetherMachine.actionLog.log[1]['count'] = NetherMachine.actionLog.log[1]['count'] + 1
    else
      table.insert(NetherMachine.actionLog.log, 1, {
        event = type,
        target = target or '',
        icon = spellIcon,
        description = spell,
        count = 1,
        time = date("%H:%M:%S")
      })

      if delta > 0 and delta < #NetherMachine.actionLog.log - log_items then
        delta = delta + 1
      end
    end
  end
end

NetherMachine.actionLog.updateRow = function (row, a, b, c)
  ActionLogItem[row].itemA:SetText(a)
  ActionLogItem[row].itemB:SetText(b)
  ActionLogItem[row].itemC:SetText(c)
end

NetherMachine.actionLog.update = function ()
  local offset = 0
  for i = log_items, 1, -1 do
    offset = offset + 1
    local item = NetherMachine.actionLog.log[offset + delta]
    if not item then
      NetherMachine.actionLog.updateRow(i, '', '', '')
    else
      local target = stringLen(item.target) > 0 and ' @ (' .. item.target .. ')' or ''
      NetherMachine.actionLog.updateRow(i, item.event, 'x' .. item.count .. ' ' .. '|T' .. item.icon .. ':-1:-1:0:0|t' .. item.description .. target, item.time)
    end
  end
end

NetherMachine.timer.register("updateActionLog", function()
  if not NM_ActionLog:IsShown() then return end

  NetherMachine.actionLog.update()
end, 100)
