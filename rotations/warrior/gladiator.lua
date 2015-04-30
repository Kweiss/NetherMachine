-- NetherMachine Rotation
-- Protection Gladiator Warrior - WoD 6.0.3
-- Updated on Nov 21st 2014

-- PLAYER CONTROLLED: Charge, Heroic Leap
-- SUGGESTED TALENTS: 2133323
-- SUGGESTED GLYPHS: Glyph of Unending Rage, Glyph of Enraged Speed, Glyph of the Blazing Trail, Glyph of Cleave
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(73, "bbWarrior Gladiator", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- BUTTONS
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- AUTO TARGET
	{ "/script TargetNearestEnemy()", { "toggle.autotarget", "!target.exists" } },
	{ "/script TargetNearestEnemy()", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- AUTO TAUNT
	{ "Taunt", { "toggle.autotaunt", "@bbLib.bossTaunt" } },

	-- DEFENSIVE COOLDOWNS
	{ "Rallying Cry", { "player.health < 30", "modifier.cooldowns" } },
	{ "Last Stand", { "player.health < 45", "modifier.cooldowns" } },
	{ "Enraged Regeneration", { "player.health < 45", "modifier.cooldowns" } },
	{ "Impending Victory", "player.health < 70" },
	{ "Victory Rush" },
	{ "Shield Block", { "!player.buff(Shield Block)", "toggle.shieldblock" } }, -- for heavy physical dmg
	{ "Shield Barrier", { "!player.buff(Shield Barrier)", "player.rage > 60", "toggle.shieldbarrier" } }, -- for magic/bleed/unblockable dmg
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)

	-- INTERRUPTS
	{ "Disrupting Shout", { "target.exists", "target.range < 10", "modifier.interrupt", "player.area(10).enemies > 1"  } },
	{ "Pummel", "modifier.interrupt" },

	-- actions=charge
	-- actions+=/auto_attack

-- actions+=/call_action_list,name=movement,if=movement.distance>5 -- "target.spell(Heroic Strike).range"
	-- actions.movement=heroic_leap
	-- actions.movement+=/shield_charge
	-- actions.movement+=/storm_bolt
	{ "Storm Bolt", "target.range > 5" },
	-- actions.movement+=/heroic_throw
	{ "Heroic Throw", "target.range > 5" },

	-- OFFENSIVE COOLDOWNS / COMMON
	{ {
		-- actions=charge
		-- actions+=/auto_attack
		-- # This is mostly to prevent cooldowns from being accidentally used during movement.
		-- actions+=/call_action_list,name=movement,if=movement.distance>5
		-- actions+=/avatar
		{ "Avatar" },
		-- actions+=/bloodbath
		{ "Bloodbath" },
		-- actions+=/blood_fury,if=buff.bloodbath.up|buff.avatar.up|buff.shield_charge.up|target.time_to_die<10
		{ "Blood Fury", "player.buff(Bloodbath)" },
		{ "Blood Fury", "player.buff(Avatar)" },
		{ "Blood Fury", "player.buff(Shield Charge)" },
		{ "Blood Fury", { "target.boss", "target.deathin < 10" } },
		-- actions+=/berserking,if=buff.bloodbath.up|buff.avatar.up|buff.shield_charge.up|target.time_to_die<10
		{ "Berserking", "player.buff(Bloodbath)" },
		{ "Berserking", "player.buff(Avatar)" },
		{ "Berserking", "player.buff(Shield Charge)" },
		{ "Berserking", { "target.boss", "target.deathin < 10" } },
		-- actions+=/arcane_torrent,if=rage<rage.max-40
		{ "Arcane Torrent", "player.rage.deficit > 40" },
		-- actions+=/potion,name=draenic_armor,if=buff.bloodbath.up|buff.avatar.up|buff.shield_charge.up
		{ "#109220", { "toggle.consume", "target.boss", "player.buff(Bloodbath)" } }, -- Draenic Armor Potion
		{ "#109220", { "toggle.consume", "target.boss", "player.buff(Avatar)" } }, -- Draenic Armor Potion
		{ "#109220", { "toggle.consume", "target.boss", "player.buff(Shield Charge)" } }, -- Draenic Armor Potion
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.distance < 10",
	} },

	-- actions+=/shield_charge,if=(!buff.shield_charge.up&!cooldown.shield_slam.remains)|charges=2
	{ "Shield Charge", { "!player.buff(Shield Charge)", "player.spell(Shield Slam).cooldown == 0" } },
	{ "Shield Charge", "player.spell(Shield Charge).charges == 2" },
	-- actions+=/berserker_rage,if=buff.enrage.down
	{ "Berserker Rage", "!player.buff(Enrage)" }, -- Buff is Berserker Rage?
	-- actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
	-- actions+=/heroic_strike,if=(buff.shield_charge.up|(buff.unyielding_strikes.up&rage>=50-buff.unyielding_strikes.stack*5))&target.health.pct>20
	{ "Heroic Strike", { "target.health > 20", "player.buff(Shield Charge)" } },
	{ "Heroic Strike", { "target.health > 20", (function() return NetherMachine.condition["rage"]('player') >= 50 - NetherMachine.condition["buff.count"]('player', 'Unyielding Strikes') * 5 end) } },
	-- actions+=/heroic_strike,if=buff.ultimatum.up|rage>=rage.max-20|buff.unyielding_strikes.stack>4|target.time_to_die<10
	{ "Heroic Strike", "player.buff(Ultimatum)" },
	{ "Heroic Strike", "player.rage.deficit <= 20" },
	{ "Heroic Strike", "player.buff(Unyielding Strikes).count > 4" },
	{ "Heroic Strike", { "target.boss", "target.deathin < 10" } },


	-- MULTIPLE TARGET
	-- actions+=/call_action_list,name=aoe,if=active_enemies>=2
	{ {
		-- actions.aoe=revenge
		{ "Revenge" },
		-- actions.aoe+=/shield_slam
		{ "Shield Slam" },
		-- actions.aoe+=/dragon_roar,if=(buff.bloodbath.up|cooldown.bloodbath.remains>10)|!talent.bloodbath.enabled
		{ "Dragon Roar", "!talent(6, 2)" },
		{ "Dragon Roar", { "talent(6, 2)", "player.buff(Bloodbath)" } },
		{ "Dragon Roar", { "talent(6, 2)", "player.spell(Bloodbath).cooldown > 10" } },
		-- actions.aoe+=/storm_bolt,if=(buff.bloodbath.up|cooldown.bloodbath.remains>7)|!talent.bloodbath.enabled
		{ "Storm Bolt", "!talent(6, 2)" },
		{ "Storm Bolt", { "talent(6, 2)", "player.buff(Bloodbath)" } },
		{ "Storm Bolt", { "talent(6, 2)", "player.spell(Bloodbath).cooldown > 7" } },
		-- actions.aoe+=/thunder_clap,cycle_targets=1,if=dot.deep_wounds.remains<3&active_enemies>4
		{ "Thunder Clap", { "target.debuff(Deep Wounds).remains < 3", "player.area(7).enemies > 4" } },
		-- actions.aoe+=/bladestorm,if=buff.shield_charge.down
		{ "Bladestorm", { "!player.buff(Shield Charge)", "player.area(7).enemies > 1" } },
		-- actions.aoe+=/execute,if=buff.sudden_death.react
		{ "Execute", "player.buff(Sudden Death)" },
		-- actions.aoe+=/thunder_clap,if=active_enemies>6
		{ "Thunder Clap", { "player.area(7).enemies > 6" } },
		-- actions.aoe+=/devastate,cycle_targets=1,if=dot.deep_wounds.remains<5&cooldown.shield_slam.remains>execute_time*0.4
		{ "Devastate", { "target.debuff(Deep Wounds).remains < 5", "player.spell(Shield Slam).cooldown > 0.6" } },
		-- actions.aoe+=/devastate,if=cooldown.shield_slam.remains>execute_time*0.4
		{ "Devastate", "player.spell(Shield Slam).cooldown > 0.6" },
	},{
		"modifier.multitarget", "player.area(3).enemies >= 2",
	} },


	-- SINGLE TARGET
	-- actions+=/call_action_list,name=single,if=active_enemies=1
	-- actions.single=devastate,if=buff.unyielding_strikes.stack>0&buff.unyielding_strikes.stack<6&buff.unyielding_strikes.remains<1.5
	{ "Devastate", { "player.buff(Unyielding Strikes)", "player.buff(Unyielding Strikes).count < 6", "player.buff(Unyielding Strikes).remains <= 1.5" } },
	-- actions.single+=/shield_slam
	{ "Shield Slam" },
	-- actions.single+=/revenge
	{ "Revenge" },
	-- actions.single+=/execute,if=buff.sudden_death.react
	{ "Execute", "player.buff(Sudden Death)" },
	-- actions.single+=/storm_bolt
	{ "Storm Bolt" },
	-- actions.single+=/dragon_roar
	{ "Dragon Roar" },
	-- actions.single+=/execute,if=rage>60&target.health.pct<20
	{ "Execute", "player.rage > 60" },
	-- actions.single+=/devastate
	{ "Devastate" },

}, {
-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- BUTTONS
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- PRE COMBAT
	-- actions.precombat=flask,type=greater_draenic_strength_flask
	-- actions.precombat+=/food,type=blackrock_barbecue
	-- actions.precombat+=/stance,choose=gladiator
	-- talent_override=bladestorm,if=raid_event.adds.count>5|desired_targets>5|(raid_event.adds.duration<10&raid_event.adds.exists)
	-- talent_override=dragon_roar,if=raid_event.adds.count>1|desired_targets>1
	-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
	-- # Generic on-use trinket line if needed when swapping trinkets out.
	-- #actions+=/use_item,slot=trinket1,if=buff.bloodbath.up|buff.avatar.up|buff.shield_charge.up|target.time_to_die<10
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_armor
},
function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
	NetherMachine.toggle.create('shieldblock', 'Interface\\Icons\\ability_defend', 'Auto Shield Block', 'Keeps Shield Block up for heavy physical damage.')
	NetherMachine.toggle.create('shieldbarrier', 'Interface\\Icons\\inv_shield_07', 'Auto Shield Barrier', 'Keeps Shield Barrier up for magic, bleed, and unblockable damage.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
end)
