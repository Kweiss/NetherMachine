-- Class ID 3 - Huntard
NetherMachine.rotation.register(3, {

	--------------------
	-- Start Rotation --
	--------------------
	
  	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } }, 
	
	-- BASIC ROTATION
	{ "Concussive Shot" },
	{ "Arcane Shot" },
	{ "Steady Shot" },
  
	------------------
	-- End Rotation --
	------------------
  
  },
  
 function()
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
end)