NetherMachine.condition = {

}

NetherMachine.condition.register = function(name, evaluation)
  NetherMachine.condition[name] = evaluation
end

NetherMachine.condition.unregister = function(name)
  NetherMachine.condition[name] = nil
end
