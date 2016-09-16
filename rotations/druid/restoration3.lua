-- NetherMachine Rotation
-- Restoration Druid - WoD 7.0
-- Updated on Sep 13th 2016

-- PLAYER CONTROLLED:
-- Talents: 1213113
-- CONTROLS: Pause - Left Control
-- TODO: Actually use talents, mouseover rez/rebirth, OOC rotation.

NetherMachine.rotation.register_custom(105, "bbDruid Restoration - Raid", {
-- COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },
  { "pause", "player.buff(Prowl)" },


  { "/stopcasting", { "boss2.exists", "player.casting", "boss2.casting(Interrupting Shout)" } }, -- boss2 Pol  Interrupting Shout
  { "#trinket2", "player.mana < 90" }, -- Everburning Candle 10k mana
  { "#trinket1", "player.mana < 80" }, -- Shards of Nothing haste

  -- BATTLE REZ
  { "Rebirth", { "target.exists", "target.friend", "target.dead", "target.player", "!player.moving" }, "target" },

  -- DISPELLS
  { "Nature's Cure", { "toggle.dispel", "mouseover.exists", "mouseover.friend", "mouseover.dispellable" }, "mouseover" }, -- Proving Grounds
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Shadow Word: Bane)" }, "mouseover" }, -- Fallen Protectors
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Lingering Corruption)" }, "mouseover" }, -- Norushen
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Mark of Arrogance)", "player.buff(Power of the Titans)" }, "mouseover" }, -- Sha of Pride
  -- { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Corrosive Blood)" }, "mouseover" }, -- Thok

  -- HEALING COOLDOWNS
  { "Tranquility", { "modifier.raid", "@coreHealing.needsHealing(60, 10)", "!player.moving" } },
  { "Tranquility", { "!modifier.raid", "@coreHealing.needsHealing(60, 4)", "!player.moving" } },
  --{ "Nature's Swiftness", "lowest.health < 30" },
  { "Nature's Swiftness", { "!player.buff(Nature's Swiftness)", "focus.exists", "focus.friend", "focus.health < 80", "focus.range < 40" }, "focus" },
  { "Healing Touch", { "player.buff(Nature's Swiftness)", "focus.exists", "focus.friend", "focus.health < 80", "focus.range < 40" }, "focus" },
  { "Nature's Swiftness", { "!player.buff(Nature's Swiftness)", "tank.exists", "tank.friend", "tank.health < 80", "tank.range < 40" }, "tank" },
  { "Healing Touch", { "player.buff(Nature's Swiftness)", "tank.exists", "tank.friend", "tank.health < 80", "tank.range < 40" }, "tank" },
  { {
    { "Genesis", { "party1.buff(Rejuvenation)", "party2.buff(Rejuvenation)", "party3.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0", "player.area(60).friendly > 3" }, "player" },
    { "Genesis", { "party1.buff(Rejuvenation)", "party2.buff(Rejuvenation)", "party4.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0", "player.area(60).friendly > 3" }, "player" },
    { "Genesis", { "party1.buff(Rejuvenation)", "party3.buff(Rejuvenation)", "party4.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0", "player.area(60).friendly > 3" }, "player" },
    { "Genesis", { "party2.buff(Rejuvenation)", "party3.buff(Rejuvenation)", "party4.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0", "player.area(60).friendly > 3" }, "player" },
  },{
    "!modifier.raid", "@coreHealing.needsHealing(70, 3)", "player.buff(Rejuvenation)",
  } },



  -- Swiftmend should primarily be used:
  --    when a single target is in urgent need for a quick (instant cast) heal.


  -- Healing Touch should primarily be used:
  --    on players who are taking a particularly high amount of damage;
  -- Regrowth should primarily be used:
  --    on players who are about to die before you can get another, longer cast off, when no instant cast spells are available;
  --    on the tank, or another raid member who is low on health or who will take damage soon, if you have an Omen of Clarity proc.


  -- WILD GROWTH
  --    to heal large bursts of damage, but beware of the high mana cost of this spell, and use it sparingly.
  { "Wild Growth", { "focus.exists", "focus.friend", "focus.health <= 90", "!player.moving", "@coreHealing.needsHealing(70, 4)", "focus.area(30).friendly > 3" }, "focus" }, -- Upto 5 within 30yd
  { "Wild Growth", { "tank.health <= 90", "!player.moving", "@coreHealing.needsHealing(70, 4)", "tank.area(30).friendly > 3" }, "tank" },
  { "Wild Growth", { "player.health <= 90", "!player.moving", "@coreHealing.needsHealing(70, 4)", "player.area(30).friendly > 3" }, "player" },

  -- PLAYER HEALING
  { "Swiftmend", { "player.health < 50", "player.buff(Rejuvenation)" }, "player" },
  { "Swiftmend", { "player.health < 50", "player.buff(Regrowth)" }, "player" },
  { "Regrowth", { "player.health < 40", "!player.buff(Regrowth)", "!player.moving" }, "player" },

  -- CLEARCASTING PROCS
  { {
    { "Regrowth", { "focus.exists", "focus.friend", "focus.health < 90", "!focus.buff(Regrowth)", "focus.distance < 40" }, "focus" },
    { "Regrowth", { "tank.health < 90", "!tank.buff(Regrowth)", "tank.distance < 40" }, "tank" },
    { "Regrowth", { "player.health < 80", "!player.buff(Regrowth)" }, "player" },
    { "Regrowth", { "lowest.health < 80", "!lowest.buff(Regrowth)",  "lowest.distance < 40" }, "lowest" },
  },{
    "!player.moving", "player.buff(Clearcasting).remains >= 2", "!modifier.last(Regrowth)"
  } },

  -- LIFEBLOOM
  --    on the tank, or another target who is taking heavy sustained damage.
  { "Lifebloom", { "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')", "boss1target.buff(Lifebloom).remains < 2" }, "boss1target" },
  { "Lifebloom", { "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "!boss1target.buff(Lifebloom)", "focus.buff(Lifebloom).remains < 2" }, "focus" },
  { "Lifebloom", { "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "!focus.buff(Lifebloom)", "!boss1target.buff(Lifebloom)", "tank.buff(Lifebloom).remains < 2" }, "tank" },

  -- SHROOMS
  -- Wild Mushroom Icon Wild Mushroom should be used:
  --    to heal groups of players who are standing together;
  --    before a burst of damage will hit the raid, to heal players through it, allowing you to cast other spells;
  --    note that with Glyph of the Sprouting Mushroom Icon Glyph of the Sprouting Mushroom, you can place the Wild Mushroom healing zone at any desired location.
  { "Wild Mushroom", { "toggle.shrooms", "!player.glyph(146654)", "focus.health < 95", "!focus.moving", (function() return GetTotemInfo(1) == false end), "focus.area(7).friendly > 2" }, "focus" },
  { "Wild Mushroom", { "toggle.shrooms", "player.glyph(146654)", "focus.health < 95", "!focus.moving", (function() return GetTotemInfo(1) == false end), "focus.area(7).friendly > 2" }, "focus.ground" },
  { "Wild Mushroom", { "toggle.shrooms", "!player.glyph(146654)", "tank.health < 95", "!tank.moving", (function() return GetTotemInfo(1) == false end), "tank.area(7).friendly > 2" }, "tank" },
  { "Wild Mushroom", { "toggle.shrooms", "player.glyph(146654)", "tank.health < 95", "!tank.moving", (function() return GetTotemInfo(1) == false end), "tank.area(7).friendly > 2" }, "tank.ground" },
  { "Wild Mushroom", { "!toggle.shrooms", "!player.glyph(146654)", "player.health < 95", "!player.moving", (function() return GetTotemInfo(1) == false end), "player.area(7).friendly > 2" }, "player" },
  { "Wild Mushroom", { "!toggle.shrooms", "player.glyph(146654)", "player.health < 95", "!player.moving", (function() return GetTotemInfo(1) == false end), "player.area(7).friendly > 2" }, "player.ground" },

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
    { {
      { "Rejuvenation", { "party1.health < 90", "party1.buff(774).remains >= 3", "party1.buff(155777).remains <= 3" }, "party1" },
      { "Rejuvenation", { "party2.health < 90", "party2.buff(774).remains >= 3", "party2.buff(155777).remains <= 3" }, "party2" },
      { "Rejuvenation", { "party3.health < 90", "party3.buff(774).remains >= 3", "party3.buff(155777).remains <= 3" }, "party3" },
      { "Rejuvenation", { "party4.health < 90", "party4.buff(774).remains >= 3", "party4.buff(155777).remains <= 3" }, "party4" },
    }, "talent(7,2)" }, -- Germination
    { "Rejuvenation", { "party1.health < 100", "party1.buff(774).remains <= 3" }, "party1" },
    { "Rejuvenation", { "party2.health < 100", "party2.buff(774).remains <= 3" }, "party2" },
    { "Rejuvenation", { "party3.health < 100", "party3.buff(774).remains <= 3" }, "party3" },
    { "Rejuvenation", { "party4.health < 100", "party4.buff(774).remains <= 3" }, "party4" },
  }, "!modifier.raid" },

  -- RAID HEALING
  { {
    { {
      { "Rejuvenation", { "raid1.health <= 80", "raid1.buff(774).remains >= 2", "raid1.buff(155777).remains <= 2" }, "raid1" },
      { "Rejuvenation", { "raid2.health <= 80", "raid2.buff(774).remains >= 2", "raid2.buff(155777).remains <= 2" }, "raid2" },
      { "Rejuvenation", { "raid3.health <= 80", "raid3.buff(774).remains >= 2", "raid3.buff(155777).remains <= 2" }, "raid3" },
      { "Rejuvenation", { "raid4.health <= 80", "raid4.buff(774).remains >= 2", "raid4.buff(155777).remains <= 2" }, "raid4" },
      { "Rejuvenation", { "raid5.health <= 80", "raid5.buff(774).remains >= 2", "raid5.buff(155777).remains <= 2" }, "raid5" },
      { "Rejuvenation", { "raid6.health <= 80", "raid6.buff(774).remains >= 2", "raid6.buff(155777).remains <= 2" }, "raid6" },
      { "Rejuvenation", { "raid7.health <= 80", "raid7.buff(774).remains >= 2", "raid7.buff(155777).remains <= 2" }, "raid7" },
      { "Rejuvenation", { "raid8.health <= 80", "raid8.buff(774).remains >= 2", "raid8.buff(155777).remains <= 2" }, "raid8" },
      { "Rejuvenation", { "raid9.health <= 80", "raid9.buff(774).remains >= 2", "raid9.buff(155777).remains <= 2" }, "raid9" },
      { "Rejuvenation", { "raid10.health <= 80", "raid10.buff(774).remains >= 2", "raid10.buff(155777).remains <= 2" }, "raid10" },
      { "Rejuvenation", { "raid11.health <= 80", "raid11.buff(774).remains >= 2", "raid11.buff(155777).remains <= 2" }, "raid11" },
      { "Rejuvenation", { "raid12.health <= 80", "raid12.buff(774).remains >= 2", "raid12.buff(155777).remains <= 2" }, "raid12" },
      { "Rejuvenation", { "raid13.health <= 80", "raid13.buff(774).remains >= 2", "raid13.buff(155777).remains <= 2" }, "raid13" },
      { "Rejuvenation", { "raid14.health <= 80", "raid14.buff(774).remains >= 2", "raid14.buff(155777).remains <= 2" }, "raid14" },
      { "Rejuvenation", { "raid15.health <= 80", "raid15.buff(774).remains >= 2", "raid15.buff(155777).remains <= 2" }, "raid15" },
      { "Rejuvenation", { "raid16.health <= 80", "raid16.buff(774).remains >= 2", "raid16.buff(155777).remains <= 2" }, "raid16" },
      { "Rejuvenation", { "raid17.health <= 80", "raid17.buff(774).remains >= 2", "raid17.buff(155777).remains <= 2" }, "raid17" },
      { "Rejuvenation", { "raid18.health <= 80", "raid18.buff(774).remains >= 2", "raid18.buff(155777).remains <= 2" }, "raid18" },
      { "Rejuvenation", { "raid19.health <= 80", "raid19.buff(774).remains >= 2", "raid19.buff(155777).remains <= 2" }, "raid19" },
      { "Rejuvenation", { "raid20.health <= 80", "raid20.buff(774).remains >= 2", "raid20.buff(155777).remains <= 2" }, "raid20" },
    }, "talent(7,2)" }, -- Germination
    { "Rejuvenation", { "raid1.health <= 90", "raid1.buff(774).remains <= 2" }, "raid1" },
    { "Rejuvenation", { "raid2.health <= 90", "raid2.buff(774).remains <= 2" }, "raid2" },
    { "Rejuvenation", { "raid3.health <= 90", "raid3.buff(774).remains <= 2" }, "raid3" },
    { "Rejuvenation", { "raid4.health <= 90", "raid4.buff(774).remains <= 2" }, "raid4" },
    { "Rejuvenation", { "raid5.health <= 90", "raid5.buff(774).remains <= 2" }, "raid5" },
    { "Rejuvenation", { "raid6.health <= 90", "raid6.buff(774).remains <= 2" }, "raid6" },
    { "Rejuvenation", { "raid7.health <= 90", "raid7.buff(774).remains <= 2" }, "raid7" },
    { "Rejuvenation", { "raid8.health <= 90", "raid8.buff(774).remains <= 2" }, "raid8" },
    { "Rejuvenation", { "raid9.health <= 90", "raid9.buff(774).remains <= 2" }, "raid9" },
    { "Rejuvenation", { "raid10.health <= 90", "raid10.buff(774).remains <= 2" }, "raid10" },
    { "Rejuvenation", { "raid11.health <= 90", "raid11.buff(774).remains <= 2" }, "raid11" },
    { "Rejuvenation", { "raid12.health <= 90", "raid12.buff(774).remains <= 2" }, "raid12" },
    { "Rejuvenation", { "raid13.health <= 90", "raid13.buff(774).remains <= 2" }, "raid13" },
    { "Rejuvenation", { "raid14.health <= 90", "raid14.buff(774).remains <= 2" }, "raid14" },
    { "Rejuvenation", { "raid15.health <= 90", "raid15.buff(774).remains <= 2" }, "raid15" },
    { "Rejuvenation", { "raid16.health <= 90", "raid16.buff(774).remains <= 2" }, "raid16" },
    { "Rejuvenation", { "raid17.health <= 90", "raid17.buff(774).remains <= 2" }, "raid17" },
    { "Rejuvenation", { "raid18.health <= 90", "raid18.buff(774).remains <= 2" }, "raid18" },
    { "Rejuvenation", { "raid19.health <= 90", "raid19.buff(774).remains <= 2" }, "raid19" },
    { "Rejuvenation", { "raid20.health <= 90", "raid20.buff(774).remains <= 2" }, "raid20" },
  },{
    "modifier.raid" --, "player.mana > 50"
  } },

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
