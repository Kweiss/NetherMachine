-- NetherMachine Rotation
-- Restoration Druid - WoD 7.0
-- Updated on Sep 13th 2016

-- PLAYER CONTROLLED:
-- Talents: 1213113
-- CONTROLS: Pause - Left Control
-- TODO: Actually use talents, mouseover rez/rebirth, OOC rotation.

NetherMachine.rotation.register_custom(105, "Druid Restoration - 5man", {
-- COMBAT ROTATION
  -- PAUSE
  { "pause", "@bbLib.pauses" },
  { "pause", "player.buff(Prowl)" },

  -- Keybinding
  { "Efflorescence", "modifier.lshift", "ground" },
  { "Stampeding Roar", "modifier.lalt" },

  { "/stopcasting", { "boss2.exists", "player.casting", "boss2.casting(Interrupting Shout)" } }, -- boss2 Pol  Interrupting Shout
  -- { "#trinket2", "player.mana < 90" }, -- Everburning Candle 10k mana
  -- { "#trinket1", "player.mana < 80" }, -- Shards of Nothing haste

  -- BATTLE REZ
  { "Rebirth", { "target.exists", "target.friend", "target.dead", "target.player", "!player.moving" }, "target" },

  -- Survival on Self
  { "#Healthstone", "player.health <= 50" },
  { "Innervate", "player.mana < 75 " },

  -- moving
  { {
    { "Rejuvenation", { "party1.health < 88", "party1.buff(774).remains <= 3" }, "party1" },
    { "Rejuvenation", { "party2.health < 88", "party2.buff(774).remains <= 3" }, "party2" },
    { "Rejuvenation", { "party3.health < 88", "party3.buff(774).remains <= 3" }, "party3" },
    { "Rejuvenation", { "party4.health < 88", "party4.buff(774).remains <= 3" }, "party4" },
  }, "player.moving" },


  -- DISPELLS
  { "Nature's Cure", { "toggle.dispel", "mouseover.exists", "mouseover.friend", "mouseover.dispellable" }, "mouseover" }, -- Proving Grounds
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Shadow Word: Bane)" }, "mouseover" }, -- Fallen Protectors
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Lingering Corruption)" }, "mouseover" }, -- Norushen
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Mark of Arrogance)", "player.buff(Power of the Titans)" }, "mouseover" }, -- Sha of Pride
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Corrosive Blood)" }, "mouseover" }, -- Thok

  -- HEALING COOLDOWNS
    { "Tranquility", { "@coreHealing.needsHealing(60, 4)", "!player.moving" } },

  -- PLAYER HEALING
  { "Swiftmend", { "player.health < 50", "player.buff(Rejuvenation)" }, "player" },
  { "Swiftmend", { "player.health < 50", "player.buff(Regrowth)" }, "player" },
  { "Regrowth", { "player.health < 40", "!player.buff(Regrowth)", "!player.moving" }, "player" },

  -- LIFEBLOOM
  --    on the tank, or another target who is taking heavy sustained damage.
  { "Lifebloom", { "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')", "boss1target.buff(Lifebloom).remains < 2" }, "boss1target" },
  { "Lifebloom", { "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "!boss1target.buff(Lifebloom)", "focus.buff(Lifebloom).remains < 2" }, "focus" },
  { "Lifebloom", { "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "!focus.buff(Lifebloom)", "!boss1target.buff(Lifebloom)", "tank.buff(Lifebloom).remains < 2" }, "tank" },


  -- WILD GROWTH
  --    to heal large bursts of damage, but beware of the high mana cost of this spell, and use it sparingly.
  { "Wild Growth", { "focus.exists", "focus.friend", "focus.health <= 90", "!player.moving", "@coreHealing.needsHealing(70, 4)", "focus.area(30).friendly > 3" }, "focus" }, -- Upto 5 within 30yd
  { "Wild Growth", { "tank.health <= 90", "!player.moving", "@coreHealing.needsHealing(70, 4)", "tank.area(30).friendly > 3" }, "tank" },
  { "Wild Growth", { "player.health <= 90", "!player.moving", "@coreHealing.needsHealing(70, 4)", "player.area(30).friendly > 3" }, "player" },

  -- CLEARCASTING PROCS
  { {
    { "Regrowth", { "focus.exists", "focus.friend", "focus.health < 90", "!focus.buff(Regrowth)", "focus.distance < 40" }, "focus" },
    { "Regrowth", { "tank.health < 90", "!tank.buff(Regrowth)", "tank.distance < 40" }, "tank" },
    { "Regrowth", { "player.health < 80", "!player.buff(Regrowth)" }, "player" },
    { "Regrowth", { "lowest.health < 80", "!lowest.buff(Regrowth)",  "lowest.distance < 40" }, "lowest" },
  },{
    "!player.moving", "player.buff(Clearcasting).remains >= 2", "!modifier.last(Regrowth)"
  } },

  -- REJUVENATION (priority)
  --    to pre-HoT players before a spike of damage;
  --    to act as a pre-requisite for casting Swiftmend on players;
  --    to heal players who have taken damage.
  { "Rejuvenation", { "player.health < 100", "player.buff(774).remains <= 3" }, "player" },
  { "Rejuvenation", { "player.health < 80", "talent(7, 2)", "player.buff(774).remains > 3", "!player.buff(155777)" }, "player" },
  { "Rejuvenation", { "boss1target.health < 100", "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "boss1target.buff(774).remains <= 3" }, "boss1target" },
  { "Rejuvenation", { "boss1target.health < 90", "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "talent(7, 2)", "boss1target.buff(774).remains > 3", "!boss1target.buff(155777)" }, "boss1target" },
  { "Rejuvenation", { "focus.health < 100", "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "focus.buff(774).remains <= 3" }, "focus" },
  { "Rejuvenation", { "focus.health < 100", "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "talent(7, 2)", "focus.buff(774).remains > 3", "!focus.buff(155777)" }, "focus" },
  { "Rejuvenation", { "tank.health < 100", "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "tank.buff(774).remains <= 3" }, "tank" },
  { "Rejuvenation", { "tank.health < 100", "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "talent(7, 2)", "tank.buff(774).remains > 3", "!tank.buff(155777)" }, "tank" },

  -- BOSS1TARGET HEALING
  { {
    { "Ironbark", "boss1target.health < 70", "boss1target" },
    { "Swiftmend", { "boss1target.health < 70", "boss1target.buff(Rejuvenation)" }, "boss1target" },
    { "Swiftmend", { "boss1target.health < 70", "boss1target.buff(Regrowth)" }, "boss1target" },
    { "Regrowth", { "boss1target.health < 40", "!boss1target.buff(Regrowth)", "!player.moving" }, "boss1target" },
  },{
    "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')",
  } },

  -- FOCUS HEALING
  { {
    { "Ironbark", "focus.health < 70", "focus" },
    { "Swiftmend", { "focus.health < 70", "focus.buff(Rejuvenation)" }, "focus" },
    { "Swiftmend", { "focus.health < 70", "focus.buff(Regrowth)" }, "focus" },
    { "Regrowth", { "focus.health < 40", "!focus.buff(Regrowth)", "!player.moving" }, "focus" },
  },{
    "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40",
  } },

  -- TANK HEALING
  { {
    { "Ironbark", "tank.health < 70", "tank" },
    { "Swiftmend", { "tank.health < 70", "focus.buff(Rejuvenation)" }, "tank" },
    { "Swiftmend", { "tank.health < 70", "focus.buff(Regrowth)" }, "tank" },
    { "Regrowth", { "tank.health < 40", "!tank.buff(Regrowth)", "!player.moving" }, "tank" },
  },{
    "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40",
  } },

  -- MOUSEOVER HEALING
  { "Rejuvenation", { "toggle.mouseover", "mouseover.exists", "mouseover.friend", "!mouseover.buff(Rejuvenation)", "mouseover.distance < 40" }, "mouseover" },
  --{ "Regrowth", { "toggle.mouseover", "mouseover.exists", "mouseover.friend", "mouseover.health < 70", "!mouseover.buff(Regrowth)", "mouseover.distance < 40" }, "mouseover" },

  -- LOWEST EMERGENCY HEALING
  { "Swiftmend", { "lowest.health < 30", "lowest.buff(Rejuvenation)" }, "lowest" },
  { "Swiftmend", { "lowest.health < 30", "lowest.buff(Regrowth)" }, "lowest" },

  -- PARTY HEALING
  { {
    { "Regrowth", { "party1.health < 81", "party1.buff(Regrowth).remains <= 3" }, "party1" },
    { "Regrowth", { "party2.health < 81", "party2.buff(Regrowth).remains <= 3" }, "party2" },
    { "Regrowth", { "party3.health < 81", "party3.buff(Regrowth).remains <= 3" }, "party3" },
    { "Regrowth", { "party4.health < 81", "party4.buff(Regrowth).remains <= 3" }, "party4" },
  }, "!modifier.raid" },

  { {
    { "Rejuvenation", { "party1.health < 93", "party1.buff(774).remains <= 3" }, "party1" },
    { "Rejuvenation", { "party2.health < 93", "party2.buff(774).remains <= 3" }, "party2" },
    { "Rejuvenation", { "party3.health < 93", "party3.buff(774).remains <= 3" }, "party3" },
    { "Rejuvenation", { "party4.health < 93", "party4.buff(774).remains <= 3" }, "party4" },
  }, "!modifier.raid" },


  -- FILLER
  { "Healing Touch", { "lowest.health < 80", "!player.moving" }, "lowest" },
  { "Treant Form", { "toggle.forms", "player.form = 0", "!player.buff(Treant Form)", "!player.buff(Dash)", "!modifier.last", "!player.outdoors" } },
  --{ "Wrath", "lowest.health > 99", "target" },

}, {
-- OUT OF COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lalt" },
  { "pause", "@bbLib.pauses" },
  { "pause", "player.buff(Prowl)" },

  -- BUFFS
  { "Mark of the Wild", "!player.buffs.stats" },

  -- HEALING
  { "Renewal", { "talent(2, 2)", "player.health < 80" }, "player" },
  { "Rejuvenation", { "player.health < 90", "!player.buff(Rejuvenation)" }, "player" },
  { "Healing Touch", { "player.health < 70" }, "player" },
  { "Lifebloom", { "focus.exists", "focus.alive", "focustarget.exists", "focustarget.enemy", "focus.buff(Lifebloom).remains < 2", "focus.distance < 40" }, "focus" },
  { "Lifebloom", { "tank.exists", "tank.alive", "tanktarget.exists", "tanktarget.enemy", "!focus.buff(Lifebloom)", "tank.buff(Lifebloom).remains < 2", "tank.distance < 40" }, "tank" },
  { "Rejuvenation", { "lowest.health < 90", "!lowest.buff(Rejuvenation)", "lowest.distance < 40" }, "lowest" },
  --{ "Regrowth", { "lowest.health < 80", "!lowest.buff(Regrowth)", "lowest.distance < 40", "!player.moving" }, "lowest" },

  -- REZ
  { "Revive", { "target.exists", "target.player", "target.dead", "!player.moving"  }, "target" },

  -- Cleanse Debuffs
  { "Remove Corruption", "player.dispellable(Remove Corruption)", "player" },

  -- AUTO FOLLOW
  { "Mark of the Wild", { "toggle.autofollow", "focus.exists", "focus.alive", (function() return GetFollowTarget() == nil end), (function() SetFollowTarget('focus') end) } }, -- TODO: NYI: isFollowing()

  -- AUTO FORMS
  { {
    { "pause", { "target.exists", "target.istheplayer" } },
    { "/cancelform", { "target.isfriendlynpc", "!player.form = 0", "!player.ininstance", "target.range <= 2" } },
    { "pause", { "target.isfriendlynpc", "target.range <= 2" } },
    { "Travel Form", { "!player.form = 3", "!target.exists", "!player.ininstance", "player.moving", "player.outdoors" } },
    { "Cat Form", { "!player.form = 2", "!player.form = 3", "!target.exists", "player.moving" } },
    { "Treant Form", { "!player.buff(Treant Form)", "!modifier.last", "player.ininstance" } },
  },{
    "toggle.forms", "!player.flying", "!player.buff(Dash)",
  } },

},
function()
  NetherMachine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
  NetherMachine.toggle.create('mouseover', 'Interface\\Icons\\spell_nature_faeriefire', 'Mouseover Regrowth', 'Toggle Mouseover Regrowth For SoO NPC Healing')
  NetherMachine.toggle.create('forms', 'Interface\\Icons\\ability_druid_treeoflife', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
  NetherMachine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target, including NPCs.')
  NetherMachine.toggle.create('shrooms', 'Interface\\Icons\\druid_ability_wildmushroom_a', 'Shroom Tank/Player', 'ON = Tank; OFF = Player')
end)
