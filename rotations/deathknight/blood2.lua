-- NetherMachine Rotation
-- Blood Death Knight - WoD 6.0.3
-- Updated on Jan 19th 2015

-- PLAYER CONTROLLED:
-- TALENTS: 2013102 Plague Leech, Anti-Magic Zone, Death's Advance, Blood Tap, Death Pact, Gorefiend's Grasp
-- GLYPHS: Glyph of Vampiric Blood, Glyph of Anti-Magic Shell, Glyph of Icebound Fortitude  Minor: Glyph of Path of Frost
-- CONTROLS: Pause - Left Control, Death and Decay - Left Shift,  Death Grip Mouseover - Left Alt, Anti-Magic Zone - Right Shift, Army of the Dead - Right Control

NetherMachine.rotation.register_custom(250, "bbDeathKnight Blood (test)", {
	-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- FROGGING
	{ {
		{ "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
	}, "toggle.frogs" },

	-- AUTO TAUNT
	{ "Dark Command", { "toggle.autotaunt", "@bbLib.bossTaunt" } },

	-- INTERRUPTS
	{ "Dark Simulacrum", { "target.casting", "@bbLib.canDarkSimulacrum(target)" } },
	{ "Mind Freeze", "target.interruptsAt(40)" },
	{ "Asphyxiate", { "target.interruptsAt(40)", "!modifier.last(Mind Freeze)" } },
	{ "Asphyxiate", { "toggle.pvpmode", "target.health <= 30" } },
	{ "Strangulate", { "target.interruptsAt(40)", "!modifier.last(Mind Freeze)" } },

	-- Keybinds
	{ "Defile", { "modifier.lshift", "talent(7, 2)", "player.area(40).enemies > 0" }, "ground" },
	{ "Death and Decay", { "modifier.lshift", "!talent(7, 2)", "player.area(40).enemies > 0" }, "ground" },
	{ "Anti-Magic Zone", { "modifier.rshift", "player.area(40).enemies > 0" }, "ground" },
	{ "Army of the Dead", { "modifier.rcontrol", "player.area(40).enemies > 0" } },
	{ "Death Grip", { "modifier.lalt", "mouseover.threat < 100", "!target.spell(Death Strike).range", "!target.boss", "player.area(40).enemies > 0" }, "mouseover" },
	{ "Chains of Ice", { "modifier.ralt", "!target.boss", "player.area(40).enemies > 0" }, "mouseover" },

	-- UTILITY / SURVIVAL
	{ "Death's Advance", { "talent(3, 1)", "player.state.snare", "!modifier.last" } },
	{ "Death's Advance", { "talent(3, 1)", "player.state.root", "!modifier.last" } },
	{ "Anti-Magic Shell", { "player.health <= 60", (function() return UnitIsUnit('targettarget', 'player') end), "target.casting.time > 0" } },


	-- COOLDOWNS
	{ {
		-- actions=auto_attack
		-- actions+=/blood_fury
		{ "Blood Fury", "player.time > 10" },
		-- actions+=/berserking
		{ "Berserking", "player.time > 10" },
		-- actions+=/arcane_torrent
		{ "Arcane Torrent", "player.time > 10" },
		-- trinx
		{ "#trinket1", "player.hashero" },
		{ "#trinket2", "player.hashero" },
		-- actions+=/potion,name=draenic_armor,if=buff.potion.down&buff.blood_shield.down&!unholy&!frost
		{ "#109219", { "toggle.consume", "target.exists", "target.boss", "!player.buff(Blood Shield)", "player.runes(unholy).count == 0", "player.runes(frost).count == 0" } }, -- Draenic Strength Potion
		-- actions+=/antimagic_shell
		-- actions+=/conversion,if=!buff.conversion.up&runic_power>50&health.pct<90
		{ "Conversion", { "!player.buff(Conversion)", "player.runicpower > 50", "player.health < 80" } },
		-- actions+=/lichborne,if=health.pct<90
		{ "Lichborne", "player.health < 90" },
		-- actions+=/death_strike,if=incoming_damage_5s>=health.max*0.65
		{ "Death Strike", "player.health < 70" },
		-- actions+=/army_of_the_dead,if=buff.bone_shield.down&buff.dancing_rune_weapon.down&buff.icebound_fortitude.down&buff.vampiric_blood.down
		{ "Army of the Dead", { "!player.buff(Bone Shield)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Icebound Fortitude)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/bone_shield,if=buff.army_of_the_dead.down&buff.bone_shield.down&buff.dancing_rune_weapon.down&buff.icebound_fortitude.down&buff.vampiric_blood.down
		{ "Bone Shield", { "!player.buff(Army of the Dead)", "!player.buff(Bone Shield)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Icebound Fortitude)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/vampiric_blood,if=health.pct<50
		{ "Vampiric Blood", "player.health <= 50" },
		-- actions+=/icebound_fortitude,if=health.pct<30&buff.army_of_the_dead.down&buff.dancing_rune_weapon.down&buff.bone_shield.down&buff.vampiric_blood.down
		{ "Icebound Fortitude", { "player.health < 30", "!player.buff(Army of the Dead)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Bone Shield)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/rune_tap,if=health.pct<50&buff.army_of_the_dead.down&buff.dancing_rune_weapon.down&buff.bone_shield.down&buff.vampiric_blood.down&buff.icebound_fortitude.down
		{ "Rune Tap", { "player.health < 20", "!player.buff(Army of the Dead)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Bone Shield)", "!player.buff(Vampiric Blood)", "!player.buff(Icebound Fortitude)" } },
		-- actions+=/dancing_rune_weapon,if=health.pct<80&buff.army_of_the_dead.down&buff.icebound_fortitude.down&buff.bone_shield.down&buff.vampiric_blood.down
		{ "Dancing Rune Weapon", { "player.health < 80", "!player.buff(Army of the Dead)", "!player.buff(Icebound Fortitude)", "!player.buff(Bone Shield)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/death_pact,if=health.pct<50
		{ "Death Pact", "player.health < 50" },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive",
	} },

	-- THREAT ROTATION
	-- Initially, apply them with Outbreak Icon Outbreak.
	{ "Outbreak", { "!talent(7, 1)", "target.debuff(Frost Fever).remains < 8" } },
	{ "Outbreak", { "!talent(7, 1)", "target.debuff(Blood Plague).remains < 8" } },
	{ "Outbreak", { "talent(7, 1)", "target.debuff(Necrotic Plague).remains < 5" } },
	-- actions+=/plague_strike,if=(!talent.necrotic_plague.enabled&!dot.blood_plague.ticking)|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
	{ "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
	{ "Plague Strike", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
	-- actions+=/icy_touch,if=(!talent.necrotic_plague.enabled&!dot.frost_fever.ticking)|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
	{ "Icy Touch", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
	{ "Tcy Touch", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
	-- After that, always refresh them with Blood Boil Icon Blood Boil.
	{ "Blood Boil", { "target.debuff(Frost Fever)", "target.debuff(Blood Plague)", "player.runes(blood).count > 0", "target.debuff(Frost Fever).remains < 8" } },
	{ "Blood Boil", { "target.debuff(Frost Fever)", "target.debuff(Blood Plague)", "player.runes(blood).count > 0", "target.debuff(Blood Plague).remains < 8" } },
	{ "Blood Boil", { "target.debuff(Necrotic Plague)", "player.runes(blood).count > 0" } },
	-- Use your Frost, Unholy, and Death runes on Death Strike Icon Death Strike.
	{ "Death Strike", { "player.runes(Frost).count > 0" } },
	{ "Death Strike", { "player.runes(Unholy).count > 0" } },
	--Plague Leech should be used on cooldown. Make sure that both your Frost and Unholy rune pairs are depleted, and use Plague Leech to gain a Frost rune and an Unholy rune. Then, you can simply re-apply your diseases with Outbreak Icon Outbreak (using Glyph of Outbreak Icon Glyph of Outbreak, which removes the cooldown of the ability).
	{ "Breath of Sindragosa", { "player.runicpower > 50", "!player.buff(Breath of Sindragosa)", "!target.debuff(Mark of Sindragosa)", "!modifier.last", "player.area(9).enemies > 0" } },
	-- actions.single_target=plague_leech,if=(cooldown.outbreak.remains<1)&((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))
	{ "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "player.spell(Outbreak).cooldown < 2", "player.runes(frost).count == 0", "player.runes(unholy).count == 0", "player.runes(death).count < 4", "player.time > 5" } },
	{ "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "player.spell(Outbreak).cooldown < 2", "player.runes(frost).count == 0", "player.runes(unholy).count == 0", "player.runes(death).count < 4", "player.time > 5"  } },
	-- actions.single_target+=/plague_leech,if=((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))&disease.min_remains<3
	{ "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Blood Plague).remains < 3", "player.runes(frost).count == 0", "player.runes(unholy).count == 0", "player.runes(death).count < 4", "player.time > 5" } },
	{ "Plague Leech", { "!talent(7, 1)", "target.debuff(Blood Plague)", "target.debuff(Frost Fever)", "target.debuff(Frost Fever).remains < 3", "player.runes(frost).count == 0", "player.runes(unholy).count == 0", "player.runes(death).count < 4", "player.time > 5" } },
	{ "Plague Leech", { "talent(7, 1)", "target.debuff(Necrotic Plague)", "target.debuff(Necrotic Plague).remains < 3", "player.runes(frost).count == 0", "player.runes(unholy).count == 0", "player.runes(death).count < 4", "player.time > 5" } },
	-- bt
	--{ "Blood Tap", { "player.buff(Blood Charge).count > 10",  } },
	{ "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes(death).count == 0", "player.runes(unholy).count < 2", "player.runes(frost).count < 2" } },
	-- Use your Blood runes on Blood Boil Icon Blood Boil. Never use Blood Boil if you have no Blood runes, as this will cause it to consume a Death rune, which should be saved for Death Strike.
	{ "Blood Boil", { "target.health > 35", "target.debuff(Frost Fever)", "target.debuff(Blood Plague)", "player.runes(blood).count > 0" } },
	{ "Blood Boil", { "target.health > 35", "target.debuff(Necrotic Plague)", "player.runes(blood).count > 0" } },
	-- When the target is at or below 35% health, you should use your Blood runes on Soul Reaper Icon Soul Reaper (the goal being to use Soul Reaper on cooldown during this period).
	{ "Soul Reaper", { "target.health <= 35", "player.runes(blood).count > 0" } },
	-- Use your runic power on Death Coil Icon Death Coil to generate threat and dump runic power.
	{ "Death Coil", "player.runicpower > 50" },
	-- Use your Crimson Scourge Icon Crimson Scourge procs on Blood Boil Icon Blood Boil.
	{ "Blood Boil", { "target.debuff(Frost Fever)", "target.debuff(Blood Plague)", "player.buff(Crimson Scourge)", "player.area(7).enemies > 0" } },
	{ "Blood Boil", { "target.debuff(Necrotic Plague)", "player.buff(Crimson Scourge)", "player.area(7).enemies > 0" } },
	-- defile
	{ "Defile", { "talent(7, 2)", "!player.moving", "target.exists", "!target.moving", "!modifier.last" }, "target.ground" },
	{ "Death and Decay", { "!talent(7, 2)", "player.level < 100", "!player.moving", "target.exists", "!target.moving", "!modifier.last" }, "target.ground" },
	--
	{ "Empower Rune Weapon", { "player.runicpower < 75", "player.runes(death).count <= 2", "player.runes(unholy).count == 0", "player.runes(frost).count == 0", "player.time > 5" } },

},{
	-- OUT OF COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },

	-- Buffs
	{ "Blood Presence", "!player.buff(Blood Presence)" },
	{ "Horn of Winter", "!player.buffs.attackpower" },
	{ "Path of Frost", { "!player.buff(Path of Frost).any", "player.mounted" } },
	{ "Bone Shield", "!player.buff", "player" },

	-- Keybinds
	{ "Defile", { "modifier.lshift", "player.area(40).enemies > 0" }, "ground" },
	{ "Army of the Dead", { "target.boss", "modifier.rshift", "player.area(40).enemies > 0" } },
	{ "Death Grip", { "modifier.lalt", "player.area(40).enemies > 0" } },

	-- FROGGING
	{ {
		{ "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
		{ "Death Grip", true, "target" },
		{ "Mind Freeze", true, "target" },
		{ "Chains of Ice", true, "target" },
	}, "toggle.frogs" },

},function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Engage', 'Automatically target and attack any enemy units in range.')
end)








-- NetherMachine Rotation
-- Blood Death Knight - WoD 6.0.3
-- Updated on Jan 19th 2015

-- PLAYER CONTROLLED:
-- TALENTS: 2013102 Plague Leech, Anti-Magic Zone, Death's Advance, Blood Tap, Death Pact, Gorefiend's Grasp
-- GLYPHS: Glyph of Vampiric Blood, Glyph of Anti-Magic Shell, Glyph of Icebound Fortitude  Minor: Glyph of Path of Frost
-- CONTROLS: Pause - Left Control, Death and Decay - Left Shift,  Death Grip Mouseover - Left Alt, Anti-Magic Zone - Right Shift, Army of the Dead - Right Control

NetherMachine.rotation.register_custom(250, "bbDeathKnight Blood (OLD)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- FROGGING
	{ {
		{ "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
	}, "toggle.frogs" },

	-- AUTO TAUNT
	{ "Dark Command", { "toggle.autotaunt", "@bbLib.bossTaunt" } },

	-- INTERRUPTS
	{ "Dark Simulacrum", { "target.casting", "@bbLib.canDarkSimulacrum(target)" } },
	{ "Mind Freeze", "modifier.interrupts" },
	{ "Strangulate", "modifier.interrupts" },

	-- Keybinds
	{ "Death and Decay", { "modifier.lshift", "player.area(40).enemies > 0" }, "ground" },
	{ "Anti-Magic Zone", { "modifier.rshift", "player.area(40).enemies > 0" }, "ground" },
	{ "Army of the Dead", { "modifier.rcontrol", "player.area(40).enemies > 0" } },
	{ "Death Grip", { "modifier.lalt", "mouseover.threat < 100", "!target.spell(Death Strike).range", "!target.boss", "player.area(40).enemies > 0" }, "mouseover" },
	{ "Chains of Ice", { "modifier.ralt", "!target.boss", "player.area(40).enemies > 0" }, "mouseover" },

	-- UTILITY / SURVIVAL
	{ "Death's Advance", { "talent(3, 1)", "player.state.snare", "!modifier.last" } },
	{ "Death's Advance", { "talent(3, 1)", "player.state.root", "!modifier.last" } },
	{ "Anti-Magic Shell", { "player.health <= 70", (function() return UnitIsUnit('targettarget', 'player') end), "target.casting.time > 0" } },


	-- COOLDOWNS
	{ {
		-- actions=auto_attack
		-- actions+=/blood_fury
		{ "Blood Fury", "player.time > 10" },
		-- actions+=/berserking
		{ "Berserking", "player.time > 10" },
		-- actions+=/arcane_torrent
		{ "Arcane Torrent", "player.time > 10" },
		-- trinx
		{ "#trinket1", "player.hashero" },
		{ "#trinket2", "player.hashero" },
		-- actions+=/potion,name=draenic_armor,if=buff.potion.down&buff.blood_shield.down&!unholy&!frost
		{ "#109219", { "toggle.consume", "target.exists", "target.boss", "!player.buff(Blood Shield)", "player.runes(unholy).count == 0", "player.runes(frost).count == 0" } }, -- Draenic Strength Potion
		-- actions+=/antimagic_shell
		-- actions+=/conversion,if=!buff.conversion.up&runic_power>50&health.pct<90
		{ "Conversion", { "!player.buff(Conversion)", "player.runicpower > 50", "player.health < 90" } },
		-- actions+=/lichborne,if=health.pct<90
		{ "Lichborne", "player.health < 90" },
		-- actions+=/death_strike,if=incoming_damage_5s>=health.max*0.65
		{ "Death Strike", "player.health < 70" },
		-- actions+=/army_of_the_dead,if=buff.bone_shield.down&buff.dancing_rune_weapon.down&buff.icebound_fortitude.down&buff.vampiric_blood.down
		{ "Army of the Dead", { "!player.buff(Bone Shield)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Icebound Fortitude)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/bone_shield,if=buff.army_of_the_dead.down&buff.bone_shield.down&buff.dancing_rune_weapon.down&buff.icebound_fortitude.down&buff.vampiric_blood.down
		{ "Bone Shield", { "!player.buff(Army of the Dead)", "!player.buff(Bone Shield)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Icebound Fortitude)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/vampiric_blood,if=health.pct<50
		{ "Vampiric Blood", "player.health <= 50" },
		-- actions+=/icebound_fortitude,if=health.pct<30&buff.army_of_the_dead.down&buff.dancing_rune_weapon.down&buff.bone_shield.down&buff.vampiric_blood.down
		{ "Icebound Fortitude", { "player.health < 30", "!player.buff(Army of the Dead)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Bone Shield)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/rune_tap,if=health.pct<50&buff.army_of_the_dead.down&buff.dancing_rune_weapon.down&buff.bone_shield.down&buff.vampiric_blood.down&buff.icebound_fortitude.down
		{ "Rune Tap", { "player.health < 30", "!player.buff(Army of the Dead)", "!player.buff(Dancing Rune Weapon)", "!player.buff(Bone Shield)", "!player.buff(Vampiric Blood)", "!player.buff(Icebound Fortitude)" } },
		-- actions+=/dancing_rune_weapon,if=health.pct<80&buff.army_of_the_dead.down&buff.icebound_fortitude.down&buff.bone_shield.down&buff.vampiric_blood.down
		{ "Dancing Rune Weapon", { "player.health < 80", "!player.buff(Army of the Dead)", "!player.buff(Icebound Fortitude)", "!player.buff(Bone Shield)", "!player.buff(Vampiric Blood)" } },
		-- actions+=/death_pact,if=health.pct<50
		{ "Death Pact", "player.health < 50" },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive",
	} },

	-- THREAT ROTATION
	-- actions+=/outbreak,if=(!talent.necrotic_plague.enabled&disease.min_remains<8)|!disease.ticking
	{ "Outbreak", { "!talent(7, 1)", "target.debuff(Frost Fever).remains < 8" } },
	{ "Outbreak", { "!talent(7, 1)", "target.debuff(Blood Plague).remains < 8" } },
	{ "Outbreak", { "talent(7, 1)", "target.debuff(Necrotic Plague).remains < 5" } },
	-- actions+=/death_coil,if=runic_power>90
	{ "Death Coil", "player.runicpower > 90" },
	-- actions+=/plague_strike,if=(!talent.necrotic_plague.enabled&!dot.blood_plague.ticking)|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
	{ "Plague Strike", { "!talent(7, 1)", "!target.debuff(Blood Plague)" } },
	{ "Plague Strike", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
	-- actions+=/icy_touch,if=(!talent.necrotic_plague.enabled&!dot.frost_fever.ticking)|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
	{ "Icy Touch", { "!talent(7, 1)", "!target.debuff(Frost Fever)" } },
	{ "Tcy Touch", { "talent(7, 1)", "!target.debuff(Necrotic Plague)" } },
	-- actions+=/defile
	{ "Defile", { "talent(7, 2)", "!player.moving", "!target.moving" }, "target.ground" },
	{ "Death and Decay", { "!talent(7, 2)", "player.level < 100", "!player.moving", "!target.moving" }, "target.ground" },  --We do not advise you to use Death and Decay Icon Death and Decay in any of your rotations, because it is very weak
	-- actions+=/death_strike,if=(unholy=2|frost=2)
	{ "Death Strike", { "player.runes(unholy).count == 2" } },
	{ "Death Strike", { "player.runes(frost).count == 2" } },
	{ "Death Strike", { "player.runes(unholy).count > 0", "player.runes(frost).count > 0", "player.health < 90" } },
	-- actions+=/death_coil,if=runic_power>70
	{ "Death Coil", "player.runicpower > 70" },
	-- actions+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35&blood>=1
	{ "Soul Reaper", { "target.health < 35", "player.runes(blood).count >= 1" } },
	-- actions+=/blood_boil,if=blood=2
	{ "Blood Boil", { "player.runes(blood).count == 2", "player.area(7).enemies > 0", "!modifier.last" } },
	{ "Blood Boil", { "player.buff(Crimson Scourge)", "player.area(7).enemies > 0", "!modifier.last" } },
	-- actions+=/blood_tap
	{ "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runes.depleted.count > 0", "!modifier.last" } },
	-- actions+=/death_coil
	{ "Death Coil", "player.runicpower > 50" },
	-- actions+=/empower_rune_weapon,if=!blood&!unholy&!frost
	{ "Empower Rune Weapon", { "player.runes(blood).count == 0", "player.runes(unholy).count == 0", "player.runes(frost).count == 0" } },

},{
-- OUT OF COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },

	-- Buffs
	{ "Blood Presence", "!player.buff(Blood Presence)" },
	{ "Horn of Winter", "!player.buffs.attackpower" },
	{ "Path of Frost", { "!player.buff(Path of Frost).any", "player.mounted" } },
	{ "Bone Shield", "!player.buff", "player" },

	-- Keybinds
	{ "Army of the Dead", { "target.boss", "modifier.rshift", "player.area(40).enemies > 0" } },
	{ "Death Grip", { "modifier.lalt", "player.area(40).enemies > 0" } },

	-- FROGGING
	{ {
		{ "Path of Frost", "@bbLib.engaugeUnit('ANY', 30, false)" },
		{ "Death Grip", true, "target" },
		{ "Mind Freeze", true, "target" },
		{ "Chains of Ice", true, "target" },
	}, "toggle.frogs" },

},
function ()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Engage', 'Automatically target and attack any enemy units in range.')
end)
