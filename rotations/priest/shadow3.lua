-- TALENTS:   15: Twist of Fate (Shadow Priest) 60: Lingering Insanity (Shadow Priest) 75: Shadowy Insight (Shadow Priest) 90: Power Infusion (Shadow Priest) 100: Shadow Crash (Shadow Priest)

-- SPEC ID 62
NetherMachine.rotation.register_custom(258, "|cFF99FF00Legion |cFFFF6600Shadow Priest |cFFFF9999(Basic)", {

  --Some Shadow DPS

  -- Interrupts
  { "Arcane Torrent", {"target.interruptAt(75)", "modifier.interrupt", "target.range <= 8", "!last.cast(Silence)" }},
  { "Silence", {"target.interruptAt(75)", "modifier.interrupt", "!last.cast(Arcane Torrent)" }},

  -- Stay Alive
  { "Power Word: Shield", "player.health < 90"},
  { "Shadow Mend", {"player.health < 50"}},

  -- Activate Voidform and new rotation
  { "Void Eruption", {"modifier.cooldowns", "!player.buff(Voidform)", "player.buff(Lingering Insanity).count < 20",  } },

  -- Rotation to build Insanity
  {{
    { "Mind Blast", },
    { "Shadow Word: Death",  {"!player.buff(Voidform)", "player.spell(Shadow Word: Death).charges > 1" }},
    { "Shadow Word: Pain", {"!player.buff(Voidform)", "target.debuff(Shadow Word: Pain).duration < 3"}},
    { "Vampiric Touch", {"!player.buff(Voidform)", "target.debuff(Vampiric Touch).duration < 3" }},
    { "Mind Flay", {"!player.buff(Voidform)", "!modifier.multitarget" }},
    { "Mind Sear", {"!player.buff(Voidform)", "modifier.multitarget" }},
  },{ "!player.buff(Void Form)" } },

  -- in Void Form

  --{ "205448", {"player.buff(Voidform)" } }, --Void Bolt
  { "/run CastSpellByID(228260);", {"player.buff(Voidform)", "player.spell(228260).cooldown < 1", "player.spell(205065).cooldown > 1", "player.spell(205065).cooldown < 55" } }, --Checking for Void Torrent CD (the artifact)....
  { "Shadowfiend", {"player.buff(Voidform)",  "modifier.cooldowns" }},
  { "Mindbender", {"player.buff(Voidform)",  "modifier.cooldowns" }},
  { "Shadow Word: Death",  {"player.buff(Voidform)", "player.spell(228260).cooldown > 1" }},
  { "Mind Blast", {"player.buff(Voidform)", "player.spell(205448).cooldown > 1" }},

  { "Void Torrent", {"player.buff(Voidform)" }},
  { "Power Infusion", {"player.buff(Voidform)",  "modifier.cooldowns" }},
  { "Shadow Word: Death",  {"player.buff(Voidform)", "player.spell(Shadow Word: Death).charges > 1" }},

  { "Shadow Word: Pain", {"player.buff(Voidform)", "!target.debuff(Shadow Word: Pain)"}},
  { "Vampiric Touch",    {"player.buff(Voidform)", "!target.debuff(Vampiric Touch)" }},
  { "Mind Flay", {"player.buff(Voidform)", "!modifier.multitarget" }},
  { "Mind Sear", {"player.buff(Voidform)", "modifier.multitarget" }},

  ------------------
  -- End Rotation --
  ------------------

}, {

  ---------------
  -- OOC Begin --
  ---------------

  { "Shadow Form", "!player.buff(Shadowform)" },

  -------------
  -- OOC End --
  -------------

}, function()
  NetherMachine.toggle.create('surrender', 'Interface\\ICONS\\Achievement_boss_generalvezax_01', 'Burn Phase', 'Turn this on if you need something big to die!')
end)

--[[

# Executed before combat begins. Accepts non-harmful actions only.
actions.precombat=flask,type=flask_of_the_whispered_pact
actions.precombat+=/food,type=azshari_salad
actions.precombat+=/augmentation,type=defiled
# Snapshot raid buffed stats before combat begins and pre-potting is done.
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=deadly_grace
actions.precombat+=/shadowform,if=!buff.shadowform.up
{ "Shadow Form", "!player.buff(Shadowform)" },
actions.precombat+=/variable,op=set,name=s2mbeltcheck,value=1,if=cooldown.mind_blast.charges>=2
actions.precombat+=/variable,op=set,name=s2mbeltcheck,value=0,if=cooldown.mind_blast.charges<=1
actions.precombat+=/mind_blast

# Executed every time the actor is available.
actions=potion,name=deadly_grace,if=buff.bloodlust.react|target.time_to_die<=40|(buff.voidform.stack>60&buff.power_infusion.up)
actions+=/variable,op=set,name=actors_fight_time_mod,value=0
actions+=/variable,op=set,name=actors_fight_time_mod,value=-((-(450)+(time+target.time_to_die))%10),if=time+target.time_to_die>450&time+target.time_to_die<600
actions+=/variable,op=set,name=actors_fight_time_mod,value=((450-(time+target.time_to_die))%5),if=time+target.time_to_die<=450
actions+=/variable,op=set,name=s2mcheck,value=0.8*(116+set_bonus.tier19_2pc*(4-variable.s2mbeltcheck*4)+4*variable.s2mbeltcheck+((raw_haste_pct*8)*(2+(0.8*set_bonus.tier19_2pc)+(1*talent.reaper_of_souls.enabled)+(2*artifact.mass_hysteria.rank)-(1*talent.sanlayn.enabled))))-(variable.actors_fight_time_mod*nonexecute_actors_pct)
actions+=/variable,op=min,name=s2mcheck,value=180
actions+=/call_action_list,name=s2m,if=buff.voidform.up&buff.surrender_to_madness.up

actions+=/call_action_list,name=vf,if=buff.voidform.up

actions+=/call_action_list,name=main

actions.main=surrender_to_madness,if=talent.surrender_to_madness.enabled&target.time_to_die<=variable.s2mcheck
  { "193223", {"talent(7,3)", "modifier.surrender" } }, --Surrender to Madness
actions.main+=/mindbender,if=talent.mindbender.enabled&!talent.surrender_to_madness.enabled
  { "Mindbender", {"!talent(7,3)",  "modifier.cooldowns" }},

actions.main+=/mindbender,if=talent.mindbender.enabled&talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck+60
  { "Mindbender", {"talent(7,3)",  "modifier.cooldowns", "target.health > 26" }},

actions.main+=/shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd.max,moving=1,cycle_targets=1
  { "Shadow Word: Pain", {"player.buff(Voidform)", "!target.debuff(Shadow Word: Pain)"}},

--Misery Talent!?
actions.main+=/vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max),cycle_targets=1
actions.main+=/shadow_word_pain,if=!talent.misery.enabled&dot.shadow_word_pain.remains<(3+(4%3))*gcd
actions.main+=/vampiric_touch,if=!talent.misery.enabled&dot.vampiric_touch.remains<(4+(4%3))*gcd

actions.main+=/void_eruption,if=insanity>=85|(talent.auspicious_spirits.enabled&insanity>=(80-shadowy_apparitions_in_flight*4))|set_bonus.tier19_4pc
  { "Void Eruption", {"player.insane >= 85"}},

actions.main+=/shadow_crash,if=talent.shadow_crash.enabled
  { "Shadow Crash", },

actions.main+=/mindbender,if=talent.mindbender.enabled&set_bonus.tier18_2pc
actions.main+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&talent.legacy_of_the_void.enabled&insanity>=70,cycle_targets=1
  { "Shadow Word: Pain", {"!target.debuff(Shadow Word: Pain)", "talent(7,1)", "player.insane >= 70"}},

actions.main+=/vampiric_touch,if=!talent.misery.enabled&!ticking&talent.legacy_of_the_void.enabled&insanity>=70,cycle_targets=1
  { "Vampiric Touch", {"!target.debuff(Shadow Word: Pain)", "talent(7,1)", "player.insane >= 70"}},

actions.main+=/shadow_word_death,if=!talent.reaper_of_souls.enabled&cooldown.shadow_word_death.charges=2&insanity<=90
  { "Shadow Word: Death",  {"!talent(4,2)", "player.spell(Shadow Word: Death).charges > 1", "player.insane <= 90 " }},

actions.main+=/shadow_word_death,if=talent.reaper_of_souls.enabled&cooldown.shadow_word_death.charges=2&insanity<=70
  { "Shadow Word: Death",  {"talent(4,2)", "player.spell(Shadow Word: Death).charges > 1", "player.insane <= 70 " }},

actions.main+=/mind_blast,if=talent.legacy_of_the_void.enabled&(insanity<=81|(insanity<=75.2&talent.fortress_of_the_mind.enabled))
  { "Mind Blast", {"talent(7,1)", "plyer.insane < 81"} },

actions.main+=/mind_blast,if=!talent.legacy_of_the_void.enabled|(insanity<=96|(insanity<=95.2&talent.fortress_of_the_mind.enabled))
  { "Mind Blast", {"!talent(7,1)", "plyer.insane <= 96"} },

actions.main+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)),cycle_targets=1

actions.main+=/vampiric_touch,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank)),cycle_targets=1
actions.main+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&artifact.sphere_of_insanity.rank),cycle_targets=1
actions.main+=/shadow_word_void,if=(insanity<=70&talent.legacy_of_the_void.enabled)|(insanity<=85&!talent.legacy_of_the_void.enabled)
actions.main+=/mind_flay,interrupt=1,chain=1
actions.main+=/shadow_word_pain

actions.s2m=void_bolt,if=set_bonus.tier19_4pc&buff.insanity_drain_stacks.stack<6
actions.s2m+=/shadow_crash,if=talent.shadow_crash.enabled
actions.s2m+=/mindbender,if=talent.mindbender.enabled
actions.s2m+=/void_torrent,if=dot.shadow_word_pain.remains>5.5&dot.vampiric_touch.remains>5.5
actions.s2m+=/berserking,if=buff.voidform.stack>=65
actions.s2m+=/shadow_word_death,if=!talent.reaper_of_souls.enabled&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+20)<100&!buff.power_infusion.up&buff.insanity_drain_stacks.stack<=60
actions.s2m+=/shadow_word_death,if=talent.reaper_of_souls.enabled&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+60)<100&!buff.power_infusion.up&buff.insanity_drain_stacks.stack<=60
actions.s2m+=/power_infusion,if=cooldown.shadow_word_death.charges=0&cooldown.shadow_word_death.remains>2*gcd.max
actions.s2m+=/void_bolt,if=dot.shadow_word_pain.remains<3.5*gcd&dot.vampiric_touch.remains<3.5*gcd&target.time_to_die>10,cycle_targets=1
actions.s2m+=/void_bolt,if=dot.shadow_word_pain.remains<3.5*gcd&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)&target.time_to_die>10,cycle_targets=1
actions.s2m+=/void_bolt,if=dot.vampiric_touch.remains<3.5*gcd&(talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank))&target.time_to_die>10,cycle_targets=1
actions.s2m+=/void_bolt,if=dot.shadow_word_pain.remains<3.5*gcd&artifact.sphere_of_insanity.rank&target.time_to_die>10,cycle_targets=1
actions.s2m+=/void_bolt
actions.s2m+=/shadow_word_death,if=!talent.reaper_of_souls.enabled&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+20)<100
actions.s2m+=/shadow_word_death,if=talent.reaper_of_souls.enabled&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+60)<100
actions.s2m+=/wait,sec=action.void_bolt.usable_in,if=action.void_bolt.usable_in<gcd.max*0.28
actions.s2m+=/dispersion,if=current_insanity_drain*gcd.max>insanity-5&!buff.power_infusion.up
actions.s2m+=/mind_blast
actions.s2m+=/wait,sec=action.mind_blast.usable_in,if=action.mind_blast.usable_in<gcd.max*0.28
actions.s2m+=/shadow_word_death,if=cooldown.shadow_word_death.charges=2
actions.s2m+=/shadowfiend,if=!talent.mindbender.enabled,if=buff.voidform.stack>15
actions.s2m+=/shadow_word_void,if=(insanity-(current_insanity_drain*gcd.max)+50)<100
actions.s2m+=/shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd,moving=1,cycle_targets=1
actions.s2m+=/vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max),cycle_targets=1
actions.s2m+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&(active_enemies<5|talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled|artifact.sphere_of_insanity.rank)
actions.s2m+=/vampiric_touch,if=!talent.misery.enabled&!ticking&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank))
actions.s2m+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)),cycle_targets=1
actions.s2m+=/vampiric_touch,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank)),cycle_targets=1
actions.s2m+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&artifact.sphere_of_insanity.rank),cycle_targets=1
actions.s2m+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=((current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+60)<100&cooldown.shadow_word_death.charges>=1)|action.void_bolt.usable)&ticks>=2

actions.vf=surrender_to_madness,if=talent.surrender_to_madness.enabled&insanity>=25&(cooldown.void_bolt.up|cooldown.void_torrent.up|cooldown.shadow_word_death.up|buff.shadowy_insight.up)&target.time_to_die<=variable.s2mcheck-(buff.insanity_drain_stacks.stack)
actions.vf+=/void_bolt,if=set_bonus.tier19_4pc&buff.insanity_drain_stacks.stack<6
actions.vf+=/shadow_crash,if=talent.shadow_crash.enabled
actions.vf+=/void_torrent,if=dot.shadow_word_pain.remains>5.5&dot.vampiric_touch.remains>5.5&talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+60
actions.vf+=/void_torrent,if=!talent.surrender_to_madness.enabled
actions.vf+=/mindbender,if=talent.mindbender.enabled&!talent.surrender_to_madness.enabled
actions.vf+=/mindbender,if=talent.mindbender.enabled&talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+30
actions.vf+=/power_infusion,if=buff.insanity_drain_stacks.stack>=10+2*set_bonus.tier19_2pc&buff.insanity_drain_stacks.stack<=30&!talent.surrender_to_madness.enabled
actions.vf+=/power_infusion,if=buff.insanity_drain_stacks.stack>=10+2*set_bonus.tier19_2pc&talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+61
actions.vf+=/berserking,if=buff.voidform.stack>=10&buff.insanity_drain_stacks.stack<=20&!talent.surrender_to_madness.enabled
actions.vf+=/berserking,if=buff.voidform.stack>=10&talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+60
actions.vf+=/void_bolt,if=dot.shadow_word_pain.remains<3.5*gcd&dot.vampiric_touch.remains<3.5*gcd&target.time_to_die>10,cycle_targets=1
actions.vf+=/void_bolt,if=dot.shadow_word_pain.remains<3.5*gcd&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)&target.time_to_die>10,cycle_targets=1
actions.vf+=/void_bolt,if=dot.vampiric_touch.remains<3.5*gcd&(talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank))&target.time_to_die>10,cycle_targets=1
actions.vf+=/void_bolt,if=dot.shadow_word_pain.remains<3.5*gcd&artifact.sphere_of_insanity.rank&target.time_to_die>10,cycle_targets=1
actions.vf+=/void_bolt
actions.vf+=/shadow_word_death,if=!talent.reaper_of_souls.enabled&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+10)<100
actions.vf+=/shadow_word_death,if=talent.reaper_of_souls.enabled&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+30)<100
actions.vf+=/wait,sec=action.void_bolt.usable_in,if=action.void_bolt.usable_in<gcd.max*0.28
actions.vf+=/mind_blast
actions.vf+=/wait,sec=action.mind_blast.usable_in,if=action.mind_blast.usable_in<gcd.max*0.28
actions.vf+=/shadow_word_death,if=cooldown.shadow_word_death.charges=2
actions.vf+=/shadowfiend,if=!talent.mindbender.enabled,if=buff.voidform.stack>15
actions.vf+=/shadow_word_void,if=(insanity-(current_insanity_drain*gcd.max)+25)<100
actions.vf+=/shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd,moving=1,cycle_targets=1
actions.vf+=/vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max),cycle_targets=1
actions.vf+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&(active_enemies<5|talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled|artifact.sphere_of_insanity.rank)
actions.vf+=/vampiric_touch,if=!talent.misery.enabled&!ticking&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank))
actions.vf+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)),cycle_targets=1
actions.vf+=/vampiric_touch,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank)),cycle_targets=1
actions.vf+=/shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&artifact.sphere_of_insanity.rank),cycle_targets=1
actions.vf+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=action.void_bolt.usable
actions.vf+=/shadow_word_pain

]]--
