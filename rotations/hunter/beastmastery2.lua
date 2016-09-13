-- NetherMachine Rotation
-- Beast Mastery Hunter - WoD 6.1
-- Updated on April 15th 2015

-- SUGGESTED TALENTS: 3121333
-- SUGGESTED GLYPHS: Deterrence, Disengage/Pathfinding, Animal Bond, Aspect of the Cheetah
-- CONTROLS: Pause - Left Control, Explosive/Ice/Snake Traps - Left Alt, Freezing Trap - Right Alt, Scatter Shot - Right Control

NetherMachine.rotation.register_custom(253, "bbHunter Beastmastery (SimC)", {
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
	{ "83242", { "!pet.exists", "!modifier.last" } }, -- Call Pet 1
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
		{ "Misdirection", { "!talent(7,3)", "pet.exists", "pet.alive", "pet.distance < 100" }, "pet" },
	},{
		"!toggle.pvpmode", "!target.isPlayer", "!player.buff(Misdirection)", "target.threat > 30",
	} },

	-- DEFENSIVE COOLDOWNS
	{ "Exhilaration", "player.health < 40" },
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	{ "#118916", { "toggle.consume", "player.health < 40", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Healing Tonic
	{ "Master's Call", { "!talent(7,3)", "player.state.disorient" }, "player" },
	{ "Master's Call", { "!talent(7,3)", "player.state.stun" }, "player" },
	{ "Master's Call", { "!talent(7,3)", "player.state.root" }, "player" },
	{ "Master's Call", { "!talent(7,3)", "player.state.snare" }, "player" },
	{ "Deterrence", { "!talent(7,3)", "player.health < 20" } },

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
		-- actions=auto_shot
		-- actions+=/use_item,name=beating_heart_of_the_mountain
		{ "#trinket1" },
		{ "#trinket2" },
		-- actions+=/arcane_torrent,if=focus.deficit>=30
		{ "Arcane Torrent", "player.focus.deficit >= 30" },
		-- actions+=/blood_fury
		{ "Blood Fury" },
		-- actions+=/berserking
		{ "Berserking" },
		-- actions+=/potion,name=draenic_agility,if=!talent.stampede.enabled&buff.bestial_wrath.up&target.health.pct<=20|target.time_to_die<=20
		{ "#109217", { "toggle.consume", "target.boss", "!talent(5,3)", "player.buff(Bestial Wrath)", "target.health <= 20" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "!talent(5,3)", "player.buff(Bestial Wrath)", "target.deathin <= 20" } }, -- Draenic Agility Potion
		-- actions+=/potion,name=draenic_agility,if=talent.stampede.enabled&cooldown.stampede.remains<1&(buff.bloodlust.up|buff.focus_fire.up)|target.time_to_die<=25
		{ "#109217", { "toggle.consume", "target.boss", "talent(5,3)", "player.spell(Stampede).cooldown <= 1.5", "player.hashero" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "talent(5,3)", "player.spell(Stampede).cooldown <= 1.5", "player.buff(Focus Fire)" } },
		{ "#109217", { "toggle.consume", "target.boss", "talent(5,3)", "player.spell(Stampede).cooldown <= 1.5", "target.deathin <= 25" } },
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
		-- actions+=/stampede,if=buff.bloodlust.up|buff.focus_fire.up|target.time_to_die<=25
		{ "Stampede", { "target.boss", "player.hashero" } },
		{ "Stampede", { "target.boss", "player.buff(Focus Fire)" } },
		{ "Stampede", { "player.buff(Draenic Agility Potion)" } },
		{ "Stampede", { "player.buff(Brawler's Draenic Agility Potion)" } },
		{ "Stampede", { "target.boss", "target.deathin <= 30" } },
		-- actions+=/dire_beast
		{ "Dire Beast" },
		-- actions+=/focus_fire,if=buff.focus_fire.down&((cooldown.bestial_wrath.remains<1&buff.bestial_wrath.down)|(talent.stampede.enabled&buff.stampede.remains)|pet.cat.buff.frenzy.remains<1)
		{ "Focus Fire", { "!player.buff(Focus Fire)", "player.buff(Frenzy)", "player.spell(Bestial Wrath).cooldown <= 1", "!player.buff(Bestial Wrath)" } },
		{ "Focus Fire", { "!player.buff(Focus Fire)", "player.buff(Frenzy)", "talent(5,3)", "player.spell(Stampede).cooldown > 265" } },
		{ "Focus Fire", { "!player.buff(Focus Fire)", "player.buff(Frenzy)", "player.buff(Frenzy).remains <= 1" } },
		-- actions+=/bestial_wrath,if=focus>30&!buff.bestial_wrath.up
		{ "Bestial Wrath", { "player.focus > 30", "!player.buff(Bestial Wrath)" } },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "pet.exists", "pet.alive",
	} },

	-- DPS ROTATION
	-- actions+=/multishot,if=active_enemies>1&pet.cat.buff.beast_cleave.remains<0.5
	{ "Multi-Shot", { "modifier.multitarget", "pet.exists", "pet.alive", "target.area(7).enemies > 1", "pet.buff(Beast Cleave).remains < 0.5", "!modifier.last" } },
	-- actions+=/focus_fire,five_stacks=1,if=buff.focus_fire.down
	{ "Focus Fire", { "!player.buff(Focus Fire)", "player.buff(Frenzy).count == 5" } },
	-- actions+=/barrage,if=active_enemies>1
	{ "Barrage", { "modifier.multitarget", "target.area(7).enemies > 1" } },
	-- actions+=/explosive_trap,if=active_enemies>5
	{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
	{ "Explosive Trap", { "modifier.multitarget", "target.enemy", "!target.moving", "player.buff(Trap Launcher)", "target.area(7).enemies > 5", "target.distance.actual < 40" }, "target.ground" },
	-- actions+=/multishot,if=active_enemies>5
	{ "Multi-Shot", { "modifier.multitarget", "target.area(7).enemies > 5" } },
	-- actions+=/kill_command
	{ "Kill Command", "target.distance(pet).actual < 25" },
	{ "Kill Command", "pettarget.distance(pet).actual < 25", "pettarget" },
	-- actions+=/a_murder_of_crows
	{ "A Murder of Crows", "!target.classification(minus, trivial)" },
	-- actions+=/kill_shot,if=focus.time_to_max>gcd
	{ "Kill Shot" },
	-- actions+=/focusing_shot,if=focus<50
	{ "Focusing Shot", "player.focus < 50" },
	-- # Cast a second shot for steady focus if that won't cap us.
	-- actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<7&(14+cast_regen)<focus.deficit
	{ "Cobra Shot", { "talent(4,1)", "modifier.last", "player.buff(Steady Focus).remains < 7", "player.focus.deficit > 20" } },
	-- actions+=/explosive_trap,if=active_enemies>1
	{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
	{ "Explosive Trap", { "modifier.multitarget", "target.enemy", "!target.moving", "player.buff(Trap Launcher)", "target.area(7).enemies > 1", "target.distance.actual < 40" }, "target.ground" },
	-- # Prepare for steady focus refresh if it is running out.
	-- actions+=/cobra_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<4&focus<50
	{ "Cobra Shot", { "talent(4,1)", "modifier.last", "player.buff(Steady Focus).remains < 4", "player.focus < 50" } },
	-- actions+=/glaive_toss
	{ "Glaive Toss" },
	-- actions+=/barrage
	{ "Barrage", "modifier.multitarget" },
	-- actions+=/powershot,if=focus.time_to_max>cast_time
	{ "Powershot" },
	-- actions+=/cobra_shot,if=active_enemies>5
	{ "Cobra Shot", "target.area(7).enemies > 5" },
	-- actions+=/arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|buff.bestial_wrath.up
	{ "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.focus > 35" } },
	{ "Arcane Shot", "player.buff(Bestial Wrath)" },
	-- actions+=/arcane_shot,if=focus>=75
	{ "Arcane Shot", "player.focus >= 75" },
	-- PvP
	{ "Aspect of the Cheetah", { "player.glyph(119462)", "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } }, -- 10sec cd now unless glyphed
	{ "Concussive Shot", { "toggle.pvpmode", "!target.debuff.any", "target.moving", "!target.immune.snare" } },
	-- actions+=/cobra_shot
	{ "Cobra Shot", "player.focus.deficit > 20" },

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
	{ "Fetch", { "!talent(7,3)", "player.glyph(126746)", "timeout(Fetch,9)", "player.ooctime < 30", "!player.moving", "!target.exists", "!player.busy" } }, --/targetlasttarget /use [@target,exists,dead] Fetch

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "83242", { "!pet.exists", "!modifier.last" } }, -- Call Pet 1
	{ "Heart of the Phoenix", { "!talent(7,3)", "pet.exists", "pet.dead", "!modifier.last" } },
	{ "Mend Pet", { "!talent(7,3)", "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
	{ "Revive Pet", { "!talent(7,3)", "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

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
		{ "Arcane Shot", { "target.exists", "target.enemy", "target.alive" } },
		{ "Cobra Shot", { "target.exists", "target.enemy", "target.alive" } },
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
-- Beast Mastery Hunter - WoD 6.1
-- Updated on April 18th 2015

-- SUGGESTED TALENTS: ST 3123333  AoE 3121233
-- SUGGESTED GLYPHS: Deterrence, Disengage/Pathfinding, Animal Bond, Aspect of the Cheetah
-- CONTROLS: Pause - Left Control, Explosive/Ice/Snake Traps - Left Alt, Freezing Trap - Right Alt, Scatter Shot - Right Control

NetherMachine.rotation.register_custom(253, "bbHunter Beastmastery", {
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
	-- TODO Tranq Shot casting at bwrong times
	{ "Tranquilizing Shot", "target.dispellable" },
	{ "Tranquilizing Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.dispellable" }, "mouseover" },

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "83242", { "!pet.exists", "!modifier.last" } }, -- Call Pet 2
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
		{ "Misdirection", { "!talent(7,3)", "pet.exists", "pet.alive", "pet.distance < 100" }, "pet" },
	},{
		"!toggle.pvpmode", "!target.isPlayer", "!player.buff(Misdirection)", "target.threat > 30",
	} },

	-- DEFENSIVE COOLDOWNS
	{ "Exhilaration", "player.health < 40" },
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	{ "#118916", { "toggle.consume", "player.health < 40", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Healing Tonic
	-- Clears all movement-impairing effects, but its primary usage in a raid is the charge that the pet does to the target which you Master’s Call, allowing you to throw your pet around extremely quickly – say to reposition it across the room on The Blast Furnace encounter for a slight DPS increase.
	{ "Master's Call", { "pet.exists", "pet.alive", "!talent(7,3)", "player.state.disorient" }, "player" },
	{ "Master's Call", { "pet.exists", "pet.alive", "!talent(7,3)", "player.state.stun" }, "player" },
	{ "Master's Call", { "pet.exists", "pet.alive", "!talent(7,3)", "player.state.root" }, "player" },
	{ "Master's Call", { "pet.exists", "pet.alive", "!talent(7,3)", "player.state.snare" }, "player" },
	{ "Deterrence", { "!talent(7,3)", "player.health < 20" } },

	-- Pre-DPS PAUSE
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.debuff(Freezing Trap).any" },
	{ "pause", "target.buff(Divine Bulwark)" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- OPENER (Steady Focus)
	{ {
		-- 1) Pre-Draenic Agility Potion
		-- 2) Pre-Cobra Shot
		-- 4) Boss is engaged – /petattack
		-- 5) Cobra Shot
		-- 5) Stampede
		{ "Stampede" },
		-- 6) On-uses + trinkets + racials (except for Arcane Torrent) + Bestial Wrath
		{ "#trinket1" },
		{ "#trinket2" },
		{ "Blood Fury" },
		{ "Berserking" },
		{ "Bestial Wrath", { "pet.exists", "pet.alive" } },
		-- 7) Kill Command
		{ "Kill Command", { "pet.exists", "pet.alive" } }, --"target.distance(pet).actual < 25"
		-- 8) Barrage
		{ "Barrage" },
	},{
		"talent(4,1)", "player.time < 10", "target.exists", "target.enemy", "target.alive", "target.boss"
	} },

	-- OPENER (Dire Beast)
	{ {
		-- 1) Pre-Draenic Agility Potion
		-- 2) Boss is engaged – /petattack
		-- 3) Stampede
		{ "Stampede" },
		-- 4) On-uses + trinkets + racials (except for Arcane Torrent) + Dire Beast
		{ "#trinket1" },
		{ "#trinket2" },
		{ "Blood Fury" },
		{ "Berserking" },
		{ "Dire Beast" },
		-- 5) Bestial Wrath
		{ "Bestial Wrath", { "pet.exists", "pet.alive" } },
		-- 6) Kill Command
		{ "Kill Command", { "pet.exists", "pet.alive" } }, --"target.distance(pet).actual < 25"
		-- 7) Barrage
		{ "Barrage" },
	},{
		"talent(4,2)", "player.time < 10", "target.exists", "target.enemy", "target.alive", "target.boss"
	} },

	-- COOLDOWNS
	{ {
		-- actions=auto_shot
		-- actions+=/use_item,name=beating_heart_of_the_mountain
		{ "#trinket1" },
		{ "#trinket2" },
		-- actions+=/arcane_torrent,if=focus.deficit>=30
		{ "Arcane Torrent", "player.focus < 50" },
		-- actions+=/blood_fury
		{ "Blood Fury" },
		-- actions+=/berserking
		{ "Berserking" },
		-- actions+=/potion,name=draenic_agility,if=!talent.stampede.enabled&buff.bestial_wrath.up&target.health.pct<=20|target.time_to_die<=20
		{ "#109217", { "toggle.consume", "target.boss", "!talent(5,3)", "player.buff(Bestial Wrath)", "target.health <= 20" } }, -- Draenic Agility Potion
		-- actions+=/potion,name=draenic_agility,if=talent.stampede.enabled&cooldown.stampede.remains<1&(buff.bloodlust.up|buff.focus_fire.up)|target.time_to_die<=25
		{ "#109217", { "toggle.consume", "target.boss", "talent(5,3)", "player.spell(Stampede).cooldown < 2", "player.hashero" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "talent(5,3)", "player.spell(Stampede).cooldown < 2", "player.buff(Focus Fire)" } },
		{ "#109217", { "toggle.consume", "target.boss", "talent(5,3)", "player.spell(Stampede).cooldown < 2", "target.health <= 20" } },
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", --"!target.classification(minus, trivial, normal)",
	} },
	-- Bestial Wrath
	{ "Bestial Wrath", { "modifier.cooldowns", "pet.exists", "pet.alive", "target.exists", "target.enemy", "target.alive" } },
	-- Frenzy
	{ {
		-- Use it with 5 stacks of Frenzy on your pet.
		-- DELAY it at 5 stacks of Frenzy if there’s over 10 seconds and under 19 seconds remaining on Bestial Wrath. In order to ensure full overlap with Bestial Wrath, pop it around the 10 second mark on its remaining cooldown.
		{ "Focus Fire", { "player.buff(Frenzy).count > 4", "player.spell(Bestial Wrath).cooldown <= 10" }, "player" },
		{ "Focus Fire", { "player.buff(Frenzy).count > 4", "player.spell(Bestial Wrath).cooldown >= 19" }, "player" },
		-- Use it at any amount of stacks if Bestial Wrath has over 3 seconds remaining.
		{ "Focus Fire", { "player.buff(Bestial Wrath).remains >= 3" }, "player" },
		-- Use it at any amount of stacks when Frenzy is about to expire from your pet.
		{ "Focus Fire", { "player.buff(Frenzy).remains <= 2" }, "player" },
		-- Use it at any amount of stacks when Stampede is up.
		{ "Focus Fire", { "player.spell(Stampede).cooldown > 265" }, "player" },
		-- Use it at any amount of stacks right before going into Bestial Wrath if Bestial Wrath is off cooldown.
		{ "Focus Fire", { "player.spell(Bestial Wrath).cooldown < 1" }, "player" },
		-- Use it at any amount of stacks right before an AoE phase to make use of the Haste for keeping Beast Cleave up, lowering Barrage’s cast time and boosting the pet’s damage significantly for this short period.
		{ "Focus Fire", { "target.area(7).enemies > 4" }, "player" },
	},{
		"pet.exists", "pet.alive", "target.exists", "target.enemy", "target.alive", "!player.buff(Focus Fire)", "player.buff(Frenzy)",
	} },
	-- Stampede should used as many times as possible throughout the fight, but due to its long cooldown, it is often beneficial to evaluate your situation and try to pop it when you are the most powerful. A combination of a high-stack Focus Fire, trinket procs and Bloodlust/Heroism is ideal.
	{ {
		{ "Stampede", { "player.hashero" } },
		{ "Stampede", { "target.boss", "player.buff(Focus Fire)" } },
		{ "Stampede", { "player.buff(Draenic Agility Potion)" } },
		{ "Stampede", { "player.buff(Brawler's Draenic Agility Potion)" } },
		{ "Stampede", { "target.boss", "target.health <= 20" } },
	},{
		"modifier.cooldowns", "pet.exists", "pet.alive", "target.exists", "target.enemy", "target.alive",
	} },

	-- AOE 3+ TARGETS
	-- Hans and Franz stuck in full aoe, only 2
	{ {
		-- 1) Use Barrage off cooldown.
		{ "Barrage" },
		{ "Glaive Toss" },
		{ "Powershot", "toggle.cleave" },
		-- 2) Use Multi-Shot as much as needed to keep Beast Cleave up.
		{ "Multi-Shot", { "pet.exists", "pet.alive", "pet.buff(Beast Cleave).remains < 2", "!modifier.last" } },
		-- 4) Use Kill Command off cooldown.
		{ "Kill Command", { "pet.exists", "pet.alive", "target.exists", "target.enemy", "target.distance(pet).actual < 25" }, "target" },
		{ "Kill Command", { "pet.exists", "pet.alive", "pettarget.exists", "pettarget.enemy" }, "pettarget" },
		--{ "Kill Command", { "pet.exists", "pet.alive", "target.distance(pet).actual < 25" }, "target" },
		--{ "Kill Command", { "pet.exists", "pet.alive", "pettarget.distance(pet).actual < 25" }, "pettarget" },
		-- 5) Use Kill Shot off cooldown when the target is under 20% health.
		{ "Kill Shot" },
		-- 3) Use Dire Beast off cooldown if this talent is chosen.
		{ "Dire Beast" },
		{ "A Murder of Crows", "!target.classification(minus, trivial)" },
		-- 6) Keep Steady Focus up by chaining Cobra Shot frequently and if this talent is chosen.
		{ "Cobra Shot", { "talent(4,1)", "modifier.last", "player.buff(Steady Focus).remains < 5", "player.focus < 100" } },
		-- 7) Use Explosive Trap off cooldown.
		{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
		{ "Explosive Trap", { "target.enemy", "!target.unitname(Kromog)", "!target.moving", "player.buff(Trap Launcher)", "target.distance.actual < 40" }, "target.ground" },
		-- 8) Arcane Shot should be used to dump excess focus. 70 focus is a decent (but not final) guideline.
		{ "Arcane Shot", { "player.focus >= 90" } },
		{ "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.focus >= 70" } },
		-- 9) Cobra Shot should be used when there is nothing else to do or you need more focus.
		{ "Focusing Shot", "player.focus < 90" },
		{ "Cobra Shot", "player.focus < 90" },
	},{
		"modifier.multitarget", "target.area(7).enemies > 2", "!target.unitname(Kromog)", "!target.unitname(Gruul)", "!target.unitname(Oregorger)", "!target.unitname(Blackhand)"
	} },

	-- AOE TWO TARGETS
	{ {
		-- 1) Use Barrage off cooldown.
		{ "Barrage" },
		{ "Glaive Toss" },
		{ "Powershot", "toggle.cleave" },
		-- 2) Use Kill Command off cooldown.
		{ "Kill Command", { "pet.exists", "pet.alive", "target.exists", "target.enemy", "target.distance(pet).actual < 25" }, "target" },
		{ "Kill Command", { "pet.exists", "pet.alive", "pettarget.exists", "pettarget.enemy" }, "pettarget" },
		--{ "Kill Command", { "pet.exists", "pet.alive", "target.distance(pet).actual < 25" }, "target" },
		--{ "Kill Command", { "pet.exists", "pet.alive", "pettarget.distance(pet).actual < 25" }, "pettarget" },
		-- 3) Use Kill Shot off cooldown when the target is under 20% health.
		{ "Kill Shot" },
		-- 3) Use Dire Beast off cooldown if this talent is chosen.
		{ "Dire Beast" },
		{ "A Murder of Crows", "!target.classification(minus, trivial)" },
		-- 4) Use Multi-Shot as much as needed to keep Beast Cleave up.
		{ "Multi-Shot", { "pet.exists", "pet.alive", "pet.buff(Beast Cleave).remains < 2", "!modifier.last" } },
		-- 5) Keep Steady Focus up by chaining Cobra Shot frequently and if this talent is chosen.
		{ "Cobra Shot", { "talent(4,1)", "modifier.last", "player.buff(Steady Focus).remains < 5", "player.focus < 100" } },
		-- 6) Use Explosive Trap off cooldown.
		{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
		{ "Explosive Trap", { "target.enemy", "!target.unitname(Kromog)", "!target.moving", "player.buff(Trap Launcher)", "target.distance.actual < 40" }, "target.ground" },
		-- 7) Arcane Shot should be used to dump excess focus. 70 focus is a decent (but not final) guideline.
		{ "Arcane Shot", { "player.focus >= 90" } },
		{ "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.focus >= 70" } },
		-- 8) Cobra Shot should be used when there is nothing else to do or you need more focus.
		{ "Focusing Shot", "player.focus < 90" },
		{ "Cobra Shot", "player.focus < 90" },
	},{
		"modifier.multitarget", "target.area(7).enemies == 2", "!target.unitname(Kromog)", "!target.unitname(Gruul)", "!target.unitname(Oregorger)", "!target.unitname(Blackhand)"
	} },

	-- SINGLE TARGET
	-- 1) Use Kill Command off cooldown.
	{ "Kill Command", { "pet.exists", "pet.alive", "target.exists", "target.enemy", "target.distance(pet).actual < 25" }, "target" },
	{ "Kill Command", { "pet.exists", "pet.alive", "pettarget.exists", "pettarget.enemy" }, "pettarget" },
	--{ "Kill Command", { "pet.exists", "pet.alive", "target.distance(pet).actual < 25" }, "target" },
	--{ "Kill Command", { "pet.exists", "pet.alive", "pettarget.distance(pet).actual < 25" }, "pettarget" },
	-- 2) Use Kill Shot off cooldown when the target is under 20% health.
	{ "Kill Shot" },
	-- 3) Use Dire Beast off cooldown if this talent is chosen.
	{ "Dire Beast" },
	{ "A Murder of Crows", "!target.classification(minus, trivial)" },
	-- 4) Use Barrage off cooldown.
	{ "Barrage", "toggle.cleave" },
	{ "Glaive Toss", "toggle.cleave" },
	{ "Powershot", "toggle.cleave" },
	-- 5) Keep Steady Focus up up by chaining Cobra Shot frequently and if this talent is chosen. This should ideally be inherent in your shot cycle already.
	{ "Cobra Shot", { "talent(4,1)", "modifier.last", "player.buff(Steady Focus).remains < 5", "player.focus < 100" } },
	-- 6) Arcane Shot should be used to dump excess focus. 70 focus is a decent (but not final) guideline.
	{ "Arcane Shot", { "player.focus >= 90" } },
	{ "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.focus >= 70" } },
	-- PvP
	{ "Aspect of the Cheetah", { "player.glyph(119462)", "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } }, -- 10sec cd now unless glyphed
	{ "Concussive Shot", { "toggle.pvpmode", "!target.debuff.any", "target.moving", "!target.immune.snare" } },
	-- 7) Cobra Shot should be used when there is nothing else to do or you need more focus.
	{ "Focusing Shot", "player.focus < 90" },
	{ "Cobra Shot", "player.focus < 90" },

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
	{ "Fetch", { "!talent(7,3)", "player.glyph(126746)", "timeout(Fetch,9)", "player.ooctime < 30", "!player.moving", "!target.exists", "!player.busy" } }, --/targetlasttarget /use [@target,exists,dead] Fetch

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "83242", { "!pet.exists", "!modifier.last" } }, -- Call Pet 2
	{ "Heart of the Phoenix", { "!talent(7,3)", "pet.exists", "pet.dead", "!modifier.last" } },
	{ "Mend Pet", { "!talent(7,3)", "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
	{ "Revive Pet", { "!talent(7,3)", "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

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
		{ "Arcane Shot", { "target.exists", "target.enemy", "target.alive" } },
		{ "Cobra Shot", { "target.exists", "target.enemy", "target.alive" } },
	}, "toggle.autoattack" },

},function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_hunter_quickshot', 'Use Mouseovers', 'Toggle automatic usage of stings/scatter/etc on eligible mouseover targets.')
	NetherMachine.toggle.create('camomode', 'Interface\\Icons\\ability_hunter_displacement', 'Use Camouflage', 'Toggle the usage Camouflage when out of combat.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack any anemies in range of the player.')
	NetherMachine.toggle.create('cleave', 'Interface\\Icons\\inv_misc_fish_33', 'Allow Cleave', 'Use abilities that could break nearby CC.')
end)
