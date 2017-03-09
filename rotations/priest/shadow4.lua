-- TALENTS:   15: Twist of Fate (Shadow Priest) 60: Lingering Insanity (Shadow Priest) 75: Shadowy Insight (Shadow Priest) 90: Power Infusion (Shadow Priest) 100: Shadow Crash (Shadow Priest)
-- ( Pawn: v1: "Shadow - Dungeon - SL": Intellect=1, HasteRating=1.02, MasteryRating=1.44, CritRating=1, Versatility=0.96 )
-- SPEC ID 62
NetherMachine.rotation.register_custom(258, "|cFF99FF00Legion |cFFFF6600Shadow Priest |cFFFF9999(Legion Basic)", {

  --Some Shadow DPS

  -- Interrupts
  { "Arcane Torrent", {"target.interruptAt(75)", "modifier.interrupt", "target.range <= 8", "!modifier.last(Silence)" }},
  { "Silence", {"target.interruptAt(75)", "modifier.interrupt", "!modifier.last(Arcane Torrent)" }},

  -- Stay Alive
  { "Power Word: Shield", {"player.health < 90", "modifier.heals" }},
  { "Shadow Mend", {"player.health < 40", "modifier.heals" }},

  -- Make sure DoTs are in a good spot before Voidform
  --{ "Shadow Word: Pain", {"!player.buff(Voidform)", "target.debuff(Shadow Word: Pain).duration < 8", "player.insane >=70 "}},
  --{ "Vampiric Touch", {"!player.buff(Voidform)", "target.debuff(Vampiric Touch).duration < 8", "player.insane >=70 " }},

  -- Activate Voidform and new rotation
  { "Void Eruption", {"modifier.cooldowns", "!player.buff(Voidform)", "player.buff(Lingering Insanity).count < 20",  } },

  -- Rotation to build Insanity
  {{
    { "Mind Blast", },
    { "Shadow Word: Death",  {"!player.buff(Voidform)", "player.spell(Shadow Word: Death).charges > 1" }},
    { "Shadow Word: Pain", {"!player.buff(Voidform)", "target.debuff(Shadow Word: Pain).duration < 3"}},
    { "Vampiric Touch", {"!player.buff(Voidform)", "target.debuff(Vampiric Touch).duration < 3" }},
    { "Mind Flay", {"!player.buff(Voidform)", "!modifier.multitarget" }},
    { "Mind Sear", {"!player.buff(Voidform)", "modifier.multitarget" }},
  },{ "!player.buff(Void Form)" } },

  -- VOID FORM
  { "/run CastSpellByID(228260);", {"player.buff(Voidform)", "player.spell(228260).cooldown < .7", "player.spell(205065).cooldown > 1", "player.spell(205065).cooldown < 55" } }, --Checking for Void Torrent CD (the artifact)....
  { "#trinket2", {"modifier.cooldowns", "player.buff(Voidform)"}},
  { "Shadowfiend", {"player.buff(Voidform)", "modifier.cooldowns" }},
  { "Mindbender", {"player.buff(Voidform)", "modifier.cooldowns" }},
  { "Shadow Word: Death",  {"player.buff(Voidform)", "player.spell(228260).cooldown > 1" }},
  { "Mind Blast", {"player.buff(Voidform)", "player.spell(205448).cooldown > 1" }},

  { "Void Torrent", {"player.buff(Voidform)" }},
  { "Power Infusion", {"player.buff(Voidform)", "modifier.cooldowns" }},
  { "Shadow Word: Death", {"player.buff(Voidform)", "player.spell(Shadow Word: Death).charges > 1" }},

  { "Shadow Word: Pain", {"player.buff(Voidform)", "!target.debuff(Shadow Word: Pain)"}},
  { "Vampiric Touch", {"player.buff(Voidform)", "!target.debuff(Vampiric Touch)" }},
  { "Mind Flay", {"player.buff(Voidform)", "!modifier.multitarget" }},
  { "Mind Sear", {"player.buff(Voidform)", "modifier.multitarget" }},

  ------------------
  -- End Rotation --
  ------------------

}, {

  { "Shadowform", "!player.buff(Shadowform)" },

}, function()
  NetherMachine.toggle.create('heals', 'Interface\\ICONS\\ability_priest_shadowyapparition', 'Heal Me', 'Turn this on to use healing while in combat')
end)
