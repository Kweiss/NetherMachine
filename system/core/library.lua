NetherMachine.library = {
  libs = { }
}

NetherMachine.library.register = function(name, lib)
  if NetherMachine.library.libs[name] then
    NetherMachine.debug.print("Cannot overwrite library:" .. name, 'library')
    return false
  end
  NetherMachine.library.libs[name] = lib
end

NetherMachine.library.fetch = function(name)
  return NetherMachine.library.libs[name]
end

NetherMachine.library.parse = function(event, evaluation, target)
  if target == nil then target = "target" end
  local call = string.sub(evaluation, 2)
  local func
  -- this will work most of the time... I hope :)
  if string.sub(evaluation, -1) == ')' then
    -- the user calls the function for us
    func = loadstring('local target = "'..target..'";return NetherMachine.library.libs.' .. call .. '')
  else
    -- we need to call the function
    func = loadstring('local target = "'..target..'";return NetherMachine.library.libs.' .. call .. '(target)')
  end
  local eval = func and func(target, event) or false
  return eval
end
