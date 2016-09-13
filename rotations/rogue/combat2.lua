-- NetherMachine Rotation Packager
-- Custom Combat Rogue Rotation
-- Created on Dec 25th 2013 1:00 am
NetherMachine.rotation.register_custom(260, "bbRogue Combat", {
-- PLAYER CONTROLLED:
-- SUGGESTED TALENTS: 3000031
-- SUGGESTED GLYPHS: energy, disappearance
-- CONTROLS: Pause - Left Control

-- COMBAT
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "player.buff(Food)" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists", "!target.friend" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead", "!target.friend" } },

	-- AMBUSH
	{ "Ambush", { "target.enemy", "target.range < 1" } }, -- , "target.behind"

	-- INTERRUPT
	{ "Kick", "modifier.interrupt" },

	-- POISONS
	{ "Deadly Poison", { "!player.moving", "!player.buff(Deadly Poison)", "!player.buff(Instant Poison)" } },
	{ "Crippling Poison", { "!player.moving", "!player.buff(Crippling Poison)" } },

	-- DEFENSIVE COOLDOWNS
	{ "Evasion", { "!player.buff(Combat Readiness)", "player.health < 100", "target.agro", "target.range < 1" } },
	{ "Combat Readiness", { "!player.buff(Evasion)", "talent(2, 3)", "player.health < 100", "target.agro", "target.range < 1" } },
	{ "Feint", { "!player.buff(Feint)", "player.health < 100", "target.agro" } },
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	{ "#118916", { "toggle.consume", "player.health < 40", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Healing Tonic
	{ "Sprint", "player.movingfor > 2" },
	{ "Recuperate", { "player.health < 50", "!player.buff(Recuperate)" } },

	-- AOE
	{ "Blade Flurry", { "modifier.multitarget", "!player.buff(Blade Flurry)", "player.area(10).enemies > 1" } },
	{ "/cancelaura Blade Flurry", { "modifier.multitarget", "player.buff(Blade Flurry)", "player.area(10).enemies < 2" } },

	-- OFFENSIVE COOLDOWNS
	{ {
		{ "Preparation", { "!player.buff(Vanish)", "player.spell(Vanish).cooldown > 60" } },
		-- actions+=/use_item,name=beating_heart_of_the_mountain
		{ "#trinket1" },
		{ "#trinket2" },
		-- actions+=/arcane_torrent,if=focus.deficit>=30
		{ "Arcane Torrent", "player.energy.deficit >= 50" },
		-- actions+=/blood_fury
		{ "Blood Fury" },
		-- actions+=/berserking
		{ "Berserking" },
		-- Blade Flurry
		{ "Shadow Reflection", { "talent(7, 2)", "player.combopoints > 3", "player.spell(Killing Spree).cooldown < 10" } },
		{ "Shadow Reflection", { "talent(7, 2)", "player.buff(Adrenaline Rush)" } },
		-- Agi Pot
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "target.health <= 20" } },
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
		-- Ambush
		{ {
			{ "Vanish", { "player.combopoints < 3", "talent(1, 3)", "!player.buff(Adrenaline Rush)", "player.energy < 20" } },
			{ "Vanish", { "player.combopoints < 3", "talent(1, 2)", "player.energy > 90" } },
			{ "Vanish", { "player.combopoints < 3", "!talent(1, 3)", "!talent(1, 2)", "player.energy > 60" } },
			{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 3", "talent(1, 3)", "!player.buff(Adrenaline Rush)", "player.energy < 20" } },
			{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 3", "talent(1, 2)", "player.energy > 90" } },
			{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 3", "!talent(1, 3)", "!talent(1, 2)", "player.energy > 60" } },
			{ "Vanish", { "player.combopoints < 4", "talent(6, 3)", "player.buff(Anticipation).count < 4", "talent(1, 3)", "!player.buff(Adrenaline Rush)", "player.energy < 20" } },
			{ "Vanish", { "player.combopoints < 4", "talent(6, 3)", "player.buff(Anticipation).count < 4", "talent(1, 2)", "player.energy > 90" } },
			{ "Vanish", { "player.combopoints < 4", "talent(6, 3)", "player.buff(Anticipation).count < 4", "!talent(1, 3)", "!talent(1, 2)", "player.energy > 60" } },
		},{
			"player.time > 10", "!player.buff(Stealth)", "target.boss",
		} },

		{ "Killing Spree", { "player.energy < 50", "!talent(7, 2)" } },
		{ "Killing Spree", { "player.energy < 50", "talent(7, 2)", "player.spell(Shadow Reflection).cooldown > 30" } },
		{ "Killing Spree", { "player.energy < 50", "talent(7, 2)", "player.buff(Shadow Reflection).duration > 3" } },
		{ "Adrenaline Rush", "player.energy < 35" },

	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },

	-- DPS ROTATION
	{ "Slice and Dice", "player.buff(Slice and Dice).duration < 2" },
	{ "Slice and Dice", { "player.combopoints > 3", "player.buff(Slice and Dice).duration < 15", "player.buff(Bandit's Guile).count > 10" } },

	{ "Marked for Death", { "player.combopoints < 2", "target.debuff(Revealing Strike)", "!talent(7, 2)" } },
	{ "Marked for Death", { "player.combopoints < 2", "target.debuff(Revealing Strike)", "player.buff(Shadow Reflection)" } },
	{ "Marked for Death", { "player.combopoints < 2", "target.debuff(Revealing Strike)", "player.spell(Shadow Reflection).cooldown > 30" } },

	{ "Revealing Strike", { "player.combopoints < 5", "target.debuff(Revealing Strike).duration < 2", "player.spell(Revealing Strike).range" } },
	{ "Revealing Strike", { "talent(6, 3)", "target.debuff(Revealing Strike).duration < 2", "player.buff(Anticipation).count < 5", "!player.buff(Deep Insight)", "player.spell(Revealing Strike).range" } },

	{ "Sinister Strike", { "player.combopoints < 5", "player.spell(Sinister Strike).range" } },
	{ "Sinister Strike", { "talent(6, 3)", "player.buff(Anticipation).count < 5", "!player.buff(Deep Insight)", "player.spell(Sinister Strike).range" } },

	{ {
		{ "Crimson Tempest", { "target.debuff(Crimson Tempest).duration <= 1", "player.buff(Deep Insight)", "player.area(10).enemies > 5" } },
		{ "Crimson Tempest", { "target.debuff(Crimson Tempest).duration <= 1", "!talent(6, 3)", "player.area(10).enemies > 5" } },
		{ "Crimson Tempest", { "target.debuff(Crimson Tempest).duration <= 1", "talent(6, 3)", "player.buff(Anticipation).count > 3", "player.area(10).enemies > 5" } },

		{ "Eviscerate", { "player.buff(Deep Insight)", "player.spell(Eviscerate).range" } },
		{ "Eviscerate", { "!talent(6, 3)", "player.spell(Eviscerate).range" } },
		{ "Eviscerate", { "talent(6, 3)", "player.buff(Anticipation).count > 3", "player.spell(Eviscerate).range" } },
	},{
		"player.combopoints > 4",
	} },

},{
-- OUT OF COMBAT
	-- PAUSE / UTILITIES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "player.buff(Food)" },

	-- POISONS
	{ "Deadly Poison", { "!player.moving", "!player.buff(Deadly Poison)", "!player.buff(Instant Poison)" } },
	{ "Crippling Poison", { "!player.moving", "!player.buff(Crippling Poison)" } },

	-- STEALTH
	{ "Stealth", "!player.buff(Stealth)" },

	-- AMBUSH OOC
	{ "Ambush", { "target.enemy", "target.range < 1" }, "target" },

},
function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
end)




-- NetherMachine Rotation
-- Combat Rogue - WoD 6.1
-- Updated on April 14th 2015

-- SUGGESTED TALENTS:
-- SUGGESTED GLYPHS:
-- CONTROLS: Pause - Left Control

local killing_spree = {
	-- actions.killing_spree=killing_spree,if=target.time_to_die>=44
	{ "Killing Spree", { "target.deathin >= 44" } },
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<44&buff.archmages_greater_incandescence_agi.react&buff.archmages_greater_incandescence_agi.remains>=buff.killing_spree.duration
	{ "Killing Spree", { "target.boss", "target.deathin < 44", "player.buff(Archmage's Greater Incandescence).remains >= 3" } },
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<44&trinket.proc.any.react&trinket.proc.any.remains>=buff.killing_spree.duration
	{ "Killing Spree", { "target.boss", "target.deathin < 44", "player.buff(Archmage's Greater Incandescence).remains >= 3" } },
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<44&trinket.stacking_proc.any.react&trinket.stacking_proc.any.remains>=buff.killing_spree.duration
	{ "Killing Spree", { "target.boss", "target.deathin < 44", "player.buff(Meaty Dragonspine Trophy).remains >= 3" } },
	{ "Killing Spree", { "target.boss", "target.deathin < 44", "player.buff(Lub-Dub).remains >= 3" } },
	{ "Killing Spree", { "target.boss", "target.deathin < 44", "player.buff(Balanced Fate).remains >= 3" } },
	-- actions.killing_spree+=/killing_spree,if=target.time_to_die<=buff.killing_spree.duration*1.5
	{ "Killing Spree", { "target.boss", "target.deathin <= 5" } },
}

local generator = {
	-- actions.generator=revealing_strike,if=(combo_points=4&dot.revealing_strike.remains<7.2&(target.time_to_die>dot.revealing_strike.remains+7.2)|(target.time_to_die<dot.revealing_strike.remains+7.2&ticks_remain<2))|!ticking
	{ "Revealing Strike", { "!target.debuff(Revealing Strike)" } },
	{ "Revealing Strike", { "player.combopoints = 4", "target.debuff(Revealing Strike).remains < 7.2", (function() return NetherMachine.condition["deathin"]('target') > (NetherMachine.condition["debuff.remains"]('target', "Revealing Strike")+7.2) end) } },
	--{ "Revealing Strike", { "player.combopoints = 4", "target.debuff(Revealing Strike).remains < 7.2", (function() return NetherMachine.condition["deathin"]('target') < (NetherMachine.condition["debuff.remains"]('target', "Revealing Strike")+7.2) end) } },
	-- actions.generator+=/sinister_strike,if=dot.revealing_strike.ticking
	{ "Sinister Strike", { "target.debuff(Revealing Strike)" } },
}

local finisher = {
	-- actions.finisher=death_from_above
	{ "Death from Above" },
	-- actions.finisher+=/eviscerate,if=(!talent.death_from_above.enabled|cooldown.death_from_above.remains)
	{ "Eviscerate", { "!talent(7, 3)" } },
	{ "Eviscerate", { "talent(7, 3)", "player.spell(Death from Above).cooldown > 1.5" } },
}

NetherMachine.rotation.register_custom(260, "bbRogue Combat (SimC)", {
	-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	-- FROGING
	{ {
		{ "Crippling Poison", "@bbLib.engaugeUnit('ANY', 30, true)" },
	}, "toggle.autoattack" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- INTERRUPTS / DISPELLS
	{ "Kick", "target.interrupt" },
	{ "Kick", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },

	-- POISONS
	{ "Deadly Poison", { "!player.moving", "!player.buff(Deadly Poison)", "!player.buff(Instant Poison)" } },
	{ "Crippling Poison", { "!player.moving", "!player.buff(Crippling Poison)" } },

	-- DEFENSIVE COOLDOWNS
	{ "Evasion", { "!player.buff(Combat Readiness)", "player.health < 100", "target.agro", "target.range < 1" } },
	{ "Combat Readiness", { "!player.buff(Evasion)", "talent(2, 3)", "player.health < 100", "target.agro", "target.range < 1" } },
	{ "Feint", { "!player.buff(Feint)", "player.health < 100", "target.agro" } },
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	{ "#118916", { "toggle.consume", "player.health < 40", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Healing Tonic
	{ "Sprint", "player.movingfor > 2" },
	{ "Recuperate", { "player.health < 50", "!player.buff(Recuperate)" } },

	-- Pre-DPS PAUSE
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.debuff(Freezing Trap).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- OFFENSIVE COOLDOWNS
	{ {
		-- actions=potion,name=draenic_agility,if=buff.bloodlust.react|target.time_to_die<40|(buff.adrenaline_rush.up&(trinket.proc.any.react|trinket.stacking_proc.any.react|buff.archmages_greater_incandescence_agi.react))
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "target.health <= 20" } },
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
		-- actions+=/preparation,if=!buff.vanish.up&cooldown.vanish.remains>30
		{ "Preparation", { "!player.buff(Vanish)", "player.spell(Vanish).cooldown > 30" } },
		-- actions+=/use_item,slot=trinket2
		{ "#trinket1" },
		{ "#trinket2" },
		-- actions+=/blood_fury
		{ "Blood Fury" },
		-- actions+=/berserking
		{ "Berserking" },
		-- actions+=/arcane_torrent,if=energy<60
		{ "Arcane Torrent", "player.energy < 60" },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },

	-- DPS ROTATION
	-- actions+=/blade_flurry,if=(active_enemies>=2&!buff.blade_flurry.up)|(active_enemies<2&buff.blade_flurry.up)
	{ "Blade Flurry", { "modifier.multitarget", "!player.buff(Blade Flurry)", "player.area(5).enemies >= 2", "!modifier.last" } },
	{ "/cancelaura Blade Flurry", { "modifier.multitarget", "player.buff(Blade Flurry)", "player.area(5).enemies < 2" } },
	-- actions+=/shadow_reflection,if=(cooldown.killing_spree.remains<10&combo_points>3)|buff.adrenaline_rush.up
	{ "Shadow Reflection", { "player.combopoints > 3", "player.spell(Killing Spree).cooldown < 10" } },
	{ "Shadow Reflection", { "player.buff(Adrenaline Rush)" } },
	-- actions+=/ambush
	{ "Ambush" },
	-- actions+=/vanish,if=time>10&(combo_points<3|(talent.anticipation.enabled&anticipation_charges<3)|(combo_points<4|(talent.anticipation.enabled&anticipation_charges<4)))&((talent.shadow_focus.enabled&buff.adrenaline_rush.down&energy<90&energy>=15)|(talent.subterfuge.enabled&energy>=90)|(!talent.shadow_focus.enabled&!talent.subterfuge.enabled&energy>=60))
	{ {
		{ "Vanish", { "player.combopoints < 3", "talent(1, 3)", "!player.buff(Adrenaline Rush)", "player.energy < 90", "player.energy >= 15" } },
		{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 3", "talent(1, 3)", "!player.buff(Adrenaline Rush)", "player.energy < 90", "player.energy >= 15" } },
		{ "Vanish", { "player.combopoints < 4", "talent(1, 3)", "!player.buff(Adrenaline Rush)", "player.energy < 90", "player.energy >= 15" } },
		{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 4", "talent(1, 3)", "!player.buff(Adrenaline Rush)", "player.energy < 90", "player.energy >= 15" } },
		{ "Vanish", { "player.combopoints < 3", "talent(1, 2)", "player.energy > 90" } },
		{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 3", "talent(1, 2)", "player.energy > 90" } },
		{ "Vanish", { "player.combopoints < 4", "talent(1, 2)", "player.energy > 90" } },
		{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 4", "talent(1, 2)", "player.energy > 90" } },
		{ "Vanish", { "player.combopoints < 3", "!talent(1, 3)", "!talent(1, 2)", "player.energy >= 60" } },
		{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 3", "!talent(1, 3)", "!talent(1, 2)", "player.energy >= 60" } },
		{ "Vanish", { "player.combopoints < 4", "!talent(1, 3)", "!talent(1, 2)", "player.energy >= 60" } },
		{ "Vanish", { "talent(6, 3)", "player.buff(Anticipation).count < 4", "!talent(1, 3)", "!talent(1, 2)", "player.energy >= 60" } },
	},{
		"player.time > 10", "!player.buff(Stealth)", "target.boss",
	} },
	-- actions+=/slice_and_dice,if=buff.slice_and_dice.remains<2|((target.time_to_die>45&combo_points=5&buff.slice_and_dice.remains<12)&buff.deep_insight.down)
	{ "Slice and Dice", "player.buff(Slice and Dice).remains < 2" },
	{ "Slice and Dice", { "target.deathin > 45", "player.combopoints == 5", "player.buff(Slice and Dice).remains < 12", "!player.buff(Deep Insight)" } },
	-- actions+=/call_action_list,name=adrenaline_rush,if=cooldown.killing_spree.remains>10
	{ {
		-- actions.adrenaline_rush=adrenaline_rush,if=target.time_to_die>=44
		{ "Adrenaline Rush", "target.deathin >= 44" },
		-- actions.adrenaline_rush+=/adrenaline_rush,if=target.time_to_die<44&(buff.archmages_greater_incandescence_agi.react|trinket.proc.any.react|trinket.stacking_proc.any.react)
		{ "Adrenaline Rush", { "target.deathin < 44", "player.buff(Meaty Dragonspine Trophy)" } },
		{ "Adrenaline Rush", { "target.deathin < 44", "player.buff(Lub-Dub)" } },
		{ "Adrenaline Rush", { "target.deathin < 44", "player.buff(Archmage's Greater Incandescence)" } },
		{ "Adrenaline Rush", { "target.deathin < 44", "player.buff(Balanced Fate)" } },
		-- actions.adrenaline_rush+=/adrenaline_rush,if=target.time_to_die<=buff.adrenaline_rush.duration*1.5
		{ "Adrenaline Rush", { "target.deathin <= 22.5" } },
	},{
		"player.spell(Killing Spree).cooldown > 10"
	} },
	-- actions+=/call_action_list,name=killing_spree,if=buff.adrenaline_rush.down&(energy<40|(buff.bloodlust.up&time<10)|buff.bloodlust.remains>20)&(!talent.shadow_reflection.enabled|cooldown.shadow_reflection.remains>30|buff.shadow_reflection.remains>3)
	-- TODO: Not On Gruul when casting Overhead Smash
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.energy < 40", "!talent(7, 2)" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.hashero", "player.time < 10", "!talent(7, 2)" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.hashero.remains > 20", "!talent(7, 2)" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.energy < 40", "talent(7, 2)", "player.spell(Shadow Reflection).cooldown > 30" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.hashero", "player.time < 10", "talent(7, 2)", "player.spell(Shadow Reflection).cooldown > 30" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.hashero.remains > 20", "talent(7, 2)", "player.spell(Shadow Reflection).cooldown > 30" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.energy < 40", "talent(7, 2)", "player.buff(Shadow Reflection).remains > 3" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.hashero", "player.time < 10", "talent(7, 2)", "player.buff(Shadow Reflection).remains > 3" } },
	{ killing_spree, { "!player.buff(Adrenaline Rush)", "player.hashero.remains > 20", "talent(7, 2)", "player.buff(Shadow Reflection).remains > 3" } },
	-- actions+=/marked_for_death,if=combo_points<=1&dot.revealing_strike.ticking&(!talent.shadow_reflection.enabled|buff.shadow_reflection.up|cooldown.shadow_reflection.remains>30)
	{ "Marked for Death", { "player.combopoints <= 1", "target.debuff(Revealing Strike)", "!talent(7, 2)" } },
	{ "Marked for Death", { "player.combopoints <= 1", "target.debuff(Revealing Strike)", "talent(7, 2)", "player.buff(Shadow Reflection)" } },
	{ "Marked for Death", { "player.combopoints <= 1", "target.debuff(Revealing Strike)", "talent(7, 2)", "player.spell(Shadow Reflection).cooldown > 30" } },
	-- actions+=/call_action_list,name=generator,if=combo_points<5|!dot.revealing_strike.ticking|(talent.anticipation.enabled&anticipation_charges<3&buff.deep_insight.down)
	{ generator, { "player.combopoints < 5" } },
	{ generator, { "!target.debuff(Revealing Strike)" } },
	{ generator, { "talent(6, 3)", "player.buff(Anticipation).count < 3", "!player.buff(Deep Insight)" } },
	-- actions+=/call_action_list,name=finisher,if=combo_points=5&dot.revealing_strike.ticking&(buff.deep_insight.up|!talent.anticipation.enabled|(talent.anticipation.enabled&anticipation_charges>=3))
	{ finisher, { "player.combopoints == 5", "target.debuff(Revealing Strike)", "player.buff(Deep Insight)" } },
	{ finisher, { "player.combopoints == 5", "target.debuff(Revealing Strike)", "!talent(6, 3)" } },
	{ finisher, { "player.combopoints == 5", "target.debuff(Revealing Strike)", "talent(6, 3)", "player.buff(Anticipation).count >= 3" } },

},{
	-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- OOC HEALING
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD

	-- POISONS
	{ "Deadly Poison", { "!player.moving", "!player.buff(Deadly Poison)", "!player.buff(Instant Poison)" } },
	{ "Crippling Poison", { "!player.moving", "!player.buff(Crippling Poison)" } },

	-- STEALTH
	{ "Stealth", "!player.buff(Stealth)" },

	-- AMBUSH OOC
	{ "Ambush", { "target.enemy", "target.range < 1" }, "target" },

	-- FROGING
	{ {
		{ "Crippling Poison", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Throw", { "target.exists", "target.enemy", "target.alive" } },
	}, "toggle.autoattack" },

	-- actions.precombat=flask,type=greater_draenic_agility_flask
	-- actions.precombat+=/food,type=buttered_sturgeon
	-- actions.precombat+=/apply_poison,lethal=deadly
	-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_agility
	-- actions.precombat+=/stealth
	-- actions.precombat+=/marked_for_death
	-- actions.precombat+=/slice_and_dice,if=talent.marked_for_death.enabled

},function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_hunter_quickshot', 'Use Mouseovers', 'Toggle automatic usage of stings/scatter/etc on eligible mouseover targets.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack any anemies in range of the player.')
	NetherMachine.toggle.create('cleave', 'Interface\\Icons\\inv_misc_fish_33', 'Allow Cleave', 'Use abilities that could break nearby CC.')
end)
