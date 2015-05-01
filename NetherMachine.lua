NetherMachine = {
  addonName = "NetherMachine",
  addonReal = "NetherMachine",
  addonColor = "AC6FC7",
  version = "1.0r2"
}

function NetherMachine.print(message)
  print('|c00'..NetherMachine.addonColor..'['..NetherMachine.addonName..']|r ' .. message)
end

if not ScriptSettings then
  ScriptSettings = {};
end

if not ScriptSettingsPerCharacter then
  ScriptSettingsPerCharacter = {};
end

function SetScriptVariable (Name, Value)
  ScriptSettings[Name] = Value;
end

function GetScriptVariable (Name)
  return ScriptSettings[Name];
end

function SetCharacterScriptVariable (Name, Value)
  ScriptSettingsPerCharacter[Name] = Value;
end

function GetCharacterScriptVariable (Name)
  return ScriptSettingsPerCharacter[Name];
end
