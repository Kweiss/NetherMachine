-- SPEC ID 71
NetherMachine.rotation.register(71, {


--Rotation according to Icy Veins, with some extra PvP stuff
--I haven't experimented enough with AoE to have sweeping strikes trigger with NM
--at the optimal time, and whirlwind goes off quite a bit just using the
--single target rotation.
-- <3 thefrese

  --------------------
  -- Start Rotation --
  --------------------
	--Heroic Leap time!
	--Leap to your mouseover with Control!
	{ "Heroic Leap", "modifier.control", "mouseover.ground"},
	--Leap to your target with Alt!
	{ "Heroic Leap", "modifier.alt", "ground"},

	--Interrupts
	{ "Pummel", "modifier.interrupts" },

	--Snare if target is a player
	{ "Hamstring", {
		"!target.debuff(Hamstring)",
		"modifier.player"
	}},

	--Cooldowns
	{ "Battle Cry", "modifier.cooldowns" },
	{ "Bloodbath", "modifier.cooldowns" },
	{ "Avatar", "modifier.cooldowns" },
	{ "Rallying Cry", {
		"coreHealing.needsHealing(30, 4)",
		"modifier.cooldowns"
	}},
	{ "Die by the Sword", "player.health <= 65" },

	--Self-healing
	{ "Victory Rush", "player.health <= 85" },
	{ "Impending Victory", "player.health <= 85" },

	--Multitarget
	{ "Shockwave", "modifier.multitarget" },
	{ "Bladestorm", "modifier.multitarget" },
  { "Cleave", "modifier.multitarget" },
  { "Whirlwind", "modifier.multitarget" },

	--Rotation
	{ "Colossus Smash" },

	--Execute every chance you get!
	{ "Execute" },
  { "Overpower" },

	--Apply Rend, but don't waste precious Colossus Smash time!
	{ "Rend", { "!target.debuff(Rend)", "!target.debuff(Colossus Smash)" }},
	{ "Rend", { "target.debuff.duration(Rend) < 5", "!target.debuff(Colossus Smash)" }},

	--Build rage and whatnot
	{ "Mortal Strike" },
  { "Focused Rage", { "target.debuff(Focused Rage).count < 3" } },

	--Slam if you took that talent, WW if you didn't.
	{ "Slam", { "target.debuff(Focused Rage).count > 2" }},
	{ "Slam", "target.debuff(Colossus Smash)" },
  { "Victory Rush" },

},
{

	--Buff yourself
	{ "Battle Shout", "!player.buff(Battle Shout)" },

})
