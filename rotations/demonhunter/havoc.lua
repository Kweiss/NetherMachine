--   SPEC ID 577
NetherMachine.rotation.register_custom(577, '|cff69ACC8Havoc Pre Patch|r',{

	{ "Fel Rush", "modifier.shift" },
	{ "Demon's Bite", { "player.fury < 50", "player.spell(Throw Glaive).cooldown > 0"}},
	{ "Chaos Strike" , "!modifier.multitarget"},
	{ "Eye Beam", "modifier.multitarget"},
	{ "Throw Glaive" },
	--   { "Wilde Strike",   { "!modifier.multitarget","player.rage > 90"												 }},

	{ "Fel Rush", "modifier.shift" 											},
	{ "Consume Magic", "modifier.interrupts"									},
	{ "Annihilation",{"player.buff(Metamorphosis)", "!modifier.multitarget"	}},
	{ "Death Sweep", {"player.buff(Metamorphosis)", "modifier.multitarget"	}},
	{ "Throw Glaive" 													  	},
	{ "Metamorphosis", "modifier.cooldowns", "ground"									},
	{ "Demon's Bite", "player.fury < 50"										},

	{ "Blade Dance", {"player.spell(Eye Beam).cooldown > 5","modifier.multitarget" }},
	{ "Chaos Strike" , "!modifier.multitarget"								},
	{ "Chaos Strike" , { "player.spell(Eye Beam).cooldown > 3", "modifier.multitarget", "player.spell(Blade Dance).cooldown > 2"} },
	{ "Eye Beam", "modifier.multitarget"										},
	{ "Demon's Bite", "player.spell(Blade Dance).cooldown > 2"				},
	{ "Demon's Bite", "player.spell(Death Sweep).cooldown > 2"				},

},
{
  -- Out of Combat Buffing Buffing



}, function()
	-- "toggle.custom_toggle_name"
		NetherMachine.toggle.create('pally_toggle', 'Interface\\ICONS\\inv_shield_04', 'Pally Toggle', 'Description')
		NetherMachine.toggle.create('conc', 'Interface\\ICONS\\Spell_Holy_ImpHolyConcentration', 'conc', 'Description')
		NetherMachine.toggle.create('sock', 'Interface\\ICONS\\inv_shield_03', 'AS Interupt All', 'Only use Avenger Shield to Interupt when On')
		NetherMachine.toggle.create('stayalive', 'Interface\\ICONS\\inv_shield_04', 'Stay Alive', 'StayAlive')
end)
