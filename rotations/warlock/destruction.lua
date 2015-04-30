-- SPEC ID 267
NetherMachine.rotation.register(267, {

  --------------------
  -- Start Rotation --
  --------------------

  	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },
	
	-- Auto Target
	{ {
		{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
		{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },
	},{ "toggle.autotarget" } },
	
  { "Dark Intent", "!player.buff" },
  { "Curse of the Elements", "!target.debuff" },

  -- Cooldowns
  { "Dark Soul: Instability", { 
    "modifier.shift", 
    "modifier.cooldowns",
  }},
  
  { "Summon Terrorguard", { 
    "modifier.control", 
    "modifier.cooldowns",
  }},
  
  { "Summon Doomguard", { 
    "modifier.control", 
    "modifier.cooldowns",
  }},

  -- Rotation
  { "Immolate", { 
    "!modifier.last(Immolate)", 
    "target.debuff(Immolate).duration <= 3",
  }},
  
  { "Shadowburn", "target.health <= 20" },
  { "Conflagrate" },
  { "Rain of Fire", "modifier.alt", "ground" },
  
  -- Moving
  {{
  { "Chaos Bolt", { 
    "!modifier.last(Chaos Bolt)", 
    "player.embers >= 35",
  }},
  
  { "Chaos Bolt", "player.buff(Dark Soul: Instability)" },
  { "Chaos Bolt", "player.buff(Skull Banner)" }},
 { "!player.moving", "target.health > 20" }},
  
  -- KJC Moving
  {{ 
  { "Incinerate", "player.spell(Kil'jaeden's Cunning).exists" },
  { "Fel Flame", "!player.spell(Kil'jaeden's Cunning).exists" }, 
  }, { "player.moving" }},
  { "Incinerate", { 
    "!player.moving", 
    "!player.spell(Kil'jaeden's Cunning).exists",
  }},
  
  ------------------
  -- End Rotation --
  ------------------
  
}, {

  ---------------
  -- OOC Begin --
  ---------------

	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" }, 
	
	{ "Dark Intent", "!player.buff" },
	
  {{
  
  { "Summon Felhunter", { 
    "!modifier.last(Summon Felhunter)", 
    "!player.spell(Grimoire of Supremacy).exists",
  }},
  
  { "Summon Observer", { 
    "!modifier.last(Summon Observer)", 
    "player.spell(Grimoire of Supremacy).exists",
  }},
  
  }, { "!player.moving", "!pet.exists" }},
  
  { "Grimoire of Sacrifice", { 
    "player.spell(Grimoire of Sacrifice).exists", 
    "!player.buff", 
    "pet.exists",
  }}
  
  -------------
  -- OOC End --
  -------------
},

---- *** TOGGLE BUTTONS ***
function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')

end)
