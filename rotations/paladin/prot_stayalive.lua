--   SPEC ID 66
NetherMachine.rotation.register_custom(66, '|cff69ACC8DeathSquad Rotation Stay Alive|r',{

	{ "Hammer of Justice", "modifier.shift"								},
	{ "Hand of the Protector", "player.health < 50"},
	{ "Eye of Tyr", "player.health < 90"								},
	{ "Consecration", {"target.range <= 5" , "toggle.conc"}},
	{ "Judgment" 														},
{ "Avenger's Shield"	, "!toggle.sock" 							},
	--{ "#trinket1", "player.health < 100" },
	{ "Shield of the Righteous", {"target.range <= 5", "modifier.alt"						}},
	{ "#trinket2", {"player.health < 50", "player.spell(Shield of the Righteous).charges = 0","player.spell(Hand of the Protector).cooldown > 1" }},
	{ "Blessed Hammer"},

	{ "Avenger's Shield"	, "!toggle.sock" 							},
	{ "Avenger's Shield", "modifier.interrupts" 						},
	{ "Rebuke", { "target.range <= 5", "modifier.interrupts"			}},
    { "Arcane Torrent", {"modifier.interrupts", "target.range <= 5" 	}},
	{ "Ardent Defender", {"!player.buff(132403)", "player.health <= 50","player.spell(Hand of the Protector).cooldown > 1", "player.spell(Shield of the Righteous).charges = 0", "player.spell(Bastion of Light).cooldown > 1"  }},
	{ "53600",{"!player.buff(132403)" , "player.spell(Shield of the Righteous).charges > 1", "player.health < 80" }},
	{ "53600", { "player.health < 60", "player.spell(Hand of the Protector).cooldown > 1"}},
	{  "/use Shieldtronic Shield", {"modifier.alt", "player.spell(Shield of the Righteous).charges < 1"}},
	--213652
	--{ "213652", "player.health < 80"},

	--{ "Shield of the Righteous", { "player.buff(Shield of the Righteous).count > 1", "!player.buff(132403)" }		},
	--{ "Shield of the Righteous", { "player.buff(Shield of the Righteous).count > 1", "!player.buff(Shield of the Righteous)" }		},

	{ "Bastion of Light",{"!player.buff(132403)", "player.health <= 50","player.spell(Hand of the Protector).cooldown > 1", "player.spell(Shield of the Righteous).charges = 0"  }},
	--{ "Shield of the Righteous"},
	{ "Blinding Light", {"modifier.multitarget","target.range <= 5" }},
	-- cff69ACC8

	--{ "53600" , { "!player.buff(53600)" , "player.spell(Shield of the Righteous).charges > 1" }},
	--{ "Shield of the Righteous" , { "!player.buff(Shield of the Righteous)" , "player.spell(Shield of the Righteous).charges > 1" }},

	{ "31884", "modifier.cooldowns" }, -- Avenging Wrath
	{ "Seraphim", "modifier.cooldowns"								},

	{ "Hammer of the Righteous" 				},


	    -- Check to interupt
     -- { "Execution Sentence", "toggle.stayalive" 						},
      { "Seraphim", "toggle.stayalive"								},
     -- { "Holy Avenger", "toggle.stayalive" 							},
     -- { "Holy Prism" 						},
     -- { "Sacred Shield",  {"!player.buff(Sacred Shield)", "toggle.stayalive"					    	}},

     -- { "Shield of the Righteous", {"player.buff(Shield of the Righteous).count < 4", "!player.buff(Shield of the Rghteous)"}},

 -- { "Shield of the Righteous", { "player.buff(Shield of the Righteous).count < 4", "!player.buff(132403)" }		},
     -- { "Eternal Flame", "!player.buff(Eternal Flame)"					},
	  --{ "Guardian of Ancient Kings", "player.uts = 3" },
	--  { "Seal of Insight", {"player.uts = 3", "player.seal != 2"} },
	 -- { "Seal of Righteous", { "player.uts < 3", "player.seal != 1"} },
	 --{ "Ardent Defender",   "player.threat = 3" },
	 -- { "Avenger's Shield"	, "!toggle.sock" 				   							},
     -- { "Avenger's Shield", "modifier.interrupts" 						},


      --{ "Divine Protection", "modifier.alt" },
     --
     -- { "Seraphim", "modifier.cooldowns"								}, -- change
     -- { "Holy Avenger", "modifier.cooldowns" 							}, -- change
     -- { "Execution Sentence", "modifier.cooldowns" 						}, -- change

--{ "pause", "modifier.lshift" },
    -- Check for Procs
     -- { "Avenger's Shield", {"player.buff(Grand Crusader)", "!toggle.sock" 				}},
      --{ "Shield of the Righteous", {"target.range <= 5","player.buff(Divine Purpose)"	    }},
     -- { "Shield of the Righteous", "player.spell(Seraphim).cooldown > 9"},
     -- { "Word of Glory", {"player.buff(Bastion of Glory).count = 5", "player.health < 50"	}},

    -- SOR Set to go at 5.
      --{ "Shield of the Righteous", {"target.range <= 5", "modifier.alt"						}},
     -- { "Shield of the Righteous", { "target.range <= 5","player.holypower > 4" ,"toggle.pally_toggle" 				}}, -- rem out for Saraphim

    -- Generate Holy Power
      { "Hammer of the Righteous", "modifier.multitarget" 				},
    --  { "Crusader Strike", "target.range <= 5" 												},
      { "Judgment" 														},
      { "Consecration", {"target.range <= 5" , "toggle.conc"}}, --, "modifier.multitarget"				  	},



    -- Oh shit button 'alt'



    -- Time to use Cooldowns ?
      { "Execution Sentence", "modifier.cooldowns" 						},
      { "Seraphim", "modifier.cooldowns"								},
      { "Holy Avenger", "modifier.cooldowns" 							},
      { "Holy Prism" , "modifier.cooldowns" 							},
      { "Sacred Shield",  "modifier.cooldowns"					    	},


      --{ "Eternal Flame", "!player.buff(Eternal Flame)"					},

    -- Well, nothing else to do so lets cause some more damage
     -- { "Hammer of Wrath" 												},
	  --{ "Consecration", "target.range <= 5" }, --, "modifier.multitarget"				  	},
	 -- { "Word of Glory", {"player.buff(Bastion of Glory).count = 5", "player.health < 50"	}},
	 -- { "Holy Wrath", "target.range <= 5"  								},

  --  { "Shield of the Righteous", "player.spell(Seraphim).cooldown > 9"},
 --   { "Shield of the Righteous"										}, -- Rem this line for Seraphim


 --]]

  },

  {
	  -- Out of COmbat Buffing Buffing
	  --{"Blessing of Might", "!player.buff(Blessing of Might)"},
	   { "Righteous Fury",    "!player.buff(Righteous Fury)" },
	  -- { "/use Empowered Augment Rune", "!player.buff(Stout Augmentation)"},


}


, function()
	-- "toggle.custom_toggle_name"
		NetherMachine.toggle.create('pally_toggle', 'Interface\\ICONS\\inv_shield_04', 'Pally Toggle', 'Description')
		NetherMachine.toggle.create('conc', 'Interface\\ICONS\\Spell_Holy_ImpHolyConcentration', 'conc', 'Description')
		NetherMachine.toggle.create('sock', 'Interface\\ICONS\\inv_shield_03', 'AS Interupt All', 'Only use Avenger Shield to Interupt when On')
		NetherMachine.toggle.create('stayalive', 'Interface\\ICONS\\inv_shield_04', 'Stay Alive', 'StayAlive')
end)
