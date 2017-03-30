-- SPEC ID 64
NetherMachine.rotation.register_custom(64, '|cff69ACC8Frost Squad|r',{
	
{ "Spellsteal", "target.stealable", "target" 						},
{ "Blizzard", { "modifier.shift", "!player.moving" }, "target.ground"},
{ "Glacial Spike", {"modifier.multitarget", "!player.buff(Brain Freeze)"}},
{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(Brain Freeze)"  }},
{ "Ice Floes", {"player.moving", "!player.buff(Ice Floes)"}},
{ "Counterspell", "modifier.interrupt" },
{ "Mirror Image", "modifier.cooldowns"},
{ "Icy Veins", { "!player.buff(Icy Veins)", "modifier.cooldowns"}},
{ "Ebonbolt", {"modifier.cooldowns", "!player.buff(Brain Freeze)"}},
{ "Ice Lance", "player.buff(Fingers of Frost).count > 2"},
{ "Flurry", "player.buff(Brain Freeze)"},
{ "Frost Bomb", { "target.debuff.remains < 1.5", "!player.lastcast(Frost Bomb)"}},
{ "Ice Lance", "player.lastcast(Flurry)"},
{ "Water Jet", "player.buff(Fingers of Frost).count < 1"},
{ "Ice Lance", "player.buff(Fingers of Frost).count >= 1"},
{ "Frozen Orb", "modifier.multitarget"},
{ "Frostbolt"},
--[[
{ "Living Bomb", "!target.buff(Living Bomb)"},

{ "Combustion", "toggle.burn"},
{ "Combustion", "player.buff(Rune of Power)"},


{ "Pyroblast",   { "player.buff(48108)", "!player.lastcast(Pyroblast)"}},
{ "Flame On", {"player.spell(Fire Blast).charges < 1",  "player.spell(Phoenix's Flames).charges < 1"}},
{ "Fire Blast",  { "player.buff(48107)", "!player.lastcast(Fire Blast)", "!player.lastcast(Phoenix's Flames)"}},
{ "Phoenix's Flames", {"player.buff(48107)", "player.spell(Fire Blast).charges < 1", "!player.lastcast(Phoenix's Flames)"}},
{ "/run CastSpellByName('Fire Blast');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0"  }},
{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48108)"  }},
{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0", "player.spell(Phoenix's Flames).charges > 0"   }},


{ "Scorch", {"player.moving","!player.buff(Ice Floes)" }},

--{-- "/cast Pyroblast", {"player.casting.percent <= 100", "player.buff(48107)", "!player.lastcast(Pyroblast)", "target" }},
--{ --"/cast Fire Blast", { "player.buff(48107)", "player.casting"}},
--{ --"/cast Pyroblast",  { "player.buff(48108)", "player.casting"}},


-- Working ok from here 
--{ "/cast Pyroblast", { "player.buff(48108)", function() local s,_=UnitChannelInfo("player"); return s and s == 'Fireball' end } }, 
--{ "/cast Fire Blast", { "player.buff(48107)", function() local s,_=UnitChannelInfo("player"); return s and s == 'Fireball' end } }, 

{ "Rune of Power", {"!player.buff(Rune of Power)", "modifier.cooldowns"}},

{ "Blazing Barrier", "player.health < 50"},

--{ "/run CastSpellByName('Pyroblast');", { "player.buff(Hot Streak!)", "player.casting" } },
--{ "Pyroblast", { "player.buff(Hot Streak!)", "player.casting"}},
--{ "/run CastSpellByName('Fire Blast');", { "player.buff(48107)", "player.casting" } },
--{ "Fire Blast", { "player.buff(48107)", "player.casting"}},
--{ "Phoenix's Flames", {"player.buff(Rune of Power)", "player.spell(Fire Blast).charges < 1"}},
--{ "Pyroblast", {"player.buff(Hot Streak!)", "!lastcast(Pyroblast)"}},
--{ "Fire Blast", "player.buff(48107)"}, -- Heating Up
{ "Dragon's Breath", { "!player.buff(48108)", "target.range <= 15"}},
{ "Cinderstorm", "target.debuff(Ignite)"},
{ "Fireball"},

{ "Ice Barrier", "player.health < 30"}, 
--{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0"  }},
--{ "Fire Blast" , "player.spell(Fire Blast).charges > 1" },
--]]
--[[
	{ "Pyroblast", {"player.buff(Hot Streak!)", "player.casting"}},
	{ "Pyroblast", "player.buff(Hot Streak!)"},

	{ "/run CastSpellByName('Fire Blast');", { "player.buff(Heating Up)", "player.casting" } },
	{ "/run CastSpellByName('Fire Blast');", "player.buff(Heating Up)" },
	{ "Pyroblast", "lastcast(Fire Blast)"},
	{ "108853", "player.buff(Heating Up)",  "player.casting"}, -- "!lastcast",
	{ "Fire Blast", {"player.buff(Heating Up)",  "!lastcast"}},

	{ "Fire Blast", {"modifier.interrupts", "player",  },

	{ "Flame On", "player.spell(Fire Blast).charges < 1"},

	{ "Fire Blast", {"player.buff(Heating up)", "!lastcast"}},
	{ "Blast Wave", {"lastcast(Fireball)", "!player.buff(Heating Up)"}},
	
	{ "Fireball", "!player.buff(Heating Up)"},
--]]
-- ability_mage_moltenarmor
  ------------------
  -- End Rotation -- 
  ------------------
  

  },{

  ---------------
  -- OOC Begin --
  ---------------

{"Blazing Barrier", {"!player.buff(Blazing Barrier)", "toggle.bubble"}},

  -------------
  -- OOC End --
  -------------

}, function()
  NetherMachine.toggle.create('burn', 'Interface\\ICONS\\spell_fire_sealoffire', 'burn', 'Comustion will be used')
  NetherMachine.toggle.create('bubble', 'Interface\\ICONS\\ability_mage_moltenarmor', 'bubble', 'Blazing Barrier will now be used')
end)
