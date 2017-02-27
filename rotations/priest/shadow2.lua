-- TALENTS:   15: Twist of Fate (Shadow Priest)  60: Lingering Insanity (Shadow Priest)  75: San'layn (Shadow Priest)  90: Power Infusion (Shadow Priest)  100: Legacy of the Void (Shadow Priest)

-- SPEC ID 62
NetherMachine.rotation.register_custom(258, "|cFF99FF00Legion |cFFFF6600Shadow Priest |cFFFF9999(Basic)", {

  -- Interrupts
  { "Arcane Torrent", {"target.interruptAt(75)", "modifier.interrupt", "target.range <= 8", "!modifier.last(Silence)" }},
  { "Silence", {"target.interruptAt(75)", "modifier.interrupt", "!modifier.last(Arcane Torrent)" }},

  -- Stay Alive
  { "Power Word: Shield", {"player.health < 90", "modifier.heals"}},
  { "Shadow Mend", {"player.health < 50", "modifier.heals"}},

  --Moving
  { "Shadow Word: Pain", {"player.moving"}},

  -- Rotation to build Insanity
  {{
    { "Shadow Word: Pain", {"target.debuff(Shadow Word: Pain).duration < 2.5"}},
    { "Vampiric Touch", {"target.debuff(Vampiric Touch).duration < 3.5" }},

    { "Void Eruption", {"modifier.cooldowns" } },
    { "Shadow Crash", },
    { "Shadow Word: Death", {"player.spell(Shadow Word: Death).charges > 1" }},

    { "Mind Blast", },
    { "Mind Flay", },
  },{ "!player.buff(Void Form)" } },

  -- VOID FORM
  {
    { "#trinket2", {"modifier.cooldowns" }},
    { "/run CastSpellByID(228260);", {"player.spell(228260).cooldown < .7", "player.spell(205065).cooldown > 1" } }, --Checking for Void Torrent CD (the artifact)....
    { "Shadow Crash", },
    { "Void Torrent", {"target.debuff(Shadow Word: Pain).duration > 5.5", "target.debuff(Vampiric Touch).duration > 5.5"}},
    { "Mindbender", {"modifier.cooldowns" }},
    { "Power Infusion", {"modifier.cooldowns", "player.buff(Voidform).count =>10" }},

    -- NEED TO SORT OUT HOW TO CAST AT THE VERY END OF VF { "Shadow Word: Death",  {"player.spell(228260).cooldown > 1" }},
    { "Mind Blast", {"player.spell(205448).cooldown > 1" }},
    { "Shadow Word: Death", {"player.spell(Shadow Word: Death).charges > 1" }},
    { "Shadowfiend", {"modifier.cooldowns", "player.buff(Voidform).count =>15" }},

    { "Shadow Word: Pain", {"!target.debuff(Shadow Word: Pain)" }},
    { "Vampiric Touch", {"!target.debuff(Vampiric Touch)" }},
    { "Mind Flay", },
  },{ "player.buff(Voidform)" },

  ------------------
  -- End Rotation --
  ------------------

}, {

  { "Shadowform", "!player.buff(Shadowform)" },

}, function()
  NetherMachine.toggle.create('heals', 'Interface\\ICONS\\ability_priest_shadowyapparition', 'Heal Me', 'Turn this on to use healing while in combat')
end)

--[[
Default action list Executed every time the actor is available.
#	count	action,conditions
8	1.00	potion,name=prolonged_power,if=buff.bloodlust.react|target.time_to_die<=80|(target.health.pct<35&cooldown.power_infusion.remains<30)
9	0.00	call_action_list,name=check,if=talent.surrender_to_madness.enabled&!buff.surrender_to_madness.up
A	0.00	run_action_list,name=s2m,if=buff.voidform.up&buff.surrender_to_madness.up
B	0.00	run_action_list,name=vf,if=buff.voidform.up
C	0.00	run_action_list,name=main


actions.main
#	count	action,conditions
0.00	surrender_to_madness,if=talent.surrender_to_madness.enabled&target.time_to_die<=variable.s2mcheck
0.00	mindbender,if=talent.mindbender.enabled&((talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck+60)|!talent.surrender_to_madness.enabled)
0.00	shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd.max,moving=1,cycle_targets=1
0.00	vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max),cycle_targets=1
D	1.00	shadow_word_pain,if=!talent.misery.enabled&dot.shadow_word_pain.remains<(3+(4%3))*gcd
E	1.00	vampiric_touch,if=!talent.misery.enabled&dot.vampiric_touch.remains<(4+(4%3))*gcd
F	8.59	void_eruption,if=insanity>=70|(talent.auspicious_spirits.enabled&insanity>=(65-shadowy_apparitions_in_flight*3))|set_bonus.tier19_4pc
0.00	shadow_crash,if=talent.shadow_crash.enabled
0.00	mindbender,if=talent.mindbender.enabled&set_bonus.tier18_2pc
0.00	shadow_word_pain,if=!talent.misery.enabled&!ticking&talent.legacy_of_the_void.enabled&insanity>=70,cycle_targets=1
0.00	vampiric_touch,if=!talent.misery.enabled&!ticking&talent.legacy_of_the_void.enabled&insanity>=70,cycle_targets=1
G	0.19	shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&cooldown.shadow_word_death.charges=2&insanity<=(85-15*talent.reaper_of_souls.enabled)
H	8.59	mind_blast,if=active_enemies<=4&talent.legacy_of_the_void.enabled&(insanity<=81|(insanity<=75.2&talent.fortress_of_the_mind.enabled))
0.00	mind_blast,if=active_enemies<=4&!talent.legacy_of_the_void.enabled|(insanity<=96|(insanity<=95.2&talent.fortress_of_the_mind.enabled))
0.00	shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)),cycle_targets=1
0.00	vampiric_touch,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank)),cycle_targets=1
0.00	shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&artifact.sphere_of_insanity.rank),cycle_targets=1
0.00	shadow_word_void,if=talent.shadow_word_void.enabled&(insanity<=70&talent.legacy_of_the_void.enabled)|(insanity<=85&!talent.legacy_of_the_void.enabled)
I	9.53	mind_flay,interrupt=1,chain=1
0.00	shadow_word_pain


actions.vf
#	count	action,conditions
0.00	surrender_to_madness,if=talent.surrender_to_madness.enabled&insanity>=25&(cooldown.void_bolt.up|cooldown.void_torrent.up|cooldown.shadow_word_death.up|buff.shadowy_insight.up)&target.time_to_die<=variable.s2mcheck-(buff.insanity_drain_stacks.stack)
J	120.20	void_bolt
0.00	shadow_crash,if=talent.shadow_crash.enabled
K	5.10	void_torrent,if=dot.shadow_word_pain.remains>5.5&dot.vampiric_touch.remains>5.5&(!talent.surrender_to_madness.enabled|(talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+60))
0.00	mindbender,if=talent.mindbender.enabled&(!talent.surrender_to_madness.enabled|(talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+30))
L	2.69	power_infusion,if=buff.insanity_drain_stacks.stack>=(10+2*set_bonus.tier19_2pc+5*buff.bloodlust.up+5*variable.s2mbeltcheck)&(!talent.surrender_to_madness.enabled|(talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+61))
M	2.00	berserking,if=buff.voidform.stack>=10&buff.insanity_drain_stacks.stack<=20&(!talent.surrender_to_madness.enabled|(talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+60))
0.00	void_bolt
N	1.94	shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+(15+15*talent.reaper_of_souls.enabled))<100
0.00	wait,sec=action.void_bolt.usable_in,if=action.void_bolt.usable_in<gcd.max*0.28
O	37.87	mind_blast,if=active_enemies<=4
0.00	wait,sec=action.mind_blast.usable_in,if=action.mind_blast.usable_in<gcd.max*0.28&active_enemies<=4
P	3.96	shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&cooldown.shadow_word_death.charges=2
Q	2.00	shadowfiend,if=!talent.mindbender.enabled,if=buff.voidform.stack>15
0.00	shadow_word_void,if=talent.shadow_word_void.enabled&(insanity-(current_insanity_drain*gcd.max)+25)<100
0.00	shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd,moving=1,cycle_targets=1
0.00	vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max),cycle_targets=1
0.00	shadow_word_pain,if=!talent.misery.enabled&!ticking&(active_enemies<5|talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled|artifact.sphere_of_insanity.rank)
0.00	vampiric_touch,if=!talent.misery.enabled&!ticking&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank))
0.00	shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)),cycle_targets=1
0.00	vampiric_touch,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank)),cycle_targets=1
0.00	shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&artifact.sphere_of_insanity.rank),cycle_targets=1
R	58.63	mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(action.void_bolt.usable|(current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+30)<100&cooldown.shadow_word_death.charges>=1))
0.00	shadow_word_pain

]]--
