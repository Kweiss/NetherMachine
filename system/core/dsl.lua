NetherMachine.dsl = {

}

local comparator_table = { }
local parse_table = { }

NetherMachine.dsl.getConditionalSpell = function(dsl, spell)
  -- check if we are passing a spell with the conditional
  if string.match(dsl, '(.+)%((.+)%)') then
    return string.match(dsl, '(.+)%((.+)%)')
  else
    return dsl, spell
  end
end

NetherMachine.dsl.comparator = function(condition, target, condition_spell)

  if not condition then return false end

  local modify_not = false

  -- lol fuck off line 24...
  if target and type(target) == "string" then
    if string.sub(target, 1, 1) == '!' then
      target = string.sub(target, 2)
      modify_not = true
    end
  end

  if string.sub(condition, 1, 1) == '!' then
    condition = string.sub(condition, 2)
    modify_not = true
  end

  -- fuck lua you are a dirty bastard
  -- we do this so we can keep the same table
  -- and save some memory
  for i,_ in ipairs(comparator_table) do comparator_table[i] = nil end
  local arg1, arg2, arg3 = strsplit(' ', condition, 3)
  if arg1 then table.insert(comparator_table, arg1) end
  if arg2 then table.insert(comparator_table, arg2) end
  if arg3 then table.insert(comparator_table, arg3) end

  local evaluation = false
  if #comparator_table == 3 then

    local compare_value = tonumber(comparator_table[3])
    local condition_call = NetherMachine.dsl.get(comparator_table[1])(target, condition_spell, compare_value)
    local call_type = type(condition_call)

    if call_type ~= "number" then
      if tonumber(condition_call) then
        call_type = "number"
        condition_call = tonumber(condition_call)
      end
    end

    if call_type == "number" then
      local value = condition_call

      if compare_value == nil then
        evaluation = comparator_table[3]  == condition_call
      else
        if comparator_table[2] == '>=' then
          evaluation = value >= compare_value
        elseif comparator_table[2] == '<=' then
          evaluation = value <= compare_value
        elseif comparator_table[2] == '>' then
          evaluation = value > compare_value
        elseif comparator_table[2] == '<' then
          evaluation = value < compare_value
        elseif comparator_table[2] == '=' or comparator_table[2] == '==' then
          evaluation = value == compare_value
        elseif comparator_table[2] == '!=' or comparator_table[2] == '!' then
          evaluation = value ~= compare_value
        else
          NetherMachine.debug.print("Calling non-existant comparator: [" .. comparator_table .. "]", 'dsl_no_exist')
          evaluation = false
        end
      end
    else
      evaluation = condition_call
    end

  else
    evaluation = NetherMachine.dsl.get(condition)(target, condition_spell)
  end
  if modify_not then
    return not evaluation
  end
  NetherMachine.debug.print(condition ..'-'.. target ..'-'.. condition_spell ..'-'.. tostring(evaluation), 'dsl_debug')
  return evaluation
end

NetherMachine.dsl.conditionizers = {}
NetherMachine.dsl.conditionizers['modifier'] = true
NetherMachine.dsl.conditionizers['!modifier'] = true

NetherMachine.dsl.conditionizers_single = {}
NetherMachine.dsl.conditionizers_single['toggle'] = true
NetherMachine.dsl.conditionizers_single['!toggle'] = true

NetherMachine.dsl.conditionize = function(target, condition)
  if NetherMachine.dsl.conditionizers[target] then
    return target..'.'..condition
  elseif NetherMachine.dsl.conditionizers_single[target] then
    return target
  else
    return condition
  end
end

NetherMachine.dsl.parse = function(dsl, spell)

  NetherMachine.dsl.parsedTarget = nil

  -- same as above, saving ram
  for i,_ in ipairs(parse_table) do parse_table[i] = nil end

  -- Just how fucking dynamic can we get?
  -- You have no idea!!!
  if type(dsl) == 'function' then
    return dsl()
  elseif type(dsl) == 'table' then
    return NetherMachine.parser.table(dsl)
  end



  local unitId, arg2, arg3 = strsplit('.', dsl, 3)

  -- healing?
  if unitId == "lowest" then
    unitId = NetherMachine.raid.lowestHP()
    if unitId == false then return false end
    NetherMachine.dsl.parsedTarget = unitId
  elseif unitId == "!lowest" then
    unitId = "!" .. NetherMachine.raid.lowestHP()
    NetherMachine.dsl.parsedTarget = unitId
  elseif unitId == "tank" then
    unitId = NetherMachine.raid.tank()
    NetherMachine.dsl.parsedTarget = unitId
  elseif unitId == "!tank" then
    unitId = '!' .. NetherMachine.raid.tank()
    NetherMachine.dsl.parsedTarget = unitId
  elseif unitId == "tanktarget" then
    unitId = NetherMachine.raid.tank() .. 'target'
    NetherMachine.dsl.parsedTarget = unitId
  elseif unitId == "!tanktarget" then
    unitId = '!' .. NetherMachine.raid.tank() .. 'target'
    NetherMachine.dsl.parsedTarget = unitId
  end

  if unitId then table.insert(parse_table, unitId) end
  if arg2 then table.insert(parse_table, arg2) end
  if arg3 then table.insert(parse_table, arg3) end

  local size = #parse_table
  if size == 1 then
    local condition, spell = string.match(dsl, '(.+)%((.+)%)')
    return NetherMachine.dsl.comparator(condition, spell, spell)
  elseif size == 2 then
    local target = parse_table[1]
    local condition, condition_spell = NetherMachine.dsl.getConditionalSpell(parse_table[2], spell)
    condition = NetherMachine.dsl.conditionize(target, condition)
    if NetherMachine.dsl.conditionizers_single[target] then
      return NetherMachine.dsl.comparator(condition, parse_table[2], condition_spell)
    end
    return NetherMachine.dsl.comparator(condition, target, condition_spell)
  elseif size == 3 then
    local target = parse_table[1]
    local condition, condition_spell, subcondition = NetherMachine.dsl.getConditionalSpell(parse_table[2], spell)
    condition = NetherMachine.dsl.conditionize(target, condition)
    return NetherMachine.dsl.comparator(condition..'.'..parse_table[3], target, condition_spell)
  end
  NetherMachine.debug.print("Calling DSL: " .. dsl, 'dsl_call')
  return NetherMachine.dsl.get(dsl)('target', spell)
end

NetherMachine.dsl.get = function(condition)
  if NetherMachine.condition[condition] ~= nil then
    return NetherMachine.condition[condition]
  else
    NetherMachine.debug.print("Calling non-existant dsl condition: [" .. condition .. "]", 'dsl_no_exist')
    return (function() return false end)
  end
end

NetherMachine.dsl.notEval = function (condition, target, spell)
  return function ()
    return not NetherMachine.dsl.get(condition)(target, spell)
  end
end

NetherMachine.dsl.eval = function (condition, target, spell)
  return function ()
    return NetherMachine.dsl.get(condition)(target, spell)
  end
end

function peval(condition, target, spell)
  return NetherMachine.dsl.get(condition)(target, spell)
end

NetherMachine.dsl.register = function (condition, evaluation)
  NetherMachine.dsl[condition] = evaluation
end

NetherMachine.dsl.unregister = function (condition)
  NetherMachine.dsl[condition] = nil
end
