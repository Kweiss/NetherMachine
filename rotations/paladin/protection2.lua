-- NetherMachine Rotation
-- Protection Paladin - WoD 6.0.3
-- Updated on Dec 1st 2014

-- PLAYER CONTROLLED: Guardian of Ancient Kings, Divine Shield
-- SUGGESTED TALENTS: Persuit of Justice, Fist of Justice, Sacred Shield, Unbreakable Spirit, Sactified Wrath, Light's Hammer, Empowered Seals
-- SUGGESTED GLYPHS: Alabaster Shield, Ardent Defender, Final Wrath,  Righteous Retreat
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(66, "bbPaladin Protection", {
-- COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- Racials
	-- { "Stoneform", "player.health <= 65" },
	-- { "Every Man for Himself", "player.state.charm" },
	-- { "Every Man for Himself", "player.state.fear" },
	-- { "Every Man for Himself", "player.state.incapacitate" },
	-- { "Every Man for Himself", "player.state.sleep" },
	-- { "Every Man for Himself", "player.state.stun" },

	{ {
		-- { "Divine Shield", "player.debuff(Gulp Frog Toxin).count > 7" }, -- Divine shield does not work!?
		{ "Blessing of Kings", { "!target.friend", "@bbLib.engaugeUnit('ANY', 30, true)" } },
	},{
		"toggle.frogs",
	} },

	-- OFF GCD
	{ "Eternal Flame", { "talent(3, 2)", "!player.buff", "player.buff(Bastion of Glory).count > 4" }, "player" },
	{ "Eternal Flame", { "talent(3, 2)", "!player.buff", "player.buff(Bastion of Glory).count > 2", "player.health < 80" }, "player" },
	{ "Word of Glory", { "player.health < 70", "player.holypower > 4", "!talent(3, 2)" }, "player" },
	{ "Word of Glory", { "player.health < 50", "player.holypower > 2", "!talent(3, 2)" }, "player" },
	{ "Shield of the Righteous", { "player.holypower > 4" } }, --"target.spell(Crusader Strike).range" --TODO: Use it to mitigate large, predictable physical damage boss attacks when 3-4 stax
	{ "Shield of the Righteous", { "player.buff(Divine Purpose)" } }, --"target.spell(Crusader Strike).range"

	-- Interrupts
	{ {
		{ "Arcane Torrent", { "target.interruptAt(50)", "target.distance < 8" } },
		{ "Avenger's Shield", "target.interrupt" },
		{ "Rebuke", "target.interruptAt(50)" }, --TODO: Interrupt at 50% cast
		{ "War Stomp", { "target.interruptAt(50)", "target.range < 8" } },
	},{ "modifier.interrupt" } },
	{ "Avenger's Shield", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },
	{ "Rebuke", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interruptAt(50)"}, "mouseover" },


	-- Survivability
	{ {
		{ "Ardent Defender", "player.health < 25" },
		{ "Lay on Hands", { "player.health < 25", "!player.buff(Ardent Defender)" } },
		{ "Holy Avenger", { "player.holypower < 3", "talent(5, 1)" } },
		{ "Divine Protection", { "player.health < 90", "target.casting.time > 0", "!player.buff(Ardent Defender)", "!player.buff(Guardian of Ancient Kings)" } },
		-- TODO: Use Survival Trinkets
	}, {
		"modifier.cooldowns",
	} },
	{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "!player.buff", "player.state.root", "player.moving" }, "player" },
	{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "!player.buff", "player.state.snare", "player.moving" }, "player" },
	{ "Sacred Shield", { "talent(3, 3)", "!player.buff" } },
	{ "#5512", { "modifier.cooldowns", "player.health < 30" } }, -- Healthstone (5512)
	{ "Cleanse", { "!modifier.last", "player.dispellable(Cleanse)" }, "player" }, -- Cleanse Poison or Disease

	-- BossMods
	{ "Reckoning", { "toggle.autotaunt", "@bbLib.bossTaunt" } }, -- TODO: Fix boss mods
	{ "Hand of Sacrifice", { "toggle.usehands", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.debuff(Assassin's Mark)" }, "mouseover" }, -- Off GCD now

	-- Raid Survivability
	--{ "Hand of Protection", { "toggle.usehands", "lowest.exists", "lowest.alive", "lowest.friend", "lowest.isPlayer", "!lowest.role(tank)", "!lowest.immune.melee", "lowest.health <= 15" }, "lowest" }, -- TODO: Don't cast on tanks.
	--{ "Hand of Sacrifice", { "tank.exists", "tank.alive", "tank.friend", "tank.range <= 40", "tank.health < 75" }, "tank" }, --TODO: Only if tank is not the player.
	--{ "Flash of Light", { "talent(3, 1)", "lowest.health < 50", "player.buff(Selfless Healer).count > 2" }, "lowest" },
	--{ "Flash of Light", { "player.health < 60", "!modifier.last" }, "player" },
	--{ "Hand of Purity", "talent(4, 1)", "player" }, -- TODO: Only if dots on player
	-- Hand of Salvation – Prevents a group/raid member from generating threat for a period of time or saves you the embarrassment of ripping aggro when offtanking. Useful for putting on healers when a group of adds spawns and is immediately drawn to them due to passive healing aggro.

	-- Mouseovers
	{{
		{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.state.root", "!mouseover.buff" }, "mouseover" },
		{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.state.snare", "!mouseover.buff", "player.moving" }, "mouseover" },
		{ "Hand of Salvation", { "toggle.usehands", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "!mouseover.role(tank)", "mouseover.highthreat(target)" }, "mouseover" },
		{ "Cleanse", { "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.dispellable(Cleanse)" }, "mouseover" },
	}, {
		"toggle.mouseovers", "player.health > 50",
	}},

	-- RANGED ROTATION
	{{
		{ "Judgment" },
		{ "Avenger's Shield" },
		{ "Light's Hammer", { "!target.moving", "!player.moving", "talent(6, 2)" }, "target.ground" },
		{ "Execution Sentence", { "talent(6, 3)", "player.health > 70" }, "target" },
	}, {
		"target.exists", "target.range > 5",
	}},





	-- COMMON / COOLDOWNS
	-- actions=/auto_attack
	-- actions+=/speed_of_light,if=movement.remains>1
	-- actions+=/blood_fury
	{ "Blood Fury", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },
	-- actions+=/berserking
	{ "Berserking", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },
	-- actions+=/arcane_torrent
	{ "Arcane Torrent", { "modifier.cooldowns", "player.focus <= 90" } },


	-- actions+=/run_action_list,name=max_dps,if=role.attack|0
	-- actions.max_dps=potion,name=draenic_armor,if=buff.holy_avenger.react|buff.bloodlust.react|target.time_to_die<=60
	-- # Max-DPS priority list starts here.
	-- # This section covers off-GCD spells.
	-- actions.max_dps+=/holy_avenger
	-- actions.max_dps+=/seraphim
	-- actions.max_dps+=/shield_of_the_righteous,if=buff.divine_purpose.react
	-- actions.max_dps+=/shield_of_the_righteous,if=(holy_power>=5|talent.holy_avenger.enabled)&(!talent.seraphim.enabled|cooldown.seraphim.remains>5)
	-- actions.max_dps+=/shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)
	-- # #GCD-bound spells start here.
	-- actions.max_dps+=/avengers_shield,if=buff.grand_crusader.react&active_enemies>1&!glyph.focused_shield.enabled
	-- actions.max_dps+=/holy_wrath,if=talent.sanctified_wrath.enabled&(buff.seraphim.react|(glyph.final_wrath.enabled&target.health.pct<=20))
	-- actions.max_dps+=/hammer_of_the_righteous,if=active_enemies>=3
	-- actions.max_dps+=/judgment,if=talent.empowered_seals.enabled&(buff.maraads_truth.down|buff.liadrins_righteousness.down)
	-- actions.max_dps+=/crusader_strike
	-- actions.max_dps+=/wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35
	-- actions.max_dps+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target
	-- actions.max_dps+=/judgment
	-- actions.max_dps+=/wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35
	-- actions.max_dps+=/avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled
	-- actions.max_dps+=/holy_wrath,if=talent.sanctified_wrath.enabled
	-- actions.max_dps+=/avengers_shield,if=buff.grand_crusader.react
	-- actions.max_dps+=/execution_sentence,if=active_enemies<3
	-- actions.max_dps+=/holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20
	-- actions.max_dps+=/avengers_shield
	-- actions.max_dps+=/seal_of_truth,if=talent.empowered_seals.enabled&!seal.truth&buff.maraads_truth.remains<cooldown.judgment.remains
	-- actions.max_dps+=/seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.maraads_truth.remains>cooldown.judgment.remains&buff.liadrins_righteousness.down
	-- actions.max_dps+=/lights_hammer
	-- actions.max_dps+=/holy_prism
	-- actions.max_dps+=/consecration,if=target.debuff.flying.down&active_enemies>=3
	-- actions.max_dps+=/execution_sentence
	-- actions.max_dps+=/hammer_of_wrath
	-- actions.max_dps+=/consecration,if=target.debuff.flying.down
	-- actions.max_dps+=/holy_wrath
	-- actions.max_dps+=/seal_of_truth,if=talent.empowered_seals.enabled&!seal.truth&buff.maraads_truth.remains<buff.liadrins_righteousness.remains
	-- actions.max_dps+=/seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.liadrins_righteousness.remains<buff.maraads_truth.remains
	-- actions.max_dps+=/sacred_shield
	-- actions.max_dps+=/flash_of_light,if=talent.selfless_healer.enabled&buff.selfless_healer.stack>=3


	-- actions+=/run_action_list,name=max_survival,if=0
	{ {
		-- # Max survival priority list starts here
		-- # This section covers off-GCD spells.
		-- actions.max_survival+=/holy_avenger
		{ "Holy Avenger", "modifier.cooldowns" },
		-- actions.max_survival+=/divine_protection,if=time<5|!talent.seraphim.enabled|(buff.seraphim.down&cooldown.seraphim.remains>5&cooldown.seraphim.remains<9)
		{ "Divine Protection", { "modifier.cooldowns", "!talent(7, 2)", "player.health < 75" } },
		{ "Divine Protection", { "modifier.cooldowns", "talent(7, 2)", "!player.buff(Seraphim)", "player.spell(Seraphim).cooldown >= 5", "player.spell(Seraphim).cooldown <= 9", "player.health < 75" } },
		-- actions.max_survival+=/seraphim,if=buff.divine_protection.down&cooldown.divine_protection.remains>0
		{ "Seraphim", { "modifier.cooldowns", "!player.buff(Divine Protection)", "player.spell(Divine Protection).cooldown > 0" } },
		-- actions.max_survival+=/guardian_of_ancient_kings,if=buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down
		{ "Guardian of Ancient Kings", { "modifier.cooldowns", "!player.buff(Holy Avenger)", "!player.buff(Shield of the Righteous)", "!player.buff(Divine Protection)", "player.health < 60" } },
		-- actions.max_survival+=/ardent_defender,if=buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down
		{ "Ardent Defender", { "modifier.cooldowns", "!player.buff(Holy Avenger)", "!player.buff(Shield of the Righteous)", "!player.buff(Divine Protection)", "!player.buff(Guardian of Ancient Kings)", "player.health < 25" } },
		-- actions.max_survival+=/eternal_flame,if=buff.eternal_flame.remains<2&buff.bastion_of_glory.react>2&(holy_power>=3|buff.divine_purpose.react|buff.bastion_of_power.react)
		{ "Eternal Flame", { "player.buff(Eternam Flame).remains < 2", "player.buff(Bastion of Glory).count > 2", "player.holypower >= 3" }, "player" },
		{ "Eternal Flame", { "player.buff(Eternam Flame).remains < 2", "player.buff(Bastion of Glory).count > 2", "player.buff(Divine Purpose)" }, "player" },
		{ "Eternal Flame", { "player.buff(Eternam Flame).remains < 2", "player.buff(Bastion of Glory).count > 2", "player.buff(Bastion of Power)" }, "player" },
		-- actions.max_survival+=/eternal_flame,if=buff.bastion_of_power.react&buff.bastion_of_glory.react>=5
		{ "Eternal Flame", { "player.buff(Bastion of Power)", "player.buff(Bastion of Glory).count >= 5" }, "player" },
		-- actions.max_survival+=/shield_of_the_righteous,if=buff.divine_purpose.react
		{ "Shield of the Righteous", "player.buff(Divine Purpose)" },
		-- actions.max_survival+=/shield_of_the_righteous,if=(holy_power>=5|incoming_damage_1500ms>=health.max*0.3)&(!talent.seraphim.enabled|cooldown.seraphim.remains>5)
		{ "Shield of the Righteous", "player.holypower >= 5" },
		{ "Shield of the Righteous", { "player.holypower >= 5", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
		-- actions.max_survival+=/shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)
		-- actions.max_survival+=/hammer_of_the_righteous,if=active_enemies>=3
		{ "Hammer of the Righteous", { "modifier.multitarget", "player.area(8).enemies >= 3" } },
		-- actions.max_survival+=/crusader_strike
		{ "Crusader Strike" },
		-- actions.max_survival+=/wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35
		{ "pause", { "player.spell(Crusader Strike).cooldown > 0", "player.spell(Crusader Strike).cooldown <= 0.35" } },
		-- actions.max_survival+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target
		-- actions.max_survival+=/judgment
		{ "Judgment" },
		-- actions.max_survival+=/wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35
		{ "pause", { "player.spell(Judgment).cooldown > 0", "player.spell(Judgment).cooldown <= 0.35" } },
		-- actions.max_survival+=/avengers_shield,if=buff.grand_crusader.react&active_enemies>1
		{ "Avenger's Shield", { "player.buff(Grand Crusader)", "player.area(8).enemies > 1" } },
		-- actions.max_survival+=/holy_wrath,if=talent.sanctified_wrath.enabled
		{ "Holy Wrath", { "talent(5, 2)", "target.distance < 6" } },
		-- actions.max_survival+=/avengers_shield,if=buff.grand_crusader.react
		{ "Avenger's Shield", "player.buff(Grand Crusader)" },
		-- actions.max_survival+=/sacred_shield,if=target.dot.sacred_shield.remains<2
		{ "Sacred Shield", "player.buff(Sacred Shield).remains < 2" },
		-- actions.max_survival+=/avengers_shield
		{ "Avenger's Shield" },
		-- actions.max_survival+=/lights_hammer
		{ "Light's Hammer", { "!target.moving", "!player.moving", "talent(6, 2)" }, "target.ground" },
		-- actions.max_survival+=/holy_prism
		{ "Holy Prism", { "talent(6, 1)", "player.health < 90" }, "player" },
		{ "Holy Prism", { "talent(6, 1)", "!toggle.limitaoe", "player.health >= 90" }, "target" },
		-- actions.max_survival+=/consecration,if=target.debuff.flying.down&active_enemies>=3
		{ "Consecration", { "modifier.multitarget", "target.distance < 6", "player.area(8).enemies >= 3" } },
		-- actions.max_survival+=/execution_sentence
		{ "Execution Sentence", { "talent(6, 3)", "player.health < 90" }, "player" },
		{ "Execution Sentence", { "talent(6, 3)", "player.health >= 90" }, "target" },
		-- actions.max_survival+=/flash_of_light,if=talent.selfless_healer.enabled&buff.selfless_healer.stack>=3
		{ "Flash of Light", { "talent(3, 1)", "player.buff(Selfless Healer).count >= 3" }, "player" },
		-- actions.max_survival+=/hammer_of_wrath
		{ "Hammer of Wrath" },
		-- actions.max_survival+=/sacred_shield,if=target.dot.sacred_shield.remains<8
		{ "Sacred Shield", "player.buff(Sacred Shield).remains < 8" },
		-- actions.max_survival+=/holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20
		{ "Holy Wrath", { "player.glyph(54935)", "target.health <= 20" } },
		-- actions.max_survival+=/consecration,if=target.debuff.flying.down&!ticking
		{ "Consecration", { "!toggle.limitaoe", "target.distance < 6" } },
		-- actions.max_survival+=/holy_wrath
		{ "Holy Wrath", { "!toggle.limitaoe", "target.distance < 6" } },
		-- actions.max_survival+=/sacred_shield
		{ "Sacred Shield" },
	},{
		"toggle.maxsurvival",
	} },


	-- actions.max_survival=potion,name=draenic_armor,if=buff.shield_of_the_righteous.down&buff.seraphim.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down&buff.ardent_defender.down

	-- # Standard survival priority list starts here
	-- # This section covers off-GCD spells.
	-- actions+=/holy_avenger
	{ "Holy Avenger", "modifier.cooldowns" },
	-- actions+=/seraphim
	{ "Seraphim", "modifier.cooldowns" },
	-- actions+=/divine_protection,if=time<5|!talent.seraphim.enabled|(buff.seraphim.down&cooldown.seraphim.remains>5&cooldown.seraphim.remains<9)
	{ "Divine Protection", { "modifier.cooldowns", "!talent(7, 2)", "player.health < 75" } },
	{ "Divine Protection", { "modifier.cooldowns", "talent(7, 2)", "!player.buff(Seraphim)", "player.spell(Seraphim).cooldown >= 5", "player.spell(Seraphim).cooldown <= 9", "player.health < 75" } },
	-- actions+=/guardian_of_ancient_kings,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down)
	{ "Guardian of Ancient Kings", { "modifier.cooldowns", "!player.buff(Holy Avenger)", "!player.buff(Shield of the Righteous)", "!player.buff(Divine Protection)", "player.health < 60" } },
	-- actions+=/ardent_defender,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down)
	{ "Ardent Defender", { "modifier.cooldowns", "!player.buff(Holy Avenger)", "!player.buff(Shield of the Righteous)", "!player.buff(Divine Protection)", "!player.buff(Guardian of Ancient Kings)", "player.health < 25" } },
	-- actions+=/eternal_flame,if=buff.eternal_flame.remains<2&buff.bastion_of_glory.react>2&(holy_power>=3|buff.divine_purpose.react|buff.bastion_of_power.react)
	{ "Eternal Flame", { "player.buff(Eternam Flame).remains < 2", "player.buff(Bastion of Glory).count > 2", "player.holypower >= 3" }, "player" },
	{ "Eternal Flame", { "player.buff(Eternam Flame).remains < 2", "player.buff(Bastion of Glory).count > 2", "player.buff(Divine Purpose)" }, "player" },
	{ "Eternal Flame", { "player.buff(Eternam Flame).remains < 2", "player.buff(Bastion of Glory).count > 2", "player.buff(Bastion of Power)" }, "player" },
	-- actions+=/eternal_flame,if=buff.bastion_of_power.react&buff.bastion_of_glory.react>=5
	{ "Eternal Flame", { "player.buff(Bastion of Power)", "player.buff(Bastion of Glory).count >= 5" }, "player" },
	-- actions+=/harsh_word,if=glyph.harsh_words.enabled&holy_power>=3
	{ "Harsh Word", { "player.glyph(54938)", "player.holypower >= 3"} },
	-- actions+=/shield_of_the_righteous,if=buff.divine_purpose.react
	{ "Shield of the Righteous", "player.buff(Divine Purpose)" },
	-- actions+=/shield_of_the_righteous,if=(holy_power>=5|incoming_damage_1500ms>=health.max*0.3)&(!talent.seraphim.enabled|cooldown.seraphim.remains>5)
	{ "Shield of the Righteous", "player.holypower >= 5" },
	{ "Shield of the Righteous", { "player.holypower >= 5", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
	-- actions+=/shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)


	-- # GCD-bound spells start here
	-- actions+=/seal_of_insight,if=talent.empowered_seals.enabled&!seal.insight&buff.uthers_insight.remains<cooldown.judgment.remains
	{ "Seal of Insight", { "talent(7, 1)", "!player.seal == 2", "!modifier.last", "@bbLib.uthersLessJudge" } },
	-- actions+=/seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.uthers_insight.remains>cooldown.judgment.remains&buff.liadrins_righteousness.down
	{ "Seal of Righteousness", { "talent(7, 1)", "!player.seal == 1", "!modifier.last", "@bbLib.uthersGreaterJudge", "!player.buff(Liadrin's Righteousness)" } },
	-- actions+=/seal_of_truth,if=talent.empowered_seals.enabled&!seal.truth&buff.uthers_insight.remains>cooldown.judgment.remains&buff.liadrins_righteousness.remains>cooldown.judgment.remains&buff.maraads_truth.down
--removed from game	{ "Seal of Truth", { "talent(7, 1)", "!player.seal == 1", "!modifier.last", "@bbLib.uthersGreaterJudge", "!player.buff(Maraad's Truth)", "@bbLib.liadrinGreaterJudge" } },
	-- actions+=/avengers_shield,if=buff.grand_crusader.react&active_enemies>1&!glyph.focused_shield.enabled
	{ "Avenger's Shield", { "player.buff(Grand Crusader)", "player.area(8).enemies > 1", "!player.glyph(54930)" } },
	-- actions+=/hammer_of_the_righteous,if=active_enemies>=3
	{ "Hammer of the Righteous", { "modifier.multitarget", "player.area(8).enemies >= 3" } },
	-- actions+=/crusader_strike
	{ "Crusader Strike" },
	-- actions+=/wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35
	{ "pause", { "player.spell(Crusader Strike).cooldown > 0", "player.spell(Crusader Strike).cooldown <= 0.35" } },
	-- actions+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target
	-- actions+=/judgment
	{ "Judgment" },
	-- actions+=/wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35
	{ "pause", { "player.spell(Judgment).cooldown > 0", "player.spell(Judgment).cooldown <= 0.35" } },
	-- actions+=/avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled
	{ "Avenger's Shield", { "player.area(8).enemies > 1", "!player.glyph(54930)" } },
	-- actions+=/holy_wrath,if=talent.sanctified_wrath.enabled
	{ "Holy Wrath", { "talent(5, 2)", "target.distance < 6" } },
	-- actions+=/avengers_shield,if=buff.grand_crusader.react
	{ "Avenger's Shield", "player.buff(Grand Crusader)" },
	-- actions+=/sacred_shield,if=target.dot.sacred_shield.remains<2
	{ "Sacred Shield", "player.buff(Sacred Shield).remains < 2" },
	-- actions+=/holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20
	{ "Holy Wrath", { "player.glyph(54935)", "target.health <= 20" } },
	-- actions+=/avengers_shield
	{ "Avenger's Shield" },
	-- actions+=/lights_hammer
	{ "Light's Hammer", { "!target.moving", "!player.moving", "talent(6, 2)" }, "target.ground" },
	-- actions+=/holy_prism
	{ "Holy Prism", { "talent(6, 1)", "player.health < 71" }, "player" },
	{ "Holy Prism", { "talent(6, 1)", "!toggle.limitaoe", "player.health > 70" }, "target" },
	-- actions+=/consecration,if=target.debuff.flying.down&active_enemies>=3
	{ "Consecration", { "modifier.multitarget", "target.distance < 6", "player.area(8).enemies >= 3" } },
	-- actions+=/execution_sentence
	{ "Execution Sentence", { "talent(6, 3)", "player.health < 71" }, "player" },
	{ "Execution Sentence", { "talent(6, 3)", "player.health > 70" }, "target" },
	-- actions+=/hammer_of_wrath
	{ "Hammer of Wrath" },
	-- actions+=/sacred_shield,if=target.dot.sacred_shield.remains<8
	{ "Sacred Shield", "player.buff(Sacred Shield).remains < 8" },
	-- actions+=/consecration,if=target.debuff.flying.down
	{ "Consecration", { "!toggle.limitaoe", "target.distance < 6" } },
	-- actions+=/holy_wrath
	{ "Holy Wrath", { "talent(5, 2)", "!toggle.limitaoe", "target.distance < 6" } },
	-- actions+=/seal_of_insight,if=talent.empowered_seals.enabled&!seal.insight&buff.uthers_insight.remains<=buff.liadrins_righteousness.remains&buff.uthers_insight.remains<=buff.maraads_truth.remains
	-- actions+=/seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.liadrins_righteousness.remains<=buff.uthers_insight.remains&buff.liadrins_righteousness.remains<=buff.maraads_truth.remains
	-- actions+=/seal_of_truth,if=talent.empowered_seals.enabled&!seal.truth&buff.maraads_truth.remains<buff.uthers_insight.remains&buff.maraads_truth.remains<buff.liadrins_righteousness.remains
	-- actions+=/sacred_shield
	{ "Sacred Shield" },
	-- actions+=/flash_of_light,if=talent.selfless_healer.enabled&buff.selfless_healer.stack>=3
	{ "Flash of Light", { "talent(3, 1)", "player.buff(Selfless Healer).count >= 3" }, "player" },


},{
-- OUT OF COMBAT ROTATION
	-- Pause
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Blessings
	{ "Blessing of Kings", { "!modifier.last", (function() return select(1,GetRaidBuffTrayAuraInfo(1)) == nil and select(1,GetRaidBuffTrayAuraInfo(8)) == nil end) } }, -- TODO: If no Monk or Druid in group.
	{ "Blessing of Might", { "!modifier.last", (function() return select(1,GetRaidBuffTrayAuraInfo(8)) == nil end), "!player.buff(Blessing of Kings)", "!player.buff(Blessing of Might)" } },

	-- Stance
	{ "Righteous Fury", { "!player.buff(Righteous Fury)", "!modifier.last" } },
	{ "Seal of Insight", { "player.seal != 2", "!modifier.last" } },


	{ {
		{ "Blessing of Kings", { "@bbLib.engaugeUnit('ANY', 30, true)" } },
		{ "Avenger's Shield", true, "target" },
		{ "Judgment", true, "target" },
		{ "Reckoning", "!target.agro", "target" },
	},{
		"toggle.frogs"
	} },


},
function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets.')
	NetherMachine.toggle.create('usehands', 'Interface\\Icons\\spell_holy_sealofprotection', 'Use Hands', 'Toggles usage of Hand spells such as Hand of Protection.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks.')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to not use AoE spells to avoid breaking CC.')
	NetherMachine.toggle.create('maxsurvival', 'Interface\\Icons\\ability_paladin_shieldofthetemplar', 'Use Max Survival Rotation', 'Toggles usage of the maximum survivability rotation.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Gulp Frog Mode', 'Automaticly target and follow Gulp Frogs.')
end)















-- NetherMachine Rotation Packager
-- NetherMachine Rotation Packager
-- Author: AkeRotations
-- Version: 2.32 26/12/2014  Reduce Holy power wastage through spells; Sacred Shield, Holy Avenger and a rework of Grand Crusader Procs. Add default Seal selection (also works with Empowered Seals).

-- Hotkeys: Left Control = Light's Hammer
--          Left Shift = Cleanse mouseover target
--			Left Alt = Pause

--Update from GUI
local fetch = NetherMachine.interface.fetchKey
local combat_rotation = {
	-- Rotation Utilities
	{ "pause", "modifier.lalt" },
	{{
		{"/targetenemy [noexists]", "!target.exists"},
		{"/targetenemy [dead]", {"target.exists", "target.dead"}},
		}, (function() return fetch('akeonProtection', 'auto_target') end)},

		-- Mouseovers
		{ "Light's Hammer", { "modifier.lcontrol" }, "mouseover.ground" },
		{ "Cleanse", { "modifier.lshift", "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.dispellable(Cleanse)" }, "mouseover" },

		-- Self Heals
		{ "Flash of Light", { "player.buff(Selfless Healer).count = 3", (function() return dynamicEval("player.health <= " .. fetch('akeonProtection', 'flashoflight_spin')) end), (function() return fetch('akeonProtection', 'flashoflight_check') end) } },
		{ "Word of Glory", { "player.holypower >= 3", (function() return dynamicEval("player.health <= " .. fetch('akeonProtection', 'wordofglory_spin')) end), (function() return fetch('akeonProtection', 'wordofglory_check') end) } },
		{ "Lay on Hands", { (function() return dynamicEval("player.health <= " .. fetch('akeonProtection', 'layonhands_spin')) end), (function() return fetch('akeonProtection', 'layonhands_check') end) } },
		{ "#5512", { (function() return dynamicEval("player.health <= " .. fetch('akeonProtection', 'healthstone_spin')) end), (function() return fetch('akeonProtection', 'healthstone_check') end) } }, -- Healthstone (5512)

		-- Survival
		{ "Eternal Flame", { "player.buff(Eternal Flame).duration < 3", (function() return fetch('akeonProtection', 'eternalglory') end) }, "player" },
		{ "Sacred Shield", { "player.buff(Sacred Shield).duration < 7", "target.range > 3", (function() return fetch('akeonProtection', 'sacredshield') end) }, "player" },
		{ "Hand of Freedom", { "!player.buff", "player.state.root", (function() return fetch('akeonProtection', 'handoffreedom') end) }, "player" },
		{ "Emancipate", { "!modifier.last(Emancipate)", "player.state.root", (function() return fetch('akeonProtection', 'emancipate') end) }, "player" },
		{ "Cleanse", { "!modifier.last(Cleanse)", "player.dispellable(Cleanse)", (function() return fetch('akeonProtection', 'cleanse') end) }, "player" },
		{ "Divine Protection", { (function() return fetch('akeonProtection', 'divprot') end), "!target.range > 3" }, "player" },

		-- Seals
		{ "Seal of Insight", { "player.seal != 2", "!talent(7, 1)", (function() return fetch("akeonProtection", "sealselect") == 'insight' end) } },
--removed from game		{ "Seal of Truth", { "player.seal != 1", "!talent(7, 1)", (function() return fetch("akeonProtection", "sealselect") == 'truth' end) } },
		{ "Seal of Righteousness", { "player.seal != 1", "!talent(7, 1)", (function() return fetch("akeonProtection", "sealselect") == 'righteousness' end) } },

		{{ --TalentRow 7 Empowered Seals (Twisting)

--removed from game		{ "Seal of Truth", { "player.seal != 1", "!player.buff(Maraad's Truth).duration > 3", "player.spell(Judgment).cooldown <= 1" } },
		{ "Seal of Righteousness", { "player.seal != 1", "!player.buff(Liadrin's Righteousness).duration > 3", "player.buff(Maraad's Truth)", "player.spell(Judgment).cooldown <= 1" } },
		{ "Seal of Insight", { "player.seal != 2", "!player.buff(Uther's Insight).duration > 3", "player.buff(Maraad's Truth)", "player.buff(Liadrin's Righteousness)", "player.spell(Judgment).cooldown <= 1" } },

		{ "Seal of Righteousness", { "player.seal != 1", "player.spell(Judgment).cooldown > 1", "modifier.multitarget" } }, -- AE Waiting
--removed from game		{ "Seal of Truth", { "player.seal != 1", "player.spell(Judgment).cooldown > 1", "!modifier.multitarget", "!toggle.smartae" } }, -- ST Waiting
		{{-- SmartAE Waiting
		-- Healing
		{ "Seal of Insight", { "player.seal != 2", "player.spell(Judgment).cooldown > 1", (function() return fetch("akeonProtection", "sealselect") == 'insight' end) } },
		{ "Seal of Righteousness", { "player.seal != 1", "player.spell(Judgment).cooldown > 1", (function() return fetch("akeonProtection", "sealselect") == 'righteousness' end) } },
--removed from game		{ "Seal of Truth", { "player.seal != 1", "player.spell(Judgment).cooldown > 1", (function() return fetch("akeonProtection", "sealselect") == 'truth' end) } }

		}, "toggle.smartae" },
		{ "Judgment", { "!player.buff(Liadrin's Righteousness).duration < 3" } },
		{ "Judgment", { "!player.buff(Maraad's Truth).duration < 3" } }
		}, "talent(7, 1)" },

		-- Interrupts
		{ "Rebuke", { "modifier.interrupt", "target.interruptAt(40)" } },

		--Cooldowns
		{{	{ "Seraphim" }, --Start TalentRow 7 Seraphim
		{ "Holy Avenger", { "player.holypower < 3", "player.buff(Seraphim)", "modifier.cooldowns" } } --TalentRow 7 Seraphim
		}, "talent(7, 2)" },  -- End TalentRow 7 Seraphim
		{ "Holy Avenger", { "player.holypower < 3", "!talent(7, 2)", "modifier.cooldowns" } },

		-- No GCD
		{ "Shield of the Righteous", { "player.holypower >= 5" } },
		{ "Shield of the Righteous", { "player.buff(Divine Purpose)" } },
		{ "Shield of the Righteous", { "player.buff(Holy Avenger)", "player.holypower >= 3", "!talent(7, 2)" } },
		{ "Shield of the Righteous", { "player.buff(Holy Avenger)", "player.holypower >= 3", "player.buff(Seraphim)" } },
		{ "Shield of the Righteous", { "player.buff(Holy Avenger)", "player.holypower >= 3", "player.spell(Seraphim).cooldown >= 5" } },

		{{  -- Raid Healing and Protection
		{ "Flash of Light", { "lowest.alive", "player.buff(Selfless Healer).count = 3", (function() return dynamicEval("lowest.health <= " .. fetch('akeonProtection', 'flashoflight_spin')) end), (function() return fetch('akeonProtection', 'flashoflight_check') end) }, "lowest" },
		{ "Lay on Hands", { "lowest.alive", (function() return dynamicEval("lowest.health <= " .. fetch('akeonProtection', 'layonhands_spin')) end), (function() return fetch('akeonProtection', 'layonhands_check') end) }, "lowest" },
		{ "Hand of Protection", { "lowest.alive", "!lowest.role(tank)", "!lowest.immune.melee", (function() return dynamicEval("lowest.health <= " .. fetch('akeonProtection', 'handoprot_spin')) end), (function() return fetch('akeonProtection', 'handoprot_check') end) }, "lowest" }
		}, (function() return fetch('akeonProtection', 'raidprotection') end) },

		{{	-- AE
		{ "Avenger's Shield", { "player.buff(Grand Crusader)" } },
		{ "Hammer of the Righteous" },
		{ "Light's Hammer", { "!target.moving", "!player.moving", "talent(6, 2)" }, "target.ground" },
		{ "Judgment", { "glyph(Double Jeopardy)", "target.exists", "target.enemy", "target.judgement" }, "target" },
		{ "Judgment", { "glyph(Double Jeopardy)", "focus.exists", "focus.enemy", "focus.judgement" }, "focus" },
		{ "Judgment" },
		{ "Holy Wrath", { "talent(5, 2)" } },
		{ "Holy Prism", nil, "player" },
		{ "Avenger's Shield", { "player.buff(Grand Crusader)" } },
		{ "Sacred Shield", { "player.buff(Sacred Shield).duration < 3", (function() return fetch('akeonProtection', 'sacredshield') end) }, "player" },
		{ "Avenger's Shield" },
		{ "Consecration", { "!player.moving" } },
		{ "Holy Wrath" }
		}, "modifier.multitarget" },

		{{	-- SmartAE
		{ "Avenger's Shield", { "player.buff(Grand Crusader)" } },
		{ "Hammer of the Righteous" },
		{ "Light's Hammer", nil, "target.ground" },
		{ "Judgment", { "glyph(Double Jeopardy)", "target.exists", "target.enemy", "target.judgement" }, "target" },
		{ "Judgment", { "glyph(Double Jeopardy)", "focus.exists", "focus.enemy", "focus.judgement" }, "focus" },
		{ "Judgment" },
		{ "Holy Wrath", { "talent(5, 2)" } },
		{ "Holy Prism", nil, "player" },
		{ "Avenger's Shield", { "player.buff(Grand Crusader)" } },
		{ "Sacred Shield", { "player.buff(Sacred Shield).duration < 3", (function() return fetch('akeonProtection', 'sacredshield') end) }, "player" },
		{ "Avenger's Shield" },
		{ "Consecration", { "!player.moving" } },
		{ "Holy Wrath" }
		}, { "toggle.smartae", "player.area(8).enemies >= 3" } },

		-- Single Target DPS Rotation
		{ "Crusader Strike" },
		{ "Judgment", { "glyph(Double Jeopardy)", "target.exists", "target.enemy", "target.judgement" }, "target" },
		{ "Judgment", { "glyph(Double Jeopardy)", "focus.exists", "focus.enemy", "focus.judgement" }, "focus" },
		{ "Judgment" },
		{ "Holy Wrath", { "talent(5, 2)" } },
		{ "Avenger's Shield", { "player.buff(Grand Crusader)" } },
		{ "Holy Prism", { "talent(5, 1)" } },
		{ "Execution Sentence", nil, "target" },
		{ "Sacred Shield", { "player.buff(Sacred Shield).duration < 3", (function() return fetch('akeonProtection', 'sacredshield') end) }, "player" },
		{ "Avenger's Shield" },
		{ "Hammer of Wrath" },
		{ "Consecration", "!player.moving" },
		{ "Holy Wrath" },
	}

	local oocRotation = {
		-- OUT OF COMBAT ROTATION
		-- Pause
		{ "pause", "modifier.lcontrol" },

		-- Seals
		{ "Seal of Insight", { "player.seal != 2", "!talent(7, 1)", (function() return fetch("akeonProtection", "sealselect") == 'insight' end) } },
--removed from game		{ "Seal of Truth", { "player.seal != 1", "!talent(7, 1)", (function() return fetch("akeonProtection", "sealselect") == 'truth' end) } },
		{ "Seal of Righteousness", { "player.seal != 1", "!talent(7, 1)", (function() return fetch("akeonProtection", "sealselect") == 'righteousness' end) } },

		-- Blessings
		{"/run setBlessing('akeonProtection')", nil, "player"},

		-- Stance
		{ "Righteous Fury", "!player.buff(Righteous Fury)" },

		-- Start Combat
		{ "Crusader Strike", "tank.combat", (function() return fetch('akeonProtection', 'startcombat') end) },
	}

	local onLoad = function()
		-- Buttons
		NetherMachine.toggle.create('smartae', 'Interface\\Icons\\spell_holy_sealofrighteousness', 'Enable Smart AE', 'Enable automatic detection of Area or Single target rotations.')

		-- GUI Show
		displayFrame(akeon_prot_config)
	end

	NetherMachine.rotation.register_custom(66, "bbPaladin Protection (ALPHA)", combat_rotation, oocRotation, onLoad)
