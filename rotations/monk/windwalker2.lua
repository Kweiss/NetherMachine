-- NetherMachine Rotation
-- Windwalker Monk - WoD 6.1
-- Updated on April 10th 2015

-- PLAYER CONTROLLED:
-- TALENTS: (ST) Momentum, Zen Sphere, Chi Brew, Leg Sweep, Dampen Harm, Xuen, Serenity
--          (AoE) Momentum, Chi Burst, Ascension, Leg Sweep, Dampen Harm, Rushing Jade Wind, Chi Explosion
-- GLYPHS: Major: Glyph of Flying Fists, Glyph of Floating Butterfly, Glyph of Zen Meditation   Minor: Glyph of Flying Serpent Kick, Glyph of Spirit Roll, Glyph of Water Roll
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(269, "bbMonk Windwalker (Icy Veins)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!toggle.frogs", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "!toggle.frogs", "target.exists", "target.dead" } },

	{ {
		{ "Legacy of the White Tiger", { "@bbLib.engaugeUnit('ANY', 30, true)" } },
	},{
		"toggle.frogs"
	} },

	-- Interrupts
	{ "Spear Hand Strike", "modifier.interrupt" },
	{ "Leg Sweep", { "talent(4, 3)", "target.interrupt", "target.range <= 5" } },
	{ "Leg Sweep", { "talent(4, 3)", "mouseover.interrupt", "target.range <= 5" } },

	-- Dispells
	{ "Detox", { "player.dispellable", "!modifier.last" }, "player" }, -- Poison and Disease
	{ "Detox", { "mouseover.exists", "mouseover.friend", "mouseover.dispellable", "!modifier.last" }, "mouseover" },

	-- DEFENSIVE COOLDOWNS
	{ "Nimble Brew", "player.state.fear" },
	{ "Nimble Brew", "player.state.stun" },
	{ "Nimble Brew", "player.state.root" },
	{ "Nimble Brew", "player.state.horror" },
	{ "Tiger's Lust", "player.state.snare" },
	{ "Tiger's Lust", "player.state.root" },
	{ "Fortifying Brew", "player.health < 30" },
	{ "Touch of Karma", { "player.health < 50", "target.range < 2" } },
	{ "Zen Meditation", { "player.health < 20", "target.range > 5", "!player.moving" } },
	{ "Diffuse Magic", { "talent(5, 3)", "player.health < 90", (function() return UnitIsUnit('targettarget', 'player') end), "target.casting.time > 0" } },
	-- TODO: Dampen Harm

	-- COOLDOWNS / COMMON
	{ {
		--Trinkets
		{ "#trinket1", "player.time < 10" },
		{ "#trinket1", "player.buff(Serenity)" },
		{ "#trinket1", "player.buff(116740)" },
		{ "#trinket2", "player.time < 10" },
		{ "#trinket2", "player.buff(Serenity)" },
		{ "#trinket2", "player.buff(116740)" },
		-- Agi Pot
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
		-- Racials
		{ "Blood Fury" },
		{ "Berserking" },
		{ "Arcane Torrent", { "player.chi < 3" } },
		-- Invoke Xuen, the White Tiger
		{ "Invoke Xuen, the White Tiger" },
		-- Chi Brew when needed "player.buff(125195).count <= 16"
		{ "Chi Brew", { "player.chi < 3", "player.buff(125195).count < 18", "player.spell(Chi Brew).charges > 1" } },
		-- Tigereye Brew if stack at 10
		{ "Tigereye Brew", { "player.buff(125195).count > 15" } },
		{ "Tigereye Brew", { "player.buff(125195).count > 9", "player.hashero" } },
		{ "Tigereye Brew", { "player.buff(125195).count > 9", "player.buff(Draenic Agility Potion)" } },
		{ "Tigereye Brew", { "player.buff(125195).count > 9", "player.buff(Lub-Dub)" } },
		{ "Tigereye Brew", { "player.buff(125195).count > 9", "player.buff(Meaty Dragonspine Trophy)" } },
		{ "Tigereye Brew", { "player.buff(125195).count > 9", "player.buff(Detonation)" } },
		{ "Tigereye Brew", { "player.buff(125195).count > 9", "player.buff(Serenity)" } },
		-- Serenity
		{ "Serenity", { "player.chi > 2" } },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive",
	} },

	-- TOD
	{ "Touch of Death", { "player.buff(Death Note)" } },

	-- Energizing Brew
	{ "Energizing Brew", { "player.energy < 40" } },
	-- Zen Sphere should be kept up on yourself and on a secondary target at all times, against a single target.
	{ "Zen Sphere", { "!player.buff" }, "player" },
	{ "Zen Sphere", { "focus.exists", "focus.friend", "focus.alive", "!focus.buff" }, "focus" },
	{ "Zen Sphere", { "!tank.buff" }, "tank" },

	-- MULTITARGET
	{ {
		{ "Storm, Earth, and Fire", { "!mouseover.debuff", "!modifier.last", "player.buff(Storm, Earth, and Fire).count < 2", "!target.target(mouseover)" }, "mouseover" },
		{ "Rising Sun Kick", { "!talent(7, 2)" } },
		{ "Rising Sun Kick", { "talent(7, 2)", "target.debuff.remains < 3" } },
		{ "Tiger Palm", { "!talent(7,2)", "player.buff(Tiger Power).duration < 6.6" } },
		{ "Tiger Palm", { "talent(7,2)", "player.buff(Tiger Power).duration < 5", "player.spell(Fists of Fury).cooldown < 5" } },
		{ {
			{ "Fists of Fury", { "!player.moving", "player.lastmoved > 0.5", "!player.glyph(Floating Butterfly)" } },
			{ "Fists of Fury", "player.glyph(Floating Butterfly)" },
		},{
			"!player.buff(Serenity)", "target.debuff(Rising Sun Kick).duration > 3.6", "player.buff(Tiger Power).duration > 3.6"
		} },
		{ "Chi Explosion", { "player.chi > 3", "player.buff(Combo Breaker: Blackout Kick)", "player.spell(Fists of Fury).cooldown > 3" } },
		{ "Hurricane Strike", {	"!player.moving", "talent(7,1)", "player.timetomax > 2", "target.debuff(Rising Sun Kick).duration > 2", "player.buff(Tiger Power).duration > 2", "!player.buff(Energizing Brew)" } },
		{ "Spinning Crane Kick", { "!modifier.last" } },
		{ "Rushing Jade Wind" },

		{ "Expel Harm", { "player.chi < 3", "player.health < 90" } },
		{ "Jab", { "player.chi < 3" } },
	},{
		"modifier.multitarget", "player.area(7).enemies > 2"
	} },

	-- SINGLE TARGET
	{ "/cancelaura Storm, Earth, and Fire", { "player.buff(Storm, Earth, and Fire)", "player.area(7).enemies < 3" } },
	{ "Tiger Palm", { "!talent(7,2)", "player.buff(Tiger Power).duration < 6.6" } },
	{ "Tiger Palm", { "talent(7,2)", "player.buff(Tiger Power).duration < 5", "player.spell(Fists of Fury).cooldown < 5" } },
	{ "Rising Sun Kick", { "!talent(7, 2)" } },
	{ "Rising Sun Kick", { "talent(7, 2)", "target.debuff.remains < 3" } },
	{ {
		{ "Fists of Fury", { "!player.moving", "player.lastmoved > 0.5", "!player.glyph(Floating Butterfly)" } },
		{ "Fists of Fury", "player.glyph(Floating Butterfly)" },
	},{
		"!player.buff(Serenity)", "target.debuff(Rising Sun Kick).duration > 3.6", "player.buff(Tiger Power).duration > 3.6"
	} },
	{ "Blackout Kick", { "player.buff(Combo Breaker: Blackout Kick)" } },
	{ "Chi Explosion", { "player.chi > 2", "player.buff(Combo Breaker: Chi Explosion)" } },
	{ "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)" } },
	{ "Chi Wave" },
	{ "Hurricane Strike", {	"!player.moving", "talent(7,1)", "player.timetomax > 2", "target.debuff(Rising Sun Kick).duration > 2", "player.buff(Tiger Power).duration > 2", "!player.buff(Energizing Brew)" } },
	{ "Blackout Kick", { "player.chi > 2" } },
	{ "Chi Explosion", { "player.chi > 2" } },


	{ "Expel Harm", { "player.chi < 3", "player.health < 90" } },
	{ "Jab", { "player.chi < 3" } },


},{
-- OUT OF COMBAT
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- OOC HEAL
	{ "Surging Mist", { "!player.moving", "player.health < 80" }, "player" },

	-- Buffs
	{ "Legacy of the White Tiger", { "!player.buff", "!player.buffs.stats" } },

	{ {
		{ "Legacy of the White Tiger", { "player.health > 80", "@bbLib.engaugeUnit('ANY', 30, true)" } },
		--{ "Crackling Jade Lightning", true, "target" },
	},{
		"toggle.frogs"
	} },

	-- PRE COMBAT
	-- actions.precombat=flask,type=greater_draenic_agility_flask
	-- actions.precombat+=/food,type=rylak_crepes
	-- actions.precombat+=/stance,choose=fierce_tiger
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_agility

},
function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Engage', 'Automatically target and attack any enemy units in range.')
end)















-- NetherMachine Rotation
-- Windwalker Monk - WoD 6.0.3
-- Updated on April 10th 2015

-- PLAYER CONTROLLED: Roll, Disable, Flying Serpent Kick, (Storm, Earth, and Fire), Touch of Karma, Zen Meditation
-- TALENTS: Tiger's Lust, Chi Wave, Chi Brew, Leg Sweep, Diffuse Magic, Invoke Xuen, Serenity 2130023
-- GLYPHS: Major: Glyph of Flying Fists, Glyph of Floating Butterfly, Glyph of Zen Meditation   Minor: Glyph of Flying Serpent Kick, Glyph of Spirit Roll, Glyph of Water Roll
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(269, "bbMonk Windwalker (SimC)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!toggle.frogs", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "!toggle.frogs", "target.exists", "target.dead" } },

	{ {
		{ "Legacy of the White Tiger", { "@bbLib.engaugeUnit('ANY', 30, true)" } },
	},{
		"toggle.frogs"
	} },

	-- Interrupts
	{ "Spear Hand Strike", "modifier.interrupt" },
	{ "Leg Sweep", { "talent(4, 3)", "modifier.interrupt", "target.range <= 5" } },

	-- DEFENSIVE COOLDOWNS
	{ "Nimble Brew", "player.state.fear" },
	{ "Nimble Brew", "player.state.stun" },
	{ "Nimble Brew", "player.state.root" },
	{ "Nimble Brew", "player.state.horror" },
	{ "Tiger's Lust", "player.state.snare" },
	{ "Tiger's Lust", "player.state.root" },
	{ "Touch of Karma", { "player.health < 50", "target.range < 2" } },
	{ "Fortifying Brew", "player.health < 30" },
	{ "Zen Meditation", { "player.health < 20", "target.range > 3" } },
	{ "Diffuse Magic", { "talent(5, 3)", "player.health < 90", (function() return UnitIsUnit('targettarget', 'player') end), "target.casting.time > 0" } },

	-- COOLDOWNS / COMMON
	-- actions=auto_attack
	-- actions+=/invoke_xuen,if=talent.invoke_xuen.enabled&time>5
	{ "Invoke Xuen, the White Tiger", { "modifier.cooldowns", "player.time > 5" } },
	-- actions+=/chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4
	-- actions+=/potion,name=draenic_agility,if=buff.serenity.up|(!talent.serenity.enabled&trinket.proc.agility.react)
	{ "#118913", { "modifier.cooldowns", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
	{ "#109217", { "modifier.cooldowns", "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
	{ "#109217", { "modifier.cooldowns", "toggle.consume", "target.boss", "!talent(7, 3)", "player.trinket.any > 0" } }, -- Draenic Agility Potion
	{ "#109217", { "modifier.cooldowns", "toggle.consume", "target.boss", "talent(7, 3)", "player.buff(Serenity)" } }, -- Draenic Agility Potion
	-- actions+=/use_item,name=gorashans_lodestone_spike,if=buff.tigereye_brew_use.up|target.time_to_die<18
	{ "#trinket1", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "player.buff(116740)" } },
	{ "#trinket1", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "target.boss", "target.deathin < 18" } },
	{ "#trinket2", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "player.buff(116740)" } },
	{ "#trinket2", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "target.boss", "target.deathin < 18"} },
	-- actions+=/blood_fury,if=buff.tigereye_brew_use.up|target.time_to_die<18
	{ "Blood Fury", { "modifier.cooldowns", "player.buff(116740)" } },
	{ "Blood Fury", { "modifier.cooldowns", "target.boss", "target.deathin < 18" } },
	-- actions+=/berserking,if=buff.tigereye_brew_use.up|target.time_to_die<18
	{ "Berserking", {  "modifier.cooldowns", "player.buff(116740)" } },
	{ "Berserking", {  "modifier.cooldowns", "target.boss", "target.deathin < 18" } },
	-- actions+=/arcane_torrent,if=chi.max-chi>=1&(buff.tigereye_brew_use.up|target.time_to_die<18)
	{ "Arcane Torrent", { "modifier.cooldowns", "player.chi.deficit >= 1", "player.buff(116740)" } },
	{ "Arcane Torrent", { "modifier.cooldowns", "player.chi.deficit >= 1", "target.boss", "target.deathin < 18" } },
	-- actions+=/chi_brew,if=chi.max-chi>=2&((charges=1&recharge_time<=10)|charges=2|target.time_to_die<charges*10)&buff.tigereye_brew.stack<=16
	{ "Chi Brew", { "player.chi.deficit >= 2", "player.buff(125195).count <= 16", "player.spell(Chi Brew).charges == 1", "player.spell(Chi Brew).recharge <= 10" } },
	{ "Chi Brew", { "player.chi.deficit >= 2", "player.buff(125195).count <= 16", "player.spell(Chi Brew).charges == 2" } },
	{ "Chi Brew", { "player.chi.deficit >= 2", "player.buff(125195).count <= 16", "target.boss", "target.deathin < 15" } },
	-- actions+=/tiger_palm,if=buff.tiger_power.remains<6
	{ "Tiger Palm", "player.buff(Tiger Power).remains < 6" },
	-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack=20
	{ "Tigereye Brew", { "!player.buff(116740)", "player.buff(125195).count == 20" } },
	-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=10&buff.serenity.up
	{ "Tigereye Brew", { "!player.buff(116740)", "player.buff(125195).count >= 10", "player.buff(Serenity)" } },
	-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=10&cooldown.fists_of_fury.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
	{ "Tigereye Brew", { "!player.buff(116740)", "player.buff(125195).count >= 10", "player.spell(Fists of Fury).cooldown == 0", "player.chi >= 3", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)" } },
	-- actions+=/tigereye_brew,if=talent.hurricane_strike.enabled&buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=10&cooldown.hurricane_strike.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
	{ "Tigereye Brew", { "talent(7, 1)", "!player.buff(116740)", "player.buff(125195).count >= 10", "player.spell(Hurricane Strike).cooldown == 0", "player.chi >= 3", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)" } },
	-- actions+=/tigereye_brew,if=buff.tigereye_brew_use.down&chi>=2&(buff.tigereye_brew.stack>=16|target.time_to_die<40)&debuff.rising_sun_kick.up&buff.tiger_power.up
	{ "Tigereye Brew", { "!player.buff(116740)", "player.chi >= 2", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)", "player.buff(125195).count >= 16" } },
	{ "Tigereye Brew", { "!player.buff(116740)", "player.chi >= 2", "target.debuff(Rising Sun Kick)", "player.buff(Tiger Power)", "target.boss", "target.deathin < 40" } },
	-- actions+=/rising_sun_kick,if=(debuff.rising_sun_kick.down|debuff.rising_sun_kick.remains<3)
	{ "Rising Sun Kick", "target.debuff(Rising Sun Kick).remains < 3" },
	-- actions+=/serenity,if=talent.serenity.enabled&chi>=2&buff.tiger_power.up&debuff.rising_sun_kick.up
	{ "Serenity", { "modifier.cooldowns", "talent(7, 3)", "player.chi >= 2", "player.buff(Tiger Power)", "target.debuff(Rising Sun Kick)" } },

	-- MULTI TARGET ROTATION >=3
	{ {
		-- actions.aoe=chi_explosion,if=chi>=4&(cooldown.fists_of_fury.remains>3|!talent.rushing_jade_wind.enabled)
		{ "Chi Explosion", { "player.chi >= 4", "player.spell(Fists of Fury).cooldown > 3" } },
		{ "Chi Explosion", { "player.chi >= 4", "!talent(6, 1)" } },
		-- actions.aoe+=/rushing_jade_wind
		{ "Rushing Jade Wind" },
		-- actions.aoe+=/energizing_brew,if=cooldown.fists_of_fury.remains>6&(!talent.serenity.enabled|(!buff.serenity.remains&cooldown.serenity.remains>4))&energy+energy.regen*gcd<50
		{ "Energizing Brew", { "player.spell(Fists of Fury).cooldown > 6", "!talent(7, 3)", "player.energy < 45", "!modifier.last", "!player.buff" } },
		{ "Energizing Brew", { "player.spell(Fists of Fury).cooldown > 6", "talent(7, 3)", "!player.buff(Serenity)", "player.spell(Serenity).cooldown > 4", "player.energy < 45", "!modifier.last", "!player.buff" } },
		-- actions.aoe+=/rising_sun_kick,if=!talent.rushing_jade_wind.enabled&chi=chi.max
		{ "Rising Sun Kick", { "!talent(6, 1)", "player.chi.deficit == 0" } },
		-- actions.aoe+=/fists_of_fury,if=talent.rushing_jade_wind.enabled&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&!buff.serenity.remains
		{ "Fists of Fury", { "target.exists", "talent(6, 1)",
			(function() return NetherMachine.condition["buff.remains"]('player', "Tiger Power") > NetherMachine.condition["spell.castingtime"]('player', "Fists of Fury") end),
			(function() return NetherMachine.condition["debuff.remains"]('target', "Rising Sun Kick") > NetherMachine.condition["spell.castingtime"]('player', "Fists of Fury") end),
			"!player.buff(Serenity)" } },
		-- actions.aoe+=/fortifying_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0
		{ "Fortifying Brew", { "target.health < 10", "player.spell(Touch of Death).remains == 0" } },
		-- actions.aoe+=/touch_of_death,if=target.health.percent<10
		{ "Touch of Death", "player.buff(Death Note)" },
		-- actions.aoe+=/hurricane_strike,if=talent.rushing_jade_wind.enabled&talent.hurricane_strike.enabled&energy.time_to_max>cast_time&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.energizing_brew.down
		{ "Hurricane Strike", { "talent(6, 1)", "talent(7, 1)", (function() return NetherMachine.condition["timetomax"]('player') > NetherMachine.condition["spell.castingtime"]('player', "Hurricane Strike") end),
			(function() return NetherMachine.condition["buff.remains"]('player', "Tiger Power") > NetherMachine.condition["spell.castingtime"]('player', "Hurricane Strike") end),
			(function() return NetherMachine.condition["debuff.remains"]('target', "Rising Sun Kick") > NetherMachine.condition["spell.castingtime"]('player', "Hurricane Strike") end),
			"!player.buff(Energizing Brew)" } },
		-- actions.aoe+=/zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking
		{ "Zen Sphere", "!player.buff(Zen Sphere)", "player" },
		-- actions.aoe+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Wave", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>2&buff.serenity.down
		{ "Chi Burst", { "talent(2, 3)", "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&!talent.chi_explosion.enabled&(buff.combo_breaker_bok.react|buff.serenity.up)
		{ "Blackout Kick", { "talent(6, 1)", "!talent(7, 2)", "player.buff(Combo Breaker: Blackout Kick)" } },
		{ "Blackout Kick", { "talent(6, 1)", "!talent(7, 2)", "player.buff(Serenity)" } },
		-- actions.aoe+=/tiger_palm,if=talent.rushing_jade_wind.enabled&buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
		{ "Tiger Palm", { "talent(6, 1)", "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).remains <= 2" } },
		-- actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&!talent.chi_explosion.enabled&chi.max-chi<2&(cooldown.fists_of_fury.remains>3|!talent.rushing_jade_wind.enabled)
		{ "Blackout Kick", { "talent(6, 1)", "!talent(7, 2)", "player.chi.deficit < 2", "player.spell(Fists of Fury).cooldown > 3" } },
		{ "Blackout Kick", { "!talent(6, 1)", "!talent(7, 2)", "player.chi.deficit < 2" } },
		-- actions.aoe+=/spinning_crane_kick
		{ "Spinning Crane Kick", "!player.buff" },
		-- actions.aoe+=/jab,if=talent.rushing_jade_wind.enabled&chi.max-chi>=2
		{ "Expel Harm", { "player.chi.deficit >= 2", "player.health < 50" } },
		{ "Jab", { "talent(6, 1)", "player.chi.deficit >= 2" } },
		-- actions.aoe+=/jab,if=talent.rushing_jade_wind.enabled&chi.max-chi>=1&talent.chi_explosion.enabled&cooldown.fists_of_fury.remains<=3
		{ "Jab", { "talent(6, 1)", "player.chi.deficit >= 1", "talent(7, 2)", "player.spell(Fists of Fury).cooldown <= 3" } },
	},{
			"modifier.multitarget", "player.area(5).enemies >= 3",
	} },

	-- SINGLE TARGET ROTATION
	-- actions.st=fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&!buff.serenity.remains
	{ "Fists of Fury", { "target.exists", (function() return NetherMachine.condition["buff.remains"]('player', "Tiger Power") > NetherMachine.condition["spell.castingtime"]('player', "Fists of Fury") end), (function() return NetherMachine.condition["debuff.remains"]('target', "Rising Sun Kick") > NetherMachine.condition["spell.castingtime"]('player', "Fists of Fury") end), "!player.buff(Serenity)" } },
	-- actions.st+=/fortifying_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi>=3
	{ "Fortifying Brew", { "target.health < 10", "player.spell(Touch of Death).remains == 0", "player.chi >= 3" } },
	-- actions.st+=/touch_of_death,if=target.health.percent<10
	{ "Touch of Death", "player.buff(Death Note)" },
	-- actions.st+=/hurricane_strike,if=talent.hurricane_strike.enabled&energy.time_to_max>cast_time&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.energizing_brew.down
	{ "Hurricane Strike", { "talent(7, 1)", (function() return NetherMachine.condition["timetomax"]('player') > NetherMachine.condition["spell.castingtime"]('player', "Hurricane Strike") end),
		(function() return NetherMachine.condition["buff.remains"]('player', "Tiger Power") > NetherMachine.condition["spell.castingtime"]('player', "Hurricane Strike") end),
		(function() return NetherMachine.condition["debuff.remains"]('target', "Rising Sun Kick") > NetherMachine.condition["spell.castingtime"]('player', "Hurricane Strike") end),
		"!player.buff(Energizing Brew)" } },
	-- actions.st+=/energizing_brew,if=cooldown.fists_of_fury.remains>6&(!talent.serenity.enabled|(!buff.serenity.remains&cooldown.serenity.remains>4))&energy+energy.regen*gcd<50
	{ "Energizing Brew", { "player.spell(Fists of Fury).cooldown > 6", "!talent(7, 3)", "player.energy < 45", "!modifier.last", "!player.buff" } },
	{ "Energizing Brew", { "player.spell(Fists of Fury).cooldown > 6", "talent(7, 3)", "!player.buff(Serenity)", "player.spell(Serenity).cooldown > 4", "player.energy < 45", "!modifier.last", "!player.buff" } },
	-- actions.st+=/rising_sun_kick,if=!talent.chi_explosion.enabled
	{ "Rising Sun Kick", "!talent(7, 2)" },
	-- actions.st+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
	{ "Chi Wave", { "player.timetomax > 2", "!player.buff(Serenity)" } },
	-- actions.st+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>2&buff.serenity.down
	{ "Chi Burst", { "talent(2, 3)", "player.timetomax > 2", "!player.buff(Serenity)" } },
	-- actions.st+=/zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
	{ "Zen Sphere", { "player.timetomax > 2", "!player.buff(Zen Sphere)", "!player.buff(Serenity)" }, "player" },
	-- actions.st+=/blackout_kick,if=!talent.chi_explosion.enabled&(buff.combo_breaker_bok.react|buff.serenity.up)
	{ "Blackout Kick", { "!talent(7, 2)", "player.buff(Combo Breaker: Blackout Kick)" } },
	{ "Blackout Kick", { "!talent(7, 2)", "player.buff(Serenity)" } },
	-- actions.st+=/chi_explosion,if=talent.chi_explosion.enabled&chi>=3&buff.combo_breaker_ce.react&cooldown.fists_of_fury.remains>3
	{ "Chi Explosion", { "talent(7, 2)", "player.chi >= 3", "player.buff(Combo Breaker: Chi Explosion)", "player.spell(Fists of Fury).cooldown > 3" } },
	-- actions.st+=/tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<6
	{ "Tiger Palm", { "player.buff(Combo Breaker: Tiger Palm)", "player.buff(Combo Breaker: Tiger Palm).remains < 6" } },
	-- actions.st+=/blackout_kick,if=!talent.chi_explosion.enabled&chi.max-chi<2
	{ "Blackout Kick", { "!talent(7, 2)", "player.chi.deficit < 2" } },
	-- actions.st+=/chi_explosion,if=talent.chi_explosion.enabled&chi>=3&cooldown.fists_of_fury.remains>3
	{ "Chi Explosion", { "talent(7, 2)", "player.chi >= 3", "player.spell(Fists of Fury).cooldown > 3" } },
	-- actions.st+=/jab,if=chi.max-chi>=2
	{ "Expel Harm", { "player.chi.deficit >= 2", "player.health < 50" } },
	{ "Jab", "player.chi.deficit >= 2" },
	-- actions.st+=/jab,if=chi.max-chi>=1&talent.chi_explosion.enabled&cooldown.fists_of_fury.remains<=3
	{ "Jab", { "player.chi.deficit >= 1", "talent(7, 2)", "player.spell(Fists of Fury).cooldown <= 3" } },

},{
-- OUT OF COMBAT
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- OOC HEAL
	{ "Surging Mist", { "!player.moving", "player.health < 80" }, "player" },

	-- Buffs
	{ "Legacy of the White Tiger", "!player.buffs.stats" },

	{ {
		{ "Legacy of the White Tiger", { "player.health > 80", "@bbLib.engaugeUnit('ANY', 30, true)" } },
		--{ "Crackling Jade Lightning", true, "target" },
	},{
		"toggle.frogs"
	} },

	-- PRE COMBAT
	-- actions.precombat=flask,type=greater_draenic_agility_flask
	-- actions.precombat+=/food,type=rylak_crepes
	-- actions.precombat+=/stance,choose=fierce_tiger
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_agility

},
function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Engage', 'Automatically target and attack any enemy units in range.')
end)
