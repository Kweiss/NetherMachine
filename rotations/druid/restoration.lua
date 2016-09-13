-- SPEC ID 105 (Restoration)
-- Talents: 1213113
NetherMachine.rotation.register(105, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Keybinding
  { "Efflorescence", "modifier.shift", "ground" },
  { "Stampeding Roar", "modifier.alt" },

  -- Survival on Self
  { "#Healthstone", "player.health <= 50" },
  { "Innervate", "@coreHealing.needsHealing(60, 2)" },
  { "Innervate", "player.mana < 75 " },

  -- moving
  { "70691", {
    "player.moving",
    "lowest.buff(70691).duration < 2",
    "lowest.health < 88",
  }, "lowest" },

  -- On tank
  {{
    { "Swiftmend", {
      "tank.health < 35 ",
      "tank.buff(Lifebloom)",
    }, "tank" },

    { "Swiftmend", {
      "tank.health < 45 ",
      "tank.buff(70691).duration > 2",
      "tank.buff(Regrowth).duration > 2",
      "tank.buff(Lifebloom)",
    }, "tank" },

    { "Ironbark", {
      "tank.health <= 50",
      "modifier.cooldowns",
    }, "tank" },

    { "Swiftmend", {
      "tank.health < 65 ",
      "tank.buff(70691).duration > 2",
      "tank.buff(Regrowth).duration > 2",
      "tank.buff(Lifebloom)",
      "player.spell(Swiftmend).charges > 1 "
    }, "tank" },

    { "Healing Touch", {
      "tank.health < 38 ",
      "tank.range <= 45",
      "tank.buff(70691)",
      "tank.buff(Lifebloom)",
      "player.spell(Swiftmend).charges < 1 "
    }, "tank" },

  },{
    "tank.exists",
  }},

  -- On raid
  { "Healing Touch", {
    "lowest.health <= 25",
    "lowest.buff(70691)",
    "lowest.buff(Regrowth)",
    "player.spell(Swiftmend).charges < 1 "
  }, "lowest" },

  { "Swiftmend", {
    "player.health <= 30",
    "player.buff(70691)",
  }, "player" },

  { "Swiftmend", {
    "lowest.health <= 35",
    "lowest.buff(70691)",
    "lowest.range <= 45"
  }, "lowest" },

  { "Healing Touch", {
    "lowest.health <= 35",
    "lowest.buff(70691)",
    "lowest.buff(Regrowth)",
  }, "lowest" },

  { "Barkskin", {
    "player.health <= 40",
    "modifier.cooldowns",
  }, "player" },

  { "Flourish", {
    "@coreHealing.needsHealing(70, 3)",
  }},

  { "Wild Growth", {
    "@coreHealing.needsHealing(80, 3)",
    "lowest.buff(Wild Growth).duration < 2",
    "player.mana > 30 ",
  }, "lowest" },

  { "Healing Touch", {
    "player.health < 50",
    "player.buff(Regrowth).duration > 2",
    "player.buff(70691).duration > 2",
  }, "player" },

  { "Healing Touch", {
    "lowest.health <= 45",
    "lowest.range <= 45",
    "lowest.buff(Regrowth).duration > 2",
    "lowest.buff(70691).duration > 2",
  }, "lowest" },

  { "Regrowth", {
    "player.health <= 70",
    "player.buff(Regrowth).duration < 2",
  }, "player" },

  { "Nature's Cure", "@coreHealing.canDispell(Nature's Cure)" },

-- On Tank again
  {{
    { "Regrowth", {
      "tank.health <= 75",
      "tank.buff(Regrowth).duration < 2",
      "!lastcast(Regrowth)",
      "tank.range <= 45",
    }, "tank" },

    { "70691", {
      "tank.health < 93",
      "tank.buff(70691).duration < 2",
      "tank.range <= 45",
    }, "tank" },

    { "Lifebloom", {
      "!tank.buff(Lifebloom)",
      "tank.range <= 45",
    }, "tank" },

  },{
    "tank.exists",
  }},

 -- On raid

  { "Regrowth", {
    "player.health <= 70",
    "player.buff(Regrowth).duration < 2",
  }, "player" },

  { "Regrowth", {
    "lowest.health <= 70",
    "lowest.range <= 45",
    "lowest.buff(Regrowth).duration < 2",
  }, "lowest" },

  { "Regrowth", {
    "player.buff(Clearcasting).duration < 5",
    "lowest.health <= 83",
  }, "lowest" },

  { "70691", {
    "player.health <= 90",
    "player.buff(70691).duration < 2"
  }, "player" },

  { "70691", {
    "lowest.health <= 90",
    "lowest.buff(70691).duration < 2",
  }, "lowest" },

  { "Regrowth", {
    "player.buff(Clearcasting).duration < 3",
    "lowest.buff(Regrowth).duration < 5",
  }, "lowest" },

  ------------------
  -- End Rotation --
  ------------------

},{

  ---------------
  -- OOC Begin --
  ---------------
  -- Confirm we are not in a form
  {

  -- On tank
  {{
  { "Lifebloom", {
    "!tank.buff(Lifebloom)",
    "!tank.dead",
    "tank.range <= 45",
  }, "tank" },
  { "70691", {
    "tank.health <= 85",
    "!tank.buff(70691)",
    "!tank.dead",
    "tank.range <= 45",
  }, "tank" },
  { "Regrowth", {
    "tank.health <= 65",
    "tank.buff(Regrowth).duration < 2",
    "!lastcast(Regrowth)",
    "!tank.dead",
    "tank.range <= 45",
  }, "tank" },

  },{ "tank.exists" }},

  },{
    "!player.buff(Bear Form)",
    "!player.buff(Cat Form)",
    "!player.buff(Flight Form)",
    "!player.buff(Swift Flight Form)",
    "!player.buff(Travel Form)",
    "!player.buff(Aquatic Form)",
  }

  ---------------
  -- OOC End --
  ---------------

})
