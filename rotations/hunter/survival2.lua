-- NetherMachine Rotation
-- Survival Hunter - WoD 6.0.3
-- Updated on Jan 15th 2015

-- SUGGESTED TALENTS: 0003313 Crouching, Binding Shot, Iron Hawk, Steady Focus, A Murder of Crows, Barrage, Focusing Shot
-- SUGGESTED GLYPHS: Animal Bond, Deterrence, Pathfinding, Aspect of the Cheetah
-- CONTROLS: Pause - Left Control, Explosive/Ice/Snake Traps - Left Alt, Freezing Trap - Right Alt, Scatter Shot - Right Control

NetherMachine.rotation.register_custom(255, "bbHunter Survival (SimC T17N)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "player.buff(Feign Death)" },
	{ "pause", "player.buff(Camouflage)" },
	{ "pause", "target.istheplayer" },

	-- FROGING
	{ {
		{ "Flare", "@bbLib.engaugeUnit('ANY', 40, false)" },
	}, "toggle.autoattack" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- BOSS MODS
	--{ "Feign Death", { "modifier.raid", "target.exists", "target.enemy", "target.boss", "target.agro", "target.distance < 30" } },
	--{ "Feign Death", { "modifier.raid", "player.debuff(Aim)", "player.debuff(Aim).duration > 3" } }, --SoO: Paragons - Aim

	-- INTERRUPTS / DISPELLS
	{ "Counter Shot", "modifier.interrupt" },
	{ "Counter Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },
	{ "Tranquilizing Shot", "target.dispellable", "target" },
	{ "Tranquilizing Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.dispellable" }, "mouseover" },

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "883", { "!talent(7, 3)", "!pet.exists", "!modifier.last" } }, -- Call Pet 1
	{ "Heart of the Phoenix", { "pet.exists", "pet.dead", "!modifier.last" } },
	{ "Mend Pet", { "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
	{ "Revive Pet", { "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

	-- TRAPS
	{ "Trap Launcher", { "!modifier.last", "!player.buff(Trap Launcher)" } },
	{ "Explosive Trap", { "modifier.lalt", "player.buff(Trap Launcher)" }, "ground" }, -- mouseover.ground?
	{ "Ice Trap", { "modifier.lalt", "player.buff(Trap Launcher)" }, "ground" },
	{ "Freezing Trap", { "modifier.lshift", "player.buff(Trap Launcher)" }, "ground" },

	-- MISDIRECTION ( focus -> tank -> pet )
	{ {
		{ "Misdirection", { "focus.exists", "focus.friend", "focus.alive", "focus.distance < 90"  }, "focus" },
		--{ "Misdirection", { "modifier.raid", "tank.exists", "tank.alive", "tank.distance < 100" }, "tank" },
		{ "Misdirection", { "!talent(7, 3)", "pet.exists", "pet.alive", "pet.distance < 100" }, "pet" },
	},{
		"!toggle.pvpmode", "!target.isPlayer", "!player.buff(Misdirection)", "target.threat > 30",
	} },

	-- DEFENSIVE COOLDOWNS
	{ "Exhilaration", "player.health < 40" },
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	{ "#118916", { "toggle.consume", "player.health < 40", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Healing Tonic
	{ "Master's Call", { "!talent(7, 3)", "player.state.disorient" }, "player" },
	{ "Master's Call", { "!talent(7, 3)", "player.state.stun" }, "player" },
	{ "Master's Call", { "!talent(7, 3)", "player.state.root" }, "player" },
	{ "Master's Call", { "!talent(7, 3)", "player.state.snare" }, "player" },
	{ "Deterrence", { "!talent(7, 3)", "player.health < 20" } },

	-- Pre-DPS PAUSE
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.debuff(Freezing Trap).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- COMMON / COOLDOWNS
	{ {
		{ "#trinket1" },
		{ "#trinket2" },
		{ "Arcane Torrent", "player.focus.deficit >= 50" },
		{ "Blood Fury" },
		{ "Berserking" },
		-- actions+=/potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.trinket.any > 0" } }, -- Draenic Agility Potion
		-- actions+=/stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=25
		{ "Stampede", { "target.boss", "player.buff(Draenic Agility Potion)" } },
		{ "Stampede", { "target.boss", "player.buff(Brawler's Draenic Agility Potion)" } },
		{ "Stampede", { "target.boss", "player.trinket.any > 0" } },
		{ "Stampede", { "target.boss", "player.hashero" } },
		{ "Stampede", { "target.boss", "player.buff(Berserking)" } },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },

	-- MULTI TARGET ROTATION
	{ {
		-- actions.aoe+=/explosive_shot,if=buff.lock_and_load.react&(!talent.barrage.enabled|cooldown.barrage.remains>0)
		{ "Explosive Shot", { "player.buff(Lock and Load)", "!talent(6, 3)" } },
		{ "Explosive Shot", { "player.buff(Lock and Load)", "talent(6, 3)", "player.spell(Barrage).cooldown > 0" } },
		-- actions.aoe+=/barrage
		{ "Multi-Shot", { "target.health > 75", "!target.debuff(Serpent Sting)" } },
		--{ "Barrage", nil, nil },
		{ "Barrage" },
		--{ "Cobra Shot", { "player.spell(Barrage).cooldown < 1.5", "player.focus < 60", "target.area(7).enemies > 3" } },
		-- actions.aoe+=/black_arrow,if=!ticking
		{ "Black Arrow", { "!target.debuff", "!target.classification(minus, trivial)" } },
		-- actions.aoe+=/explosive_shot,if=active_enemies<5
		{ "Explosive Shot", "target.area(12).enemies < 5" },
		-- actions.aoe+=/explosive_trap,if=dot.explosive_trap.remains<=5
		{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
		{ "Explosive Trap", { "target.enemy", "!target.moving", "player.buff(Trap Launcher)", "target.debuff(Explosive Trap).remains <= 5", "target.range < 35" }, "target.ground" },
		-- actions.aoe+=/a_murder_of_crows
		{ "A Murder of Crows", "!target.classification(minus, trivial)" },
		-- actions.aoe+=/dire_beast
		{ "Dire Beast", "!target.classification(minus, trivial)" },
		-- actions.aoe+=/multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
		{ "Multi-Shot", { "player.buff(Thrill of the Hunt)", "player.focus > 50" } },
		{ "Multi-Shot", { "target.debuff(Serpent Sting).remains <= 5" } },
		{ "Multi-Shot", { "target.deathin < 4.5" } },
		-- actions.aoe+=/glaive_toss
		{ "Glaive Toss" },
		-- actions.aoe+=/powershot
		{ "Powershot" },
		-- actions.aoe+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
		{ "Cobra Shot", { "talent(4, 1)", "modifier.last", "player.buff(Steady Focus).remains < 5", (function() local _, regen = GetPowerRegen(); local name, _, _, castTime = GetSpellInfo(spell); if name and regen then if castTime == 0 then castTime = 1500 end; return UnitPower('player', SPELL_POWER_FOCUS) + 14 + ((castTime/1000) * regen) < 80; end return false; end) } },
		-- actions.aoe+=/multishot,if=focus>=70|talent.focusing_shot.enabled
		{ "Multi-Shot", { "player.focus >= 70", "player.spell(Barrage).cooldown > 4" } },
		{ "Multi-Shot", { "talent(7, 2)", "!target.debuff(Serpent Sting)" } },
		{ "Multi-Shot", { "talent(7, 2)", "player.spell(Barrage).cooldown > 5" } },
		-- PvP
		{ "Aspect of the Cheetah", { "player.glyph(119462)", "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } }, -- 10sec cd now unless glyphed
		{ "Concussive Shot", { "toggle.pvpmode", "!target.debuff.any", "target.moving", "!target.immune.snare" } },
		-- actions.aoe+=/focusing_shot
		{ "Focusing Shot", "player.focus.deficit > 30" },
		-- actions.aoe+=/cobra_shot
		{ "Cobra Shot", "player.focus.deficit > 30" },
	},{
		"modifier.multitarget", "target.area(7).enemies > 1"
	} },

	-- SINGLE TARGET ROTATION
	-- actions+=/a_murder_of_crows
	{ "A Murder of Crows" },
	-- actions+=/black_arrow,if=!ticking
	{ "Black Arrow" },
	-- actions+=/explosive_shot
	{ "Explosive Shot" },
	-- actions+=/dire_beast
	{ "Dire Beast" },
	-- actions+=/arcane_shot,if=buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit|dot.serpent_sting.remains<=3|target.time_to_die<4.5
	{ "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.focus > 35" } },
	{ "Arcane Shot", { "target.debuff(Serpent Sting).remains <= 3" } },
	--{ "Arcane Shot", "target.deathin < 4.5" },
	-- Barrage?
	{ "Barrage", { "modifier.multitarget", "target.area(7).enemies > 1" } },
	{ "Glaive Toss" },
	-- actions+=/explosive_trap
	{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
	{ "Explosive Trap", { "target.enemy", "!target.unitname(Kromog)", "!target.moving", "player.buff(Trap Launcher)", "target.range < 35" }, "target.ground" },
	-- # Cast a second shot for steady focus if that won't cap us.
	-- actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit
	{ "Cobra Shot", { "talent(4, 1)", "modifier.last", "player.buff(Steady Focus).remains < 5", (function() local _, regen = GetPowerRegen() local name, _, _, castTime = GetSpellInfo(spell) if name and regen then if castTime == 0 then castTime = 1500 end return 14 + ((castTime/1000) * regen) <= (UnitPowerMax('player', SPELL_POWER_FOCUS) - UnitPower('player', SPELL_POWER_FOCUS)) end return false end) } },
	-- actions+=/arcane_shot,if=focus>=80|talent.focusing_shot.enabled
	{ "Arcane Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.alive", "mouseover.combat", "player.focus >= 45", "!mouseover.debuff(Serpent Sting)", "!modifier.last", "!mouseover.classification(minus, trivial)" }, "mouseover" },
	{ "Arcane Shot", "player.focus >= 80" },
	{ "Arcane Shot", { "talent(7, 2)", "player.focus > 40" } },
	-- PVP
	{ "Aspect of the Cheetah", { "player.glyph(119462)", "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } }, -- 10sec cd now unless glyphed
	{ "Concussive Shot", { "toggle.pvpmode", "!target.debuff(Frozen Ammo)", "!target.debuff(Concussive Shot).any", "target.moving", "!target.immune.snare" } },
	-- actions+=/focusing_shot
	{ "Focusing Shot", "player.focus < 80" },
	-- actions+=/cobra_shot
	{ "Cobra Shot", "player.focus < 80" },

},{
	-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	--{ "/click ExtraActionButton1", { "player.buff(Magic Wings)", "player.buff(Magic Wings).remains <= 1" } },
	{ "pause", "player.buff(Feign Death)" },
	{ "Aspect of the Cheetah", { "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } },
	{ "pause", "player.buff(Camouflage)" },

	-- OOC HEALING
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD

	-- AUTO LOOT
	{ "Fetch", { "!talent(7, 3)", "player.glyph(126746)", "timeout(Fetch, 9)", "player.ooctime < 30", "!player.moving", "!target.exists", "!player.busy" } }, --/targetlasttarget /use [@target,exists,dead] Fetch

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "883", { "!talent(7, 3)", "!pet.exists", "!modifier.last" } }, -- Call Pet 1
	{ "Heart of the Phoenix", { "!talent(7, 3)", "pet.exists", "pet.dead", "!modifier.last" } },
	{ "Mend Pet", { "!talent(7, 3)", "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
	{ "Revive Pet", { "!talent(7, 3)", "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

	-- TRAPS
	{ "Trap Launcher", { "!modifier.last", "!player.buff(Trap Launcher)" } },
	{ "Explosive Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" }, -- mouseover.ground?
	{ "Ice Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },
	{ "Freezing Trap", { "modifier.lshift", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },

	-- ASPECTS
	{ "Camouflage", { "toggle.camomode", "!player.buff", "player.health < 85", "!player.debuff(Orb of Power)", "!modifier.last", "player.ooctime > 4" } },

	-- FROGING
	{ {
		{ "Flare", "@bbLib.engaugeUnit('ANY', 40, false)" },
		{ "Auto Shot", { "target.exists", "target.enemy", "target.alive" } },
		{ "Glaive Toss", { "target.exists", "target.enemy", "target.alive" } },
		{ "Explosive Shot", { "target.exists", "target.enemy", "target.alive" } },
		{ "Arcane Shot", { "target.exists", "target.enemy", "target.alive" } },
	}, "toggle.autoattack" },

},function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_hunter_quickshot', 'Use Mouseovers', 'Toggle automatic usage of stings/scatter/etc on eligible mouseover targets.')
	NetherMachine.toggle.create('camomode', 'Interface\\Icons\\ability_hunter_displacement', 'Use Camouflage', 'Toggle the usage Camouflage when out of combat.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack any anemies in range of the player.')
end)







-- NetherMachine Rotation
-- Survival Hunter - WoD 6.1
-- Updated on March 17th 2015

-- SUGGESTED TALENTS: 3123332
-- SUGGESTED GLYPHS: Animal Bond, Deterrence, Disengage, Aspect of the Cheetah
-- CONTROLS: Pause - Left Control, Explosive/Ice/Snake Traps - Left Alt, Freezing Trap - Right Alt, Scatter Shot - Right Control

NetherMachine.rotation.register_custom(255, "bbHunter Survival (Icy-Veins)", {
	-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "player.buff(Feign Death)" },
	{ "pause", "player.buff(Camouflage)" },
	{ "pause", "target.istheplayer" },

	-- FROGING
	{ {
		{ "Flare", "@bbLib.engaugeUnit('ANY', 40, false)" },
	}, "toggle.autoattack" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- BOSS MODS
	--{ "Feign Death", { "modifier.raid", "target.exists", "target.enemy", "target.boss", "target.agro", "target.distance < 30" } },
	--{ "Feign Death", { "modifier.raid", "player.debuff(Aim)", "player.debuff(Aim).duration > 3" } }, --SoO: Paragons - Aim

	-- INTERRUPTS / DISPELLS
	{ "Counter Shot", "target.interrupt" },
	{ "Counter Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },
	{ "Tranquilizing Shot", "target.dispellable" },
	{ "Tranquilizing Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.dispellable" }, "mouseover" },

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "883", { "!talent(7, 3)", "!pet.exists", "!modifier.last" } }, -- Call Pet 1
	{ "Heart of the Phoenix", { "pet.exists", "pet.dead", "!modifier.last" } },
	{ "Mend Pet", { "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
	{ "Revive Pet", { "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

	-- TRAPS
	{ "Trap Launcher", { "!modifier.last", "!player.buff(Trap Launcher)" } },
	{ "Explosive Trap", { "modifier.lalt", "player.buff(Trap Launcher)" }, "ground" }, -- mouseover.ground?
	{ "Ice Trap", { "modifier.lalt", "player.buff(Trap Launcher)" }, "ground" },
	{ "Freezing Trap", { "modifier.lshift", "player.buff(Trap Launcher)" }, "ground" },

	-- MISDIRECTION ( focus -> tank -> pet )
	{ {
		{ "Misdirection", { "focus.exists", "focus.friend", "focus.alive", "focus.distance < 90"  }, "focus" },
		--{ "Misdirection", { "modifier.raid", "tank.exists", "tank.alive", "tank.distance < 100" }, "tank" },
		{ "Misdirection", { "!talent(7, 3)", "pet.exists", "pet.alive", "pet.distance < 100" }, "pet" },
	},{
		"!toggle.pvpmode", "!target.isPlayer", "!player.buff(Misdirection)", "target.threat > 30",
	} },

	-- DEFENSIVE COOLDOWNS
	{ "Exhilaration", "player.health < 40" },
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	{ "#118916", { "toggle.consume", "player.health < 40", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Healing Tonic
	{ "Master's Call", { "!talent(7, 3)", "player.state.disorient" }, "player" },
	{ "Master's Call", { "!talent(7, 3)", "player.state.stun" }, "player" },
	{ "Master's Call", { "!talent(7, 3)", "player.state.root" }, "player" },
	{ "Master's Call", { "!talent(7, 3)", "player.state.snare" }, "player" },
	{ "Deterrence", { "!talent(7, 3)", "player.health < 20" } },

	-- Pre-DPS PAUSE
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.debuff(Freezing Trap).any" },
	{ "pause", "target.buff(Divine Bulwark)" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- COMMON / COOLDOWNS
	{ {
		{ "#trinket1" },
		{ "#trinket2" },
		{ "Arcane Torrent", "player.focus < 75" },
		{ "Blood Fury" },
		{ "Berserking" },
		-- actions+=/potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.trinket.any > 0" } }, -- Draenic Agility Potion
		-- actions+=/stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=25
		{ "Stampede", { "target.boss", "player.buff(Draenic Agility Potion)" } },
		{ "Stampede", { "target.boss", "player.buff(Brawler's Draenic Agility Potion)" } },
		{ "Stampede", { "target.boss", "player.buff(Lub-Dub)" } },
		{ "Stampede", { "target.boss", "player.hashero" } },
		{ "Stampede", { "target.boss", "player.buff(Berserking)" } },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },

	-- DPS ROTATION
	{ "Multi-Shot", { "modifier.multitarget", "!target.debuff(Serpent Sting)", "!modifier.last", "target.area(7).enemies > 1" } },
	{ "Arcane Shot", { "!target.debuff(Serpent Sting)", "!modifier.last", "target.area(7).enemies == 1" } },
	{ "Barrage", { "modifier.multitarget", "target.area(7).enemies > 7" } },
	{ "Explosive Shot", "player.buff(Lock and Load)" },
	{ "Explosive Shot", "!player.buff(Heavy Shot)" },
	{ "Barrage", { "modifier.multitarget", "target.area(7).enemies > 1" } },
	{ "Multi-Shot", { "modifier.multitarget", "target.area(7).enemies > 7", "player.spell(Barrage).cooldown > 1.5" } },
	{ "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.multistrike.percent >= 70" } },
	{ "Explosive Shot" },
	{ "Black Arrow", "target.deathin >= 10" },
	{ "A Murder of Crows", "!target.classification(minus, trivial)" },
	{ "Cobra Shot", { "talent(4, 1)", "modifier.last", "player.buff(Steady Focus).remains < 5", "player.focus < 75" } },
	{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
	{ "Explosive Trap", { "modifier.multitarget", "target.enemy", "!target.unitname(Kromog)", "!target.moving", "player.buff(Trap Launcher)", "target.distance.actual < 40", "player.focus > 50", "player.spell(Explosive Shot).cooldown > 2" }, "target.ground" },
	{ "Explosive Trap", { "modifier.multitarget", "target.enemy", "!target.unitname(Kromog)", "!target.moving", "player.buff(Trap Launcher)", "target.distance.actual < 40", "target.area(7).enemies > 1" }, "target.ground" },
	{ "Glaive Toss" },
	{ "Barrage", "modifier.multitarget" },
	{ "Powershot", "modifier.multitarget" },
	{ "Dire Beast", "!target.classification(minus, trivial)" },
	{ {
		{ "Multi-Shot", { "player.focus >= 75" } },
		{ "Multi-Shot", { "target.debuff(Serpent Sting).remains <= 5" } },
	},{
		"target.area(7).enemies > 2", "player.spell(Barrage).cooldown > 1.5"
	} },
	{ {
		{ "Arcane Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.alive", "mouseover.combat", "player.focus >= 45", "mouseover.debuff(Serpent Sting).remains <= 5", "!modifier.last", "!mouseover.classification(minus, trivial)" }, "mouseover" },
		{ "Arcane Shot", "player.focus >= 75" },
		{ "Arcane Shot", "target.debuff(Serpent Sting).remains <= 5" },
	},{
		"target.area(7).enemies < 3"
	} },
	--keep up cheetah if we have the glyph
	{ "Concussive Shot", { "toggle.pvpmode", "!target.debuff(Frozen Ammo)", "!target.debuff(Concussive Shot).any", "target.moving", "!target.immune.snare" } },
	{ "Aspect of the Cheetah", { "player.glyph(119462)", "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } }, -- 10sec cd now unless glyphed
	--Cast Cobra Shot Icon Cobra Shot (or Focusing Shot Icon Focusing Shot, if you have taken this talent) to generate Focus.
	{ "Focusing Shot", "player.focus < 60" },
	{ "Focusing Shot", { "player.focus < 75", "player.spell(Explosive Shot).cooldown > 1.5" } },
	{ "Cobra Shot", "player.focus < 75" },
	{ "Cobra Shot", { "player.spell(Explosive Shot).cooldown > 1.5", "player.spell(Barrage).cooldown > 1.5", "player.spell().cooldown > 1.5" } },

},{
	-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	--{ "/click ExtraActionButton1", { "player.buff(Magic Wings)", "player.buff(Magic Wings).remains <= 1" } },
	{ "pause", "player.buff(Feign Death)" },
	{ "Aspect of the Cheetah", { "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } },
	{ "pause", "player.buff(Camouflage)" },

	-- OOC HEALING
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "883", { "!talent(7, 3)", "!pet.exists", "!modifier.last" } }, -- Call Pet 1
	{ "Heart of the Phoenix", { "!talent(7, 3)", "pet.exists", "pet.dead", "!modifier.last" } },
	{ "Mend Pet", { "!talent(7, 3)", "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
	{ "Revive Pet", { "!talent(7, 3)", "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

	-- TRAPS
	{ "Trap Launcher", { "!modifier.last", "!player.buff(Trap Launcher)" } },
	{ "Explosive Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" }, -- mouseover.ground?
	{ "Ice Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },
	{ "Freezing Trap", { "modifier.lshift", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },

	-- FROGING
	{ {
		{ "Flare", "@bbLib.engaugeUnit('ANY', 40, false)" },
		{ "Auto Shot", { "target.exists", "target.enemy", "target.alive" } },
		{ "Glaive Toss", { "target.exists", "target.enemy", "target.alive" } },
		{ "Explosive Shot", { "target.exists", "target.enemy", "target.alive" } },
		{ "Arcane Shot", { "target.exists", "target.enemy", "target.alive" } },
	}, "toggle.autoattack" },

},function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_hunter_quickshot', 'Use Mouseovers', 'Toggle automatic usage of stings/scatter/etc on eligible mouseover targets.')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack any anemies in range of the player.')
end)
