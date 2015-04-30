-- NetherMachine Rotation
-- Protection Warrior Rotation for WoD 6.0.3
-- Updated on Dec 28th 2014

-- PLAYER CONTROLLED: Pots, Charge, Heroic Leap, Rallying Cry
-- OPTIMAL TALENTS: 1113323
-- OPTIMAL GLYPHS: unending_rage/cleave/heroic_leap
-- CONTROLS: Pause - Left Control

-- /script print("Distance: "..NetherMachine.condition["distance"]('target'))

NetherMachine.rotation.register_custom(73, "bbWarrior Protection (SimC)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- BUTTONS
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!toggle.frogs", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "!toggle.frogs", "target.exists", "target.dead" } },

	-- FROGING
	{ {
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
	}, "toggle.frogs" },

	-- AUTO TAUNT
	{ "Taunt", { "toggle.autotaunt", "@bbLib.bossTaunt" } },

	-- INTERRUPTS
	{ "Disrupting Shout", { "target.exists", "target.enemy", "target.interruptAt(40)", "target.range < 10", "player.area(10).enemies > 1"  } },
	{ "Disrupting Shout", { "mouseover.exists", "mouseover.enemy", "mouseover.interruptAt(40)", "mouseover.range < 10", "player.area(10).enemies > 1" }, "mouseover" },
	{ "Pummel", { "target.exists", "target.enemy", "target.interruptAt(40)", "target.range < 5" } },
	{ "Pummel", { "mouseover.exists", "mouseover.enemy", "mouseover.interruptAt(40)", "mouseover.range <= 5" }, "mouseover" },
	-- Spell Reflection

	-- RANGED
	{ "Heroic Throw", { "target.combat", "target.range >= 10" } },
	{ "Throw", { "target.combat", "target.range >= 10", "!player.moving" } },
	-- Shattering Throw?

	-- OFFENSIVE COOLDOWNS
	{ {
		-- actions=charge
		-- actions+=/auto_attack
		{ "Blood Fury", "player.buff(Bloodbath)" },
		{ "Blood Fury", "player.buff(Avatar)" },
		{ "Berserking", "player.buff(Bloodbath)" },
		{ "Berserking", "player.buff(Avatar)" },
		{ "Arcane Torrent", "player.buff(Bloodbath)" },
		{ "Arcane Torrent", "player.buff(Avatar)" },
		{ "Berserker Rage", "!player.buff(Enrage)" },
 	},{ "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "target.distance < 3" } },

	-- DEFENSIVE COOLDOWNS
	{ "#5512", { "modifier.cooldowns", "player.health < 30" } }, -- Healthstone (5512)
	{ {
		{ "Shield Block" },
		{ "Demoralizing Shout", { "player.area(10).enemies > 0" } },
		{ "Enraged Regeneration", { "player.health < 70" } },
		{ "Shield Wall", { "player.health < 60" } },
		{ "Last Stand", { "player.health < 25" } },
		-- actions.prot+=/potion,name=draenic_armor,if=incoming_damage_2500ms>health.max*0.1|target.time_to_die<=25
		{ "Stoneform" },
	},{
		"player.health < 90", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial)", "target.distance <= 5",
		"!target.debuff(Demoralizing Shout)", "!player.buff(Ravager)", "!player.buff(Shield Wall)", "!player.buff(Last Stand)", "!player.buff(Enraged Regeneration)", "!player.buff(Shield Block)"
	} }, --!buff.potion.up
	{ "Shield Barrier", { "!player.buff(Shield Barrier)", "!player.buff(Shield Block)", "player.spell(Shield Block).charges < 0.75" } },
	{ "Shield Barrier", { "!player.buff(Shield Barrier)", "player.rage >= 85" } },
	-- Vigilance

	-- AOE THREAT ROTATION 4+
	{ {
		{ "Bloodbath", "modifier.cooldowns" },
		{ "Avatar", "modifier.cooldowns" },
		{ "Thunder Clap", { "!target.debuff(Deep Wounds)", "target.distance < 8" } },
		{ "Heroic Strike", "player.buff(Ultimatum)" },
		{ "Heroic Strike", "player.rage > 110" },
		{ "Heroic Strike", { "talent(3, 3)", "player.buff(Unyielding Strikes).count >= 6" } },
		-- actions.prot_aoe+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
		{ "Shield Slam", "player.buff(Shield Block)" },
		{ "Ravager", { "talent(6, 1)", "player.buff(Avatar)" } },
		{ "Ravager", { "talent(6, 1)", "player.spell(Avatar).cooldown > 10" } },
		{ "Ravager", "!talent(6, 1)" },
		{ "Dragon Roar", { "talent(6, 2)", "player.buff(Bloodbath)" } },
		{ "Dragon Roar", { "talent(6, 2)", "player.spell(Bloodbath).cooldown > 10" } },
		{ "Dragon Roar", "!talent(6, 2)" },
		{ "Shockwave" },
		{ "Revenge" },
		{ "Thunder Clap" },
		{ "Bladestorm" },
		{ "Shield Slam" },
		{ "Storm Bolt" },
		{ "Shield Slam" },
		{ "Execute", "player.buff(Sudden Death)" },
		{ "Devastate" },
	}, { "modifier.multitarget", "player.area(8).enemies > 3" } },


	-- SINGLE TARGET ROTATION 1-3
	{ "Heroic Strike", "player.buff(Ultimatum)" },
	{ "Heroic Strike", { "talent(3, 3)", "player.buff(Unyielding Strikes).count >= 6" } },
	{ "Bloodbath", { "talent(6, 2)", "talent(4, 3)", "player.spell(Dragon Roar).cooldown == 0" } },
	{ "Bloodbath", { "talent(6, 2)", "talent(4, 1)", "player.spell(Storm Bolt).cooldown == 0" } },
	{ "Bloodbath", { "talent(6, 2)", "talent(4, 2)" } },
	{ "Avatar", { "talent(6, 1)", "talent(7, 2)", "player.spell(Ravager).cooldown == 0" } },
	{ "Avatar", { "talent(6, 1)", "talent(4, 3)", "player.spell(Dragon Roar).cooldown == 0" } },
	{ "Avatar", { "talent(6, 1)", "talent(4, 1)", "player.spell(Storm Bolt).cooldown == 0" } },
	{ "Avatar", { "talent(6, 1)", "!talent(4, 3)", "!talent(7, 2)", "!talent(4, 1)" } },
	{ "Shield Slam" },
	{ "Revenge" },
	{ "Ravager" },
	{ "Storm Bolt" },
	{ "Dragon Roar" },
	{ "Impending Victory", { "talent(2, 3)", "player.health < 90" } },
	{ "Victory Rush", "!talent(2, 3)" },
	{ "Execute", "player.buff(Sudden Death)" },
	{ "Devastate" },

},{
-- OUT OF COMBAT
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- BUTTONS
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- BUFFS
	{ "Battle Shout", { "!player.buffs.attackpower", "lowest.distance <= 30" }, "lowest" },
	{ "Commanding Shout", { "!player.buffs.attackpower", "!player.buffs.stamina", "lowest.distance <= 30" }, "lowest" },

	-- AUTO ATTACK
	{ {
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Taunt" },
	}, "toggle.frogs" },

},function()
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('shout', 'Interface\\ICONS\\ability_warrior_battleshout', 'Battle Shout', 'Toggle usage of Battle Shout vs Commanding Shout')
	NetherMachine.toggle.create('shieldblock', 'Interface\\ICONS\\ability_defend', 'Shield Block', 'Toggle usage of Shield Block for Physical Damage')
	NetherMachine.toggle.create('shieldbarrier', 'Interface\\ICONS\\inv_shield_07', 'Shield Barrier', 'Toggle usage of Shield Barrier for Magic/Bleed Damage')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack nearby enemies.')
end)
