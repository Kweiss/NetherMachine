-- Protection Warrior Rotation for Legion 7.1
-- Updated on 11/1/2016

-- PLAYER CONTROLLED: Pots, Charge, Heroic Leap, Rallying Cry
-- OPTIMAL TALENTS: 1113323

-- /script print("Distance: "..NetherMachine.condition["distance"]('target'))

NetherMachine.rotation.register_custom(73, "|cff8A2BE2Legion |cffC79C6EWarrior Protection |cffff9999(7.1)", {
	--------------------
	-- Start Rotation --
	--------------------

	-- Buffs
	{ "Berserker Rage", "player.state.fear" },
  { "Berserker Rage", "player.state.stun" },
  { "Berserker Rage", "player.state.root" },
  { "Berserker Rage", "player.state.horror" },

	-- Survival
	{ "Last Stand", { "player.health < 20", "modifier.cooldowns" }},
	{ "Shield Wall", { "player.health < 30", "modifier.cooldowns"	}},

	{ "Impending Victory", "player.health <= 85" },

	-- Survival Buffs
	{{

		{ "61336", { "player.health <= 40", "player.spell(61336).charges > 1" }}, --Survival Instincts

		{ "#5512", { "player.health <= 50" }}, --Healthstone

		{ "2565", { "player.rage > 90", "!player.buff(2565)", "target.threat >= 100" }}, -- Shield Block
		{ "2565", { "player.rage > 95", "target.threat >= 100" }}, -- Shield Block
		{ "2565", { "player.health <= 96", "player.rage > 60", "!player.buff(2565)" }}, -- Shield Block
		{ "2565", { "player.health <= 70", "player.rage > 50", "!player.buff(2565)" }}, -- Shield Block

		{ "190456", { "player.health <= 90", "player.rage > 60", "toggle.Magic" }}, -- Ignore Pain

		{ "200851", { "player.health <= 70", "modifier.cooldowns" }}, --Rage of the Sleeper

		{ "#trinket2", { "player.buff(Rage of the Sleeper)" }}, --Vers Trinket
		},{
			"target.exists", "target.enemy", "target.alive", "targettarget.istheplayer"
		} },

-- "!player.buff(Bristling Fur)", "!player.buff(Survival Instincts)", "!player.buff(Barkskin)", "!player.buff(Savage Defense)"

	-- Kicks
	{ "Pummel", "modifier.interrupts" },
	{ "Disrupting Shout", "modifier.interrupts", "target.range <= 8" },

	-- Ranged
	{ "Heroic Throw", "target.range >= 10" },

	-- Cooldowns
	{ "Avatar", "modifier.cooldowns"  },

	-- AoE
	{ "Thunder Clap", { "modifier.multitarget", "target.range <= 5" } },
	{ "Shockwave", { "modifier.multitarget", "target.range <= 5" } },
	{ "Revenge", { "modifier.multitarget" } },

	-- Rotation
	{ "Shield Slam" },
	{ "Devastate", { "player.spell(Shield Slam).cooldown > 1" } },
	{ "Revenge", { "player.spell(Shield Slam).cooldown < 1.5" } },

	-- Weakened Armor

	------------------
	-- End Rotation --
	------------------


},{
-- OUT OF COMBAT

	-- BUTTONS
	{ "Heroic Leap", { "modifier.lshift" }, "ground" },

},function()
	NetherMachine.toggle.create('shieldblock', 'Interface\\ICONS\\ability_defend', 'Shield Block', 'Toggle usage of Shield Block for Physical Damage')
	NetherMachine.toggle.create('shieldbarrier', 'Interface\\ICONS\\inv_shield_07', 'Shield Barrier', 'Toggle usage of Shield Barrier for Magic/Bleed Damage')
end)

--[[

actions.prot=shield_block,if=!buff.neltharions_fury.up&((cooldown.shield_slam.remains<6&!buff.shield_block.up)|(cooldown.shield_slam.remains<6+buff.shield_block.remains&buff.shield_block.up))
actions.prot+=/ignore_pain,if=(rage>=60&!talent.vengeance.enabled)|(buff.vengeance_ignore_pain.up&buff.ultimatum.up)|(buff.vengeance_ignore_pain.up&rage>=39)|(talent.vengeance.enabled&!buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage<30)
actions.prot+=/focused_rage,if=(buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(buff.ultimatum.up&buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(talent.vengeance.enabled&buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage>=30)|(buff.ultimatum.up&buff.vengeance_ignore_pain.up&cooldown.shield_slam.remains=0&rage<10)|(rage>=100)
actions.prot+=/demoralizing_shout,if=incoming_damage_2500ms>health.max*0.20
actions.prot+=/shield_wall,if=incoming_damage_2500ms>health.max*0.50
actions.prot+=/last_stand,if=incoming_damage_2500ms>health.max*0.50&!cooldown.shield_wall.remains=0
actions.prot+=/potion,name=unbending_potion,if=(incoming_damage_2500ms>health.max*0.15&!buff.potion.up)|target.time_to_die<=25
actions.prot+=/call_action_list,name=prot_aoe,if=spell_targets.neltharions_fury>=2
actions.prot+=/focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot+=/neltharions_fury,if=incoming_damage_2500ms>health.max*0.20&!buff.shield_block.up
actions.prot+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot+=/revenge,if=cooldown.shield_slam.remains<=gcd.max*2
actions.prot+=/devastate

actions.prot_aoe=focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot_aoe+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot_aoe+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot_aoe+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot_aoe+=/neltharions_fury,if=buff.battle_cry.up
actions.prot_aoe+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot_aoe+=/revenge
actions.prot_aoe+=/thunder_clap,if=spell_targets.thunder_clap>=3
actions.prot_aoe+=/devastate

]]--
