-- SPEC ID 268 Brewmaster
NetherMachine.rotation.register(268, {

  --------------------
  -- Start Rotation --
  --------------------

  --Interrupts
  { "Spear Hand Strike", { "target.interruptAt(75)", "!modifier.last(Leg Sweep)", "modifier.interrupt" }},
	{ "Leg Sweep", { "target.interruptAt(75)", "!modifier.last(Spear Hand Strike", "modifier.interrupt", "target.range <= 10" }},

  { "Summon Black Ox Statue", "modifier.lshift", "ground" },

  -- Survival
  {{
    { "Black Ox Brew", "player.spell(115308).charges < 1"},
    { "115203", { "player.health <= 28", }}, --Fortifying Brew (7min CD... Ouch)

    { "#5512", { "player.health <= 50" }}, --Healthstone

    --Iron Skin Logic (Must Have Aggro)
    {{
      { "115308", { "player.health < 95", "!player.buff(Ironskin Brew)", "player.spell(115308).charges > 2" }}, -- Ironskin
      { "115308", { "player.health < 92", "player.buff(Ironskin Brew).duration < 2", "player.spell(115308).charges > 1" }}, -- Ironskin
      { "115308", { "player.health < 76", "player.buff(Ironskin Brew).duration < 2" }}, -- Ironskin
    }, { "target.threat >= 100" } },

    { "115308", { "player.health < 66", "player.buff(Ironskin Brew).duration < 2" }}, -- Ironskin

    -- { "119582", { "player.debuf(Moderate Stagger)", "player.spell(119582).charges > 1" }}, -- Purifying Brew
    { "119582", { "player.debuf(Heavy Stagger)", "player.spell(119582).charges > 1" }}, -- Purifying Brew

    { "Chi Wave", "player.health < 78" },
    { "Chi Burst", "player.health < 73" },
    { "214326", { "modifier.cooldowns", "modifier.lcontrol" }, "ground" }, --Exploding Keg

    },{
  		"target.exists", "target.enemy", "target.alive",
  } },

  --Damage
  { "Blackout Strike", {"talent(7,2)", "!player.buff(Blackout Combo)"} },

  { "Keg Smash", "!talent(7,2)" },
  { "Keg Smash", "player.buff(Blackout Combo)" },
  { "Keg Smash", {"talent(7,2)", "player.spell(Blackout Strike).cooldown > .5" } },

  { "Tiger Palm", {"!player.buff(Blackout combo)", "player.energy > 75", "player.spell(Blackout Strike).cooldown > .5"} },

  { "Blackout Strike",  "!talent(7,2)" },

  { "Breath of Fire", { "player.buff(Blackout Combo)", "target.range <= 10"} },
  { "Breath of Fire", { "!talent(7,2)", "target.range <= 10"} },

  { "115072", { "player.health <= 70", "!modifier.last(115072)",  }}, --Expel Harm

  { "Rushing Jade Wind", },
  { "Tiger Palm", {"talent(6,1)", "player.buff(Rushing Jade Wind)", "player.energy > 65" } },
  { "Tiger Palm", {"!talent(6,1)", "player.energy > 70" } },

  },{

  ---------------
  -- OOC Begin --
  ---------------


  -------------
  -- OOC End --
  -------------
}, function()
NetherMachine.toggle.create('disable', 'Interface\\Icons\\spell_nature_rejuvenation', 'Disable', 'Toggle Disable')
end)
