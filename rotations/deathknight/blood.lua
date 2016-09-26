-- SPEC ID 250
NetherMachine.rotation.register(250, {

  --------------------
  -- Start Rotation --
  --------------------

  --Taunt
  { "Dark Command", {
    "target.range <= 30",
    "target.threat < 100",
    "!modifier.last(Dark Command)",
    "modifier.shift",
    "toggle.tc",
  }},


  -- Keybinds
  { "Death and Decay", "modifier.shift", "ground" },

  -- Interrupts
  { "Mind Freeze", "modifier.interrupts" },

    -- Survival
  { "Anti-Magic Shell", {
    "player.health <= 70",
	  "target.casting"
  }},

  { "Dancing Rune Weapon", "player.health <= 35" },
  { "Vampiric Blood", "player.health <= 65" },

  -- Disease Control
  { "Blood Boil", {
    "target.debuff(Blood Plague).duration < 3",
    "target.range <= 10",
  }},

  -- Always do this
  { "Marrowrend",  "player.buff(Bone Shield).count < 5" },
  { "Death and Decay", {
    "player.buff(Crimson Scourge)", "ground",
    "toggle.conc",
  }}, ----This may cause problems??

  { "Death Strike", {
  "player.health < 85",
  }},
  { "Death Strike", {
  "player.runicpower > 80",
  }},
  { "Heart Strike", {
  "player.buff(Bone Shield).count > 4",
  "player.runes > 1",
  }},
  { "Blood Boil", },

  ------------------
  -- End Rotation --
  ------------------

},{

  ---------------
  -- OOC Begin --
  ---------------

  -- Buffs
  -- { "Horn of Winter", "!player.buff(Horn of Winter)" },
  -- { "Path of Frost", "!player.buff(Path of Frost).any" },
  -- { "Bone Shield", "player.buff(Bone Shield).charges < 1" },

  -- Keybinds
  { "Death Grip", "modifier.control" },

  -------------
  -- OOC End --
  -------------

  },
 function ()
  NetherMachine.toggle.create('tc', 'Interface\\Icons\\ability_deathwing_bloodcorruption_death', 'Threat Control', '')
  NetherMachine.toggle.create('conc', 'Interface\\ICONS\\Spell_Holy_ImpHolyConcentration', 'conc', 'Description')
  end)
