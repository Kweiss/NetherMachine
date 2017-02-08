-- NetherMachine Rotation
-- Custom Feral Druid Rotation
-- Legion 7.1 - early raid gear (865 ilvl)

-- SIMC TALENTS: 15: Lunar Inspiration (Feral Druid)  75: Savage Roar (Feral Druid)  90: Jagged Wounds (Feral Druid)  100: Bloodtalons (Feral Druid)
-- My Best talents - talents=2211322
-- Talent Link: https://cloudup.com/ciG-A-mwAKt
-- Brutal slash 20 energy, Rake 35, shred 40
-- REQUIRED ARTIFACT: Ashamane's Frenzy Ashamane's Bite Scent of Blood Protection of Ashamane Razor Fangs (Rank 6) Powerful Bite (Rank 3)Ashamane's Energy (Rank 3) Attuned to Nature (Rank 3)Tear the Flesh (Rank 3)Shredder Fangs
-- CONTROLS:

NetherMachine.rotation.register_custom(103, "|cFF99FF00Legion |cFFFF6600Feral Druid |cFFFF9999(SimC T19H)", {

	-- 8	4.56	rake,if=buff.prowl.up|buff.shadowmeld.up
	{ "Rake", { "player.buff(Prowl)" } },
	{ "Rake", { "player.buff(Shadowmeld)" } },

	{ "#5512", { "player.health < 50" } }, -- Healthstone (5512)
	{ "Survival Instincts", { "!player.buff(Survival Instincts)", "!modifier.last", "player.health <= 40", "player.spell(61336).charges > 1" } },

	-- 0.00	skull_bash
	{ "Skull Bash", { "target.interruptAt(75)", "!modifier.last(Mighty Bash)", "!modifier.last(War Stomp)", "modifier.interrupt" }},
	{ "Mighty Bash", { "target.interruptAt(75)", "!modifier.last(Skull Bash)", "!modifier.last(War Stomp)", "modifier.interrupt" }},
	{ "War Stomp", { "target.interruptAt(50)", "!modifier.last(Skull Bash)", "!modifier.last(Mighty Bash)", "modifier.interrupt", "target.range <= 10" }},

	{ {
		{ "#127844", { "player.hashero" } },
		{ "#127844", { "player.buff(Berserk)" } },
		{ "#127844", { "player.trinket.any > 0", "target.health < 25" } },
		{ "#127844", { "target.deathin <= 40" } },
	},{ "toggle.consume", "target.boss" } }, -- Potion(#127844: Potion of the Old War)

	-- A	2.94	berserk,if=buff.tigers_fury.up
	{ "Berserk", {"modifier.cooldowns", "player.buff(Tiger's Fury)"}},
	{ "#trinket2", {"modifier.cooldowns", "player.buff(Tiger's Fury)"}},

	-- D	15.21	tigers_fury,if=(!buff.clearcasting.react&energy.deficit>=60)|energy.deficit>=80|(t18_class_trinket&buff.berserk.up&buff.tigers_fury.down)
	{ "Tiger's Fury", {	"!player.buff(Clearcasting)", "player.energy < 40" }},

	-- E	2.54	ferocious_bite,cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>3&(target.health.pct<25|talent.sabertooth.enabled)
	{ "Ferocious Bite", {"target.debuff(Rip).remains < 3", "target.debuff(Rip)", "target.ttd > 3", "target.health <25 " }},

	-- F	35.40	regrowth,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&(combo_points>=5|buff.predatory_swiftness.remains<1.5|(talent.bloodtalons.enabled&combo_points=2&buff.bloodtalons.down&cooldown.ashamanes_frenzy.remains<gcd)|(talent.elunes_guidance.enabled&((cooldown.elunes_guidance.remains<gcd&combo_points=0)|(buff.elunes_guidance.up&combo_points>=4))))
	{ {
		{ "Regrowth", { "player.combopoints >= 5" }},
		{ "Regrowth", { "player.buff(Predatory Swiftness).duration < 1.5" }},
		{ "Regrowth", { "!player.buff(Bloodtalons)", "player.combopoints > 1 ", "player.spell(Ashamane's Frenzy).cooldown < 1" }},
		{ "Regrowth", { "player.health <= 60", "player.combopoints > 1 " }},
	}, {
		"talent(7,2)", "player.buff(Predatory Swiftness)"
	} },

	{ "Regrowth", { "player.health <= 82", "!talent(7,2)", "player.buff(Predatory Swiftness)" } },
	--{ "Regrowth", { "lowest.health <= 80", "player.health >= 90", "player.buff(Predatory Swiftness)", "!talent(7,2)" }, "lowest"},

	-- 0.00	healing_touch,if=equipped.ailuro_pouncers&talent.bloodtalons.enabled&buff.predatory_swiftness.stack>1&buff.bloodtalons.down

	-- H	0.00	call_action_list,name=finisher

	-- actions.finisher
	-- J	8.29	savage_roar,if=!buff.savage_roar.up&(combo_points=5)
	{ "Savage Roar", { "!player.buff(Savage Roar)", "target.ttd > 3", "player.combopoints == 5" } },

	-- 0.00	thrash_cat,cycle_targets=1,if=remains<=duration*0.3&spell_targets.thrash_cat>=5
	{ "Thrash", { "modifier.multitarget", "target.debuff(Thrash) < 2" }},

	-- 0.00	pool_resource,for_next=1

	-- K	15.90	rip,cycle_targets=1,if=
	--									(!ticking| (remains<8&target.health.pct>25&!talent.sabertooth.enabled)| persistent_multiplier>dot.rip.pmultiplier)
	-- 									&target.time_to_die-remains>tick_time*4
	--									&combo_points=5
	--									&(energy.time_to_max<1|buff.berserk.up|buff.incarnation.up|buff.elunes_guidance.up|cooldown.tigers_fury.remains<3|set_bonus.tier18_4pc|buff.clearcasting.react
	--									|talent.soul_of_the_forest.enabled|!dot.rip.ticking|(dot.rake.remains<1.5&spell_targets.swipe_cat<6))

	{ {
		{ "Rip", { "!target.debuff(Rip)" } },
		{ "Rip", { "target.debuff(Rip).remains < 8", "target.health > 25", "!talent(6,1)" } },
		}, {
			"target.ttd > 6", "player.combopoints == 5"
	} },

		-- L	8.34	savage_roar,if=(buff.savage_roar.remains<=10.5|(buff.savage_roar.remains<=7.2&!talent.jagged_wounds.enabled)) --talent(6,2)
		--														&combo_points=5
		--														&(energy.time_to_max<1|buff.berserk.up|buff.incarnation.up|buff.elunes_guidance.up|cooldown.tigers_fury.remains<3|set_bonus.tier18_4pc|buff.clearcasting.react|talent.soul_of_the_forest.enabled|!dot.rip.ticking|(dot.rake.remains<1.5&spell_targets.swipe_cat<6))
	{ {
		{ "Savage Roar", { "player.timetomax <= 1" } },
		{ "Savage Roar", { "player.buff(Berserk)" } },
		{ "Savage Roar", { "player.spell(Tiger's Fury).cooldown < 3" } },
		{ "Savage Roar", { "player.buff(Clearcasting)" } },
		{ "Savage Roar", { "!target.debuff(Rip)" } },
		{ "Savage Roar", { "target.debuff(Rake).remains < 1.5" } },
		}, {
			"player.buff(Savage Roar).remains < 10.5", "target.ttd > 6", "player.combopoints == 5"
	} },

		-- 0.00	swipe_cat,if=combo_points=5&(spell_targets.swipe_cat>=6|(spell_targets.swipe_cat>=3&!talent.bloodtalons.enabled))&combo_points=5&(energy.time_to_max<1|buff.berserk.up|buff.incarnation.up|buff.elunes_guidance.up|cooldown.tigers_fury.remains<3|set_bonus.tier18_4pc|(talent.moment_of_clarity.enabled&buff.clearcasting.react))

		-- M	5.71	ferocious_bite,max_energy=1,cycle_targets=1,if=combo_points=5
		--								&(energy.time_to_max<1|buff.berserk.up|buff.incarnation.up|buff.elunes_guidance.up|cooldown.tigers_fury.remains<3|set_bonus.tier18_4pc|(talent.moment_of_clarity.enabled&buff.clearcasting.react))
	{ {
		{ "Ferocious Bite", { "player.energy > 85", "player.timetomax < 1" } },
		{ "Ferocious Bite", { "player.energy > 95", "player.buff(Berserk)" } },
		{ "Ferocious Bite", { "player.energy > 90", "player.spell(Tiger's Fury).cooldown < 3" } },
	}, "player.combopoints == 5" },

	-- actions.generator
	-- #	count	action,conditions

	-- 0.00	brutal_slash,if=spell_targets.brutal_slash>desired_targets&combo_points<5

	-- N	4.29	ashamanes_frenzy,if=combo_points<=2
	--									&buff.elunes_guidance.down
	--									&(buff.bloodtalons.up|!talent.bloodtalons.enabled)
	--									&(buff.savage_roar.up|!talent.savage_roar.enabled)
	{ "Ashamane's Frenzy", { "player.combopoints < 3 ", "player.buff(Savage Roar)", "player.buff(Bloodtalons)" }},
	{ "Ashamane's Frenzy", { "player.combopoints < 3 ", "player.buff(Savage Roar)", "!talent(7,2)" }},

	-- 0.00	pool_resource,if=talent.elunes_guidance.enabled&combo_points=0&energy<action.ferocious_bite.cost+25-energy.regen*cooldown.elunes_guidance.remains
	-- 0.00	elunes_guidance,if=talent.elunes_guidance.enabled&combo_points=0&energy>=action.ferocious_bite.cost+25

	-- 0.00	pool_resource,for_next=1

	-- 0.00	thrash_cat,if=talent.brutal_slash.enabled&spell_targets.thrash_cat>=9
	-- 0.00	pool_resource,for_next=1
	-- 0.00	swipe_cat,if=spell_targets.swipe_cat>=6

	-- O	3.56	shadowmeld,if=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<2.1&buff.tigers_fury.up&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
	-- 0.00	pool_resource,for_next=1
	-- P	42.65	rake,cycle_targets=1,if=combo_points<5
	--						&(!ticking|(talent.bloodtalons.enabled&buff.bloodtalons.up&(!talent.soul_of_the_forest.enabled&remains<=7|remains<=5)&persistent_multiplier>dot.rake.pmultiplier*0.80))
	--						&target.time_to_die-remains>tick_time

	{ {
		{ "Rake", { "target.debuff(Rake).duration < 3" }},
		{ "Rake", { "player.buff(Bloodtalons)", "target.debuff(Rake).duration <= 5 " }},
	}, "player.combopoints < 5 ", "target.ttd > 3" },

	-- Q 21.20	moonfire_cat,cycle_targets=1,if=combo_points<5&remains<=4.2&target.time_to_die-remains>tick_time*2
	{ "Moonfire", { "player.combopoints < 5", "target.debuff(Moonfire).duration < 4.2", "target.ttd > 8", "talent(1,3)", "!player.buff(Travel Form)" }},

	-- 0.00	pool_resource,for_next=1
	-- 0.00	thrash_cat,cycle_targets=1,if=remains<=duration*0.3&spell_targets.swipe_cat>=2
	-- 0.00	0.00	brutal_slash,if=combo_points<5
	--						&((raid_event.adds.exists&raid_event.adds.in>(1+max_charges-charges_fractional)*15)
	--						|(!raid_event.adds.exists&(charges_fractional>2.66&time>10)))

	{ "Brutal Slash", { "player.combopoints < 5", "player.spell(Brutal Slash).charges > 2" }},
	-- 0.00	swipe_cat,if=combo_points<5&spell_targets.swipe_cat>=3
	-- R	70.77	shred,if=combo_points<5&(spell_targets.swipe_cat<3|talent.brutal_slash.enabled)
	{ "Swipe", { "player.combopoints < 5", "modifier.multitarget" }},
	{ "Shred", { "!modifier.multitarget", "player.combopoints < 5", }},

},
{
-- OUT OF COMBAT ROTATION

	{ "Prowl", { "player.buff(Cat Form)", "target.enemy", "!target.dead" }},
	-- AUTO FORMS
	{ {
		{ "pause", { "target.exists", "target.istheplayer" } },
		{ "/cancelform", { "target.isfriendlynpc", "!player.form == 0", "!player.ininstance", "target.range <= 2" } },
		{ "pause", { "target.isfriendlynpc", "target.range <= 2" } },
		{ "Travel Form", { "!player.buff(Travel Form)", "!target.exists", "!player.ininstance", "player.moving", "player.outdoors" } },
		{ "Cat Form", { "!player.buff(Cat Form)", "target.exists", "target.enemy", "target.range < 30" } },
	},{
		"toggle.forms", "!player.flying", "!player.buff(Dash)",
	} },

},
-- TOGGLE BUTTONS
function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('forms', 'Interface\\Icons\\ability_druid_catform', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
end)
