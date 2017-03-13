-- NetherMachine Rotation
-- Brewmaster Monk - WoD 6.1.2
-- Updated on May 16th 2015

-- PLAYER CONTROLLED:
-- talents=0130123
-- glyphs=fortifying_brew,expel_harm,fortuitous_spheres
-- CONTROLS: Pause - Left Control;  Black Ox Statue - Left Alt;  Dizzying Haze - Left Shift;  Healing Sphere - Right Alt

NetherMachine.rotation.register_custom(268, "|cFF00FF96Monk Brewmaster (Legion)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

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
	-- actions=auto_attack
	-- actions+=/blood_fury,if=energy<=40
	{ "Blood Fury", { "modifier.cooldowns", "player.energy <= 40" } },
	-- actions+=/berserking,if=energy<=40
	{ "Berserking", { "modifier.cooldowns", "player.energy <= 40" } },
	-- actions+=/arcane_torrent,if=chi.max-chi>=1&energy<=40
	{ "Arcane Torrent", { "modifier.cooldowns", "player.energy <= 40", "player.chi.deficit > 0" } },
	-- actions+=/chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4
	-- actions+=/chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10&((charges=1&recharge_time<5)|charges=2|(target.time_to_die<15&(cooldown.touch_of_death.remains>target.time_to_die|glyph.touch_of_death.enabled)))
	{ "Chi Brew", { "talent(3, 3)", "player.chi.deficit >= 2", "player.buff(128939).count <= 10", "player.spell(Chi Brew).charges == 1", "player.spell(Chi Brew).recharge < 5" } },
	{ "Chi Brew", { "talent(3, 3)", "player.chi.deficit >= 2", "player.buff(128939).count <= 10", "player.spell(Chi Brew).charges == 2" } },
	{ "Chi Brew", { "talent(3, 3)", "player.chi.deficit >= 2", "player.buff(128939).count <= 10", "target.boss", "target.deathin < 15", (function() return NetherMachine.condition["spell.cooldown"]("player","Touch of Death") > NetherMachine.condition["deathin"]("target") end) } },
	{ "Chi Brew", { "talent(3, 3)", "player.chi.deficit >= 2", "player.buff(128939).count <= 10", "target.boss", "target.deathin < 15", "player.glyph(123391)" } },
	-- actions+=/chi_brew,if=(chi<1&stagger.heavy)|(chi<2&buff.shuffle.down)
	{ "Chi Brew", { "player.chi < 1", "player.debuff(Heavy Stagger)" } },
	{ "Chi Brew", { "player.chi < 2", "!player.buff(Shuffle)" } },
	-- actions+=/gift_of_the_ox,if=buff.gift_of_the_ox.react&incoming_damage_1500ms
	-- actions+=/diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
	{ "Diffuse Magic", { "player.health < 100", "target.exists", "target.enemy", "target.casting.percent >= 50", "targettarget.istheplayer", "!player.buff(Fortifying Brew)" } },
	-- actions+=/dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down
	{ "Dampen Harm", { "player.health < 100", "target.exists", "target.enemy", "!player.buff(Fortifying Brew)", "!player.buff(115308)" } },
	-- actions+=/fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
	{ "Fortifying Brew", { "player.health < 100", "target.exists", "target.enemy", "targettarget.istheplayer", "!player.buff(115308)", "!player.buff(Dampen Harm)" } },
	{ "Fortifying Brew", { "player.health < 100", "target.exists", "target.enemy", "targettarget.istheplayer", "!player.buff(115308)", "!player.buff(Diffuse Magic)" } },
	-- actions+=/use_item,name=tablet_of_turnbuckle_teamwork,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.fortifying_brew.down&buff.elusive_brew_activated.down
	{ "#trinket1", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },
	{ "#trinket2", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },
	-- actions+=/elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
	{ "Elusive Brew", { "target.exists", "target.enemy", "targettarget.istheplayer", "player.buff(Elusive Brew).count >= 9", "!player.buff(115308)", "!player.buff(Dampen Harm)" } },
	{ "Elusive Brew", { "target.exists", "target.enemy", "targettarget.istheplayer", "player.buff(Elusive Brew).count >= 9", "!player.buff(115308)", "!player.buff(Diffuse Magic)" } },
	-- actions+=/invoke_xuen,if=talent.invoke_xuen.enabled&target.time_to_die>15&buff.shuffle.remains>=3&buff.serenity.down
	{ "Invoke Xuen, the White Tiger", { "modifier.cooldowns", "player.time > 5", "talent(6, 2)", "target.deathin > 15", "player.buff(Shuffle).remains >= 3", "!player.buff(Serenity)" } },
	-- actions+=/serenity,if=talent.serenity.enabled&cooldown.keg_smash.remains>6
	{ "Serenity", { "talent(7, 3)", "player.spell(Keg Smash).cooldown > 6" } },
	-- actions+=/potion,name=draenic_armor,if=(buff.fortifying_brew.down&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down)
	{ "#109220", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "!player.buff(Fortifying Brew)", "!player.buff(115308)", "!player.buff(Dampen Harm)", "player.health < 70" } }, -- Draenic Agility Potion
	{ "#109220", { "modifier.cooldowns", "toggle.consume", "target.exists", "target.boss", "!player.buff(Fortifying Brew)", "!player.buff(115308)", "!player.buff(Diffuse Magic)", "player.health < 70" } }, -- Draenic Agility Potion
	-- actions+=/touch_of_death,if=target.health.percent<10&cooldown.touch_of_death.remains=0&((!glyph.touch_of_death.enabled&chi>=3&target.time_to_die<8)|(glyph.touch_of_death.enabled&target.time_to_die<5))
	{ "Touch of Death", "player.buff(Death Note)" },
	--{ "Touch of Death", { "target.health < 10", "!player.glyph(124456)", "player.chi >= 3", "target.deathin < 8" } },
	--{ "Touch of Death", { "target.health < 10", "player.glyph(124456)", "target.deathin < 5" } },

	-- MOUSEOVERS
	--{ "Dizzying Haze", { "target.exists", "target.enemy", "target.combat", "target.distance > 15", "target.distance < 40", "!target.debuff(Dizzying Haze)", "!modifier.last" }, "target.ground" },
	--{ "Dizzying Haze", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.combat", "mouseover.distance > 15", "mouseover.distance < 40", "!mouseover.debuff(Dizzying Haze)" }, "mouseover.ground" },

	-- "Non-Smart" SINGLE TARGET ROTATION
	{ {
		-- actions.st=purifying_brew,if=stagger.heavy
		{ "Purifying Brew", { "player.debuff(Heavy Stagger)" } },
		-- actions.st+=/blackout_kick,if=buff.shuffle.down
		{ "Blackout Kick", "!player.buff(Shuffle)" },
		-- actions.st+=/purifying_brew,if=buff.serenity.up
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Light Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Moderate Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Heavy Stagger)" } },
		-- actions.st+=/chi_explosion,if=chi>=3
		{ "Chi Explosion", "player.chi >= 3" },
		-- actions.st+=/purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
		{ "Purifying Brew", { "player.debuff(Moderate Stagger)", "player.buff(Shuffle).remains >= 6" } },
		-- actions.st+=/guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 1", "player.spell(Guard).recharge < 5" } },
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 2" } },
		{ "Guard", { "!player.buff(Guard)", "target.boss", "target.deathin < 15" } },
		-- actions.st+=/guard,if=incoming_damage_10s>=health.max*0.5
		{ "Guard", { "!player.buff(Guard)", "player.health <= 70" } },
		-- actions.st+=/chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi.max-chi>=2&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi.deficit >= 2", "!player.glyph(124456)", "player.buff(Shuffle).remains >= 6" } },
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi.deficit >= 2", "!player.glyph(124456)", (function() return NetherMachine.condition["deathin"]("target") < NetherMachine.condition["buff.remains"]("player","Shuffle") end) } },
		-- actions.st+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
		{ "Keg Smash", { "player.chi.deficit >= 2", "!player.buff(Serenity)" } },
		-- actions.st+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
		{ "Blackout Kick", { "player.buff(Shuffle).remains <= 3", "player.spell(Keg Smash).cooldown >= 1" } },
		-- actions.st+=/blackout_kick,if=buff.serenity.up
		{ "Blackout Kick", "player.buff(Serenity)" },
		-- actions.st+=/chi_burst,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Burst", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.st+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Wave", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.st+=/zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
		{ "Zen Sphere", { "!player.buff(Zen Sphere)", "player.timetomax > 2", "!player.buff(Serenity)" }, "player" },
		-- actions.st+=/blackout_kick,if=chi.max-chi<2
		{ "Blackout Kick", "player.chi.deficit < 2" },
		-- actions.st+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Expel Harm", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.st+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Jab", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", "player.spell(Expel Harm).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.st+=/tiger_palm
		{ "Tiger Palm" },
	},{
		"!modifier.multitarget", "!toggle.smartaoe",
	} },

	-- "Non-Smart" MULTIPLE TARGET ROTATION
	{ {
		-- actions.aoe=purifying_brew,if=stagger.heavy
		{ "Purifying Brew", "player.debuff(Heavy Stagger)" },
		-- actions.aoe+=/blackout_kick,if=buff.shuffle.down
		{ "Blackout Kick", "!player.buff(Shuffle)" },
		-- actions.aoe+=/purifying_brew,if=buff.serenity.up
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Light Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Moderate Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Heavy Stagger)" } },
		-- actions.aoe+=/chi_explosion,if=chi>=4
		{ "Chi Explosion", "player.chi >= 4" },
		-- actions.aoe+=/purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
		{ "Purifying Brew", { "player.debuff(Moderate Stagger)", "player.buff(Shuffle).remains >= 6" } },
		-- actions.aoe+=/guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 1", "player.spell(Guard).recharge < 5" } },
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 2" } },
		{ "Guard", { "!player.buff(Guard)", "target.boss", "target.deathin < 15" } },
		-- actions.aoe+=/guard,if=incoming_damage_10s>=health.max*0.5
		{ "Guard", { "!player.buff(Guard)", "player.health <= 70" } },
		-- actions.aoe+=/chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi<=3&chi>=1&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi <= 3", "player.chi >= 1", "!player.glyph(124456)", "player.buff(Shuffle).remains >= 6" } },
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi <= 3", "player.chi >= 1", "!player.glyph(124456)", (function() return NetherMachine.condition["deathin"]("target") < NetherMachine.condition["buff.remains"]("player","Shuffle") end) } },
		-- actions.aoe+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
		{ "Keg Smash", { "player.chi.deficit >= 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
		{ "Blackout Kick", { "player.buff(Shuffle).remains <= 3", "player.spell(Keg Smash).cooldown >= 1" } },
		-- actions.aoe+=/blackout_kick,if=buff.serenity.up
		{ "Blackout Kick", "player.buff(Serenity)" },
		-- actions.aoe+=/rushing_jade_wind,if=chi.max-chi>=1&buff.serenity.down
		{ "Rushing Jade Wind", { "player.chi.deficit >= 1", "!player.buff(Serenity)" } },
		-- actions.aoe+=/chi_burst,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Burst", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Wave", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
		{ "Zen Sphere", { "!player.buff(Zen Sphere)", "player.timetomax > 2", "!player.buff(Serenity)" }, "player" },
		-- actions.aoe+=/blackout_kick,if=chi.max-chi<2
		{ "Blackout Kick", "player.chi.deficit < 2" },
		-- actions.aoe+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Expel Harm", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.aoe+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Jab", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", "player.spell(Expel Harm).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.aoe+=/tiger_palm
		{ "Tiger Palm" },
	},{
		"modifier.multitarget", "!toggle.smartaoe",
	} },

	-- "Smart" SINGLE TARGET ROTATION [<=2]
	{ {
		-- actions.st=purifying_brew,if=stagger.heavy
		{ "Purifying Brew", { "player.debuff(Heavy Stagger)" } },
		-- actions.st+=/blackout_kick,if=buff.shuffle.down
		{ "Blackout Kick", "!player.buff(Shuffle)" },
		-- actions.st+=/purifying_brew,if=buff.serenity.up
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Light Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Moderate Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Heavy Stagger)" } },
		-- actions.st+=/chi_explosion,if=chi>=3
		{ "Chi Explosion", "player.chi >= 3" },
		-- actions.st+=/purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
		{ "Purifying Brew", { "player.debuff(Moderate Stagger)", "player.buff(Shuffle).remains >= 6" } },
		-- actions.st+=/guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 1", "player.spell(Guard).recharge < 5" } },
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 2" } },
		{ "Guard", { "!player.buff(Guard)", "target.boss", "target.deathin < 15" } },
		-- actions.st+=/guard,if=incoming_damage_10s>=health.max*0.5
		{ "Guard", { "!player.buff(Guard)", "player.health <= 70" } },
		-- actions.st+=/chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi.max-chi>=2&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi.deficit >= 2", "!player.glyph(124456)", "player.buff(Shuffle).remains >= 6" } },
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi.deficit >= 2", "!player.glyph(124456)", (function() return NetherMachine.condition["deathin"]("target") < NetherMachine.condition["buff.remains"]("player","Shuffle") end) } },
		-- actions.st+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
		{ "Keg Smash", { "player.chi.deficit >= 2", "!player.buff(Serenity)" } },
		-- actions.st+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
		{ "Blackout Kick", { "player.buff(Shuffle).remains <= 3", "player.spell(Keg Smash).cooldown >= 1" } },
		-- actions.st+=/blackout_kick,if=buff.serenity.up
		{ "Blackout Kick", "player.buff(Serenity)" },
		-- actions.st+=/chi_burst,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Burst", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.st+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Wave", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.st+=/zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
		{ "Zen Sphere", { "!player.buff(Zen Sphere)", "player.timetomax > 2", "!player.buff(Serenity)" }, "player" },
		-- actions.st+=/blackout_kick,if=chi.max-chi<2
		{ "Blackout Kick", "player.chi.deficit < 2" },
		-- actions.st+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Expel Harm", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.st+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Jab", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", "player.spell(Expel Harm).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.st+=/tiger_palm
		{ "Tiger Palm" },
	},{
		"toggle.smartaoe", "!player.area(10).enemies >= 3",
	} },

	-- "Smart" MULTIPLE TARGET ROTATION [>=3]
	{ {
		-- actions.aoe=purifying_brew,if=stagger.heavy
		{ "Purifying Brew", "player.debuff(Heavy Stagger)" },
		-- actions.aoe+=/blackout_kick,if=buff.shuffle.down
		{ "Blackout Kick", "!player.buff(Shuffle)" },
		-- actions.aoe+=/purifying_brew,if=buff.serenity.up
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Light Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Moderate Stagger)" } },
		{ "Purifying Brew", { "player.buff(Serenity)", "player.debuff(Heavy Stagger)" } },
		-- actions.aoe+=/chi_explosion,if=chi>=4
		{ "Chi Explosion", "player.chi >= 4" },
		-- actions.aoe+=/purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
		{ "Purifying Brew", { "player.debuff(Moderate Stagger)", "player.buff(Shuffle).remains >= 6" } },
		-- actions.aoe+=/guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 1", "player.spell(Guard).recharge < 5" } },
		{ "Guard", { "!player.buff(Guard)", "player.spell(Guard).charges == 2" } },
		{ "Guard", { "!player.buff(Guard)", "target.boss", "target.deathin < 15" } },
		-- actions.aoe+=/guard,if=incoming_damage_10s>=health.max*0.5
		{ "Guard", { "!player.buff(Guard)", "player.health <= 70" } },
		-- actions.aoe+=/chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi<=3&chi>=1&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi <= 3", "player.chi >= 1", "!player.glyph(124456)", "player.buff(Shuffle).remains >= 6" } },
		{ "Chi Brew", { "target.health < 10", "player.spell(Touch of Death).cooldown == 0", "player.chi <= 3", "player.chi >= 1", "!player.glyph(124456)", (function() return NetherMachine.condition["deathin"]("target") < NetherMachine.condition["buff.remains"]("player","Shuffle") end) } },
		-- actions.aoe+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
		{ "Keg Smash", { "player.chi.deficit >= 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
		{ "Blackout Kick", { "player.buff(Shuffle).remains <= 3", "player.spell(Keg Smash).cooldown >= 1" } },
		-- actions.aoe+=/blackout_kick,if=buff.serenity.up
		{ "Blackout Kick", "player.buff(Serenity)" },
		-- actions.aoe+=/rushing_jade_wind,if=chi.max-chi>=1&buff.serenity.down
		{ "Rushing Jade Wind", { "player.chi.deficit >= 1", "!player.buff(Serenity)" } },
		-- actions.aoe+=/chi_burst,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Burst", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/chi_wave,if=energy.time_to_max>2&buff.serenity.down
		{ "Chi Wave", { "player.timetomax > 2", "!player.buff(Serenity)" } },
		-- actions.aoe+=/zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
		{ "Zen Sphere", { "!player.buff(Zen Sphere)", "player.timetomax > 2", "!player.buff(Serenity)" }, "player" },
		-- actions.aoe+=/blackout_kick,if=chi.max-chi<2
		{ "Blackout Kick", "player.chi.deficit < 2" },
		-- actions.aoe+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Expel Harm", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.aoe+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
		{ "Jab", { "player.chi.deficit >= 1", "player.spell(Keg Smash).cooldown >= 1", "player.spell(Expel Harm).cooldown >= 1", (function() return ((NetherMachine.condition["energy"]('player')+(NetherMachine.condition["energy.regen"]('player')*(NetherMachine.condition["spell.cooldown"]('player', 'Keg Smash')))) >= 80) end) } },
		-- actions.aoe+=/tiger_palm
		{ "Tiger Palm" },
	},{
		"toggle.smartaoe", "player.area(10).enemies >= 3",
	} },


},{
-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buffs
	{ "Legacy of the White Tiger", { "player.ooctime > 3", "!player.buffs.stats" } },

	-- OOC Healing
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD
	{ "Surging Mist", { "player.health <= 90",  "!player.moving", "player.energy >= 70" } },

	-- Ground Stuff
	{ "Dizzying Haze", { "modifier.lshift", "player.area(40).enemies > 0" }, "ground" },
	{ "Summon Black Ox Statue", "modifier.lalt", "ground" },

	-- actions.precombat=flask,type=greater_draenic_agility_flask
	-- actions.precombat+=/food,type=sleeper_sushi
	-- actions.precombat+=/stance,choose=sturdy_ox
	-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/potion,name=draenic_armor
	-- actions.precombat+=/dampen_harm

},
function()
	NetherMachine.toggle.create('smartaoe', 'Interface\\Icons\\Ability_Racial_RocketBarrage', 'Enable Smart AoE Detection', 'Toggle the usage of smart detection of Single/AoE target roation selection abilities.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to avoid using CC breaking aoe effects.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autotaunt', 'Interface\\Icons\\spell_nature_reincarnation', 'Auto Taunt', 'Automaticaly taunt the boss at the appropriate stacks')
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
end)
