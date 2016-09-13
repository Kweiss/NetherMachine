-- NetherMachine Rotation
-- Frost Mage - WoD 6.0.3
-- Updated on February 14th 2015

-- SUGGESTED TALENTS: 3003122
-- SUGGESTED GLYPHS: icy_veins/splitting_ice/cone_of_cold
-- CONTROLS: Pause - Left Control

-- ACTION LISTS
local cooldowns = {
  -- OFFENSIVE COOLDOWNS
  { {
    -- actions.cooldowns=icy_veins
    { "Icy Veins" },
    -- actions.cooldowns+=/blood_fury
    { "Blood Fury" },
    -- actions.cooldowns+=/berserking
    { "Berserking" },
    -- actions.cooldowns+=/arcane_torrent
    { "Arcane Torrent", "player.mana < 80" },
    -- actions.cooldowns+=/potion,name=draenic_intellect,if=buff.bloodlust.up|buff.icy_veins.up
    { "#109218", { "toggle.consume", "target.exists", "target.boss", "player.hashero" } },
    { "#109218", { "toggle.consume", "target.exists", "target.boss", "player.buff(Icy Veins)" } },
    -- actions.cooldowns+=/use_item,slot=trinket1
    { "#trinket1", "player.buff(Icy Veins)" },
    { "#trinket2", "player.buff(Icy Veins)" },
  },{
    "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
  } },
}

local crystal_sequence = {
  -- PRISMATIC CRYSTAL ROTATION
  -- actions.crystal_sequence=frost_bomb,if=active_enemies=1&current_target!=prismatic_crystal&remains<10
  { "Frost Bomb", { "target.area(8).enemies == 1", "!target.unitname(Prismatic Crystal)", "target.debuff(Frost Bomb).remains < 10" } },
  -- actions.crystal_sequence+=/frozen_orb
  { "Frozen Orb" },
  -- actions.crystal_sequence+=/call_action_list,name=cooldowns
  { cooldowns },
  -- actions.crystal_sequence+=/prismatic_crystal
  { "Prismatic Crystal", "target.exists", "target.ground" },
  { "/tar Prismatic Crystal", { "!target.unitname(Prismatic Crystal)" } },
  -- actions.crystal_sequence+=/frost_bomb,if=talent.prismatic_crystal.enabled&current_target=prismatic_crystal&active_enemies>1&!ticking
  { "Frost Bomb", { "talent(7, 2)", "target.unitname(Prismatic Crystal)", "target.area(8).enemies > 1", "!target.debuff(Frost Bomb)" } },
  -- actions.crystal_sequence+=/ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&active_dot.frozen_orb>=1)
  { "Ice Lance", "player.buff(Fingers of Frost).count == 2" },
  { "Ice Lance", { "player.buff(Fingers of Frost)", "target.debuff(Frozen Orb)" } },
  -- actions.crystal_sequence+=/ice_nova,if=charges=2
  { "Ice Nova", "player.spell(Ice Nova).charges == 2" },
  -- actions.crystal_sequence+=/frostfire_bolt,if=buff.brain_freeze.react
  { "Frostfire Bolt", "player.buff(Brain Freeze).remains > 1.5" },
  -- actions.crystal_sequence+=/ice_lance,if=buff.fingers_of_frost.react
  { "Ice Lance", "player.buff(Fingers of Frost)" },
  -- actions.crystal_sequence+=/ice_nova
  { "Ice Nova" },
  -- actions.crystal_sequence+=/blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2),if=active_enemies>=5
  { "/stopcasting", { "player.casting(Blizzard)", "player.spell(Frozen Orb).cooldown == 0" } },
  { "/stopcasting", { "player.casting(Blizzard)", "talent(5, 1)", "player.buff(Fingers of Frost).count == 2" } },
  { "Blizzard", { "target.area(10).enemies >= 5", "player.spell(Frozen Orb).cooldown > 0", "player.buff(Fingers of Frost).count < 2"  }, "target.ground" },
  -- actions.crystal_sequence+=/frostbolt
  { "Frostbolt" },
}

local init_water_jet = {
  -- actions.init_water_jet=frost_bomb,if=remains<3.6
  { "Frost Bomb", { "target.debuff(Frost Bomb).remains < 3.6" } },
  -- actions.init_water_jet+=/ice_lance,if=buff.fingers_of_frost.react&pet.water_elemental.cooldown.water_jet.up
  { "Ice Lance", { "player.buff(Fingers of Frost)", "pet.spell(Water Jet).cooldown == 0" } },
  -- actions.init_water_jet+=/water_jet,if=prev_gcd.frostbolt
  { "Water Jet", "modifier.last(Frostbolt)" },
  -- actions.init_water_jet+=/frostbolt
  { "Frostbolt" },
}

local water_jet = {
  -- actions.water_jet=frostbolt,if=prev.water_jet
  { "Frostbolt", "modifier.last(Water Jet)" },
  -- actions.water_jet+=/ice_lance,if=buff.fingers_of_frost.react=2&action.frostbolt.in_flight
  { "Ice Lance", { "player.buff(Fingers of Frost).count == 2", "modifier.last(Frostbolt)" } },
  -- actions.water_jet+=/frostbolt,if=debuff.water_jet.remains>cast_time+travel_time
  { "Frostbolt", "target.debuff(Water Jet).remains > 2" },
  -- actions.water_jet+=/ice_lance,if=prev_gcd.frostbolt
  { "Ice Lance", "modifier.last(Frostbolt)" },
  -- actions.water_jet+=/call_action_list,name=single_target
  { single_target },
}

local aoe = {
  -- actions.aoe=call_action_list,name=cooldowns
  { cooldowns },
  -- actions.aoe+=/frost_bomb,if=remains<action.ice_lance.travel_time&(cooldown.frozen_orb.remains<gcd.max|buff.fingers_of_frost.react=2)
  { "Frost Bomb", { "target.debuff(Frost Bomb).remains < 1", "player.spell(Frozen Orb).cooldown < 2" } },
  { "Frost Bomb", { "target.debuff(Frost Bomb).remains < 1", "player.buff(Fingers of Frost).count == 2" } },
  -- actions.aoe+=/frozen_orb
  { "Frozen Orb" },
  -- actions.aoe+=/ice_lance,if=talent.frost_bomb.enabled&buff.fingers_of_frost.react&debuff.frost_bomb.up
  { "Ice Lance", { "talent(5, 1)", "player.buff(Fingers of Frost)", "target.debuff(Frost Bomb)" } },
  -- actions.aoe+=/comet_storm
  { "Comet Storm" },
  -- actions.aoe+=/ice_nova
  { "Ice Nova" },
  -- actions.aoe+=/blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2)
  { "/stopcasting", { "player.casting(Blizzard)", "player.spell(Frozen Orb).cooldown == 0" } },
  { "/stopcasting", { "player.casting(Blizzard)", "talent(5, 1)", "player.buff(Fingers of Frost).count == 2" } },
  { "Blizzard", { "player.spell(Frozen Orb).cooldown > 0", "player.buff(Fingers of Frost).count < 2"  }, "target.ground" },
}

local single_target = {
  -- SINGLE TARGET ROTATION
  -- actions.single_target=call_action_list,name=cooldowns,if=!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>15
  { cooldowns, "!talent(7, 2)" },
  { cooldowns, "player.spell(Prismatic Crystal).cooldown > 15" },
  -- # Safeguards against losing FoF and BF to buff expiry
  -- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react&buff.fingers_of_frost.remains<action.frostbolt.execute_time
  { "Ice Lance", { "player.buff(Fingers of Frost)", "player.buff(Fingers of Frost).remains < 3" } },
  -- actions.single_target+=/frostfire_bolt,if=buff.brain_freeze.react&buff.brain_freeze.remains<action.frostbolt.execute_time
  { "Frostfire Bolt", { "player.buff(Brain Freeze)", "player.buff(Brain Freeze).remains < 3" } },
  -- # Frozen Orb usage without Prismatic Crystal
  -- actions.single_target+=/frost_bomb,if=!talent.prismatic_crystal.enabled&cooldown.frozen_orb.remains<gcd.max&debuff.frost_bomb.remains<10
  { "Frost Bomb", { "!talent(7, 2)", "target.debuff.remains < 1", "player.spell(Frozen Orb).cooldown < 2", "target.debuff(Frost Bomb).remains < 10" } },
  -- actions.single_target+=/frozen_orb,if=!talent.prismatic_crystal.enabled&buff.fingers_of_frost.stack<2&cooldown.icy_veins.remains>45
  { "Frost Bomb", { "!talent(7, 2)", "target.debuff.remains < 1", "player.buff(Fingers of Frost).count < 2", "player.spell(Icy Veins).cooldown > 45" } },
  -- # Single target routine; Rough summary: IN2 > FoF2 > CmS > IN > BF > FoF
  -- actions.single_target+=/frost_bomb,if=remains<action.ice_lance.travel_time&(buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd.max*2)))
  { "Frost Bomb", { "target.debuff.remains < 1.5", "player.buff(Fingers of Frost).count == 2" } },
  { "Frost Bomb", { "target.debuff.remains < 1.5", "player.buff(Fingers of Frost)", "talent(7, 1)" } },
  { "Frost Bomb", { "target.debuff.remains < 1.5", "player.buff(Fingers of Frost)", "player.buff(Fingers of Frost).remains < 3" } },
  -- actions.single_target+=/ice_nova,if=time_to_die<10|(charges=2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up))
  { "Ice Nova", "target.deathin < 10" },
  { "Ice Nova", { "player.spell(Ice Nova).charges == 2", "!talent(7, 2)" } },
  { "Ice Nova", { "player.spell(Ice Nova).charges == 2", "player.spell(Prismatic Crystal).cooldown > 1.5" } },
  -- actions.single_target+=/ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&dot.frozen_orb.ticking)
  { "Ice Lance", "player.buff(Fingers of Frost).count == 2" },
  { "Ice Lance", { "player.buff(Fingers of Frost)", "target.debuff(Frozen Orb)" } },
  -- actions.single_target+=/comet_storm
  { "Comet Storm" },
  -- actions.single_target+=/ice_nova,if=(!talent.prismatic_crystal.enabled|(charges=1&cooldown.prismatic_crystal.remains>recharge_time&buff.incanters_flow.stack>3))&(buff.icy_veins.up|(charges=1&cooldown.icy_veins.remains>recharge_time))
  { "Ice Nova", { "!talent(7, 2)", "player.buff(Icy Veins)" } },
  { "Ice Nova", { "!talent(7, 2)", "player.spell(Ice Nova).charges == 1", "player.spell(Icy Veins).cooldown > 15" } },
  { "Ice Nova", { "talent(7, 2)", "player.spell(Ice Nova).charges == 1", "player.spell(Prismatic Crystal).cooldown > 15", "player.buff(Incanter's Flow).count > 3", "player.buff(Icy Veins)" } },
  { "Ice Nova", { "talent(7, 2)", "player.spell(Ice Nova).charges == 1", "player.spell(Prismatic Crystal).cooldown > 15", "player.buff(Incanter's Flow).count > 3", "player.spell(Ice Nova).charges == 1", "player.spell(Icy Veins).cooldown > 15" } },
  -- actions.single_target+=/frostfire_bolt,if=buff.brain_freeze.react
  { "Frostfire Bolt", "player.buff(Brain Freeze).remains > 2" },
  -- actions.single_target+=/ice_lance,if=set_bonus.tier17_4pc&talent.thermal_void.enabled&talent.mirror_image.enabled&dot.frozen_orb.ticking
  -- actions.single_target+=/ice_lance,if=talent.frost_bomb.enabled&buff.fingers_of_frost.react&debuff.frost_bomb.remains>travel_time&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
  { "Ice Lance", { "talent(5, 1)", "player.buff(Fingers of Frost)", "target.debuff(Frost Bomb).remains > 1.5", "!talent(7, 1)" } },
  { "Ice Lance", { "talent(5, 1)", "player.buff(Fingers of Frost)", "target.debuff(Frost Bomb).remains > 1.5", "player.spell(Icy Veins).cooldown > 8" } },
  -- # Camp procs and spam Frostbolt while 4T17 buff is up
  -- actions.single_target+=/frostbolt,if=set_bonus.tier17_2pc&buff.ice_shard.up&!(talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<10)
  -- actions.single_target+=/ice_lance,if=!talent.frost_bomb.enabled&buff.fingers_of_frost.react&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
  { "Ice Lance", { "!talent(5, 1)", "player.buff(Fingers of Frost)", "!talent(7, 1)" } },
  { "Ice Lance", { "!talent(5, 1)", "player.buff(Fingers of Frost)", "player.spell(Icy Veins).cooldown > 8" } },
  -- actions.single_target+=/call_action_list,name=init_water_jet,if=pet.water_elemental.cooldown.water_jet.remains<=gcd.max*(buff.fingers_of_frost.react+talent.frost_bomb.enabled)&!dot.frozen_orb.ticking
  { init_water_jet, { "pet.spell(Water Jet).cooldown <= 4", "!target.debuff(Frozen Orb)" } },
  -- actions.single_target+=/frostbolt
  { "Frostbolt" },
  -- actions.single_target+=/ice_lance,moving=1
  { "Ice Lance", "player.moving" },
}

NetherMachine.rotation.register_custom(64, "bbMage Frost (SimC T17H)", {
  -- COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- AUTO TARGET
  { "/targetenemy [noexists]", { "toggle.autotarget", "!toggle.frogs", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "!toggle.frogs", "target.exists", "target.dead" } },

  -- FROGING
  { {
    { "Flare", "@bbLib.engaugeUnit('ANY', 40, false)" },
  }, "toggle.frogs" },

  -- BOSS MODS
  --{ "Feign Death", { "modifier.raid", "target.exists", "target.enemy", "target.boss", "target.agro", "target.distance < 30" } },
  --{ "Feign Death", { "modifier.raid", "player.debuff(Aim)", "player.debuff(Aim).duration > 3" } }, --SoO: Paragons - Aim

  -- INTERRUPTS / DISPELLS
  { "Counterspell", "modifier.interrupt" },
  { "Counterspell", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },
  -- Remove Curse
  -- Spellsteal

  -- DEFENSIVE COOLDOWNS
  { "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
  { "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
  { "Remove Curse", { "!modifier.last", "player.dispellable" }, "player" },
  { "Remove Curse", { "!modifier.last", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40", "mouseover.dispellable" }, "mouseover" },
  -- Ice Block
  -- Evanesce
  -- Invisibility
  -- Greater Invisibility
  -- Slow Fall

  -- Pre-DPS PAUSE
  { "pause", "target.debuff(Wyvern Sting).any" },
  { "pause", "target.debuff(Scatter Shot).any" },
  { "pause", "target.immune.all" },
  { "pause", "target.status.disorient" },
  { "pause", "target.status.incapacitate" },
  { "pause", "target.status.sleep" },

  -- COMBAT ROTATION
  -- actions=counterspell,if=target.debuff.casting.react
  -- actions+=/blink,if=movement.distance>10
  -- actions+=/blazing_speed,if=movement.remains>0
  -- actions+=/time_warp,if=target.health.pct<25|time>5
  --{ "Time Warp", { "modifier.cooldowns", "target.boss", "target.deathin < 25", "!player.debuff(Sated)", "!player.debuff(Exhaustion)" } },
  -- actions+=/call_action_list,name=water_jet,if=prev.water_jet|debuff.water_jet.remains>0
  { water_jet, { "target.debuff(Water Jet).remains > 0" } },
  { water_jet, { "modifier.last(Water Jet)" } },
  -- actions+=/mirror_image
  { "Mirror Image" },
  -- actions+=/ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<action.frostbolt.cast_time)
  { "Ice Floes", { "player.movingfor > 1", "!player.buff(Ice Floes)" } },
  -- actions+=/rune_of_power,if=buff.rune_of_power.remains<cast_time
  { "Rune of Power", { "!player.moving", "!player.buff(Rune of Power)", "!modifier.last" }, "player.ground" },
  -- actions+=/rune_of_power,if=(cooldown.icy_veins.remains<gcd.max&buff.rune_of_power.remains<20)|(cooldown.prismatic_crystal.remains<gcd.max&buff.rune_of_power.remains<10)
  -- actions+=/call_action_list,name=cooldowns,if=time_to_die<24
  { cooldowns, { "target.boss", "target.deathin < 24" } },
  -- # Water jet on pull for non IN+PC talent combos
  -- actions+=/water_jet,if=time<1&active_enemies<4&!(talent.ice_nova.enabled&talent.prismatic_crystal.enabled)
  { "Water Jet", { "player.time < 3", "target.area(10).enemies < 4", "!talent(5, 3)", "!talent(7, 2)" } },
  -- actions+=/call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&(cooldown.prismatic_crystal.remains<=gcd.max|pet.prismatic_crystal.active)
  { crystal_sequence, { "modifier.lalt", "talent(7, 2)", (function() return GetSpellCooldown("Prismatic Crystal") <= 1.5 or GetTotemInfo(1) end) } },
  -- actions+=/call_action_list,name=aoe,if=active_enemies>=4
  { aoe, { "modifier.multitarget", "target.area(10).enemies >= 4" } },
  -- actions+=/call_action_list,name=single_target
  { single_target },

},{
  -- OUT OF COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- BUFFS
  { "Arcane Brilliance", { "!player.buffs.spellpower", "!modifer.last" } },
  { "Summon Water Elemental", "!pet.exists" },

  -- FROGING
  { {
    { "Arcane Brilliance", "@bbLib.engaugeUnit('ANY', 40, false)" },
    --
  }, "toggle.frogs" },

},
function()
  NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_hunter_quickshot', 'Use Mouseovers', 'Toggle automatic usage of stings/scatter/etc on eligible mouseover targets.')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack enemies near you.')
end)
