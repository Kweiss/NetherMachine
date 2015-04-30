local singleTarget = {
  -- actions.single_target+=/plague_leech,if=!talent.necrotic_plague.enabled&(dot.blood_plague.remains<1&dot.frost_fever.remains<1)
  { "Plague Leech", { "spell(Outbreak).cooldown < 1", "target.debuff(Necrotic Plague)" } },
  { "Plague Leech", { "spell(Outbreak).cooldown < 1", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" } },
  -- actions.single_target+=/plague_leech,if=talent.necrotic_plague.enabled&(dot.necrotic_plague.remains<1)
  { "Plague Leech", { "target.debuff(Necrotic Plague).duration < 1" }},
  -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=45
  { "Soul Reaper", "target.health <= 45" },
  -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=45&cooldown.soul_reaper.remains=0)
  { "Blood Tap", { "target.health <= 45", "spell(Soul Reaper).cooldown = 0" }},
  -- actions.single_target+=/summon_gargoyle
  { "Summon Gargoyle", "modifier.cooldowns" },
  -- actions.single_target+=/death_coil,if=runic_power>90
  { "Death Coil", "player.runicpower > 90" },
  -- actions.single_target+=/defile
  { "Defile", { "target.exists", "player.time > 5" }, "target.ground" },
  -- actions.single_target+=/dark_transformation
  { "Dark Transformation" },
  -- actions.single_target+=/unholy_blight,if=!talent.necrotic_plague.enabled&(dot.frost_fever.remains<3|dot.blood_plague.remains<3)
  { "Unholy Blight", "target.debuff(Frost Fever).duration < 3" },
  { "Unholy Blight", "target.debuff(Blood Plague).duration < 3" },
  -- actions.single_target+=/unholy_blight,if=talent.necrotic_plague.enabled&dot.necrotic_plague.remains<1
  { "Unholy Blight", "target.debuff(Necrotic Plague).duration < 1"},
  -- actions.single_target+=/outbreak,if=!talent.necrotic_plague.enabled&(!dot.frost_fever.ticking|!dot.blood_plague.ticking)
  { "Outbreak", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
  { "Outbreak", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
  -- actions.single_target+=/outbreak,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
  { "Outbreak", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
  -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&(!dot.blood_plague.ticking|!dot.frost_fever.ticking)
  { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
  { "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
  -- actions.single_target+=/plague_strike,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
  { "Plague Strike", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
  -- BoS used?
  -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
  -- actions.single_target+=/run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
  -- actions.single_target+=/death_and_decay,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
  -- actions.single_target+=/scourge_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
  -- actions.single_target+=/festering_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<76&talent.breath_of_sindragosa.enabled
  -- actions.single_target+=/death_and_decay,if=unholy=2
  { "Death and Decay", "player.runes(unholy).count = 2" },
  -- actions.single_target+=/blood_tap,if=unholy=2&cooldown.death_and_decay.remains=0
  { "Blood Tap", { "player.runes(unholy).count = 2", "spell(Death and Decay).cooldown = 0" }},
  -- actions.single_target+=/scourge_strike,if=unholy=2
  { "Scourge Strike", "player.runes(unholy).count = 2"},
  -- actions.single_target+=/death_coil,if=runic_power>80
  { "Death Coil|DC@80RP", "player.runicpower > 80" },
  -- actions.single_target+=/festering_strike,if=blood=2&frost=2
  { "Festering Strike", { "player.runes(blood).count = 2", "player.runes(frost).count = 2" }},
  -- actions.single_target+=/death_and_decay
  { "Death and Decay", { "target.exists", "player.time > 5" }, "target.ground" },
  -- actions.single_target+=/blood_tap,if=cooldown.death_and_decay.remains=0
  { "Blood Tap", "spell(Death and Decay).cooldown = 0" },
  -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>10&(buff.sudden_doom.react|(buff.dark_transformation.down&rune.unholy<=1))
  { "Blood Tap", { "player.buff(Blood Charge).count > 10", "player.buff(Sudden Doom)" }},
  { "Blood Tap", { "player.buff(Blood Charge).count > 10", "!pet.buff(Dark Transformation)", "player.runes(unholy).count <= 1" }},
  -- actions.single_target+=/death_coil,if=buff.sudden_doom.react|(buff.dark_transformation.down&rune.unholy<=1)
  { "Death Coil", "player.buff(Sudden Doom)" },
  { "Death Coil", "!pet.buff(Dark Transformation)", "player.runes(unholy).count <= 1" },
  -- actions.single_target+=/scourge_strike,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=45)|(unholy>=1&death>=1)|(death>=2)
  { "Scourge Strike", "target.health > 45" },
  { "Scourge Strike", { "player.runes(unholy).count >= 1", "player.runes(death).count >= 1" }},
  { "Scourge Strike", "player.runes(death).count >= 2" },
  -- actions.single_target+=/festering_strike
  { "Festering Strike" },
  -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>=10&runic_power>=30
  { "Blood Tap", { "player.buff(Blood Charge).count >= 10", "player.runicpower >= 30" }},
  -- actions.single_target+=/death_coil
  { "Death Coil|DCIDLE" },
  -- actions.single_target+=/empower_rune_weapon
  { "Empower Rune Weapon", "modifier.cooldowns" }

}

local multiTarget = {

}

NetherMachine.rotation.register_custom(252, 'Unholy Death Knight', {
  { singleTarget }
},{

}, function()
  NetherMachine.condition.register("modifier.xkey", function()
    if FireHack then
      return GetKeyState(0x58)
    end
  end)
end)
