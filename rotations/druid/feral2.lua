-- NetherMachine Rotation
-- Custom Feral Druid Rotation
-- Created on Jan 25th 2015

-- REQUIRED TALENTS: 3002002
-- REQUIRED GLYPHS: Savage Roar
-- CONTROLS:
NetherMachine.rotation.register_custom(103, "bbDruid Feral (SimC T17N)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	-- FROGING
	{ {
		{ "Mark of the Wild", "@bbLib.engaugeUnit('ANY', 40, false)" },
	}, "toggle.autoattack" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },


	-- actions=cat_form
	-- actions+=/wild_charge
		-- 5-25yd range, Fly to a nearby ally's position.
	-- actions+=/displacer_beast,if=movement.distance>10
		-- Teleports the Druid up to 20 yards forward, activates Cat Form, and increases movement speed by 50% for 4 sec.
	-- actions+=/dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
		--Activates Cat Form, removes all roots and snares, and increases movement speed by 70% while in Cat Form for 15 sec.
	-- actions+=/rake,if=buff.prowl.up|buff.shadowmeld.up
	{ "Rake", { "player.buff(Prowl)" } },
	{ "Rake", { "player.buff(Shadowmeld)" } },
	-- actions+=/auto_attack
	-- actions+=/skull_bash
	{ "Skull Bash", { "modifier.interrupt" } },
	{ "Skull Bash", { "mouseover.exists", "mouseover.enemy", "mouseover.interrupt", "mouseover.distance < 13" }, "mouseover" },
	-- actions+=/force_of_nature,if=charges=3|trinket.proc.all.react|target.time_to_die<20
	{ "Force of Nature", { "player.spell(Force of Nature).charges > 2" } },
	{ "Force of Nature", { "target.boss", "target.deathin < 20" } },
	{ "Force of Nature", { "player.trinket.any > 0" } },
	{ "Force of Nature", { "player.hashero" } },
	-- actions+=/potion,name=draenic_agility,if=target.time_to_die<=40
	{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
	{ "#109217", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
	{ "#109217", { "toggle.consume", "target.boss", "player.trinket.any > 0" } }, -- Draenic Agility Potion
	{ "#109217", { "toggle.consume", "target.boss", "target.deathin <= 40" } }, -- Draenic Agility Potion
	-- actions+=/use_item,slot=trinket1,sync=tigers_fury
	{ "#trinket1", "player.buff(Tiger's Fury)" },
	{ "#trinket2", "player.buff(Tiger's Fury)" },
	-- actions+=/,sync=tigers_fury
	{ "Blood Fury", "player.buff(Tiger's Fury)" },
	-- actions+=/berserking,sync=tigers_fury
	{ "Berserking", "player.buff(Tiger's Fury)" },
	-- actions+=/arcane_torrent,sync=tigers_fury
	{ "Arcane Torrent", "player.buff(Tiger's Fury)" },
	-- actions+=/tigers_fury,if=(!buff.omen_of_clarity.react&energy.max-energy>=60)|energy.max-energy>=80
	{ "Tiger's Fury", { "modifier.cooldowns", "!player.buff(Omen of Clarity)", "player.energy.deficit >= 60" } },
	{ "Tiger's Fury", { "modifier.cooldowns", "player.energy.deficit >= 80" } },
	-- actions+=/incarnation,if=cooldown.berserk.remains<10&energy.time_to_max>1
	{ "102543", { "modifier.cooldowns", "player.spell(Berserk).cooldown < 10", "player.timetomax > 1" } }, -- Incarnation: King of the Jungle
	-- actions+=/potion,name=draenic_agility,sync=berserk,if=target.health.pct<25
	{ "#109217", { "toggle.consume", "target.boss", "target.health < 25", "player.buff(Berserk)" } }, -- Draenic Agility Potion
	-- actions+=/berserk,if=buff.tigers_fury.up
	{ "Berserk", { "modifier.cooldowns", "player.buff(Tiger's Fury)" } },
	-- actions+=/shadowmeld,if=dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
	--TODO: &dot.rake.pmultiplier<2
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "player.buff(Bloodtalons)", "!talent(4, 2)" } },
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "!talent(7, 2)", "!talent(4, 2)" } },
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "player.buff(Bloodtalons)", "talent(4, 2)", "player.spell(102543).cooldown > 15" } },
	{ "Shadowmeld", { "target.debuff(Rake).remains < 4.5", "player.energy >= 35", "!player.buff(102543)", "!talent(7, 2)", "talent(4, 2)", "player.spell(102543).cooldown > 15" } },
	-- actions+=/ferocious_bite,cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
	{ "Ferocious Bite", { "target.debuff(Rip)", "target.debuff(Rip).remains < 3", "target.health < 25" } },
	{ "Ferocious Bite", { "mouseover.exists", "mouseover.enemy", "mouseover.alive", "mouseover.distance < 3", "mouseover.debuff(Rip)", "mouseover.debuff(Rip).remains < 3", "mouseover.health < 25" }, "mouseover" },
	-- actions+=/healing_touch,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&(combo_points>=4|buff.predatory_swiftness.remains<1.5)
	{ "Healing Touch", { "talent(7, 2)", "player.buff(Predatory Swiftness)", "player.combopoints >= 4" } },
	{ "Healing Touch", { "talent(7, 2)", "player.buff(Predatory Swiftness)", "player.buff(Predatory Swiftness).remains < 1.5" } },
	-- actions+=/savage_roar,if=buff.savage_roar.remains<3
	{ "Savage Roar", { "player.buff(Savage Roar).remains < 3" } },
	-- actions+=/thrash_cat,cycle_targets=1,if=buff.omen_of_clarity.react&remains<4.5&active_enemies>1
	{ "Thrash", { "player.buff(Omen of Clarity)", "target.debuff(Thrash).remains < 4.5", "player.area(5).enemies > 1" } },
	-- actions+=/thrash_cat,cycle_targets=1,if=!talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react
	{ "Thrash", { "!talent(7, 2)", "player.buff(Omen of Clarity)", "target.debuff(Thrash).remains < 4.5", "player.combopoints > 4" } },
	-- actions+=/pool_resource,for_next=1
	--TODO: { "pause", { "player.energy < 50", "player.spell(Thrash).cooldown < 1", "target.debuff(Thrash).remains < 4.5", "player.area(8).enemies > 1" } },
	-- actions+=/thrash_cat,cycle_targets=1,if=remains<4.5&active_enemies>1
	{ "Thrash", { "target.debuff(Thrash).remains < 4.5", "player.area(5).enemies > 1" } },

	-- FINSHERS
	{ {
		-- actions.finisher=ferocious_bite,cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
		--TODO: max_energy=1 ???
		{ "Ferocious Bite", { "target.health < 25", "target.debuff(Rip)" } },
		-- actions.finisher+=/rip,cycle_targets=1,if=remains<3&target.time_to_die-remains>18
		{ "Rip", { "target.debuff(Rip).remains < 3", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rip") > 18 end) } },
		-- actions.finisher+=/rip,cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
		--TODO: &persistent_multiplier>dot.rip.pmultiplier
		-- actions.finisher+=/savage_roar,if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
		{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.timetomax <= 1" } },
		{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.buff(Berserk)" } },
		{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.spell(Tiger's Fury).cooldown < 3" } },
		-- actions.finisher+=/ferocious_bite,max_energy=1,if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
		--TODO: max_energy=1 ?????
		{ "Ferocious Bite", { "player.energy > 50", "player.timetomax <= 1" } },
		{ "Ferocious Bite", { "player.energy > 50", "player.buff(Berserk)" } },
		{ "Ferocious Bite", { "player.energy > 50", "player.spell(Tiger's Fury).cooldown < 3" } },
	}, "player.combopoints == 5" },

	-- MAINTAIN DOTS
	-- actions.maintain=rake,cycle_targets=1,if=!talent.bloodtalons.enabled&remains<3&combo_points<5&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 3", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3" } },
	{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 3", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end) } },
	-- actions.maintain+=/rake,cycle_targets=1,if=!talent.bloodtalons.enabled&remains<4.5&combo_points<5&persistent_multiplier>dot.rake.pmultiplier&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	--TODO: persistent_multiplier>dot.rake.pmultiplier
	--{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3" } },
	--{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end) } },
	-- actions.maintain+=/rake,cycle_targets=1,if=talent.bloodtalons.enabled&remains<4.5&combo_points<5&(!buff.predatory_swiftness.up|buff.bloodtalons.up|persistent_multiplier>dot.rake.pmultiplier)&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3", "!player.buff(Predatory Swiftness)" } },
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end), "!player.buff(Predatory Swiftness)" } },
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3", "!player.buff(Bloodtalons)" } },
	{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end), "!player.buff(Bloodtalons)" } },
	--TODO: persistent_multiplier>dot.rake.pmultiplier
	--{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 3 end), "player.area(5).enemies < 3" } },
	--{ "Rake", { "talent(7, 2)", "target.debuff(Rake).remains < 4.5", "player.combopoints < 5", (function() return NetherMachine.condition["deathin"]('target') - NetherMachine.condition["debuff.remains"]('target', "Rake") > 6 end) } },
	-- actions.maintain+=/thrash_cat,cycle_targets=1,if=talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react
	{ "Thrash", { "talent(7, 2)", "player.combopoints > 4", "target.debuff(Thrash).remains < 4.5", "player.buff(Omen of Clarity)" } },
	-- actions.maintain+=/moonfire_cat,cycle_targets=1,if=combo_points<5&remains<4.2&active_enemies<6&target.time_to_die-remains>tick_time*5
	--TODO: target.time_to_die-remains>tick_time*5
	{ "Moonfire", { "player.energy >= 30", "player.combopoints < 5", "player.buff(Lunar Inspiration)", "target.debuff(Moonfire).remains < 4.2", "player.area(8).enemies < 6", "target.deathin > 15" } },
	-- actions.maintain+=/rake,cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&combo_points<5&active_enemies=1
	--TODO: persistent_multiplier>dot.rake.pmultiplier
	{ "Rake", { "!target.debuff(Rake)", "player.combopoints < 5", "player.area(8).enemies == 1" } },

	-- GENERATORS
	{ {
		-- actions.generator=swipe,if=active_enemies>=3
		{ "Swipe", "player.area(5).enemies >= 3" },
		-- actions.generator+=/shred,if=active_enemies<3
		{ "Shred", "player.area(5).enemies < 3" },
	}, "player.combopoints < 5" },

},
{
-- OUT OF COMBAT ROTATION
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buffs
	{ "Mark of the Wild", { "!player.buffs.stats", "!modifier.last" } },

	-- Rez and Heal
	{ "Revive", { "target.exists", "target.dead", "target.player", "target.range < 40", "!player.moving" }, "target" },
	{ "Rejuvenation", { "!player.buff(Prowl)", "!player.casting", "player.alive", "!player.buff(Rejuvenation)", "player.health <= 70" }, "player" },

	-- Cleanse Debuffs
	{ "Remove Corruption", "player.dispellable(Remove Corruption)", "player" },

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

	-- AUTO ATTACK
	{ {
		{ "Mark of the Wild", { "player.health > 80", "@bbLib.engaugeUnit('ANY', 30, true)" } },
		{ "Faerie Fire", true, "target" },
	}, "toggle.autoattack" },

	-- Pre-Combat
	-- actions.precombat=flask,type=greater_draenic_agility_flask
	-- actions.precombat+=/food,type=blackrock_barbecue
	-- actions.precombat+=/mark_of_the_wild,if=!aura.str_agi_int.up
	-- actions.precombat+=/healing_touch,if=talent.bloodtalons.enabled
	-- actions.precombat+=/cat_form
	-- actions.precombat+=/prowl
	-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_agility

},
-- TOGGLE BUTTONS
function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_nature_faeriefire', 'Use Mouseovers', 'Toggle usage of Moonfire/Sunfire on mouseover targets.')
	NetherMachine.toggle.create('forms', 'Interface\\Icons\\ability_druid_catform', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Engauge', 'Automaticly target and attack units in range.')
end)







-- NetherMachine Rotation
-- Custom Feral Druid Rotation
-- Created on Jan 25th 2015

-- REQUIRED TALENTS: 3002002
-- REQUIRED GLYPHS: Savage Roar
-- CONTROLS:
NetherMachine.rotation.register_custom(103, "bbDruid Feral (OLD)", {
	-- COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- DPS ROTATION
	-- actions=cat_form
	{ "Cat Form", { "!player.form = 2", "!player.flying" } },
	-- actions+=/wild_charge
	-- actions+=/displacer_beast,if=movement.distance>10
	-- actions+=/dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
	{ "Rake", { "player.buff(Prowl)" } },
	{ "Rake", { "player.buff(Shadowmeld)" } },
	-- actions+=/auto_attack
	{ "Skull Bash", { "modifier.interrupt" } },
	{ "Force of Nature", { "player.spell(Force of Nature).charges > 2" } },
	{ "Force of Nature", { "target.deathin < 20" } },
	-- actions+=/force_of_nature,if=trinket.proc.all.react
	{ "#109217", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
	{ "#109217", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "target.deathin <= 40" } }, -- Draenic Agility Potion
	-- actions+=/use_item,slot=trinket2,sync=tigers_fury
	{ "Blood Fury", { "modifier.cooldowns", "player.buff(Tiger's Fury)" } },
	{ "Berserking", { "modifier.cooldowns", "player.buff(Tiger's Fury)" } },
	{ "Arcane Torrent", { "modifier.cooldowns", "player.buff(Tiger's Fury)" } },
	{ "Tiger's Fury", { "modifier.cooldowns", "!player.buff(Omen of Clarity)", "player.energy >= 60" } },
	{ "Tiger's Fury", { "modifier.cooldowns", "player.energy >= 80" } },
	{ "Incarnation: Son of Ursoc", { "modifier.cooldowns", "player.spell(Berserk).cooldown < 10", "player.timetomax > 1" } },
	{ "#109217", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "player.buff(Berserk)", "target.health < 25" } }, -- Draenic Agility Potion
	{ "Berserk", { "modifier.cooldowns", "player.buff(Tiger's Fury)" } },
	-- actions+=/shadowmeld,if=dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
	{ "Ferocious Bite", { "target.debuff(Rip)", "target.debuff(Rip).remains < 3", "target.health < 25" } },
	{ "Healing Touch", { "talent(7, 2)", "player.buff(Predatory Swiftness)", "player.combopoints >= 4" } },
	{ "Healing Touch", { "talent(7, 2)", "player.buff(Predatory Swiftness)", "player.buff(Predatory Swiftness).remains < 1.5" } },
	{ "Savage Roar", { "player.buff(Savage Roar).remains < 3" } },
	{ "Thrash", { "player.buff(Omen of Clarity)", "target.debuff(Thrash).remains < 4.5", "player.area(8).enemies > 1" } },
	{ "Thrash", { "!talent(7, 2)", "player.buff(Omen of Clarity)", "target.debuff(Thrash).remains < 4.5", "player.combopoints > 4" } },

	-- Pool resources for Thrash
	--{ "pause", { "player.energy < 50", "player.spell(Thrash).cooldown < 1", "target.debuff(Thrash).remains < 4.5", "player.area(8).enemies > 1" } },
	{ "Thrash", { "target.debuff(Thrash).remains < 4.5", "player.area(8).enemies > 1" } },

	-- FINISHERS
	{ {
		{ "Ferocious Bite", { "target.health < 25", "target.debuff(Rip)", "player.energy > 50" } },
		{ "Rip", { "target.debuff(Rip).remains < 3", "target.deathin > 18" } },
		-- actions.finisher+=/rip,cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
		--{ "Rip", { "target.debuff(Rip).remains < 7.2", "target.deathin > 18" } },
		{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.timetomax <= 1" } },
		{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.buff(Berserk)" } },
		{ "Savage Roar", { "player.buff(Savage Roar).remains < 12.6", "player.spell(Tiger's Fury).cooldown < 3" } },
		{ "Ferocious Bite", { "player.energy > 50", "player.timetomax <= 1" } },
		{ "Ferocious Bite", { "player.energy > 50", "player.buff(Berserk)" } },
		{ "Ferocious Bite", { "player.energy > 50", "player.spell(Tiger's Fury).cooldown < 3" } },
	},{
		"player.combopoints > 4",
	} },

	-- MAINTAIN DEBUFFS
	{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 3", "player.combopoints < 5", "target.deathin > 3", "player.area(8).enemies < 3" } },
	{ "Rake", { "!talent(7, 2)", "target.debuff(Rake).remains < 3", "player.combopoints < 5", "target.deathin > 6" } },
	-- actions.maintain+=/rake,cycle_targets=1,if=!talent.bloodtalons.enabled&remains<4.5&combo_points<5&persistent_multiplier>dot.rake.pmultiplier&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	-- actions.maintain+=/rake,cycle_targets=1,if=talent.bloodtalons.enabled&remains<4.5&combo_points<5&(!buff.predatory_swiftness.up|buff.bloodtalons.up|persistent_multiplier>dot.rake.pmultiplier)&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	{ "Thrash", { "talent(7, 2)", "player.combopoints > 4", "target.debuff(Thrash).remains < 4.5", "player.buff(Omen of Clarity)" } },
	{ "Moonfire", { "player.combopoints < 5", "player.buff(Lunar Inspiration)", "target.debuff(Moonfire).remains < 4.2", "player.area(8).enemies < 6", "target.deathin > 10" } },
	-- actions.maintain+=/rake,cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&combo_points<5&active_enemies=1

	-- GENERATORS
	{ {
		{ "Swipe", "player.area(8).enemies >= 3" },
		{ "Shred", "player.area(8).enemies < 3" },
	},{
	"player.combopoints < 5",
	} },

},
{
	-- OUT OF COMBAT ROTATION
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buffs
	{ "Mark of the Wild", "!player.buffs.stats" },

	-- Rez and Heal
	{ "Revive", { "target.exists", "target.dead", "target.player", "target.range < 40", "!player.moving" }, "target" },
	{ "Rejuvenation", { "!player.buff(Prowl)", "!player.casting", "player.alive", "!player.buff(Rejuvenation)", "player.health <= 70" }, "player" },

	-- Cleanse Debuffs
	{ "Remove Corruption", "player.dispellable(Remove Corruption)", "player" },

	-- AUTO FORMS
	{ {
		{ "pause", { "target.exists", "target.istheplayer" } },
		{ "/cancelform", { "target.isfriendlynpc", "!player.form = 0", "!player.ininstance", "target.range <= 2" } },
		{ "pause", { "target.isfriendlynpc", "target.range <= 2" } },
		{ "Travel Form", { "!player.form = 3", "!target.exists", "!player.ininstance", "player.moving", "player.outdoors" } },
		{ "Cat Form", { "!player.form = 2", "target.exists", "target.enemy", "target.range < 30" } },
	},{
		"toggle.forms", "!player.flying", "!player.buff(Dash)",
	} },

	-- FROGGING
	{ {
		{ "Mark of the Wild", { "player.health > 80", "@bbLib.engaugeUnit('ANY', 30, true)" } },
		{ "Faerie Fire", true, "target" },
	},{
		"toggle.frogs",
	} },

	-- Pre-Combat
	-- actions.precombat=flask,type=greater_draenic_agility_flask
	-- actions.precombat+=/food,type=blackrock_barbecue
	-- actions.precombat+=/mark_of_the_wild,if=!aura.str_agi_int.up
	-- actions.precombat+=/healing_touch,if=talent.bloodtalons.enabled
	-- actions.precombat+=/cat_form
	-- actions.precombat+=/prowl
	-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_agility

},function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_nature_faeriefire', 'Use Mouseovers', 'Toggle usage of Moonfire/Sunfire on mouseover targets.')
	NetherMachine.toggle.create('forms', 'Interface\\Icons\\ability_druid_catform', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Engauge', 'Automaticly target and attack units in range.')
end)
