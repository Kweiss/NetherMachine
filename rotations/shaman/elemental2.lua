-- NetherMachine Rotation
-- Elemental Shaman Rotation for WoD 6.0.3
-- Updated on Jan 8th 2015

-- PLAYER CONTROLLED SPELLS: Earthgrab Totem, Totemic Projection, Bloodlust
-- SUGGESTED TALENTS: 0001011 Astral Shift, Earthgrab Totem, Totemic Projection, Elemental Mastery, Ancestral Guidance, Unleashed Fury, Elemental Fusion
-- SUGGESTED GLYPHS: Chain Lightning, Spiritwalker's Grace, Ghostly Speed(minor)
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(262, "bbShaman Elemental (SimC T17N)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	-- FROGING
	{ {
		{ "Water Walking", "@bbLib.engaugeUnit('ANY', 40, false)" },
	}, "toggle.autoattack" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- BOSS MODS
	--{ "Feign Death", { "modifier.raid", "target.exists", "target.enemy", "target.boss", "target.agro", "target.distance < 30" } },
	--{ "Feign Death", { "modifier.raid", "player.debuff(Aim)", "player.debuff(Aim).duration > 3" } }, --SoO: Paragons - Aim

	-- INTERRUPTS / DISPELLS
	{ "Wind Shear", "modifier.interrupt" },
	{ "Wind Shear", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },

	-- UTILITY
	-- Capacitor Totem: Handy to stun groups (8yd)
	-- Cleanse Spirit: Removes curses
	-- Earthbind Totem: Slows enemies within 10yds. Becomes Earthgrab Totem when talent(2, 2)
	-- Frost Shock: Not that useful for Elemental as it conflicts with Earth & Flame Shocks
	-- Ghost Wolf: Handy to cover distances quickly mid fight
	-- Grounding Totem: Redirects one single target spell to the totem.
	-- Purge removes 1 beneficial magic effect from the target enemy
	-- Tremor Totem: Removes Charm, Fear & Sleep effects from party. Cannot be used while you are under the effects of one of these, so use to dispel allies or drop it in advance.
	-- Thunderstorm: Handy for knocking enemies away, towards tanks or off cliffs.
	-- Water Walking: Allows the target to walk on water.

	-- Defensive Cooldowns
	{ "Astral Shift", { "player.health < 30", "talent(1, 3)" } },
	-- Shamanistic Rage: Reduces damage taken by 30% Usable when stunned
	{ "Healing Stream Totem", { "!player.moving", "player.health < 100" } },
	{ "Healing Surge", { "!player.moving", "player.health < 70", "!modifier.raid" }, "player" },

	-- Pre DPS Pause
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- Mouseovers
	{ "Flame Shock", { "toggle.mouseovers", "mouseover.enemy", "mouseover.alive", "!mouseover.debuff(Flame Shock)", "mouseover.combat", "mouseover.deathin > 20", }, "mouseover" },

	-- COOLDOWNS
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	{ "#trinket1" },
	{ "#trinket2" },
	-- actions+=/potion,name=draenic_intellect,if=buff.ascendance.up|target.time_to_die<=30
	{ "#109218", { "modifier.cooldowns", "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Intellect Potion (109218)
	{ "#109218", { "modifier.cooldowns", "toggle.consume", "target.boss", "player.buff(Ascendance)" } }, -- Draenic Intellect Potion (109218)
	{ "#109218", { "modifier.cooldowns", "toggle.consume", "target.boss", "target.deathin <= 30" } }, -- Draenic Intellect Potion (109218)
	-- actions+=/berserking,if=!buff.bloodlust.up&!buff.elemental_mastery.up&(set_bonus.tier15_4pc_caster=1|(buff.ascendance.cooldown_remains=0&(dot.flame_shock.remains>buff.ascendance.duration|level<87)))
	{ "Berserking", { "modifier.cooldowns", "!player.hashero", "!player.buff(Elemental Mastery)", "player.spell(Asecendance).cooldown == 0", "player.level < 87" } },
	{ "Berserking", { "modifier.cooldowns", "!player.hashero", "!player.buff(Elemental Mastery)", "player.spell(Asecendance).cooldown == 0", "target.debuff(Flame Shock).remains > 15" } },
	-- actions+=/blood_fury,if=buff.bloodlust.up|buff.ascendance.up|((cooldown.ascendance.remains>10|level<87)&cooldown.fire_elemental_totem.remains>10)
	{ "Blood Fury", { "modifier.cooldowns", "player.hashero" } },
	{ "Blood Fury", { "modifier.cooldowns", "player.buff(Ascendance)" } },
	{ "Blood Fury", { "modifier.cooldowns", "player.spell(Ascendance).cooldown > 10", "player.spell(Fire Elemental Totem).cooldown > 10" } },
	{ "Blood Fury", { "modifier.cooldowns", "player.level < 87", "player.spell(Fire Elemental Totem).cooldown > 10" } },
	-- actions+=/arcane_torrent
	{ "Arcane Torrent" },
	-- actions+=/elemental_mastery,if=action.lava_burst.cast_time>=1.2
	{ "Elemental Mastery", { "modifier.cooldowns", "player.spell(Lava Burst).castingtime >= 1.2" } },
	-- actions+=/ancestral_swiftness,if=!buff.ascendance.up
	{ "Ancestral Swiftness", { "modifier.cooldowns", "!player.buff(Ascendance)" } },
	-- actions+=/storm_elemental_totem
	{ "Storm Elemental Totem", "modifier.cooldowns" },
	-- actions+=/fire_elemental_totem,if=!active
	{ "Fire Elemental Totem", { "modifier.cooldowns", "!player.totem(Fire Elemental Totem)" } },
	-- actions+=/ascendance,if=active_enemies>1|(dot.flame_shock.remains>buff.ascendance.duration&(target.time_to_die<20|buff.bloodlust.up|time>=60)&cooldown.lava_burst.remains>0)
	{ "Ascendance", { "modifier.cooldowns", "target.area(8).enemies > 1" } },
	{ "Ascendance", { "modifier.cooldowns", "target.debuff(Flame Shock).duration > 15", "player.spell(Lava Burst).cooldown > 0", "target.boss", "target.deathin < 20" } },
	{ "Ascendance", { "modifier.cooldowns", "target.debuff(Flame Shock).duration > 15", "player.spell(Lava Burst).cooldown > 0", "player.hashero" } },
	{ "Ascendance", { "modifier.cooldowns", "target.debuff(Flame Shock).duration > 15", "player.spell(Lava Burst).cooldown > 0", "player.time >= 60" } },
	-- actions+=/liquid_magma,if=pet.searing_totem.remains>=15|pet.fire_elemental_totem.remains>=15
	{ "Liquid Magma", { "modifier.cooldowns", "player.totem(Searing Totem).duration >= 15" } },
	{ "Liquid Magma", { "modifier.cooldowns", "player.totem(Fire Elemental Totem).duration >= 15" } },

	-- MULTIPLE TARGET ROTATION
	{ {
		-- actions.aoe=earthquake,cycle_targets=1,if=!ticking&(buff.enhanced_chain_lightning.up|level<=90)&active_enemies>=2
		{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "player.buff(Enhanced Chain Lightning)" }, "target.ground" },
		{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "player.level <= 90" }, "target.ground" },
		-- actions.aoe+=/lava_beam
		{ "Lava Beam" },
		-- actions.aoe+=/earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
		{ "Earth Shock", "player.buff(Lightning Shield).count == 20", "!modifier.last" },
		-- actions.aoe+=/thunderstorm,if=active_enemies>=10
		{ "Thunderstorm", "player.area(10).enemies >= 10" },
		-- actions.aoe+=/searing_totem,if=(!talent.liquid_magma.enabled&!totem.fire.active)|(talent.liquid_magma.enabled&pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up)
		{ "Searing Totem", { "!talent(7, 3)", "!player.totem(Searing Totem)", "!player.totem(Fire Elemental Totem)" } },
		{ "Searing Totem", { "talent(7, 3)", "player.totem(Searing Totem).duration <= 20", "!player.totem(Fire Elemental Totem)", "!player.buff(Liquid Magma)" } },
		-- actions.aoe+=/chain_lightning,if=active_enemies>=2
		{ "Chain Lightning", "!player.moving" },
		-- actions.aoe+=/lightning_bolt
		{ "Lightning Bolt" },
	},{
		"modifier.multitarget", "target.area(8).enemies > 1",
	} },

	-- SINGLE TARGET ROTATION
	-- actions.single=unleash_flame,moving=1
	{ "Unleash Flame", { "target.exists", "player.movingfor > 1" } },
	-- actions.single+=/spiritwalkers_grace,moving=1,if=buff.ascendance.up
	{ "Spiritwalker's Grace", { "player.movingfor > 1", "player.buff(Ascendance)" } },
	-- actions.single+=/earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
	{ "Earth Shock", { "player.level >= 92", "player.buff(Lightning Shield).count > 19", "!modifier.last" } },
	{ "Earth Shock", { "player.level < 92", "player.buff(Lightning Shield).count > 9", "!modifier.last" } },
	-- actions.single+=/lava_burst,if=dot.flame_shock.remains>cast_time&(buff.ascendance.up|cooldown_react)
	{ "Lava Burst", { "!player.moving", (function() return NetherMachine.condition["debuff.remains"]('target', 'Flame Shock') > NetherMachine.condition["spell.castingtime"]('player', 'Lava Burst') end) } },
	-- actions.single+=/unleash_flame,if=talent.unleashed_fury.enabled&!buff.ascendance.up
	{ "Unleash Flame", { "talent(6, 1)", "!player.buff(Ascendance)" } },
	-- actions.single+=/flame_shock,if=dot.flame_shock.remains<=9
	{ "Flame Shock", "target.debuff(Flame Shock).remains <= 9" },
	-- actions.single+=/earth_shock,if=(set_bonus.tier17_4pc&buff.lightning_shield.react>=15&!buff.lava_surge.up)|(!set_bonus.tier17_4pc&buff.lightning_shield.react>15)
	{ "Earth Shock", { "player.buff(Lightning Shield).count > 15", "!modifier.last" } },
	-- actions.single+=/earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&buff.elemental_mastery.down&buff.bloodlust.down
	-- actions.single+=/earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=1.3*(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.up|buff.bloodlust.up)
	-- actions.single+=/earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.remains>=10|buff.bloodlust.remains>=10)
	-- actions.single+=/earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&buff.elemental_mastery.down&buff.bloodlust.down
	--{ "Earthquake", { "talent(6, 1)", "target.deathin > 10", "!player.buff(Elemental Mastery)", "!player.hashero", (function() return (1+GetCombatRating(CR_HASTE_SPELL))*(1+(GetCombatRating(CR_MASTERY)*2%4.5)) >= ((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*GetMultistrike()%100)) end) }, "target.ground" },
	-- actions.single+=/earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=1.3*((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.up|buff.bloodlust.up)
	--{ "Earthquake", { "talent(6, 1)", "target.deathin > 10", "player.buff(Elemental Mastery)", (function() return (1+GetCombatRating(CR_HASTE_SPELL))*(1+(GetCombatRating(CR_MASTERY)*2%4.5)) >= 1.3*((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*GetMultistrike()%100)) end) }, "target.ground" },
	--{ "Earthquake", { "talent(6, 1)", "target.deathin > 10", "player.hashero", (function() return (1+GetCombatRating(CR_HASTE_SPELL))*(1+(GetCombatRating(CR_MASTERY)*2%4.5)) >= 1.3*((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*GetMultistrike()%100)) end) }, "target.ground" },
	-- actions.single+=/earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.remains>=10|buff.bloodlust.remains>=10)
	--{ "Earthquake", { "talent(6, 1)", "target.deathin > 10", "player.buff(Elemental Mastery).remains >= 10", (function() return (1+GetCombatRating(CR_HASTE_SPELL))*(1+(GetCombatRating(CR_MASTERY)*2%4.5)) >= ((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*GetMultistrike()%100)) end) }, "target.ground" },
	--{ "Earthquake", { "talent(6, 1)", "target.deathin > 10", "player.hashero.remains >= 10", (function() return (1+GetCombatRating(CR_HASTE_SPELL))*(1+(GetCombatRating(CR_MASTERY)*2%4.5)) >= ((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*GetMultistrike()%100)) end) }, "target.ground" },
	{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "target.deathin > 10", "player.buff(Enhanced Chain Lightning)" }, "target.ground" },
	{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "target.deathin > 10", "player.buff(Elemental Mastery).remains >= 10" }, "target.ground" },
	{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "target.deathin > 10", "player.hashero.remains >= 10" }, "target.ground" },
	-- actions.single+=/elemental_blast
	{ "Elemental Blast" },
	-- actions.single+=/flame_shock,if=time>60&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<duration
	{ "Flame Shock", { "player.time > 60", "target.debuff(Flame Shock).remains <= 15", "player.spell(Ascendance).cooldown < 15" } },
	-- actions.single+=/searing_totem,if=(!talent.liquid_magma.enabled&!totem.fire.active)|(talent.liquid_magma.enabled&pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up)
	{ "Searing Totem", { "!talent(7, 3)", "!player.totem(Searing Totem)", "!player.totem(Fire Elemental Totem)" } },
	{ "Searing Totem", { "talent(7, 3)", "player.totem(Searing Totem).duration <= 20", "!player.totem(Fire Elemental Totem)", "!player.buff(Liquid Magma)" } },
	-- actions.single+=/spiritwalkers_grace,moving=1,if=((talent.elemental_blast.enabled&cooldown.elemental_blast.remains=0)|(cooldown.lava_burst.remains=0&!buff.lava_surge.react))
	{ "Spiritwalker's Grace", { "player.movingfor > 1", "talent(6, 3)", "player.spell(Elemental Blast).cooldown = 0" } },
	{ "Spiritwalker's Grace", { "player.movingfor > 1", "player.spell(Lava Burst).cooldown == 0", "!player.buff(Lava Surge)" } },
	-- actions.single+=/lightning_bolt
	{ "Lightning Bolt" },

}, {
-- OUT OF COMBAT ROTATION
	-- Pause
	{ "pause", "modifier.lcontrol" },
	{ "pause", "player.buff(Food)" },

	-- Buffs
	{ "Lightning Shield", "!player.buff(Lightning Shield)" },

	-- Heal
	{ "Healing Stream Totem", { "!player.moving", "player.health < 80" } },
	{ "Healing Surge", { "!player.moving", "player.health < 80" }, "player" },

	{ "Ghost Wolf", { "player.moving", "!player.buff" } },

	{ {
		{ "Water Walking", "@bbLib.engaugeUnit('ANY', 40, false)" },
		{ "Flame Shock", true, "target" },
		{ "Searing Totem", "!player.totem(Searing Totem)" },
	}, "toggle.autoattack" },

},
function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_fire_flameshock', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Gulp Frog Mode', 'Automaticly target and follow Gulp autoattack.')
end)










-- NetherMachine Rotation
-- Custom Elemental Shaman Rotation
-- Updated on Oct 18th 2014
-- PLAYER CONTROLLED SPELLS: Earthgrab Totem, Totemic Projection, Bloodlust
-- SUGGESTED TALENTS: Astral Shift, Earthgrab Totem, Totemic Projection, Elemental Mastery, Ancestral Guidance, Unleashed Flame
-- SUGGESTED GLYPHS: Chain Lightning, Spiritwalker's Grace, (Your/Encounter Choice), Ghostly Speed(minor)
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(262, "bbShaman Elemental (OLD)", {
	-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },


	-- FROGING
	{ {
		{ "Water Walking", "@bbLib.engaugeUnit('ANY', 40, false)" },
	}, "toggle.autoattack" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- BOSS MODS
	--{ "Feign Death", { "modifier.raid", "target.exists", "target.enemy", "target.boss", "target.agro", "target.distance < 30" } },
	--{ "Feign Death", { "modifier.raid", "player.debuff(Aim)", "player.debuff(Aim).duration > 3" } }, --SoO: Paragons - Aim

	-- INTERRUPTS / DISPELLS
	{ "Wind Shear", "modifier.interrupt" },
	{ "Wind Shear", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },

	-- UTILITY
	-- Capacitor Totem: Handy to stun groups (8yd)
	-- Cleanse Spirit: Removes curses
	-- Earthbind Totem: Slows enemies within 10yds. Becomes Earthgrab Totem when talent(2, 2)
	-- Frost Shock: Not that useful for Elemental as it conflicts with Earth & Flame Shocks
	-- Ghost Wolf: Handy to cover distances quickly mid fight
	-- Grounding Totem: Redirects one single target spell to the totem.
	-- Purge removes 1 beneficial magic effect from the target enemy
	-- Tremor Totem: Removes Charm, Fear & Sleep effects from party. Cannot be used while you are under the effects of one of these, so use to dispel allies or drop it in advance.
	-- Thunderstorm: Handy for knocking enemies away, towards tanks or off cliffs.
	-- Water Walking: Allows the target to walk on water.

	-- Defensive Cooldowns
	{ "Astral Shift", { "player.health < 30", "talent(1, 3)" } },
	-- Shamanistic Rage: Reduces damage taken by 30% Usable when stunned
	{ "Healing Stream Totem", { "!player.moving", "player.health < 100" } },
	{ "Healing Surge", { "!player.moving", "player.health < 70", "!modifier.raid" }, "player" },

	-- Pre DPS Pause
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- Mouseovers
	{ "Flame Shock", { "toggle.mouseovers", "mouseover.enemy", "mouseover.alive", "!mouseover.debuff(Flame Shock)", "mouseover.deathin > 20", }, "mouseover" },

	-- COMMON / COOLDOWNS
-- actions+=/potion,name=draenic_intellect,if=buff.ascendance.up|target.time_to_die<=30
	{ "#109218", { "modifier.cooldowns", "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Intellect Potion (109218)
	--{ "#109218", { "modifier.cooldowns", "toggle.consume", "target.boss", "player.buff(Ascendance)" } }, -- Draenic Intellect Potion (109218)
	--{ "#109218", { "modifier.cooldowns", "toggle.consume", "target.boss", "target.deathin <= 30" } }, -- Draenic Intellect Potion (109218)
-- actions+=/berserking,if=!buff.bloodlust.up&!buff.elemental_mastery.up&(set_bonus.tier15_4pc_caster=1|(buff.ascendance.cooldown_remains=0&(dot.flame_shock.remains>buff.ascendance.duration|level<87)))
	{ "Berserking", { "modifier.cooldowns", "!player.hashero", "!player.buff(Elemental Mastery)" } },
	{ "Blood Fury", { "modifier.cooldowns", "player.hashero" } },
	{ "Blood Fury", { "modifier.cooldowns", "player.buff(Ascendance)" } },
	{ "Blood Fury", { "modifier.cooldowns", "player.spell(Ascendance).cooldown > 10", "player.spell(Fire Elemental Totem).cooldown > 10" } },
	{ "Blood Fury", { "modifier.cooldowns", "player.level < 87", "player.spell(Fire Elemental Totem).cooldown > 10" } },
	{ "Arcane Torrent" },
	{ "Elemental Mastery", "modifier.cooldowns" },
	{ "Ancestral Swiftness", "!player.buff(Ascendance)" },
	{ "Storm Elemental Totem", "modifier.cooldowns" },
	{ "Fire Elemental Totem", { "modifier.cooldowns", "!player.totem(Fire Elemental Totem)" } },
-- actions+=/ascendance,if=active_enemies>1|(dot.flame_shock.remains>buff.ascendance.duration&(target.time_to_die<20|buff.bloodlust.up|time>=60)&cooldown.lava_burst.remains>0)
	{ "Ascendance", { "modifier.cooldowns", "target.area(8).enemies > 1" } },
	{ "Ascendance", { "modifier.cooldowns", "target.debuff(Flame Shock).duration > 15", "player.spell(Lava Burst).cooldown > 0", "target.deathin < 20" } },
	{ "Ascendance", { "modifier.cooldowns", "target.debuff(Flame Shock).duration > 15", "player.spell(Lava Burst).cooldown > 0", "player.hashero" } },
	{ "Ascendance", { "modifier.cooldowns", "target.debuff(Flame Shock).duration > 15", "player.spell(Lava Burst).cooldown > 0", "player.time >=60" } },
	{ "Liquid Magma", { "modifier.cooldowns", "player.totem(Searing Totem).duration >= 15" } },
	{ "Liquid Magma", { "modifier.cooldowns", "player.totem(Fire Elemental Totem).duration >= 15" } },

	-- AOE
	{ {
		{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "player.buff(Enhanced Chain Lightning)" }, "target.ground" },
		{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "player.level < 91" }, "target.ground" },
		{ "Lava Beam" },
		-- actions.aoe+=/earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
		{ "Earth Shock", "player.buff(Lightning Shield).count > 14" },
		{ "Thunderstorm", "player.area(10).enemies > 9" },
		{ "Searing Totem", { "!talent(7, 3)", "!player.totem(Searing Totem)", "!player.totem(Fire Elemental Totem)" } },
		{ "Searing Totem", { "talent(7, 3)", "player.totem(Searing Totem).duration <= 20", "!player.totem(Fire Elemental Totem)", "!player.buff(Liquid Magma)" } },
		{ "Chain Lightning", "!player.moving" },
		{ "Lightning Bolt" },
	},{
		"modifier.multitarget", "target.area(8).enemies > 1",
	} },

-- SINGLE TARGET
	{ "Unleash Flame", { "talent(6, 1)", "!player.buff(Ascendance)" } },
	{ "Spiritwalker's Grace", { "player.movingfor > 1", "player.buff(Ascendance)" } },
-- actions.single+=/earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
	{ "Earth Shock", { "player.level > 91", "player.buff(Lightning Shield).count > 9"} },
	{ "Earth Shock", { "player.level < 92", "player.buff(Lightning Shield).count > 4"} },
-- actions.single+=/lava_burst,if=dot.flame_shock.remains>cast_time&(buff.ascendance.up|cooldown_react)
	{ "Lava Burst", { "!player.moving", "target.debuff(Flame Shock).duration > 2" } },
	{ "Flame Shock", "target.debuff(Flame Shock).duration <= 9" },
-- actions.single+=/earth_shock,if=(set_bonus.tier17_4pc&buff.lightning_shield.react>=15&!buff.lava_surge.up)|(!set_bonus.tier17_4pc&buff.lightning_shield.react>15)
	{ "Earth Shock", { "player.buff(Lightning Shield).duration > 15"} },
-- actions.single+=/earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&buff.elemental_mastery.down&buff.bloodlust.down
-- actions.single+=/earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=1.3*(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.up|buff.bloodlust.up)
-- actions.single+=/earthquake,if=!talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=(1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.remains>=10|buff.bloodlust.remains>=10)
-- actions.single+=/earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&buff.elemental_mastery.down&buff.bloodlust.down
-- actions.single+=/earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=1.3*((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.up|buff.bloodlust.up)
-- actions.single+=/earthquake,if=talent.unleashed_fury.enabled&((1+stat.spell_haste)*(1+(mastery_value*2%4.5))>=((1.3*1.875)+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100)))&target.time_to_die>10&(buff.elemental_mastery.remains>=10|buff.bloodlust.remains>=10)
	-- GetCombatRating(CR_HASTE_SPELL)
	-- UnitSpellHaste("player")
	--(function() return ((1+stat.spell_haste)*(1+(GetMastery()*2%4.5)) >= (1.875+(1.25*0.226305)+1.25*(2*0.226305*stat.multistrike_pct%100))) end)
	{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "target.deathin > 10", "!player.buff(Elemental Mastery)", "!player.hashero" } , "target.ground" },
	{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "target.deathin > 10", "player.buff(Elemental Mastery).duration >= 10" } , "target.ground" },
	{ "Earthquake", { "target.alive", "!target.moving", "!player.moving", "!target.debuff(Earthquake)", "target.deathin > 10", "player.hashero.remains >= 10" } , "target.ground" },
	{ "Elemental Blast" },
	-- actions.single+=/flame_shock,if=time>60&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<duration
	--{ "Flame Shock", { "player.time > 60", "target.debuff(Flame Shock).duration <= 15" } },
	{ "Searing Totem", { "!talent(7, 3)", "!player.totem(Searing Totem)", "!player.totem(Fire Elemental Totem)" } },
	{ "Searing Totem", { "talent(7, 3)", "player.totem(Searing Totem).duration <= 20", "!player.totem(Fire Elemental Totem)", "!player.buff(Liquid Magma)" } },
	{ "Spiritwalker's Grace", { "player.movingfor > 1", "talent(6, 3)", "player.spell(Elemental Blast).cooldown = 0" } },
	{ "Spiritwalker's Grace", { "player.movingfor > 1", "player.spell(Lava Burst).cooldown = 0", "!player.buff(Lava Surge)" } },
	{ "Lightning Bolt" },

}, {
-- OUT OF COMBAT ROTATION
	-- Pause
	{ "pause", "modifier.lcontrol" },
	{ "pause", "player.buff(Food)" },

	-- Buffs
	{ "Lightning Shield", "!player.buff(Lightning Shield)" },

	-- Heal
	{ "Healing Stream Totem", { "!player.moving", "player.health < 80" } },
	{ "Healing Surge", { "!player.moving", "player.health < 80" }, "player" },

	{ {
		{ "Water Walking", "@bbLib.engaugeUnit('ANY', 40, false)" },
		{ "Flame Shock", true, "target" },
		{ "Searing Totem", "!player.totem(Searing Totem)" },
	}, "toggle.autoattack" },

},
function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_fire_flameshock', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Gulp Frog Mode', 'Automaticly target and follow Gulp autoattack.')
end)














NetherMachine.rotation.register_custom(262, "bbShaman Elemental (Experimental)", {
---------------------------
--       MODIFIERS       --
---------------------------
{"/cancelaura Ghost Wolf",{"!player.moving", "player.buff(Ghost Wolf)"}},
{"/cancelaura Ghost Wolf",{"player.buff(79206)", "player.buff(Ghost Wolf)"}},
{"/cancelaura Ghost Wolf",{"player.buff(Lava Surge)", "player.buff(Ghost Wolf)"}},
{"/cancelaura Ghost Wolf",{"!player.spell(Earth Shock).cooldown","player.buff(Lightning Shield).count >= 13","target.debuff(Flame Shock).duration >= 9", "player.buff(Ghost Wolf)"}},

{"Earth Shock",{"player.buff(Lightning Shield).count >= 15", "target.range <= 40","target.debuff(Flame Shock).duration >= 9" },"target" },

{"!Ancestral Guidance",{"modifier.lalt","talent(5,2)"},"player"},
{"!Healing Rain",{"modifier.lalt","talent(5,3)"},"mouseover.ground"},
{"!Ascendance",{"modifier.lcontrol"},"player"},
{ "#trinket1",{"player.buff(Ascendance)" },"player"},
{ "#trinket2",{"player.buff(Ascendance)" },"player"},
{ "Elemental Mastery",{"player.buff(Ascendance)" },"player"},
{ "Fire Elemental Totem",{"player.buff(Ascendance)" },"player"},
{ "Blood Fury",{"player.buff(Ascendance)" },"player"},
{ "Berserking",{"player.buff(Ascendance)" },"player"},

{{	-- Cooldowns (thanks to Ake for this section)
	{ "Ancestral Swiftness" },
	{ "Fire Elemental Totem" },
	{ "Storm Elemental Totem" },
	{ "Elemental Mastery" },
	{ "#trinket1", { "player.buff(Ascendance)" } },
	{ "#trinket2", { "player.buff(Ascendance)" } },
	{ "Ascendance", { "!player.buff(Ascendance)"},"player" },
}, "modifier.cooldowns" },

---------------------------
--     SURVIVAL/misc     --
---------------------------
{ "Lightning Shield",{"!player.buff(Lightning Shield)" },"player"},
{"Windwalk Totem",{"!player.buff","player.state.root","!player.totem(Windwalk Totem)","talent(2,3)"},"player"},
{"Windwalk Totem",{"!player.buff","player.state.snare","!player.totem(Windwalk Totem)","talent(2,3)"},"player"},
{"Shamanistic Rage",{"player.health <= 70"},"player"},
{"Astral Shift",{"player.health <= 55","talent(1,3)"},"player"},
{"Stone Bulwark Totem",{"player.health <= 55","talent(1,2)"},"player"},
{ "#5512", "player.health <= 35","player" },  --healthstone
{ "Stoneform", "player.health <= 65" },
{ "Gift of the Naaru", "player.health <= 70", "player" },
{ "Spiritwalker's Grace", { "player.buff(Ascendance)","player.moving"},"player" },

---------------------------
--INTERRUPT & SPELLSTEAL--
---------------------------
{ "Wind Shear", {"modifier.interrupt","target.range <= 25","target.enemy"},"target" },

---------------------------
--  Keep Up Flameshock   --
---------------------------
{"Flame Shock",{"target.debuff(Flame Shock).duration <= 6","target.enemy","target.range <= 40"},"target"},
{{
{"Flame Shock",{"boss1.debuff(Flame Shock).duration <= 6","boss1.enemy","boss1.range <= 40"},"boss1"},
{"Flame Shock",{"boss2.debuff(Flame Shock).duration <= 6","boss2.enemy","boss2.range <= 40"},"boss2"},
{"Flame Shock",{"boss3.debuff(Flame Shock).duration <= 6","boss3.enemy","boss3.range <= 40"},"boss3"},
{"Flame Shock",{"boss4.debuff(Flame Shock).duration <= 6","boss4.enemy","boss4.range <= 40"},"boss4"},
{"Flame Shock",{"boss5.debuff(Flame Shock).duration <= 6","boss5.enemy","boss5.range <= 40"},"boss5"},
},"!player.buff(Ascendance)"},
{"Flame Shock",{"player.buff(Unleash Flame)","target.debuff(Flame Shock).duration < 19","target.range <= 40" },"target" },

---------------------------
--     AOE ROTATION     --
---------------------------
{{
{"Lava Beam",{ "player.buff(Ascendance)","target.range <= 40","!player.moving" },"target" },
{"Lava Beam",{ "player.buff(Ascendance)","target.range <= 40","player.buff(79206)" },"target" },
{"Earthquake", {"player.buff(Improved Chain Lightning)","!player.moving"}, "target.ground" },
{"Earthquake", {"player.buff(Improved Chain Lightning)","player.buff(79206)"}, "target.ground" },
{"Earth Shock",{"player.buff(Lightning Shield).count >= 18","target.range <= 40" },"target" },
{"Chain Lightning",{"target.range <= 40","!player.moving" },"target" },
{"Chain Lightning",{"target.range <= 40","player.buff(79206)" },"target" },
},"toggle.AoESpam"},
---------------------------
-- SINGLE TARGET/Cleave  --
---------------------------
{ "Elemental Blast", { "player.buff(Ancestral Swiftness)","target.range <= 40" },"target" },
{ "Lava Burst", { "player.buff(Ancestral Swiftness)","target.range <= 40" },"target" },
{ "Lava Burst", { "player.buff(Lava Surge)","target.range <= 40" },"target" },
{ "Unleash Flame", { "talent(6, 1)" } },
{"Lava Burst",{"!player.moving","target.range <= 40"},"target"},
{"Lava Burst",{"player.buff(79206)","target.range <= 40"},"target"},
{"Elemental Blast",{"!player.moving","target.range <= 40"},"target"},
{"Elemental Blast",{"player.buff(79206)","target.range <= 40"},"target"},
{"Earth Shock",{"player.buff(Lightning Shield).count >= 15", "target.range <= 40","target.debuff(Flame Shock).duration >= 9" },"target" },
{"Earth Shock",{"!player.buff(79206)","player.moving","player.buff(Lightning Shield).count >= 10", "target.range <= 40","target.debuff(Flame Shock).duration >= 9" },"target" },
{"Searing Totem", { "!player.totem(Fire Elemental Totem)", "!player.totem(Searing Totem)"} },
{"Earthquake", {"modifier.multitarget","player.buff(Improved Chain Lightning)","!player.moving"}, "target.ground" },
{"Earthquake", {"modifier.multitarget","player.buff(Improved Chain Lightning)","player.buff(79206)"}, "target.ground" },
{"Chain Lightning", {"modifier.multitarget","!player.moving","target.range <= 40"}, "target" },
{"Chain Lightning", {"modifier.multitarget","player.buff(79206)","target.range <= 40"}, "target" },
{"Lightning Bolt", {"!modifier.multitarget","!player.moving","target.range <= 40"}, "target" },
{"Lightning Bolt", {"!modifier.multitarget","player.buff(79206)","target.range <= 40"}, "target" },
{ "Unleash Flame" },

{"Ghost Wolf",{"player.movingfor > 1", "!lastcast(Ghost Wolf)","!player.buff(79206)"},},

---------------------------
--!!!!!!END COMBAT!!!!!!!--
---------------------------
},{
---------------------------
--   OOC / PRE-PULL     --
---------------------------
{ "Lightning Shield",{"!player.buff(Lightning Shield)" },"player"},
{"#109218",{"modifier.lcontrol"},"player"},
{"Unleash Flame",{"modifier.lcontrol"},"player"},
{ "Storm Elemental Totem",{"modifier.lcontrol","talent(7,2)"},"player" },
{ "Fire Elemental Totem",{"modifier.lcontrol","!talent(7,2)"},"player" },
{"Earthquake", {"modifier.lcontrol","!player.moving"}, "target.ground" },

}, function()
NetherMachine.toggle.create('AoESpam', 'Interface\\Icons\\spell_nature_chainlightning', 'Spam AOE','Spam Chain Lightning and Earthquake')
--NetherMachine.toggle.create('AutoTarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target','Auto Target')

end)
