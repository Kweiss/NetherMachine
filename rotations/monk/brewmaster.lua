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
    { "115203", { "player.health <= 15", }}, --Fortifying Brew (7min CD... Ouch)

    { "#5512", { "player.health <= 50" }}, --Healthstone

    --Iron Skin Logic (Must Have Aggro)
    {{
      { "115308", { "player.health < 85", "!player.buff(Ironskin Brew)", "player.spell(115308).charges > 2" }}, -- Ironskin
      { "115308", { "player.health < 60", "player.buff(Ironskin Brew).count < 2", "player.spell(115308).charges > 1" }}, -- Ironskin
      { "115308", { "player.health < 40", "player.buff(Ironskin Brew).count < 2", "player.buff(Ironskin Brew).duration < 2" }}, -- Ironskin
      { "115308", { "player.health < 27", "player.buff(Ironskin Brew).count < 2" } }, -- Ironskin
    }, { "target.threat >= 100" } },

    { "119582", { "player.health <= 73", "player.debuf(Moderate Stagger)", "player.spell(119582).charges > 1" }}, -- Purifying Brew
    { "119582", { "player.health <= 85", "player.debuf(Heavy Stagger)", "player.spell(119582).charges > 1" }}, -- Purifying Brew

    { "Chi Wave", "player.health < 78" },
    { "214326", { "modifier.cooldowns", "modifier.lcontrol" }, "ground" }, --Exploding Keg

    },{
  		"target.exists", "target.enemy", "target.alive",
  } },

  --Damage
  { "Blackout Strike",  "talent(7,2)" },

  { "Keg Smash", "!talent(7,2)" },
  { "Keg Smash", "player.buff(Blackout Combo)" },
  { "Keg Smash", "player.spell(Blackout Strike).cooldown > .5" },
  { "Tiger Palm", "player.energy > 65" },

  { "115072", { "player.health <= 70", "!modifier.last(115072)",  }}, --Expel Harm

  { "Blackout Strike",  "!talent(7,2)" },
  { "Rushing Jade Wind", },
  { "Breath of Fire", { "target.debuff(Dizzying Haze)", } },

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















--[[

-- Survival
{ "Expel Harm", "player.health < 95" },
{ "Fortifying Brew", "player.health <= 50" },

{ "Dampen Harm", "player.health <= 60" },
{ "Diffuse Magic", "player.health <= 60" },

-- Multitarget
{ "Rushing Jade Wind", {
  "modifier.multitarget",
  "!player.buff(Rushing Jade Wind)",
  "!player.buff(Rushing Jade Wind).duration < 2",
}},

{ "Spinning Crane Kick", "modifier.multitarget" },

-- Ground Stuff

{ "Summon Black Ox Statue", "modifier.control", "ground" },
{ "Healing Sphere", "modifer.alt", "ground" },

-- Interrupts
{ "Spear Hand Strike", "modifier.interrupts" },
{ "Grapple Weapon", "modifier.interrupts" },
{ "Leg Sweep", "modifier.interrupts", "target.range <= 10" },

-- PvP
{ "Disable", { "toggle.disable", "!target.debuff(Disable)" } },

-- Talents
{ "Chi Wave" },
{ "Zen Sphere", "!player.buff(Zen Sphere)", "player" },
{ "Chi Burst" },
{ "Invoke Xuen, the White Tiger" },
{ "Tiger's Lust", "target.range >= 15" },

-- Brews
{ "Purifying Brew", "player.debuff(Moderate Stagger)" },
{ "Purifying Brew", "player.debuff(Heavy Stagger)" },


-- Rotation
{ "Keg Smash" },


{ "Breath of Fire", {
  "target.debuff(Dizzying Haze)",
  "!target.debuff(Breath of Fire)",
}},

{ "Tiger Palm",  },
{ "Blackout Kick" },

{ "Tiger Palm" },

------------------
-- End Rotation --
------------------


-- Buffs
{ "Legacy of the Emperor", "!player.buff(Legacy of the Emperor)" },

-- Ground Stuff
{ "Dizzying Haze", "modifier.shift", "ground" },
{ "Summon Black Ox Statue", "modifier.control", "ground" },
{ "Healing Sphere", "modifier.alt", "ground" },

]]--
