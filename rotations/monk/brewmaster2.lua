-- NetherMachine Rotation
-- Brewmaster Monk - WoD 6.0.3
-- Updated on Jan 10th 2015

-- PLAYER CONTROLLED:
-- TALENTS: 2133123
-- GLYPHS: fortifying_brew, expel_harm, fortuitous_spheres
-- CONTROLS: Pause - Left Control;  Black Ox Statue - Left Alt;  Dizzying Haze - Left Shift;  Healing Sphere - Right Alt

NetherMachine.rotation.register_custom(268, "|cFF00FF96bbMonk Brewmaster|r (SimC T17N)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- Off GCD
	{ "Touch of Death", "player.buff(Death Note)" },
	{ "Provoke", { "toggle.autotaunt", "@bbLib.bossTaunt" } },

	-- Survival
	{ "Nimble Brew", "player.state.fear" },
	{ "Nimble Brew", "player.state.stun" },
	{ "Nimble Brew", "player.state.root" },
	{ "Nimble Brew", "player.state.horror" },

	-- Interrupts
	{ "Leg Sweep", { "modifier.interrupt", "target.range <= 5", "player.area(5).enemies > 1" } },
	{ "Spear Hand Strike", "modifier.interrupt" },

	-- Keybinds
	{ "Dizzying Haze", "modifier.lshift", "ground" },
	{ "Summon Black Ox Statue", "modifier.lalt", "ground" },
	{ "Healing Sphere", "modifer.ralt", "ground" },
	{ "Spinning Crane Kick", "modifier.rshift" },

	-- COOLDOWNS
	-- actions+=/blood_fury,if=energy<=40
	{ "Blood Fury", { "modifier.cooldowns", "player.energy <= 40" } },
	-- actions+=/berserking,if=energy<=40
	{ "Berserking", { "modifier.cooldowns", "player.energy <= 40" } },
	-- actions+=/arcane_torrent,if=energy<=40
	{ "Arcane Torrent", { "modifier.cooldowns", "player.energy <= 40" } },
	-- actions+=/chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10&((charges=1&recharge_time<5)|charges=2|target.time_to_die<15)
	{ "Chi Brew", { "talent(3, 3)", "player.chi.deficit >= 2", "player.buff(128939).count <= 10", "player.spell(Chi Brew).charges == 1", "player.spell(Chi Brew).recharge < 5" } },
	{ "Chi Brew", { "talent(3, 3)", "player.chi.deficit >= 2", "player.buff(128939).count <= 10", "player.spell(Chi Brew).charges == 2" } },
	{ "Chi Brew", { "talent(3, 3)", "player.chi.deficit >= 2", "player.buff(128939).count <= 10", "target.boss", "target.deathin < 15" } },
	-- actions+=/chi_brew,if=(chi<1&stagger.heavy)|(chi<2&buff.shuffle.down)
	{ "Chi Brew", { "player.chi < 1", "player.debuff(Heavy Stagger)" } },
	{ "Chi Brew", { "player.chi < 2", "!player.buff(Shuffle)" } },
	-- actions+=/diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
	{ "Diffuse Magic", { "player.health < 100", "target.exists", "target.enemy", "target.casting.percent >= 50", "targettarget.istheplayer", "!player.buff(Fortifying Brew)" } },
	-- actions+=/dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down
	{ "Dampen Harm", { "player.health < 100", "target.exists", "target.enemy", "!player.buff(Fortifying Brew)", "!player.buff(115308)" } },
	-- actions+=/fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
	{ "Fortifying Brew", { "player.health < 100", "target.exists", "target.enemy", "targettarget.istheplayer", "!player.buff(115308)", "!player.buff(Dampen Harm)" } },
	{ "Fortifying Brew", { "player.health < 100", "target.exists", "target.enemy", "targettarget.istheplayer", "!player.buff(115308)", "!player.buff(Diffuse Magic)" } },
	-- actions+=/elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
	{ "Elusive Brew", { "target.exists", "target.enemy", "targettarget.istheplayer", "player.buff(Elusive Brew).count >= 9", "!player.buff(115308)", "!player.buff(Dampen Harm)" } },
	{ "Elusive Brew", { "target.exists", "target.enemy", "targettarget.istheplayer", "player.buff(Elusive Brew).count >= 9", "!player.buff(115308)", "!player.buff(Diffuse Magic)" } },
	-- actions+=/invoke_xuen,if=talent.invoke_xuen.enabled&target.time_to_die>15&buff.shuffle.remains>=3&buff.serenity.down
	{ "Invoke Xuen, the White Tiger", { "modifier.cooldowns", "player.time > 5", "talent(6, 2)", "target.deathin > 15", "player.buff(Shuffle).remains >= 3", "!player.buff(Serenity)" } },
	-- actions+=/serenity,if=talent.serenity.enabled&cooldown.keg_smash.remains>6
	{ "Serenity", { "talent(7, 3)", "player.spell(Keg Smash).remains > 6" } },
	-- actions+=/potion,name=draenic_armor,if=(buff.fortifying_brew.down&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down)
	{ "#109220", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "!player.buff(115308)", "!player.buff(Fortifying Brew)", "!player.buff(Dampen Harm)" } }, -- Draenic Agility Potion
	{ "#109220", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "!player.buff(115308)", "!player.buff(Fortifying Brew)", "!player.buff(Diffuse Magic)" } }, -- Draenic Agility Potion
	-- trinkets
	{ "#trinket1", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },
	{ "#trinket2", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },

	-- MOUSEOVERS
	--{ "Dizzying Haze", { "target.exists", "target.enemy", "target.combat", "target.distance > 15", "target.distance < 40", "!target.debuff(Dizzying Haze)", "!modifier.last" }, "target.ground" },
	--{ "Dizzying Haze", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.combat", "mouseover.distance > 15", "mouseover.distance < 40", "!mouseover.debuff(Dizzying Haze)" }, "mouseover.ground" },

	-- MULTIPLE TARGET ROTATION
	{ {
		-- actions.aoe=purifying_brew,if=stagger.heavy
		{ "Purifying Brew", "player.debuff(Heavy Stagger)" },
		-- actions.aoe+=/blackout_kick,if=buff.shuffle.down
		{ "Blackout Kick", "!player.buff(Shuffle)" },
		-- actions.aoe+=/purifying_brew,if=buff.serenity.up
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Light Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Moderate Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Heavy Stagger)" } },
		-- actions.aoe+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.moderate&buff.shuffle.remains>=6
		{ "Purifying Brew", { "!talent(7, 2)", "player.debuff(Moderate Stagger)", "player.buff(Shuffle).remains >= 6" } },
		-- actions.aoe+=/guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 1", "player.spell(Guard).recharge < 5" } },
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 2" } },
		{ "Guard", { "!player.buff(Guard)", "target.boss", "target.deathin < 15" } },
		-- actions.aoe+=/guard,if=incoming_damage_10s>=health.max*0.5
		{ "Guard", { "!player.buff(Guard)", "player.health <= 70" } },
		-- actions.aoe+=/breath_of_fire,if=(chi>=3|buff.serenity.up)&buff.shuffle.remains>=6&dot.breath_of_fire.remains<=2.4&!talent.chi_explosion.enabled
		{ "Breath of Fire", { "player.chi >= 3", "player.buff(Shuffle).remains >= 6", "target.debuff(Breath of Fire).remains <= 2.4", "!talent(7, 2)" } },
		{ "Breath of Fire", { "player.buff(Serenity)", "player.buff(Shuffle).remains >= 6", "target.debuff(Breath of Fire).remains <= 2.4", "!talent(7, 2)" } },
		-- actions.aoe+=/keg_smash,if=chi.max-chi>=1&!buff.serenity.remains
		{ "Keg Smash", { "player.chi.deficit >= 1", "!player.buff(Serenity)" } },
		-- actions.aoe+=/rushing_jade_wind,if=chi.max-chi>=1&!buff.serenity.remains&talent.rushing_jade_wind.enabled
		{ "Rushing Jade Wind", { "player.chi.deficit >= 1", "!player.buff(Serenity)", "talent(6, 1)" } },
		-- actions.aoe+=/chi_burst,if=(energy+(energy.regen*gcd))<100
		{ "Chi Burst", { (function() return (NetherMachine.condition["energy"]('player') + (NetherMachine.condition["energy.regen"]('player') * 1)) < 100 end) } },
		-- actions.aoe+=/chi_wave,if=(energy+(energy.regen*gcd))<100
		{ "Chi Wave", { (function() return (NetherMachine.condition["energy"]('player') + (NetherMachine.condition["energy.regen"]('player') * 1)) < 100 end) } },
		-- actions.aoe+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking&(energy+(energy.regen*gcd))<100
		{ "Zen Sphere", { "talent(2, 2)", "!player.buff(Zen Sphere)", (function() return (NetherMachine.condition["energy"]('player') + (NetherMachine.condition["energy.regen"]('player') * 1)) < 100 end) }, "player" },
		-- actions.aoe+=/chi_explosion,if=chi>=4
		{ "Chi Explosion", "player.chi >= 4" },
		-- actions.aoe+=/blackout_kick,if=chi>=4
		{ "Blackout Kick", "player.chi >= 4" },
		-- actions.aoe+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
		{ "Blackout Kick", { "player.buff(Shuffle).remains <= 3", "player.spell(Keg Smash).cooldown >= 1" } },
		-- actions.aoe+=/blackout_kick,if=buff.serenity.up
		{ "Blackout Kick", "player.buff(Serenity)" },
		-- actions.aoe+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Expel Harm", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.aoe+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Jab", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", "player.spell(Expel Harm).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.aoe+=/tiger_palm
		{ "Tiger Palm" },
	},{
		"modifier.multitarget", "player.area(10).enemies >= 3",
	} },


	-- SINGLE TARGET ROTATION
	-- actions.st=purifying_brew,if=!talent.chi_explosion.enabled&stagger.heavy
	{ "Purifying Brew", { "!talent(7, 2)", "player.debuff(Heavy Stagger)" } },
	-- actions.st+=/blackout_kick,if=buff.shuffle.down
	{ "Blackout Kick", "!player.buff(Shuffle)" },
	-- actions.st+=/purifying_brew,if=buff.serenity.up
	{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Light Stagger)" } },
	{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Moderate Stagger)" } },
	{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Heavy Stagger)" } },
	-- actions.st+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.moderate&buff.shuffle.remains>=6
	{ "Purifying Brew", { "!talent(7, 2)", "player.debuff(Moderate Stagger)", "player.buff(Shuffle).remains >= 6" } },
	-- actions.st+=/guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
	{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 1", "player.spell(Guard).recharge < 5" } },
	{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 2" } },
	{ "Guard", { "!player.buff(Guard)", "target.boss", "target.deathin < 15" } },
	-- actions.st+=/guard,if=incoming_damage_10s>=health.max*0.5
	{ "Guard", { "!player.buff(Guard)", "player.health <= 70" } },
	-- actions.st+=/keg_smash,if=chi.max-chi>=1&!buff.serenity.remains
	{ "Keg Smash", { "player.chi.deficit >= 1", "!player.buff(Serenity)" } },
	-- actions.st+=/chi_burst,if=(energy+(energy.regen*gcd))<100
	{ "Chi Burst", { (function() return (NetherMachine.condition["energy"]('player') + (NetherMachine.condition["energy.regen"]('player') * 1)) < 100 end) } },
	-- actions.st+=/chi_wave,if=(energy+(energy.regen*gcd))<100
	{ "Chi Wave", { (function() return (NetherMachine.condition["energy"]('player') + (NetherMachine.condition["energy.regen"]('player') * 1)) < 100 end) } },
	-- actions.st+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking&(energy+(energy.regen*gcd))<100
	{ "Zen Sphere", { "talent(2, 2)", "!player.buff(Zen Sphere)", (function() return (NetherMachine.condition["energy"]('player') + (NetherMachine.condition["energy.regen"]('player') * 1)) < 100 end) }, "player" },
	-- actions.st+=/chi_explosion,if=chi>=3
	{ "Chi Explosion", "player.chi >= 3" },
	-- actions.st+=/blackout_kick,if=chi>=4
	{ "Blackout Kick", "player.chi >= 4" },
	-- actions.st+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
	{ "Blackout Kick", { "player.buff(Shuffle).remains <= 3", "player.spell(Keg Smash).cooldown >= 1" } },
	-- actions.st+=/blackout_kick,if=buff.serenity.up
	{ "Blackout Kick", "player.buff(Serenity)" },
	-- actions.st+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
	{ "Expel Harm", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
	-- actions.st+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
	{ "Jab", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", "player.spell(Expel Harm).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
	-- actions.st+=/tiger_palm
	{ "Tiger Palm" },

},{
-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buffs
	{ "Legacy of the White Tiger", { "player.ooctime > 3", "!player.buffs.stats" } },

	-- Ground Stuff
	{ "Dizzying Haze", { "modifier.lshift", "player.area(40).enemies > 0" }, "ground" },
	{ "Summon Black Ox Statue", "modifier.lalt", "ground" },

-- actions.precombat=flask,type=greater_draenic_stamina_flask
-- actions.precombat+=//food,type=sleeper_surprise
-- actions.precombat+=/stance,choose=sturdy_ox
-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
-- actions.precombat+=/snapshot_stats
-- actions.precombat+=/potion,name=draenic_agility
-- actions.precombat+=/dampen_harm

},
function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
end)
