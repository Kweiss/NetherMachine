-- Class ID 3 - Hunter
NetherMachine.rotation.register(3, {
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
	
	-- Basic Rotation
	{ "Concussive Shot" },
	{ "Arcane Shot" },
	{ "Steady Shot" },

},	{
---- *** Out Of Combat Routine Section ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	
	-- Mass Resurrection
	{ "Mass Resurrection", { "modifier.party", "!modifier.raid", "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },
	{ "Mass Resurrection", { "!modifier.party", "modifier.raid", "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },
	
}, -- [Section Closing Curly Brace]

---- *** Toggle Buttons ***
function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('survival', 'Interface\\Icons\\ability_warrior_defensivestance', 'Use Survival Abilities', 'Toggle usage of various self survival abilities.')
end)