-- SPEC ID 62
NetherMachine.rotation.register(62, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Interrupts
  { "2139", "modifier.interrupts" }, -- Counterspell

  -- Survivability

  -- Cooldowns
  { "12043", "modifier.cooldowns" }, -- Presence of Mind

  {"12042", {
    "modifier.cooldowns",
    "player.spell(Evocation).cooldown <= 2",
    "player.mana > 50",
    "player.debuff(36032).count = 4",
  }}, -- Arcane Power on Burn Phase

  {"Evocation", {
    "modifier.cooldown",
    "player.mana <= 50",
    "!player.buff(79683)",
    "player.debuff(36032).count = 4",
  }}, -- Evocation transition

  {"#trinket2", "modifier.cooldowns" }, -- Trinket

  -- Mage Bombs
  {"114923", {
    "!target.debuff(114923)",
    "player.debuff(36032).count = 4",
  }, "target"}, -- Nether Tempest

  { "114923", {
    "target.debuff(114923).duration <= 3",
    "player.debuff(36032).count = 4",
  }, "target"}, -- Nether Tempest Refresh

  {"152087", {
    "modifier.lalt",
    "player.spell(Evocation).cooldown <= 2",
    "player.debuff(36032).count = 4",
  }, "target.ground"}, -- Prismatic Crystal

  {"157980", {
    "modifier.lalt",
    "!player.buff(79683).count = 3",
    "player.mana < 94",
  }, "target"}, -- SuperNova

  -- AoE
  {"1449", "modifier.lshift"}, -- Arcane Explosion

  -- Moving
  {"108839", {
    "player.moving",
    "!player.buff(108839)",
  }}, -- Ice floes

  { "5143", {
    "player.moving",
    "player.buff(108839)",
    "player.spell(Evocation).cooldown <= 2",
    "player.buff(79683).count >= 1",
    "player.debuff(36032).count = 4",
  }},-- Arcane Missiles on Burn Phase - MOVING

  {"30451", {
    "player.moving",
    "player.buff(108839)",
    "player.spell(Evocation).cooldown <= 2",
  }}, -- Arcane Blast on Burn Phase - MOVING

  { "5143", {
    "player.moving",
    "player.buff(108839)",
    "player.spell(Evocation).cooldown > 2",
    "player.buff(79683).count = 3",
    "player.debuff(36032).count = 4",
  }},-- Arcane Missiles 3 charges - MOVING

  {"30451", {
    "player.moving",
    "player.buff(108839)",
    "player.spell(Evocation).cooldown > 2",
    "player.mana >= 93",
  }}, --Arcane Blast - MOVING

  { "5143", {
    "player.moving",
    "player.buff(108839)",
    "player.spell(Evocation).cooldown > 2",
    "player.buff(79683).count >= 1",
    "player.debuff(36032).count = 4",
  }},-- Arcane Missiles - MOVING

  { "44425", {
    "player.moving",
    "player.spell(Evocation).cooldown > 2",
    "player.debuff(36032).count = 4",
    "!player.buff(79683)",
  }},-- Arcane Barrage - MOVING

  { "30451", {
    "player.moving",
    "player.buff(108839)",
    "player.spell(Evocation).cooldown > 2",
  }}, -- Arcane Blast - MOVING

  -- Rotation
  {"116011", {
    "modifier.lcontrol",
    "!player.moving",
    "!player.buff(Rune of Power)",
  }, "player.ground"}, -- Rune of Power

  { "5143", {
    "!player.moving",
    "player.spell(Evocation).cooldown <= 2",
    "player.buff(79683).count >= 1",
    "player.debuff(36032).count = 4",
  }},-- Arcane Missiles on Burn Phase

  {"30451", {
    "!player.moving",
    "player.spell(Evocation).cooldown <= 2",
  }}, -- Arcane Blast on Burn Phase

  { "5143", {
    "!player.moving",
    "player.spell(Evocation).cooldown > 2",
    "player.buff(79683).count = 3",
    "player.debuff(36032).count = 4",
    }},-- Arcane Missiles 3 charges

  {"30451", {
    "!player.moving",
    "player.spell(Evocation).cooldown > 2",
    "player.mana >= 93",
  }}, --Arcane Blast

  { "5143", {
    "!player.moving",
    "player.spell(Evocation).cooldown > 2",
    "player.buff(79683).count >= 1",
    "player.debuff(36032).count = 4",
  }},-- Arcane Missiles

  { "44425", {
    "!player.moving";
    "player.spell(Evocation).cooldown > 2",
    "player.debuff(36032).count = 4",
    "!player.buff(79683)",
  }},-- Arcane Barrage

  { "30451", {
    "!player.moving",
    "player.spell(Evocation).cooldown > 2",
  }}, -- Arcane Blast

  ------------------
  -- End Rotation --
  ------------------

},{

  ---------------
  -- OOC Begin --
  ---------------

  -- Dalaran Brilliance (Spell Power)
  { "61316", {
    "!player.buff(61316)", -- Dalaran Brillance
    "!player.buff(1459)", -- Arcane Brillance
    "!player.buff(109733)", -- Dark Intent
    "!player.buff(128433)", -- Hunter: Serpent Pet Species Type - Serpent's Cunning
    "!player.buff(90364)", -- Hunter: Silithid Pet Species Type - Qiraji Fortitude
    "!player.buff(126309)", -- Hunter: Waterstrider Pet Species Type - Still Water
    "spell.exists(61316)" -- Sanity Check for Dalaran Brilliance
  }},

  -- Dalaran Brilliance Time Remaining Critical
  { "61316", {
    "!player.buff(61316).duration <= 900", -- Dalaran Brillance
    "!player.buff(1459).duration <= 900", -- Arcane Brillance
    "!player.buff(109733).duration <= 900", -- Dark Intent
    "!player.buff(128433).duration <= 900", -- Hunter: Serpent Pet Species Type - Serpent's Cunning
    "!player.buff(90364).duration <= 900", -- Hunter: Silithid Pet Species Type - Qiraji Fortitude
    "!player.buff(126309).duration <= 900", -- Hunter: Waterstrider Pet Species Type - Still Water
    "spell.exists(61316)" -- Sanity Check for Dalaran Brilliance
  }},

  -- Arcane Brilliance (Spell Power)
  { "1459", {
    "!player.buff(61316)", -- Dalaran Brillance
    "!player.buff(1459)", -- Arcane Brillance
    "!player.buff(109733)", -- Dark Intent
    "!player.buff(128433)", -- Hunter: Serpent Pet Species Type - Serpent's Cunning
    "!player.buff(90364)", -- Hunter: Silithid Pet Species Type - Qiraji Fortitude
    "!player.buff(126309)", -- Hunter: Waterstrider Pet Species Type - Still Water
    "!spell.exists(61316)" -- Sanity Check for Dalaran Brilliance
  }},

  -- Arcane Brilliance Time Remaining Critical
  { "1459", {
    "!player.buff(61316).duration <= 900", -- Dalaran Brillance
    "!player.buff(1459).duration <= 900", -- Arcane Brillance
    "!player.buff(109733).duration <= 900", -- Dark Intent
    "!player.buff(128433).duration <= 900", -- Hunter: Serpent Pet Species Type - Serpent's Cunning
    "!player.buff(90364).duration <= 900", -- Hunter: Silithid Pet Species Type - Qiraji Fortitude
    "!player.buff(126309).duration <= 900", -- Hunter: Waterstrider Pet Species Type - Still Water
  }},

  -- Dalaran Brilliance (Crit)
  { "61316", {
    "!player.buff(17007)", -- Leader of the Pack
    "!player.buff(61316)", -- Dalaran Brilliance
    "!player.buff(1459)", -- Arcane Brilliance
    "!player.buff(116781)", -- Legacy of the White Tiger
    "!player.buff(90309)", -- Hunter: Devilsaur Pet Species Type - Terrifying Roar
    "!player.buff(126373)", -- Hunter: Quilen Pet Species Type - Fearless Roar
    "!player.buff(160052)", -- Hunter: Raptor Pet Species Type - Strength of the Pack
    "!player.buff(90363)", -- Hunter: Shale Spider Pet Species Type - Embrace of the Shale Spider
    "!player.buff(24604)", -- Hunter: Wolf Pet Species Type - Furious Howl
    "!player.buff(126309)", -- Hunter: Waterstrider Pet Species Type - Still Water
    "spell.exists(61316)" -- Sanity Check for Dalaran Brilliance
  }},


  -- Dalaran Brilliance - Time Remaining Critical
  { "61316", {
    "!player.buff(17007).duration <= 900", -- Leader of the Pack
    "!player.buff(61316).duration <= 900", -- Dalaran Brilliance
    "!player.buff(1459).duration <= 900", -- Arcane Brilliance
    "!player.buff(116781).duration <= 900", -- Legacy of the White Tiger
    "!player.buff(90309).duration <= 900", -- Hunter: Devilsaur Pet Species Type - Terrifying Roar
    "!player.buff(126373).duration <= 900", -- Hunter: Quilen Pet Species Type - Fearless Roar
    "!player.buff(160052).duration <= 900", -- Hunter: Raptor Pet Species Type - Strength of the Pack
    "!player.buff(90363).duration <= 900", -- Hunter: Shale Spider Pet Species Type - Embrace of the Shale Spider
    "!player.buff(24604).duration <= 900", -- Hunter: Wolf Pet Species Type - Furious Howl
    "!player.buff(126309).duration <= 900", -- Hunter: Waterstrider Pet Species Type - Still Water
    "spell.exists(61316)" -- Sanity Check for Dalaran Brilliance
  }},

  -- Arcane Brilliance (Crit)
  { "1459", {
    "!player.buff(17007)", -- Leader of the Pack
    "!player.buff(61316)", -- Dalaran Brilliance
    "!player.buff(1459)", -- Arcane Brilliance
    "!player.buff(116781)", -- Legacy of the White Tiger
    "!player.buff(90309)", -- Hunter: Devilsaur Pet Species Type - Terrifying Roar
    "!player.buff(126373)", -- Hunter: Quilen Pet Species Type - Fearless Roar
    "!player.buff(160052)", -- Hunter: Raptor Pet Species Type - Strength of the Pack
    "!player.buff(90363)", -- Hunter: Shale Spider Pet Species Type - Embrace of the Shale Spider
    "!player.buff(24604)", -- Hunter: Wolf Pet Species Type - Furious Howl
    "!player.buff(126309)", -- Hunter: Waterstrider Pet Species Type - Still Water
    "!spell.exists(61316)" -- Sanity Check for Dalaran Brilliance
  }},


  -- Arcane Brilliance - Time Remaining Critical
  { "1459", {
    "!player.buff(17007).duration <= 900", -- Leader of the Pack
    "!player.buff(61316).duration <= 900", -- Dalaran Brilliance
    "!player.buff(1459).duration <= 900", -- Arcane Brilliance
    "!player.buff(116781).duration <= 900", -- Legacy of the White Tiger
    "!player.buff(90309).duration <= 900", -- Hunter: Devilsaur Pet Species Type - Terrifying Roar
    "!player.buff(126373).duration <= 900", -- Hunter: Quilen Pet Species Type - Fearless Roar
    "!player.buff(160052).duration <= 900", -- Hunter: Raptor Pet Species Type - Strength of the Pack
    "!player.buff(90363).duration <= 900", -- Hunter: Shale Spider Pet Species Type - Embrace of the Shale Spider
    "!player.buff(24604).duration <= 900", -- Hunter: Wolf Pet Species Type - Furious Howl
    "!player.buff(126309).duration <= 900", -- Hunter: Waterstrider Pet Species Type - Still Water
    "!spell.exists(61316)" -- Sanity Check for Dalaran Brilliance
  }},

  -------------
  -- OOC End --
  -------------

  })
