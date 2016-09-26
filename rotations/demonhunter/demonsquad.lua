--   SPEC ID 577

NetherMachine.rotation.register_custom(581, '|cff69ACC8DS Rotation|r',{

--Mobility
	{ "Infernal Strike", "modifier.shift", "ground" },
	{ "Sigil of Flame", "modifier.control", "ground"},

	--Interupts
	{ "Arcane Torrent", "modifier.interrupts" },
	{ "Consume Magic", { "modifier.interrupts", "!lastcast(Arcane Torrent)" }},

	{"Immolation Aura", "target.range < 9"},

	{ "Demon Spikes", {
	"!player.buff(Demon Spikes)",
	"player.spell(Demon Spikes).charges > 1",
	}},
	{ "Soul Cleave", "player.health < 70"},
	--Defensive Cooldowns
	{"Metamorphosis", {
	"player.health < 40",
	"modifier.cooldowns"
	}},

	{"Fiery Brand", {
	"player.health < 90",
	}},

	{ "Demon Spikes", {
	"!player.buff(Demon Spikes)",
	"player.health <85",
	}},
	{ "Soul Cleave", {
	"player.health < 90",
	"player.pain > 90",
	}},


	-- Cooldowns
	{"Metamorphosis", "modifier.cooldowns" },

	--AoE

	{"Throw Glaive"},

	--Single Target
	{"Shear" },

  },

  {



}


, function()
	-- "toggle.custom_toggle_name"
		NetherMachine.toggle.create('pally_toggle', 'Interface\\ICONS\\inv_shield_04', 'Pally Toggle', 'Description')
		NetherMachine.toggle.create('conc', 'Interface\\ICONS\\Spell_Holy_ImpHolyConcentration', 'conc', 'Description')
		NetherMachine.toggle.create('sock', 'Interface\\ICONS\\inv_shield_03', 'AS Interupt All', 'Only use Avenger Shield to Interupt when On')
		NetherMachine.toggle.create('stayalive', 'Interface\\ICONS\\inv_shield_04', 'Stay Alive', 'StayAlive')
end)
