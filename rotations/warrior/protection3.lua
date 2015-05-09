-- NetherMachine Rotation
-- Profile Created by NetherMan
-- Custom Warrior Protection - WoD 6.1.2
-- Created on 05/08/15
-- Updated on 05/09/2015 @ 05:16
-- Version 1.0.1
-- Status: Functional - Development Stage [ Estimated Completion: ~10% ]
--[[	Notes:	Profile developed to match SimCraft T17-Heroic Action Rotation Lists & tuned for Gear ilvl = 680-690 (with Tier 17 4 set bonus)
# Gear Summary:	neck enchant=gift_of_mastery, back enchant=gift_of_mastery, finger1 enchant=gift_of_mastery, 
				finger2 enchant=gift_of_mastery, trinket1=tablet_of_turnbuckle_teamwork id=113905,
				trinket2=blast_furnace_door id=113893, main_hand=kromogs_brutal_fist id=113927 enchant=mark_of_blackrock,
				off_hand=kromogs_protecting_palm id=113926	]]

-- Suggested Talents: 1113323
-- Suggested Glyphs: Unending Rage / Heroic Leap / Cleave
-- Controls: Pause - Left Control

-- ToDo List:
--[[		1. )   Need function to detect 2/4 Tier Set Bonus Abilities
			2. )   Need to rework the GCD detection Function
]]

NetherMachine.rotation.register_custom(73, "|cff8A2BE2Nether|r|cffFF0074Machine |cffC79C6EWarrior Protection |cffff9999(SimC T17N/H) |cff336600Ver: |cff3333cc1.0.1", {
---- *** COMBAT ROUTINE SECTION ***
	-- ** Pauses **
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	{ "/stopcasting", { "boss2.exists", "player.casting", "boss2.casting(Interrupting Shout)" } }, -- boss2 Highmual Pol Interrupting Shout

	-- Stance
	{ "Defensive Stance", { "!player.buff(Defensive Stance)", "!modifier.last" } },
	
	-- ** Survival Logic **
	{	{
		{ "#5512", { "toggle.consume", "player.health < 40" } }, -- Healthstone (5512)
		{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	},	{ "toggle.survival" } },

	-- Buttons
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- ** Auto Grinding **
	{	{
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
		}, { "toggle.autogrind" } },

	-- ** Auto Target **
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- ** Interrupts **
	{	{
		{ "Disrupting Shout", { "target.exists", "target.enemy", "target.range < 10", "player.area(10).enemies > 1"  } },
		{ "Disrupting Shout", { "mouseover.exists", "mouseover.enemy", "mouseover.interruptAt(40)", "mouseover.range < 10", "player.area(10).enemies > 1" }, "mouseover" },
		{ "Pummel", { "target.exists", "target.enemy", "target.interruptAt(40)", "target.range < 5" } },
		{ "Pummel", { "mouseover.exists", "mouseover.enemy", "mouseover.interruptAt(40)", "mouseover.range <= 5" }, "mouseover" },
		-- Spell Reflection
		{ "Arcane Torrent", "target.distance < 8" }, -- Blood Elf Racial
		{ "War Stomp", "target.range < 8" }, -- Taruen Racial
		},	{ "modifier.interrupt","target.interruptAt(50)" } },

	-- ** BossMods **

	-- ** Raid Survivability **

	-- ** Mouseovers **
	{	{
		
	},	{ "toggle.mouseovers", "" } },

	-- ** Pre-DPS Pauses **
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- ** Common **
	-- # Executed every time the actor is available.
	-- actions=charge
	-- actions+=/auto_attack
	-- actions+=/call_action_list,name=prot
	
	-- ** Cooldowns **
	{	{
		-- actions.prot+=/potion,name=draenic_armor,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)|target.time_to_die<=25
		{ "#109220", { "toggle.consume", "target.boss", "player.health.max * 0.1", (function() return NetherMachine.condition["buff.remains"]('player', "Maraad's Truth") < NetherMachine.condition["spell.cooldown"]('player', "Judgment") end) } }, -- Draenic Armor Potion (109220)
		{ "#109220", { "toggle.consume", "target.boss", "player.buff(Avenging Wrath)" } }, -- Draenic Armor Potion (109220)
		{ "#109220", { "toggle.consume", "target.boss", "target.deathin <= 40" } }, -- Draenic Armor Potion (109220)
		-- actions+=/use_item,name=tablet_of_turnbuckle_teamwork,if=active_enemies=1&(buff.bloodbath.up|!talent.bloodbath.enabled)|(active_enemies>=2&buff.ravager_protection.up)
		{ "#trinket1", "player.buff(Avenging Wrath)" },
		{ "#trinket2", "player.buff(Avenging Wrath)" },
		-- actions+=/blood_fury,if=buff.bloodbath.up|buff.avatar.up
		{ "Blood Fury" },
		-- actions+=/berserking,if=buff.bloodbath.up|buff.avatar.up
		{ "Berserking" },
		-- actions+=/arcane_torrent,if=buff.bloodbath.up|buff.avatar.up
		-- actions+=/berserker_rage,if=buff.enrage.down
	},	{ "modifier.cooldowns", "target.exists", "target.enemy" } },

	-- ** "Non-Smart" Single Target Rotation <= 2 **
	{	{
	-- actions.prot=shield_block,if=!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up)
	-- actions.prot+=/shield_barrier,if=buff.shield_barrier.down&((buff.shield_block.down&action.shield_block.charges_fractional<0.75)|rage>=85)
	-- actions.prot+=/demoralizing_shout,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
	-- actions.prot+=/enraged_regeneration,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
	-- actions.prot+=/shield_wall,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
	-- actions.prot+=/last_stand,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
	
	-- actions.prot+=/stoneform,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
	-- actions.prot+=/call_action_list,name=prot_aoe,if=active_enemies>3
	-- actions.prot+=/heroic_strike,if=buff.ultimatum.up|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
	-- actions.prot+=/bloodbath,if=talent.bloodbath.enabled&((cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(cooldown.storm_bolt.remains=0&talent.storm_bolt.enabled)|talent.shockwave.enabled)
	-- actions.prot+=/avatar,if=talent.avatar.enabled&((cooldown.ravager.remains=0&talent.ravager.enabled)|(cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(talent.storm_bolt.enabled&cooldown.storm_bolt.remains=0)|(!(talent.dragon_roar.enabled|talent.ravager.enabled|talent.storm_bolt.enabled)))
	-- actions.prot+=/shield_slam
	-- actions.prot+=/revenge
	-- actions.prot+=/ravager
	-- actions.prot+=/storm_bolt
	-- actions.prot+=/dragon_roar
	-- actions.prot+=/impending_victory,if=talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
	-- actions.prot+=/victory_rush,if=!talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
	-- actions.prot+=/execute,if=buff.sudden_death.react
	-- actions.prot+=/devastate
	},	{ "!modifier.multitarget", "!toggle.smartaoe" } },

	-- ** "Smart" Single Target Rotation <= 2 **
	{	{
		
		},	{ "toggle.smartaoe", "!player.area(8)enemies >= 3" } },	
		
	-- "Non-Smart" Cleave AoE Rotation >= 3
	{	{
		-- actions.prot_aoe=bloodbath
		-- actions.prot_aoe+=/avatar
		-- actions.prot_aoe+=/thunder_clap,if=!dot.deep_wounds.ticking
		-- actions.prot_aoe+=/heroic_strike,if=buff.ultimatum.up|rage>110|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
		-- actions.prot_aoe+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
		-- actions.prot_aoe+=/shield_slam,if=buff.shield_block.up
		-- actions.prot_aoe+=/ravager,if=(buff.avatar.up|cooldown.avatar.remains>10)|!talent.avatar.enabled
		-- actions.prot_aoe+=/dragon_roar,if=(buff.bloodbath.up|cooldown.bloodbath.remains>10)|!talent.bloodbath.enabled
		-- actions.prot_aoe+=/shockwave
		-- actions.prot_aoe+=/revenge
		-- actions.prot_aoe+=/thunder_clap
		-- actions.prot_aoe+=/bladestorm
		-- actions.prot_aoe+=/shield_slam
		-- actions.prot_aoe+=/storm_bolt
		-- actions.prot_aoe+=/shield_slam
		-- actions.prot_aoe+=/execute,if=buff.sudden_death.react
		-- actions.prot_aoe+=/devastate
	},	{ "modifier.multitarget", "!toggle.smartaoe" } },
	
	-- "Smart" Cleave AoE Rotation >= 3
	{	{
		
		},	{ "toggle.smartaoe", "player.area(8)enemies >= 3" } },
		
},	{
---- *** OUT OF COMBAT ROUTINE SECTION ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buttons
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- Buffs
	{ "Battle Shout", { "!player.buffs.attackpower", "lowest.distance <= 30" }, "lowest" },
	{ "Commanding Shout", { "!player.buffs.attackpower", "!player.buffs.stamina", "lowest.distance <= 30" }, "lowest" },

	
	

	-- OOC Healing
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD

	-- Mass Resurrection
	{ "Mass Resurrection", { "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },

	-- Auto Grinding
	{	{
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Taunt" },
		}, { "toggle.autogrind" } },

}, -- [Section Closing Curly Brace]

---- *** TOGGLE BUTTONS ***
function()
	NetherMachine.toggle.create('survival', 'Interface\\Icons\\ability_warrior_defensivestance', 'Use Survival Abilities', 'Toggle usage of various self survival abilities.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('smartaoe', 'Interface\\Icons\\Ability_Racial_RocketBarrage', 'Enable Smart AoE Detection', 'Toggle the usage of smart detection of Single/AoE target roation selection abilities.')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to not use AoE spells to avoid breaking CC.')
	NetherMachine.toggle.create('autogrind', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack nearby enemies.')
end)




-- actions.precombat=flask,type=greater_draenic_stamina_flask
-- actions.precombat+=/food,type=sleeper_sushi
-- actions.precombat+=/stance,choose=defensive
-- actions.precombat+=/snapshot_stats
-- actions.precombat+=/shield_wall
-- actions.precombat+=/potion,name=draenic_armor
