-- NetherMachine Rotation
-- Unholy Death Knight - WoW WoD 6.1
-- Updated on March 16th 2015

-- SUGGESTED TALENTS: 2001002 Plague Leech, Anti-Magic Zone, Death's Advance, Runic Corruption, Death Pact, Whatever, Defile

-- SUGGESTED GLYPHS: Blood Boil, Raise Ally, Regenerative Magic
-- CONTROLS: Pause - Left Control,

local spread = {
  -- actions.spread=blood_boil,cycle_targets=1,if=!disease.min_ticking
  -- TODO
  -- actions.spread+=/outbreak,if=!disease.min_ticking
  { "Outbreak", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
  { "Outbreak", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
  -- actions.spread+=/plague_strike,if=!disease.min_ticking
  { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
  { "Plague Strike", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
}

local bos_aoe = {
  -- actions.bos_aoe=death_and_decay,if=runic_power<88
  { "Death and Decay", { "!player.moving", "!target.moving", "!talent(7, 2)", "player.runicpower < 88" }, "target.ground" },
  { "Defile", { "!player.moving", "!target.moving", "talent(7, 2)", "player.runicpower < 88" }, "target.ground" },
  -- actions.bos_aoe+=/blood_boil,if=runic_power<88
  { "Blood Boil", { "player.runicpower < 88", "player.area(7).enemies > 0" } },
  -- actions.bos_aoe+=/scourge_strike,if=runic_power<88&unholy=1
  { "Scourge Strike", { "player.runicpower < 88", "player.runes(unholy).count >= 1" } },
  -- actions.bos_aoe+=/icy_touch,if=runic_power<88
  { "Icy Touch", { "player.runicpower < 88" } },
  -- actions.bos_aoe+=/blood_tap,if=buff.blood_charge.stack>=5
  { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
  -- actions.bos_aoe+=/plague_leech
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
  -- actions.bos_aoe+=/empower_rune_weapon
  { "Empower Rune Weapon" },
  -- actions.bos_aoe+=/death_coil,if=buff.sudden_doom.react
  { "Death Coil", { "player.buff(Sudden Doom)" } },
}

local aoe = {
  -- actions.aoe=unholy_blight
  { "Unholy Blight", "player.area(7).enemies > 0" },
  -- actions.aoe+=/call_action_list,name=spread,if=!dot.blood_plague.ticking|!dot.frost_fever.ticking|(!dot.necrotic_plague.ticking&talent.necrotic_plague.enabled)
  { spread, { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
  { spread, { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
  { spread, { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
  -- actions.aoe+=/defile
  { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving" }, "target.ground" },
  -- actions.aoe+=/breath_of_sindragosa,if=runic_power>75
  { "Breath of Sindragosa", { "!modifier.last", "!player.buff", "player.runicpower > 75" } },
  -- actions.aoe+=/run_action_list,name=bos_aoe,if=dot.breath_of_sindragosa.ticking
  { bos_aoe, "target.debuff(Breath of Sindragosa)" },
  -- actions.aoe+=/blood_boil,if=blood=2|(frost=2&death=2)
  { "Blood Boil", { "player.runes(frost).count >= 2", "player.runes(death).count >= 2", "player.area(7).enemies > 0" } },
  { "Blood Boil", { "player.runes(blood).count >= 2", "player.area(7).enemies > 0" } },
  -- actions.aoe+=/summon_gargoyle
  { "Summon Gargoyle" },
  -- actions.aoe+=/dark_transformation
  { "Dark Transformation" },
  -- actions.aoe+=/blood_tap,if=level<=90&buff.shadow_infusion.stack=5
  { "Blood Tap", { "player.level <= 90", "player.buff(Shadow Infusion).count == 5", "player.runes.depleted.count > 1" } },
  -- actions.aoe+=/defile
  { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving" }, "target.ground" },
  -- actions.aoe+=/death_and_decay,if=unholy=1
  { "Death and Decay", { "!talent(7, 2)", "!player.moving", "!target.moving", "player.runes(unholy).count >= 1" }, "target.ground" },
  -- actions.aoe+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=45
  { "Soul Reaper", "target.health < 45" },
  -- actions.aoe+=/scourge_strike,if=unholy=2
  { "Scourge Strike", "player.runes(unholy).count >= 2" },
  -- actions.aoe+=/blood_tap,if=buff.blood_charge.stack>10
  { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.runes.depleted.count > 1" } },
  -- actions.aoe+=/death_coil,if=runic_power>90|buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1)
  { "Death Coil", { "player.runicpower > 90" } },
  { "Death Coil", { "player.runicpower > 30", "player.buff(Sudden Doom)" } },
  { "Death Coil", { "!player.buff(Dark Transformation)", "player.runes(unholy).count <= 1" } },
  -- actions.aoe+=/blood_boil
  { "Blood Boil", "player.area(7).enemies > 0" },
  -- actions.aoe+=/icy_touch
  { "Icy Touch" },
  -- actions.aoe+=/scourge_strike,if=unholy=1
  { "Scourge Strike", "player.runes(unholy).count >= 1" },
  -- actions.aoe+=/death_coil
  { "Death Coil" },
  -- actions.aoe+=/blood_tap
  { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
  -- actions.aoe+=/plague_leech
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
  -- actions.aoe+=/empower_rune_weapon
  { "Empower Rune Weapon", "player.runicpower < 75" },
}

local bos_st = {
  -- actions.bos_st=death_and_decay,if=runic_power<88
  { "Death and Decay", { "!player.moving", "!target.moving", "!talent(7, 2)", "player.runicpower < 88" }, "target.ground" },
  { "Defile", { "!player.moving", "!target.moving", "talent(7, 2)", "player.runicpower < 88" }, "target.ground" },
  -- actions.bos_st+=/festering_strike,if=runic_power<77
  { "Festering Strike", { "player.runicpower < 77" } },
  -- actions.bos_st+=/scourge_strike,if=runic_power<88
  { "Scourge Strike", { "player.runicpower < 88" } },
  -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
  { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 1" } },
  -- actions.bos_st+=/plague_leech
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
  -- actions.bos_st+=/empower_rune_weapon
  { "Empower Rune Weapon" },
  -- actions.bos_st+=/death_coil,if=buff.sudden_doom.react
  { "Death Coil", { "player.buff(Sudden Doom)" } },
}

local single_target = {
  -- actions.single_target=plague_leech,if=(cooldown.outbreak.remains<1)&((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.spell(Outbreak).cooldown <= 1.5", "player.runes(blood).count < 1", "player.runes(frost).count < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.spell(Outbreak).cooldown <= 1.5", "player.runes(blood).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.spell(Outbreak).cooldown <= 1.5", "player.runes(frost).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.spell(Outbreak).cooldown <= 1.5", "player.runes(blood).count < 1", "player.runes(frost).count < 1" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.spell(Outbreak).cooldown <= 1.5", "player.runes(blood).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.spell(Outbreak).cooldown <= 1.5", "player.runes(frost).count < 1", "player.runes(unholy).count < 1" } },
  -- actions.single_target+=/plague_leech,if=((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))&disease.min_remains<3
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 3", "player.runes(blood).count < 1", "player.runes(frost).count < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 3", "player.runes(blood).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 3", "player.runes(frost).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 3", "player.runes(blood).count < 1", "player.runes(frost).count < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 3", "player.runes(blood).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 3", "player.runes(frost).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 3", "player.runes(blood).count < 1", "player.runes(frost).count < 1" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 3", "player.runes(blood).count < 1", "player.runes(unholy).count < 1" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 3", "player.runes(frost).count < 1", "player.runes(unholy).count < 1" } },
  -- actions.single_target+=/plague_leech,if=disease.min_remains<1
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 1" } },
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 1" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 1" } },
  -- actions.single_target+=/outbreak,if=!disease.min_ticking
  { "Outbreak", { "!target.debuff(Frost Fever)" } },
  { "Outbreak", { "!target.debuff(Blood Plague)" } },
  -- actions.single_target+=/unholy_blight,if=!talent.necrotic_plague.enabled&disease.min_remains<3
  { "Unholy Blight", { "!talent(7, 1)", "target.debuff(Frost Fever).remains < 3", "player.area(7).enemies > 0" } },
  { "Unholy Blight", { "!talent(7, 1)", "target.debuff(Blood Plague).remains < 3", "player.area(7).enemies > 0" } },
  -- actions.single_target+=/unholy_blight,if=talent.necrotic_plague.enabled&dot.necrotic_plague.remains<1
  { "Unholy Blight", { "talent(7, 1)", "target.debuff(Necrotic Plague).remains < 1", "player.area(7).enemies > 0" } },
  -- actions.single_target+=/death_coil,if=runic_power>90
  { "Death Coil", "player.runicpower > 90" },
  -- actions.single_target+=/soul_reaper,if=(target.health.pct-3*(target.health.pct%target.time_to_die))<=45
  { "Soul Reaper", "target.health < 45" },
  -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
  { "Breath of Sindragosa", { "!modifier.last", "!player.buff", "player.runicpower > 75", "player.area(9).enemies > 0" } },
  -- actions.single_target+=/run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
  { bos_st, "target.debuff(Breath of Sindragosa)" },
  -- actions.single_target+=/death_and_decay,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
  { "Death and Decay", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 88" }, "target.ground" },
  -- actions.single_target+=/scourge_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
  { "Scourge Strike", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 88" } },
  -- actions.single_target+=/festering_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<76&talent.breath_of_sindragosa.enabled
  { "Festering Strike", { "talent(7, 3)", "player.spell(Breath of Sindragosa).cooldown < 7", "player.runicpower < 76" } },
  -- actions.single_target+=/blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
  { "Blood Tap", { "target.exists", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "target.health < 45", "player.runes.depleted.count > 1" } },
  -- actions.single_target+=/death_and_decay,if=unholy=2
  { "Death and Decay", { "!player.moving", "!target.moving", "player.runes(unholy).count >= 2" }, "target.ground" },
  -- actions.single_target+=/defile,if=unholy=2
  { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving", "player.runes(unholy).count >= 2" }, "target.ground" },
  -- actions.single_target+=/plague_strike,if=!disease.min_ticking&unholy=2
  { "Plague Strike", { "!talent(7, 1)", "player.runes(unholy).count >= 2", "!target.debuff(Frost Fever)" } },
  { "Plague Strike", { "!talent(7, 1)", "player.runes(unholy).count >= 2", "!target.debuff(Blood Plague)" } },
  { "Plague Strike", { "talent(7, 1)", "player.runes(unholy).count >= 2", "!target.debuff(Necrotic Plague)" } },
  -- actions.single_target+=/scourge_strike,if=unholy=2
  { "Scourge Strike", "player.runes(unholy).count >= 2" },
  -- actions.single_target+=/death_coil,if=runic_power>80
  { "Death Coil", "player.runicpower > 80" },
  -- actions.single_target+=/festering_strike,if=talent.necrotic_plague.enabled&talent.unholy_blight.enabled&dot.necrotic_plague.remains<cooldown.unholy_blight.remains%2
  { "Festering Strike", { "talent(7, 1)", "talent(1, 3)", (function() return NetherMachine.condition["debuff.remains"]('target', 'Necrotic Plague') < (NetherMachine.condition["spell.cooldown"]('player', 'Unholy Blight') % 2) end) } },
  -- actions.single_target+=/festering_strike,if=blood=2&frost=2&(((Frost-death)>0)|((Blood-death)>0))
  { "Festering Strike", { "player.runes(blood).count == 2", "player.runes(frost).count == 2", (function() return NetherMachine.condition["runes.count"]('player', 'Frost') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end) } },
  { "Festering Strike", { "player.runes(blood).count == 2", "player.runes(frost).count == 2", (function() return NetherMachine.condition["runes.count"]('player', 'Blood') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end) } },
  -- actions.single_target+=/festering_strike,if=(blood=2|frost=2)&(((Frost-death)>0)&((Blood-death)>0))
  { "Festering Strike", { "player.runes(blood).count == 2", (function() return NetherMachine.condition["runes.count"]('player', 'Frost') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end), (function() return NetherMachine.condition["runes.count"]('player', 'Blood') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end) } },
  { "Festering Strike", { "player.runes(frost).count == 2", (function() return NetherMachine.condition["runes.count"]('player', 'Frost') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end), (function() return NetherMachine.condition["runes.count"]('player', 'Blood') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end) } },
  -- actions.single_target+=/defile,if=blood=2|frost=2
  { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving", "player.runes(blood).count >= 2" }, "target.ground" },
  { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving", "player.runes(frost).count >= 2" }, "target.ground" },
  -- actions.single_target+=/plague_strike,if=!disease.min_ticking&(blood=2|frost=2)
  { "Plague Strike", { "!talent(7, 1)", "player.runes(blood).count == 2", "!target.debuff(Frost Fever)" } },
  { "Plague Strike", { "!talent(7, 1)", "player.runes(blood).count == 2", "!target.debuff(Blood Plague)" } },
  { "Plague Strike", { "talent(7, 1)", "player.runes(blood).count == 2", "!target.debuff(Necrotic Plague)" } },
  { "Plague Strike", { "!talent(7, 1)", "player.runes(frost).count == 2", "!target.debuff(Frost Fever)" } },
  { "Plague Strike", { "!talent(7, 1)", "player.runes(frost).count == 2", "!target.debuff(Blood Plague)" } },
  { "Plague Strike", { "talent(7, 1)", "player.runes(frost).count == 2", "!target.debuff(Necrotic Plague)" } },
  -- actions.single_target+=/scourge_strike,if=blood=2|frost=2
  { "Scourge Strike", "player.runes(blood).count == 2" },
  { "Scourge Strike", "player.runes(frost).count == 2" },
  -- actions.single_target+=/festering_strike,if=((Blood-death)>1)
  { "Festering Strike", (function() return NetherMachine.condition["runes.count"]('player', 'Blood') - NetherMachine.condition["runes.count"]('player', 'death') > 1 end) },
  -- actions.single_target+=/blood_boil,if=((Blood-death)>1)
  { "Blood Boil", { (function() return NetherMachine.condition["runes.count"]('player', 'Blood') - NetherMachine.condition["runes.count"]('player', 'death') > 1 end), "player.area(7).enemies > 0" } },
  -- actions.single_target+=/festering_strike,if=((Frost-death)>1)
  { "Festering Strike", { (function() return NetherMachine.condition["runes.count"]('player', 'Frost') - NetherMachine.condition["runes.count"]('player', 'death') > 1 end) } },
  -- actions.single_target+=/blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
  { "Blood Tap", { "target.exists", "player.spell(Soul Reaper).cooldown == 0", "player.buff(Blood Charge).count > 4", "target.health < 45", "player.runes.depleted.count > 1" } },
  -- actions.single_target+=/summon_gargoyle
  { "Summon Gargoyle" },
  -- actions.single_target+=/death_and_decay
  { "Death and Decay", { "!player.moving", "!target.moving" }, "target.ground" },
  -- actions.single_target+=/defile
  { "Defile", { "talent(7, 2)", "!player.moving", "!target.moving" }, "target.ground" },
  -- actions.single_target+=/blood_tap,if=cooldown.defile.remains=0
  { "Blood Tap", { "talent(7, 2)", "player.spell(Defile).cooldown <= 1.5", "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
  -- actions.single_target+=/plague_strike,if=!disease.min_ticking
  { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
  { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
  { "Plague Strike", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
  -- actions.single_target+=/dark_transformation
  { "Dark Transformation" },
  -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>10&(buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1))
  { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.buff(Sudden Doom)", "player.runes.depleted.count > 1" } },
  { "Blood Tap", { "player.buff(Blood Charge).count > 10", "!player.buff(Dark Transformation)", "player.runes(unholy).count <= 1", "player.runes.depleted.count > 1" } },
  -- actions.single_target+=/death_coil,if=buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1)
  { "Death Coil", { "player.buff(Sudden Doom)" } },
  { "Death Coil", { "!player.buff(Dark Transformation)", "player.runes(unholy).count <= 1" } },
  -- actions.single_target+=/scourge_strike,if=!((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)|(Unholy>=2)
  { "Scourge Strike", { "target.exists", "target.health >= 45" } },
  { "Scourge Strike", { "player.runes(Unholy).count >= 2" } },
  -- actions.single_target+=/blood_tap
  { "Blood Tap", { "player.buff(Blood Charge).count > 4", "player.runes.depleted.count > 1" } },
  -- actions.single_target+=/festering_strike,if=!((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)|(((Frost-death)>0)&((Blood-death)>0))
  { "Festering Strike", "target.health > 45" },
  { "Festering Strike", { (function() return NetherMachine.condition["runes.count"]('player', 'Frost') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end), (function() return NetherMachine.condition["runes.count"]('player', 'Blood') - NetherMachine.condition["runes.count"]('player', 'death') > 0 end) } },
  -- actions.single_target+=/death_coil
  { "Death Coil" },
  -- actions.single_target+=/plague_leech
  { "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
  { "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)" } },
  -- actions.single_target+=/scourge_strike,if=cooldown.empower_rune_weapon.remains=0
  { "Scourge Strike", { "player.buff(Empower Rune Weapon).cooldown <= 1.5" } },
  -- actions.single_target+=/festering_strike,if=cooldown.empower_rune_weapon.remains=0
  { "Festering Strike", { "player.buff(Empower Rune Weapon).cooldown == 0" } },
  -- actions.single_target+=/blood_boil,if=cooldown.empower_rune_weapon.remains=0
  { "Blood Boil", { "player.buff(Empower Rune Weapon).cooldown == 0", "player.area(7).enemies > 0" } },
  -- actions.single_target+=/icy_touch,if=cooldown.empower_rune_weapon.remains=0
  { "Icy Touch", { "player.buff(Empower Rune Weapon).cooldown == 0" } },
  -- actions.single_target+=/empower_rune_weapon,if=blood<1&unholy<1&frost<1
  { "Empower Rune Weapon", { "player.runes(blood).count < 1", "player.runes(unholy).count < 1", "player.runes(frost).count < 1" } },
}

local combat = {
-- COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- AUTO TARGET
  { "/targetenemy [noexists]", { "toggle.autotarget", "!toggle.frogs", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "!toggle.frogs", "target.exists", "target.dead" } },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, true)" },
  }, "toggle.frogs" },

  -- Interrupts
  { "Mind Freeze", "modifier.interrupts" },
  { "Strangulate", {  "modifier.interrupts", "!modifier.last(Mind Freeze)" } },

  -- PLAYER CONTROLLED
  { "Defile", { "modifier.lshift", "talent(7, 2)", "player.area(40).enemies > 0" }, "ground" },
  { "Chains of Ice", { "modifier.control", "player.area(40).enemies > 0" } },
  { "Army of the Dead", { "target.boss", "modifier.rshift", "player.area(40).enemies > 0" } },
  { "Death Grip", { "modifier.lalt", "player.area(40).enemies > 0" } },

  -- DEFENSIVE COOLDOWNS
  { "Death Pact", "player.health < 25" },
  { "Icebound Fortitude", "player.health <= 45" },
  { "Anti-Magic Shell", "player.health <= 45" },
  { "Lichborne", "player.state.charm" },
  { "Lichborne", "player.state.fear" },
  { "Lichborne", "player.state.sleep" },
  { "Desecrated Ground", "player.state.charm" },
  { "Desecrated Ground", "player.state.fear" },
  { "Desecrated Ground", "player.state.sleep" },
  { "Desecrated Ground", "player.state.root" },
  { "Desecrated Ground", "player.state.snare" },

  -- COMMON / COOLDOWNS
  { "Raise Dead", { "!pet.exists", "!modifier.last" } },
  { {
    -- actions=auto_attack
    -- actions+=/deaths_advance,if=movement.remains>2
    -- actions+=/antimagic_shell,damage=100000
    -- actions+=/blood_fury
    { "Blood Fury" },
    -- actions+=/berserking
    { "Berserking" },
    -- actions+=/arcane_torrent
    { "Arcane Torrent" },
    -- actions+=/use_item,slot=trinket2
    -- actions+=/potion,name=draenic_strength,if=buff.dark_transformation.up&target.time_to_die<=60
    { "#109219", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Strength Potion
    { "#109219", { "toggle.consume", "target.boss", "target.deathin <= 60", "player.buff(Dark Transformation)" } }, -- Draenic Strength Potion
    { "#trinket1" },
    { "#trinket2" },
  },{
    "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "target.distance < 5",
  } },

  -- actions+=/run_action_list,name=aoe,if=(!talent.necrotic_plague.enabled&active_enemies>=2)|active_enemies>=4
  { aoe, { "modifier.multitarget", "!talent(7, 1)", "player.area(7).enemies >= 2" } },
  { aoe, { "modifier.multitarget", "player.area(7).enemies >= 4" } },
  -- actions+=/run_action_list,name=single_target,if=(!talent.necrotic_plague.enabled&active_enemies<2)|active_enemies<4
  { single_target, { "!modifier.multitarget" } },
  { single_target, { "modifier.multitarget", "!talent(7, 1)", "player.area(7).enemies < 2" } },
  { single_target, { "modifier.multitarget", "player.area(7).enemies < 4" } },
}

local out_of_combat = {
-- OUT OF COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- Buffs
  { "Unholy Presence", "!player.buff(Unholy Presence)" },
  { "Horn of Winter", "!player.buff(Horn of Winter).any" },
  { "Path of Frost", { "!player.buff(Path of Frost).any", "player.mounted" } },

  -- PET
  { "Raise Dead", { "player.ooctime > 3", "!pet.exists", "!modifier.last" } },

  -- Keybinds
  { "Army of the Dead", { "modifier.rshift", "target.boss", "player.area(40).enemies > 0" } },
  { "Death Grip", { "modifier.lalt", "player.area(40).enemies > 0" } },

  -- FROGGING
  { {
    { "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, true)" },
    { "Death Grip", true, "target" },
    { "Mind Freeze", true, "target" },
    { "Chains of Ice", true, "target" },
  }, "toggle.frogs" },

  -- PRE COMBAT
  -- actions.precombat=flask,type=greater_draenic_strength_flask
  -- actions.precombat+=/food,type=salty_squid_roll
  -- actions.precombat+=/horn_of_winter
  -- actions.precombat+=/unholy_presence
  -- # Snapshot raid buffed stats before combat begins and pre-potting is done.
  -- actions.precombat+=/snapshot_stats
  -- actions.precombat+=/army_of_the_dead
  -- actions.precombat+=/potion,name=draenic_strength
  -- actions.precombat+=/raise_dead
}

NetherMachine.rotation.register_custom(252, "bbDeathKnight Unholy (SimC T17N)", combat, out_of_combat, function ()
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Gulp Frog Mode', 'Automaticly target and follow Gulp Frogs.')
end)
