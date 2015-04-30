local LibDispellable = LibStub("LibDispellable-1.0")

NetherMachine.states = { }
NetherMachine.states.status = {}
NetherMachine.states.status.charm = {
    "^charmed"
}
NetherMachine.states.status.disarm = {
    "disarmed"
}
NetherMachine.states.status.disorient = {
    "^disoriented"
}
NetherMachine.states.status.dot = {
    "damage every.*sec", "damage per.*sec"
}
NetherMachine.states.status.fear = {
    "^horrified", "^fleeing", "^feared", "^intimidated", "^cowering in fear",
    "^running in fear", "^compelled to flee"
}
NetherMachine.states.status.incapacitate = {
    "^incapacitated", "^sapped"
}
NetherMachine.states.status.misc = {
    "unable to act", "^bound", "^frozen.$", "^cannot attack or cast spells",
    "^shackled.$"
}
NetherMachine.states.status.root = {
    "^rooted", "^immobil", "^webbed", "frozen in place", "^paralyzed",
    "^locked in place", "^pinned in place"
}
NetherMachine.states.status.silence = {
    "^silenced"
}
NetherMachine.states.status.sleep = {
    "^asleep"
}
NetherMachine.states.status.snare = {
    "^movement.*slowed", "movement speed reduced", "^slowed by", "^dazed",
    "^reduces movement speed"
}
NetherMachine.states.status.stun = {
    "^stunned", "^webbed"
}
NetherMachine.states.immune = {}
NetherMachine.states.immune.all = {
    "dematerialize", "deterrence", "divine shield", "ice block"
}
NetherMachine.states.immune.charm = {
    "bladestorm", "desecrated ground", "grounding totem effect", "lichborne"
}
NetherMachine.states.immune.disorient = {
    "bladestorm", "desecrated ground"
}
NetherMachine.states.immune.fear = {
    "berserker rage", "bladestorm", "desecrated ground", "grounding totem",
    "lichborne", "nimble brew"
}
NetherMachine.states.immune.incapacitate = {
    "bladestorm", "desecrated ground"
}
NetherMachine.states.immune.melee = {
    "dispersion", "evasion", "hand of protection", "ring of peace", "touch of karma"
}
NetherMachine.states.immune.misc = {
    "bladestorm", "desecrated ground"
}
NetherMachine.states.immune.silence = {
    "devotion aura", "inner focus", "unending resolve"
}
NetherMachine.states.immune.polly = {
    "immune to polymorph"
}
NetherMachine.states.immune.sleep = {
    "bladestorm", "desecrated ground", "lichborne"
}
NetherMachine.states.immune.snare = {
    "bestial wrath", "bladestorm", "death's advance", "desecrated ground",
    "dispersion", "hand of freedom", "master's call", "windwalk totem"
}
NetherMachine.states.immune.spell = {
    "anti-magic shell", "cloak of shadows", "diffuse magic", "dispersion",
    "massspell reflection", "ring of peace", "spell reflection", "touch of karma"
}
NetherMachine.states.immune.stun = {
    "bestial wrath", "bladestorm", "desecrated ground", "icebound fortitude",
    "grounding totem", "nimble brew"
}

NetherMachine.condition.register("state.purge", function(target, spell)
  if LibDispellable:CanDispelWith(target, GetSpellID(GetSpellName(spell))) then
    return true
  end
  return false
end)

NetherMachine.condition.register("state.charm", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.charm, 'debuff')
end)

NetherMachine.condition.register("state.disarm", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.disarm, 'debuff')
end)

NetherMachine.condition.register("state.disorient", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.disorient, 'debuff')
end)

NetherMachine.condition.register("state.dot", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.dot, 'debuff')
end)

NetherMachine.condition.register("state.fear", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.fear, 'debuff')
end)

NetherMachine.condition.register("state.incapacitate", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.incapacitate, 'debuff')
end)

NetherMachine.condition.register("state.misc", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.misc, 'debuff')
end)

NetherMachine.condition.register("state.root", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.root, 'debuff')
end)

NetherMachine.condition.register("state.silence", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.silence, 'debuff')
end)

NetherMachine.condition.register("state.sleep", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.sleep, 'debuff')
end)

NetherMachine.condition.register("state.snare", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.snare, 'debuff')
end)

NetherMachine.condition.register("state.stun", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.status.stun, 'debuff')
end)

NetherMachine.condition.register("immune.all", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.all)
end)

NetherMachine.condition.register("immune.charm", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.charm)
end)

NetherMachine.condition.register("immune.disorient", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.disorient)
end)

NetherMachine.condition.register("immune.fear", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.fear)
end)

NetherMachine.condition.register("immune.incapacitate", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.incapacitate)
end)

NetherMachine.condition.register("immune.melee", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.melee)
end)

NetherMachine.condition.register("immune.misc", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.misc)
end)

NetherMachine.condition.register("immune.silence", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.silence)
end)

NetherMachine.condition.register("immune.poly", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.polly)
end)

NetherMachine.condition.register("immune.sleep", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.sleep)
end)

NetherMachine.condition.register("immune.snare", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.snare)
end)

NetherMachine.condition.register("immune.spell", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.spell)
end)

NetherMachine.condition.register("immune.stun", function(target, spell)
  return NetherMachine.tooltip.scan(target, NetherMachine.states.immune.stun)
end)
