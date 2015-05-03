-- Quick Down & Dirty Affliction Warlock Leveling Profile
-- Rotation is based upon Icy-Veins current logic for Patch 6.1.2

NetherMachine.rotation.register_custom(265, "|cFF9482C9Affliction Warlock |cFFFF9999(Leveling)", {
---- *** Combat Routine Section ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	-- Survival Logic
	{	{
		{ "#5512", { "player.health < 30" } }, -- Healthstone (5512)
		{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	},	{ "toggle.survival" } },

	-- Auto Target
	{	{
		{ "/cleartarget", "target.dead" },
		{ "/targetenemy [noexists]", "!target.exists" },
		{ "/targetenemy [dead]", { "target.exists", "target.dead" } },
	},	{ "toggle.autotarget" } },
	
	-- Pre-DPS Pauses
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },
	
	-- Soul Burn + Soul Swap
	{	{
		{ "Soulburn", "!player.buff(Soulburn)" },
		{ "Soul Swap", "player.buff(Soulburn)" },
		},
		{ "target.debuff(Agony).duration <= 3", "target.debuff(Corruption).duration <= 3", "target.debuff(Unstable Affliction).duration <= 3" },
	},
  
  	-- Cool Downs
	{	{
		{ "Summon Doomguard", { "!talent(7, 3)", "!modifier.last", "!pet.exists", "player.area(40).enemies < 9" } },
		{ "Summon Infernal", { "!talent(7, 3)", "!modifier.last", "!pet.exists", "player.area(40).enemies >= 9" } },
	},	{ "modifier.cooldowns" } },
	
	-- Auto Pet Management
	{	{
		{ "Summon Doomguard", { "talent(7, 3)", "!modifier.last", "!pet.exists", "player.area(40).enemies < 9", "!player.casting(Summon Doomguard)" } },
		{ "Summon Infernal", { "talent(7, 3)", "!modifier.last", "!pet.exists", "player.area(40).enemies >= 9", "!player.casting(Summon Infernal" } },
		{ "Summon Fel Imp", { "!talent(7, 3)", "talent(5, 1)", "!pet.exists", "!player.casting(Summon Fel Imp)" } },
		{ "Summon Imp", { "!talent(7, 3)", "!pet.exists", "!player.casting(Summon Imp)" } },
		{ "Health Funnel", {  "pet.exists", "pet.alive", "pet.health < 40", "pet.distance < 45", "!player.buff(Health Funnel)", "!modifier.last" } },
	},	{ "toggle.autopet" } },
	
	-- Mouseover Multi-Dotting
	{	{
		{ "Agony", { "!target.debuff(Agony)", "mouseover.exists", "mouseover.enemy", "mouseover.alive" }, "mouseover" },
		{ "Agony", { "target.debuff(Agony).duration <= 7.2", "mouseover.exists", "mouseover.enemy", "mouseover.alive" }, "mouseover" },
		{ "Corruption", { "!target.debuff(Corruption)", "mouseover.exists", "mouseover.enemy", "mouseover.alive" }, "mouseover" },
		{ "Corruption", { "target.debuff(Corruption).duration <= 5.4", "mouseover.exists", "mouseover.enemy", "mouseover.alive" }, "mouseover" },
		{ "Unstable Affliction", { "!target.debuff(Unstable Affliction)", "mouseover.exists", "mouseover.enemy", "mouseover.alive" }, "mouseover" },
		{ "Unstable Affliction", { "target.debuff(Unstable Affliction).duration <= 4.2", "mouseover.exists", "mouseover.enemy", "mouseover.alive" }, "mouseover" },
	},	{ "toggle.mouseovers" } },
	
	-- Single Target Rotation ( 1 - 3 Enemies)
	{	{
		{ "Agony", "!target.debuff(Agony)" },
		{ "Agony", "target.debuff(Agony).duration <= 7.2" },
		{ "Corruption", "!target.debuff(Corruption)" },
		{ "Corruption", "target.debuff(Corruption).duration <= 5.4" },
		{ "Unstable Affliction", "!target.debuff(Unstable Affliction)" },
		{ "Unstable Affliction", "target.debuff(Unstable Affliction).duration <= 4.2" },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "player.trinket.any > 0" } },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "target.health < 20" } },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "player.soulshards >= 3" } },
		{ "Haunt", { "!talent(7, 1)", "player.soulshards == 4", "player.trinket.any > 0" } },
		{ "Haunt", { "!talent(7, 1)", "player.soulshards == 4", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "!talent(7, 1)", "player.soulshards == 4", "target.health < 20" } },
		{ "Soulburn", { "talent(7, 1)", "player.soulshards >=1", "!player.buff(Haunting Spirits)" } },
		{ "Soulburn", { "talent(7, 1)", "player.soulshards >=1", "player.buff(Haunting Spirits).remains < 9" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Soulburn).remains >= 2" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "player.trinket.any > 0" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "target.health < 20" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "player.soulshards >= 3" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "player.soulshards == 4", "player.trinket.any > 0" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "player.soulshards == 4", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "player.soulshards == 4", "target.health < 20" } },
		{ "Drain Soul", "!player.spell(Drain Soul).casting" },
	},	{ "!modifier.multitarget" } },

	-- Multiple Target Rotation ( 4+ Enemies )
	{	{
		{ "Agony", "!target.debuff(Agony)" },
		{ "Agony", "target.debuff(Agony).duration <= 7.2" },
		{ "Unstable Affliction", "!target.debuff(Unstable Affliction)" },
		{ "Unstable Affliction", "target.debuff(Unstable Affliction).duration <= 4.2" },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "player.trinket.any > 0" } },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "target.health < 20" } },
		{ "Haunt", { "!talent(7, 1)", "!target.debuff(Haunt)", "player.soulshards >= 3" } },
		{ "Haunt", { "!talent(7, 1)", "player.soulshards == 4", "player.trinket.any > 0" } },
		{ "Haunt", { "!talent(7, 1)", "player.soulshards == 4", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "!talent(7, 1)", "player.soulshards == 4", "target.health < 20" } },
		{ "Soulburn", { "talent(7, 1)", "player.soulshards >=1", "!player.buff(Haunting Spirits)" } },
		{ "Soulburn", { "talent(7, 1)", "player.soulshards >=1", "player.buff(Haunting Spirits).remains < 9" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Soulburn).remains >= 2" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "player.trinket.any > 0" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "target.health < 20" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "!target.debuff(Haunt)", "player.soulshards >= 3" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "player.soulshards == 4", "player.trinket.any > 0" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "player.soulshards == 4", "player.buff(Dark Soul: Misery).remains >= 2" } },
		{ "Haunt", { "talent(7, 1)", "player.buff(Haunting Spirits).remains > 15", "player.soulshards == 4", "target.health < 20" } },
		{ "Soulburn", { "player.soulshards >= 1", "player.buff(Soulburn).remains <= 3" } },
		{ "Seed of Corruption", { "!player.spell(Seed of Corruption).casting", "player.buff(Soulburn).remains >= 3", "!target.debuff(Seed of Corruption)", "!modifier.last" } },
		{ "Cataclysm", { "target.enemy", "target.alive", "talent(7, 2)" }, "target.ground" },
		{ "Drain Soul", { "!player.spell(Drain Soul).casting", "!talent(7, 2)" } },
	},	{ "modifier.multitarget" } },

},	{
---- *** Out Of Combat Routine Section ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buffs
	{ "Dark Intent", "!player.buffs.multistrike" },
	{ "Dark Intent", "!player.buffs.spellpower" },
	
	-- OOC Healing & Mana
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD
	{ "Life Tap", { "player.health >= 70", "player.mana <= 90" } },
	
	-- Pet Management
	{ "Summon Doomguard", { "talent(7, 3)", "!modifier.last", "!pet.exists", "!player.casting(Summon Doomguard)" } },
	{ "Summon Imp", { "!talent(7, 3)", "!modifier.last", "!pet.exists", "!player.casting(Summon Imp)" } },
	{ "Health Funnel", {  "pet.exists", "pet.alive", "pet.health < 90", "pet.distance < 45", "!player.buff(Health Funnel)", "!modifier.last" } },
	
	-- Mass Resurrection
	{ "Mass Resurrection", { "modifier.party", "!modifier.raid", "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },
	{ "Mass Resurrection", { "!modifier.party", "modifier.raid", "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },
	
	-- Auto Attack
	{	{
		{ "Corruption", "@bbLib.engaugeUnit('ANY', 40, true)" },
		{ "Unstable Affliction", { "target.exists", "target.enemy", "target.alive" } },
	},	{ "toggle.autoattack" } },
	
}, -- [Section Closing Curly Brace]

---- *** Toggle Buttons ***
function()
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autopet', 'Interface\\Icons\\achievement_boss_magtheridon', 'Pet Swapping', 'Toggle the usage of automatic pet management.')
	NetherMachine.toggle.create('survival', 'Interface\\Icons\\ability_warrior_defensivestance', 'Use Survival Abilities', 'Toggle usage of various self survival abilities.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\Achievement_Reputation_KirinTor', 'Use Mouseovers', 'Toggle usage of Moonfire/Sunfire on mouseover targets.')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack any anemies in range of the player.')
end)