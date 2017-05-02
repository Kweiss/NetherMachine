-- SPEC ID 63
NetherMachine.rotation.register_custom(63, '|cff69ACC8Fire Mage 7.2|r', {
-- PLAYER CONTROLLED: Temporal Shield, Blizzard, Blink, Frost Bomb
-- SUGGESTED TALENTS:
-- CONTROLS: Pause - Left Control
-- 48108 Hot Streak!
-- 48107 Heating Up

-- { "11366"},

--
{ "pause", "player.buff(Ice Block)"},
{ "pause", { "player.buff(Kael'thas's Ultimate Ability)", "player.casting(Pyroblast)"}},
{ "Pyroblast", { "player.buff(Kael'thas's Ultimate Ability)", "!player.buff(48108)", "!modifier.last(Pyroblast)"}},
{ "Meteor", { "modifier.shift", "!player.moving" }, "target.ground"},
{ "Flamestrike", { "modifier.shift", "player.buff(48108)" }, "target.ground"},
{ "Pyroblast",    "player.buff(48108)"},
{"Blazing Barrier", {"!player.buff(Blazing Barrier)", "!player.casting", "player.falling"}},
{ "#trinket1", "toggle.trinkets" },
{ "#trinket2", "toggle.trinkets" },
{ "Counterspell", "modifier.interrupts" },
{ "Living Bomb", {"!target.buff(Living Bomb)", "!player.buff(48108)", "!player.buff(48107)", "!player.buff(Kael'thas's Ultimate Ability)", "modifier.multitarget"}},

{ "Combustion", "toggle.burn"},
{ "Combustion", "player.buff(Rune of Power)"},
{ "Mirror Image", "modifier.cooldowns"},

{ "Pyroblast",   { "player.buff(48108)", "!player.lastcast(Pyroblast)"}},
{ "Flame On", {"player.spell(Fire Blast).charges < 1", "modifier.cooldowns"}},
{ "Fire Blast",  { "player.buff(48107)", "!player.lastcast(Fire Blast)", "!player.lastcast(Phoenix's Flames)"}},
{ "Phoenix's Flames", {"player.buff(48107)", "player.spell(Fire Blast).charges < 1", "!player.lastcast(Phoenix's Flames)", "toggle.flames"}},
--{ "Phoenix's Flames", { "!player.buff(48108)", "player.spell(Combustion).cooldown > 45"}},
{ "/run CastSpellByName('Fire Blast');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0"  }},
{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48108)"  }},
{ "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.buff(48107)", "player.spell(Fire Blast).charges > 0", "player.spell(Phoenix's Flames).charges > 0"   }},
{ "Spellsteal", "target.stealable", "target" 						},
{ "Ice Floes", {"player.moving", "!player.buff(Ice Floes)"}},
{ "Scorch", {"player.moving","!player.buff(Ice Floes)", "!player.buff(48108)" }},


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
{ "Dragon's Breath", { "!player.buff(48108)", "!player.buff(48107)","target.range <= 10", "toggle.dragons", "talent(4, 1)"}},
{ "Cinderstorm", {"target.debuff(Ignite)", "toggle.cinderstorm"}},
--{ "/run RunMacro('sdf');", {"player.lastcast(Pyroblast)", "!player.buff(Kael'thas's Ultimate Ability)"}},
--{ "Pyroblast", { "player.buff(Kael'thas's Ultimate Ability)", "!player.buff(48108)", "!lastcast(11366)"}},
--{ "/run RunMacro('sdf');", {"player.casting(Pyroblast)", "!player.buff(Kael'thas's Ultimate Ability)" }},
{ "Scorch", { "target.health < 30", "toggle.usescorch"}},
{ "Fireball", "!player.buff(Combustion)" },
{ "Fireball", "player.buff(Combustion)"},


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
	
	{ "Fireball", "!player.buff(Heating Up)"},
--]]
-- ability_mage_moltenarmor
  ------------------
  -- End Rotation --
  ------------------
},{
	-- OUT OF COMBAT
{ "Blazing Barrier", {"!player.buff(Blazing Barrier)", "player.moving"}}, -- , "toggle.bubble"
{ "Slow Fall", {"!player.buff(Slow Fall)",  "player.falling"}}, -- "toggle.slowfall",
{  "/cast Combustion", { "player.casting", "!player.buff(48107)", "!player.buff(48108)", "player.casting.percent <= 10", "modifier.cooldowns", "toggle.raiding" }},
},
function()
  NetherMachine.toggle.create('burn', 'Interface\\ICONS\\spell_fire_sealoffire', 'burn', 'Combustion will be used')
   NetherMachine.toggle.create('trinkets', 'Interface\\ICONS\\sha_spell_fire_bluepyroblast_nightmare', 'Trinkets', 'Use your Trinkets on CD')
 
 
  NetherMachine.toggle.create('cinderstorm', 'Interface\\ICONS\\spell_fire_flare', 'Use Cinderstorm!', 'Turn off if your pulling to many adds')
  NetherMachine.toggle.create('dragons', 'Interface\\ICONS\\inv_misc_head_dragon_01', 'Use Dragons Breath', 'Turn on when talented with Dragons Breath')
  NetherMachine.toggle.create('raiding', 'Interface\\ICONS\\Achievement_boss_general_nazgrim', 'PreCast', 'Will Combust on Pull')
 
   NetherMachine.toggle.create('flames', 'Interface\\ICONS\\artifactability_firemage_phoenixbolt', 'Use Flames!', 'Phoenix Flames Will be Used')
   NetherMachine.toggle.create('usescorch', 'Interface\\ICONS\\Spell_fire_soulburn', 'Use Scorch', 'If you have the Lego Waist use this')
  --NetherMachine.toggle.create('slowfall', 'Interface\\ICONS\\spell_magic_featherfall', 'Slow Fall', 'Auto Slow Fall')
   --NetherMachine.toggle.create('bubble', 'Interface\\ICONS\\ability_mage_moltenarmor', 'bubble', 'Blazing Barrier will now be used when not in combat')
end)








