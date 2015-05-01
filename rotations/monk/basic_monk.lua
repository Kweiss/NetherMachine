-- Class ID 10 - Four Line Killing Machine
NetherMachine.rotation.register(10, {

	--------------------
	-- Start Rotation --
	--------------------
  
	-- Roll
	{ "Roll", "modifier.rshift" },
  
  	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- Rotation
	{ "Tiger Palm", "player.buff(Tiger Power).duration < 3" },
	{ "Blackout Kick" },
	{ "Jab" },
	{ "Tiger Palm" },

	------------------
	-- End Rotation --
	------------------
  
	},{
  
	---------------
	-- OOC Begin --
	---------------
  
	-- Roll
	{ "Roll", "modifier.rshift" },

	-------------
	-- OOC End --
	-------------
},

function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
end)