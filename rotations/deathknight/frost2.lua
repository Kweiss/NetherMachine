-- NetherMachine Rotation Packager
-- Frost Death Knight 1H & 2H - WoW WoD 6.0.3
-- Updated on Jan 17th 2015

-- PLAYER CONTROLLED:
-- SUGGESTED TALENTS: 2001002
-- CONTROLS: Pause - Left Control, Death and Decay - Left Shift,  Death Grip Mouseover - Left Alt, Anti-Magic Zone - Right Shift, Army of the Dead - Right Control

-- TODO: Necrotic Plague replaces Blood Plague and Frost Fever, including any ability that applies either. It cannot be refreshed, it gains 1 stack instead.

NetherMachine.rotation.register_custom(251, "bbDeathKnight Frost (SimC T17N)", {
  -- COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- AUTO TARGET
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
  }, "toggle.frogs" },

  -- INTERRUPTS
  { "Mind Freeze", "modifier.interrupt" },
  { "Strangulate", {  "modifier.interrupt", "!modifier.last(Mind Freeze)" } },

  -- PLAYER CONTROLLED
  { "Defile", { "modifier.lshift", "talent(7, 2)", "player.area(40).enemies > 0" }, "ground" },
  { "Death and Decay", { "modifier.lshift", "!talent(7, 2)", "player.area(40).enemies > 0" }, "ground" },
  --{ "Chains of Ice", "modifier.control" },
  { "Army of the Dead", { "target.boss", "modifier.rshift", "player.area(40).enemies > 0" } },
  { "Death Grip", { "modifier.lalt", "player.area(40).enemies > 0" } },

  -- DEFENSIVE COOLDOWNS
  { "Icebound Fortitude", "player.health <= 45" },
  { "Anti-Magic Shell", "player.health <= 45" }, -- TODO: Simulate Runic Power gain on using Anti-Magic Shell to absorb 100000 magic damage every 60 seconds on average.

  -- COOLDOWNS / COMMON
  { {
    -- actions=auto_attack
    -- actions+=/deaths_advance,if=movement.remains>2
    -- actions+=/antimagic_shell,damage=100000
    -- actions+=/pillar_of_frost
    { "Pillar of Frost" },
    -- actions+=/potion,name=draenic_strength,if=target.time_to_die<=30|(target.time_to_die<=60&buff.pillar_of_frost.up)
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "player.hashero" } }, -- Draenic Strength Potion
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "target.deathin <= 60", "player.buff(Pillar of Frost)" } }, -- Draenic Strength Potion
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "target.deathin <= 30" } }, -- Draenic Strength Potion
    -- actions+=/empower_rune_weapon,if=target.time_to_die<=60&buff.potion.up
    { "Empower Rune Weapon", { "target.boss", "player.buff(Draenic Strength Potion)" } },
    -- actions+=/blood_fury
    { "Blood Fury" },
    -- actions+=/berserking
    { "Berserking" },
    -- actions+=/arcane_torrent
    { "Arcane Torrent" },
    -- actions+=/use_item,slot=trinket2
    { "#trinket1", "player.buff(Pillar of Frost)" },
    { "#trinket1", "player.hashero" },
    { "#trinket2", "player.buff(Pillar of Frost)" },
    { "#trinket2", "player.hashero" },
  },{
    "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "target.distance < 5"
  } },

  -- AOE ROTATION (Same for 1H/2H)
  -- actions+=/run_action_list,name=aoe,if=active_enemies>=4
  -- actions.aoe=unholy_blight
  { "Unholy Blight", { "modifier.multitarget", "player.area(7).enemies > 3" } },
  { {
    -- actions.aoe+=/blood_boil,if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28
    { "Blood Boil", { "target.debuff(Blood Plague)", "!talent(1, 3)", "player.area(7).enemies > 0", "timeout(Blood Boil, 28)" } },
    { "Blood Boil", { "target.debuff(Blood Plague)", "talent(1, 3)", "player.spell(Unholy Blight).cooldown < 49", "player.area(7).enemies > 0", "timeout(Blood Boil, 28)" } },
    -- actions.aoe+=/defile
    { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving" }, "target.ground" },
    -- actions.aoe+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", { "!modifier.last", "!player.buff", "player.runicpower > 75", "player.area(9).enemies > 0" } },
    -- actions.aoe+=/run_action_list,name=bos_aoe,if=dot.breath_of_sindragosa.ticking
    { {
      -- actions.bos_aoe=howling_blast
      { "Howling Blast" },
      -- actions.bos_aoe+=/blood_tap,if=buff.blood_charge.stack>10
      { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
      -- actions.bos_aoe+=/death_and_decay,if=unholy=1
      { "Death and Decay", { "!talent(7, 2)", "!player.moving", "!target.moving", "player.runes(unholy).count == 1" }, "target.ground" },
      -- actions.bos_aoe+=/plague_strike,if=unholy=2
      { "Plague Strike", "player.runes(unholy).count == 2" },
      -- actions.bos_aoe+=/blood_tap
      { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
      -- actions.bos_aoe+=/plague_leech
      { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
      { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
      -- actions.bos_aoe+=/plague_strike,if=unholy=1
      { "Plague Strike", "player.runes(unholy).count == 1" },
      -- actions.bos_aoe+=/empower_rune_weapon
      { "Empower Rune Weapon" },
      --{ "pause" },
    }, "target.debuff(Breath of Sindragosa)" },
    -- actions.aoe+=/howling_blast
    { "Howling Blast" },
    -- actions.aoe+=/blood_tap,if=buff.blood_charge.stack>10
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
    -- actions.aoe+=/frost_strike,if=runic_power>88
    { "Frost Strike", "player.runicpower > 88" },
    -- actions.aoe+=/death_and_decay,if=unholy=1
    { "Death and Decay", { "!talent(7, 2)", "!player.moving", "!target.moving", "player.runes(unholy).count == 1" }, "target.ground" },
    -- actions.aoe+=/plague_strike,if=unholy=2
    { "Plague Strike", "player.runes(unholy).count == 2" },
    -- actions.aoe+=/blood_tap
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.aoe+=/frost_strike,if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
    { "Frost Strike", "!talent(7, 3)" },
    { "Frost Strike", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown >= 10" } },
    -- actions.aoe+=/plague_leech
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
    -- actions.aoe+=/plague_strike,if=unholy=1
    { "Plague Strike", "player.runes(unholy).count == 1" },
    -- actions.aoe+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  },{
    "player.area(5).enemies >= 4", "modifier.multitarget",  --TODO: >=3 for 1H
  } },

  -- SINGLE TARGET FOR 2H (active_enemies < 4)
  { {
    -- actions+=/run_action_list,name=single_target,if=active_enemies<4
    -- actions.single_target=plague_leech,if=disease.min_remains<1
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains <= 1" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains <= 1" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains <= 1" } },
    -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
    { "Soul Reaper", "target.health < 35" },
    -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
    { "Blood Tap", { "target.health < 35", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/defile
    { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving" }, "target.ground" },
    -- actions.single_target+=/blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
    { "Blood Tap", { "talent(7, 2)", "player.spell(Defile).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5&buff.killing_machine.react
    { "Howling Blast", { "player.buff(Freezing Fog)", "player.buff(Killing Machine)", "target.debuff(Blood Plague).remains > 5", "target.debuff(Frost Fever).remains > 5" } },
    -- actions.single_target+=/obliterate,if=buff.killing_machine.react
    { "Obliterate", "player.buff(Killing Machine)" },
    -- actions.single_target+=/blood_tap,if=buff.killing_machine.react
    { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking&buff.rime.react
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)", "player.buff(Freezing Fog)" } },
    -- actions.single_target+=/outbreak,if=!disease.max_ticking
    { "Outbreak", "!target.debuff(Frost Fever)" },
    { "Outbreak", "!target.debuff(Blood Plague)" },
    -- actions.single_target+=/unholy_blight,if=!disease.min_ticking
    { "Unholy Blight", { "!target.debuff(Frost Fever)", "player.area(7).enemies > 0" } },
    { "Unholy Blight", { "!target.debuff(Blood Plague)", "player.area(7).enemies > 0" } },
    -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", { "!modifier.last", "!player.buff", "player.runicpower > 75", "player.area(9).enemies > 0" } },
    -- actions.single_target+=/run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
    { {
      -- actions.bos_st=obliterate,if=buff.killing_machine.react
      { "Obliterate", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech,if=buff.killing_machine.react
      { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.buff(Killing Machine)" } },
      { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.buff(Killing Machine)" } },
      -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech
      { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
      { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
      -- actions.bos_st+=/obliterate,if=runic_power<76
      { "Obliterate", "player.runicpower < 76" },
      -- actions.bos_st+=/howling_blast,if=((death=1&frost=0&unholy=0)|death=0&frost=1&unholy=0)&runic_power<88
      { "Howling Blast", { "player.runicpower < 88", "player.runes(death).count == 1", "player.runes(frost).count == 0", "player.runes(unholy).count == 0" } },
      { "Howling Blast", { "player.runicpower < 88", "player.runes(death).count == 0", "player.runes(frost).count == 1", "player.runes(unholy).count == 0" } },
    }, "target.debuff(Breath of Sindragosa)" },
    -- actions.single_target+=/obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<76
    { "Obliterate", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 76" } },
    -- actions.single_target+=/howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<88
    { "Howling Blast", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 3", "player.runicpower < 88" } },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
    -- actions.single_target+=/howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
    { "Howling Blast", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
    -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
    { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
    -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>10&runic_power>76
    { "Blood Tap", { "player.runicpower < 76", "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/frost_strike,if=runic_power>76
    { "Frost Strike", "player.runicpower > 76" },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5&(blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8)
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(blood).count.frac >= 1.8" } },
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(unholy).count.frac >= 1.8" } },
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(frost).count.frac >= 1.8" } },
    -- actions.single_target+=/obliterate,if=blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8
    { "Obliterate", "player.runes(blood).count.frac >= 1.8" },
    { "Obliterate", "player.runes(unholy).count.frac >= 1.8" },
    { "Obliterate", "player.runes(frost).count.frac >= 1.8" },
    -- actions.single_target+=/plague_leech,if=disease.min_remains<3&((blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95))
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 3", "player.runes(blood).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 3", "player.runes(frost).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 3", "player.runes(frost).count <= 0.95", "player.runes(blood).count.frac <= 0.95" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 3", "player.runes(blood).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 3", "player.runes(frost).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 3", "player.runes(frost).count <= 0.95", "player.runes(blood).count.frac <= 0.95" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 3", "player.runes(blood).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 3", "player.runes(frost).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 3", "player.runes(frost).count <= 0.95", "player.runes(blood).count.frac <= 0.95" } },
    -- actions.single_target+=/frost_strike,if=talent.runic_empowerment.enabled&(frost=0|unholy=0|blood=0)&(!buff.killing_machine.react|!obliterate.ready_in<=1)
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(frost).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(unholy).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(blood).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown > 1", "player.runes(frost).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown > 1", "player.runes(unholy).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown > 1", "player.runes(blood).count == 0" } },
    -- actions.single_target+=/frost_strike,if=talent.blood_tap.enabled&buff.blood_charge.stack<=10&(!buff.killing_machine.react|!obliterate.ready_in<=1)
    { "Frost Strike", { "talent(4, 3)", "player.buff(Blood Charge).count <= 10", "!player.buff(Killing Machine)" } },
    { "Frost Strike", { "talent(4, 3)", "player.buff(Blood Charge).count <= 10", "player.spell(Obliterate).cooldown > 1" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5" } },
    -- actions.single_target+=/obliterate,if=blood.frac>=1.5|unholy.frac>=1.6|frost.frac>=1.6|buff.bloodlust.up|cooldown.plague_leech.remains<=4
    { "Obliterate", "player.runes(blood).count.frac >= 1.5" },
    { "Obliterate", "player.runes(unholy).count.frac >= 1.6" },
    { "Obliterate", "player.runes(frost).count.frac >= 1.6" },
    { "Obliterate", "player.hashero" },
    { "Obliterate", "player.spell(Plague Leech).cooldown <= 4" },
    -- actions.single_target+=/blood_tap,if=(buff.blood_charge.stack>10&runic_power>=20)|(blood.frac>=1.4|unholy.frac>=1.6|frost.frac>=1.6)
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower >= 20", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(blood).count.frac >= 1.4", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(unholy).count.frac >= 1.6", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(frost).count.frac >= 1.6", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/frost_strike,if=!buff.killing_machine.react
    { "Frost Strike", "!player.buff(Killing Machine)" },
    -- actions.single_target+=/plague_leech,if=(blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95)
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.runes(blood).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.runes(frost).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.runes(frost).count <= 0.95", "player.runes(blood).count.frac <= 0.95" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.runes(blood).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.runes(frost).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.runes(frost).count <= 0.95", "player.runes(blood).count.frac <= 0.95" } },
    -- actions.single_target+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  }, "player.twohand" },

  -- SINGLE TARGET FOR 1H (active_enemies < 3)
  { {
    -- actions.single_target=blood_tap,if=buff.blood_charge.stack>10&(runic_power>76|(runic_power>=20&buff.killing_machine.react))
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower >= 20", "player.buff(Killing Machine)", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower > 76", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
    { "Soul Reaper", "target.health < 35" },
    -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
    { "Blood Tap", { "target.health < 35", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", { "!modifier.last", "!player.buff", "player.runicpower > 75", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
    { {
      -- actions.bos_st=obliterate,if=buff.killing_machine.react
      { "Obliterate", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech,if=buff.killing_machine.react
      { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.buff(Killing Machine)" } },
      { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.buff(Killing Machine)" } },
      -- actions.bos_st+=/howling_blast,if=runic_power<88
      { "Howling Blast", "player.runicpower < 88" },
      -- actions.bos_st+=/obliterate,if=unholy>0&runic_power<76
      { "Obliterate", { "player.runes(unholy).count > 0", "player.runicpower < 76" } },
      -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech
      { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
      { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
      -- actions.bos_st+=/empower_rune_weapon
      { "Empower Rune Weapon" },
    }, "target.debuff(Breath of Sindragosa)" },
    -- actions.single_target+=/defile
    { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving" }, "target.ground" },
    -- actions.single_target+=/blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
    { "Blood Tap", { "talent(7, 2)", "player.spell(Defile).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<88
    { "Howling Blast", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 88" } },
    -- actions.single_target+=/obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<76
    { "Obliterate", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 3", "player.runicpower < 76" } },
    -- actions.single_target+=/frost_strike,if=buff.killing_machine.react|runic_power>88
    { "Frost Strike", "player.buff(Killing Machine)" },
    { "Frost Strike", "player.runicpower > 88" },
    -- actions.single_target+=/frost_strike,if=cooldown.antimagic_shell.remains<1&runic_power>=50&!buff.antimagic_shell.up
    { "Frost Strike", { "player.spell(Anti-Magic Shell).cooldown < 1", "player.runicpower >= 50", "!player.buff(Anti-Magic Shell)" } },
    -- actions.single_target+=/howling_blast,if=death>1|frost>1
    { "Howling Blast", "player.runes(death).count > 1" },
    { "Howling Blast", "player.runes(frost).count > 1" },
    -- actions.single_target+=/unholy_blight,if=!disease.ticking
    { "Unholy Blight", { "!target.debuff(Frost Fever)", "player.area(7).enemies > 0" } },
    { "Unholy Blight", { "!target.debuff(Blood Plague)", "player.area(7).enemies > 0" } },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
    -- actions.single_target+=/howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
    { "Howling Blast", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
    -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking&unholy>0
    { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)", "player.runes(unholy).count > 0" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react
    { "Howling Blast", "player.buff(Freezing Fog)" },
    -- actions.single_target+=/frost_strike,if=set_bonus.tier17_2pc=1&(runic_power>=50&(cooldown.pillar_of_frost.remains<5))
    -- actions.single_target+=/frost_strike,if=runic_power>76
    { "Frost Strike", "player.runicpower > 76" },
    -- actions.single_target+=/obliterate,if=unholy>0&!buff.killing_machine.react
    { "Obliterate", { "player.runes(unholy).count > 0", "!player.buff(Killing Machine)" } },
    -- actions.single_target+=/howling_blast,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains<3)|death+frost>=2
    { "Howling Blast", { "player.runes(death).count >= 1", "player.runes(frost).count >= 1" } },
    { "Howling Blast", { "target.health < 35", "player.spell(Soul Reaper).cooldown < 3" } },
    -- actions.single_target+=/blood_tap
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/plague_leech
    { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
    { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
    -- actions.single_target+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  }, "player.onehand" },

},{
  -- OUT OF COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- Buffs
  { "Frost Presence", "!player.buff(Frost Presence)", "player" },
  { "Horn of Winter", "!player.buff(Horn of Winter).any", "player" },
  { "Path of Frost", { "!player.buff(Path of Frost).any", "player.mounted" }, "player" },

  -- Keybinds
  { "Army of the Dead", { "target.boss", "modifier.rshift", "player.area(40).enemies > 0" } },
  { "Death Grip", { "modifier.lalt", "player.area(40).enemies > 0" } },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
    { "Death Grip", true, "target" },
    { "Mind Freeze", true, "target" },
    { "Chains of Ice", true, "target" },
  }, "toggle.frogs" },

},function()
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
  NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target, run to, and attack enemies.')
end)


















-- NetherMachine Rotation Packager
-- Frost Death Knight 1H & 2H - WoW WoD 6.0.3
-- Updated on Jan 17th 2015

-- PLAYER CONTROLLED:
-- SUGGESTED TALENTS: 2001002
-- CONTROLS: Pause - Left Control, Death and Decay - Left Shift,  Death Grip Mouseover - Left Alt, Anti-Magic Zone - Right Shift, Army of the Dead - Right Control

-- TODO: Necrotic Plague replaces Blood Plague and Frost Fever, including any ability that applies either. It cannot be refreshed, it gains 1 stack instead.

NetherMachine.rotation.register_custom(251, "bbDeathKnight Frost (SimC OLD)", {
  -- COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- AUTO TARGET
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
  }, "toggle.frogs" },

  -- INTERRUPTS
  { "Mind Freeze", "modifier.interrupt" },
  { "Strangulate", {  "modifier.interrupt", "!modifier.last(Mind Freeze)" } },

  -- PLAYER CONTROLLED
  { "Defile", { "modifier.lshift", "talent(7, 2)" }, "ground" },
  { "Chains of Ice", "modifier.control" },
  { "Army of the Dead", { "target.boss", "modifier.rshift" } },
  { "Death Grip", "modifier.lalt" },

  -- DEFENSIVE COOLDOWNS
  { "Icebound Fortitude", "player.health <= 45" },
  { "Anti-Magic Shell", "player.health <= 45" }, -- TODO: Simulate Runic Power gain on using Anti-Magic Shell to absorb 100000 magic damage every 60 seconds on average.

  -- COOLDOWNS / COMMON
  -- actions+=/deaths_advance,if=movement.remains>2
  { {
    -- actions+=/pillar_of_frost
    { "Pillar of Frost", "modifier.cooldowns" },
    -- actions+=/potion,name=draenic_strength,if=target.time_to_die<=30|(target.time_to_die<=60&buff.pillar_of_frost.up)
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "player.hashero" } }, -- Draenic Strength Potion
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "target.deathin <= 60", "player.buff(Pillar of Frost)" } }, -- Draenic Strength Potion
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "target.deathin <= 30" } }, -- Draenic Strength Potion
    -- actions+=/empower_rune_weapon,if=target.time_to_die<=60&buff.potion.up
    { "Empower Rune Weapon", { "modifier.cooldowns", "target.deathin <= 60", "player.buff(Draenic Strength Potion)" } },
    -- actions+=/blood_fury
    { "Blood Fury" },
    -- actions+=/berserking
    { "Berserking" },
    -- actions+=/arcane_torrent
    { "Arcane Torrent" },
    -- trinkets
    { "#trinket1", "player.buff(Pillar of Frost)" },
    { "#trinket1", "player.hashero" },
    { "#trinket2", "player.buff(Pillar of Frost)" },
    { "#trinket2", "player.hashero" },
  },{
    "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "target.distance < 5",
  } },

  -- AOE ROTATION (Same for 1H/2H)
  { {
    { {
      -- actions.bos_aoe=howling_blast
      { "Howling Blast" },
      -- actions.bos_aoe+=/blood_tap,if=buff.blood_charge.stack>10
      { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
      -- actions.bos_aoe+=/death_and_decay,if=unholy=1
      { "Death and Decay", "player.runes(unholy).count == 1", "target.ground" },
      -- actions.bos_aoe+=/plague_strike,if=unholy=2
      { "Plague Strike", "player.runes(unholy).count == 2" },
      -- actions.bos_aoe+=/blood_tap
      { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
      -- actions.bos_aoe+=/plague_leech
      { "Plague Leech" },
      -- actions.bos_aoe+=/plague_strike,if=unholy=1
      { "Plague Strike", "player.runes(unholy).count == 1" },
      -- actions.bos_aoe+=/empower_rune_weapon
      { "Empower Rune Weapon" },
    }, "target.debuff(Breath of Sindragosa)" },
    -- actions.aoe=unholy_blight
    { "Unholy Blight" },
    -- actions.aoe+=/blood_boil,if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28
    -- actions.aoe+=/defile
    { "Defile", { "!player.moving", "!target.moving", "talent(7, 2)" }, "target.ground" },
    -- actions.aoe+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", "player.runicpower > 75" },
    -- actions.aoe+=/howling_blast
    { "Howling Blast" },
    -- actions.aoe+=/blood_tap,if=buff.blood_charge.stack>10
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
    -- actions.aoe+=/frost_strike,if=runic_power>88
    { "Frost Strike", "player.runicpower > 88" },
    -- actions.aoe+=/death_and_decay,if=unholy=1
    { "Death and Decay", { "!player.moving", "!target.moving", "!talent(7, 2)", "player.runes(unholy).count == 1" }, "target.ground" },
    -- actions.aoe+=/plague_strike,if=unholy=2
    { "Plague Strike", "player.runes(unholy).count == 2" },
    -- actions.aoe+=/blood_tap
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.aoe+=/frost_strike,if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
    { "Frost Strike", "!talent(7, 3)" },
    { "Frost Strike", "player.spell(Breath of Sindragosa).cooldown >= 10" },
    -- actions.aoe+=/plague_leech
    { "Plague Leech" },
    -- actions.aoe+=/plague_strike,if=unholy=1
    { "Plague Strike", "player.runes(unholy).count == 1" },
    -- actions.aoe+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  },{
    "player.area(10).enemies >= 3", "modifier.multitarget",
  } },

  -- SINGLE TARGET FOR 2H (active_enemies < 3)
  { {
    { {
      -- actions.bos_st=obliterate,if=buff.killing_machine.react
      { "Obliterate", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech,if=buff.killing_machine.react
      { "Plague Leech", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech
      { "Plague Leech" },
      -- actions.bos_st+=/obliterate,if=runic_power<76
      { "Obliterate", "player.runicpower < 76" },
      -- actions.bos_st+=/howling_blast,if=((death=1&frost=0&unholy=0)|death=0&frost=1&unholy=0)&runic_power<88
      { "Howling Blast", { "player.runicpower < 88", "player.runes(death).count == 1", "player.runes(frost).count == 0", "player.runes(unholy).count == 0" } },
      { "Howling Blast", { "player.runicpower < 88", "player.runes(death).count == 0", "player.runes(frost).count == 1", "player.runes(unholy).count == 0" } },
    }, "target.debuff(Breath of Sindragosa)" },
    -- actions.single_target=plague_leech,if=disease.min_remains<1
    { "Plague Leech", { "target.debuff(Blood Plague)", "target.debuff(Blood Plague).remains <= 1" } },
    { "Plague Leech", { "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains <= 1" } },
    -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
    { "Soul Reaper", "target.health <= 35" },
    -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
    { "Blood Tap", { "target.health <= 35", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/defile
    { "Defile", true, "target.ground" },
    -- actions.single_target+=/blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
    { "Blood Tap", { "talent(7, 2)", "player.spell(Defile).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5&buff.killing_machine.react
    { "Howling Blast", { "player.buff(Freezing Fog)", "player.buff(Killing Machine)", "target.debuff(Blood Plague).remains > 5", "target.debuff(Frost Fever).remains > 5" } },
    -- actions.single_target+=/obliterate,if=buff.killing_machine.react
    { "Obliterate", "player.buff(Killing Machine)" },
    -- actions.single_target+=/blood_tap,if=buff.killing_machine.react
    { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking&buff.rime.react
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)", "player.buff(Freezing Fog)" } },
    -- actions.single_target+=/outbreak,if=!disease.max_ticking
    { "Outbreak", "!target.debuff(Frost Fever)" },
    { "Outbreak", "!target.debuff(Blood Plague)" },
    -- actions.single_target+=/unholy_blight,if=!disease.min_ticking
    { "Unholy Blight", "!target.debuff(Frost Fever)", "target" },
    { "Unholy Blight", "!target.debuff(Blood Plague)", "target" },
    -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", "player.runicpower > 75" },
    -- actions.single_target+=/obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<76
    { "Obliterate", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 76" } },
    -- actions.single_target+=/howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<88
    { "Howling Blast", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 3", "player.runicpower < 88" } },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
    -- actions.single_target+=/howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
    { "Howling Blast", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
    -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
    { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
    -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>10&runic_power>76
    { "Howling Blast", { "player.buff(Blood Charge).count > 10", "player.runicpower < 76" } },
    -- actions.single_target+=/frost_strike,if=runic_power>76
    { "Frost Strike", "player.runicpower > 76" },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5&(blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8)
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(blood).count.frac >= 1.8" } },
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(unholy).count.frac >= 1.8" } },
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(frost).count.frac >= 1.8" } },
    -- actions.single_target+=/obliterate,if=blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8
    { "Obliterate", "player.runes(blood).count.frac >= 1.8" },
    { "Obliterate", "player.runes(unholy).count.frac >= 1.8" },
    { "Obliterate", "player.runes(frost).count.frac >= 1.8" },
    -- actions.single_target+=/plague_leech,if=disease.min_remains<3&((blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95))
    -- actions.single_target+=/frost_strike,if=talent.runic_empowerment.enabled&(frost=0|unholy=0|blood=0)&(!buff.killing_machine.react|!obliterate.ready_in<=1)
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(frost).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(unholy).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(blood).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown >= 1", "player.runes(frost).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown >= 1", "player.runes(unholy).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown >= 1", "player.runes(blood).count == 0" } },
    -- actions.single_target+=/frost_strike,if=talent.blood_tap.enabled&buff.blood_charge.stack<=10&(!buff.killing_machine.react|!obliterate.ready_in<=1)
    { "Frost Strike", { "talent(4, 3)", "player.buff(Blood Charge).count <= 10", "!player.buff(Killing Machine)", "player.spell(Obliterate).cooldown >= 1" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5" } },
    -- actions.single_target+=/obliterate,if=blood.frac>=1.5|unholy.frac>=1.6|frost.frac>=1.6|buff.bloodlust.up|cooldown.plague_leech.remains<=4
    { "Obliterate", "player.runes(blood).count.frac >= 1.5" },
    { "Obliterate", "player.runes(unholy).count.frac >= 1.6" },
    { "Obliterate", "player.runes(frost).count.frac >= 1.6" },
    { "Obliterate", "player.hashero" },
    { "Obliterate", "player.spell(Plague Leech).cooldown <= 4" },
    -- actions.single_target+=/blood_tap,if=(buff.blood_charge.stack>10&runic_power>=20)|(blood.frac>=1.4|unholy.frac>=1.6|frost.frac>=1.6)
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower >= 20", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(blood).count.frac >= 1.4", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(unholy).count.frac >= 1.6", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(frost).count.frac >= 1.6", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/frost_strike,if=!buff.killing_machine.react
    { "Frost Strike", "!player.buff(Killing Machine)" },
    -- actions.single_target+=/plague_leech,if=(blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95)
    { "Plague Leech", { "player.runes(blood).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "player.runes(frost).count <= 0.95", "player.runes(unholy).count.frac <= 0.95" } },
    { "Plague Leech", { "player.runes(frost).count <= 0.95", "player.runes(blood).count.frac <= 0.95" } },
    -- actions.single_target+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  }, "player.twohand" },

  -- SINGLE TARGET FOR 1H (active_enemies < 3)
  { {
    { {
      -- actions.bos_st=obliterate,if=buff.killing_machine.react
      { "Obliterate", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech,if=buff.killing_machine.react
      { "Plague Leech", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/howling_blast,if=runic_power<88
      { "Howling Blast", { "player.runicpower < 88" } },
      -- actions.bos_st+=/obliterate,if=unholy>0&runic_power<76
      { "Obliterate", { "player.runes(unholy).count > 0", "player.runicpower < 76" } },
      -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech
      { "Plague Leech" },
      -- actions.bos_st+=/empower_rune_weapon
      { "Empower Rune Weapon" },
    }, "target.debuff(Breath of Sindragosa)" },
    -- actions.single_target=blood_tap,if=buff.blood_charge.stack>10&(runic_power>76|(runic_power>=20&buff.killing_machine.react))
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower > 76", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower >= 20", "player.buff(Killing Machine)", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
    { "Soul Reaper", "target.health <= 35" },
    -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
    { "Blood Tap", { "target.health <= 35", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", "player.runicpower > 75" },
    -- actions.single_target+=/defile
    { "Defile", true, "target.ground" },
    -- actions.single_target+=/blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
    { "Blood Tap", { "talent(7, 2)", "player.spell(Defile).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<88
    { "Howling Blast", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 88" } },
    -- actions.single_target+=/obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<76
    { "Obliterate", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 3", "player.runicpower < 76" } },
    -- actions.single_target+=/frost_strike,if=buff.killing_machine.react|runic_power>88
    { "Frost Strike", "player.buff(Killing Machine)" },
    { "Frost Strike", "player.runicpower > 88" },
    -- actions.single_target+=/frost_strike,if=cooldown.antimagic_shell.remains<1&runic_power>=50&!buff.antimagic_shell.up
    { "Frost Strike", { "player.spell(Anti-Magic Shell).cooldown < 1", "player.runicpower >= 50", "!player.buff(Anti-Magic Shell)" } },
    -- actions.single_target+=/howling_blast,if=death>1|frost>1
    { "Howling Blast", "player.runes(death).count > 1" },
    { "Howling Blast", "player.runes(frost).count > 1" },
    -- actions.single_target+=/unholy_blight,if=!disease.ticking
    { "Unholy Blight", "!target.debuff(Frost Fever)", "target" },
    { "Unholy Blight", "!target.debuff(Blood Plague)", "target" },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
    -- actions.single_target+=/howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
    { "Howling Blast", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
    -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking&unholy>0
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Blood Plague)", "player.runes(unholy).count > 0" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react
    { "Howling Blast", "player.buff(Freezing Fog)" },
    -- actions.single_target+=/frost_strike,if=set_bonus.tier17_2pc=1&(runic_power>=50&(cooldown.pillar_of_frost.remains<5))
    -- actions.single_target+=/frost_strike,if=runic_power>76
    { "Frost Strike", "player.runicpower > 76" },
    -- actions.single_target+=/obliterate,if=unholy>0&!buff.killing_machine.react
    { "Obliterate", { "player.runes(unholy).count > 0", "!player.buff(Killing Machine)" } },
    -- actions.single_target+=/howling_blast,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains<3)|death+frost>=2
    { "Howling Blast", { "player.runes(death).count >= 1", "player.runes(frost).count >= 1" } },
    { "Howling Blast", { "target.health <= 35", "player.spell(Soul Reaper).cooldown < 3" } },
    -- actions.single_target+=/blood_tap
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/plague_leech
    { "Plague Leech" },
    -- actions.single_target+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  }, "player.onehand" },


},{
  -- OUT OF COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- Buffs
  { "Frost Presence", "!player.buff(Frost Presence)", "player" },
  { "Horn of Winter", "!player.buff(Horn of Winter).any", "player" },
  { "Path of Frost", { "!player.buff(Path of Frost).any", "player.mounted" }, "player" },

  -- Keybinds
  { "Army of the Dead", { "target.boss", "modifier.rshift" } },
  { "Death Grip", "modifier.lalt" },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
    { "Death Grip", true, "target" },
    { "Mind Freeze", true, "target" },
    { "Chains of Ice", true, "target" },
  }, "toggle.frogs" },

},function()
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
  NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target, run to, and attack enemies.')
end)















NetherMachine.rotation.register_custom(251, "bbDeathKnight Frost (Really OLD)", {
-- COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- AUTO TARGET
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
  }, "toggle.frogs" },

  -- INTERRUPTS
  { "Mind Freeze", "modifier.interrupt" },
  { "Strangulate", {  "modifier.interrupt", "!modifier.last(Mind Freeze)" } },

  -- PLAYER CONTROLLED
  { "Defile", "modifier.lshift", "ground" },
  { "Chains of Ice", "modifier.control" },
  { "Army of the Dead", { "target.boss", "modifier.rshift" } },
  { "Death Grip", "modifier.lalt" },

  -- DEFENSIVE COOLDOWNS
  { "Icebound Fortitude", "player.health <= 45" },
  { "Anti-Magic Shell", "player.health <= 45" }, -- TODO: Simulate Runic Power gain on using Anti-Magic Shell to absorb 100000 magic damage every 60 seconds on average.

  -- COOLDOWNS / COMMON
  -- actions+=/deaths_advance,if=movement.remains>2
  { {
    -- actions+=/pillar_of_frost
    { "Pillar of Frost", "modifier.cooldowns" },
    -- actions+=/potion,name=draenic_strength,if=target.time_to_die<=30|(target.time_to_die<=60&buff.pillar_of_frost.up)
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "player.hashero" } }, -- Draenic Strength Potion
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "target.deathin <= 60", "player.buff(Pillar of Frost)" } }, -- Draenic Strength Potion
    { "#109219", { "toggle.consume", "target.exists", "target.boss", "target.deathin <= 30" } }, -- Draenic Strength Potion
    -- actions+=/empower_rune_weapon,if=target.time_to_die<=60&buff.potion.up
    { "Empower Rune Weapon", { "modifier.cooldowns", "target.deathin <= 60", "player.buff(Draenic Strength Potion)" } },
    -- actions+=/blood_fury
    { "Blood Fury" },
    -- actions+=/berserking
    { "Berserking" },
    -- actions+=/arcane_torrent
    { "Arcane Torrent" },
    -- trinkets
    { "#trinket1", "player.buff(Pillar of Frost)" },
    { "#trinket1", "player.hashero" },
    { "#trinket2", "player.buff(Pillar of Frost)" },
    { "#trinket2", "player.hashero" },
  },{
    "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "target.distance < 5",
  } },

  -- AOE ROTATION (Same for 1H/2H)
  { {
    { {
      -- actions.bos_aoe=howling_blast
      { "Howling Blast" },
      -- actions.bos_aoe+=/blood_tap,if=buff.blood_charge.stack>10
      { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
      -- actions.bos_aoe+=/death_and_decay,if=unholy=1
      { "Defile", { "!player.moving", "!target.moving", "talent(7, 2)", "player.runes(unholy).count == 1" }, "target.ground" },
      { "Death and Decay", { "!player.moving", "!target.moving", "!talent(7, 2)", "player.runes(unholy).count == 1" }, "target.ground" },
      -- actions.bos_aoe+=/plague_strike,if=unholy=2
      { "Plague Strike", "player.runes(unholy).count == 2" },
      -- actions.bos_aoe+=/blood_tap
      { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
      -- actions.bos_aoe+=/plague_leech
      { "Plague Leech" },
      -- actions.bos_aoe+=/plague_strike,if=unholy=1
      { "Plague Strike", "player.runes(unholy).count == 1" },
      -- actions.bos_aoe+=/empower_rune_weapon
      { "Empower Rune Weapon" },
    },{
        "target.debuff(Breath of Sindragosa)",
    } },
    -- actions.aoe=unholy_blight
    { "Unholy Blight" },
    -- actions.aoe+=/blood_boil,if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28
    -- actions.aoe+=/defile
    { "Defile", { "!player.moving", "!target.moving", "talent(7, 2)" }, "target.ground" },
    -- actions.aoe+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", "player.runicpower > 75" },
    -- actions.aoe+=/howling_blast
    { "Howling Blast" },
    -- actions.aoe+=/blood_tap,if=buff.blood_charge.stack>10
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
    -- actions.aoe+=/frost_strike,if=runic_power>88
    { "Frost Strike", "player.runicpower > 88" },
    -- actions.aoe+=/death_and_decay,if=unholy=1
    { "Death and Decay", { "!player.moving", "!target.moving", "!talent(7, 2)", "player.runes(unholy).count == 1" }, "target.ground" },
    -- actions.aoe+=/plague_strike,if=unholy=2
    { "Plague Strike", "player.runes(unholy).count == 2" },
    -- actions.aoe+=/blood_tap
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.aoe+=/frost_strike,if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
    { "Frost Strike", "!talent(7, 3)" },
    { "Frost Strike", "player.spell(Breath of Sindragosa).cooldown >= 10" },
    -- actions.aoe+=/plague_leech
    { "Plague Leech" },
    -- actions.aoe+=/plague_strike,if=unholy=1
    { "Plague Strike", "player.runes(unholy).count == 1" },
    -- actions.aoe+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  },{
  "player.area(10).enemies >= 3", "modifier.multitarget",
  } },

  -- SINGLE TARGET FOR 2H (active_enemies < 3)
  { {
    { {
      -- actions.bos_st=obliterate,if=buff.killing_machine.react
      { "Obliterate", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech,if=buff.killing_machine.react
      { "Plague Leech", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech
      { "Plague Leech" },
      -- actions.bos_st+=/obliterate,if=runic_power<76
      { "Obliterate", "player.runicpower < 76" },
      -- actions.bos_st+=/howling_blast,if=((death=1&frost=0&unholy=0)|death=0&frost=1&unholy=0)&runic_power<88
      { "Howling Blast", { "player.runicpower < 88", "player.runes(death).count == 1", "player.runes(frost).count == 0", "player.runes(unholy).count == 0" } },
      { "Howling Blast", { "player.runicpower < 88", "player.runes(death).count == 0", "player.runes(frost).count == 1", "player.runes(unholy).count == 0" } },
    }, "target.debuff(Breath of Sindragosa)" },
    -- actions.single_target=plague_leech,if=disease.min_remains<1
    { "Plague Leech", { "target.debuff(Blood Plague)", "target.debuff(Blood Plague).remains <= 1" } },
    { "Plague Leech", { "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains <= 1" } },
    -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
    { "Soul Reaper", "target.health <= 35" },
    -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
    { "Blood Tap", { "target.health <= 35", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/defile
    { "Defile", true, "target.ground" },
    -- actions.single_target+=/blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
    { "Blood Tap", { "talent(7, 2)", "player.spell(Defile).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5&buff.killing_machine.react
    { "Howling Blast", { "player.buff(Freezing Fog)", "player.buff(Killing Machine)", "target.debuff(Blood Plague).remains > 5", "target.debuff(Frost Fever).remains > 5" } },
    -- actions.single_target+=/obliterate,if=buff.killing_machine.react
    { "Obliterate", "player.buff(Killing Machine)" },
    -- actions.single_target+=/blood_tap,if=buff.killing_machine.react
    { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking&buff.rime.react
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)", "player.buff(Freezing Fog)" } },
    -- actions.single_target+=/outbreak,if=!disease.max_ticking
    { "Outbreak", "!target.debuff(Frost Fever)", "target" },
    { "Outbreak", "!target.debuff(Blood Plague)", "target" },
    -- actions.single_target+=/unholy_blight,if=!disease.min_ticking
    { "Unholy Blight", "!target.debuff(Frost Fever)", "target" },
    { "Unholy Blight", "!target.debuff(Blood Plague)", "target" },
    -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", "player.runicpower > 75" },
    -- actions.single_target+=/obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<76
    { "Obliterate", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 76" } },
    -- actions.single_target+=/howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<88
    { "Howling Blast", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 3", "player.runicpower < 88" } },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
    -- actions.single_target+=/howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
    { "Howling Blast", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
    -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
    { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
    -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>10&runic_power>76
    { "Howling Blast", { "player.buff(Blood Charge).count > 10", "player.runicpower < 76" } },
    -- actions.single_target+=/frost_strike,if=runic_power>76
    { "Frost Strike", "player.runicpower > 76" },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5&(blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8) --TODO: create frac func!
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(blood).count >= 1.8" } },
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(unholy).count >= 1.8" } },
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5", "player.runes(frost).count >= 1.8" } },
    -- actions.single_target+=/obliterate,if=blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8
    { "Obliterate", "player.runes(blood).count >= 1.8" },
    { "Obliterate", "player.runes(unholy).count >= 1.8" },
    { "Obliterate", "player.runes(frost).count >= 1.8" },
    -- actions.single_target+=/plague_leech,if=disease.min_remains<3&((blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95))
    -- actions.single_target+=/frost_strike,if=talent.runic_empowerment.enabled&(frost=0|unholy=0|blood=0)&(!buff.killing_machine.react|!obliterate.ready_in<=1)
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(frost).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(unholy).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "!player.buff(Killing Machine)", "player.runes(blood).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown >= 1", "player.runes(frost).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown >= 1", "player.runes(unholy).count == 0" } },
    { "Frost Strike", { "talent(4, 2)", "player.spell(Obliterate).cooldown >= 1", "player.runes(blood).count == 0" } },
    -- actions.single_target+=/frost_strike,if=talent.blood_tap.enabled&buff.blood_charge.stack<=10&(!buff.killing_machine.react|!obliterate.ready_in<=1)
    { "Frost Strike", { "talent(4, 3)", "player.buff(Blood Charge).count <= 10", "!player.buff(Killing Machine)", "player.spell(Obliterate).cooldown >= 1" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react&disease.min_remains>5
    { "Howling Blast", { "player.buff(Freezing Fog)", "target.debuff(Frost Fever).remains > 5", "target.debuff(Blood Plague).remains > 5" } },
    -- actions.single_target+=/obliterate,if=blood.frac>=1.5|unholy.frac>=1.6|frost.frac>=1.6|buff.bloodlust.up|cooldown.plague_leech.remains<=4
    { "Obliterate", "player.runes(blood).count >= 1.5" },
    { "Obliterate", "player.runes(unholy).count >= 1.6" },
    { "Obliterate", "player.runes(frost).count >= 1.6" },
    { "Obliterate", "player.hashero" },
    { "Obliterate", "player.spell(Plague Leech).cooldown <= 4" },
    -- actions.single_target+=/blood_tap,if=(buff.blood_charge.stack>10&runic_power>=20)|(blood.frac>=1.4|unholy.frac>=1.6|frost.frac>=1.6)
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower >= 20", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(blood).count >= 1.4", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(unholy).count >= 1.6", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes(frost).count >= 1.6", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/frost_strike,if=!buff.killing_machine.react
    { "Frost Strike", "!player.buff(Killing Machine)" },
    -- actions.single_target+=/plague_leech,if=(blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95)
    { "Plague Leech", { "player.runes(blood).count <= 0.95", "player.runes(unholy).count <= 0.95" } },
    { "Plague Leech", { "player.runes(frost).count <= 0.95", "player.runes(unholy).count <= 0.95" } },
    { "Plague Leech", { "player.runes(frost).count <= 0.95", "player.runes(blood).count <= 0.95" } },
    -- actions.single_target+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  },{
    "player.twohand",
  } },

  -- SINGLE TARGET FOR 1H (active_enemies < 3)
  { {
    { {
      -- actions.bos_st=obliterate,if=buff.killing_machine.react
      { "Obliterate", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Killing Machine)", "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech,if=buff.killing_machine.react
      { "Plague Leech", "player.buff(Killing Machine)" },
      -- actions.bos_st+=/howling_blast,if=runic_power<88
      { "Howling Blast", { "player.runicpower < 88" } },
      -- actions.bos_st+=/obliterate,if=unholy>0&runic_power<76
      { "Obliterate", { "player.runes(unholy).count > 0", "player.runicpower < 76" } },
      -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
      { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
      -- actions.bos_st+=/plague_leech
      { "Plague Leech" },
      -- actions.bos_st+=/empower_rune_weapon
      { "Empower Rune Weapon" },
    },{
      "target.debuff(Breath of Sindragosa)",
    } },
    -- actions.single_target=blood_tap,if=buff.blood_charge.stack>10&(runic_power>76|(runic_power>=20&buff.killing_machine.react))
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower > 76", "player.runes.depleted.count > 1" } },
    { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runicpower >= 20", "player.buff(Killing Machine)", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
    { "Soul Reaper", "target.health <= 35" },
    -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
    { "Blood Tap", { "target.health <= 35", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
    { "Breath of Sindragosa", "player.runicpower > 75" },
    -- actions.single_target+=/defile
    { "Defile", true, "target.ground" },
    -- actions.single_target+=/blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
    { "Blood Tap", { "talent(7, 2)", "player.spell(Defile).cooldown == 0", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<88
    { "Howling Blast", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 88" } },
    -- actions.single_target+=/obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<76
    { "Obliterate", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 3", "player.runicpower < 76" } },
    -- actions.single_target+=/frost_strike,if=buff.killing_machine.react|runic_power>88
    { "Frost Strike", "player.buff(Killing Machine)" },
    { "Frost Strike", "player.runicpower > 88" },
    -- actions.single_target+=/frost_strike,if=cooldown.antimagic_shell.remains<1&runic_power>=50&!buff.antimagic_shell.up
    { "Frost Strike", { "player.spell(Anti-Magic Shell).cooldown < 1", "player.runicpower >= 50", "!player.buff(Anti-Magic Shell)" } },
    -- actions.single_target+=/howling_blast,if=death>1|frost>1
    { "Howling Blast", "player.runes(death).count > 1" },
    { "Howling Blast", "player.runes(frost).count > 1" },
    -- actions.single_target+=/unholy_blight,if=!disease.ticking
    { "Unholy Blight", "!target.debuff(Frost Fever)", "target" },
    { "Unholy Blight", "!target.debuff(Blood Plague)", "target" },
    -- actions.single_target+=/howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
    -- actions.single_target+=/howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
    { "Howling Blast", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
    -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking&unholy>0
    { "Howling Blast", { "!talent(7, 1)", "!target.debuff(Blood Plague)", "player.runes(unholy).count > 0" } },
    -- actions.single_target+=/howling_blast,if=buff.rime.react
    { "Howling Blast", "player.buff(Freezing Fog)" },
    -- actions.single_target+=/frost_strike,if=set_bonus.tier17_2pc=1&(runic_power>=50&(cooldown.pillar_of_frost.remains<5))
    -- actions.single_target+=/frost_strike,if=runic_power>76
    { "Frost Strike", "player.runicpower > 76" },
    -- actions.single_target+=/obliterate,if=unholy>0&!buff.killing_machine.react
    { "Obliterate", { "player.runes(unholy).count > 0", "!player.buff(Killing Machine)" } },
    -- actions.single_target+=/howling_blast,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains<3)|death+frost>=2
    { "Howling Blast", { "player.runes(death).count >= 1", "player.runes(frost).count >= 1" } },
    { "Howling Blast", { "target.health <= 35", "player.spell(Soul Reaper).cooldown < 3" } },
    -- actions.single_target+=/blood_tap
    { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
    -- actions.single_target+=/plague_leech
    { "Plague Leech" },
    -- actions.single_target+=/empower_rune_weapon
    { "Empower Rune Weapon" },
  },{
    "player.onehand",
  } },


},{
-- OUT OF COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- Buffs
  { "Frost Presence", "!player.buff(Frost Presence)", "player" },
  { "Horn of Winter", "!player.buff(Horn of Winter).any", "player" },
  { "Path of Frost", { "!player.buff(Path of Frost).any", "player.mounted" }, "player" },

  -- Keybinds
  { "Army of the Dead", { "target.boss", "modifier.rshift" } },
  { "Death Grip", "modifier.lalt" },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
    { "Death Grip", true, "target" },
    { "Mind Freeze", true, "target" },
    { "Chains of Ice", true, "target" },
  },{
    "toggle.frogs",
  } },

},
function ()
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
  NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target, run to, and attack enemies.')
end)
