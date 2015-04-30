-- NetherMachine Rotation
-- Marksmanship Hunter - WoD 6.0.3
-- Updated on Feb 28th 2015

-- SUGGESTED TALENTS: 0003313 Crouching, Binding Shot, Iron Hawk, Steady Focus, A Murder of Crows, Barrage, Focusing Shot
-- SUGGESTED GLYPHS: Animal Bond, Deterrence, Pathfinding, Aspect of the Cheetah
-- CONTROLS: Pause - Left Control, Explosive/Ice/Snake Traps - Left Alt, Freezing Trap - Right Alt, Scatter Shot - Right Control

NetherMachine.rotation.register_custom(254, "bbHunter Marksmanship (SimC T17H)", {
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
		-- actions=auto_shot
		-- actions+=/use_item,name=beating_heart_of_the_mountain
		{ "#trinket1" },
		{ "#trinket2" },
		-- actions+=/arcane_torrent,if=focus.deficit>=30
		{ "Arcane Torrent", "player.focus.deficit >= 50" },
		-- actions+=/blood_fury
		{ "Blood Fury" },
		-- actions+=/berserking
		{ "Berserking" },
		-- actions+=/potion,name=draenic_agility,if=((buff.rapid_fire.up|buff.bloodlust.up)&(cooldown.stampede.remains<1))|target.time_to_die<=25
		{ "#118913", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.buff(Rapid Fire)", "player.spell(Stampede).cooldown < 2" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero", "player.spell(Stampede).cooldown < 2" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.buff(Rapid Fire)", "player.spell(Stampede).cooldown > 280" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero", "player.spell(Stampede).cooldown > 280" } }, -- Draenic Agility Potion
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },



	-- DPS ROTATION
	-- actions+=/chimaera_shot
	{ "Chimaera Shot" },
	-- actions+=/kill_shot
	{ "Kill Shot" },
	-- actions+=/rapid_fire
	{ "Rapid Fire", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)" } },
	-- actions+=/stampede,if=buff.rapid_fire.up|buff.bloodlust.up|target.time_to_die<=25
	{ "Stampede", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "target.boss", "player.buff(Rapid Fire)" } },
	{ "Stampede", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "target.boss", "player.hashero" } },
	{ "Stampede", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "target.boss", "player.buff(Berserking)" } },
	{ "Stampede", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "target.boss", "player.buff(Draenic Agility Potion)" } },
	{ "Stampede", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "target.boss", "player.buff(Brawler's Draenic Agility Potion)" } },
	{ {
		-- actions.careful_aim=glaive_toss,if=active_enemies>2
		{ "Glaive Toss", "target.area(7).enemies > 2" },
		-- actions.careful_aim+=/powershot,if=active_enemies>1&cast_regen<focus.deficit
		{ "Powershot", "target.area(7).enemies > 1", (function() return NetherMachine.condition["spell.castregen"]('player', 'Powershot') < NetherMachine.condition["focus.deficit"]('player') end) },
		-- actions.careful_aim+=/barrage,if=active_enemies>1
		{ "Barrage", { "modifier.multitarget", "target.area(7).enemies > 1" } },
		-- actions.careful_aim+=/aimed_shot
		{ "Aimed Shot" },
		-- actions.careful_aim+=/focusing_shot,if=50+cast_regen<focus.deficit
		{ "Focusing Shot", (function() return 50+NetherMachine.condition["spell.castregen"]('player', 'Focusing Shot') < NetherMachine.condition["focus.deficit"]('player') end) },
		-- actions.careful_aim+=/steady_shot
		{ "Steady Shot", "player.focus.deficit > 20" },
	}, "player.buff(Careful Aim)" },
	-- actions+=/explosive_trap,if=active_enemies>1
	{ "Trap Launcher", { "!player.buff(Trap Launcher)", "!modifier.last" } },
	{ "Explosive Trap", { "target.enemy", "!target.moving", "player.buff(Trap Launcher)", "target.area(7).enemies > 1" }, "target.ground" },
	-- actions+=/a_murder_of_crows
	{ "A Murder of Crows", "!target.classification(minus, trivial)" },
	-- actions+=/dire_beast,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit
	{ "Dire Beast", { "!target.classification(minus, trivial)", (function() return NetherMachine.condition["spell.castregen"]('player', 'Dire Beast')+NetherMachine.condition["spell.castregen"]('player', 'Aimed Shot') < NetherMachine.condition["focus.deficit"]('player') end) } },
	-- actions+=/glaive_toss
	{ "Glaive Toss" },
	-- actions+=/powershot,if=cast_regen<focus.deficit
	{ "Powershot", { (function() return NetherMachine.condition["spell.castregen"]('player', 'Powershot') < NetherMachine.condition["focus.deficit"]('player') end) } },
	-- actions+=/barrage
	{ "Barrage", "modifier.multitarget" },
	-- # Pool max focus for rapid fire so we can spam AimedShot with Careful Aim buff
	-- actions+=/steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains
	{ "Steady Shot", { (function() return NetherMachine.condition["focus.deficit"]('player')*NetherMachine.condition["spell.castingtime"]('player', 'Steady Shot')%(14+NetherMachine.condition["spell.castregen"]('player', 'Steady Shot')) > NetherMachine.condition["spell.cooldown"]('player', 'Rapid Fire') end) } },
	-- actions+=/focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100
	{ "Focusing Shot", { "player.focus < 100", (function() return NetherMachine.condition["focus.deficit"]('player')*NetherMachine.condition["spell.castingtime"]('player', 'Focusing Shot')%(50+NetherMachine.condition["spell.castregen"]('player', 'Focusing Shot')) > NetherMachine.condition["spell.cooldown"]('player', 'Rapid Fire') end) } },
	-- # Cast a second shot for steady focus if that won't cap us.
	-- actions+=/steady_shot,if=buff.pre_steady_focus.up&(14+cast_regen+action.aimed_shot.cast_regen)<=focus.deficit
	{ "Steady Shot", { "talent(4, 1)", "modifier.last", (function() return 14+NetherMachine.condition["spell.castregen"]('player', 'Steady Shot')+NetherMachine.condition["spell.castregen"]('player', 'Aimed Shot') <= NetherMachine.condition["focus.deficit"]('player') end) } },
	-- actions+=/multishot,if=active_enemies>6
	{ "Multi-Shot", { "modifier.multitarget", "target.area(7).enemies > 6" } },
	-- actions+=/aimed_shot,if=talent.focusing_shot.enabled
	{ "Aimed Shot", "talent(7, 2)" },
	-- actions+=/aimed_shot,if=focus+cast_regen>=85
	{ "Aimed Shot", { (function() return NetherMachine.condition["focus"]('player')+NetherMachine.condition["spell.castregen"]('player', 'Aimed Shot') >= 85 end) } },
	-- actions+=/aimed_shot,if=buff.thrill_of_the_hunt.react&focus+cast_regen>=65
	{ "Aimed Shot", { "player.buff(Thrill of the Hunt)", (function() return NetherMachine.condition["focus"]('player')+NetherMachine.condition["spell.castregen"]('player', 'Aimed Shot') >= 65 end) } },
	-- PVP
	{ "Aspect of the Cheetah", { "player.glyph(119462)", "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } }, -- 10sec cd now unless glyphed
	{ "Concussive Shot", { "toggle.pvpmode", "!target.debuff(Frozen Ammo)", "!target.debuff(Concussive Shot).any", "target.moving", "!target.immune.snare" } },
	-- # Allow FS to over-cap by 10 if we have nothing else to do
	-- actions+=/focusing_shot,if=50+cast_regen-10<focus.deficit
	{ "Focusing Shot", { (function() return 50+NetherMachine.condition["spell.castregen"]('player', 'Focusing Shot')-10 < NetherMachine.condition["focus.deficit"]('player') end) } },
	-- actions+=/steady_shot
	{ "Steady Shot", "player.focus.deficit > 20" },

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
		{ "Chimaera Shot", { "target.exists", "target.enemy", "target.alive" } },
		{ "Glaive Toss", { "target.exists", "target.enemy", "target.alive" } },
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
-- Marksmanship Hunter - WoD 6.0.3
-- Updated on Nov 24th 2014

-- SUGGESTED TALENTS: Crouching Tiger, Binding Shot, Iron Hawk, Thrill of the Hunt, A Murder of Crows, and Barrage or Glaive Toss
-- SUGGESTED GLYPHS: Major: Animal Bond, Deterrence, Disengage  Minor: Aspect of the Cheetah, Play Dead, Fetch
-- CONTROLS: Pause - Left Control, Explosive/Ice/Snake Traps - Left Alt, Freezing Trap - Right Alt, Scatter Shot - Right Control

-- Grimrail - Rocketspark -- Borka's  Slam will now also interrupt spell casting, locking the player out of the affected spell school for a brief period. Casters and healers should target or focus Borka to watch for his Slam cast and avoid using cast-time spells as it finishes.
-- Grimrail - Nitrogg -- Use Blackrock Grenade on CD target.ground (Special Action Button)

NetherMachine.rotation.register_custom(254, "bbHunter Marksmanship (OLD)", {
-- COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "/cancelaura Aspect of the Pack", "player.buff(Aspect of the Pack)" },
	{ "pause", "player.buff(Feign Death)" },
	{ "pause", "player.buff(Camouflage)" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!toggle.frogs", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "!toggle.frogs", "target.exists", "target.dead" } },


	-- FROGING
	{ {
		{ "Flare", "@bbLib.engaugeUnit('ANY', 40, false)" },
	}, "toggle.frogs" },

	-- BOSS MODS
	--{ "Feign Death", { "modifier.raid", "target.exists", "target.enemy", "target.boss", "target.agro", "target.distance < 30" } },
	--{ "Feign Death", { "modifier.raid", "player.debuff(Aim)", "player.debuff(Aim).duration > 3" } }, --SoO: Paragons - Aim

	-- INTERRUPTS / DISPELLS
	{ "Counter Shot", "modifier.interrupt" },
	{ "Counter Shot", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },
	{ "Tranquilizing Shot", "target.dispellable", "target" },

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ {
		{ "883", { "!pet.exists", "!modifier.last" } }, -- Call Pet 1
		{ "Heart of the Phoenix", { "pet.exists", "pet.dead", "!modifier.last" } },
		{ "Revive Pet", { "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },
	}, "!talent(7, 3)" },
	{ "Master's Call", { "pet.exists", "pet.alive", "player.state.disorient" }, "player" },
	{ "Master's Call", { "pet.exists", "pet.alive", "player.state.stun" }, "player" },
	{ "Master's Call", { "pet.exists", "pet.alive", "player.state.root" }, "player" },
	{ "Master's Call", { "pet.exists", "pet.alive", "player.state.snare" }, "player" },
	{ "Mend Pet", { "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },

	-- TRAPS
	{ "Trap Launcher", { "!modifier.last", "!player.buff(Trap Launcher)" } },
	{ "Explosive Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" }, -- mouseover.ground?
	{ "Ice Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },
	{ "Freezing Trap", { "modifier.ralt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },

	-- MISDIRECTION ( focus -> tank -> pet )
	{ {
		{ "Misdirection", { "focus.exists", "focus.friend", "focus.alive", "focus.distance < 100"  }, "focus" },
		--{ "Misdirection", { "modifier.raid", "tank.exists", "tank.alive", "tank.distance < 100" }, "tank" },
		{ "Misdirection", { "!talent(7, 3)", "pet.exists", "pet.alive", "pet.distance < 100" }, "pet" },
	},{
		"!toggle.pvpmode", "!target.isPlayer", "!player.buff(Misdirection)", "target.threat > 30",
	} },

	-- DEFENSIVE COOLDOWNS
	{ "Exhilaration", "player.health < 40" },
	--{ "#89640", { "toggle.consume", "player.health < 40", "!player.buff(130649)", "target.boss" } }, -- Life Spirit
	{ "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone
	--{ "#118916", { "toggle.consume", "player.health < 40" } }, -- Brawler's Healing Tonic
	{ "Deterrence", "player.health < 20" },
	{ "#76097", { "toggle.consume", "player.health < 20", "target.boss" } }, -- Master Healing Potion

	-- Pre-DPS PAUSE
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- COMMON / COOLDOWNS
	{ {
		-- actions+=/use_item,name=gorashans_lodestone_spike
		{ "#trinket1", "player.buff(Rapid Fire)" },
		{ "#trinket1", "player.hashero" },
		{ "#trinket2", "player.buff(Rapid Fire)" },
		{ "#trinket2", "player.hashero" },
		-- actions+=/arcane_torrent,if=focus.deficit>=30
		{ "Arcane Torrent", "player.focus <= 90" },
		-- actions+=/blood_fury
		{ "Blood Fury" },
		-- actions+=/berserking
		{ "Berserking" },
		-- actions+=/potion,name=draenic_agility,if=((buff.rapid_fire.up|buff.bloodlust.up)&(cooldown.stampede.remains<1))|target.time_to_die<=25
		{ "#109217", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Agility Potion
		{ "#109217", { "toggle.consume", "target.boss", "player.buff(Rapid Fire)" } }, -- Draenic Agility Potion
		-- actions+=/rapid_fire
		{ "Rapid Fire" },
		-- actions+=/stampede,if=buff.rapid_fire.up|buff.bloodlust.up|target.time_to_die<=25
		{ "Stampede", { "target.boss", "player.buff(Rapid Fire)" } },
		{ "Stampede", { "target.boss", "player.hashero" } },
		{ "Stampede", { "target.boss", "target.deathin <= 30" } },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },

	-- actions+=/chimaera_shot
	{ "Chimaera Shot" },
	-- actions+=/kill_shot
	{ "Kill Shot" },

	-- CAREFUL AIM
	{ {
		-- actions.careful_aim=glaive_toss,if=active_enemies>2
		{ "Glaive Toss", { "modifier.multitarget", "target.area(8).enemies > 2" } },
		-- actions.careful_aim+=/powershot,if=active_enemies>1&cast_regen<focus.deficit
		{ "Powershot", { "target.area(10).enemies > 1", "!player.moving" } },
		-- actions.careful_aim+=/barrage,if=active_enemies>1
		{ "Barrage", { "modifier.multitarget", "target.area(8).enemies > 1" } },
		-- actions.careful_aim+=/aimed_shot
		{ "Aimed Shot" },
		-- actions.careful_aim+=/focusing_shot,if=50+cast_regen<focus.deficit
		{ "Focusing Shot", { "player.focus < 50",  } },
		-- actions.careful_aim+=/steady_shot
		{ "Steady Shot" },
	}, "target.health > 80" },
	{ {
		-- actions.careful_aim=glaive_toss,if=active_enemies>2
		{ "Glaive Toss", { "modifier.multitarget", "target.area(8).enemies > 2" } },
		-- actions.careful_aim+=/powershot,if=active_enemies>1&cast_regen<focus.deficit
		{ "Powershot", { "target.area(10).enemies > 1", "!player.moving" } },
		-- actions.careful_aim+=/barrage,if=active_enemies>1
		{ "Barrage", { "modifier.multitarget", "target.area(8).enemies > 1" } },
		-- actions.careful_aim+=/aimed_shot
		{ "Aimed Shot" },
		-- actions.careful_aim+=/focusing_shot,if=50+cast_regen<focus.deficit
		{ "Focusing Shot", { "player.focus < 50",  } },
		-- actions.careful_aim+=/steady_shot
		{ "Steady Shot" },
	}, "player.buff(Rapid Fire)" },

	-- DPS ROTATION
	{ "Barrage", { "modifier.multitarget", "target.area(10).enemies > 3" } },
	-- actions+=/explosive_trap,if=active_enemies>1
	{ "Explosive Trap", { "modifier.multitarget", "!target.moving", "target.area(8).enemies > 2" }, "target.ground" },
	-- actions+=/a_murder_of_crows
	{ "A Murder of Crows" },
	-- actions+=/dire_beast,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit
	{ "Dire Beast", "@bbLib.canDireBeast" },
	-- actions+=/glaive_toss
	{ "Glaive Toss", "modifier.multitarget" },
	-- actions+=/powershot,if=cast_regen<focus.deficit
	{ "Powershot", "!player.moving" },
	-- actions+=/barrage
	{ "Barrage", "modifier.multitarget" },
	-- # Pool max focus for rapid fire so we can spam AimedShot with Careful Aim buff
	-- actions+=/steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains
	{ "Steady Shot", "@bbLib.poolSteady" },
	-- actions+=/focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100
	{ "Focusing Shot", { "player.focus < 100", "@bbLib.poolFocusing" } },
	-- # Cast a second shot for steady focus if that won't cap us.
	-- actions+=/steady_shot,if=buff.pre_steady_focus.up&(14+cast_regen+action.aimed_shot.cast_regen)<=focus.deficit
	{ "Steady Shot", { "talent(4, 1)", "modifier.last(Steady Shot)", "!player.buff(Steady Focus)", "@bbLib.steadyFocus" } },
	-- actions+=/multishot,if=active_enemies>6
	{ "Multi-Shot", { "modifier.multitarget", "target.area(8).enemies > 6" } },
	-- actions+=/aimed_shot,if=talent.focusing_shot.enabled
	{ "Aimed Shot", "talent(7, 2)" },
	-- actions+=/aimed_shot,if=focus+cast_regen>=85
	-- actions+=/aimed_shot,if=buff.thrill_of_the_hunt.react&focus+cast_regen>=65
	{ "Aimed Shot", "@bbLib.aimedShot" },
	-- # Allow FS to over-cap by 10 if we have nothing else to do
	{ "Concussive Shot", { "toggle.pvpmode", "!target.debuff(Frozen Ammo)", "!target.debuff(Concussive Shot).any", "target.moving", "!target.immune.snare" } },
	{ "Aspect of the Cheetah", { "player.moving", "!player.buff", "!modifier.last", "player.glyph(119462)" } },
	-- actions+=/focusing_shot,if=50+cast_regen-10<focus.deficit
	{ "Focusing Shot", "@bbLib.focusingShot" },
	-- actions+=/steady_shot
	{ "Steady Shot", "player.focus < 100" },

},
{
-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "/click ExtraActionButton1", { "player.buff(Magic Wings)", "player.buff(Magic Wings).remains <= 1" } },
	{ "pause", "player.buff(Feign Death)" },
	{ "Aspect of the Cheetah", { "player.movingfor > 1", "!player.buff", "!player.buff(Aspect of the Pack).any", "!modifier.last" } },
	{ "pause", "player.buff(Camouflage)" },

	--{ "/stopcasting", "player.casting(Aimed Shot)" },

	-- AUTO LOOT
	{ "Fetch", { "!talent(7, 3)", "player.glyph(126746)", "timeout(Fetch, 9)", "player.ooctime < 30", "!player.moving", "!target.exists", "!player.busy" } }, --/targetlasttarget /use [@target,exists,dead] Fetch

	-- PET MANAGEMENT
	-- TODO: Use proper pet when raid does not provide buff. http://www.icy-veins.com/wow/survival-hunter-pve-dps-buffs-debuffs-useful-abilities
	{ "883", { "!talent(7, 3)", "!pet.exists", "!modifier.last" } }, -- Call Pet 1
	{ "Heart of the Phoenix", { "pet.exists", "pet.dead", "!modifier.last" } },
	{ "Mend Pet", { "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
	{ "Revive Pet", { "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

	-- TRAPS
	{ "Trap Launcher", { "!modifier.last", "!player.buff(Trap Launcher)" } },
	{ "Explosive Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" }, -- mouseover.ground?
	{ "Ice Trap", { "modifier.lalt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },
	{ "Freezing Trap", { "modifier.ralt", "player.buff(Trap Launcher)", "player.area(40).enemies > 0" }, "ground" },

	-- ASPECTS
	{ "Camouflage", { "toggle.camomode", "!player.buff", "player.health < 85", "!player.debuff(Orb of Power)", "!modifier.last", "player.ooctime > 3" } },

	-- LONE WOLF BUFFS
	{ {
		{ "Lone Wolf: Ferocity of the Raptor", 			{ "!modifier.last", "!player.buff.any", "!player.buffs.crit" } }, -- Lone Wolf: Ferocity of the Raptor (Crit) 160200
		{ "Lone Wolf: Quickness of the Dragonhawk", { "!modifier.last", "!player.buff.any", "!player.buffs.multistrike", 	"!player.buff(160200)" } }, -- Lone Wolf: Quickness of the Dragonhawk (Multistrike) 172968
		{ "Lone Wolf: Versatility of the Ravager", 	{ "!modifier.last", "!player.buff.any", "!player.buffs.versatility",	"!player.buff(160200)", "!player.buff(172968)" } }, -- Lone Wolf: Versatility of the Ravager (Versatility) 172967
		{ "Lone Wolf: Haste of the Hyena", 					{ "!modifier.last", "!player.buff.any", "!player.buffs.haste", 				"!player.buff(160200)", "!player.buff(172968)", "!player.buff(172967)" } }, -- Lone Wolf: Haste of the Hyena (Haste) 160203
		{ "Lone Wolf: Grace of the Cat", 						{ "!modifier.last", "!player.buff.any", "!player.buffs.mastery",			"!player.buff(160200)", "!player.buff(172968)", "!player.buff(172967)", "!player.buff(160203)" } }, -- Lone Wolf: Grace of the Cat (Mastery) 160198
		{ "Lone Wolf: Power of the Primates", 			{ "!modifier.last", "!player.buff.any", "!player.buffs.stats",				"!player.buff(160200)", "!player.buff(172968)", "!player.buff(172967)", "!player.buff(160203)", "!player.buff(160198)" } }, -- Lone Wolf: Power of the Primates (Stats) 160206
		{ "Lone Wolf: Fortitude of the Bear", 			{ "!modifier.last", "!player.buff.any", "!player.buffs.stamina",			"!player.buff(160200)", "!player.buff(172968)", "!player.buff(172967)", "!player.buff(160203)", "!player.buff(160198)", "!player.buff(160206)" } }, -- Lone Wolf: Fortitude of the Bear (Stamina) 160199
		{ "Lone Wolf: Wisdom of the Serpent", 			{ "!modifier.last", "!player.buff.any", "!player.buffs.spellpower",		"!player.buff(160200)", "!player.buff(172968)", "!player.buff(172967)", "!player.buff(160203)", "!player.buff(160198)", "!player.buff(160206)", "!player.buff(160199)" } }, -- Lone Wolf: Wisdom of the Serpent (Spell Power) 160205
	},{
		"talent(7, 3)", "!pet.exists",
	} },


	-- AUTO ENGAGE
	{ {
		{ "Flare", "@bbLib.engaugeUnit('ANY', 40, false)" },
		{ "Chimaera Shot", { "target.exists", "target.enemy" }, "target" },
		{ "Glaive Toss", { "target.exists", "target.enemy" }, "target" },
	}, "toggle.frogs" },

	-- PRE COMBAT
	-- actions.precombat=flask,type=greater_draenic_agility_flask
	-- actions.precombat+=/food,type=blackrock_barbecue
	-- actions.precombat+=/summon_pet
	-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/exotic_munitions,ammo_type=poisoned,if=active_enemies<3
	-- actions.precombat+=/exotic_munitions,ammo_type=incendiary,if=active_enemies>=3
	-- actions.precombat+=/potion,name=draenic_agility
	-- actions.precombat+=/aimed_shot

},
function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_hunter_quickshot', 'Use Mouseovers', 'Toggle automatic usage of stings/scatter/etc on eligible mouseover targets.')
	NetherMachine.toggle.create('camomode', 'Interface\\Icons\\ability_hunter_displacement', 'Use Camouflage', 'Toggle the usage Camouflage when out of combat.')
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('frogs', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Engage', 'Automatically target and attack any enemy units in range.')
end)




























-- Single Target <= 80%:
-- Cast Chimaera Shot Icon Chimaera Shot on cooldown.
-- Cast Kill Shot Icon Kill Shot on cooldown
-- can only be cast when the target is at or below 35% health.
-- Cast Aimed Shot Icon Aimed Shot if Rapid Fire Icon Rapid Fire is active or if the target is above 80% health.
-- Use A Murder of Crows Icon A Murder of Crows or Stampede Icon Stampede, depending on your talent choice.
-- Cast Glaive Toss Icon Glaive Toss, if you have taken this talent.
-- Cast Aimed Shot Icon Aimed Shot if you have a Thrill of the Hunt Icon Thrill of the Hunt proc.
-- Cast Barrage Icon Barrage.
-- Cast Aimed Shot Icon Aimed Shot to dump Focus.
-- Cast Steady Shot Icon Steady Shot (or Focusing Shot Icon Focusing Shot, if you are using this talent) to generate Focus.
-- If using Steady Focus Icon Steady Focus as your tier 5 talent, make sure to use Steady Shot in pairs at least once every 10 seconds, to keep up the buff.
--
-- Multi-Target
-- Against 2-6, you should simply perform your single target rotation on one of them, while making sure to use Kill Shot Icon Kill Shot on any targets that are below 35% health, and to use Aimed Shot Icon Aimed Shot on any targets that are above 80% health.
-- When facing 7 or more enemies, you should keep performing your single target rotation, while making the following changes to it:
-- Cast Multi-Shot Icon Multi-Shot instead of Aimed Shot Icon Aimed Shot.
-- If Rapid Fire Icon Rapid Fire is active, or if you can attack a target that has over 80% health, you should keep using Aimed Shot.
-- Cast Kill Shot Icon Kill Shot. Make sure to always look out for any targets in the group that are below Kill Shot's threshold.
-- Cast Chimaera Shot Icon Chimaera Shot on a target that is close to another target, so that you benefit from the cleave effect.
-- Use A Murder of Crows Icon A Murder of Crows or Stampede Icon Stampede, depending on your talent choice.
-- Cast Steady Shot Icon Steady Shot to generate Focus.
-- In any multiple target situation (even against 2 targets), you should use Explosive Trap Icon Explosive Trap on cooldown.
-- Bombardment Icon Bombardment, a Marksmanship-specific passive ability, causes your critical hits with Multi-Shot Icon Multi-Shot to grant you a 5 second buff that reduces the Focus cost of Multi-Shot by 25 Focus and increases Multi-Shot's damage by 60%.
--
-- CA Phase
-- Thanks to Careful Aim Icon Careful Aim, when your target is above 80% health, or while Rapid Fire Icon Rapid Fire is active, your critical strike chance with Steady Shot Icon Steady Shot and Aimed Shot Icon Aimed Shot is increased by 50%.
-- Basically, at the start of the fight, and whenever Rapid Fire is active, you should try to cast Aimed Shot as much as possible to benefit from these effects. During these periods, you should leave out all abilities from your rotation except for Aimed Shot, Steady Shot Icon Steady Shot, and Chimaera Shot Icon Chimaera Shot. In the event that you are fighting more than 1 target, you can also use Barrage Icon Barrage, and if you are fighting 3 or more targets, you can also use Glaive Toss Icon Glaive Toss.
-- As an added improvement, when using Rapid Fire later on in the fight, you can try to pool up Focus before casting it, and even try to hold on to a Thrill of the Hunt Icon Thrill of the Hunt proc.
