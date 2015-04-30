-- NetherMachine Rotation
-- Custom Feral Druid Rotation
-- Created on Jan 25th 2015
-- Updated by Phreakshow
-- Updated on 04/15/2015 @ 10:23
--	Version 1.0.2
-- Status: Functional & (Tested) Error Free - Work in Progress [ Estimated Completion: ~75% ]
-- Notes: Updating feral profile to match SimCraft T17-Heroic & T17-Mythic Action Rotation Lists
-- Credits to *** Backburn *** for the original profile development! [Personal thanks for all of your hard work and dedication of being a WoW player]

-- REQUIRED TALENTS: 3002002
-- Optional Talents: 3002302
-- REQUIRED GLYPHS: Savage Roar, Cat Form
-- CONTROLS: Left Ctrl == Pause Profile Rotation
NetherMachine.rotation.register_custom(103, "|cFF99FF00Phreakshow |cFFFF6600Feral Druid |cFFFF9999(SimC T17H) |cFF336600Version: |cFF3333CC1.0.2", {
---- *** COMBAT ROUTINE ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },
	
	-- Survival Logic
	{ {
		{ "#5512", { "player.health < 30" } }, -- Healthstone (5512)
		{ "Rejuvenation", { "player.health < 80", "!player.buff(Rejuvenation)" } },
		{ "Survival Instincts", { "!player.buff(Survival Instincts)", "!modifier.last", "player.health <= 40" } },
	},{ "toggle.survival" } },
	
	-- Auto Target
	{ {
		{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
		{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },
	},{ "toggle.autotarget" } },
	
	-- Interrupt Logic
	{ {
		{ "Skull Bash", { "target.distance <= 13" } },
		{ "Mighty Bash", { "talent(5, 3)", "target.distance <= 5" } }, -- "Optional" Talent(Mighty Bash) Interrupt
	},{ "modifier.interrupt" } },
	{ {
		{ "Skull Bash", { "mouseover.exists", "mouseover.enemy", "mouseover.interrupt", "mouseover.distance <= 13" }, "mouseover" },
	},{ "toggle.mouseovers" } },
	-- Main Combat Rotation Routine
	
	-- SimCraft T17H | **++**++** Action.List **++**++** # Executed every time the actor is available.
	-- SimCraft T17H | actions=cat_form
	-- SimCraft T17H | actions+=/wild_charge
	-- SimCraft T17H | actions+=/displacer_beast,if=movement.distance>10
	-- SimCraft T17H | actions+=/dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
	-- SimCraft T17H | actions+=/rake,if=buff.prowl.up|buff.shadowmeld.up
	{ "Rake", { "player.buff(Prowl)" } },
	{ "Rake", { "player.buff(Shadowmeld)" } },
	-- SimCraft T17H | actions+=/auto_attack
	-- SimCraft T17H | actions+=/skull_bash
	-- SimCraft T17H | actions+=/force_of_nature,if=charges=3|trinket.proc.all.react|target.time_to_die<20
	{ "Force of Nature", { "player.spell(Force of Nature).charges > 2" } },
	{ "Force of Nature", { "player.trinket.any > 0" } },
	{ "Force of Nature", { "target.boss", "target.deathin < 20" } },
	{ "Force of Nature", { "player.hashero" } },
	-- SimCraft T17H | actions+=/berserk,sync=tigers_fury,if=buff.king_of_the_jungle.up|!talent.incarnation.enabled
	{ "Berserk", { "modifier.cooldowns", "player.buff(Tiger's Fury)", "player.buff(102543)" } },  -- Incarnation: King of the Jungle(102543)
	{ "Berserk", { "modifier.cooldowns", "talent(4, 2)" } },  -- Talent(Incarnation: King of the Jungle)
	-- SimCraft T17H | actions+=/use_item,slot=trinket1,if=(prev.tigers_fury&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|prev.berserk|(buff.king_of_the_jungle.up&time<10)
	{ "#trinket1", { "modifier.cooldowns", "player.buff(Tiger's Fury)" } }, --ToDo Fix this
	{ "#trinket2", { "modifier.cooldowns", "player.buff(Tiger's Fury)" } }, -- ToDo Fix This
	-- SimCraft T17H | actions+=/potion,name=draenic_agility,if=(buff.berserk.remains>10&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
	{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Potion(Brawler's Bottomless Draenic Agility Potion)
	{ {
		{ "#109217", { "player.hashero" } },
		{ "#109217", { "player.buff(Berserk)" } },
		{ "#109217", { "player.trinket.any > 0", "target.health < 25" } },
		{ "#109217", { "target.deathin <= 40" } },
	},{ "toggle.consume", "target.boss" } }, -- Potion(#109217: Draenic Agility Potion)
	-- SimCraft T17H | actions+=/blood_fury,sync=tigers_fury
	{ "Blood Fury", "player.buff(Tiger's Fury)" },
	-- SimCraft T17H | actions+=/berserking,sync=tigers_fury
	{ "Berserking", "player.buff(Tiger's Fury)" },
	-- SimCraft T17H | actions+=/arcane_torrent,sync=tigers_fury
	{ "Arcane Torrent", "player.buff(Tiger's Fury)" },
	-- SimCraft T17H | actions+=/tigers_fury,if=(!buff.omen_of_clarity.react&energy.max-energy>=60)|energy.max-energy>=80
	{ "Tiger's Fury", { "modifier.cooldowns", "!player.buff(Omen of Clarity)", "player.energy.deficit >= 60" } },
	{ "Tiger's Fury", { "modifier.cooldowns", "player.energy.deficit >= 80" } },
	-- SimCraft T17H | actions+=/incarnation,if=cooldown.berserk.remains<10&energy.time_to_max>1
	{ "102543", { "modifier.cooldowns", "player.spell(Berserk).cooldown < 10", "player.timetomax > 1" } }, -- Incarnation: King of the Jungle
	-- SimCraft T17H | actions+=/shadowmeld,if=dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
	--ToDo: &dot.rake.pmultiplier<2
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "player.buff(Bloodtalons)", "!talent(4, 2)" } },
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "!talent(7, 2)", "!talent(4, 2)" } },
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "player.buff(Bloodtalons)", "talent(4, 2)", "player.spell(102543).cooldown > 15" } },
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "!talent(7, 2)", "talent(4, 2)", "player.spell(102543).cooldown > 15" } },
	-- SimCraft T17H | actions+=/ferocious_bite,cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
	{ "Ferocious Bite", { "target.debuff(Rip)", "target.debuff(Rip).remains < 3", "target.health < 25" } },
	{ "Ferocious Bite", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.alive", "mouseover.distance < 3", "mouseover.debuff(Rip)", "mouseover.debuff(Rip).remains < 3", "mouseover.health < 25" }, "mouseover" },
	-- SimCraft T17H | actions+=/healing_touch,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&(combo_points>=4|buff.predatory_swiftness.remains<1.5)
	{ "Healing Touch", { "talent(7, 2)", "player.buff(Predatory Swiftness)", "player.combopoints >= 4" } },
	{ "Healing Touch", { "talent(7, 2)", "player.buff(Predatory Swiftness)", "player.buff(Predatory Swiftness).remains < 1.5" } },
	-- SimCraft T17H | actions+=/savage_roar,if=buff.savage_roar.down
	{ "Savage Roar", { "player.buff(Savage Roar).remains < 2" } },
	-- SimCraft T17H | actions+=/pool_resource,for_next=1
	-- SimCraft T17H | actions+=/thrash_cat,cycle_targets=1,if=remains<4.5&(active_enemies>=2&set_bonus.tier17_2pc|active_enemies>=4)
--	{ "Thrash", { "player.buff(Omen of Clarity)", "target.debuff(Thrash).remains < 4.5", "player.area(5).enemies > 1" } },
--	{ "Thrash", { "!talent(7, 2)", "player.buff(Omen of Clarity)", "target.debuff(Thrash).remains < 4.5", "player.combopoints > 4" } },
	{ "Thrash", { "target.debuff(Thrash).remains < 4.5", "player.area(5).enemies > 3" } }, --I have my 4 set tier 17 bonus, but how to detect tier bonus? ToDo: Detect player.tier(17) 2 & 4  set bonus
	
	-- SimCraft T17H | actions+=/call_action_list,name=finisher,if=combo_points=5
		-- SimCraft T17H | **++**++**  Action.Finisher **++**++** # Finishing moves to use pooled ComboPoints.
		{ {
			-- SimCraft T17H | actions.finisher=ferocious_bite,cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
			--ToDo: max_energy=1 ???
			{ "Ferocious Bite", { "target.health < 25", "target.debuff(Rip)" } },
			-- SimCraft T17H | actions.finisher+=/rip,cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
			{ "Rip", { "target.debuff(Rip).remains < 3", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rip") > 18 end) } },
			-- SimCraft T17H | actions.finisher+=/rip,cycle_targets=1,if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|!talent.bloodtalons.enabled)&target.time_to_die-remains>18
			--ToDo: &persistent_multiplier>dot.rip.pmultiplier
			{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.timetomax <= 1" } },
			{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.buff(Berserk)" } },
			{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.spell(Tiger's Fury).cooldown < 3" } },
			{ "Ferocious Bite", { "player.energy > 50", "player.timetomax <= 1" } },
			{ "Ferocious Bite", { "player.energy > 50", "player.buff(Berserk)" } },
			{ "Ferocious Bite", { "player.energy > 50", "player.spell(Tiger's Fury).cooldown < 3" } },
		}, "player.combopoints == 5" },
	
	-- SimCraft T17H | actions+=/savage_roar,if=buff.savage_roar.remains<gcd
	-- SimCraft T17H | actions+=/call_action_list,name=maintain,if=combo_points<5
	-- SimCraft T17H | actions+=/pool_resource,for_next=1
	-- SimCraft T17H | actions+=/thrash_cat,cycle_targets=1,if=remains<4.5&active_enemies>=2
	-- SimCraft T17H | actions+=/call_action_list,name=generator,if=combo_points<5


	
	-- SimCraft T17H | actions.finisher+=/rip,cycle_targets=1,if=remains<2&target.time_to_die-remains>18
	-- SimCraft T17H | actions.finisher+=/savage_roar,if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
	-- SimCraft T17H | actions.finisher+=/ferocious_bite,max_energy=1,if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)

	-- SimCraft T17H | SimCraft T17H | **++**++** Action.Generator **++**++** # Generation of ComboPoints.
	-- SimCraft T17H | actions.generator=swipe,if=active_enemies>=3
	-- SimCraft T17H | actions.generator+=/shred,if=active_enemies<3

	-- SimCraft T17H | **++**++** Action.Maintain.DoTs **++**++** # What attacks to do while not pooling ComboPoints or using Finishing moves & keeping the DoTs up.
	-- SimCraft T17H | actions.maintain=rake,cycle_targets=1,if=remains<3&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	-- SimCraft T17H | actions.maintain+=/rake,cycle_targets=1,if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	-- SimCraft T17H | actions.maintain+=/moonfire_cat,cycle_targets=1,if=remains<4.2&active_enemies<=5&target.time_to_die-remains>tick_time*5
	-- SimCraft T17H | actions.maintain+=/rake,cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&active_enemies=1&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)

	{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 3", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3" } },
	{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 3", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end) } },
	
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3", "!player.buff(Predatory Swiftness)" } },
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end), "!player.buff(Predatory Swiftness)" } },
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3", "!player.buff(Bloodtalons)" } },
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end), "!player.buff(Bloodtalons)" } },
	
	{ "Thrash", { "talent(7, 2)", "player.combopoints > 4", "target.debuff(Thrash).remains < 4.5", "player.buff(Omen of Clarity)" } },
	
	{ "Moonfire", { "player.energy >= 30", "player.combopoints < 5", "player.buff(Lunar Inspiration)", "target.debuff(Moonfire).remains < 4.2", "player.area(8).enemies < 6", "target.deathin > 15" } },
	
	{ "Rake", { "!target.debuff(Rake)", "player.combopoints < 5", "player.area(8).enemies == 1" } },

	-- GENERATORS
	{ {
		-- actions.generator=swipe,if=active_enemies>=3
		{ "Swipe", "player.area(5).enemies >= 3" },
		-- actions.generator+=/shred,if=active_enemies<3
		{ "Shred", "player.area(5).enemies < 3" },
	}, "player.combopoints < 5" },

	
}, -- [Section Closing Curly Brace]
{
---- *** OUT OF COMBAT ROUTINE ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	-- Buffs
	{ "Mark of the Wild", { "!player.buffs.stats", "!modifier.last" } },

	-- Rez and Heal
	{ "Revive", { "target.exists", "target.dead", "target.player", "target.range < 40", "!player.moving" }, "target" },
	{ "Rejuvenation", { "!player.buff(Prowl)", "!player.casting", "player.alive", "!player.buff(Rejuvenation)", "player.health <= 70" }, "player" },

	-- Cleanse Debuffs
	{ "Remove Corruption", "player.dispellable(Remove Corruption)", "player" },

	-- Auto Forms
	{ {
		{ "pause", { "target.exists", "target.istheplayer" } },
		{ "/cancelform", { "target.isfriendlynpc", "!player.form == 0", "!player.ininstance", "target.range <= 2" } },
		{ "pause", { "target.isfriendlynpc", "target.range <= 2" } },
		{ "Travel Form", { "!player.buff(Travel Form)", "!target.exists", "!player.ininstance", "player.moving", "player.outdoors" } },
		{ "Cat Form", { "!player.buff(Cat Form)", "target.exists", "target.enemy", "target.range < 30" } },
	},{
		"toggle.forms", "!player.flying", "!player.buff(Dash)",
	} },
	-- SimCraft T17H | **++**++** Action.Pre-combat **++**++**
	-- SimCraft T17H | Executed before combat begins. Accepts non-harmful actions only.
	-- SimCraft T17H | actions.precombat=flask,type=greater_draenic_agility_flask
	-- SimCraft T17H | actions.precombat+=/food,type=pickled_eel
	-- SimCraft T17H | actions.precombat+=/mark_of_the_wild,if=!aura.str_agi_int.up
	-- SimCraft T17H | actions.precombat+=/healing_touch,if=talent.bloodtalons.enabled
	-- SimCraft T17H | actions.precombat+=/cat_form
	-- SimCraft T17H | actions.precombat+=/prowl
	-- SimCraft T17H | actions.precombat+=/snapshot_stats
	-- SimCraft T17H | actions.precombat+=/potion,name=draenic_agility

}, -- [Section Closing Curly Brace]

---- *** TOGGLE BUTTONS ***
function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('survival', 'Interface\\Icons\\ability_warrior_defensivestance', 'Use Survival Abilities', 'Toggle usage of various self survival abilities.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_nature_faeriefire', 'Use Mouseovers', 'Toggle usage of Moonfire/Sunfire on mouseover targets.')
	NetherMachine.toggle.create('forms', 'Interface\\Icons\\ability_druid_catform', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
end)
