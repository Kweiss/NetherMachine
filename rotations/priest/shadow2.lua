-- NetherMachine Rotation
-- Shadow Priest - WoD 6.0.3
-- Updated on Nov 4th 2014

-- PLAYER CONTROLLED (TODO): Levitate, Shackle Undead, Mass Dispel, Dispel Magic, Purify, Fear Ward, Void Tendrils
-- TALENTS: Desperate Prayer, Body and Soul, Mindbender, Void Tendrils, Power Infusion, Halo
-- GLYPHS: Glyph of Fade, Glyph of Mind Flay, Glyph of Dispersion
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(258, "bbPriest Shadow (CoP)", {
-- COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lcontrol" },
  { "pause", "player.buff(Food)" },
  { "pause", "modifier.looting" },
  { "pause", "target.buff(Reckless Provocation)" }, -- Iron Docks - Fleshrender
  { "pause", "target.buff(Sanguine Sphere)" }, -- Iron Docks - Enforcers

  -- FORMS
  { "Shadowform", "!player.buff(Shadowform)" },

  -- DISPELLS
  { "Dispel", { "toggle.dispel", "player.debuff(Aqua Bomb)" }, "player" }, -- Proving Grounds
  { "Dispel", { "toggle.dispel", "player.debuff(Shadow Word: Bane)" }, "player" }, -- Fallen Protectors
  { "Dispel", { "toggle.dispel", "player.debuff(Lingering Corruption)" }, "player" }, -- Norushen
  { "Dispel", { "toggle.dispel", "player.debuff(Mark of Arrogance)", "player.buff(Power of the Titans)" }, "player" }, -- Sha of Pride
  { "Dispel", { "toggle.dispel", "player.debuff(Corrosive Blood)" }, "player" }, -- Thok

  -- DEFENSIVE COOLDOWNS
  { "Psychic Scream", { "talent(4, 2)", "player.area(8).enemies > 1" } },
  { "Fade", "player.state.stun" },
  { "Fade", "player.state.root" },
  { "Fade", "player.state.snare" },
  { "Fade", "player.area(1).enemies > 1" },

  -- HEALING
  { "Desperate Prayer", { "talent(1, 1)", "player.health < 78" }, "player" },
  --{ "Prayer of Mending", { "!player.moving", "player.health < 90", "!player.buff(Prayer of Mending)" }, "player" },
  { "Power Word: Shield", { "!player.debuff(Weakened Soul)" }, "player" },
  --{ "Flash Heal", { "!player.moving", "player.health < 50" }, "player" },

  -- FROGGING
  { {
    { "Power Word: Fortitude", { "@bbLib.engaugeUnit('Gulp Frog', 40, true)" } },
  },{
    "toggle.frogs"
  } },

  -- actions=shadowform,if=!buff.shadowform.up
  { "Shadowform", "!player.buff(Shadowform)" },
  -- actions+=/potion,name=draenic_intellect,if=buff.bloodlust.react|target.time_to_die<=40
  { "#109218", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "player.hashero" } }, -- Draenic Intellect Potion
  { "#109218", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "target.deathin <= 40" } }, -- Draenic Intellect Potion
  -- actions+=/power_infusion,if=talent.power_infusion.enabled
  { "Power Infusion", { "!player.moving", "talent(5, 2)" } },
  -- actions+=/blood_fury
  { "Blood Fury", { "modifier.cooldowns", "target.enemy", "target.alive", "!target.buff(Protection Shield)" } },
  -- actions+=/berserking
  { "Berserking", { "modifier.cooldowns", "target.enemy", "target.alive", "!target.buff(Protection Shield)" } },
  -- actions+=/arcane_torrent
  { "Arcane Torrent", { "modifier.cooldowns", "player.mana <= 70" } },


  -- COP ADVANCED MFI DOTS
  { {
    -- actions.cop_advanced_mfi_dots=mind_spike,if=((target.dot.shadow_word_pain.ticking&target.dot.shadow_word_pain.remains<gcd)|(target.dot.vampiric_touch.ticking&target.dot.vampiric_touch.remains<gcd))&!target.dot.devouring_plague.ticking
    { "Mind Spike", { "!target.debuff(Devouring Plague)", "@bbLib.PriestCoPAdvancedMFIDotsMindSpike" } },
    -- actions.cop_advanced_mfi_dots+=/shadow_word_pain,if=!ticking&miss_react&!target.dot.vampiric_touch.ticking
    { "Shadow Word: Pain", { "!target.debuff(Shadow Word: Pain)", "!target.debuff(Vampiric Touch)" } },
    -- actions.cop_advanced_mfi_dots+=/vampiric_touch,if=!ticking&miss_react
    { "Vampiric Touch", "!target.debuff(Vampiric Touch)" },
    -- actions.cop_advanced_mfi_dots+=/mind_blast
    { "Mind Blast" },
    -- actions.cop_advanced_mfi_dots+=/devouring_plague,if=shadow_orb>=3&target.dot.shadow_word_pain.ticking&target.dot.vampiric_touch.ticking
    { "Devouring Plague", { "player.shadoworbs >= 3", "target.debuff(Shadow Word: Pain)", "target.debuff(Vampiric Touch)" } },
    -- actions.cop_advanced_mfi_dots+=/insanity,if=buff.shadow_word_insanity.remains<0.5*gcd,chain=1
    { "Insanity", { "player.buff(Shadow Word: Insanity)", "player.buff(Shadow Word: Insanity).remains < 1.5" } }, -- TODO: chain=1 (re-cast a channeled spell at the beginning of its last tick)
    -- actions.cop_advanced_mfi_dots+=/insanity,if=active_enemies<=2,interrupt=1,chain=1
    { "Insanity" }, --TODO: chain=1 (re-cast a channeled spell at the beginning of its last tick)  && interrupt=1 (Stopcasting after a tick of spell if higher priority comes up.)
    -- actions.cop_advanced_mfi_dots+=/mind_spike,if=(target.dot.shadow_word_pain.ticking&target.dot.shadow_word_pain.remains<gcd*2)|(target.dot.vampiric_touch.ticking&target.dot.vampiric_touch.remains<gcd*2)
    { "Mind Spike", "@bbLib.PriestCoPAdvancedMFIDotsMindSpikeX2" },
    -- actions.cop_advanced_mfi_dots+=/mind_flay,chain=1,interrupt=1
    { "Mind Flay" }, --TODO: chain=1 (re-cast a channeled spell at the beginning of its last tick)  && interrupt=1 (Stopcasting after a tick of spell if higher priority comes up.)
  },{
    -- target.health.pct>=20&talent.clarity_of_power.enabled&talent.insanity.enabled&active_enemies<=2&(shadow_orb>=4|target.dot.shadow_word_pain.ticking|target.dot.vampiric_touch.ticking|target.dot.devouring_plague.ticking)
    "talent(7, 1)", "talent(3, 3)", "target.health >= 20", "target.area(15).enemies <= 2", "@bbLib.PriestCoPAdvancedMFIDots",
  } },


  -- COP ADVANCED MFI
  { {
    -- actions.cop_advanced_mfi=mind_blast,if=mind_harvest=0,cycle_targets=1
    --{ "Mind Blast", { "player.glyph(162532)", "player.spell(Mind Blast).castingtime <= 9" } }, -- Glyph of Mind Harvest
    -- actions.cop_advanced_mfi+=/mind_blast,if=active_enemies<=5&cooldown_react
    { "Mind Blast" },
    -- actions.cop_advanced_mfi+=/mindbender,if=talent.mindbender.enabled
    { "Mindbender", "talent(3, 2)" },
    -- actions.cop_advanced_mfi+=/shadowfiend,if=!talent.mindbender.enabled
    { "Shadowfiend", "!talent(3, 2)" },
    -- actions.cop_advanced_mfi+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
    { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "target.distance >= 17" } },
    -- actions.cop_advanced_mfi+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 11", "target.area(15).enemies > 1" } },
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 28" } },
    -- actions.cop_advanced_mfi+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.area(8).enemies > 1" } },
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 24" } },
    -- actions.cop_advanced_mfi+=/shadow_word_pain,if=remains<(18*0.3)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
    { "Shadow Word: Pain", { "target.debuff(Shadow Word: Pain).remains < 5.4" } },
    { "Shadow Word: Pain", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Shadow Word: Pain).remains < 5.4" }, "mouseover" },
    -- actions.cop_advanced_mfi+=/vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
    { "Vampiric Touch", { "target.debuff(Vampiric Touch).remains < 4.5" } },
    { "Vampiric Touch", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Vampiric Touch).remains < 4.5" }, "mouseover" },
    -- actions.cop_advanced_mfi+=/mind_sear,if=active_enemies>=6,chain=1,interrupt=1
    { "Mind Sear", "target.area(10).enemies >= 6" }, --TODO: chain=1 (re-cast a channeled spell at the beginning of its last tick)  && interrupt=1 (Stopcasting after a tick of spell if higher priority comes up.)
    -- actions.cop_advanced_mfi+=/mind_spike
    { "Mind Spike" },
    -- actions.cop_advanced_mfi+=/shadow_word_death,moving=1
    { "Shadow Word: Death", "player.moving" },
    -- actions.cop_advanced_mfi+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
    { "Mind Blast", { "player.moving", "player.buff(Shadowy Insight)" } },
    -- actions.cop_advanced_mfi+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
    { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "player.moving" } },
    -- actions.cop_advanced_mfi+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 28", "player.moving" } },
    -- actions.cop_advanced_mfi+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "player.moving" } },
    -- actions.cop_advanced_mfi+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
    { "Shadow Word: Pain", { "player.moving" } },

  },{
    -- target.health.pct>=20&talent.clarity_of_power.enabled&talent.insanity.enabled&active_enemies<=2
    "talent(7, 1)", "talent(3, 3)", "target.health >= 20", "target.area(15).enemies <= 2",
  } },

  -- COP MFI
  { {
    -- actions.cop_mfi=devouring_plague,if=shadow_orb=5
    { "Devouring Plague", "player.shadoworbs > 4" },
    -- actions.cop_mfi+=/mind_blast,if=mind_harvest=0,cycle_targets=1
    -- actions.cop_mfi+=/mind_blast,if=active_enemies<=5&cooldown_react
    { "Mind Blast" },
    -- actions.cop_mfi+=/shadow_word_death,cycle_targets=1
    { "Shadow Word: Death" },
    { "Shadow Word: Death", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.health < 20" }, "mouseover" },
    -- actions.cop_mfi+=/devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)
    { "Devouring Plague", { "player.shadoworbs >= 3", "player.spell(Mind Blast).cooldown < 1.5" } },
    { "Devouring Plague", { "player.shadoworbs >= 3", "target.health < 20", "player.spell(Shadow Word: Death).cooldown < 1.5" } },
    -- actions.cop_mfi+=/mindbender,if=talent.mindbender.enabled
    { "Mindbender", "talent(3, 2)" },
    -- actions.cop_mfi+=/shadowfiend,if=!talent.mindbender.enabled
    { "Shadowfiend", "!talent(3, 2)" },
    -- actions.cop_mfi+=/insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1
    { "Insanity", { "player.buff(Shadow Word: Insanity)", "player.buff(Shadow Word: Insanity).remains < 1.5" } }, --TODO: chain=1
    -- actions.cop_mfi+=/insanity,if=active_enemies<=2,interrupt=1,chain=1
    { "Insanity" }, --TODO: chain=1, interrupt=1
    -- actions.cop_mfi+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
    { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "target.distance >= 17" } },
    -- actions.cop_mfi+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 11", "target.area(15).enemies > 1" } },
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 28" } },
    -- actions.cop_mfi+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.area(8).enemies > 1" } },
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 24" } },
    -- actions.cop_mfi+=/shadow_word_pain,if=remains<(18*0.3)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
    { "Shadow Word: Pain", { "target.debuff(Shadow Word: Pain).remains < 5.4" } },
    { "Shadow Word: Pain", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Shadow Word: Pain).remains < 5.4" }, "mouseover" },
    -- actions.cop_mfi+=/vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
    { "Vampiric Touch", { "target.debuff(Vampiric Touch).remains < 4.5" } },
    { "Vampiric Touch", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Vampiric Touch).remains < 4.5" }, "mouseover" },
    -- actions.cop_mfi+=/mind_sear,if=active_enemies>=6,chain=1,interrupt=1
    { "Mind Sear", "target.area(10).enemies >= 6" },
    -- actions.cop_mfi+=/mind_spike
    { "Mind Spike" },
    -- actions.cop_mfi+=/shadow_word_death,moving=1
    { "Shadow Word: Death", "player.moving" },
    -- actions.cop_mfi+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
    { "Mind Blast", { "player.moving", "player.buff(Shadowy Insight)" } },
    -- actions.cop_mfi+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
    { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "player.moving" } },
    -- actions.cop_mfi+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 28", "player.moving" } },
    -- actions.cop_mfi+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "player.moving" } },
    -- actions.cop_mfi+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
    { "Shadow Word: Pain", { "player.moving" } },
  },{
    -- talent.clarity_of_power.enabled&talent.insanity.enabled&active_enemies<=2
    "talent(7, 1)", "talent(3, 3)", "target.area(15).enemies <= 2",
  } },

  -- COP
  { {
    -- actions.cop=devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<=gcd*1.0|cooldown.shadow_word_death.remains<=gcd*1.0)&primary_target=0,cycle_targets=1
    { "Devouring Plague", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "!mouseover.debuff(Devouring Plague)", "player.spell(Mind Blast).cooldown < 1.5" }, "mouseover" },
    { "Devouring Plague", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "!mouseover.debuff(Devouring Plague)", "player.spell(Shadow Word: Death).cooldown < 1.5" }, "mouseover" },
    -- actions.cop+=/devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<=gcd*1.0|cooldown.shadow_word_death.remains<=gcd*1.0)
    { "Devouring Plague", { "player.shadoworbs >= 3", "player.spell(Mind Blast).cooldown < 1.5" } },
    { "Devouring Plague", { "player.shadoworbs >= 3", "player.spell(Shadow Word: Death).cooldown < 1.5" } },
    -- actions.cop+=/mind_blast,if=mind_harvest=0,cycle_targets=1
    -- actions.cop+=/mind_blast,if=active_enemies<=5&cooldown_react
    { "Mind Blast", "target.area(10).enemies <= 5" },
    -- actions.cop+=/shadow_word_death,cycle_targets=1
    { "Shadow Word: Death" },
    { "Shadow Word: Death", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.health < 20" }, "mouseover" },
    -- actions.cop+=/mindbender,if=talent.mindbender.enabled
    { "Mindbender", "talent(3, 2)" },
    -- actions.cop+=/shadowfiend,if=!talent.mindbender.enabled
    { "Shadowfiend", "!talent(3, 2)" },
    -- actions.cop+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
    { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "target.distance >= 17" } },
    -- actions.cop+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 11", "target.area(15).enemies > 1" } },
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 28" } },
    -- actions.cop+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.area(8).enemies > 1" } },
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 24" } },
    -- actions.cop+=/shadow_word_pain,if=miss_react&!ticking&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
    { "Shadow Word: Pain", { "!target.debuff(Shadow Word: Pain)", "target.area(15).enemies <= 5" } },
    { "Shadow Word: Pain", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "!mouseover.debuff(Shadow Word: Pain)", "mouseover.area(15).enemies <= 5" }, "mouseover" },
    -- actions.cop+=/vampiric_touch,if=remains<cast_time&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
    { "Vampiric Touch", { "target.debuff(Vampiric Touch).remains < 1.5", "target.area(15).enemies <= 5" } },
    { "Vampiric Touch", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Vampiric Touch).remains < 1.5", "mouseover.area(15).enemies <= 5" }, "mouseover" },
    -- actions.cop+=/mind_sear,if=active_enemies>=5,chain=1,interrupt=1
    { "Mind Sear", "target.area(10).enemies >= 5" },
    -- actions.cop+=/mind_spike,if=active_enemies<=4&buff.surge_of_darkness.react
    { "Mind Spike", { "target.area(10).enemies <= 4", "player.buff(Surge of Darkness)" } },
    -- actions.cop+=/mind_sear,if=active_enemies>=3,chain=1,interrupt=1
    { "Mind Sear", "target.area(10).enemies >= 3" },
    -- actions.cop+=/mind_flay,if=target.dot.devouring_plague_tick.ticks_remain>1&active_enemies=1,chain=1,interrupt=1
    { "Mind Flay", { "target.debuff(Devouring Plague).remains > 1", "target.area(15).enemies < 2" } },
    -- actions.cop+=/mind_spike
    { "Mind Spike" },
    -- actions.cop+=/shadow_word_death,moving=1
    { "Shadow Word: Death", "player.moving" },
    -- actions.cop+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
    { "Mind Blast", { "player.moving", "player.buff(Shadowy Insight)" } },
    -- actions.cop+=/halo,moving=1,if=talent.halo.enabled&target.distance<=30
    { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "player.moving" } },
    -- actions.cop+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
    { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 28", "player.moving" } },
    -- actions.cop+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
    { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "player.moving" } },
    -- actions.cop+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
    { "Shadow Word: Pain", { "player.moving" } },
  },{
    -- talent.clarity_of_power.enabled&(active_enemies<=2|target.health.pct<20)
    "talent(7, 1)", (function() return (UnitHealth('target')/UnitHealthMax('target')) * 100 < 20 or UnitsAroundUnit('target', 15) <= 2 end),
  } },


  -- MAIN ROTATION
  -- actions.main=mindbender,if=talent.mindbender.enabled
  { "Mindbender", "talent(3, 2)" },
  -- actions.main+=/shadowfiend,if=!talent.mindbender.enabled
  { "Shadowfiend", "!talent(3, 2)" },
  -- actions.main+=/void_entropy,if=talent.void_entropy.enabled&shadow_orb>=3&miss_react&!ticking&target.time_to_die>60&cooldown.mind_blast.remains<=gcd*2,cycle_targets=1,max_cycle_targets=3
  { "Void Entropy", { "talent(7, 2)", "player.shadoworbs >= 3", "!target.debuff(Void Entropy)", "target.deathin > 60", "player.spell(Mind Blast).cooldown < 3" } },
  -- actions.main+=/devouring_plague,if=talent.void_entropy.enabled&shadow_orb>=3&dot.void_entropy.ticking&dot.void_entropy.remains<10,cycle_targets=1,max_cycle_targets=3
  -- actions.main+=/devouring_plague,if=talent.void_entropy.enabled&shadow_orb>=3&dot.void_entropy.ticking&dot.void_entropy.remains<20,cycle_targets=1,max_cycle_targets=3
  { "Devouring Plague", { "talent(7, 2)", "player.shadoworbs >= 3", "target.debuff(Void Entropy)", "target.debuff(Void Entropy).remains < 15" } },
  -- actions.main+=/devouring_plague,if=talent.void_entropy.enabled&shadow_orb=5
  { "Devouring Plague", { "talent(7, 2)", "player.shadoworbs > 4" } },
  -- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=4&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
  { "Devouring Plague", { "!talent(7, 2)", "talent(3, 1)", "player.shadoworbs >= 4", "!target.debuff(Devouring Plague)" } },
  -- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&((shadow_orb>=4)|(shadow_orb>=3&set_bonus.tier17_2pc))
  { "Devouring Plague", { "!talent(7, 2)", "player.shadoworbs >= 4" } },
  -- actions.main+=/shadow_word_death,cycle_targets=1
  { "Shadow Word: Death" },
  -- actions.main+=/mind_blast,if=!glyph.mind_harvest.enabled&active_enemies<=5&cooldown_react
  { "Mind Blast", "target.area(10).enemies <= 5" },
  -- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
  { "Devouring Plague", { "!talent(7, 2)", "talent(3, 1)", "player.shadoworbs >= 3", "!target.debuff(Devouring Plague)", "player.spell(Mind Blast).cooldown < 1.5" } },
  { "Devouring Plague", { "!talent(7, 2)", "talent(3, 1)", "player.shadoworbs >= 3", "!target.debuff(Devouring Plague)", "target.health < 20", "player.spell(Shadow Word: Death).cooldown < 1.5" } },
  -- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)
  { "Devouring Plague", { "!talent(7, 2)", "player.shadoworbs >= 3", "player.spell(Mind Blast).cooldown < 1.5" } },
  { "Devouring Plague", { "!talent(7, 2)", "player.shadoworbs >= 3", "target.health < 20", "player.spell(Shadow Word: Death).cooldown < 1.5" } },
  -- actions.main+=/mind_blast,if=glyph.mind_harvest.enabled&mind_harvest=0,cycle_targets=1
  -- actions.main+=/mind_blast,if=active_enemies<=5&cooldown_react
  { "Mind Blast", "target.area(15).enemies <= 5" },
  -- actions.main+=/insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1
  { "Insanity", { "player.buff(Shadow Word: Insanity)", "player.buff(Shadow Word: Insanity).remains < 1.5", "target.area(15).enemies <= 2" } },
  -- actions.main+=/insanity,interrupt=1,chain=1,if=active_enemies<=2
  { "Insanity", { "player.buff(Shadow Word: Insanity)", "target.area(15).enemies <= 2" } },
  -- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&active_enemies>2
  { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "player.area(30).enemies > 2" } },
  -- actions.main+=/cascade,if=talent.cascade.enabled&active_enemies>2&target.distance<=40
  { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.area(15).enemies > 2" } },
  -- actions.main+=/divine_star,if=talent.divine_star.enabled&active_enemies>4&target.distance<=24
  { "Divine Star", { "talent(6, 2)", "target.exists", "target.area(8).enemies > 4", "target.distance <= 24" } },
  -- actions.main+=/shadow_word_pain,if=talent.auspicious_spirits.enabled&remains<(18*0.3)&miss_react,cycle_targets=1
  { "Shadow Word: Pain", { "talent(7, 3)", "target.debuff(Shadow Word: Pain).remains < 5.4" } },
  { "Shadow Word: Pain", { "talent(7, 3)", "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Shadow Word: Pain).remains < 5.4" }, "mouseover" },
  -- actions.main+=/shadow_word_pain,if=!talent.auspicious_spirits.enabled&remains<(18*0.3)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
  { "Shadow Word: Pain", { "!talent(7, 3)", "target.debuff(Shadow Word: Pain).remains < 5.4", "target.area(15).enemies <= 5" } },
  { "Shadow Word: Pain", { "!talent(7, 3)", "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Shadow Word: Pain).remains < 5.4", "mouseover.area(15).enemies <= 5" }, "mouseover" },
  -- actions.main+=/vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
  { "Vampiric Touch", { "target.debuff(Vampiric Touch).remains < 6", "target.area(15).enemies <= 5" } },
  { "Vampiric Touch", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.debuff(Vampiric Touch).remains < 6", "mouseover.area(15).enemies <= 5" }, "mouseover" },
  -- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&ticks_remain<=1
  { "Devouring Plague", { "!talent(7, 2)", "player.shadoworbs >= 3", "target.debuff(Devouring Plague).remains < 2" } },
  -- actions.main+=/mind_spike,if=active_enemies<=5&buff.surge_of_darkness.react=3
  { "Mind Spike", { "player.buff(Surge of Darkness)", "target.area(10).enemies <= 5" } },
  -- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
  { "Halo", { "talent(6, 3)", "target.exists", "target.distance <= 30", "target.distance >= 17" } },
  -- actions.main+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
  { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 11", "target.area(15).enemies > 1" } },
  { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "target.distance >= 28" } },
  -- actions.main+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
  { "Divine Star", { "talent(6, 2)", "target.exists", "target.area(8).enemies > 1" } },
  { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 24" } },
  -- actions.main+=/wait,sec=cooldown.shadow_word_death.remains,if=target.health.pct<20&cooldown.shadow_word_death.remains&cooldown.shadow_word_death.remains<0.5&active_enemies<=1
  { "pause", { "target.health < 20", "player.spell(Shadow Word: Death).cooldown > 0", "player.spell(Shadow Word: Death).cooldown < 0.5", "target.area(8).enemies < 2" } },
  -- actions.main+=/wait,sec=cooldown.mind_blast.remains,if=cooldown.mind_blast.remains<0.5&cooldown.mind_blast.remains&active_enemies<=1
  { "pause", { "player.spell(Mind Blast).cooldown > 0", "player.spell(Mind Blast).cooldown < 0.5", "target.area(8).enemies < 2" } },
  -- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5
  { "Mind Spike", { "player.buff(Surge of Darkness)", "target.area(10).enemies <= 5" } },
  -- actions.main+=/divine_star,if=talent.divine_star.enabled&target.distance<=28&active_enemies>1
  { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 28", "target.area(10).enemies > 1" } },
  -- actions.main+=/mind_sear,chain=1,interrupt=1,if=active_enemies>=4
  { "Mind Sear", "target.area(10).enemies >= 4" },
  -- actions.main+=/shadow_word_pain,if=shadow_orb>=2&ticks_remain<=3&talent.insanity.enabled
  { "Shadow Word: Pain", { "talent(3, 3)", "player.shadoworbs >= 2", "target.debuff(Shadow Word: Pain).remains <= 4.5" } },
  -- actions.main+=/vampiric_touch,if=shadow_orb>=2&ticks_remain<=3.5&talent.insanity.enabled
  { "Vampiric Touch", { "talent(3, 3)", "player.shadoworbs >= 2", "target.debuff(Vampiric Touch).remains <= 5.2" } },
  -- actions.main+=/mind_flay,chain=1,interrupt=1
  { "Mind Flay" },
  -- actions.main+=/shadow_word_death,moving=1
  { "Shadow Word: Death", "player.moving" },
  -- actions.main+=/mind_blast,moving=1,if=buff.shadowy_insight.react&cooldown_react
  { "Mind Blast", { "player.moving", "player.buff(Shadowy Insight)" } },
  -- actions.main+=/divine_star,moving=1,if=talent.divine_star.enabled&target.distance<=28
  { "Divine Star", { "talent(6, 2)", "target.exists", "target.distance <= 28", "player.moving" } },
  -- actions.main+=/cascade,moving=1,if=talent.cascade.enabled&target.distance<=40
  { "Cascade", { "talent(6, 1)", "target.exists", "target.distance <= 40", "player.moving" } },
  -- actions.main+=/shadow_word_pain,moving=1,cycle_targets=1
  { "Shadow Word: Pain", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "player.moving" }, "mouseover" },
  { "Shadow Word: Pain", "player.moving" },

}, {
-- OUT OF COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lalt" },
  { "pause", "player.buff(Food)" },

  -- BUFFS
  { "Power Word: Fortitude", { "!player.buffs.stamina", "lowest.distance < 40" }, "lowest" },

  -- HEAL
  { "Desperate Prayer", { "talent(1, 1)", "player.health < 78" }, "player" },
  { "Prayer of Mending", { "!player.moving", "player.health < 90", "!player.buff(Prayer of Mending)" }, "player" },
  { "Power Word: Shield", { "player.moving", "!player.debuff(Weakened Soul)" }, "player" },
  { "Flash Heal", { "!player.moving", "player.health < 50" }, "player" },
  { "Heal", { "!player.moving", "player.health < 100" }, "player" },

  -- REZ
  -- Mass Resurrection
  { "Resurrection", { "target.exists", "target.dead", "!player.moving", "target.player" }, "target" },

  -- FORMS
  -- Shadowform
  { "Shadowform", { "timeout(Shadowform, 5)", "!player.buff(Shadowform)" } },

  -- AUTO FOLLOW
  { "/follow focus", { "toggle.autofollow", "focus.exists", "focus.alive", "focus.friend", "!focus.range < 3", "focus.range < 20" } }, -- TODO: NYI: isFollowing()

  { {
    { "Power Word: Fortitude", { "player.health > 80", "@bbLib.engaugeUnit('Gulp Frog', 40, true)" } },
    { "Devouring Plague", "player.shadoworbs > 2", "target" },
    { "Halo", { "talent(6, 3)", "target.exists", "target.range > 24", "target.range < 30" } },
    { "Shadow Word: Pain", { "target.exists", "!target.debuff(Shadow Word: Pain)" }, "target" },
    { "Shadowfiend", { "target.exists", "!talent(3, 2)" }, "target"  },
    { "Mindbender", { "target.exists", "talent(3, 2)" }, "target"  },
  },{
    "toggle.frogs"
  } },

},
function()
  NetherMachine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_nature_resistnature', 'Mouseovers', 'Toggle usage of Mouseover dotting.')
  NetherMachine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target. Must be another player.')
  NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Gulp Frog Mode', 'Automaticly target un-tapped Gulp Frogs.')
end)

















--[[
Interface file for Shadow Priest [Mirakuru Profiles]
Created by Mirakuru
]]
mirakuru_shadow_config = {
key = "miraShadowConfig",
profiles = true,
title = "Shadow Priest",
subtitle = "Configuration",
color = "005522",
width = 250,
height = 450,
config = {
{type = "spacer"},
{
type = "texture",texture = "Interface\\AddOns\\NetherMachine_Mirakuru\\interface\\media\\splash.blp",
width = 100,
height = 100,
offset = 70,
y = 40,
center = true
},
{type = "spacer"},{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "General Settings",
align = "center",
},
{type = "rule"},
{
type = "checkbox",
default = false,
text = "Auto Target",
key = "auto_target",
desc = "Automatically sets a new target should your current target die or disappear."
},
{type = "spacer"},
{
type = "checkbox",
default = false,
text = "Force Attack",
key = "force_attack",
desc = "Forces the combat routine to attack your target, even when not in combat."
},
{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Party/Raid Buffing",
key = "buff_raid",
desc = "Enables the combat routine to scan and buff your raid or party."
},
{type = "spacer"},{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Use run speed increases",
key = "speed_increase",
desc = "Automatically use Angelic Feathers or Power Word: Shield to increase your run speed."
},
{
type = "checkbox",
default = false,
text = "... Only in Combat.",
key = "speed_increase_combat",
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Combat Settings",
align = "center",
},
{type = "rule"},
{
type = "checkbox",
default = true,
text = "Save cooldowns for bosses",
key = "cd_bosses_only",
desc = "When enabled, forces the combat routine to hold CDs until you target a boss."
},
{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Automatically use level 90 talents",
key = "l90_talents",
desc = "When enabled, the combat routine will determine the most optimal use of your level 90 talent."
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Multi-target Settings",
align = "center",
},
{type = "rule"},
{
type = "spinner",
text = "Mind Sear",
key = "msear_units",
width = 50,
min = 0,
max = 20,
default = 4,
step = 1,
desc = "Minimum number of enemies required to cast Mind Sear."
},
{type = "spacer"},
{
type = "spinner",
text = "Shadow Word: Pain",
key = "swp_count",
default = 4,
min = 0,
max = 20,
width = 50,
desc = "Maximum number of units to cast Shadow Word: Pain on in combat."
},
{type = "spacer"},
{
type = "spinner",
text = "Vampiric Touch",
key = "vt_count",
default = 4,
min = 0,
max = 20,
width = 50,
desc = "Maximum number of units to cast Vampiric Touch on in combat."
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Defensive Settings",
align = "center",
},
{type = "rule"},
{
type = "checkbox",
default = true,
text = "Auto Fade",
key = "fade",
desc = "Automatically use Fade when glyphed."
},
{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Auto Void Tendrils",
key = "tendrils",
desc = "Automatically counter enemies by using Void Tendrils when they get too close."
},
{type = "spacer"},
{
type = "checkspin",
default_check = true,
default_spin = 19,
width = 50,
text = "Dispersion",
key = "dispersion",
desc = "Use Dispersion in emergencies or to counter boss mechanics when available."
},
{type = "spacer"},
{
type = "checkspin",
default_check = true,
default_spin = 35,
width = 50,
text = "Healthstone / Healing Tonic",
key = "stone_pot",
desc = "Automatically use Healthstone or Healing Tonic when you reach this health percentage."
},
}
}





-- Dynamically evaluate settings
local fetch = NetherMachine.interface.fetchKey

local function dynamicEval(condition, spell)
  if not condition then return false end
  return NetherMachine.dsl.parse(condition, spell or '')
end

-- Register our rotation
NetherMachine.rotation.register_custom(258, "bbPriest Shadow (ALPHA)", {
-- COMBAT ROATATION
  -- Auto target enemy when Enabled
  { {
    {"/targetenemy [noexists]", "!target.exists"},
    {"/targetenemy [dead]", {"target.exists", "target.dead"}}
  }, (function() return fetch('miraShadowConfig', 'auto_target') end) },

  -- Healing Tonic / Healthstone
  { {
    {"#109223"},
    {"#5512"}
  },{
    (function() return fetch('miraShadowConfig', 'stone_pot_check') end),
    (function() return dynamicEval('player.health <= '..fetch('miraShadowConfig', 'stone_pot_spin')) end)
  } },

-- Feathers / Power Word: Shield
  { {
    { "17", { "talent(2, 1)", "!player.debuff(6788)" } },
    { "121536", {"talent(2, 2)", "player.spell(121536).charges > 1", "player.buff(121557).duration < 0.2", "player.moving" }, "player.ground"}
  }, (function() return fetch('miraShadowConfig', 'speed_increase') end) },

  -- Cooldowns --
  { {
    { "#trinket1" },
    { "#trinket2" },
    { "!26297", { "player.spell(26297).cooldown = 0", "!player.hashero" } },
    { "!33702", "player.spell(33702).cooldown = 0" },
    { "!28730", { "player.mana <= 90", "player.spell(28730).cooldown = 0" } },
    { "!132604", { "talent(3, 2)", "player.spell(132604).cooldown = 0" } },
    { "!132603", { "!talent(3, 2)", "player.spell(132603).cooldown = 0" } }
  },{
    "modifier.cooldowns", (function()
      if fetch('miraShadowConfig', 'cd_bosses_only') then
        if miLib.unitBoss("target") then return true else return false end
      else return true end
    end)
  } },

  -- Silence
  { "15487", { "target.interruptAt(20)", "target.distance < 30" } },

  -- Mass Dispel Mouseover --
  { "32375", { "player.spell(32375).cooldown = 0", "modifier.lalt" }, "mouseover.ground" },

  -- Mouseover Multidotting --
  { {
    {"589", "mouseover.debuff(589).duration <= 6", "mouseover"},
    {"34914", {"mouseover.debuff(34914).duration <= 6", "!player.moving"}, "mouseover"}
  },{
    "!player.target(mouseover)", "mouseover.enemy(player)", "toggle.mdots"
  } },

  -- Defensive Cooldowns --
  { {
    --{"!586", {"player.glyph(55684)", "incoming.damage"}}
  }, (function() return fetch('miraShadowConfig', 'fade') end) },

  { {
    --{"!47858", {"player.spell(47858).cooldown = 0", "@miLib.bossEvents()"}},
    {"!47858", { "player.spell(47858).cooldown = 0", (function() return dynamicEval("player.health <= " .. fetch('miraShadowConfig', 'dispersion_spin')) end) } },
  }, (function() return fetch('miraShadowConfig', 'dispersion_check') end) },

  -- Void Tendrils
  { {
    { "!108920", { "player.spell(108920).cooldown = 0", "target.distance <= 8" } },
    { "!108920", { "player.firehack", "player.spell(108920).cooldown = 0", "player.area(10).enemies >= 1" } },
  }, (function() return fetch('miraShadowConfig', 'tendrils') end) },

  -- AOE Rotation .. if you can call it AOE --
  { {
    {"!2944", "player.shadoworbs >= 5" },
    {"!2944", { "player.shadoworbs >= 3", "player.buff(167254)", "player.buff(167254).duration <= 1.5" } },
    { "!32379", { "target.health < 20", "player.spell(32379).cooldown = 0" } },
    { "!32379", { "modifier.multitarget", "player.spell(32379).cooldown = 0", "@miLib.manager(32379, 0, 20)" } },
    { "!129176", { "player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20" } },
    {"!8092", "player.spell(8092).cooldown = 0" },
    {"!589", "@miLib.manager(589)" },
    {"!589", "!target.debuff(589)" },
    {"48045", "!player.moving" }
  },{
    "toggle.aoe", (function()
        if FireHack then
          if dynamicEval("target.area(10).enemies >= "..fetch('miraShadowConfig', 'msear_units')) then return true else return false end
        else
          if NetherMachine.condition["modifier.control"]() then return true else return false end
        end
      end)
  } },

-- Combat Routine
{{
-- Clarity of Power
{{
-- Clarity of Power with Insanity
{{
-- Dotweaving, over 20% health
{{
-- Devouring Plague
{{
{"!2944", {"target.debuff(34914)", "target.debuff(589)", "player.shadoworbs >= 5"}},
{"!2944", {"player.buff(167254)", "player.buff(167254).duration <= 1.5"}},
{"!2944", {
"target.debuff(34914)",
"target.debuff(589)",
"!player.buff(132573)",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.4*(1.5/((100+GetHaste("player"))/100))),2)) end)
}}
}, "player.shadoworbs >= 3"},

-- Shadow Word: Death
{{
{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
{{
{"!32379", "@miLib.manager(32379, 0, 20)"}
}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
}},

-- Mind Blast
{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)"}},
{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 4"}},

-- Shadow Word: Pain
{{
{"589", {
"player.shadoworbs = 4",
"player.buff(165628)",
"!target.debuff(589)",
"!target.debuff(158831)",
(function() return dynamicEval("player.spell(8092).cooldown < "..miLib.round((1.2*(1.5/((100+GetHaste("player"))/100))),2)) end),
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.2*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},
{"589", {"player.shadoworbs = 5", "!target.debuff(158831)", "!target.debuff(589)"}}
}},

-- Vampiric Touch
{"34914", {"player.shadoworbs = 5", "!target.debuff(158831)", "!target.debuff(34914)", "!player.moving", "!modifier.last(34914)"}},

-- Mind Flay: Insanity
{"!129197", {
"!player.moving",
"player.buff(132573)",
"timeout(insanity, 1)",
"player.buff(132573).duration > 0.35",
(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},
{"129197", {"!player.moving", "player.buff(132573)"}},

-- Shadow Word: Pain
{"589", {
"player.shadoworbs >= 2",
"target.debuff(589).duration >= 6",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
"target.debuff(34914)",
"player.hashero",
"!player.buff(165628)"
}},

-- Vampiric Touch
{"34914", {
"!player.moving",
"!modifier.last(34914)",
"player.shadoworbs >= 2",
"target.debuff(34914).duration >= 5",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
"player.hashero",
"!player.buff(165628)"
}},

-- Level 90 Talents
{{
{"120644", {
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
"talent(6, 3)",
"target.distance <= 30",
"target.distance >= 17"
}},
{"122121", {
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
"talent(6, 2)",
"target.distance <= 24"
}},
{"127632", {
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
"talent(6, 1)",
"target.distance >= 11",
"target.distance <= 39"
}}
}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},

-- Multidotting
{{
{"!589", "@miLib.manager(589)"},
{{
{"!34914", {"@miLib.manager(34914)"}}
}, {"!modifier.last(34914)", "!player.moving"}}
}, {"player.shadoworbs <= 4", "modifier.multitarget"}},

-- Mind Spike
{{
{"73510", {
"player.buff(132573)",
(function() return dynamicEval("player.buff(132573).duration <= "..miLib.round((1.5/((100+GetHaste("player"))/100)),2)) end),
"player.hashero",
"!target.debuff(589)",
"!target.debuff(34914)"
}},
{{
{"73510", {"target.debuff(589)", "!target.debuff(34914)"}},
{"73510", {"!target.debuff(589)", "target.debuff(34914)"}}
}, {
"!player.moving",
"player.shadoworbs <= 2",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}}
}},

-- Mind Flay
{"15407", {
"!player.moving",
"target.debuff(589)",
"target.debuff(34914)",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.9*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},

-- Mind Spike
{"73510", {
"!player.moving",
"!target.debuff(158831)",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.4*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},

-- Shadow Word: Pain
{"589", "player.moving"}
}, "target.health > 20"},

-- COP Execute (Lite)
{{
-- Devouring Plague
{"!2944", "player.shadoworbs = 5"},

-- Mind Blast
{"!8092", "player.spell(8092).cooldown = 0"},

-- Shadow Word: Death
{{
{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
{{
{"!32379", "@miLib.manager(32379, 0, 20)"}
}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
}},

-- Devouring Plague
{{
{"!2944", (function() return dynamicEval("player.spell(8092).cooldown < "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)},
{"!2944", {
"target.health < 20",
(function() return dynamicEval("player.spell(32379).cooldown < "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)
}}
}, "player.shadoworbs >= 3"},

-- Mind Flay: Insanity
{"!129197", {
"!player.moving",
"player.buff(132573)",
"timeout(insanity, 1)",
"!modifier.last(129197)",
"!player.buff(132573).duration > 0.35",
(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},
{"129197", {"!player.moving", "player.buff(132573)"}},

-- Level 90 Talents
{{
{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
{"122121", {"talent(6, 2)", "target.distance <= 24"}},
{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},

-- Multidotting
{{
{"!589", "@miLib.manager(589)"},
{{
{"!34914", {"@miLib.manager(34914)"}}
}, {"!modifier.last(34914)", "!player.moving"}}
}, {"player.shadoworbs <= 4", "modifier.multitarget"}},

-- Mind Spike
{"73510", "!player.moving"},

-- Shadow Word: Pain
{"589", "player.moving"}
}, "target.health <= 20"}
}, "talent(3, 3)"},

-- Regular Clarity of Power combat
{{
-- Devouring Plague
{{
{"!2944", (function() return dynamicEval("player.spell(8092).cooldown <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)},
{"!2944", {
"target.health < 20",
(function() return dynamicEval("player.spell(32379).cooldown <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)
}}
}, "player.shadoworbs >= 3"},

-- Mind Blast
{"!8092", "player.spell(8092).cooldown = 0"},

-- Shadow Word: Death
{{
{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
{{
{"!32379", "@miLib.manager(32379, 0, 20)"}
}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
{"!129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
}},

-- Level 90 Talents
{{
{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
{"122121", {"talent(6, 2)", "target.distance <= 24"}},
{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},

-- Multidotting
{{
{"!589", "@miLib.manager(589)"},
{{
{"!34914", {"@miLib.manager(34914)"}}
}, {"!modifier.last(34914)", "!player.moving"}}
}, {"player.shadoworbs <= 4", "modifier.multitarget"}},

-- Mind Spike (Surge of Darkness)
{"73510", "player.buff(87160)"},

-- Mind Flay during Devouring Plague
{"15407", {"!player.moving", "target.debuff(158831)"}},

-- Mind Spike without Devouring Plague
{"73510", {"!player.moving", "!target.debuff(158831)"}},

-- Shadow Word: Pain
{"589", "player.moving"}
}, "!talent(3, 3)"}
}, "talent(7, 1)"},

-- Void Entropy rotation
{{
-- Void Entropy
{"!155361", {"target.ttd > 60", "player.shadoworbs >= 3", "!target.debuff(155361)", "!player.casting(155361)", "!player.moving"}},

-- Devouring Plague
{{
{"!2944", {
"target.debuff(155361)",
(function() return dynamicEval("target.debuff(155361).duration <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*2),2)) end)
}},
{"!2944", {"target.debuff(155361)", "target.debuff(155361).duration < 10", "player.shadoworbs = 5"}},
{"!2944", {"target.debuff(155361)", "target.debuff(155361).duration < 20", "player.shadoworbs = 5"}},
{"!2944", {"target.debuff(155361)", "player.shadoworbs = 5"}}
}, {"player.shadoworbs >= 3", "!player.casting(155361)"}},

-- Mind Blast
{{
{"!8092", {"talent(5, 3)", "player.buff(124430)", "player.spell(8092).cooldown = 0"}},
{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)", "!player.moving"}},
{"!8092", {
"!player.moving",
"player.shadoworbs <= 4",
"player.spell(8092).cooldown = 0",
}}
}, "!player.casting(155361)"},

-- Shadow Word: Death
{{
{"!32379", {"player.spell(32379).cooldown = 0", "target.health < 20"}},
{{
{"!32379", "@miLib.manager(32379, 0, 20)"}
}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
}, "player.shadoworbs <= 4"},

-- Shadow Word: Pain
{"589", {
"player.shadoworbs = 4",
"target.debuff(589)",
"player.buff(165628)",
"target.debuff(589).duration < 9",
"player.spell(8092).cooldown < 1.2",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.2*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},

-- Mind Flay: Insanity
{"!129197", {
"talent(3, 3)",
"!player.moving",
"player.buff(132573)",
"timeout(insanity, 1)",
"!modifier.last(129197)",
(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},
{"129197", {
"talent(3, 3)",
"!player.moving",
"player.buff(132573)",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},

-- Mind Spike: Surge of Darkness
{"73510", {"talent(3, 1)", "player.buff(87160).count = 3"}},

-- Shadow Word: Pain
{"589", {"target.debuff(589).duration < 6"}},

-- Vampiric Touch
{"34914", {"!modifier.last(34914)", "target.debuff(34914).duration < 6", "!player.moving"}},

-- Multidotting
{{
{"!589", "@miLib.manager(589)"},
{{
{"!34914", {"@miLib.manager(34914)"}}
}, {"!modifier.last(34914)", "!player.moving"}}
}, "modifier.multitarget"},

-- Level 90 Talents
{{
{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
{"122121", {"talent(6, 2)", "target.distance <= 24"}},
{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
}, {
(function() return fetch('miraShadowConfig', 'l90_talents') end),
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},

-- Mind Spike: Surge of Darkness
{"73510", {
"talent(3, 1)",
"player.buff(87160)",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},

-- Mind Flay
{"15407", {"!player.moving",
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)}},

-- Movement
{"589", "player.moving"}
}, "talent(7, 2)"},

-- Auspicious Spirits rotation
{{
-- Shadow Word: Death
{{
{"!32379", {"target.health < 20", "player.shadoworbs <= 4"}},
{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
{{
{"!32379", "@miLib.manager(32379, 0, 20)"}
}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
}},

-- Mind Blast
{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)", "!player.moving"}},

-- Devouring Plague
{{
{"!2944", "player.shadoworbs = 5"},
{{
{"!2944", "player.spell(8092).cooldown < 1.5"},
{"!2944", {"player.spell(8092).cooldown < 1.5", "target.health < 20"}}
}, "player.shadoworbs >= 3"}
}},

-- Mind Blast
{"!8092", {"talent(5, 3)", "player.buff(124430)", "player.spell(8092).cooldown = 0"}},
{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)", "!player.moving"}},
{"!8092", {"player.spell(8092).cooldown = 0", "!player.moving"}},

-- Mind Flay: Insanity
{"!129197", {
"talent(3, 3)",
"!player.moving",
"player.buff(132573)",
"timeout(insanity, 1)",
"!modifier.last(129197)",
(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
}},
{"129197", {"talent(3, 3)", "!player.moving", "player.buff(132573)"}},

-- Shadow Word: Pain
{"589", "target.debuff(589).duration < 6"},

-- Vampiric Touch
{"34914", {
"!player.moving",
(function() return dynamicEval("target.debuff(34914).duration < "..miLib.round((15*0.3+(1.5/((100+GetHaste("player"))/100))),2)) end)
}},

-- Multidotting
{{
{"!589", "@miLib.manager(589)"},
{{
{"!34914", {"@miLib.manager(34914)"}}
}, {"!modifier.last(34914)", "!player.moving"}}
}, "modifier.multitarget"},

-- Devouring Plague
{"2944", {"!talent(7, 2)", "player.shadoworbs >= 3", "target.debuff(158831)", "target.debuff(158831).duration < 0.9"}},

-- Mind Spike: Surge of Darkness
{"73510", {"talent(3, 1)", "player.buff(87160).count = 3"}},

-- Level 90 Talents
{{
{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
{"122121", {"talent(6, 2)", "target.distance <= 24"}},
{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},

-- Mind Spike: Surge of Darkness
{"73510", {"talent(3, 1)", "player.buff(87160)"}},

-- Dots with Mind Flay: Insanity
{{
{"589", {"target.debuff(589)", "target.debuff(589).duration <= 9"}},
{"34914", {"target.debuff(34914)", "target.debuff(34914).duration <= 9"}}
}, {"talent(3, 3)", "player.shadoworbs >= 2"}},

-- Mind Flay
{"15407", "player.spell(8092).cooldown > 0.5"}
}, {"!talent(7, 1)", "!talent(7, 2)" } }
}, (function()
  if NetherMachine.config.read('button_states', 'aoe', false) then
if FireHack then
if dynamicEval("target.area(10).enemies >= "..fetch('miraShadowConfig', 'msear_units')) then return false else return true end
else
if NetherMachine.condition["modifier.control"]() then return false else return true end
end
else return true end
end)
}


},{
-- OUT OF COMBAT ROTATION
  -- Buffing
  { {
    {"15473", "!player.buff(15473)"},
    {"21562", "!player.buffs.stamina"}
  }, "player.alive" },

  -- Feathers / Power Word: Shield
  { {
    { "17", { "talent(2, 1)", "!player.debuff(6788)" } },
    { "121536", { "talent(2, 2)", "player.spell(121536).charges > 1", "player.buff(121557).duration < 0.2", "player.moving" }, "player.ground" }
  },{
    (function() return fetch('miraShadowConfig', 'speed_increase') end), (function() return (not fetch('miraShadowConfig', 'speed_increase_combat') and true or false) end)
  } },

  -- Mass Dispel Mouseover --
  { "32375", { "player.spell(32375).cooldown = 0", "modifier.lalt" }, "mouseover.ground"},

  -- Auto combat
  { {
    {"/cast "..GetSpellInfo(589), "target.alive"}
  }, (function() return fetch('miraShadowConfig', 'force_attack') end) },

},function()
  NetherMachine.toggle.create('mdots', 'Interface\\Icons\\spell_shadow_shadowwordpain.png', 'Mousover Dotting', "Enables mouseover-dotting within the combat rotation.")
  NetherMachine.toggle.create('aoe', 'Interface\\Icons\\spell_shadow_mindshear.png', 'AOE', "Enables the AOE rotation within the combat rotation.")
  NetherMachine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() miLib.displayFrame(mirakuru_shadow_config) end))
end)
