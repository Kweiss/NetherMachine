NetherMachine.set = {
    set = { }
}

NetherMachine.set.new = function ()
    return NetherMachine.set
end

NetherMachine.set.add = function (key, value)
    NetherMachine.set.set[key] = value
end

NetherMachine.set.remove = function (key)
    NetherMachine.set.set[key] = nil
end
NetherMachine.set.contains = function (key)
    return NetherMachine.set.set[key] ~= nil
end


NetherMachine.rotations = NetherMachine.set.new()
