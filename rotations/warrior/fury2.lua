-- NetherMachine Rotation
-- Fury Warrior - WoD 6.1
-- Updated on March 23rd 2015

-- PLAYER CONTROLLED:
-- SUGGESTED TALENTS: 1321321  AOE: 1323332
	-- talent_override=bladestorm,if=raid_event.adds.count>=1|enemies>1
	-- talent_override=dragon_roar,if=raid_event.adds.count>=1|enemies>1
	-- talent_override=ravager,if=raid_event.adds.cooldown>=60&raid_event.adds.exists
-- SUGGESTED GLYPHS: unending_rage/raging_wind/heroic_leap
-- CONTROLS: Pause - Left Control

local bladestorm = {
	-- TODO: need raid_events code
	-- actions.bladestorm=recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)
	{ "Recklessness", { "toggle.bladestorm", "player.buff(Enrage).remains > 6", "player.buff(Bladestorm)" } },
	{ "Recklessness", { "toggle.bladestorm", "player.buff(Enrage).remains > 6", "player.spell(Bladestorm).cooldown <= 1.5" } },
	-- actions.bladestorm+=/bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)
	{ "Bladestorm", { "toggle.bladestorm", "player.buff(Enrage).remains > 6" } },
}

local movement = {
	-- actions.movement=heroic_leap
	-- actions.movement+=/charge,cycle_targets=1,if=debuff.charge.down
	-- # If possible, charge a target that will give rage. Otherwise, just charge to get back in range.
	-- actions.movement+=/charge
	-- # May as well throw storm bolt if we can.
	-- actions.movement+=/storm_bolt
	{ "Storm Bolt" },
	-- actions.movement+=/heroic_throw
	{ "Heroic Throw" },
}

local single_target = {
	-- actions.single_target=bloodbath
	{ "Bloodbath" },
	-- actions.single_target+=/recklessness,if=target.health.pct<20&raid_event.adds.exists
	{ "Recklessness", { "modifier.cooldowns", "target.health < 20", "toggle.adds" } },
	-- actions.single_target+=/wild_strike,if=(rage>rage.max-20)&target.health.pct>20
	{ "Wild Strike", { "player.rage.deficit < 20", "target.health > 20" } },
	-- actions.single_target+=/bloodthirst,if=(!talent.unquenchable_thirst.enabled&(rage<rage.max-40))|buff.enrage.down|buff.raging_blow.stack<2
	{ "Bloodthirst", { "!talent(3, 3)", "player.rage.deficit > 40" } },
	{ "Bloodthirst", "!player.buff(Enrage)" },
	{ "Bloodthirst", "player.buff(Raging Blow!).count < 2" },
	-- actions.single_target+=/ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.in>60|target.time_to_die<40))
	--{ "Ravager", { "!player.moving", "!target.moving", "player.buff(Bloodbath)" }, "target.ground" },
	--{ "Ravager", { "!player.moving", "!target.moving", "!talent(6, 2)", "!toggle.adds" }, "target.ground" },
	--{ "Ravager", { "!player.moving", "!target.moving", "!talent(6, 2)", "target.boss", "target.deathin < 40" }, "target.ground" },
	-- actions.single_target+=/siegebreaker
	{ "Siegebreaker" },
	-- actions.single_target+=/execute,if=buff.sudden_death.react
	{ "Execute" }, --, "player.buff(Sudden Death)"
	-- actions.single_target+=/storm_bolt
	{ "Storm Bolt" },
	-- actions.single_target+=/wild_strike,if=buff.bloodsurge.up
	{ "Wild Strike", "player.buff(Bloodsurge)" },
	-- actions.single_target+=/execute,if=buff.enrage.up|target.time_to_die<12
	{ "Execute", "player.buff(Enrage)" },
	{ "Execute", "target.deathin < 12" },
	-- actions.single_target+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
	{ "Dragon Roar", { "player.buff(Bloodbath)" } }, --"player.area(8).enemies > 0",
	{ "Dragon Roar", { "!talent(6, 2)" } },
	-- actions.single_target+=/raging_blow
	{ "Raging Blow" },
	-- actions.single_target+=/wait,sec=cooldown.bloodthirst.remains,if=cooldown.bloodthirst.remains<0.5&rage<50
	--{ "pause", { "player.spell(Bloodthirst).cooldown <= 1.5", "player.rage < 50" } },
	-- actions.single_target+=/wild_strike,if=buff.enrage.up&target.health.pct>20
	{ "Wild Strike", { "player.buff(Enrage)", "target.health > 20" } },
	-- actions.single_target+=/bladestorm,if=!raid_event.adds.exists
	{ "Bladestorm", "toggle.adds" },
	-- actions.single_target+=/shockwave,if=!talent.unquenchable_thirst.enabled
	--{ "Shockwave", "!talent(3, 3)" }, --prot only?
	-- actions.single_target+=/impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
	{ "Impending Victory", { "!talent(3, 3)", "target.health > 20" } },
	-- actions.single_target+=/bloodthirst
	{ "Bloodthirst" },
}

local two_targets = {
	-- actions.two_targets=bloodbath
	{ "Bloodbath" },
	-- actions.two_targets+=/ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
	{ "Ravager", { "!player.moving", "!target.moving", "player.buff(Bloodbath)" }, "target.ground" },
	{ "Ravager", { "!player.moving", "!target.moving", "!talent(6, 2)" }, "target.ground" },
	-- actions.two_targets+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
	{ "Dragon Roar", { "player.area(8).enemies > 0", "player.buff(Bloodbath)" } },
	{ "Dragon Roar", { "player.area(8).enemies > 0", "!talent(6, 2)" } },
	-- actions.two_targets+=/call_action_list,name=bladestorm
	{ bladestorm },
	-- actions.two_targets+=/bloodthirst,if=buff.enrage.down|rage<40|buff.raging_blow.down
	{ "Bloodthirst", "!player.buff(Enrage)" },
	{ "Bloodthirst", "player.rage < 40" },
	{ "Bloodthirst", "!player.buff(Raging Blow!)" },
	-- actions.two_targets+=/siegebreaker
	{ "Siegebreaker" },
	-- actions.two_targets+=/execute,cycle_targets=1
	{ "Execute" },
	-- actions.two_targets+=/raging_blow,if=buff.meat_cleaver.up|target.health.pct<20
	{ "Raging Blow", "player.buff(Meat Cleaver)" },
	{ "Raging Blow", "target.health < 20" },
	-- actions.two_targets+=/whirlwind,if=!buff.meat_cleaver.up&target.health.pct>20
	{ "Whirlwind", { "player.area(8).enemies > 0", "!player.buff(Meat Cleaver)", "target.health > 20" } },
	-- actions.two_targets+=/wild_strike,if=buff.bloodsurge.up
	{ "Wild Strike", "player.buff(Bloodsurge)" },
	-- actions.two_targets+=/bloodthirst
	{ "Bloodthirst" },
	-- actions.two_targets+=/whirlwind
	{ "Whirlwind", "player.area(8).enemies > 0" },
}

local three_targets = {
	-- actions.three_targets=bloodbath
	{ "Bloodbath" },
	-- actions.three_targets+=/ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
	{ "Ravager", { "!player.moving", "!target.moving", "player.buff(Bloodbath)" }, "target.ground" },
	{ "Ravager", { "!player.moving", "!target.moving", "!talent(6, 2)" }, "target.ground" },
	-- actions.three_targets+=/call_action_list,name=bladestorm
	{ bladestorm },
	-- actions.three_targets+=/bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
	{ "Bloodthirst", "!player.buff(Enrage)" },
	{ "Bloodthirst", "player.rage < 50" },
	{ "Bloodthirst", "!player.buff(Raging Blow!)" },
	-- actions.three_targets+=/raging_blow,if=buff.meat_cleaver.stack>=2
	{ "Raging Blow", "player.buff(Meat Cleaver).count >= 2" },
	-- actions.three_targets+=/siegebreaker
	{ "Siegebreaker" },
	-- actions.three_targets+=/execute,cycle_targets=1
	{ "Execute" }, --, "player.buff(Sudden Death)"
	-- actions.three_targets+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
	{ "Dragon Roar", { "player.buff(Bloodbath)" } },
	{ "Dragon Roar", { "!talent(6, 2)" } },
	-- actions.three_targets+=/whirlwind,if=target.health.pct>20
	{ "Whirlwind", { "target.health > 20" } },
	-- actions.three_targets+=/bloodthirst
	{ "Bloodthirst" },
	-- actions.three_targets+=/wild_strike,if=buff.bloodsurge.up
	{ "Wild Strike", "player.buff(Bloodsurge)" },
	-- actions.three_targets+=/raging_blow
	{ "Raging Blow" },
}

local aoe = {
	-- 	actions.aoe=bloodbath
	{ "Bloodbath" },
	-- 	actions.aoe+=/ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
	{ "Ravager", { "!player.moving", "!target.moving", "player.buff(Bloodbath)" }, "target.ground" },
	{ "Ravager", { "!player.moving", "!target.moving", "!talent(6, 2)" }, "target.ground" },
	-- 	actions.aoe+=/raging_blow,if=buff.meat_cleaver.stack>=3&buff.enrage.up
	{ "Raging Blow", { "player.buff(Meat Cleaver).count >= 3", "player.buff(Enrage)" } },
	-- 	actions.aoe+=/bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
	{ "Bloodthirst", "!player.buff(Enrage)" },
	{ "Bloodthirst", "player.rage < 50" },
	{ "Bloodthirst", "!player.buff(Raging Blow!)" },
	-- 	actions.aoe+=/raging_blow,if=buff.meat_cleaver.stack>=3
	{ "Raging Blow", "player.buff(Meat Cleaver).count >= 3" },
	-- actions.aoe+=/call_action_list,name=bladestorm
	{ bladestorm },
	-- 	actions.aoe+=/whirlwind
	{ "Whirlwind" },
	-- actions.aoe+=/siegebreaker
	{ "Siegebreaker" },
	-- 	actions.aoe+=/execute,if=buff.sudden_death.react
	{ "Execute", "player.buff(Sudden Death)" },
	-- 	actions.aoe+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
	{ "Dragon Roar", { "player.buff(Bloodbath)" } },
	{ "Dragon Roar", { "!talent(6, 2)" } },
	-- 	actions.aoe+=/bloodthirst
	{ "Bloodthirst" },
	-- 	actions.aoe+=/wild_strike,if=buff.bloodsurge.up
	{ "Wild Strike", "player.buff(Bloodsurge)" },
}

NetherMachine.rotation.register_custom(72, "bbWarrior Fury (1H)", {
-- COMBAT
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/script TargetNearestEnemy()", { "toggle.autotarget", "!target.exists" } },
	{ "/script TargetNearestEnemy()", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- BUTTONS
	{ "Heroic Leap", { "modifier.lalt", "player.area(40).enemies > 0" }, "ground" },

	-- FROGGING
	{ {
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
	},{
		"toggle.frogs",
	} },

	-- DEFENSIVE COOLDOWNS
	{ "Victory Rush" },
	{ "#89640", { "toggle.consume", "player.health < 40", "!player.buff(130649)", "target.boss" } }, -- Life Spirit (130649)
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	-- { "Rallying Cry", "player.health < 10" }, -- Raidwide last stand
	-- Die by the Sword - Increases parry chance by 100% and reduces damage taken by 20% for 8 seconds

	-- INTERRUPTS
	{ "Pummel", "target.interruptAt(40)" },

	-- "player.onehand", "player.twohand",

	-- COOLDOWNS
	{ {
		-- actions=charge,if=debuff.charge.down
		-- actions+=/auto_attack
		-- # This is mostly to prevent cooldowns from being accidentally used during movement.
		-- actions+=/call_action_list,name=movement,if=movement.distance>5
		--{ movement, { "player.movingfor > 1", "target.range > 10" } },
		-- actions+=/berserker_rage,if=buff.enrage.down|(prev_gcd.bloodthirst&buff.raging_blow.stack<2)
		{ "Berserker Rage", "!player.buff(Enrage)" },
		{ "Berserker Rage", { "modifier.last(Bloodthirst)", "player.buff(Raging Blow!).count < 2" } },
		-- actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
		-- actions+=/use_item,name=vial_of_convulsive_shadows,if=(active_enemies>1|!raid_event.adds.exists)&((talent.bladestorm.enabled&cooldown.bladestorm.remains=0)|buff.recklessness.up|target.time_to_die<25|!talent.anger_management.enabled)
		-- TODO: &(active_enemies>1|!raid_event.adds.exists)
		{ "#trinket1", "player.hashero" },
		{ "#trinket1", { "talent(6, 3)", "player.spell(Bladestorm).cooldown <= 1.5" } },
		{ "#trinket1", "player.buff(Recklessness)" },
		{ "#trinket1", "talent(7, 1)" },
		{ "#trinket2", "player.hashero" },
		{ "#trinket2", { "talent(6, 3)", "player.spell(Bladestorm).cooldown <= 1.5" } },
		{ "#trinket2", "player.buff(Recklessness)" },
		{ "#trinket2", "talent(7, 1)" },
		-- actions+=/potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<=25
		{ "#109219", { "toggle.consume", "player.hashero" } }, -- Draenic Strength Potion
		{ "#109219", { "toggle.consume", "target.boss", "target.health < 20", "player.buff(Recklessness)" } }, -- Draenic Strength Potion
		{ "#109219", { "toggle.consume", "target.boss", "target.deathin <= 25" } }, -- Draenic Strength Potion
		-- # Skip cooldown usage if we can line them up with bladestorm on a large set of adds, or if movement is coming soon.
		-- actions+=/call_action_list,name=single_target,if=(raid_event.adds.cooldown<60&raid_event.adds.count>2&active_enemies=1)|raid_event.movement.cooldown<5
		-- TODO
		-- # This incredibly long line (Due to differing talent choices) says 'Use recklessness on cooldown, unless the boss will die before the ability is usable again, and then use it with execute.'
		-- actions+=/recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)
		-- TODO: Rewrite this
		{ "Recklessness", { "target.deathin > 190", "player.buff(Bloodbath)" } },
		{ "Recklessness", { "target.deathin > 190", "!talent(6, 2)" } },
		{ "Recklessness", { "target.boss", "target.health < 20", "player.buff(Bloodbath)" } },
		{ "Recklessness", { "target.boss", "target.health < 20", "!talent(6, 2)" } },
		{ "Recklessness", { "target.boss", "target.deathin <= 12" } },
		{ "Recklessness", { "talent(7, 1)" } },
		-- actions+=/avatar,if=buff.recklessness.up|cooldown.recklessness.remains>60|target.time_to_die<30
		{ "Avatar", "player.buff(Recklessness)" },
		{ "Avatar", "player.spell(Recklessness).cooldown > 60" },
		{ "Avatar", { "target.boss", "target.deathin < 30" } },
		-- actions+=/blood_fury,if=buff.bloodbath.up|!talent.bloodbath.enabled|buff.recklessness.up
		{ "Blood Fury", "player.buff(Bloodbath)" },
		{ "Blood Fury", "!talent(6, 2)" },
		{ "Blood Fury", "player.buff(Recklessness)" },
		-- actions+=/berserking,if=buff.bloodbath.up|!talent.bloodbath.enabled|buff.recklessness.up
		{ "Berserking", "player.buff(Bloodbath)" },
		{ "Berserking", "!talent(6, 2)" },
		{ "Berserking", "player.buff(Recklessness)" },
		-- actions+=/arcane_torrent,if=rage<rage.max-40
		{ "Arcane Torrent", "player.rage.deficit > 40" },
	},{
		"modifier.cooldowns", "target.spell(Bloodthirst).range"
	} },

	-- CALL ACTION LISTS
	-- actions+=/call_action_list,name=aoe,if=active_enemies>3
	{ aoe, { "modifier.multitarget", "player.area(8).enemies > 3" } },
	-- actions+=/call_action_list,name=three_targets,if=active_enemies=3
	{ three_targets, { "modifier.multitarget", "player.area(8).enemies == 3" } },
	-- actions+=/call_action_list,name=two_targets,if=active_enemies=2
	{ two_targets, { "modifier.multitarget", "player.area(8).enemies == 2" } },
	-- actions+=/call_action_list,name=single_target,if=active_enemies=1
	{ single_target },

},{
-- OUT OF COMBAT
	-- Pause
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- BUTTONS
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- BUFFS
	{ "Battle Shout", { "!player.buffs.attackpower", "lowest.distance <= 30" }, "lowest" },
	{ "Commanding Shout", { "!player.buffs.attackpower", "!player.buffs.stamina", "lowest.distance <= 30" }, "lowest" },

	-- PRE COMBAT
	{ "#76095", { "toggle.consume", "target.exists", "target.boss", "@bbLib.pullingIn(3)" } }, -- Strength Potion (76095) Potion of Mogu Power

	-- FROGGING
	{ {
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Taunt" },
	},{
		"toggle.frogs",
	} },

	-- actions.precombat=flask,type=greater_draenic_strength_flask
	-- actions.precombat+=/food,type=pickled_eel
	-- actions.precombat+=/stance,choose=battle
	-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
	-- # Generic on-use trinket line if needed when swapping trinkets out.
	-- #actions+=/use_item,slot=trinket1,if=active_enemies=1&(buff.bloodbath.up|(!talent.bloodbath.enabled&(buff.avatar.up|!talent.avatar.enabled)))|(active_enemies>=2&buff.ravager.up)
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_strength

}, function()
	--NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack nearby enemies.')
	NetherMachine.toggle.create('bladestorm', 'Interface\\Icons\\ability_warrior_bladestorm', 'Bladestorm', 'Toggle usage of Bladestorm in AoE.')
	NetherMachine.toggle.create('adds', 'Interface\\Icons\\achievement_pvp_o_h', 'Adds Mode', 'Enable if encounter has add spawns.')
end)








phoenix_fury_config = {
	key = "phoenixFury",
	profiles = true,
	title = "Fury Warrior",
	subtitle = "Configuration",
	color = "7A5230",
	width = 235,
	height = 350,
	config = {
		{
			type = "checkbox",
			text = "Auto target",
			key = "auto_target",
			default = false,
		},
		{
			type = "checkbox",
			default = true,
			text = "Stance Dance on Low HP",
			key = "stancedance",
		},
		{
			type = "dropdown",
			text = "DPS Potions:",
			key = "potions",
			list = {
				{
					text = "none",
					key = "none"
				},
				{
					text = "Alchemy Lab",
					key = "labpot"
				},
				{
					text = "Crafted Pot",
					key = "craftedpot"
				},
			},

			default = "none",
		},
		{
			type = "checkbox",
			default = true,
			text = "Charge to enemy",
			key = "charge",
		},
		{type = "rule"},
		{
			type = "text",
			text = "Self Healing",
			align = "center",
		},
		{
			type = "checkspin",
			text = "Impending Victory",
			key = "impv",
			default_spin = 80,
			default_check = false,
		},
		{
			type = "checkspin",
			text = "Healing Tonic",
			key = "healthpot",
			default_spin = 25,
			default_check = false,
		},
		{
			type = "checkspin",
			text = "Healthstone",
			key = "healthstone",
			default_spin = 25,
			default_check = false,
		},
		{type = "rule"},
		{
			type = "text",
			text = "Self Survivability",
			align = "center",
		},
		{
			type = "checkspin",
			text = "Die by the Sword",
			key = "dbs",
			default_spin = 10,
			default_check = false,
		},
		{
			type = "checkspin",
			text = "Rallying Cry",
			key = "rally",
			default_spin = 25,
			default_check = false,
		},
		{
			type = "checkbox",
			text = "Intimidating Shout on Threat",
			key = "fear",
			default = false,
		},
		{type = "rule"},
		{
			type = "text",
			text = "Hotkeys",
			align = "center",
		},
		{
			type = "text",
			text = "Left Control: Ravager",
			align = "left",
		},
		{
			type = "text",
			text = "Left Shift: Heroic Leap",
			align = "left",
		},
		{
			type = "text",
			text = "Left Alt: Pause Rotation",
			align = "left",
		},
		{
			type = "text",
			text = "Right Control: Intimidating Shout",
			align = "left",
		},
		{
			type = "text",
			text = "Right Alt: Shattering Throw",
			align = "left",
		},
	}
}
-- NetherMachine Rotation Packager
-- Author: Team Phoenix

-- Hotkeys: Left Control = Ravager
--			Left Shift = Heroic Leap
--			Left Alt = Pause
--			Right Control = Intimidating Shout
--			Right Alt = Shattering Throw

--Update from GUI

local fetch = NetherMachine.interface.fetchKey
local combat_rotation = {

{{	-- Auto Target
	{ "/cleartarget", "target.dead" },
	{ "/targetenemy", "!target.exists" },
	{ "/targetenemy", { "!target.exists", "!target.combat" } },
	{ "/cleartarget", "!target.combat" }
}, { (function() return fetch('phoenixFury', 'auto_target') end) } },

  -- Stance Dance
  { "71", { "player.health <= 10", "player.seal != 2", (function() return fetch('phoenixFury', 'stancedance') end) } },
  { "2457", {	"player.health >= 26", "player.seal != 1" } },

  -- Hotkeys
  { "Heroic Leap", "modifier.lshift", "mouseover.ground" },
  { "pause", "modifier.lalt" },
  { "Shattering Throw", "modifier.ralt" },
  { "Ravager", "modifier.lcontrol", "mouseover.ground" },
  { "Intimidating Shout", "modifier.rcontrol" },

  -- Interrupt
  { "Pummel", "modifier.interrupt" },

  -- Buffs
  { "Battle Shout", "!player.buffs.attackpower" },
  { "Berserker Rage", { "!player.buff(Enrage)", "player.lastcast(Bloodthirst)", "player.buff(Raging Blow).count < 2" } },

  -- OOR
  { "Charge", { "target.distance >= 10", (function() return fetch('phoenixFury', 'charge') end) } },

  -- Survival
  { "#109223", { (function() return dynamicEval("player.health <= " .. fetch('phoenixFury', 'healthpot_spin')) end), (function() return fetch('phoenixFury', 'healthpot_check') end) } }, -- Healing Tonic
  { "#5512", { (function() return dynamicEval("player.health <= " .. fetch('phoenixFury', 'healthstone_spin')) end), (function() return fetch('phoenixFury', 'healthstone_check') end) } }, -- Healthstone (5512)
  { "Die by the Sword", { (function() return dynamicEval("player.health <= " .. fetch('phoenixFury', 'dbs_spin')) end), (function() return fetch('phoenixFury', 'dbs_check') end) } },
  { "Rallying Cry", { (function() return dynamicEval("player.health <= " .. fetch('phoenixFury', 'rally_spin')) end), (function() return fetch('phoenixFury', 'rally_check') end) } },
  { "Victory Rush", "player.buff(Victorious)" },
  { "Impending Victory", { (function() return dynamicEval("player.health <= " .. fetch('phoenixFury', 'impv_spin')) end), (function() return fetch('phoenixFury', 'impv_check') end) } },
  { "20589", "player.state.root" }, -- Break Root/snare
  { "20589", "player.state.snare" },-- Break Root/snare
  { "Intimidating Shout", { "target.threat >= 80", (function() return fetch('phoenixFury', 'fear') end) } }, -- Fear on agro

{{ -- Cooldowns
  	{ "#trinket1" },
  	{ "#trinket2" },
	{"Berserker Rage", {"!player.buff(Enrage)", "player.lastcast(Bloodthirst)","player.buff(Raging Blow).count < 2" } },
	{ "#122455", { (function() return fetch('phoenixFury', 'potions') == 'labpot' end), "player.buff(Recklessness)", "target.ttd <= 25" } },
	{ "#109219", { (function() return fetch('phoenixFury', 'potions') == 'craftpot' end), "player.buff(Recklessness)", "target.ttd <= 25" } },
	{"Recklessness", { "target.ttd > 190", "player.buff(Bloodbath)" } },
	{"Recklessness", { "target.ttd > 190", "!talent(6,2)" } },
	{"Recklessness", { "target.health < 20", "player.buff(Bloodbath)" } },
	{"Recklessness", { "target.health < 20", "!talent(6,2)" } },
	{"Recklessness", { "target.ttd <=12", "talent(7,1)", "talent(6,3)", "player.spell(Bladestorm).cooldown < 0" } },
	{"Recklessness", { "target.ttd <=12", "talent(7,1)", "!talent(6,3)" } },
	{"Avatar", {"player.buff(Recklessness)", "target.ttd < 30" } },
	{"Blood Fury", {"player.buff(Bloodbath)", "player.buff(Recklessness)" } },
	{"Berserking", {"player.buff(Bloodbath)", "player.buff(Recklessness)" } },
	{ "Arcane Torrent", {"player.rage > 60" } }
}, "modifier.cooldowns" },


{{ --SmartAE
	{ "Bloodbath" },
	{ "Bloodthirst", { "!player.buff(Enrage)" } },
	{ "Bloodthirst", { "!player.buff(Raging Blow)" } },
	{ "Raging Blow", { "player.buff(Meat Cleaver).count >= 3 ", "player.buff(Enrage)" } },
	{ "Raging Blow", { "!player.buff(Raging Wind)", "player.buff(Enrage)" } },
	{ "Whirlwind", { "player.buff(Raging Wind)", "player.buff(Enrage)" } },
	{ "Whirlwind", { "player.buff(Meat Cleaver).count < 3", "player.buff(Enrage)" } },
	{ "Ravager", nil, "target.ground", { "player.buff(Bloodbath)" } },
	{ "Ravager", nil, "target.ground", { "!talent(6, 2)" } },
	{ "Bladestorm", "player.buff(Enrage).duration > 6" },
	{ "Execute", "player.buff(Sudden Death)" },
	{ "Dragon Roar", { "player.buff(Bloodbath)" } },
	{ "Bloodthirst" }
}, { "modifier.multitarget", "player.akearea(8).enemies >= 4" } },


	-- Single Target
	{ "Bloodbath" },
	{ "Wild Strike", { "player.rage > 90", "target.health > 20" } },
	{ "Bloodthirst", {"!talent(3,3)", "player.rage > 60", "!player.buff(Enrage)", "player.buff(Raging Blow).count > 2" } },
	{ "Ravager", { "player.buff(Bloodbath)", "target.ttd > 40" } },
	{ "Siegebreaker"},
	{ "Execute", { "player.buff(Sudden Death)" } },
	{ "Storm Bolt"},
	{ "Wild Strike", "player.buff(Bloodsurge)" },
	{ "Execute", { "player.buff(Enrage)", "target.ttd < 12" } },
	{ "Dragon Roar", "player.buff(Bloodbath)" },
	{ "Raging Blow"},
	{ "Wild Strike", { "player.buff(Enrage)", "target.health > 20" } },
	{ "Bloodthirst" }


}

local _, Ake = ...
local overrides = Ake.NMOverrides
local oocRotation = {

	{ overrides, },

-- OUT OF COMBAT ROTATION
	-- Pause
	{ "pause", "modifier.lalt" },
	{ "Battle Shout", "!player.buffs.attackpower" },

}

local onLoad = function()
	-- Buttons
	NetherMachine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() displayFrame(phoenix_fury_config) end))
end

NetherMachine.rotation.register_custom(72, "Team Phoenix - #FURYOLO", combat_rotation, oocRotation, onLoad)
