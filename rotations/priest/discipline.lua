-- NetherMachine Rotation
-- Discipline Priest - Legion 7.0.3
-- Updated on Sept 15th 2016

-- TALENTS: 15: Castigation 30: Angelic Feather 60: Shield Discipline 75: Power Infusion 90: Halo 100: Purge the Wicked
-- STATS: Haste > Critical Strike > Mastery > Versatility >

-- SPEC ID 256 (Disc)
NetherMachine.rotation.register_custom(256, "|cFF99FF00Legion |Disc Priest |cFFFF9999(Party)", {

  --------------------
  -- Start Rotation --
  --------------------

  -- Keybinds
  { "Power Word: Barrier", "modifier.lshift", "ground" },

  -- Survival on Self
  { "#Healthstone", "player.health <= 30" },

  -- MOVING
  { {
    { "Plea", { "party1.health < 92", "party1.buff(Atonement).remains <= 2" }, "party1" },
    { "Plea", { "party2.health < 92", "party2.buff(Atonement).remains <= 2" }, "party2" },
    { "Plea", { "party3.health < 92", "party3.buff(Atonement).remains <= 2" }, "party3" },
    { "Plea", { "party4.health < 92", "party4.buff(Atonement).remains <= 2" }, "party4" },
  }, "player.moving" },

  -- DISPELLS

  -- HEALING COOLDOWNS
  {{
    { "Pain Suppression", {"lowest.health <= 35", "lowest.range <= 40", "lowest.buff(Atonement).duration > 2" }, "lowest" },
    { "Rapture", {"@coreHealing.needsHealing(70, 3)", "lowest.range <= 40" }, "player" },
  },{
    "tank.exists", "!tank.dead", "tank.range <= 40"
  }},

  -- PLAYER HEALING
  { "Power Word: Shield", { "player.health < 60", "!player.buff(Atonement)" }, "player" },
  { "Plea", { "player.health < 96", "!player.buff(Atonement)" }, "player" },

  -- POWER WORD: SHIELD
  --    on the tank, or another target who is taking heavy sustained damage.
  { "Power Word: Shield", { "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')" }, "boss1target" },
  { "Power Word: Shield", { "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "!boss1target.buff(Lifebloom)" }, "focus" },
  { "Power Word: Shield", { "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "!focus.buff(Lifebloom)", "!boss1target.buff(Lifebloom)" }, "tank" },

  -- POWER WORD: RADIANCE
  { "Power Word: Radiance", { "focus.exists", "focus.friend", "focus.health <= 90", "!player.moving", "@coreHealing.needsHealing(75, 3)", "!lowest.buff(Atonement)" "focus.area(30).friendly > 3" }, "focus" }, -- Up to 5 within 30yd
  { "Power Word: Radiance", { "tank.health <= 90", "!player.moving", "@coreHealing.needsHealing(75, 3)", "tank.area(30).friendly > 3", "!lowest.buff(Atonement)" }, "tank" },
  { "Power Word: Radiance", { "player.health <= 90", "!player.moving", "@coreHealing.needsHealing(75, 3)", "player.area(30).friendly > 3", "!lowest.buff(Atonement)" }, "player" },

  -- BOSS1TARGET HEALING
  { {
    { "Plea", { "boss1target.health < 99", "!boss1target.buff(Atonement)" }, "boss1target" },
    { "Shadowmend", { "boss1target.health < 40", "!player.moving", "boss1target.buff(Atonement)" }, "boss1target" },
    { "Plea", { "boss1target.health < 30", "player.moving", }, "boss1target" },
  },{
    "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')",
  } },

  -- FOCUS HEALING
  { {
    { "Plea", { "focus.health < 99", "!focus.buff(Atonement)" }, "focus" },
    { "Shadowmend", { "focus.health < 40", "!player.moving", "focus.buff(Atonement)" }, "focus" },
    { "Plea", { "tank.health < 35", "player.moving", }, "focus" },
  },{
    "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40",
  } },

  -- TANK HEALING
  { {
    { "Plea", { "tank.health < 99", "!tank.buff(Atonement)" }, "tank" },
    { "Shadowmend", { "tank.health < 40", "!player.moving", "tank.buff(Atonement)" }, "tank" },
    { "Plea", { "tank.health < 35", "player.moving", }, "tank" },
  },{
    "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40",
  } },

  --Big Stuff
  { "Divine Star", "modifier.cooldowns" },
  { "Halo", "modifier.cooldowns" },

  ------------------------------------------
  -- Atonement Checks and Regular Healing --
  ------------------------------------------
  { {
    { "Power Word: Shield", { "!party1.buff(Power Word: Shield)" }, "party1" },
    { "Power Word: Shield", { "!party2.buff(Power Word: Shield)" }, "party2" },
    { "Power Word: Shield", { "!party3.buff(Power Word: Shield)" }, "party3" },
    { "Power Word: Shield", { "!party4.buff(Power Word: Shield)" }, "party4" },
    { "Power Word: Shield", { "!lowest.buff(Power Word: Shield)" }, "lowest" },
  }, "player.buff(Rapture)" },

  ------------------------------------------
  -- Atonement Checks and Regular Healing --
  ------------------------------------------
  { {
    { "Shadow Mend", { "party1.health <= 40", "!player.moving", "party1.buff(Atonement).duration < 4", "lowest.buff(Atonement)" }, "party1" },
    { "Shadow Mend", { "party2.health <= 40", "!player.moving", "party2.buff(Atonement).duration < 4", "lowest.buff(Atonement)" }, "party2" },
    { "Shadow Mend", { "party3.health <= 40", "!player.moving", "party3.buff(Atonement).duration < 4", "lowest.buff(Atonement)" }, "party3" },
    { "Shadow Mend", { "party4.health <= 40", "!player.moving", "party4.buff(Atonement).duration < 4", "lowest.buff(Atonement)" }, "party4" },
    { "Shadow Mend", { "lowest.health <= 40", "!player.moving", "lowest.range <= 40", "lowest.buff(Atonement).duration < 4", "lowest.buff(Atonement)" }, "lowest" },

    { "Power Word: Shield", { "party1.health <= 72", "!party1.buff(Power Word: Shield)" }, "party1" },
    { "Power Word: Shield", { "party2.health <= 72", "!party2.buff(Power Word: Shield)" }, "party2" },
    { "Power Word: Shield", { "party3.health <= 72", "!party3.buff(Power Word: Shield)" }, "party3" },
    { "Power Word: Shield", { "party4.health <= 72", "!party4.buff(Power Word: Shield)" }, "party4" },
    { "Power Word: Shield", { "lowest.health <= 72", "lowest.range <= 40", "!lowest.buff(Power Word: Shield)" }, "lowest" },

    { "Plea", { "party1.health <= 96", "!party1.buff(Atonement)", "party1.range <= 40" }, "party1" },
    { "Plea", { "party2.health <= 96", "!party2.buff(Atonement)", "party2.range <= 40" }, "party2" },
    { "Plea", { "party3.health <= 96", "!party3.buff(Atonement)", "party3.range <= 40" }, "party3" },
    { "Plea", { "party4.health <= 96", "!party4.buff(Atonement)", "party4.range <= 40" }, "party4" },
    { "Plea", { "lowest.health <= 96", "!lowest.buff(Atonement)", "lowest.range <= 40" }, "lowest" },
  }, "!modifier.raid" },


  --Direct Damage to tank target first and then my target
  {{
    { "Mindbender", "modifier.cooldowns" },
    { "Shadowfiend", "modifier.cooldowns" },
    { "Shadow Word: Pain", "target.debuff(Shadow Word: Pain).duration < 2" },
    { "Purge the Wicked", "target.debuff(Purge the Wicked).duration < 2" },
    { "Schism", "!player.moving" },
    { "Penance" },
    { "Power Word: Solace" },
    { "Smite", "!player.moving" },
  }, "target.enemy" },

  {{
    { "Mindbender", "modifier.cooldowns" },
    { "Shadowfiend", "modifier.cooldowns" },
    { "Shadow Word: Pain", "tanktarget.debuff(Shadow Word: Pain).duration < 2" },
    { "Purge the Wicked", "tanktarget.debuff(Purge the Wicked).duration < 2" },
    { "Schism", {"!player.moving"}, "tanktarget" },
    { "Penance", {""}, "tanktarget" },
    { "Power Word: Solace", {""}, "tanktarget" },
    { "Smite", {"!player.moving"}, "tanktarget" },
  }, "tanktarget.exists", "tanktarget.enemy" },

  ------------------
  -- End Rotation --
  ------------------

})
