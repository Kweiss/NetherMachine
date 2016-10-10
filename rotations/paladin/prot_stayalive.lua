--   SPEC ID 66
NetherMachine.rotation.register_custom(66, '|cff69ACC8DeathSquad Rotation Stay Alive|r',{


	{ "Hammer of Justice", "modifier.shift"								},
	----------------------------------
	----   Active Mitigation   ----
	----------------------------------
	{ "Hand of the Protector", "player.health < 50"},
	{ "Eye of Tyr", "player.health < 90"								},

	{ "Consecration", {"target.range <= 5" , "toggle.conc"}},

	{ "Judgment", },
	{ "Avenger's Shield"	, "!toggle.sock" },

	{ "Shield of the Righteous", {"target.range <= 5", "modifier.alt"	}},

	{ "#trinket2", {"player.health < 50", "player.spell(Shield of the Righteous).charges = 0","player.spell(Hand of the Protector).cooldown > 1" }},

	{ "Blessed Hammer"},

	{ "Avenger's Shield", "!toggle.sock" },

	----------------------------------
	----   Interrupts   ----
	----------------------------------
	{ "Avenger's Shield", "modifier.interrupts" },
	{ "Rebuke", { "target.range <= 5", "modifier.interrupts" } },
  { "Arcane Torrent", {"modifier.interrupts", "target.range <= 5" 	}},

	----------------------------------
	----   Cast Stuff   ----
	----------------------------------
	{ "Ardent Defender", {"!player.buff(132403)", "player.health <= 50", "player.spell(Hand of the Protector).cooldown > 1", "player.spell(Shield of the Righteous).charges = 0", "player.spell(Bastion of Light).cooldown > 1"  }},
	{ "53600", {"!player.buff(132403)" , "player.spell(Shield of the Righteous).charges > 1", "player.health < 80" }},
	{ "53600", { "player.health < 60", "player.spell(Hand of the Protector).cooldown > 1"}},
	{  "/use Shieldtronic Shield", {"modifier.alt", "player.spell(Shield of the Righteous).charges < 1"}},

	{ "Bastion of Light",{"!player.buff(132403)", "player.health <= 50","player.spell(Hand of the Protector).cooldown > 1", "player.spell(Shield of the Righteous).charges = 0"  }},

	{ "Blinding Light", {"modifier.multitarget","target.range <= 5" }},

	----------------------------------
	----   Cooldowns   ----
	----------------------------------

	{ "31884", "modifier.cooldowns" }, -- Avenging Wrath
	{ "Seraphim", "modifier.cooldowns" },

	----------------------------------
	----   Cast Stuff   ----
	----------------------------------

	{ "Hammer of the Righteous" },

  { "Seraphim", "toggle.stayalive" },

  { "Hammer of the Righteous", "modifier.multitarget" },
  { "Judgment" },
  { "Consecration", {"target.range <= 5" , "toggle.conc"} },

	----------------------------------
	----   Cooldowns   ----
	----------------------------------

  { "Execution Sentence", "modifier.cooldowns" 						},
  { "Seraphim", "modifier.cooldowns"								},
  { "Holy Avenger", "modifier.cooldowns" 							},
  { "Holy Prism" , "modifier.cooldowns" 							},
  { "Sacred Shield",  "modifier.cooldowns"					    	},

},{
	{ "Righteous Fury",    "!player.buff(Righteous Fury)" },

}, function()
	-- "toggle.custom_toggle_name"
		NetherMachine.toggle.create('pally_toggle', 'Interface\\ICONS\\inv_shield_04', 'Pally Toggle', 'Description')
		NetherMachine.toggle.create('conc', 'Interface\\ICONS\\Spell_Holy_ImpHolyConcentration', 'conc', 'Description')
		NetherMachine.toggle.create('sock', 'Interface\\ICONS\\inv_shield_03', 'AS Interupt All', 'Only use Avenger Shield to Interupt when On')
		NetherMachine.toggle.create('stayalive', 'Interface\\ICONS\\inv_shield_04', 'Stay Alive', 'StayAlive')
end)
