
--   SPEC ID 581 (vengeance)
-- 	 talents=3323313
NetherMachine.rotation.register_custom(581, '|cff69ACC8Simcraft Veng Rotation|r',{

	--Mobility
	{ "Infernal Strike", "modifier.shift", "ground" },
	{ "Sigil of Flame", "modifier.alt", "ground"}, -- fire DPS
	-- { "Sigil of Chains", "modifier.alt", "ground"}, -- snare (like deathgrip)
	-- { "Sigil of Misery", "modifier.alt", "ground"}, -- fear (up to 30 seconds)
	-- { "Sigil of silence", "modifier.alt", "ground"}, -- silence for 6 seconds

	--Interrupts
	{ "Consume Magic", { "modifier.interrupts", "!lastcast(Arcane Torrent)" }},
	{ "Arcane Torrent", { "modifier.interrupts", "!lastcast(Consume Magic)" }},

	--Defensive Cooldowns
	{"Metamorphosis", { "player.health < 30" }},

	{"Fiery Brand", {
	"player.health < 60",
	}},

	{ "Demon Spikes", {
	"!player.buff(Demon Spikes)",
	"player.health < 75",
	}},

	{ "Demon Spikes", {
	"!player.buff(Demon Spikes)",
	"player.spell(Demon Spikes).charges > 1"
	}},

	{ "Soul Cleave", {
	"player.health < 40",
	"player.pain > 30",
	}},

	{ "Soul Cleave", {
	"player.health < 70",
	"player.pain > 60",
	}},

	{ "Soul Cleave", {
	"player.health < 85",
	"player.pain > 85",
	}},

	{ "Soul Cleave", {
	"player.pain > 98",
	}},

	-- Cooldowns
	{"Metamorphosis", "modifier.cooldowns" },

	--AoE
	{ "Immolation Aura", {
	"target.range < 9",
	"modifier.multitarget"
	}},
	{ "Throw Glaive", "modifier.multitarget" },

	--Single Target
	{ "Immolation Aura", {
	"target.range < 9"
	}},
	{ "Felblade" },
	{ "Shear" },
},
{
	-- Out of Combat



}, function()
		NetherMachine.toggle.create('stayalive', 'Interface\\ICONS\\inv_shield_04', 'Stay Alive', 'StayAlive')
end)

NetherMachine.rotation.register_custom(581, '|cFF99FF00Legion |cFFFF6600Veng Demon Hunter |cFFFF9999(Mythic+)',{

	--Mobility
	{ "Infernal Strike", "modifier.shift", "ground" },
	{ "Sigil of Flame", "modifier.alt", "target.ground"}, -- fire DPS
	-- { "Sigil of Chains", "modifier.alt", "ground"}, -- snare (like deathgrip)
	-- { "Sigil of Misery", "modifier.alt", "ground"}, -- fear (up to 30 seconds)
	-- { "Sigil of silence", "modifier.alt", "ground"}, -- silence for 6 seconds

	--Interrupts
	{ "Consume Magic", { "modifier.interrupts", "!lastcast(Arcane Torrent)" }},
	{ "Sigil of Silence", { "modifier.interrupts", "!lastcast(Arcane Torrent)", "!lastcast(Consume Magic)" }, "target.ground"},
	{ "Arcane Torrent", { "modifier.interrupts", "!lastcast(Consume Magic)" }},


-- actions=auto_attack
-- actions+=/fiery_brand,if=buff.demon_spikes.down&buff.metamorphosis.down
	{"Fiery Brand", { "!player.buff(Demon Spikes)", "!player.buff(Metamorphosis)" }},

-- actions+=/demon_spikes,if=charges=2|buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down
	{ "Demon Spikes", { "!player.buff(Demon Spikes)", "player.spell(Demon Spikes).charges > 1" }},
	{ "Demon Spikes", {	"!player.buff(Demon Spikes)", "!player.buff(Metamorphosis)", "!target.debuff(Fiery Brand)" }},

-- actions+=/empower_wards,if=debuff.casting.up

-- actions+=/infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&artifact.fiery_demise.enabled&dot.fiery_brand.ticking
	{ "Infernal Strike", { "modifier.shift"	}, "target.ground" },

-- actions+=/infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&(!artifact.fiery_demise.enabled|(max_charges-charges_fractional)*recharge_time<cooldown.fiery_brand.remains+5)&(cooldown.sigil_of_flame.remains>7|charges=2)

-- actions+=/spirit_bomb,if=debuff.frailty.down
	{"Spirit Bomb", "!target.debuff(Frailty)" },

-- actions+=/soul_carver,if=dot.fiery_brand.ticking
	{"Soul Carver", "target.debuff(Fiery Brand)" },

-- actions+=/immolation_aura,if=pain<=80
	{ "Immolation Aura", { "target.range < 9", "player.pain <= 80" }},

-- actions+=/felblade,if=pain<=70
	{ "Felblade", { "player.pain <= 70" }},

-- actions+=/soul_barrier
	{ "Soul Barrier" },
-- actions+=/soul_cleave,if=soul_fragments=5
	{ "Soul Cleave", { "player.spell(Soul Cleave).charges > 4" 	}},

-- actions+=/metamorphosis,if=buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down&incoming_damage_5s>health.max*0.70
	{"Metamorphosis", { "!player.buff(Demon Spikes)", "!target.debuff(Fiery Brand)"	}},
	{"Metamorphosis", { "modifier.cooldowns"	}},

-- actions+=/fel_devastation,if=incoming_damage_5s>health.max*0.70

-- actions+=/soul_cleave,if=incoming_damage_5s>=health.max*0.70
	{"Soul Cleave", "player.pain >= 80", "player.health < 80 " },
-- actions+=/fel_eruption
	{"Fel Eruption" },

-- actions+=/sigil_of_flame,if=remains-delay<=0.3*duration
	{ "Sigil of Flame", "", "target.ground"}, -- fire DPS
-- actions+=/fracture,if=pain>=80&soul_fragments<4&incoming_damage_4s<=health.max*0.20
	{"Fracture", "player.pain >= 80", "player.spell(Soul Cleave).charges < 4", "player.health < 73" },
-- actions+=/soul_cleave,if=pain>=80
	{"Soul Cleave", "player.pain >= 80" },

-- actions+=/shear
	{"Shear" },

	},
	{
		-- Out of Combat



	}, function()
			NetherMachine.toggle.create('stayalive', 'Interface\\ICONS\\inv_shield_04', 'Stay Alive', 'StayAlive')
	end)
