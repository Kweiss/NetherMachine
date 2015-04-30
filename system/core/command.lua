local L = NetherMachine.locale.get

NetherMachine.command = {
  commands = 0,
  handlers = { }
}

NetherMachine.command.print = function(message)
  print("|cFF"..NetherMachine.addonColor.."["..NetherMachine.addonName.."]|r " .. message .. "")
end

NetherMachine.command.register = function (command, handler)
  local name = 'NM_' .. command
  _G["SLASH_" .. name .. "1"] = '/' .. command
  SlashCmdList[name] = function(message, editbox) handler(message, editbox) end
end

NetherMachine.command.register_handler = function(command, handler)
  local command_type = type(command)
  if command_type == "string" then
    NetherMachine.command.handlers[command] = handler
  elseif command_type == "table" then
    for _,com in pairs(command) do
      NetherMachine.command.handlers[com] = handler
    end
  else
    NetherMachine.command.print(L('unknown_type') .. ': ' .. command_type)
  end
end

NetherMachine.command.register('nm', function(msg, box)
  local command, text = msg:match("^(%S*)%s*(.-)$")
  if NetherMachine.command.handlers[command] then
    NetherMachine.command.handlers[command](text)
  else
    NetherMachine.command.handlers['help']('help')
  end
end)
