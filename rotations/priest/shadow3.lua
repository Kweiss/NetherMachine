-- SPEC ID 62
NetherMachine.rotation.register_custom(258, '|cff69ACC8Shadow Squad|r',{

  -- Cooldowns
  -- Build Phase
  { "Power Word: Shield", "player.health < 90"},
  { "Shadow Mend", { "!player.debuff(Shadow Mend)", "player.health < 50"}},
  { "Void Eruption" }, --, "player.insane = 100" },
  { "Mind BLast", "!player.buff(Voidform)"},
  { "Shadow Word: Pain", {"!player.buff(Voidform)", "target.debuff(Shadow Word: Pain).duration < 3"}},
  { "Vampiric Touch",    {"!player.buff(Voidform)", "target.debuff(Vampiric Touch).duration < 3" }},
  { "Mind Flay", "!player.buff(Voidform)"},

 -- Spend / Maintain
-- { "/run CastSpellByName('Void Eruption');","!lastcast(Void Eruption)" },
 { "/run CastSpellByName('Void Eruption');",  "player.spell(Void Eruption).cooldown < 1"},
 { "Void Eruption", {"player.buff(Voidform)", "player.insane > 10"}},
 { "Void Torrent"},
 { "Shadowfiend", {"player.buff(Voidform)",  "modifier.cooldowns" }},
 { "Mindbender", {"player.buff(Voidform)",  "modifier.cooldowns" }},
 { "Shadow Word: Death",  {"player.buff(Voidform)", "player.spell(Shadow Word: Death).charges > 1" }},
 { "Mind Blast", "player.buff(Voidform)"},
 { "Shadow Word: Pain", {"player.buff(Voidform)", "!target.debuff(Shadow Word: Pain)"}},
 { "Vampiric Touch",    {"player.buff(Voidform)", "!target.debuff(Vampiric Touch)" }},
 { "Mind Flay", "player.buff(Voidform)"},

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
end)
