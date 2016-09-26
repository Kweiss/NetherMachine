--   SPEC ID 102 (Balance)
ProbablyEngine.rotation.register(102, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Interupts
  { "Solar Beam", "modifier.interrupts"},

  -- Mouseover
  { "Moonfire", {"!mouseover.debuff(Moonfire)", "mouseover.enemy"}, "mouseover" },
  { "Sunfire",  {"!mouseover.debuff(Sunfire)",  "mouseover.enemy"}, "mouseover" },


  -- Cooldowns
  { "Celestial Alignment", "modifier.cooldowns"},
  { "Astral Communion", {
  "player.astral < 25",
  "modifier.cooldowns"
  }},
  { "Blessing of the Ancients", "modifier.cooldowns"},
  { "Incarnation: Chosen of Elune",  "modifier.cooldowns"},
  { "Blessing of the Ancients", "!player.buff(Blessing of Elune)"},

 --lvl 110
 { "New Moon", {"modifier.cooldowns", "player.spell(New Moon).charges = 3 "}},
 { "202768", {"modifier.cooldowns", "player.spell(202768).charges = 2 "}},
 { "202771", {"modifier.cooldowns", "player.spell(202771).charges = 1 "}},
 { "Half Moon", "modifier.cooldowns"},
 { "Full Moon", "modifier.cooldowns"},


  -- Rotation
  { "Moonfire", "target.debuff(Moonfire).duration < 2" },
  { "Sunfire", "target.debuff(Sunfire).duration < 2" },
  { "Starfall", {
  "modifier.multitarget",
  "player.astral > 60",
  }},
  { "Starsurge", {
  "!modifier.multitarget",
  "player.astral > 60",
  }},
  { "Stellar Flare", "target.debuff(Stellar Flare) < 2" },
  { "Lunar Strike", "player.buff(Lunar Empowerment)" },
  { "Solar Wrath", {
  "player.buff(Solar Empowerment)",
  "!modifier.cooldowns",
  }},

  { "Solar Wrath", "player.astral < 65"},


}, function()
	-- "toggle.custom_toggle_name"
	ProbablyEngine.toggle.create('toggle', 'Interface\\ICONS\\inv_shield_04', 'CDs w Trinkets', 'Your CDs Will Only Be Used When your Trinkets Proc')
end)


--[[
actions+=/call_action_list,name=fury_of_elune,if=talent.fury_of_elune.enabled&cooldown.fury_of_elue.remains<target.time_to_die
actions+=/new_moon,if=(charges=2&recharge_time<5)|charges=3
actions+=/half_moon,if=(charges=2&recharge_time<5)|charges=3|(target.time_to_die<15&charges=2)
actions+=/full_moon,if=(charges=2&recharge_time<5)|charges=3|target.time_to_die<15
actions+=/stellar_flare,if=remains<7.2
actions+=/moonfire,if=(talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled)
actions+=/sunfire,if=(talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled)
actions+=/astral_communion,if=astral_power.deficit>=75
actions+=/incarnation,if=astral_power>=40
actions+=/celestial_alignment,if=astral_power>=40
actions+=/solar_wrath,if=buff.solar_empowerment.stack=3
actions+=/lunar_strike,if=buff.lunar_empowerment.stack=3
actions+=/call_action_list,name=celestial_alignment_phase,if=buff.celestial_alignment.up|buff.incarnation.up
actions+=/call_action_list,name=single_target

actions.fury_of_elune=incarnation,if=astral_power>=95&cooldown.fury_of_elune.remains<=gcd
actions.fury_of_elune+=/fury_of_elune,if=astral_power>=95
actions.fury_of_elune+=/new_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=90))
actions.fury_of_elune+=/half_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=80))
actions.fury_of_elune+=/full_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=60))
actions.fury_of_elune+=/astral_communion,if=buff.fury_of_elune_up.up&astral_power<=25
actions.fury_of_elune+=/warrior_of_elune,if=buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.up)
actions.fury_of_elune+=/lunar_strike,if=buff.warrior_of_elune.up&(astral_power<=90|(astral_power<=85&buff.incarnation.up))
actions.fury_of_elune+=/new_moon,if=astral_power<=90&buff.fury_of_elune_up.up
actions.fury_of_elune+=/half_moon,if=astral_power<=80&buff.fury_of_elune_up.up&astral_power>cast_time*12
actions.fury_of_elune+=/full_moon,if=astral_power<=60&buff.fury_of_elune_up.up&astral_power>cast_time*12
actions.fury_of_elune+=/moonfire,if=buff.fury_of_elune_up.down&remains<=6.6
actions.fury_of_elune+=/sunfire,if=buff.fury_of_elune_up.down&remains<=5.4
actions.fury_of_elune+=/stellar_flare,if=remains<7.2
actions.fury_of_elune+=/starsurge,if=buff.fury_of_elune_up.down&((astral_power>=92&cooldown.fury_of_elune.remains>gcd*3)|(cooldown.warrior_of_elune.remains<=5&cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.stack<2))
actions.fury_of_elune+=/solar_wrath,if=buff.solar_empowerment.up
actions.fury_of_elune+=/lunar_strike,if=buff.lunar_empowerment.stack=3|(buff.lunar_empowerment.remains<5&buff.lunar_empowerment.up)
actions.fury_of_elune+=/solar_wrath

actions.celestial_alignment_phase=starsurge
actions.celestial_alignment_phase+=/warrior_of_elune,if=buff.lunar_empowerment.stack>=2&((astral_power<=70&buff.blessing_of_elune.down)|(astral_power<=58&buff.blessing_of_elune.up))
actions.celestial_alignment_phase+=/lunar_strike,if=buff.warrior_of_elune.up
actions.celestial_alignment_phase+=/solar_wrath,if=buff.solar_empowerment.up
actions.celestial_alignment_phase+=/lunar_strike,if=buff.lunar_empowerment.up
actions.celestial_alignment_phase+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
actions.celestial_alignment_phase+=/lunar_strike,if=talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains
actions.celestial_alignment_phase+=/solar_wrath

actions.single_target=new_moon,if=astral_power<=90
actions.single_target+=/half_moon,if=astral_power<=80
actions.single_target+=/full_moon,if=astral_power<=60
actions.single_target+=/starsurge
actions.single_target+=/warrior_of_elune,if=buff.lunar_empowerment.stack>=2&((astral_power<=80&buff.blessing_of_elune.down)|(astral_power<=72&buff.blessing_of_elune.up))
actions.single_target+=/lunar_strike,if=buff.warrior_of_elune.up
actions.single_target+=/solar_wrath,if=buff.solar_empowerment.up
actions.single_target+=/lunar_strike,if=buff.lunar_empowerment.up
actions.single_target+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
actions.single_target+=/lunar_strike,if=talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains
actions.single_target+=/solar_wrath

]]--
