-- SPEC ID 105 (Restoration)
-- Restoration Druid - Legion 7.0.3 - Raid
-- Updated on Sep 23rd 2016

--[[
As of 10/2/16
These rough stat weights are meant as a way to guide you towards the correct pieces. iLvl is generally the correct choice.

Raiding String: ( Pawn: v1: "RdruidRaid":    CritRating=0.70, HasteRating=0.725, MasteryRating=0.60, Versatility=0.65, Stamina=0.01, Intellect=1 )
Dungeon String: ( Pawn: v1: "RdruidDungeon": CritRating=0.70, HasteRating=0.750, MasteryRating=0.90, Versatility=0.65, Stamina=0.01, Intellect=1 )
]]--

-- Talents: (1,2) Cenarion Ward, (2,2) Displacer Beast, (3,2) Feral Affinity, (4,1) Mighty Bash, (5,3) Cultivation (6,1) Spring Blossoms, (7,3) Flourish
-- m+ is CW, germ, cultivation and stonebark
-- m+ Rake > shred to 5 combo > rip > sunfire/moon fire > wrath till rake is falling off
-- CONTROLS: Pause - Left Control
-- TODO: Actually use talents, mouseover rez/rebirth, OOC rotation.

NetherMachine.rotation.register_custom(105, "|cFF99FF00Legion |cFFFF6600Resto Druid |cFFFF9999(Raid)", {

-- COMBAT ROTATION
  { {
    {"Rip", { "player.combopoints > 4", "target.debuff(Rip).duration < 2", }},
    {"Ferocious Bite", { "player.combopoints > 4", "target.debuff(Rip).duration > 6", }},
    {"Rake", { "target.debuff(Rake).duration < 3" }},
    {"Shred" },
  },{ "player.buff(Cat Form)" } },

  --Make sure we have some mana for emergency healing
  {{

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
      { "Rejuvenation", { "lowest.health < 88", "lowest.buff(774).remains <= 3" }, "lowest" },
      { "Rejuvenation", { "lowest.health < 72", "lowest.buff(155777).remains <= 3" }, "lowest" },
    }, "player.moving" },

    -- DISPELLS
    { "Nature's Cure", { "toggle.dispel", "mouseover.exists", "mouseover.friend", "mouseover.dispellable" }, "mouseover" }, -- Proving Grounds
    { "Nature's Cure", { "toggle.dispel", "mouseover.exists", "mouseover.friend", "mouseover.debuff(Touch of Corruption)" }, "mouseover" }, -- Fallen Protectors

    -- HEALING COOLDOWNS
    { "Flourish", { "modifier.raid", "@coreHealing.needsHealing(70, 5)" }, "lowest" },
    { "Tranquility", { "modifier.raid", "@coreHealing.needsHealing(58, 6)" } },

    -- PLAYER HEALING
    { "Barkskin", { "player.health < 40" }, "player" },
    { "Swiftmend", { "player.health < 50", "player.buff(Rejuvenation)" }, "player" },
    { "Swiftmend", { "player.health < 50", "player.buff(Regrowth)" }, "player" },
    { "Regrowth", { "player.health < 60", "!player.buff(Regrowth)", "!player.moving" }, "player" },

    --Cenarion Ward
    { "Cenarion Ward", { "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')", "modifier.cooldowns" }, "boss1target" },
    { "Cenarion Ward", { "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "modifier.cooldowns" }, "focus" },
    { "Cenarion Ward", { "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "modifier.cooldowns" }, "tank" },

    -- LIFEBLOOM
    --    on the tank, or another target who is taking heavy sustained damage.
    { "Lifebloom", { "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')", "boss1target.buff(Lifebloom).remains < 2" }, "boss1target" },
    { "Lifebloom", { "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "!boss1target.buff(Lifebloom)", "focus.buff(Lifebloom).remains < 2" }, "focus" },
    { "Lifebloom", { "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "!focus.buff(Lifebloom)", "!boss1target.buff(Lifebloom)", "tank.buff(Lifebloom).remains < 2" }, "tank" },
    -- Refresh for insta heal if below 95%
    { "Lifebloom", { "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "@bbLib.isTank('boss1target')", "boss1target.buff(Lifebloom).remains < 6", "boss1target1.health < 95" }, "boss1target" },
    { "Lifebloom", { "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "!boss1target.buff(Lifebloom)", "focus.buff(Lifebloom).remains < 6", "focus.health < 95" }, "focus" },
    { "Lifebloom", { "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "!focus.buff(Lifebloom)", "!boss1target.buff(Lifebloom)", "tank.buff(Lifebloom).remains < 6", "tank.health < 95" }, "tank" },


    -- WILD GROWTH
    --    to heal large bursts of damage, but beware of the high mana cost of this spell, and use it sparingly.
    { "Wild Growth", { "focus.exists", "focus.friend", "focus.health <= 90", "!player.moving", "@coreHealing.needsHealing(75, 4)", "focus.area(30).friendly > 3" }, "focus" }, -- Upto 5 within 30yd
    { "Wild Growth", { "tank.health <= 90", "!player.moving", "@coreHealing.needsHealing(75, 4)", "tank.area(30).friendly > 3" }, "tank" },
    { "Wild Growth", { "player.health <= 90", "!player.moving", "@coreHealing.needsHealing(75, 4)", "player.area(30).friendly > 3" }, "player" },

    -- CLEARCASTING PROCS
    { {
      { "Regrowth", { "focus.exists", "focus.friend", "focus.health < 90", "!focus.buff(Regrowth)", "focus.distance < 40" }, "focus" },
      { "Regrowth", { "tank.health < 90", "!tank.buff(Regrowth)", "tank.distance < 40" }, "tank" },
      { "Regrowth", { "player.health < 80", "!player.buff(Regrowth)" }, "player" },
      { "Regrowth", { "lowest.health < 80", "!lowest.buff(Regrowth)",  "lowest.buff(774)", "lowest.distance < 40" }, "lowest" },
    },{
      "!player.moving", "player.buff(Clearcasting).remains >= 2", "!modifier.last(Regrowth)"
    } },

    -- Innervate Free casting (priority)
    --    to pre-HoT players before a spike of damage;
    { "Wild Growth", { "player.buff(Innervate)", "!player.moving", "tank.area(30).friendly > 3" }, "tank" },
    { "Regrowth", { "lowest.health < 85", "!lowest.buff(Regrowth)", "lowest.buff(774)", "player.buff(Innervate)", "lowest.distance < 40" }, "lowest" },
    { "Rejuvenation", { "lowest.health < 90", "!lowest.buff(774)", "player.buff(Innervate)", "lowest.distance < 40" }, "lowest" },

    -- REJUVENATION (priority)
    --    to pre-HoT players before a spike of damage;
    --    to act as a pre-requisite for casting Swiftmend on players;
    --    to heal players who have taken damage.
    { "Rejuvenation", { "player.health < 88", "player.buff(774).remains <= 3" }, "player" },
    { "Rejuvenation", { "player.health < 67", "talent(6, 3)", "player.buff(774).remains > 3", "!player.buff(155777)" }, "player" },
    { "Rejuvenation", { "boss1target.health < 91", "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "boss1target.buff(774).remains <= 3" }, "boss1target" },
    { "Rejuvenation", { "boss1target.health < 74", "boss1target.exists", "boss1target.alive", "boss1target.friend", "boss1target.distance < 40", "talent(6, 3)", "boss1target.buff(774).remains > 3", "!boss1target.buff(155777)" }, "boss1target" },
    { "Rejuvenation", { "focus.health < 91", "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "focus.buff(774).remains <= 3" }, "focus" },
    { "Rejuvenation", { "focus.health < 74", "focus.exists", "focus.alive", "focus.friend", "focus.distance < 40", "talent(6, 3)", "focus.buff(774).remains > 3", "!focus.buff(155777)" }, "focus" },
    { "Rejuvenation", { "tank.health < 91", "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "tank.buff(774).remains <= 3" }, "tank" },
    { "Rejuvenation", { "tank.health < 74", "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40", "talent(6, 3)", "tank.buff(774).remains > 3", "!tank.buff(155777)" }, "tank" },

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
      { "Swiftmend", { "tank.health < 70", "tank.buff(Rejuvenation)" }, "tank" },
      { "Swiftmend", { "tank.health < 70", "tank.buff(Regrowth)" }, "tank" },
      { "Regrowth", { "tank.health < 40", "!tank.buff(Regrowth)", "!player.moving" }, "tank" },
    },{
      "tank.exists", "tank.alive", "tank.friend", "tank.distance < 40",
    } },

    -- MOUSEOVER HEALING
    { "Rejuvenation", { "toggle.mouseover", "mouseover.exists", "mouseover.friend", "!mouseover.buff(774)", "mouseover.distance < 40" }, "mouseover" },
    { "Rejuvenation", { "toggle.mouseover", "mouseover.exists", "mouseover.friend", "!mouseover.buff(155777)", "mouseover.distance < 40", "talent(6, 3)" }, "mouseover" },
    --{ "Regrowth", { "toggle.mouseover", "mouseover.exists", "mouseover.friend", "mouseover.health < 70", "!mouseover.buff(Regrowth)", "mouseover.distance < 40" }, "mouseover" },

    -- LOWEST EMERGENCY HEALING
    { "Swiftmend", { "lowest.health < 40", "lowest.buff(774)", "!talent(6,3)" }, "lowest" },
    { "Swiftmend", { "lowest.health < 40", "lowest.buff(774)", "lowest.buff(155777)", "talent(6,3)" }, "lowest" },
    { "Swiftmend", { "lowest.health < 40", "lowest.buff(Regrowth)" }, "lowest" },

    -- RAID HEALING
    { {
      { {
        { "Rejuvenation", { "lowest.health <= 65", "lowest.buff(774).remains >= 2", "lowest.buff(155777).remains <= 2" }, "lowest" },
        { "Rejuvenation", { "raid1.health <= 65", "raid1.buff(774).remains >= 2", "raid1.buff(155777).remains <= 2" }, "raid1" },
        { "Rejuvenation", { "raid2.health <= 65", "raid2.buff(774).remains >= 2", "raid2.buff(155777).remains <= 2" }, "raid2" },
        { "Rejuvenation", { "raid3.health <= 65", "raid3.buff(774).remains >= 2", "raid3.buff(155777).remains <= 2" }, "raid3" },
        { "Rejuvenation", { "raid4.health <= 65", "raid4.buff(774).remains >= 2", "raid4.buff(155777).remains <= 2" }, "raid4" },
        { "Rejuvenation", { "raid5.health <= 65", "raid5.buff(774).remains >= 2", "raid5.buff(155777).remains <= 2" }, "raid5" },
        { "Rejuvenation", { "raid6.health <= 65", "raid6.buff(774).remains >= 2", "raid6.buff(155777).remains <= 2" }, "raid6" },
        { "Rejuvenation", { "raid7.health <= 65", "raid7.buff(774).remains >= 2", "raid7.buff(155777).remains <= 2" }, "raid7" },
        { "Rejuvenation", { "raid8.health <= 65", "raid8.buff(774).remains >= 2", "raid8.buff(155777).remains <= 2" }, "raid8" },
        { "Rejuvenation", { "raid9.health <= 65", "raid9.buff(774).remains >= 2", "raid9.buff(155777).remains <= 2" }, "raid9" },
        { "Rejuvenation", { "raid10.health <= 65", "raid10.buff(774).remains >= 2", "raid10.buff(155777).remains <= 2" }, "raid10" },
        { "Rejuvenation", { "raid11.health <= 65", "raid11.buff(774).remains >= 2", "raid11.buff(155777).remains <= 2" }, "raid11" },
        { "Rejuvenation", { "raid12.health <= 65", "raid12.buff(774).remains >= 2", "raid12.buff(155777).remains <= 2" }, "raid12" },
        { "Rejuvenation", { "raid13.health <= 65", "raid13.buff(774).remains >= 2", "raid13.buff(155777).remains <= 2" }, "raid13" },
        { "Rejuvenation", { "raid14.health <= 65", "raid14.buff(774).remains >= 2", "raid14.buff(155777).remains <= 2" }, "raid14" },
        { "Rejuvenation", { "raid15.health <= 65", "raid15.buff(774).remains >= 2", "raid15.buff(155777).remains <= 2" }, "raid15" },
        { "Rejuvenation", { "raid16.health <= 65", "raid16.buff(774).remains >= 2", "raid16.buff(155777).remains <= 2" }, "raid16" },
        { "Rejuvenation", { "raid17.health <= 65", "raid17.buff(774).remains >= 2", "raid17.buff(155777).remains <= 2" }, "raid17" },
        { "Rejuvenation", { "raid18.health <= 65", "raid18.buff(774).remains >= 2", "raid18.buff(155777).remains <= 2" }, "raid18" },
        { "Rejuvenation", { "raid19.health <= 65", "raid19.buff(774).remains >= 2", "raid19.buff(155777).remains <= 2" }, "raid19" },
        { "Rejuvenation", { "raid20.health <= 65", "raid20.buff(774).remains >= 2", "raid20.buff(155777).remains <= 2" }, "raid20" },
      }, "talent(6,3)" }, -- Germination
      { "Rejuvenation", { "lowest.health <= 84", "lowest.buff(774).remains <= 2" }, "lowest" },
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
      "modifier.raid", "player.mana > 8"
    } },

  }, "player.mana > 5" },

}, {
-- OUT OF COMBAT ROTATION

  -- HEALING
  { "Rejuvenation", { "player.health < 90", "!player.buff(Rejuvenation)" }, "player" },
  { "Rejuvenation", { "player.health < 80", "!player.buff(155777)" }, "player" },

  { "Lifebloom", { "focus.exists", "focus.alive", "focustarget.exists", "focustarget.enemy", "focus.buff(Lifebloom).remains < 2", "focus.distance < 40" }, "focus" },
  { "Lifebloom", { "tank.exists", "tank.alive", "tanktarget.exists", "tanktarget.enemy", "!focus.buff(Lifebloom)", "tank.buff(Lifebloom).remains < 2", "tank.distance < 40" }, "tank" },
  { "Rejuvenation", { "lowest.health < 90", "!lowest.buff(Rejuvenation)", "lowest.distance < 40" }, "lowest" },
  --{ "Regrowth", { "lowest.health < 80", "!lowest.buff(Regrowth)", "lowest.distance < 40", "!player.moving" }, "lowest" },

  -- REZ
  { "Revive", { "target.exists", "target.player", "target.dead", "!player.moving"  }, "target" },

},
function()
  NetherMachine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
  NetherMachine.toggle.create('mouseover', 'Interface\\Icons\\spell_nature_faeriefire', 'Mouseover Regrowth', 'Toggle Mouseover Regrowth For SoO NPC Healing')
end)
