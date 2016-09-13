NetherMachine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return NetherMachine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for unit,_ in pairs(NetherMachine.raid.roster) do
      if UnitDebuff(unit, spell) then
        NetherMachine.dsl.parsedTarget = unit
        return true
      end
    end
  end,
})

-- NetherMachine Rotation
-- Holy Priest - WoD 6.1
-- Updated on March 27th 2015

-- PLAYER CONTROLLED (TODO): Leap of Faith, Levitate, Shackle Undead, Mass Dispel, Dispel Magic, Purify, Fear Ward, Holy Nova, Prayer of Healing, Pain Suppression, Power Word: Barrier
-- TALENTS: Desperate Prayer, Body and Soul, Surge of Light, Psychic Scream, Power Infusion, Cascade, Clarity of Will
-- GLYPHS: Glyph of Penance, Glyph of Weakened Soul, Glyph of Holy Fire
-- CONTROLS: Pause - Left Control

-- target, focus, tank, boss1target, lowest
-- mt heal, raid heal mode
-- auto target and dps mode
-- auto follow tank
-- PWS with body soul talent on person with marks in raid liek on blackhand

NetherMachine.rotation.register_custom(257, "bbPriest Holy", {
-- COMBAT ROTATION
  -- Pause Rotation
  { "pause", "modifier.lalt" },
  { "pause", "player.buff(Food)" },

  --{ "/stopcasting", { "player.casting(Mind Sear)", "focus.area(7).enemies < 3" } },
  --{ "/stopcasting", { "player.casting(Mind Sear)", "lowest.health < 90" } },

  -- DISPELLS
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Aqua Bomb)" }, "mouseover" }, -- Proving Grounds
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Shadow Word: Bane)" }, "mouseover" }, -- Fallen Protectors
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Lingering Corruption)" }, "mouseover" }, -- Norushen
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Mark of Arrogance)", "player.buff(Power of the Titans)" }, "mouseover" }, -- Sha of Pride
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Corrosive Blood)" }, "mouseover" }, -- Thok
  -- Dispel Magic Removes 1 beneficial Magic effect from an enemy.
  { "Dispel Magic", { "target.exists", "target.enemy", "target.alive", "target.dispellable" }, "target" },
  -- Mass Dispel - Removes one harmful magical effect from every friendly target and one beneficial magical effect from every enemy target in an area. If Glyph of Mass Dispel Icon Glyph of Mass Dispel is used, then it also removes effects that are not normally dispellable.
  -- Purify - Removes all Magic and Disease effects from a friendly target (8-second cooldown)
  { "Purify", { "player.dispellable" }, "player" },
  { "Purify", { "target.exists", "target.friend", "target.alive", "target.dispellable" }, "target" },
  { "Purify", { "focus.exists", "focus.friend", "focus.alive", "focus.dispellable" }, "focus" },
  { "Purify", { "tank.exists", "tank.alive", "target.dispellable" }, "tank" },

  -- DEFENSIVE COOLDOWNS
  { "Psychic Scream", { "talent(4, 2)", "player.area(3).enemies > 2" } },
  { "Fade", { "talent(2, 3)", "player.state.stun" } },
  { "Fade", { "talent(2, 3)", "player.state.root" } },
  { "Fade", { "talent(2, 3)", "player.state.snare" } },
  { "Fade", "player.agro" },
  { "Angelic Feather", { "player.movingfor > 2", "!player.buff", "!modifier.last" }, "player.ground" },
  { "Angelic Feather", { "focus.exists", "focus.friend", "focus.movingfor > 2", "!focus.buff", "!modifier.last" }, "focus.ground" },

  --{ "Fade", "player.area(1).enemies > 1" },

  -- SURGE OF LIGHT
  { "Flash Heal", { "lowest.health < 100", "player.buff(Surge of Light)" }, "lowest" },

  -- HEALING COOLDOWNS
  -- Pain Suppression should be used on a tank, before a damage spike. Alternatively, it can be used on a raid member who is targeted by a very damaging ability.
  -- Power Word: Barrier should be used to mitigate intense AoE damage; it requires the raid to be stacked in one place.
  -- Power Infusion should be used whenever a period of intense healing is coming up, or simply when you want to conserve your Mana. Exceptionally, you can use it to deal more damage, if the encounter calls for it.
  -- Spirit Shell should be used whenever there is high sustained damage to heal. You should aim to use it as many times as possible throughout the fight. It can also be used to pre-shield a target before they receive a lot of damage.
  { "Power Infusion", { "talent(5, 2)", "@coreHealing.needsHealing(70, 5)" } },
  -- Cascade is a sort of chain heal. It heals an initial target (with the healing being greater the farther away that target is), and then bouncing to additional allies up to 4 times. Each time that the heal bounces, it splits into 2 heals. It can never heal the same target twice.
  { "Cascade", { "talent(6, 1)", "lowest.health < 90", "@bbLib.NeedHealsAroundUnit('Cascade')" }, "lowest" },
  { "Mindbender", "player.mana < 90" },
  { "Shadowfiend", "player.mana < 90" },
  { "Lightwell", { "!modifier.raid", "@coreHealing.needsHealing(50, 2)" }, "player.ground" },
  { "Lightwell", { "modifier.raid", "@coreHealing.needsHealing(50, 5)" }, "player.ground" },

  -- Cooldowns
  -- Divine Hymn Icon Divine Hymn should be used during periods of very intense raid damage. Keep in mind, however, that your raid leader may instruct you to use it a very specific time.
  -- Lightwell Icon Lightwell should be active whenever a period of high and sustained occurs. Excluding such situations, you should try to cast it as often as possible.
  -- Guardian Spirit Icon Guardian Spirit should be used depending on many factors, including on your raid leader's instructions. If you do not have to save Guardian Spirit for a specific event, then just use it as a "life-saver" on the tank or another raid member who needs it.

  -- SELF HEALING
  { "Desperate Prayer", "player.health < 50", "player" },
  { "Flash Heal", { "!player.moving", "player.health < 70" }, "player" },
  { "Power Word: Shield", { "talent(2, 1)", "player.moving", "!player.debuff(Weakened Soul)", "!player.buff" }, "player" },

  { "Shackle Undead", { "target.enemy", "target.race(undead)", "target.alive", "target.health > 99", "!modifier.last" }, "target" },
  { "Shackle Undead", { "toggle.mouseover", "mouseover.race(undead)", "mouseover.exists", "mouseover.enemy", "mouseover.alive", "mouseover.health > 99", "!modifier.last" }, "mouseover" },

  -- EMERGENCY SITUATIONS
  -- Cast Guardian Spirit Icon Guardian Spirit on the tank if they are in imminent danger of dying. Note that you should not do this if you are assigned to use Guardian Spirit at another, specific time of the fight.
  { "Guardian Spirit", { "focus.exists", "focus.friend", "!player.moving", "focus.health < 30" }, "focus" }, -- TODO: Toggle
  { "Guardian Spirit", { "tank.exists", "tank.friend", "!player.moving", "tank.health < 30" }, "tank" },
  -- Cast Binding Heal (with Glyph of Binding Heal Icon Glyph of Binding Heal) on the tank if they are in danger of dying and you can also benefit from the healing.
  { "Binding Heal", { "focus.exists", "focus.friend", "!player.moving", "player.health < 90", "focus.health < 50" }, "focus" },
  { "Binding Heal", { "tank.exists", "tank.friend", "!player.moving", "player.health < 90", "tank.health < 50" }, "tank" },
  { "Binding Heal", { "boss1target.exists", "boss1target.friend", "!player.moving", "player.health < 90", "boss1target.health < 50" }, "boss1target" },
  { "Binding Heal", { "target.exists", "target.friend", "!player.moving", "player.health < 90", "target.health < 50" }, "target" },
  -- Cast Flash Heal Icon Flash Heal on the tank if they are in danger of dying.
  { "Flash Heal", { "focus.exists", "focus.friend", "!player.moving", "focus.health < 50" }, "focus" },
  { "Flash Heal", { "tank.exists", "tank.friend", "!player.moving", "tank.health < 50" }, "tank" },
  { "Flash Heal", { "boss1target.exists", "boss1target.friend", "!player.moving", "boss1target.health < 50" }, "boss1target" },
  { "Flash Heal", { "target.exists", "target.friend", "!player.moving", "target.health < 50" }, "target" },
  -- Cast Binding Heal Icon Binding Heal (with Glyph of Binding Heal Icon Glyph of Binding Heal) on a player that is really low on health and in imminent danger of dying, if you yourself are also in need of healing.
  { "Binding Heal", { "lowest.exists", "!player.moving", "player.health < 90", "lowest.health < 30" }, "lowest" },
  -- Cast Flash Heal Icon Flash Heal on a player that is really low on health and in imminent danger of dying.
  { "Flash Heal", { "lowest.exists", "!player.moving", "lowest.health < 30" }, "lowest" },
  -- If you have stacks of Serendipity Icon Serendipity (from having cast Flash Heal or Binding Heal), then you can use the hastened Heal Icon Heal or Prayer of Healing Icon Prayer of Healing for emergencies as well.
  -- TODO: Prayer of Healing
  { "Heal", { "focus.exists", "focus.friend", "!player.moving", "focus.health < 50", "player.buff(Serendipity)" }, "focus" },
  { "Heal", { "tank.exists", "tank.friend", "!player.moving", "tank.health < 50", "player.buff(Serendipity)" }, "tank" },
  { "Heal", { "boss1target.exists", "boss1target.friend", "!player.moving", "boss1target.health < 50", "player.buff(Serendipity)" }, "boss1target" },
  { "Heal", { "target.exists", "target.friend", "!player.moving", "target.health < 50", "player.buff(Serendipity)" }, "target" },
  { "Heal", { "lowest.exists", "!player.moving", "lowest.health < 30", "player.buff(Serendipity)" }, "lowest" },

  -- MODERATE HEALING
  -- Keep Renew Icon Renew up on the tank,
  { "Renew", { "focus.exists", "focus.friend", "!focus.buff" }, "focus" },
  { "Renew", { "tank.exists", "tank.friend", "!tank.buff" }, "tank" },
  { "Renew", { "boss1target.exists", "boss1target.friend", "!boss1target.buff" }, "boss1target" },
  -- Refresh Renew with Holy Word: Serenity.
  { "Holy Word: Serenity", { "focus.exists", "focus.friend", "focus.buff(Renew)", "focus.buff(Renew).remains < 4" }, "focus" },
  { "Holy Word: Serenity", { "tank.exists", "tank.friend", "tank.buff(Renew)", "tank.buff(Renew).remains < 4" }, "tank" },
  { "Holy Word: Serenity", { "boss1target.exists", "boss1target.friend", "boss1target.buff(Renew)", "boss1target.buff(Renew).remains < 4" }, "boss1target" },
  -- Power Word: Shield on tanks
  { "Power Word: Shield", { "focus.exists", "focus.friend", "!focus.buff(Weakened Soul)" }, "focus" },
  { "Power Word: Shield", { "!tank.buff(Weakened Soul)" }, "tank" },
  { "Power Word: Shield", { "boss1target.exists", "boss1target.friend", "!boss1target.buff(Weakened Soul)", "!boss1target.buff" }, "boss1target" },
  -- Place Holy Word: Sanctuary Icon Holy Word: Sanctuary on the ground, in an area where there are a lot of raid members. Ideally cast this a few seconds before the damage begins.
  -- TODO
  -- Pre-HoT some players with Renew Icon Renew.
  -- TODO
  -- Cast Circle of Healing Icon Circle of Healing on cooldown.
  { "Circle of Healing", "@coreHealing.needsHealing(80, 3)", "lowest" },
  -- Cast Prayer of Mending Icon Prayer of Mending on cooldown.
  -- Cast Prayer of Healing Icon Prayer of Healing (if the previous actions are not enough to cover the damage).
  { "Prayer of Healing", "@coreHealing.needsHealing(80, 3)", "lowest" },
  -- Cast Heal Icon Heal if additional healing is needed.
  { "Flash Heal", { "lowest.exists", "!player.moving", "lowest.health < 60" }, "lowest" },
  { "Flash Heal", { "lowest.exists", "!player.moving", "lowest.health <= 90", "player.level < 34" }, "lowest" },
  { "Heal", { "lowest.exists", "!player.moving", "lowest.health <= 90" }, "lowest" },

  -- DPS MODE
  { "Power Word: Solace", "target.combat" },
  { "Power Word: Solace", { "focus.exists", "focustarget.exists", "focustarget.enemy", "focustarget.alive", "focustarget.combat" }, "focustarget" },
  { {
    --{ "Mind Sear", { "!player.moving", "focus.exists", "focus.area(7).enemies > 2" }, "focus" },
    { "Shadow Word: Pain", "!target.debuff" },
    { "Shadow Word: Pain", { "focus.exists", "focustarget.exists", "focustarget.enemy", "focustarget.boss", "!focustarget.debuff" }, "focustarget" },
    { "Holy Fire" },
    { "Holy Fire", { "focus.exists", "focustarget.exists", "focustarget.enemy" }, "focustarget" },
    { "Smite", "!player.moving" },
    { "Smite", { "!player.moving", "focus.exists", "focustarget.exists", "focustarget.enemy" }, "focustarget" },
  },{
    "toggle.dps", "lowest.health > 90",
  } },

}, {
-- OUT OF COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lalt" },
  { "pause", "player.buff(Food)" },

  -- BUFFS
  { "Power Word: Fortitude", { "!lowest.buff", "lowest.distance < 40" }, "lowest" },
  { "Levitate", { "player.moving", "!player.buff", "!modifier.last" }, "player" }, --TODO: only if glyph of levitate
  { "Angelic Feather", { "talent(2, 2)", "player.movingfor > 2", "!player.buff" }, "player.ground" },
  { "Angelic Feather", { "talent(2, 2)", "focus.movingfor > 2", "!focus.buff" }, "focus.ground" },
  { "Power Word: Shield", { "talent(2, 1)", "player.moving", "!player.debuff(Weakened Soul)", "!player.buff" }, "player" },

  -- HEAL
  { "Renew", { "focus.moving", "focus.exists", "focus.friend", "!focus.buff" }, "focus" },
  { "Renew", { "tank.moving", "tank.exists", "tank.friend", "!tank.buff" }, "tank" },
  { "Renew", { "!lowest.buff", "lowest.health < 95" }, "lowest" },
  { "Power Word: Shield", { "focus.moving", "focus.exists", "focus.friend", "!focus.debuff(Weakened Soul)", "!focus.buff" }, "focus" },
  { "Power Word: Shield", { "tank.moving", "tank.exists", "tank.friend", "!tank.debuff(Weakened Soul)", "!tank.buff" }, "tank" },
  { "Flash Heal", { "!player.moving", "lowest.health < 70" }, "lowest" },
  { "Heal", { "!player.moving", "lowest.health < 90" }, "lowest" },

  -- AUTO FOLLOW
  { "/follow focus", { "toggle.autofollow", "focus.exists", "focus.alive", "focus.friend", "!focus.range < 3", "focus.range < 20" } }, -- TODO: NYI: isFollowing()

},
function()
  NetherMachine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
  NetherMachine.toggle.create('mouseover', 'Interface\\Icons\\spell_nature_resistnature', 'Mouseovers', 'Toggle usage of mouseover healing.')
  NetherMachine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target. Must be another player.')
  NetherMachine.toggle.create('dps', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'DPS Mode', 'DPS your focuses target')
  NetherMachine.toggle.create('levitate', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Levitate Party', 'Keeps Levitate on your party.')
end)









NetherMachine.rotation.register_custom(257, "bbPriest Holy (Experimental)", {
---------------------------
--   CHAKRA MANAGEMENT  --
---------------------------
{"Chakra: Sanctuary",{"player.stance != 2","modifier.rshift"}},
{"Chakra: Serenity",{"player.stance != 3","modifier.rshift"}},

---------------------------
--       SURVIVAL        --
---------------------------
{ "!19236", { "player.health <= 40" }, "Player" },--Desperate Prayer
{ "#5512", "player.health <= 50" },  --healthstone
---------------------------
--     MISC/MODIFIERS    --
---------------------------
{ "pause", "player.buff(Divine Hymn)" }, --Pause FOR Hymn
{ "!32375", "modifier.rcontrol", "mouseover.ground" }, --Mass Dispell
{ "586", "target.threat >= 80" },-- Fade
{ "!64843", "modifier.lalt" },  --Divine Hymn
{"724", "modifier.ralt", "mouseover.ground" }, --Lightwell
{"!88685", "modifier.lcontrol","mouseover.ground" },  --Holy Word: Sanctuary
---------------------------
--         MANA         --
---------------------------
{ "123040", {"player.mana < 95","target.spell(123040).range"}, "target" },
{ "129250", {"target.spell(129250).range" }, "target" },

---------------------------
--        DISPELLS       --
---------------------------
{"527", {"!lastcast(527)", "player.mana > 20", "@coreHealing.needsDispelled('Corrupted Blood')"	}, nil },
{"527", {"!lastcast(527)", "player.mana > 20","@coreHealing.needsDispelled('Slow')" }, nil },



---------------------------
--        TIER 6        --
---------------------------
{ "121135", "lowest.health <= 92", "lowest" },  --Cascade
{ "!120517", "modifier.lshift", "player" }, --Halo
{ "!110744", "modifier.lshift", "player" }, --Divine Star


---------------------------
--     PROC HEALING      --
---------------------------
--114255 SoL Buff
{"Flash Heal",{"tank.health <= 40", "player.buff(114255)"},"tank"}, --Surge of Light
{"Flash Heal",{"lowest.health <= 90", "player.buff(114255)", "lowest.range <= 40"},"lowest"}, --Surge of Light
--123267 DI Buff
{"Prayer of Mending",{"tank.health <= 40", "player.buff(123267)", "!lastcast(Prayer of Mending)"},"tank"}, -- Divine Insight
{"Prayer of Mending",{"lowest.health <= 95", "player.buff(123267)", "!lastcast(Prayer of Mending)","lowest.range <= 40"},"lowest"}, --Divine Insight

---------------------------
--     SERENITY BURST    --
---------------------------
--Will attempt  Serenity->Flash -> Flash -> Greater Heal combo
--if in correct chakra and nobody else is in danger of dying (good for focus healing)
{{
{"Holy Word: Serenity",{"lowest.health <= 50"},"lowest"},
{"Heal",{"!player.moving","lowest.health <= 50", "lowest.buff(88684)","lowest.range <= 40" ,"player.buff(63735).count = 2"},"lowest"},--63735 is Serendipity
{"Flash Heal",{"!player.moving","lowest.health <= 50", "lowest.range <= 40" ,"lowest.buff(88684)"},"lowest"},


--Note:  TANK will return FOCUS as target if a Focus EXISTS. SO just focus someone.
{"Holy Word: Serenity",{"tank.health <= 90"},"tank"},
{"Heal",{"!player.moving","tank.health <= 90", "tank.buff(88684)", "player.buff(63735).count = 2"},"tank"},--63735 is Serendipity
{"Flash Heal",{"!player.moving","tank.health <= 90", "tank.buff(88684)"},"tank"},

},{"!lowest.health <= 20","player.stance = 3" }},


---------------------------
--     SAVE THE TANK!    --
---------------------------
{"!Guardian Spirit",{"tank.health <= 15"},"tank"},
{ "Heal", {"!player.moving", "tank.health <= 25", "tank.spell(2061).range","player.buff(63735).count = 2" }, "tank" },
{ "Heal", {"!player.moving", "lowest.health <= 25", "lowest.spell(2061).range","player.buff(63735).count = 2" }, "lowest" },
{ "Binding Heal", {"!player.moving", "tank.health <= 25", "tank.spell(2061).range", "player.health <= 80" }, "tank" },
{ "Binding Heal", {"!player.moving", "lowest.health <= 25", "lowest.spell(2061).range", "player.health <= 80" }, "lowest" },
{ "Heal", {"!player.moving", "tank.health <= 20", "tank.spell(2061).range","player.buff(63735).count = 2" }, "tank" },
{ "2061", {"!player.moving", "tank.health <= 20", "tank.spell(2061).range" }, "tank" },
{ "2061", {"!player.moving", "focus.health <= 20","focus.spell(2061).range" }, "focus" },
{ "2061", {"!player.moving", "lowest.health <= 15","lowest.spell(2061).range" }, "lowest" },

---------------------------
--       SANCTUARY       --
---------------------------
{{
{"Circle of Healing",{"@coreHealing.needsHealing(95, 3)","lowest.range <= 40"},"lowest"},
{ "Prayer of Healing", {"@coreHealing.needsHealing(90, 3)","!player.moving", "tank.health <= 90", "tank.range <= 40","player.buff(63735).count = 2" }, "tank" },
{ "Prayer of Healing", {"@coreHealing.needsHealing(95, 3)","!player.moving", "lowest.health <= 90","lowest.range <= 40","player.buff(63735).count = 2" }, "lowest" },
{"Prayer of Mending", {"!player.moving","tank.health <= 99", "tank.range <= 40"},"tank"},
{ "Prayer of Healing", {"@coreHealing.needsHealing(90, 5)","!player.moving", "lowest.range <= 40","!player.spell(Circle of Healing).recharge < 3"}, "lowest" },
{ "Prayer of Healing", {"@coreHealing.needsHealing(85, 4)","!player.moving", "lowest.range <= 40","!player.spell(Circle of Healing).recharge < 3"}, "lowest" },
{ "Prayer of Healing", {"@coreHealing.needsHealing(80, 3)","!player.moving", "lowest.range <= 40","!player.spell(Circle of Healing).recharge < 3"}, "lowest" },
{"Heal",{"lowest.range <= 40", "lowest.health <= 95", "!player.moving", "!player.spell(Circle of Healing).recharge < 3"},"lowest"},
{"Renew",{"lowest.range <= 40", "lowest.health < = 90", "!lowest.buff(Renew)"}, "lowest"},
},"player.stance = 2"},


---------------------------
--       SERENITY       --
---------------------------
{{
{"Holy Word: Serenity",{"lowest.health <= 80", "lowest.range <= 40", "lowest.buff(Renew)"},"lowest"},
{"Holy Word: Serenity",{"tank.health <= 92", "tank.range <= 40", "tank.buff(Renew)"},"tank"},
{"Prayer of Mending",{"tank.range <= 40", "tank.health <= 90"},"tank"},
{"Heal",{"lowest.health <= 90", "lowest.buff(Renew)", "lowest.range <= 40"},"lowest"},
{"Heal",{"tank.health <= 90", "tank.buff(Renew)", "tank.range <= 40"},"lowest"},
},"player.stance = 3"},


---------------------------
--      Multi-HoTing     --
---------------------------
{ "Renew", {"lowest.range <= 40", "!lowest.buff(Renew)", "lowest.health <= 88"}, "lowest" }, -- Renew.
{ "Renew", {"focus.range <= 40", "!focus.buff(Renew)", "focus.health <= 92"}, "focus" }, -- Renew.
{ "Renew", {"tank.range <= 40","!tank.buff(Renew)", "tank.health <= 92"}, "tank" }, -- Renew.
{{ -- PARTY MODE
{ "Renew", { "party1.range <= 40","!party1.buff(Renew)", "party1.health <= 95"}, "party1" }, -- Renew.
{ "Renew", { "!player.buff(Renew)", "player.health <= 95" }, "player" }, -- Renew.
{ "Renew", { "party2.range <= 40","!party2.buff(Renew)", "party2.health <= 95"}, "party2" }, -- Renew.
{ "Renew", { "party3.range <= 40","!party3.buff(Renew)", "party3.health <= 95"}, "party3" }, -- Renew.
{ "Renew", { "party4.range <= 40","!party4.buff(Renew)", "party4.health <= 95"}, "party4" }, -- Renew.
{ "Renew", { "party5.range <= 40","!party5.buff(Renew)", "party5.health <= 95"}, "party5" }, -- Renew.
}, "!modifier.raid"},
{{ --RAID MODE
{ "Renew", { "raid1.range <= 40","!raid1.buff(Renew)", "raid1.health <= 85"}, "raid1" }, -- Renew.
{ "Renew", { "!player.buff(Renew)", "player.health <= 90" }, "player" }, -- Renew.
{ "Renew", { "raid2.range <= 40","!raid2.buff(Renew)", "raid2.health <= 85"}, "raid2" }, -- Renew.
{ "Renew", { "raid3.range <= 40","!raid3.buff(Renew)", "raid3.health <= 85"}, "raid3" }, -- Renew.
{ "Renew", { "raid4.range <= 40","!raid4.buff(Renew)", "raid4.health <= 85"}, "raid4" }, -- Renew.
{ "Renew", { "raid5.range <= 40","!raid5.buff(Renew)", "raid5.health <= 85"}, "raid5" }, -- Renew.
{ "Renew", { "raid6.range <= 40","!raid6.buff(Renew)", "raid6.health <= 85"}, "raid6" }, -- Renew.
{ "Renew", { "raid7.range <= 40","!raid7.buff(Renew)", "raid7.health <= 85"}, "raid7" }, -- Renew.
{ "Renew", { "raid8.range <= 40","!raid8.buff(Renew)", "raid8.health <= 85"}, "raid8" }, -- Renew.
{ "Renew", { "raid9.range <= 40","!raid9.buff(Renew)", "raid9.health <= 85"}, "raid9" }, -- Renew.
{ "Renew", { "raid10.range <= 40","!raid10.buff(Renew)", "raid10.health <= 85"}, "raid10" }, -- Renew.
{ "Renew", { "raid11.range <= 40","!raid11.buff(Renew)", "raid11.health <= 85"}, "raid11" }, -- Renew.
{ "Renew", { "raid12.range <= 40","!raid12.buff(Renew)", "raid12.health <= 85"}, "raid12" }, -- Renew.
{ "Renew", { "raid13.range <= 40","!raid13.buff(Renew)", "raid13.health <= 85"}, "raid13" }, -- Renew.
{ "Renew", { "raid14.range <= 40","!raid14.buff(Renew)", "raid14.health <= 85"}, "raid14" }, -- Renew.
{ "Renew", { "raid15.range <= 40","!raid15.buff(Renew)", "raid15.health <= 85"}, "raid15" }, -- Renew.
{ "Renew", { "raid16.range <= 40","!raid16.buff(Renew)", "raid16.health <= 85"}, "raid16" }, -- Renew.
{ "Renew", { "raid17.range <= 40","!raid17.buff(Renew)", "raid17.health <= 85"}, "raid17" }, -- Renew.
{ "Renew", { "raid18.range <= 40","!raid18.buff(Renew)", "raid18.health <= 85"}, "raid18" }, -- Renew.
{ "Renew", { "raid19.range <= 40","!raid19.buff(Renew)", "raid19.health <= 85"}, "raid19" }, -- Renew.
{ "Renew", { "raid20.range <= 40","!raid20.buff(Renew)", "raid20.health <= 85"}, "raid20" }, -- Renew.
{ "Renew", { "raid21.range <= 40","!raid21.buff(Renew)", "raid21.health <= 85"}, "raid21" }, -- Renew.
}, "modifier.raid"},




---------------------------
--       DPS MODE       --
---------------------------
{{
{"Chakra: Chastise",{"player.stance != 1"}},
{ "!2061", { "!player.moving", "lowest.health <= 30", "lowest.spell(2061).range" }, "lowest" },--Flash Heal
{ "34861", { "lowest.spell(34861).cooldown < .001",  "@coreHealing.needsHealing(80, 3)", "lowest.spell(34861).range" }, "lowest" },--CoH
{ "139", {  "!lowest.buff(139)",  "lowest.health < 85",  "lowest.spell(139).range" }, "lowest" },--Renew
{ "589", { "target.debuff(589).duration < 2",  "target.spell(589).range"}, "target" },--SW:pain
{ "14914", {  "player.spell(129250).cooldown < .001"  }, "target" },--Hoyl fire
{ "585", {  "player.mana > 30" }, "target"}, -- Smite


},  "toggle.Dps"  },


---------------------------
--  TARGETING AND FOCUS  --
---------------------------
{{
{ "/targetenemy [noexists]", "!target.exists" },
{ "/focus [@targettarget]", "target.enemy" },
{ "/target [target=focustarget, harm, nodead]", "target.range > 40" },
},"toggle.AutoTarget"},





},{
  ---------------------------
  --      OUT OF COMBAT    --
  ---------------------------
  { "1126", "!player.buffs.stamina" }, --stam
  {"724", "modifier.ralt", "mouseover.ground" }, --lightwell preplace
  {"!88685", "modifier.lcontrol","mouseover.ground" },  --Holy Word: Sanctuary
  {"Chakra: Sanctuary",{"player.stance != 2","modifier.rshift"}},
  {"Chakra: Serenity",{"player.stance != 3","modifier.rshift"}},

},function()
  NetherMachine.toggle.create('Dps', 'Interface\\Icons\\spell_shadow_demonicfortitude', 'DPS MODE','Switch to Chakra Chastise')
  NetherMachine.toggle.create('AutoTarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target/Focus','Auto Target Boss and Focus Active Tank')
end)
