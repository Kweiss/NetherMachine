-- NetherMachine Rotation
-- Custom Guardian Druid - WoD 6.1.2
-- Created on Jan 7th 2015 by Backburn
-- Updated by Phreakshow
-- Updated on 04/17/2015 @ 9:58
--	Version 1.0.1
-- Status: Functional & (Tested) Error Free - Work in Progress [ Estimated Completion: ~75% ]
-- Notes: Updating guardian profile to match SimCraft T17-Heroic & T17-Mythic Action Rotation Lists, along with advice from Icy-Veins.com
-- Credits to *** Backburn *** for the original profile development! [Personal thanks for all of your hard work and dedication of being a WoW player]

-- PLAYER CONTROLLED:
-- REQUIRED TALENTS: (Feline Swiftness or Wild Charge), Cenarion Ward, Typhoon, Soul of the Forest, Mighty Bash, Dream of Cenarius, Pulverize
-- REQUIRED GLYPHS: Glyph of Maul, Glyph of Rebirth, Glyph of Fae Silence, Glyph of Grace (minor)
-- CONTROLS: Left Ctrl == Pause Profile Rotation

NetherMachine.rotation.register_custom(104, "|cFF99FF00Phreakshow |cFFFF6600Guardian Druid |cFFFF9999Patch 6.1.2 |cFF336600Version: |cFF3333CC1.0.1", {
-- COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead", "!target.friend" } },

	-- AUTO ATTACK
	{ {
		{ "Mark of the Wild", "@bbLib.engaugeUnit('ANY', 30, true)" },
	}, "toggle.autoattack" },

	-- BEAR FORM
	{ "Bear Form", { "!player.buff(Bear Form)", "!player.flying", "!player.buff(Dash)", "!modifier.last" } },

	-- INTERRUPTS
	{ {
		{ "Skull Bash" },
		{ "Faerie Fire", { "player.glyph(114237)" } }, -- Glyph of Fae Silence (114237)
		{ "Mighty Bash", { "talent(5, 3)", "modifier.interrupt" } },
		{ "War Stomp", { "modifier.interrupt", "target.range < 5" } },
	},{ "modifier.interrupt" } },
	{ "Faerie Fire", { "toggle.mouseovers", "mouseover.alive", "mouseover.enemy", "mouseover.interrupt", "player.glyph(114237)" }, "mouseover" }, -- Glyph of Fae Silence (114237)
	
	-- DREAM PROCS
	{ "Rebirth", { "target.exists", "target.friend", "target.dead", "player.buff(Dream of Cenarius).remains >= 1.5" }, "target" },

	-- RANGED PULLS
	{ "Faerie Fire", { "target.exists", "target.distance > 5" } },
	{ "Faerie Fire", { "toggle.mouseovers", "mouseover.exists", "mouseover.alive", "mouseover.enemy", "mouseover.distance > 5" }, "mouseover" },

	-- DEFENSIVE COOLDOWNS
	{ "#5512", { "toggle.consume", "player.health < 40" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 20", "target.boss" } }, -- Master Healing Potion (76097)
	{ {
		{ "Bristling Fur", { "player.health < 80" } },
		{ "Savage Defense", { "player.health < 95", "player.rage >= 60" } },
		{ "Survival Instincts", { "player.health < 70", "player.spell(Survival Instincts).charges > 1" } },
		{ "Barkskin", { "player.health < 90" } },
		{ "#trinket1" },
		{ "#trinket2" },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "targettarget.istheplayer", "!player.buff(Bristling Fur)", "!player.buff(Survival Instincts)", "!player.buff(Barkskin)", "!player.buff(Savage Defense)"
	} },

	-- OFFENSIVE COOLDOWNS
	{ {
		{ "Blood Fury" },
		{ "Berserking" },
		{ "Arcane Torrent", "player.rage <= 75" },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },

	-- THREAT ROTATION
	-- actions+=/maul,if=buff.tooth_and_claw.react&incoming_damage_1s
	{ "Maul", { "toggle.cleave", "player.buff(Tooth and Claw)", "!modifier.last" } }, -- Empowered Maul causes its primary victim's next autoattack to deal (Attack power * 2.4) less damage.
	-- actions+=/berserk,if=buff.pulverize.remains>10
	{ "Berserk", { "player.buff(Pulverize).remains > 10" } }, -- When used in Bear Form, removes the cooldown from Mangle and causes it to hit up to 3 targets and lasts 10 sec.
	-- actions+=/frenzied_regeneration,if=rage>=80
	{ "Frenzied Regeneration", { "modifier.cooldowns", "player.rage >= 80", "!modifier.last", "player.health < 90" } }, -- Heal streangth is: max(2 x (AttackPower - Agility x 2), Stamina x 2.5)
	-- actions+=/cenarion_ward
	{ "Cenarion Ward", true, "player" },
	-- actions+=/renewal,if=health.pct<30
	{ "Renewal", "player.health < 60" },
	-- actions+=/heart_of_the_wild
	{ "Heart of the Wild", "modifier.cooldowns" },
	-- actions+=/rejuvenation,if=buff.heart_of_the_wild.up&remains<=3.6
	{ "Rejuvenation", { "player.buff(Heart of the Wild)", "player.buff.remains <= 3.6" }, "player" },
	-- actions+=/natures_vigil
	{ "Nature's Vigil", "player.health < 95" },
	-- actions+=/healing_touch,if=buff.dream_of_cenarius.react&health.pct<30
	{ "Healing Touch", { "player.buff(Dream of Cenarius).remains >= 1.5", "player.health < 70" }, "player" },
	-- actions+=/pulverize,if=buff.pulverize.remains<=3.6
	{ "Pulverize", { "target.debuff(Lacerate).count == 3", "player.buff(Pulverize).remains <= 3.6" } }, -- check to see how many lacerate stacks pulverize will trigger with
	-- actions+=/lacerate,if=talent.pulverize.enabled&buff.pulverize.remains<=(3-dot.lacerate.stack)*gcd&buff.berserk.down
	{ "Lacerate", { "target.exists", "talent(7, 2)", "!player.buff(Berserk)", (function() return NetherMachine.condition["buff.remains"]('player', 'Pulverize') <= (3 - NetherMachine.condition["debuff.count"]('target', 'Lacerate')) * 1.5 end) } },
	-- actions+=/incarnation
	{ "Incarnation: Son of Ursoc", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "player.health < 80" } },
	-- actions+=/lacerate,if=!ticking
	{ "Lacerate", "!target.debuff(Lacerate)" },
	-- actions+=/thrash_bear,if=!ticking
	{ "Thrash", { "toggle.cleave", "!target.debuff(Thrash)" } },
	-- actions+=/mangle
	{ "Mangle" },
	-- actions+=/thrash_bear,if=remains<=4.8
	{ "Thrash", { "toggle.cleave", "target.debuff(Thrash).remains <= 4.8" } },
	-- actions+=/lacerate
	{ "Lacerate" },

}, -- [Section Closing Curly Brace]
{
-- OUT OF COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	-- BUFFS
	{ "Mark of the Wild", { "!player.buffs.stats", "!modifier.last" } },

	-- REZ & HEAL
	{ "Revive", { "target.exists", "target.dead", "target.player", "!player.moving" }, "target" },
	{ "Rejuvenation", { "!player.buff(Prowl)", "!player.casting", "player.alive", "!player.buff(Rejuvenation)", "player.health <= 70" }, "player" },

	-- AUTO FORMS
	{ "pause", { "target.exists", "target.istheplayer" } },
	{ {
		{ "/cancelform", { "target.isfriendlynpc", "!player.form == 0", "!player.ininstance", "target.range <= 2" } },
		{ "pause", { "target.isfriendlynpc", "target.range <= 2" } },
		{ "Travel Form", { "!player.buff(Travel Form)", "!target.exists", "!player.ininstance", "player.moving", "player.outdoors" } },
		{ "Cat Form", { "!player.buff(Cat Form)", "!player.buff(Travel Form)", "!target.exists", "player.moving" } },
		{ "Bear Form", { "!player.buff(Bear Form)", "target.exists", "target.enemy", "target.distance < 30" } },
	},{
		"toggle.forms", "!player.flying", "!player.buff(Dash)",
	} },

	-- AUTO ATTACK
	{ {
		{ "Mark of the Wild", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Soothe", true, "target" },
	}, "toggle.autoattack" },

}, -- [Section Closing Curly Brace]

---- *** TOGGLE BUTTONS ***
function()
	NetherMachine.toggle.create('forms', 'Interface\\Icons\\ability_racial_bearform', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_nature_faeriefire', 'Use Mouseovers', 'Toggle usage of Faerie Fire on mouseover targets.')
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack units in range.')
	NetherMachine.toggle.create('cleave', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Cleave', 'Toggle the usage of multi target abilities when in single target mode.')
end)





-- SINGLE Target Rotation
-- Use Mangle on cooldown (its cooldown has a chance to be reset by Lacerate, so you need to watch out for this).
-- Use Lacerate until it has 3 stacks on the target.
-- Use Pulverize (consuming the Lacerate stacks).
-- Re-stack Lacerate to 3 before the 12-second buff from Pulverize expires.
-- Keep up the Thrash bleed (lasts 16 seconds).
-- Use Maul Icon Maul only when
-- you are under the effect of a Tooth and Claw proc;
-- you are at or very close to maximum Rage;
-- you do not need to use your active mitigation.
--
-- MULTIPLE Target Rotation
-- Keep up the Thrash bleed (lasts 16 seconds).
-- Use Lacerate until it has 3 stacks on the target.
-- Use Pulverize (consuming the Lacerate stacks).
-- Use Mangle on cooldown.
-- Re-stack Lacerate to 3 before the 12-second buff from Pulverize expires.
-- You will want to alternate using Mangle on various enemies, preferring those on which your threat is lowest.
