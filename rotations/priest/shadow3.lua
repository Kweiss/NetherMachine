-- SPEC ID 62
NetherMachine.rotation.register_custom(258, '|cff69ACC8Magiheals|r',{

  -- Cooldowns
  -- Build Phase
   { "Shadowfiend", "player.buff(Voidform).count > 9"},
   
  { "Void Bolt"	, "player.buff(Voidform)"																},
  { "Void Eruption" 																					},
  { "Mind Blast", "!player.buff(Voidform)"																},
  { "Shadow Word: Pain", {"!player.buff(Voidform)", "target.debuff(Shadow Word: Pain).duration < 3"		}},
  { "Vampiric Touch",    {"!player.buff(Voidform)", "target.debuff(Vampiric Touch).duration < 3"  		}},
  { "Mind Flay", "!player.buff(Voidform)"																},
  
  -- Void Form 
  { "/run RunMacro('sdf');", {"player.casting.percent <= 100", "player.spell(Void Bolt).cooldown = 0", "player.buff(Voidform)"  }},
  { "Power Infusion", { "modifier.cooldowns", "player.buff(Voidform)"									}},
  { "Void Torrent", "player.buff(Voidform)"																},
  
  { "Shadowfiend", {"player.buff(Voidform)",  "modifier.cooldowns", "player.buff(218413).count  > 9"	}},
  { "Shadowfiend", {"player.buff(Voidform)",  "modifier.cooldowns", "player.buff(194249).count  > 9"	}},
 
  
  { "Shadow Word: Death",  {"player.buff(Voidform)", "player.spell(Shadow Word: Death).charges > 1" 	}},
  { "Shadow Word: Death",  {"player.buff(Voidform)", "player.insane < 21", "player.spell(Mind Blast).cooldown < 1" 	}},
  { "Mind BLast", "player.buff(Voidform)"																},
  { "Vampiric Touch",    {"player.buff(Voidform)", "target.debuff(Vampiric Touch).duration < 3" 		}},
  { "Shadow Word: Pain", {"player.buff(Voidform)", "target.debuff(Shadow Word: Pain).duration < 3"		}},
  { "Mind Flay", "player.buff(Voidform)"																},
  
  
  { "Power Word: Shield", "player.health < 90"},
  { "Shadow Mend", { "!player.debuff(Shadow Mend)", "player.health < 50"}},
 -- { "Void Eruption" }, --, "player.insane = 100" },
  
  
  
  

 -- Spend / Maintain
-- { "/run CastSpellByName('Void Eruption');","!lastcast(Void Eruption)" },
 --{ "/run CastSpellByName('Void Eruption');",  "player.spell(Void Eruption).cooldown < 1"},
 
 
 
 --{ "Mindbender", {"player.buff(Voidform)",  "modifier.cooldowns" }},

 
 --{ "Shadow Word: Pain", {"player.buff(Voidform)", "!target.debuff(Shadow Word: Pain)"}},
 
 

  --[[
  { "Power Infusion", "modifier.cooldowns" },
  { "Shadowfiend", "modifier.cooldowns" },

  -- Keybinds
  { "Mind Sear", "modifier.shift" },

  -- If Moving
  { "Shadow Word: Pain", "player.moving" },
  { "Cascade", "player.moving" },
  { "Halo", "player.moving" },
  { "Shadow Word: Death", "player.moving" },

  -- Rotation
  { "Mind Blast", "player.buff(Divine Insight)" },
  { "Devouring Plague", "player.shadoworbs = 3" },
  { "Mind Blast" },

  { "Shadow Word: Pain", "target.debuff(Shadow Word: Pain).duration < 3" },

  { "Mind Flay", "target.debuff(Devouring Plague)" },
  { "Cascade", },
  { "Halo" },
  { "Mind Spike", "player.buff(Surge of Darkness)" },
  { "Mind Flay" },
  { "Shadow Word: Death" },
--]]

  ------------------
  -- End Rotation --
  ------------------

  }, {

  ---------------
  -- OOC Begin --
  ---------------

  { "Shadow Form", "!player.buff(Shadowform)" },

  -------------
  -- OOC End --
  -------------

}, function()
  NetherMachine.toggle.create('burn', 'Interface\\ICONS\\Spell_mage_infernoblast', 'Burn Phase', 'Turn this on if you need something big to die!')
  NetherMachine.toggle.create('heals', 'Interface\\ICONS\\ability_priest_shadowyapparition', 'Heal Me', 'Turn this on to use healing while in combat')
end)
