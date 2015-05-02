-- Class ID 10 - Four Line Killing Machine
NetherMachine.rotation.register(10, {
---- *** Combat Routine Section ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },
	
	-- Roll
	{ "Roll", "modifier.rshift" },

	-- Survival Logic
	{	{
		{ "#5512", { "player.health < 30" } }, -- Healthstone (5512)
		{ "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
	},	{ "toggle.survival" } },

	-- Auto Target
	{	{
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

	-- Rotation
	{ "Tiger Palm", "player.buff(Tiger Power).duration < 3" },
	{ "Blackout Kick" },
	{ "Jab" },
	{ "Tiger Palm" },

},	{
---- *** Out Of Combat Routine Section ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Roll
	{ "Roll", "modifier.rshift" },
	
	-- Mass Resurrection
	{ "Mass Resurrection", { "modifier.party", "!modifier.raid", "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },
	{ "Mass Resurrection", { "!modifier.party", "modifier.raid", "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },
	
}, -- [Section Closing Curly Brace]

---- *** Toggle Buttons ***
function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('survival', 'Interface\\Icons\\ability_warrior_defensivestance', 'Use Survival Abilities', 'Toggle usage of various self survival abilities.')
end)