--[[
NetherMachine.keys = {
  frame = CreateFrame("Frame", "NM_CaptureKeyFrame", WorldFrame),
  states = { }
}

NetherMachine.keys.frame:EnableKeyboard(true)
NetherMachine.keys.frame:SetPropagateKeyboardInput(true)

NetherMachine.keys.frame:SetScript("OnKeyDown", function(self, key)
  NetherMachine.keys.setState(key, true)
end)

NetherMachine.keys.frame:SetScript("OnKeyUp", function(self, key)
  NetherMachine.keys.setState(key, nil)
end)

NetherMachine.keys.getState = function(key)
  return NetherMachine.keys.states[key] or false
end

NetherMachine.keys.setState = function(key, state)
  NetherMachine.keys.states[key] = state
end]]
