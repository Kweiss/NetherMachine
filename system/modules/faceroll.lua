NetherMachine.faceroll = {
	buttonMap = { },
	lastFrame = false,
	rolling = false
}

NetherMachine.faceroll.activeFrame = CreateFrame('Frame', 'activeCastFrame', UIParent)
local activeFrame = NetherMachine.faceroll.activeFrame
activeFrame:SetWidth(32)
activeFrame:SetHeight(32)
activeFrame:SetPoint("CENTER", UIParent, "CENTER")
activeFrame.texture = activeFrame:CreateTexture()
activeFrame.texture:SetTexture("Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8")
activeFrame.texture:SetVertexColor(0, 1, 0, 1)
activeFrame.texture:SetAllPoints(activeFrame)
activeFrame:SetFrameStrata('HIGH')
activeFrame:Hide()

local function showActiveSpell()
	if not NetherMachine.protected.method then
		local current_spell = NetherMachine.current_spell
		local spellButton = NetherMachine.faceroll.buttonMap[current_spell]
		if spellButton and current_spell then
			activeFrame:Show()
			activeFrame:SetPoint("CENTER", spellButton, "CENTER")
		else
			activeFrame:Hide()
		end
	else
		NetherMachine.faceroll.activeFrame:Hide()
		NetherMachine.timer.unregister("visualCast")
	end
end
NetherMachine.timer.register("visualCast", showActiveSpell, 50)
