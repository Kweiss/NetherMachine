-- NetherMachine Rotation
-- Profile Created by NetherMan
-- Custom Retribution Paladin - WoD 6.1.2
-- Created on April 25th 2015
-- Updated on 04/25/2015 @ 02:16
-- Version 1.0.0
-- Status: Functional & (Tested) Error Free [ Estimated Completion: ~100% ]
-- Notes: Updating Destro profile to match SimCraft T17-Heroic Action Rotation Lists

-- Suggested Talents: 2112333
-- Suggested Glyphs: Winged Vengeance / Templar's Verdict / Righteous Retreat / Fire From the Heavens / Judgment / Mass Exorcism
-- Controls: Pause - Left Control

-- ToDo List:
--[[	1. )   Need function to detect 2/4 Tier Set Bonus Abilities
		2. )   
]]


 
NetherMachine.rotation.register_custom(70, "|cff660099Nether|r|cff9482c9Machine |cfff58cbaPaladin Retribution |cffff9999(SimC T17H/M) |cff336600Ver: |cff3333cc1.0.0", {
---- *** COMBAT ROUTINE SECTION ***
	-- ** Pauses **
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	{ "/stopcasting", { "boss2.exists", "player.casting", "boss2.casting(Interrupting Shout)" } }, -- boss2 Highmual Pol Interrupting Shout
	
	-- ** Survival Logic **
	{	{
		{ "Lay on Hands", "player.health < 25" },
		{ "Divine Protection", { "player.health < 90", "target.casting.time > 0" } },
		{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "!player.buff(Hand of Freedom)", "player.state.root" }, "player" },
		{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "!player.buff(Hand of Freedom)", "player.state.snare" }, "player" },
		{ "Sacred Shield", { "talent(3, 3)", "player.health < 100", "!player.buff" } },
		{ "#5512", { "toggle.consume", "player.health < 40" } }, -- Healthstone (5512)
		{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
		{ "Cleanse", { "!modifier.last", "player.dispellable(Cleanse)" }, "player" }, -- Cleanse Poison or Disease
	},	{ "toggle.survival" } },
	
	-- ** Auto Grinding **
	{	{
		{ "Blessing of Kings", "@bbLib.engaugeUnit('ANY', 30, true)" },
		}, { "toggle.frogs" } },

	-- ** Auto Target **
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },
	
	-- ** Interrupts **
	{	{
		{ "Rebuke", "modifier.interrupt" },
		{ "Fist of Justice", "target.distance < 20", "talent(2, 1)" },
		{ "Repentance", "target.distance < 30", "talent(2, 2)" },
		{ "Blinding Light", "target.distance < 10", "talent(2, 3)" },
		{ "Arcane Torrent", "target.distance < 8" }, -- Blood Elf Racial
		{ "War Stomp", "target.range < 8" }, -- Taruen Racial
		},	{ "modifier.interrupt","target.interruptAt(50)" } },

	-- ** BossMods **
	{ "Hand of Sacrifice", { "toggle.usehands", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.role(tank)" }, "mouseover" }, -- Sac the TANK, he's about to get face smashed!
	{ "Hand of Sacrifice", { "toggle.usehands", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.debuff(Assassin's Mark)" }, "mouseover" }, -- Blackhand

	-- ** Raid Survivability **
	{ "Hand of Protection", { "toggle.usehands", "lowest.exists", "lowest.alive", "lowest.friend", "lowest.isPlayer", "!lowest.role(tank)", "!lowest.immune.melee", "lowest.health <= 15" }, "lowest" }, -- TODO: Don't cast on tanks.
	--{ "Hand of Sacrifice", { "tank.exists", "tank.alive", "tank.friend", "tank.range <= 40", "tank.health < 75" }, "tank" }, --TODO: Only if tank is not the player.
	{ "Flash of Light", { "talent(3, 1)", "lowest.health < 50", "player.buff(Selfless Healer).count > 2" }, "lowest" },
	--{ "Flash of Light", { "player.health < 60", "!modifier.last" }, "player" },
	--{ "Hand of Purity", "talent(4, 1)", "player" }, -- TODO: Only if dots on player

	-- ** Mouseovers **
	{	{
		{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.state.root", "!mouseover.buff" }, "mouseover" },
		{ "Hand of Freedom", { "toggle.usehands", "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.state.snare", "!mouseover.buff", "player.moving" }, "mouseover" },
		{ "Hand of Salvation", { "toggle.usehands", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "!mouseover.role(tank)", "mouseover.highthreat(target)" }, "mouseover" },
		{ "Cleanse", { "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.dispellable(Cleanse)" }, "mouseover" },
		},	{ "toggle.mouseovers", "player.health > 50" } },

	-- ** Pre-DPS Pauses **
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },
	
	-- ** Common **
	-- actions+=/auto_attack
	-- actions+=/speed_of_light,if=movement.distance>5
	{ "Speed of Light", { "player.moving", "target.exists", "target.distance > 5" } },
	-- actions+=/judgment,if=talent.empowered_seals.enabled&time<2
	{ "Judgment", { "talent(7, 1)", "player.time <= 3" } },
	-- actions+=/execution_sentence
	{ "Execution Sentence", "player.health > 50", "target" },
	{ "Execution Sentence", "player.health <= 50", "player" },
	-- actions+=/lights_hammer
	{ "Light's Hammer", "talent(6, 2)", "target.ground" },

	-- ** Cooldowns **
	{	{
		-- actions+=/potion,name=draenic_strength,if=(buff.bloodlust.react|buff.avenging_wrath.up|target.time_to_die<=40)
		{ "#109219", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Strength Potion
		{ "#109219", { "toggle.consume", "target.boss", "player.buff(Avenging Wrath)" } }, -- Draenic Strength Potion
		{ "#109219", { "toggle.consume", "target.boss", "target.deathin <= 40" } }, -- Draenic Strength Potion
		-- actions+=/use_item,name=vial_of_convulsive_shadows,if=buff.avenging_wrath.up
		{ "#trinket1", "player.buff(Avenging Wrath)" },
		{ "#trinket2", "player.buff(Avenging Wrath)" },
		-- actions+=/holy_avenger,sync=seraphim,if=talent.seraphim.enabled
		{ "Holy Avenger", { "talent(7, 2)", "player.buff(Seraphim)" } },
		-- actions+=/holy_avenger,if=holy_power<=2&!talent.seraphim.enabled
		{ "Holy Avenger", { "!talent(7, 2)", "player.holypower <= 2" } },
		-- actions+=/avenging_wrath,sync=seraphim,if=talent.seraphim.enabled
		{ "Avenging Wrath", { "talent(7, 2)", "player.buff(Seraphim)" } },
		-- actions+=/avenging_wrath,if=!talent.seraphim.enabled
		{ "Avenging Wrath", "!talent(7, 2)" },
		-- actions+=/blood_fury
		{ "Blood Fury" },
		-- actions+=/berserking
		{ "Berserking" },
		-- actions+=/arcane_torrent
		{ "Arcane Torrent", "player.holypower < 5" },
		-- actions+=/seraphim
		{ "Seraphim" },
		-- actions+=/wait,sec=cooldown.seraphim.remains,if=talent.seraphim.enabled&cooldown.seraphim.remains>0&cooldown.seraphim.remains<gcd.max&holy_power>=5
	},	{ "modifier.cooldowns", "target.exists", "target.enemy" } },

	-- ** "Non-Smart" Single Target Rotation < 2 **
	{	{
		-- actions.single=divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.holypower == 5", "player.buff(Final Verdict)" } },
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Holy Avenger)", "player.holypower >= 3", "player.buff(Final Verdict)" } },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.holypower == 5", "player.area(8).enemies == 2", "!talent(7, 3)" } },
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Holy Avenger)", "player.holypower >= 3", "player.area(8).enemies == 2", "!talent(7, 3)" } },
		-- actions.single+=/divine_storm,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&buff.final_verdict.up
		{ "Divine Storm", { "player.holypower == 5", "player.area(8).enemies == 2", "player.buff(Final Verdict)" } },
		{ "Divine Storm", { "player.buff(Holy Avenger)", "player.holypower >= 3", "player.area(8).enemies == 2", "player.buff(Final Verdict)" } },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(talent.seraphim.enabled&cooldown.seraphim.remains<gcd*4)
		{ "Divine Storm", { "player.buff*(Divine Crusader)","player.holypower == 5", "talent(7, 2)", "player.spell(Seraphim).cooldown < 5.5" } },
		{ "Divine Storm", { "player.buff*(Divine Crusader)","player.buff(Holy Avenger)", "player.holypower >= 3", "talent(7, 2)", "player.spell(Seraphim).cooldown < 5.5" } },
		-- actions.single+=/templars_verdict,if=(1holy_power=5|2buff.holy_avenger.up&holy_power>=3)&(3buff.avenging_wrath.down|4target.health.pct>35)&(5!talent.seraphim.enabled|6cooldown.seraphim.remains>gcd*4)
			-- actions.single+=/templars_verdict,if=holy_power=5&buff.avenging_wrath.down&!talent.seraphim.enabled
		{ "Templar's Verdict", { "player.holypower == 5", "!player.buff(Holy Avenger)", "!talent(7, 2)" } },
			-- actions.single+=/templars_verdict,if=holy_power=5&buff.avenging_wrath.down&cooldown.seraphim.remains>gcd*4
		{ "Templar's Verdict", { "player.holypower == 5", "!player.buff(Holy Avenger)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5.5" } },
			-- actions.single+=/templars_verdict,if=holy_power=5&target.health.pct>35&!talent.seraphim.enabled
		{ "Templar's Verdict", { "player.holypower == 5", "target.health > 35", "!talent(7, 2)" } },
			-- actions.single+=/templars_verdict,if=holy_power=5&target.health.pct>35&cooldown.seraphim.remains>gcd*4
		{ "Templar's Verdict", { "player.holypower == 5", "target.health > 35", "player.spell(Seraphim).cooldown > 5.5" } },
			-- actions.single+=/templars_verdict,if=buff.holy_avenger.up&holy_power>=3&buff.avenging_wrath.down&!talent.seraphim.enabled
		{ "Templar's Verdict", { "player.buff(Holy Avenger)", "player.holypower >= 3", "!player.buff(Avenging Wrath)", "!talent(7, 2)" } },
			-- actions.single+=/templars_verdict,if=buff.holy_avenger.up&holy_power>=3&buff.avenging_wrath.down&cooldown.seraphim.remains>gcd*4
		{ "Templar's Verdict", { "player.buff(Holy Avenger)", "player.holypower >= 3", "!player.buff(Avenging Wrath)", "player.spell(Seraphim).cooldown > 5.5" } },
			-- actions.single+=/templars_verdict,if=buff.holy_avenger.up&holy_power>=3&target.health.pct>35&!talent.seraphim.enabled
		{ "Templar's Verdict", { "player.buff(Holy Avenger)", "player.holypower >= 3", "target.health > 35", "!talent(7, 2)" } },
			-- actions.single+=/templars_verdict,if=buff.holy_avenger.up&holy_power>=3&target.health.pct>35&cooldown.seraphim.remains>gcd*4
		{ "Templar's Verdict", { "player.buff(Holy Avenger)", "player.holypower >= 3", "target.health > 35", "player.spell(Seraphim).cooldown > 5.5" } },
		-- actions.single+=/templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
		{ "Templar's Verdict", { "player.buff(Divine Purpose)", "player.buff(Divine Purpose).remains < 3" } },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Divine Crusader).remains < 3", "!talent(7, 3)"} },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Divine Crusader).remains < 3", "player.buff(Final Verdict)" } },
		-- actions.single+=/final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
		{ "Final Verdict", "player.holypower == 5" },
		{ "Final Verdict", { "player.buff(Holy Avenger)", "player.holypower >= 3" } },
		-- actions.single+=/final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
		{ "Final Verdict", { "player.buff(Divine Purpose)", "player.buff(Divine Purpose).remains < 3" } },
		-- actions.single+=/hammer_of_wrath
		{ "Hammer of Wrath", true, "target" },
		-- actions.single+=/judgment,if=talent.empowered_seals.enabled&seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration
		{ "Judgment", { "talent(7, 1)", "player.seal == 1", (function() return NetherMachine.condition["buff.remains"]('player', "Maraad's Truth") < NetherMachine.condition["spell.cooldown"]('player', "Judgment") end) } },
		-- actions.single+=/judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration
		{ "Judgment", { "talent(7, 1)", "player.seal == 2", (function() return NetherMachine.condition["buff.remains"]('player', "Liadrin's Righteousness") < NetherMachine.condition["spell.cooldown"]('player', "Judgment") end) } },
		-- actions.single+=/judgment,if=talent.empowered_seals.enabled&seal.righteousness&cooldown.avenging_wrath.remains<cooldown.judgment.duration
		{ "Judgment", { "talent(7, 1)", "player.seal == 2", (function() return NetherMachine.condition["spell.cooldown"]('player', "Avenging Wrath") < NetherMachine.condition["spell.cooldown"]('player', "Judgment") end) } },
		-- actions.single+=/exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
		{ "Exorcism", { "player.holypower <= 2", "player.buff(Blazing Contempt)", "!player.buff(Holy Avenger)" } },
		-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.down
		{ "Seal of Truth", { "talent(7, 1)", "!player.buff(Maraad's Truth)", "player.seal != 1" } },
		-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled&cooldown.avenging_wrath.remains<cooldown.judgment.duration&buff.liadrins_righteousness.remains>cooldown.judgment.duration
		{ "Seal of Truth", { "talent(7, 1)", (function() return NetherMachine.condition["spell.cooldown"]('player', "Avenging Wrath") < NetherMachine.condition["spell.cooldown"]('player', "Judgment") end), (function() return NetherMachine.condition["buff.remains"]('player', "Liadrin's Righteousness") > NetherMachine.condition["spell.cooldown"]('player', "Judgment") end) } },
		-- actions.single+=/seal_of_righteousness,if=talent.empowered_seals.enabled&buff.maraads_truth.remains>cooldown.judgment.duration&buff.liadrins_righteousness.down&!buff.avenging_wrath.up&!buff.bloodlust.up
		{ "Seal of Righteousness", { "talent(7, 1)", "player.seal != 2", (function() return NetherMachine.condition["buff.remains"]('player', "Maraad's Truth") > NetherMachine.condition["spell.cooldown"]('player', "Judgment") end), "!player.buff(Liadrin's Righteousness)", "!player.buff(Avenging Wrath)", "!player.hashero" } },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.single+=/divine_storm,if=active_enemies=2&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Divine Storm", { "player.area(8).enemies == 2", "player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "player.area(8).enemies == 2", "player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.single+=/final_verdict,if=buff.avenging_wrath.up|target.health.pct<35
		{ "Final Verdict", "player.buff(Avenging Wrath)" },
		{ "Final Verdict", "target.health < 35" },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&active_enemies=2&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.area(8).enemies == 2", "player.buff(Avenging Wrath)", "!talent(7, 3)" } },
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.area(8).enemies == 2", "target.health < 35", "!talent(7, 3)" } },
		-- actions.single+=/templars_verdict,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)
		{ "Templar's Verdict", { "player.holypower == 5", "player.buff(Avenging Wrath)", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower == 5", "player.buff(Avenging Wrath)", "player.spell(Seraphim).cooldown > 4.125" } },
		{ "Templar's Verdict", { "player.holypower == 5", "target.health < 35", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower == 5", "target.health < 35", "player.spell(Seraphim).cooldown > 4.125" } },
		-- actions.single+=/templars_verdict,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
		{ "Templar's Verdict", { "player.holypower == 4", "player.buff(Avenging Wrath)", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower == 4", "player.buff(Avenging Wrath)", "player.spell(Seraphim).cooldown > 5.5" } },
		{ "Templar's Verdict", { "player.holypower == 4", "target.health < 35", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower == 4", "target.health < 35", "player.spell(Seraphim).cooldown > 5.5" } },
		-- actions.single+=/templars_verdict,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
		{ "Templar's Verdict", { "player.holypower == 3", "player.buff(Avenging Wrath)", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower == 3", "player.buff(Avenging Wrath)", "player.spell(Seraphim).cooldown > 6.875" } },
		{ "Templar's Verdict", { "player.holypower == 3", "target.health < 35", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower == 3", "target.health < 35", "player.spell(Seraphim).cooldown > 6.875" } },
		-- actions.single+=/crusader_strike,if=holy_power<5&talent.seraphim.enabled
		{ "Crusader Strike", "player.holypower < 5", "talent(7, 2)" },
		-- actions.single+=/crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
		{ "Crusader Strike", "player.holypower <= 3" },
		{ "Crusader Strike", { "player.holypower == 4", "target.health >= 35", "!player.buff(Avenging Wrath)" } },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Divine Crusader)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Divine Crusader)", "target.health < 35" } },
		-- actions.single+=/judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled&holy_power<5
			-- [NOTE:] Player should control the tab-targeting, not dropping a spare "Judgment" into the profile for this SimC line.
		-- actions.single+=/exorcism,if=glyph.mass_exorcism.enabled&active_enemies>=2&holy_power<5&!glyph.double_jeopardy.enabled&!set_bonus.tier17_4pc=1
		-- ToDo	1. )   Need function to detect 2/4 Tier Set Bonus Abilities
		{ "Exorcism", { "player.holypower < 5", "player.glyph(122028)", "!player.glyph(121027)", "!player.glyph(54922)", "player.area(8).enemies >= 2" } },
		-- actions.single+=/judgment,if=holy_power<5&talent.seraphim.enabled
		{ "Judgment", { "player.holypower < 5", "talent(7, 2)" } },
		-- actions.single+=/judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
		{ "Judgment", "player.holypower <= 3" },
		{ "Judgment", { "player.holypower == 4", "player.spell(Crusader Strike).cooldown >= 2.75", "target.health > 35", "player.buff(Avenging Wrath)" } },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)" } },
		-- actions.single+=/divine_storm,if=active_enemies=2&holy_power>=4&buff.final_verdict.up
		{ "Divine Storm", { "player.area(8).enemies == 2", "player.holypower >= 4", "player.buff(Final Verdict)" } },
		-- actions.single+=/final_verdict,if=buff.divine_purpose.react
		{ "Final Verdict", "player.buff(Divine Purpose)" },
		-- actions.single+=/final_verdict,if=holy_power>=4
		{ "Final Verdict", "player.holypower >= 4" },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&active_enemies=2&holy_power>=4&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.area(8).enemies == 2", "player.holypower >= 4", "!talent(7, 3)" } },
		-- actions.single+=/templars_verdict,if=buff.divine_purpose.react
		{ "Templar's Verdict", "player.buff(Divine Purpose)" },
		-- actions.single+=/divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "!talent(7, 3)" } },
		-- actions.single+=/templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
		{ "Templar's Verdict", { "player.holypower >= 4", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower >= 4", "talent(7, 2)", "player.spell(Seraphim).cooldown > 6.875" } },
		-- actions.single+=/seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<cooldown.judgment.duration
		{ "Seal of Truth", { "talent(7, 1)", "player.seal != 1", (function() return NetherMachine.condition["buff.remains"]('player', "Maraad's Truth") < NetherMachine.condition["spell.cooldown"]('player', "Judgment") end) } },
		-- actions.single+=/seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<cooldown.judgment.duration&!buff.bloodlust.up
		{ "Seal of Righteousness", { "talent(7, 1)", "player.seal != 2", "!player.hashero", (function() return NetherMachine.condition["buff.remains"]('player', "Liadrin's Righteousness") < NetherMachine.condition["spell.cooldown"]('player', "Judgment") end) } },
		-- actions.single+=/exorcism,if=holy_power<5&talent.seraphim.enabled
		{ "Exorcism", { "player.holypower < 5", "talent(7, 2)" } },
		-- actions.single+=/exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
		{ "Exorcism", "player.holypower <= 3" },
		{ "Exorcism", { "player.holypower == 4", "player.spell(Judgment).cooldown >= 2.75", "player.spell(Crusader Strike).cooldown >= 2.75", "target.health > 35", "!player.buff(Avenging Wrath)" } },
		-- actions.single+=/divine_storm,if=active_enemies=2&holy_power>=3&buff.final_verdict.up
		{ "Divine Storm", { "player.area(8).enemies == 2", "player.holypower >= 3", "player.buff(Final Verdict)" } },
		-- actions.single+=/final_verdict,if=holy_power>=3
		{ "Final Verdict", "player.holypower >= 3" },
		-- actions.single+=/templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)
		{ "Templar's Verdict", { "player.holypower >= 3", "!talent(7, 2)" } },
		{ "Templar's Verdict", { "player.holypower >= 3", "talent(7, 2)", "player.spell(Seraphim).cooldown > 8.25" } },
		-- actions.single+=/holy_prism
		{ "Holy Prism", true, "target" },
		},	{ "!modifier.multitarget", "!toggle.smartaoe" } },

  -- "Smart" Cleave AoE Rotation >= 3
	{	{
		-- actions.cleave=final_verdict,if=buff.final_verdict.down&holy_power=5
		{ "Final Verdict", { "player.holypower == 5", "!player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.holypower == 5", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=holy_power=5&buff.final_verdict.up
		{ "Divine Storm", { "player.holypower == 5", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.holypower == 5", "!talent(7, 3)" } },
		-- actions.cleave+=/divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.holypower == 5", "!talent(7, 3)", "!talent(7, 2)" } },
		{ "Divine Storm", { "player.holypower == 5", "!talent(7, 3)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 4" } },
		-- actions.cleave+=/hammer_of_wrath
		{ "Hammer of Wrath", true, "target" },
		-- actions.cleave+=/exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
		{ "Exorcism", { "player.holypower <= 2", "player.buff(Blazing Contempt)", "!player.buff(Holy Avenger)" } },
		-- actions.cleave+=/judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
		{ "Judgment", { "talent(7, 1)", "player.seal == 2", "player.buff(Liadrin's Righteousness).remains <= 5" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.cleave+=/divine_storm,if=buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Divine Storm", { "player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.cleave+=/final_verdict,if=buff.final_verdict.down&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Final Verdict", { "!player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Final Verdict", { "!player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Divine Crusader)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Divine Crusader)", "target.health < 35" } },
		-- actions.cleave+=/divine_storm,if=(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Avenging Wrath)", "!talent(7, 2)" } },
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Avenging Wrath)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
		{ "Divine Storm", { "!talent(7, 3)", "target.health < 35", "!talent(7, 2)" } },
		{ "Divine Storm", { "!talent(7, 3)", "target.health < 35", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
		-- actions.cleave+=/hammer_of_the_righteous,if=active_enemies>=4&holy_power<5
		{ "Hammer of the Righteous", { "player.holypower < 5", "player.area(8).enemies >= 4" } },
		-- actions.cleave+=/crusader_strike,if=holy_power<5
		{ "Crusader Strike", "player.holypower < 5" },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_purpose.react&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Purpose)", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=holy_power>=4&buff.final_verdict.up
		{ "Divine Storm", { "player.holypower >= 4", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/final_verdict,if=buff.divine_purpose.react&buff.final_verdict.down
		{ "Final Verdict", { "player.buff(Divine Purpose)", "!player.buff(Final Verdict)" } },
		-- actions.cleave+=/final_verdict,if=holy_power>=4&buff.final_verdict.down
		{ "Final Verdict", { "player.holypower >= 4", "!player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "!talent(7, 3)" } },
		-- actions.cleave+=/divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.holypower >= 4", "!talent(7, 3)", "!talent(7, 2)" } },
		{ "Divine Storm", { "player.holypower >= 4", "!talent(7, 3)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
		-- actions.cleave+=/exorcism,if=glyph.mass_exorcism.enabled&holy_power<5
		{ "Exorcism", { "player.holypower < 5", "player.glyph(122028)" } },
		-- actions.cleave+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&holy_power<5
		-- actions.cleave+=/judgment,if=holy_power<5
		{ "Judgment", "player.holypower < 5" },
		-- actions.cleave+=/exorcism,if=holy_power<5
		{ "Exorcism", "player.holypower < 5" },
		-- actions.cleave+=/divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.holypower >= 3", "!talent(7, 3)", "!talent(7, 2)" } },
		{ "Divine Storm", { "player.holypower >= 3", "!talent(7, 3)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 6" } },
		-- actions.cleave+=/divine_storm,if=holy_power>=3&buff.final_verdict.up
		{ "Divine Storm", { "player.holypower >= 3", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/final_verdict,if=holy_power>=3&buff.final_verdict.down
		{ "Final Verdict", { "player.holypower >= 3", "!player.buff(Final Verdict)" } },
	},	{ "player.area(8).enemies >= 3", "toggle.smartaoe" } },
	
	  -- "Non-Smart" Cleave AoE Rotation >= 3
	{	{
		-- actions.cleave=final_verdict,if=buff.final_verdict.down&holy_power=5
		{ "Final Verdict", { "player.holypower == 5", "!player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.holypower == 5", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=holy_power=5&buff.final_verdict.up
		{ "Divine Storm", { "player.holypower == 5", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.holypower == 5", "!talent(7, 3)" } },
		-- actions.cleave+=/divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.holypower == 5", "!talent(7, 3)", "!talent(7, 2)" } },
		{ "Divine Storm", { "player.holypower == 5", "!talent(7, 3)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 4" } },
		-- actions.cleave+=/hammer_of_wrath
		{ "Hammer of Wrath", true, "target" },
		-- actions.cleave+=/exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
		{ "Exorcism", { "player.holypower <= 2", "player.buff(Blazing Contempt)", "!player.buff(Holy Avenger)" } },
		-- actions.cleave+=/judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
		{ "Judgment", { "talent(7, 1)", "player.seal == 2", "player.buff(Liadrin's Righteousness).remains <= 5" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.cleave+=/divine_storm,if=buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Divine Storm", { "player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.cleave+=/final_verdict,if=buff.final_verdict.down&(buff.avenging_wrath.up|target.health.pct<35)
		{ "Final Verdict", { "!player.buff(Final Verdict)", "player.buff(Avenging Wrath)" } },
		{ "Final Verdict", { "!player.buff(Final Verdict)", "target.health < 35" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Divine Crusader)", "player.buff(Avenging Wrath)" } },
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Divine Crusader)", "target.health < 35" } },
		-- actions.cleave+=/divine_storm,if=(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Avenging Wrath)", "!talent(7, 2)" } },
		{ "Divine Storm", { "!talent(7, 3)", "player.buff(Avenging Wrath)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
		{ "Divine Storm", { "!talent(7, 3)", "target.health < 35", "!talent(7, 2)" } },
		{ "Divine Storm", { "!talent(7, 3)", "target.health < 35", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
		-- actions.cleave+=/hammer_of_the_righteous,if=active_enemies>=4&holy_power<5
		{ "Hammer of the Righteous", { "player.holypower < 5", "player.area(8).enemies >= 4" } },
		-- actions.cleave+=/crusader_strike,if=holy_power<5
		{ "Crusader Strike", "player.holypower < 5" },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Crusader)", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_purpose.react&buff.final_verdict.up
		{ "Divine Storm", { "player.buff(Divine Purpose)", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=holy_power>=4&buff.final_verdict.up
		{ "Divine Storm", { "player.holypower >= 4", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/final_verdict,if=buff.divine_purpose.react&buff.final_verdict.down
		{ "Final Verdict", { "player.buff(Divine Purpose)", "!player.buff(Final Verdict)" } },
		-- actions.cleave+=/final_verdict,if=holy_power>=4&buff.final_verdict.down
		{ "Final Verdict", { "player.holypower >= 4", "!player.buff(Final Verdict)" } },
		-- actions.cleave+=/divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.buff(Divine Crusader)", "!talent(7, 3)" } },
		-- actions.cleave+=/divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.holypower >= 4", "!talent(7, 3)", "!talent(7, 2)" } },
		{ "Divine Storm", { "player.holypower >= 4", "!talent(7, 3)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 5" } },
		-- actions.cleave+=/exorcism,if=glyph.mass_exorcism.enabled&holy_power<5
		{ "Exorcism", { "player.holypower < 5", "player.glyph(122028)" } },
		-- actions.cleave+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&holy_power<5
		-- actions.cleave+=/judgment,if=holy_power<5
		{ "Judgment", "player.holypower < 5" },
		-- actions.cleave+=/exorcism,if=holy_power<5
		{ "Exorcism", "player.holypower < 5" },
		-- actions.cleave+=/divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)&!talent.final_verdict.enabled
		{ "Divine Storm", { "player.holypower >= 3", "!talent(7, 3)", "!talent(7, 2)" } },
		{ "Divine Storm", { "player.holypower >= 3", "!talent(7, 3)", "talent(7, 2)", "player.spell(Seraphim).cooldown > 6" } },
		-- actions.cleave+=/divine_storm,if=holy_power>=3&buff.final_verdict.up
		{ "Divine Storm", { "player.holypower >= 3", "player.buff(Final Verdict)" } },
		-- actions.cleave+=/final_verdict,if=holy_power>=3&buff.final_verdict.down
		{ "Final Verdict", { "player.holypower >= 3", "!player.buff(Final Verdict)" } },
	},	{ "modifier.multitarget", "!toggle.smartaoe" } },

},	{
---- *** OUT OF COMBAT ROUTINE SECTION ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buffs
	{ "Blessing of Kings", { "!modifier.last", "!player.buffs.stats" } }, -- TODO: If no Monk or Druid in group.
	{ "Blessing of Might", { "!modifier.last", "!player.buffs.mastery", "!player.buff(Blessing of Kings)" } },
	
	-- Seals
	{ "Seal of Truth", { "player.seal != 1", "!modifier.last" } },
	
	-- OOC Healing
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD
	
	-- Mass Resurrection
	{ "Mass Resurrection", { "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },

	-- Auto Grinding
	{	{
		{ "Blessing of Kings", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Judgment", true, "target" },
		{ "Reckoning", true, "target" },
		}, { "toggle.autogrind" } },
		
}, -- [Section Closing Curly Brace]

---- *** TOGGLE BUTTONS ***
function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('usehands', 'Interface\\Icons\\spell_holy_sealofprotection', 'Use Hands', 'Toggles usage of Hand spells such as Hand of Protection.')
	NetherMachine.toggle.create('smartaoe', 'Interface\\Icons\\Ability_Racial_RocketBarrage', 'Enable Smart AoE Detection', 'Toggle the usage of smart detection of Single/AoE target roation selection abilities.')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to not use AoE spells to avoid breaking CC.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autogrind', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack nearby enemies.')
end)
