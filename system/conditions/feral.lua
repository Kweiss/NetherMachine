-- SPEC ID 103
--Talents are 3323323
ProbablyEngine.rotation.register(103, {

  ------------------------------------------
  -- Survival Stuff --
  ------------------------------------------

  { "Survival Instincts", {
  "player.health <= 40",
  "!player.buff(Survival Instincts)",
  }},

  ------------------------------------------
  -- Interrupts --
  ------------------------------------------

  { "Skull Bash", {
    "target.interruptAt(75)",
    "!last.cast(War Stomp)",
    "modifier.interrupt"
  }},

  { "War Stomp", {
    "target.interruptAt(50)",
    "!last.cast(Skull Bash)",
    "modifier.interrupt"
  }},

  ------------------------------------------
  -- Cooldowns --
  ------------------------------------------

  {"Berserk", "modifier.cooldowns"},
  {"Incarnation: King of the Jungle", "modifier.cooldowns"},
  {"Ashamane's Frenzy", {
    "player.combopoints < 3 "
  }},
  { "#trinket2", "modifier.cooldowns" },

  ------------------------------------------
  -- Start Killing Things --
  ------------------------------------------

  {"Tiger's Fury", {
  "!player.buff(Clearcasting)",
  "player.energy < 23",
  }},

  {"Ferocious Bite", {
  "target.debuff(Rip).duration < 3",
  "target.health < 25"
  }},

  ------------------------------------------
  -- Self Healing --
  ------------------------------------------

  { "Healing Touch", {
    "player.buff(Predatory Swiftness)",
    "player.health <= 80",
  }},
  { "Healing Touch", {
    "player.buff(Predatory Swiftness)",
    "player.buff(Predatory Swiftness).duration < 1.5"
  }},

  ------------------------------------------
  -- Back to Killing Things --
  ------------------------------------------

  {"Savage Roar", "!player.buff(Savage Roar)" },

  ------------------------------------------
  -- Multi Target --
  ------------------------------------------
  {"Thrash", {
  "modifier.multitarget",
  "target.debuff(Thrash) < 2"
  }},

  ------------------------------------------
  -- Back to Killing Things --
  ------------------------------------------
  {"Rip", {
  "player.combopoints > 4",
  "target.debuff(Rip).duration < 2",
  }},
  {"Savage Roar", {
  "player.buff(Savage Roar).duration < 3",
  "player.combopoints > 4",
  }},
  {"Ferocious Bite", {
  "player.combopoints > 4",
  "player.energy > 125",
  }},
  {"Rake", {
  "target.debuff(Rake).duration < 3",
  }},
  {"Moonfire", {
  "target.debuff(Moonfire).duration < 4",
  }},
  {"Swipe", "modifier.multitarget"},
  {"Shred" },

  ------------------
  -- End Rotation --
  ------------------

  }, {

  ---------------
  -- OOC Begin --
  ---------------

  { "Savage Roar", {
    "!player.buff(Savage Roar)",
    "target.range < 10",
    "player.buff(Prowl)",
    "target.exists",
    "target.enemy",
  }},

  { "Prowl", {
    "player.buff(Cat Form)",
    "target.enemy",
    "!target.dead",
  }},
  -------------
  -- OOC End --
  -------------

})
