-- SPEC ID 72
NetherMachine.rotation.register(72, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Buffs
  { "Berserker Rage" },

  -- Survival
  { "Rallying Cry", {
    "player.health < 15",
    "modifier.cooldowns",
  }},

  { "Die by the Sword", "player.health < 25" },
  { "Impending Victory", "player.health <= 85" },
  { "Victory Rush", "player.health <= 85" },

  -- Kicks
  { "Pummel", "modifier.interrupts" },
  { "Disrupting Shout", "modifier.interrupts" },

  -- Cooldowns
  { "Bloodbath", "modifier.cooldowns" },
  { "Avatar", "modifier.cooldowns" },
  { "Recklessness", "modifier.cooldowns" },
  { "Skull Banner", "modifier.cooldowns" },
  { "Bladestorm", "modifier.cooldowns" },

  -- AoE
  { "Thunder Clap", "modifier.multitarget", "target.range <= 5" },
  { "Whirlwind", "modifier.multitarget", "target.range <= 5" },
  { "Dragon Roar", "modifier.multitarget", "target.range <= 5" },

  -- Rotation
  { "Colossus Smash" },
  { "Bloodthirst" },
  { "Execute", "player.rage > 80" },
  { "Heroic Strike", "player.rage > 80" },
  { "Raging Blow" },
  { "Wild Strike", "player.buff(Bloodsurge)" },
  { "Impending Victory" },
  { "Heroic Throw" }

  ------------------
  -- End Rotation --
  ------------------

})




-- SPEC ID 72
NetherMachine.rotation.register_custom(72, '|cff69ACC8Fury Legion |r',{

--------------------
-- Start Rotation --
--------------------

{ "Berserker Rage", "player.state.fear" },
{ "Berserker Rage", "player.state.stun" },
{ "Berserker Rage", "player.state.root" },
{ "Berserker Rage", "player.state.horror" },

-- Kicks
{ "Pummel", "modifier.interrupts" },

-- Jump
{ "Heroic Leap", "modifier.shift", "ground" },

-- Regardless of anything, use these
{ "Avatar", "modifier.cooldowns"},
{ "Bloodthirst", "modifier.cooldowns"},
{ "Recklessness", "modifier.cooldowns" },
{ "Bloodbath", "modifier.cooldowns"},
--{ "Berserker Rage", "modifier.cooldowns"},

{"Battle Cry", "modifier.cooldowns" },


-- Single Target Rotation
{ "Rampage", {
"!player.buff(Enrage)",
"player.rage > 95"
}},
{ "Bloodthirst", "!player.buff(Enrage)" },
{ "Whirlwind", "player.buff(Wrecking Ball)" },
{ "Raging Blow" },
{ "Bloodthirst" },
{ "Furious Slash" },


------------------
-- End Rotation --
------------------

},{

---------------
-- OOC Begin --
---------------

-- Ground Stuff
{ "Heroic Leap", "modifier.shift", "ground" },

-------------
-- OOC End --
-------------
}, function()
NetherMachine.toggle.create('disable', 'Interface\\Icons\\spell_nature_rejuvenation', 'Disable', 'Toggle Disable')
end)
