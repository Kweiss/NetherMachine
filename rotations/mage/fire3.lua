-- SPEC ID 63
NetherMachine.rotation.register_custom(63, '|cff69ACC8Fire Squad|r',{

-- "!modifier.last(Regrowth)", 

--
--[[{ "Blink", "player.casting"},
{ "Fireball"},

  { "Skull Bash", { 
    "target.casting", 
    "modifier.interrupt" 
  }},--]]
--{ "Blink", "player.casting"},
--{ "Fireball"},
{ "Ice Barrier", "player.health < 100"}, 
{ "Pyroblast",   { "player.buff(48108)", "!player.lastcast(Pyroblast)"}},
{ "Flame On", {"player.spell(Fire Blast).charges < 1",  "player.spell(Phoenix's Flames).charges < 1"}},
{ "Fire Blast",  { "player.buff(48107)", "!player.lastcast(Fire Blast)", "!player.lastcast(Phoenix's Flames)"}},
{ "Phoenix's Flames", {"player.buff(48107)", "player.spell(Fire Blast).charges < 1", "!player.lastcast(Phoenix's Flames)"}},
{ "/run CastSpellByName('Fire Blast');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0"  }},
{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48108)"  }},
{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0", "player.spell(Phoenix's Flames).charges > 0"   }},
 { "Spellsteal", "target.stealable", "target" 						},
{ "Ice Floes", {"player.moving", "!player.buff(Ice Floes"}},


--{-- "/cast Pyroblast", {"player.casting.percent <= 100", "player.buff(48107)", "!player.lastcast(Pyroblast)", "target" }},
--{ --"/cast Fire Blast", { "player.buff(48107)", "player.casting"}},
--{ --"/cast Pyroblast",  { "player.buff(48108)", "player.casting"}},


-- Working ok from here 
--{ "/cast Pyroblast", { "player.buff(48108)", function() local s,_=UnitChannelInfo("player"); return s and s == 'Fireball' end } }, 
--{ "/cast Fire Blast", { "player.buff(48107)", function() local s,_=UnitChannelInfo("player"); return s and s == 'Fireball' end } }, 

{ "Rune of Power", {"!player.buff(Rune of Power)", "modifier.cooldowns"}},

{ "Combustion", "player.buff(Rune of Power)"},

--{ "/run CastSpellByName('Pyroblast');", { "player.buff(Hot Streak!)", "player.casting" } },
--{ "Pyroblast", { "player.buff(Hot Streak!)", "player.casting"}},
--{ "/run CastSpellByName('Fire Blast');", { "player.buff(48107)", "player.casting" } },
--{ "Fire Blast", { "player.buff(48107)", "player.casting"}},
--{ "Phoenix's Flames", {"player.buff(Rune of Power)", "player.spell(Fire Blast).charges < 1"}},
--{ "Pyroblast", {"player.buff(Hot Streak!)", "!lastcast(Pyroblast)"}},
--{ "Fire Blast", "player.buff(48107)"}, -- Heating Up
{ "Fireball"},
--{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0"  }},
--{ "Fire Blast" , "player.spell(Fire Blast).charges > 1" },

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
	{ "Dragon's Breath", {"lastcast(Fireball)", "!player.buff(Heating Up)"}},
	{ "Fireball", "!player.buff(Heating Up)"},
--]]

  ------------------
  -- End Rotation --
  ------------------

  },{

  ---------------
  -- OOC Begin --
  ---------------
  { "Arcane Brilliance", "!player.buff(Arcane Brilliance)"},
  { "1459", "!player.buff" }, -- Arcane Brilliance

  -------------
  -- OOC End --
  -------------

}, function()
  NetherMachine.toggle.create('burn', 'Interface\\ICONS\\Spell_mage_infernoblast', 'Burn Phase', 'Turn this on if you need something big to die!')
end)
