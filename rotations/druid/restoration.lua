-- SPEC ID 105 (Restoration)
-- Talents: 1213113
-- m+ is CW, germ, cultivation and stonebark
-- m+ Rake > shred to 5 combo > rip > sunfire/moon fire > wrath till rake is falling off
NetherMachine.rotation.register(105, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Keybinding
  { "Efflorescence", "modifier.lshift", "ground" },
  { "Stampeding Roar", "modifier.lalt" },

  -- Survival on Self
  { "#Healthstone", "player.health <= 50" },
  { "Innervate", "player.mana < 75 " },

  -- moving
  { "Rejuvenation", {
    "player.moving",
    "lowest.buff(Rejuvenation).duration < 2",
    "lowest.health < 88",
  }, "lowest" },

  -- On tank
  {{
    { "Swiftmend", { "tank.health < 35 ", "tank.buff(Lifebloom)" }, "tank" },
    { "Swiftmend", { "tank.health < 45 ", "tank.buff(Rejuvenation).duration > 2", "tank.buff(Regrowth).duration > 2", "tank.buff(Lifebloom)" }, "tank" },

    { "Ironbark", { "tank.health <= 50", "modifier.cooldowns" }, "tank" },

    { "Swiftmend", { "tank.health < 65 ", "tank.buff(Rejuvenation).duration > 2", "tank.buff(Regrowth).duration > 2", "tank.buff(Lifebloom)", "player.spell(Swiftmend).charges > 1 " }, "tank" },

    { "Healing Touch", { "tank.health < 38 ", "tank.range <= 45", "tank.buff(Rejuvenation)", "tank.buff(Lifebloom)", "player.spell(Swiftmend).charges < 1 " }, "tank" },

  },{
    "tank.exists",
  }},

  -- On raid
  { "Healing Touch", {
    "lowest.health <= 25",
    "lowest.buff(Rejuvenation)",
    "lowest.buff(Regrowth)",
    "player.spell(Swiftmend).charges < 1 "
  }, "lowest" },

  { "Swiftmend", {
    "player.health <= 30",
    "player.buff(Rejuvenation)",
  }, "player" },

  { "Swiftmend", {
    "lowest.health <= 35",
    "lowest.buff(Rejuvenation)",
    "lowest.range <= 45"
  }, "lowest" },

  { "Healing Touch", {
    "lowest.health <= 35",
    "lowest.buff(Rejuvenation)",
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
    "player.buff(Rejuvenation).duration > 2",
  }, "player" },

  { "Healing Touch", {
    "lowest.health <= 45",
    "lowest.range <= 45",
    "lowest.buff(Regrowth).duration > 2",
    "lowest.buff(Rejuvenation).duration > 2",
  }, "lowest" },

  { "Regrowth", {
    "player.health <= 70",
    "player.buff(Regrowth).duration < 2",
  }, "player" },

  { "Nature's Cure", { "toggle.dispel", "mouseover.exists", "mouseover.friend", "mouseover.dispellable" }, "mouseover" }, -- Proving Grounds

-- On Tank again
  {{
    { "Regrowth", {
      "tank.health <= 75",
      "tank.buff(Regrowth).duration < 2",
      "!lastcast(Regrowth)",
      "tank.range <= 45",
    }, "tank" },

    { "Rejuvenation", {
      "tank.health < 93",
      "tank.buff(Rejuvenation).duration < 2",
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

  { "Rejuvenation", {
    "player.health <= 90",
    "player.buff(Rejuvenation).duration < 2"
  }, "player" },

  { "Rejuvenation", {
    "lowest.health <= 90",
    "lowest.buff(Rejuvenation).duration < 2",
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

  -- (Boss target, then Focus, then Tank role)
  { "Lifebloom", { "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')", "!boss1target.buff(Lifebloom)", }, "boss1target" },
  { "Lifebloom", { "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "!boss1target.buff(Lifebloom)", "!focus.buff(Lifebloom)" }, "focus" },
  { "Lifebloom", { "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "!focus.buff(Lifebloom)", "!boss1target.buff(Lifebloom)", "!tank.buff(Lifebloom)" }, "tank" },

  { "Rejuvenation", { "tank.health <= 87", "!tank.buff(Rejuvenation)", "!tank.dead", "tank.range <= 45" }, "tank" },
  { "Regrowth", { "tank.health <= 65", "tank.buff(Regrowth).duration < 2", "!lastcast(Regrowth)", "!tank.dead", "tank.range <= 45" }, "tank" },

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

  },
  function()
    NetherMachine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
    NetherMachine.toggle.create('mouseover', 'Interface\\Icons\\spell_nature_faeriefire', 'Mouseover Regrowth', 'Toggle Mouseover Regrowth For SoO NPC Healing')
  end)




  NetherMachine.rotation.register_custom(105, "bbDruid Restoration (Experimental)", {
    ---------------------------
    --    MODIFIERS/MISC     --
    ---------------------------
    { "1126", "!player.buffs.stats" }, --stats
    {"!Wild Mushroom", { "modifier.rcontrol", "mouseover.ground" } }, --shroom
    {"!26297", "modifier.lalt" }, --Berserking Racial
    {"!740", "modifier.lalt" }, --Tranq
    {"!33891", "modifier.lcontrol" }, --Incarnation
    {"!108294", { "modifier.ralt", "talent(6,1)" } }, --Heart of the wild
    {"!124974", { "modifier.ralt", "talent(6,3)" } },--Natures Vigil
    {"!106898", "modifier.lshift" }, --Stampeding Roar
    {"!20484", "modifier.rshift", "mouseover" }, --Rebirth
    {"/cancelform", { "player.buff(Stampeding Roar)" } },
    {"/cancelform", { "player.buff(Displacer Beast)" } },
    {"#trinket1", "player.mana < 80"},
    {"#trinket2", "player.mana < 80"},

    ---------------------------
    --      SURVIVAL        --
    ---------------------------
    { "22812", { "player.health <= 50" }, "player" },--barkskin
    { "108238", { "player.health <= 40", "talent(2,2)" }, "player" },--Renewal
    { "#5512", "player.health <= 30" },  --healthstone
    { "Ironbark", { "focus.health <= 40", "focus.friend", "focus.range <= 40" }, "focus" },
    { "Ironbark", { "tank.health <= 40", "tank.range <= 40"}, "tank" },

    ---------------------------
    --      DISPELLS        --
    ---------------------------
    {{
      {"88423", { "!lastcast(88423)", "player.mana > 10", "@coreHealing.needsDispelled('Corrupted Blood')" }, nil },
      {"88423", { "!lastcast(88423)", "player.mana > 10", "@coreHealing.needsDispelled('Slow')" }, nil },
    }, "player.mana > 10" },

    ---------------------------
    --    PROCS AND BUFFS    --
    ---------------------------
    { "Regrowth", { "!player.moving", "player.buff(16870)", "lowest.range <= 40" }, "lowest" },--Omen procs
    { "Regrowth", { "!player.moving", "player.buff(16870)", "tank.range <= 40" }, "tank" },--Omen procs
    { "Regrowth", { "!player.moving", "player.buff(155631)", "lowest.range <= 40" }, "lowest" }, --Moment of Clarity
    { "Regrowth", { "!player.moving", "player.buff(155631)", "tank.range <= 40" }, "tank" }, --Moment of Clarity
    { "132158", { "lowest.health <= 90" } },--NS on CD, but not wasted
    { "Healing Touch", { "player.buff(132158)", "lowest.range <= 40" }, "lowest" },--NS lowest
    { "1126", "!player.buffs.stats" }, --stats
    { "1126", "!player.buffs.versatility" }, --stats

    ---------------------------
    --   STANDARD HEALING    --
    ---------------------------
    {{
      ---------------------------
      --       EMERGENCY       --
      ---------------------------
      { "Regrowth", {"!player.moving", "player.health <= 25" }, "player" },
      { "Regrowth", {"!player.moving", "focus.health <= 25", "focus.range <= 40" }, "focus" },
      { "Regrowth", {"!player.moving", "tank.health <= 28", "tank.range <= 40" }, "tank" },
      { "Regrowth", {"!player.moving", "lowest.health <= 28", "lowest.range <= 40" }, "lowest" },

      ---------------------------
      --         MISC          --
      ---------------------------
      { "Healing Touch", { "!player.moving","player.buff(100977).duration <= 1", "!glyph(116218)", "lowest.range <= 40" }, "lowest" },--Mastery Upkeep
      { "Regrowth", { "!player.moving","player.buff(100977).duration <= 1", "glyph(116218)", "lowest.range <= 40" }, "lowest" }, --Mastery Upkeep
      { "Lifebloom", { "!lastcast(Lifebloom)", "focus.exists", "focus.friend", "!focus.buff", "focus.range <= 40" }, "focus" }, --lifebloom "tank"
      { "Lifebloom", { "!lastcast(Lifebloom)", "!tank.buff", "!focus.buff", "tank.range <= 40" }, "tank" }, --lifebloom "tank"
      { "102351", { "focus.buff(102351).duration <= 1", "focus.range <= 40" }, "focus" }, --CW focus
      { "102351", { "tank.buff(102351).duration <= 1", "!focus.exist", "tank.range <= 40" }, "tank" },--CW "tank" if no focus

      ---------------------------
      --     AUTO-SHROOM       --
      ---------------------------
      {{
        { "145205", { "toggle.ShroomPlace", "!player.totem(145205)" }, "focus" },
        { "145205", { "toggle.ShroomPlace", "!player.totem(145205)" }, "tank" },
        { "145205", { "!toggle.ShroomPlace", "!player.totem(145205)" }, "player" },
      }, "!glyph(146654)" },

      ---------------------------
      --     INCARNATION       --
      ---------------------------
      {{
        {{
          { "Wild Growth", { "!player.moving", "lowest.range <= 40", "@coreHealing.needsHealing(90, 4)" }, "lowest" },
          { "Wild Growth", { "!player.moving", "tank.range <= 40", "@coreHealing.needsHealing(90, 4)" }, "tank" },
          { "Wild Growth", { "!player.moving", "focus.range <= 40", "@coreHealing.needsHealing(90, 4)" }, "focus" },
        }, "toggle.WildGrowth" },
        { "Regrowth", { "lowest.range <= 40", "lowest.health <= 90" }, "lowest" },
        { "Regrowth", { "tank.range <= 40", "tank.health <= 90" }, "tank" },
        { "Regrowth", { "focus.range <= 40", "focus.health <= 90" }, "focus" },
      }, "player.buff(117679)" },

      ---------------------------
      --     FORCE OF NATURE   --
      ---------------------------
      {{
        { "102693", { "!lastcast(102693)", "player.spell(102693).charges = 3", "lowest.range <= 40", "lowest.health <= 92" }, "lowest" },
        { "102693", { "!lastcast(102693)", "player.spell(102693).charges = 3", "tank.range <= 40", "tank.health <= 92" }, "tank" },
        { "102693", { "!lastcast(102693)", "player.spell(102693).charges >= 2", "lowest.range <= 40", "lowest.health <= 70" }, "lowest" },
        { "102693", { "!lastcast(102693)", "player.spell(102693).charges >= 2", "tank.range <= 40", "tank.health <= 70" }, "tank" },
        { "102693", { "!lastcast(102693)", "player.spell(102693).charges >= 1", "lowest.range <= 40","@coreHealing.needsHealing(70, 5)" }, "lowest" },
        { "102693", { "!lastcast(102693)", "player.spell(102693).charges >= 1", "tank.range <= 40","@coreHealing.needsHealing(70, 5)" }, "tank" },
      }, "talent(4,3)" },

      ---------------------------
      --  SOUL OF THE FOREST   --
      ---------------------------
      {{
        {{
          { "Wild Growth", { "!player.moving", "lowest.range <= 40", "@coreHealing.needsHealing(90, 3)" }, "lowest"},
          { "Wild Growth", { "!player.moving", "tank.range <= 40", "@coreHealing.needsHealing(90, 3)" }, "tank"},
          { "Wild Growth", { "!player.moving", "focus.range <= 40", "@coreHealing.needsHealing(90, 3)" }, "focus"},
        }, "toggle.WildGrowth"},
        { "Regrowth", { "!player.moving", "lowest.range <= 40", "lowest.health <= 85"}, "lowest"},
        { "Regrowth", { "!player.moving", "tank.range <= 40", "tank.health <= 85"}, "tank"},
        { "Regrowth", { "!player.moving", "focus.range <= 40", "focus.health <= 85"}, "focus"},
      }, "player.buff(114108)" },

      ---------------------------
      --       TIER 6          --
      ---------------------------
      { "Wrath", { "lowest.health >= 80", "!player.moving", "talent(6,2)", "!player.buff(114108)", "target.enemy", "target.range <= 40" }, "target" },
      { "124974", { "@coreHealing.needsHealing(85, 5)", "talent(6,3)", "modifier.cooldowns" } }, -- NatuRes vigil

      ---------------------------
      --     BASIC HEALING     --
      ---------------------------
      {{
        { "Wild Growth", { "!player.moving", "player.mana >= 20", "lowest.range <= 40", "@coreHealing.needsHealing(60, 3)" }, "lowest" },
        { "Wild Growth", { "!player.moving", "player.mana >= 20", "tank.range <= 40", "@coreHealing.needsHealing(60, 3)" }, "tank" },
        { "Wild Growth", { "!player.moving", "player.mana >= 20", "focus.range <= 40", "@coreHealing.needsHealing(60, 3)" }, "focus" },
        { "Wild Growth", { "!player.moving", "player.mana >= 20", "lowest.range <= 40", "@coreHealing.needsHealing(80, 5)" }, "lowest" },
        { "Wild Growth", { "!player.moving", "player.mana >= 20", "tank.range <= 40", "@coreHealing.needsHealing(80, 5)" }, "tank" },
        { "Wild Growth", { "!player.moving", "player.mana >= 20", "focus.range <= 40", "@coreHealing.needsHealing(80, 5)" }, "focus" },
        { "Wild Growth", { "!player.moving", "player.buff(167715)", "@coreHealing.needsHealing(80, 5)" }, "player" }, -- 4 set bonus
        { "Wild Growth", { "!player.moving", "player.buff(167715)", "lowest.range <= 40", "@coreHealing.needsHealing(80, 5)" }, "lowest" },
        { "Wild Growth", { "!player.moving", "player.buff(167715)", "tank.range <= 40", "@coreHealing.needsHealing(80, 5)" }, "tank" },
        { "Wild Growth", { "!player.moving", "player.buff(167715)", "focus.range <= 40", "@coreHealing.needsHealing(80, 5)" }, "focus" },
      }, "toggle.WildGrowth"},

      ---------------------------
      --      SWIFTMEND        --
      ---------------------------
      {{
        { "Rejuvenation", { "lowest.health <= 91","!player.buff(Rejuvenation)"}, "player" }, -- REJUVE check for swiftmend
        { "Swiftmend", { "lowest.range <= 40", "lowest.buff(774)", "lowest.health <= 90"}, "lowest" }, -- Rejuv.
        { "Swiftmend", { "focus.range <= 40", "focus.buff(774)", "focus.health <= 95"}, "focus" }, -- Rejuv.
        { "Swiftmend", { "tank.buff(774)", "tank.health <= 95"}, "tank" }, -- Rejuv.
        { "Swiftmend", { "raid1.range <= 40", "raid1.buff(774)", "raid1.health <= 90"}, "raid1" }, -- Rejuv.
        { "Swiftmend", { "player.buff(774)", "player.health <= 90" }, "player" }, -- Rejuv.
        { "Swiftmend", { "raid2.range <= 40", "raid2.buff(774)", "raid2.health <= 90"}, "raid2" }, -- Rejuv.
        { "Swiftmend", { "raid3.range <= 40", "raid3.buff(774)", "raid3.health <= 90"}, "raid3" }, -- Rejuv.
        { "Swiftmend", { "raid4.range <= 40", "raid4.buff(774)", "raid4.health <= 90"}, "raid4" }, -- Rejuv.
        { "Swiftmend", { "raid5.range <= 40", "raid5.buff(774)", "raid5.health <= 90"}, "raid5" }, -- Rejuv.
        { "Swiftmend", { "raid6.range <= 40", "raid6.buff(774)", "raid6.health <= 90"}, "raid6" }, -- Rejuv.
        { "Swiftmend", { "raid7.range <= 40", "raid7.buff(774)", "raid7.health <= 90"}, "raid7" }, -- Rejuv.
        { "Swiftmend", { "raid8.range <= 40", "raid8.buff(774)", "raid8.health <= 90"}, "raid8" }, -- Rejuv.
        { "Swiftmend", { "raid9.range <= 40", "raid9.buff(774)", "raid9.health <= 90"}, "raid9" }, -- Rejuv.
        { "Swiftmend", { "raid10.range <= 40", "raid10.buff(774)", "raid10.health <= 90"}, "raid10" }, -- Rejuv.
        { "Swiftmend", { "raid11.range <= 40", "raid11.buff(774)", "raid11.health <= 90"}, "raid11" }, -- Rejuv.
        { "Swiftmend", { "raid12.range <= 40", "raid12.buff(774)", "raid12.health <= 90"}, "raid12" }, -- Rejuv.
        { "Swiftmend", { "raid13.range <= 40", "raid13.buff(774)", "raid13.health <= 90"}, "raid13" }, -- Rejuv.
        { "Swiftmend", { "raid14.range <= 40", "raid14.buff(774)", "raid14.health <= 90"}, "raid14" }, -- Rejuv.
        { "Swiftmend", { "raid15.range <= 40", "raid15.buff(774)", "raid15.health <= 90"}, "raid15" }, -- Rejuv.
        { "Swiftmend", { "raid16.range <= 40", "raid16.buff(774)", "raid16.health <= 90"}, "raid16" }, -- Rejuv.
        { "Swiftmend", { "raid17.range <= 40", "raid17.buff(774)", "raid17.health <= 90"}, "raid17" }, -- Rejuv.
        { "Swiftmend", { "raid18.range <= 40", "raid18.buff(774)", "raid18.health <= 90"}, "raid18" }, -- Rejuv.
        { "Swiftmend", { "raid19.range <= 40", "raid19.buff(774)", "raid19.health <= 90"}, "raid19" }, -- Rejuv.
        { "Swiftmend", { "raid20.range <= 40", "raid20.buff(774)", "raid20.health <= 90"}, "raid20" }, -- Rejuv.
        { "Swiftmend", { "raid21.range <= 40", "raid21.buff(774)", "raid21.health <= 90"}, "raid21" }, -- Rejuv.
      }, "player.moving" },
      {{
        { "Rejuvenation", { "lowest.health <= 91","!player.buff(Rejuvenation)" }, "player" }, -- REJUVE check for swiftmend
        { "Swiftmend", { "lowest.range <= 40", "lowest.buff(774)", "lowest.health <= 90" }, "lowest" }, -- Rejuv.
        { "Swiftmend", { "focus.range <= 40", "focus.buff(774)", "focus.health <= 95" }, "focus" }, -- Rejuv.
        { "Swiftmend", { "tank.buff(774)", "tank.health <= 95" }, "tank" }, -- Rejuv.
        { "Swiftmend", { "raid1.range <= 40", "raid1.buff(774)", "raid1.health <= 90" }, "raid1" }, -- Rejuv.
        { "Swiftmend", { "player.buff(774)", "player.health <= 90" }, "player" }, -- Rejuv.
        { "Swiftmend", { "raid2.range <= 40", "raid2.buff(774)", "raid2.health <= 90" }, "raid2" }, -- Rejuv.
        { "Swiftmend", { "raid3.range <= 40", "raid3.buff(774)", "raid3.health <= 90" }, "raid3" }, -- Rejuv.
        { "Swiftmend", { "raid4.range <= 40", "raid4.buff(774)", "raid4.health <= 90" }, "raid4" }, -- Rejuv.
        { "Swiftmend", { "raid5.range <= 40", "raid5.buff(774)", "raid5.health <= 90" }, "raid5" }, -- Rejuv.
        { "Swiftmend", { "raid6.range <= 40", "raid6.buff(774)", "raid6.health <= 90" }, "raid6" }, -- Rejuv.
        { "Swiftmend", { "raid7.range <= 40", "raid7.buff(774)", "raid7.health <= 90" }, "raid7" }, -- Rejuv.
        { "Swiftmend", { "raid8.range <= 40", "raid8.buff(774)", "raid8.health <= 90" }, "raid8" }, -- Rejuv.
        { "Swiftmend", { "raid9.range <= 40", "raid9.buff(774)", "raid9.health <= 90" }, "raid9" }, -- Rejuv.
        { "Swiftmend", { "raid10.range <= 40", "raid10.buff(774)", "raid10.health <= 90" }, "raid10" }, -- Rejuv.
        { "Swiftmend", { "raid11.range <= 40", "raid11.buff(774)", "raid11.health <= 90" }, "raid11" }, -- Rejuv.
        { "Swiftmend", { "raid12.range <= 40", "raid12.buff(774)", "raid12.health <= 90" }, "raid12" }, -- Rejuv.
        { "Swiftmend", { "raid13.range <= 40", "raid13.buff(774)", "raid13.health <= 90" }, "raid13" }, -- Rejuv.
        { "Swiftmend", { "raid14.range <= 40", "raid14.buff(774)", "raid14.health <= 90" }, "raid14" }, -- Rejuv.
        { "Swiftmend", { "raid15.range <= 40", "raid15.buff(774)", "raid15.health <= 90" }, "raid15" }, -- Rejuv.
        { "Swiftmend", { "raid16.range <= 40", "raid16.buff(774)", "raid16.health <= 90" }, "raid16" }, -- Rejuv.
        { "Swiftmend", { "raid17.range <= 40", "raid17.buff(774)", "raid17.health <= 90" }, "raid17" }, -- Rejuv.
        { "Swiftmend", { "raid18.range <= 40", "raid18.buff(774)", "raid18.health <= 90" }, "raid18" }, -- Rejuv.
        { "Swiftmend", { "raid19.range <= 40", "raid19.buff(774)", "raid19.health <= 90" }, "raid19" }, -- Rejuv.
        { "Swiftmend", { "raid20.range <= 40", "raid20.buff(774)", "raid20.health <= 90" }, "raid20" }, -- Rejuv.
        { "Swiftmend", { "raid21.range <= 40", "raid21.buff(774)", "raid21.health <= 90" }, "raid21" }, -- Rejuv.
      }, "talent(7,3)" },
      {{
        { "Rejuvenation", { "lowest.health <= 91", "!player.buff(Rejuvenation)" }, "player" }, -- REJUVE check for swiftmend
        { "Swiftmend", { "lowest.range <= 40", "lowest.buff(774)", "lowest.health <= 90" }, "lowest" }, -- Rejuv.
        { "Swiftmend", { "focus.range <= 40", "focus.buff(774)", "focus.health <= 95" }, "focus" }, -- Rejuv.
        { "Swiftmend", { "tank.buff(774)", "tank.health <= 95" }, "tank" }, -- Rejuv.
        { "Swiftmend", { "raid1.range <= 40","raid1.buff(774)", "raid1.health <= 90" }, "raid1" }, -- Rejuv.
        { "Swiftmend", { "player.buff(774)", "player.health <= 90" }, "player" }, -- Rejuv.
        { "Swiftmend", { "raid2.range <= 40", "raid2.buff(774)", "raid2.health <= 90" }, "raid2" }, -- Rejuv.
        { "Swiftmend", { "raid3.range <= 40", "raid3.buff(774)", "raid3.health <= 90" }, "raid3" }, -- Rejuv.
        { "Swiftmend", { "raid4.range <= 40", "raid4.buff(774)", "raid4.health <= 90" }, "raid4" }, -- Rejuv.
        { "Swiftmend", { "raid5.range <= 40", "raid5.buff(774)", "raid5.health <= 90" }, "raid5" }, -- Rejuv.
        { "Swiftmend", { "raid6.range <= 40", "raid6.buff(774)", "raid6.health <= 90" }, "raid6" }, -- Rejuv.
        { "Swiftmend", { "raid7.range <= 40", "raid7.buff(774)", "raid7.health <= 90" }, "raid7" }, -- Rejuv.
        { "Swiftmend", { "raid8.range <= 40", "raid8.buff(774)", "raid8.health <= 90" }, "raid8" }, -- Rejuv.
        { "Swiftmend", { "raid9.range <= 40", "raid9.buff(774)", "raid9.health <= 90" }, "raid9" }, -- Rejuv.
        { "Swiftmend", { "raid10.range <= 40", "raid10.buff(774)", "raid10.health <= 90" }, "raid10" }, -- Rejuv.
        { "Swiftmend", { "raid11.range <= 40", "raid11.buff(774)", "raid11.health <= 90" }, "raid11" }, -- Rejuv.
        { "Swiftmend", { "raid12.range <= 40", "raid12.buff(774)", "raid12.health <= 90" }, "raid12" }, -- Rejuv.
        { "Swiftmend", { "raid13.range <= 40", "raid13.buff(774)", "raid13.health <= 90" }, "raid13" }, -- Rejuv.
        { "Swiftmend", { "raid14.range <= 40", "raid14.buff(774)", "raid14.health <= 90" }, "raid14" }, -- Rejuv.
        { "Swiftmend", { "raid15.range <= 40", "raid15.buff(774)", "raid15.health <= 90" }, "raid15" }, -- Rejuv.
        { "Swiftmend", { "raid16.range <= 40", "raid16.buff(774)", "raid16.health <= 90" }, "raid16" }, -- Rejuv.
        { "Swiftmend", { "raid17.range <= 40", "raid17.buff(774)", "raid17.health <= 90" }, "raid17" }, -- Rejuv.
        { "Swiftmend", { "raid18.range <= 40", "raid18.buff(774)", "raid18.health <= 90" }, "raid18" }, -- Rejuv.
        { "Swiftmend", { "raid19.range <= 40", "raid19.buff(774)", "raid19.health <= 90" }, "raid19" }, -- Rejuv.
        { "Swiftmend", { "raid20.range <= 40", "raid20.buff(774)", "raid20.health <= 90" }, "raid20" }, -- Rejuv.
        { "Swiftmend", { "raid21.range <= 40", "raid21.buff(774)", "raid21.health <= 90" }, "raid21" }, -- Rejuv.
      }, "talent(4,1)" },

      ---------------------------
      --        GENESIS       --
      ---------------------------
      { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving", "@coreHealing.needsHealing(60, 6)", "lowest.buff(Rejuvenation).duration >= 1"},},
      { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving", "@coreHealing.needsHealing(30, 3)", "lowest.buff(Rejuvenation).duration >= 1"},},
      {{
        { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving","lowest.health <= 25", "lowest.buff(Rejuvenation).duration >= 1"},},
        { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving","tank.health <= 25", "tank.buff(Rejuvenation).duration >= 1" },},
        { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving","focus.health <= 25", "focus.buff(Rejuvenation).duration >= 1"},},
      }, "talent(7,2)" },
      {{
        { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving","lowest.health <= 25"},},
        { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving","tank.health <= 25"},},
        { "Genesis", { "!lastcast(Genesis)", "player.spell(132158).cooldown >= 2", "player.spell(Swiftmend).cooldown >= 1", "player.moving","focus.health <= 25"},},
      }, "!talent(7,2)" },

      ---------------------------
      --          GERM        --
      ---------------------------
      {{
        { "Rejuvenation", { "lowest.range <= 40", "lowest.health <= 82", "!lowest.buff(155777)" }, "lowest" }, --germ.
        { "Rejuvenation", { "focus.range <= 40", "focus.health <= 85", "!focus.buff(155777)" }, "focus" }, -- germ
        { "Rejuvenation", { "tank.range <= 40", "tank.health <= 85", "!tank.buff(155777)" }, "tank" }, -- germ
      }, "talent(7,2)" },
      ---------------------------
      --        REJUV          --
      ---------------------------
      { "Rejuvenation", { "lowest.range <= 40", "!lowest.buff(774)", "lowest.health <= 88" }, "lowest" }, -- Rejuv.
      { "Rejuvenation", { "focus.range <= 40", "!focus.buff(774)", "focus.health <= 89" }, "focus" }, -- Rejuv.
      { "Rejuvenation", { "tank.range <= 40", "!tank.buff(774)", "tank.health <= 87" }, "tank" }, -- Rejuv.

      ---------------------------
      --      PARTY MODE      --
      ---------------------------
      {{--  Rejuventation/germination PARTY mode
        --Germ
        {{
          { "Rejuvenation", { "player.health <= 85", "!player.buff(155777)" }, "player" }, -- germ
          { "Rejuvenation", { "party1.range <= 40", "party1.health <= 85","!party1.buff(155777)" }, "party1" }, --germ
          { "Rejuvenation", { "party2.range <= 40", "party2.health <= 85", "!party2.buff(155777)" }, "party2" }, -- germ
          { "Rejuvenation", { "party3.range <= 40", "party3.health <= 85", "!party3.buff(155777)" }, "party3" }, -- germ.
          { "Rejuvenation", { "party4.range <= 40", "party4.health <= 85", "!party4.buff(155777)" }, "party4" }, -- germ.
        }, "talent(7,2)" },
        --Rejuv
        { "Rejuvenation", { "!player.buff(774)", "player.health <= 95" }, "player" }, -- Rejuv.
        { "Rejuvenation", { "party1.range <= 40", "!party1.buff(774)", "party1.health <= 95" }, "party1" }, -- Rejuv.
        { "Rejuvenation", { "party2.range <= 40", "!party2.buff(774)", "party2.health <= 95" }, "party2" }, -- Rejuv.
        { "Rejuvenation", { "party3.range <= 40", "!party3.buff(774)", "party3.health <= 95" }, "party3" }, -- Rejuv.
        { "Rejuvenation", { "party4.range <= 40", "!party4.buff(774)", "party4.health <= 95" }, "party4" }, -- Rejuv.
      }, "!modifier.raid" },

      ---------------------------
      --       RAID MODE      --
      ---------------------------
      {{
        --Germ
        {{
          { "Rejuvenation", { "player.health <= 80","!player.buff(155777)" }, "player" }, -- germ
          { "Rejuvenation", { "raid1.range <= 40","raid1.health <= 75","!raid1.buff(155777)" }, "raid1" }, -- germ.
          { "Rejuvenation", { "raid2.range <= 40","raid2.health <= 75","!raid2.buff(155777)" }, "raid2" }, -- germ.
          { "Rejuvenation", { "raid3.range <= 40","raid3.health <= 75","!raid3.buff(155777)" }, "raid3" }, -- germ.
          { "Rejuvenation", { "raid4.range <= 40","raid4.health <= 75","!raid4.buff(155777)" }, "raid4" }, -- germ.
          { "Rejuvenation", { "raid5.range <= 40","raid5.health <= 75","!raid5.buff(155777)" }, "raid5" }, -- germ.
          { "Rejuvenation", { "raid6.range <= 40","raid6.health <= 75","!raid6.buff(155777)" }, "raid6" }, -- germ.
          { "Rejuvenation", { "raid7.range <= 40","raid7.health <= 75","!raid7.buff(155777)" }, "raid7" }, -- germ.
          { "Rejuvenation", { "raid8.range <= 40","raid8.health <= 75","!raid8.buff(155777)" }, "raid8" }, -- germ.
          { "Rejuvenation", { "raid9.range <= 40","raid9.health <= 75","!raid9.buff(155777)" }, "raid9" }, -- germ.
          { "Rejuvenation", { "raid10.range <= 40","raid10.health <= 75","!raid10.buff(155777)" }, "raid10" }, -- germ.
          { "Rejuvenation", { "raid11.range <= 40","raid11.health <= 75","!raid11.buff(155777)" }, "raid11" }, -- germ.
          { "Rejuvenation", { "raid12.range <= 40","raid12.health <= 75","!raid12.buff(155777)" }, "raid12" }, -- germ.
          { "Rejuvenation", { "raid13.range <= 40","raid13.health <= 75","!raid13.buff(155777)" }, "raid13" }, -- germ.
          { "Rejuvenation", { "raid14.range <= 40","raid14.health <= 75","!raid14.buff(155777)" }, "raid14" }, -- germ.
          { "Rejuvenation", { "raid15.range <= 40","raid15.health <= 75","!raid15.buff(155777)" }, "raid15" }, -- germ.
          { "Rejuvenation", { "raid16.range <= 40","raid16.health <= 75","!raid16.buff(155777)" }, "raid16" }, -- germ.
          { "Rejuvenation", { "raid17.range <= 40","raid17.health <= 75","!raid17.buff(155777)" }, "raid17" }, -- germ.
          { "Rejuvenation", { "raid18.range <= 40","raid18.health <= 75","!raid18.buff(155777)" }, "raid18" }, -- germ.
          { "Rejuvenation", { "raid19.range <= 40","raid19.health <= 75","!raid19.buff(155777)" }, "raid19" }, -- germ.
          { "Rejuvenation", { "raid20.range <= 40","raid20.health <= 75","!raid20.buff(155777)" }, "raid20" }, -- germ.
          { "Rejuvenation", { "raid21.range <= 40","raid21.health <= 75","!raid21.buff(155777)" }, "raid21" }, -- germ.
        }, "talent(7,2)"},
        { "Rejuvenation", { "!player.buff(774)", "player.health <= 85" }, "player" }, -- Rejuv.
        { "Rejuvenation", { "raid1.range <= 40","!raid1.buff(774)", "raid1.health <= 85" }, "raid1" }, -- Rejuv.
        { "Rejuvenation", { "raid2.range <= 40","!raid2.buff(774)", "raid2.health <= 85" }, "raid2" }, -- Rejuv.
        { "Rejuvenation", { "raid3.range <= 40","!raid3.buff(774)", "raid3.health <= 85" }, "raid3" }, -- Rejuv.
        { "Rejuvenation", { "raid4.range <= 40","!raid4.buff(774)", "raid4.health <= 85" }, "raid4" }, -- Rejuv.
        { "Rejuvenation", { "raid5.range <= 40","!raid5.buff(774)", "raid5.health <= 85" }, "raid5" }, -- Rejuv.
        { "Rejuvenation", { "raid6.range <= 40","!raid6.buff(774)", "raid6.health <= 85" }, "raid6" }, -- Rejuv.
        { "Rejuvenation", { "raid7.range <= 40","!raid7.buff(774)", "raid7.health <= 85" }, "raid7" }, -- Rejuv.
        { "Rejuvenation", { "raid8.range <= 40","!raid8.buff(774)", "raid8.health <= 85" }, "raid8" }, -- Rejuv.
        { "Rejuvenation", { "raid9.range <= 40","!raid9.buff(774)", "raid9.health <= 85" }, "raid9" }, -- Rejuv.
        { "Rejuvenation", { "raid10.range <= 40","!raid10.buff(774)", "raid10.health <= 85" }, "raid10" }, -- Rejuv.
        { "Rejuvenation", { "raid11.range <= 40","!raid11.buff(774)", "raid11.health <= 85" }, "raid11" }, -- Rejuv.
        { "Rejuvenation", { "raid12.range <= 40","!raid12.buff(774)", "raid12.health <= 85" }, "raid12" }, -- Rejuv.
        { "Rejuvenation", { "raid13.range <= 40","!raid13.buff(774)", "raid13.health <= 85" }, "raid13" }, -- Rejuv.
        { "Rejuvenation", { "raid14.range <= 40","!raid14.buff(774)", "raid14.health <= 85" }, "raid14" }, -- Rejuv.
        { "Rejuvenation", { "raid15.range <= 40","!raid15.buff(774)", "raid15.health <= 85" }, "raid15" }, -- Rejuv.
        { "Rejuvenation", { "raid16.range <= 40","!raid16.buff(774)", "raid16.health <= 85" }, "raid16" }, -- Rejuv.
        { "Rejuvenation", { "raid17.range <= 40","!raid17.buff(774)", "raid17.health <= 85" }, "raid17" }, -- Rejuv.
        { "Rejuvenation", { "raid18.range <= 40","!raid18.buff(774)", "raid18.health <= 85" }, "raid18" }, -- Rejuv.
        { "Rejuvenation", { "raid19.range <= 40","!raid19.buff(774)", "raid19.health <= 85" }, "raid19" }, -- Rejuv.
        { "Rejuvenation", { "raid20.range <= 40","!raid20.buff(774)", "raid20.health <= 85" }, "raid20" }, -- Rejuv.
        { "Rejuvenation", { "raid21.range <= 40","!raid21.buff(774)", "raid21.health <= 85" }, "raid21" }, -- Rejuv.
      },{ "modifier.raid","player.spell(Rejuvenation).casted <= 6" } },

      -----------------------------
      --REGROWTH OR HEALING TOUCH--
      -----------------------------
      ---------------------------
      --       REGROWTH     --     -- REGROWTH IS BETTER THAN HEALING TOUCH IF GLYPHED
      ---------------------------
      {{
        {{
          { "Regrowth", { "!player.moving", "lowest.buff(Rejuvenation)", "lowest.range <= 40", "lowest.health <= 50" }, "lowest" },
          { "Regrowth", { "!player.moving", "tank.buff(Rejuvenation)", "tank.range <= 40", "tank.health <= 65" }, "tank" },
          { "Regrowth", { "!player.moving", "focus.buff(Rejuvenation)", "focus.range <= 40", "focus.health <= 65" }, "focus" },
        }, "!talent(7,2)" },
        {{--155777 is germination
          { "Regrowth", { "!player.moving", "lowest.buff(155777)", "lowest.range <= 40", "lowest.health <= 50" }, "lowest" },
          { "Regrowth", { "!player.moving", "tank.buff(155777)", "tank.range <= 40", "tank.health <= 65" }, "tank" },
          { "Regrowth", { "!player.moving", "focus.buff(155777)", "focus.range <= 40", "focus.health <= 65" }, "focus" },
        }, "talent(7,2)" },
      }, "glyph(116218)" },

      ---------------------------
      --     HEALING TOUCH     ---- Healing touch is better if not glyphed (non emergency)
      ---------------------------
      {{
        {{-- IF
          { "Healing Touch", { "!player.moving", "lowest.buff(774)", "lowest.range <= 40", "lowest.health <= 70" }, "lowest" },
          { "Healing Touch", { "!player.moving", "tank.buff(774)", "tank.range <= 40", "tank.health <= 80" }, "tank" },
          { "Healing Touch", { "!player.moving", "focus.buff(774)", "focus.range <= 40", "focus.health <= 80" }, "focus" },
        }, "!talent(7,2)" },
        {{--155777 is germination
          { "Healing Touch", { "!player.moving", "lowest.buff(155777)", "lowest.range <= 40", "lowest.health <= 70" }, "lowest" },
          { "Healing Touch", { "!player.moving", "tank.buff(155777)", "tank.range <= 40", "tank.health <= 80" }, "tank" },
          { "Healing Touch", { "!player.moving", "focus.buff(155777)", "focus.range <= 40", "focus.health <= 80" }, "focus" },
        }, "talent(7,2)" },
      }, "!glyph(116218)" },

    ---------------------------
    --      END MANA CHECK  --
    ---------------------------
    --END Mana Check
    }, "player.mana > 5" },

    ---------------------------
    --      OOM ROTATION     --
    ---------------------------
    { {
      { {
        --Incarnation OOM Support
        { {
          { "Rejuvenation", {"lowest.range <= 40", "lowest.health <= 80","!lowest.buff(155777)"}, "lowest" }, --germ.
          { "Rejuvenation", {"focus.range <= 40",  "focus.health <= 90","!focus.buff(155777)"}, "focus" }, -- germ
          { "Rejuvenation", {"tank.range <= 40",  "tank.health <= 90","!tank.buff(155777)"}, "tank" }, -- germ
        }, "talent(6,3)"},
        { "Rejuvenation", {"lowest.range <= 40", "!lowest.buff(774)", "lowest.health <= 90"}, "lowest" }, -- Rejuv.
        { "Rejuvenation", {"focus.range <= 40", "!focus.buff(774)", "focus.health <= 95"}, "focus" }, -- Rejuv.
        { "Rejuvenation", {"tank.range <= 40","!tank.buff(774)", "tank.health <= 95"}, "tank" }, -- Rejuv.
      }, "player.buff(117679)" },

      { "Wrath", {"!player.moving","target.enemy", "talent(6,2)","target.range <= 40"}},--WRATH IF DoC
      { "Wrath", {"!player.moving", "player.buff(124974)","target.enemy","target.range <= 40"}},--wrath if Nature Vigil
      { "124974", {"talent(6,3)", "!player.buff(117679)"},},--natures vigil
      { "Healing Touch", {"!player.moving","tank.range <= 40", "tank.health <= 20"},"tank"},
      { "Healing Touch", {"!player.moving","lowest.range <= 40", "lowest.health <= 90"},"lowest"},
    }, "player.mana <= 10" },

    ---------------------------
    --  TARGETING AND FOCUS  --
    ---------------------------
    { {
      { "/targetenemy [noexists]", "!target.exists" },
      { "/focus [@targettarget]", { "target.enemy","target(target).friend" } },
      { "/target [target=focustarget, harm, nodead]", "target.range > 40" },
    }, "toggle.AutoTarget"},

  },{
    ---------------------------
    --      OUT OF COMBAT    --
    ---------------------------
    { "1126", "!player.buffs.stats" }, --stats
    { "Wild Mushroom", { "modifier.rcontrol", "player.glyph(146654)" }, "mouseover.ground" }, --Shroom
    { "Wild Mushroom", { "modifier.rcontrol", "!player.glyph(146654)" }, "player" }, --Shroom

  },function()
    NetherMachine.toggle.create('WildGrowth', 'Interface\\Icons\\ability_druid_flourish', 'Wild Growth','Toggle on/off use of Wild Growth')
    NetherMachine.toggle.create('ShroomPlace', 'Interface\\Icons\\druid_ability_wildmushroom_a', 'Auto Shroom no Glyph','On for Tank / Off for Player')
    NetherMachine.toggle.create('AutoTarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target and Focus','Target boss and focus currently active Tank')
  end)
