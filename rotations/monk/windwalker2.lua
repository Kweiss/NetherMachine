-- Windwalker Monk - Legion 7.2

-- PLAYER CONTROLLED:
-- TALENTS (from SimC) - 3010032

NetherMachine.rotation.register_custom(269, "|cFF99FF00Legion |cFFFF6600Windwalker |cFFFF9999(SimC 7.2)", {

-- COMBAT ROTATION
	--[[ PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!toggle.frogs", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "!toggle.frogs", "target.exists", "target.dead" } },

	{ {
		{ "Legacy of the White Tiger", { "@bbLib.engaugeUnit('ANY', 30, true)" } },
	},{
		"toggle.frogs"
	} }, ]]--

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



--[[
# This default action priority list is automatically created based on your character.
# It is a attempt to provide you with a action list that is both simple and practicable,
# while resulting in a meaningful and good simulation. It may not result in the absolutely highest possible dps.
# Feel free to edit, adapt and improve it to your own needs.
# SimulationCraft is always looking for updates and improvements to the default action lists.

# Executed before combat begins. Accepts non-harmful actions only.
actions.precombat=flask,type=flask_of_the_seventh_demon
actions.precombat+=/food,type=the_hungry_magister
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=prolonged_power

# Executed every time the actor is available.
actions=auto_attack
actions+=/spear_hand_strike,if=target.debuff.casting.react
actions+=/potion,name=prolonged_power,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
actions+=/touch_of_death,if=target.time_to_die<=9
actions+=/call_action_list,name=serenity,if=(talent.serenity.enabled&cooldown.serenity.remains<=0)|buff.serenity.up
actions+=/call_action_list,name=sef,if=!talent.serenity.enabled&equipped.drinking_horn_cover&((cooldown.fists_of_fury.remains<=1&chi>=3)|buff.storm_earth_and_fire.up|cooldown.storm_earth_and_fire.charges=2|target.time_to_die<=25|cooldown.touch_of_death.remains>=85)
actions+=/call_action_list,name=sef,if=!talent.serenity.enabled&!equipped.drinking_horn_cover&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=14&cooldown.fists_of_fury.remains<=6&cooldown.rising_sun_kick.remains<=6)|buff.storm_earth_and_fire.up)
actions+=/call_action_list,name=st

actions.cd=invoke_xuen
actions.cd+=/blood_fury
actions.cd+=/berserking
actions.cd+=/touch_of_death,cycle_targets=1,max_cycle_targets=2,if=!artifact.gale_burst.enabled&equipped.hidden_masters_forbidden_touch&!prev_gcd.1.touch_of_death
actions.cd+=/touch_of_death,if=!artifact.gale_burst.enabled&!equipped.hidden_masters_forbidden_touch
actions.cd+=/touch_of_death,cycle_targets=1,max_cycle_targets=2,if=artifact.gale_burst.enabled&equipped.hidden_masters_forbidden_touch&((talent.serenity.enabled&cooldown.serenity.remains<=1)|chi>=2)&(cooldown.strike_of_the_windlord.remains<8|cooldown.fists_of_fury.remains<=4)&cooldown.rising_sun_kick.remains<7&!prev_gcd.1.touch_of_death
actions.cd+=/touch_of_death,if=artifact.gale_burst.enabled&!talent.serenity.enabled&!equipped.hidden_masters_forbidden_touch&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7&chi>=2
actions.cd+=/touch_of_death,if=artifact.gale_burst.enabled&((talent.serenity.enabled&cooldown.serenity.remains<=1)|chi>=2)&(cooldown.strike_of_the_windlord.remains<8|cooldown.fists_of_fury.remains<=4)&cooldown.rising_sun_kick.remains<7&!prev_gcd.1.touch_of_death

actions.sef=tiger_palm,if=energy=energy.max&chi<1
actions.sef+=/arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
actions.sef+=/call_action_list,name=cd
actions.sef+=/storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&(cooldown.touch_of_death.remains<=8|cooldown.touch_of_death.remains>85)
actions.sef+=/storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&cooldown.storm_earth_and_fire.charges=2
actions.sef+=/storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&target.time_to_die<=25
actions.sef+=/storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&cooldown.fists_of_fury.remains<=1&chi>=3
actions.sef+=/fists_of_fury,if=buff.storm_earth_and_fire.up
actions.sef+=/rising_sun_kick,if=buff.storm_earth_and_fire.up&chi=2&energy<energy.max
actions.sef+=/call_action_list,name=st

actions.serenity=call_action_list,name=cd
actions.serenity+=/serenity
actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies<3
actions.serenity+=/fists_of_fury
actions.serenity+=/strike_of_the_windlord
actions.serenity+=/spinning_crane_kick,if=active_enemies>=3&!prev_gcd.1.spinning_crane_kick
actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies>=3
actions.serenity+=/spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick
actions.serenity+=/blackout_kick,cycle_targets=1,if=!prev_gcd.1.blackout_kick
actions.serenity+=/rushing_jade_wind,if=!prev_gcd.1.rushing_jade_wind

actions.st=call_action_list,name=cd
actions.st+=/energizing_elixir,if=energy<energy.max&chi<=1
actions.st+=/arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
actions.st+=/rising_sun_kick,cycle_targets=1,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=2
actions.st+=/rising_sun_kick,cycle_targets=1,if=equipped.convergence_of_fates&!talent.serenity.enabled
actions.st+=/rising_sun_kick,cycle_targets=1,if=!equipped.convergence_of_fates
actions.st+=/fists_of_fury,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=5
actions.st+=/fists_of_fury,if=equipped.convergence_of_fates&!talent.serenity.enabled
actions.st+=/fists_of_fury,if=!equipped.convergence_of_fates
actions.st+=/strike_of_the_windlord,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=10
actions.st+=/strike_of_the_windlord,if=equipped.convergence_of_fates&!talent.serenity.enabled
actions.st+=/strike_of_the_windlord,if=!equipped.convergence_of_fates
actions.st+=/tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm&energy=energy.max&chi<=3&buff.storm_earth_and_fire.up
actions.st+=/whirling_dragon_punch
actions.st+=/crackling_jade_lightning,if=equipped.the_emperors_capacitor&buff.the_emperors_capacitor.stack>=15
actions.st+=/spinning_crane_kick,if=(active_enemies>=3|spinning_crane_kick.count>=3)&!prev_gcd.1.spinning_crane_kick
actions.st+=/rushing_jade_wind,if=chi.max-chi>1&!prev_gcd.1.rushing_jade_wind
actions.st+=/blackout_kick,cycle_targets=1,if=(chi>1|buff.bok_proc.up)&!prev_gcd.1.blackout_kick
actions.st+=/chi_wave,if=energy.time_to_max>=2.25
actions.st+=/chi_burst,if=energy.time_to_max>=2.25
actions.st+=/tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm


]]--
