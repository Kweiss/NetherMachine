-- NetherMachine Rotation
-- Discipline Priest - Legion 7.0.3
-- Updated on Sept 15th 2016

-- PLAYER CONTROLLED (TODO):
-- TALENTS:
-- CONTROLS: Pause - Left Control

-- TODO: Actually use talents, mouseover rez/rebirth, OOC rotation.

-- SPEC ID 256 (Disc)
ProbablyEngine.rotation.register(256, {

  --------------------
  -- Start Rotation --
  --------------------
  -- On tank
  {{
  { "Shadowmend", {
    "tank.health < 40",
    "!tank.dead",
    "tank.range <= 40",
  }, "tank" },

  { "Plea", {
    "tank.health < 60",
    "!tank.dead",
    "tank.range <= 40",
    "!last.cast(Plea)",
  }, "tank" },

  { "Power Word: Shield", {
    "tank.health < 95",
    "!tank.buff(Power Word: Shield)",
    "!tank.dead",
    "tank.range <= 40",
  }, "tank" },
  },{
  "tank.exists",
  }},

  --Big Stuff
  { "Divine Star", "modifier.cooldowns" },
  { "Mindbender", "modifier.cooldowns"},


  ------------------------------------------
  -- Atonement Checks and Regular Healing --
  ------------------------------------------
  { "Pain Suppression", {
    "lowest.health <= 25",
    "lowest.range <= 40",
    "lowest.buff(Atonement).duration > 1"
  }, "lowest" },

  { "Rapture", {
    "@coreHealing.needsHealing(60, 3)",
    "lowest.range <= 40"
  }, "player" },

  { "Power Word: Shield", {
    "lowest.health <= 60",
    "lowest.range <= 40",
    "!lowest.buff(Power Word: Shield)",
    "player.buff(Rapture)",
  }, "lowest" },

  { "Power Word: Radiance", {
    "@coreHealing.needsHealing(78, 3)",
    "lowest.range <= 40"
  }, "lowest" },

  { "Shadow Mend", {
    "lowest.health <= 50",
    "lowest.range <= 40",
    "lowest.buff(Atonement).duration < 4"
  }, "lowest" },

  { "Power Word: Shield", {
    "lowest.health <= 80",
    "lowest.range <= 40",
    "!lowest.buff(Power Word: Shield)",
  }, "lowest" },

  { "Plea", {
    "lowest.health <= 85",
    "!lowest.buff(Atonement)",
    "lowest.range <= 40"
  }, "lowest" },

  --Direct Damage

  { "Shadow Word: Pain", "target.debuff(Shadow Word: Pain).duration < 2" },
  { "Purge the Wicked", "target.debuff(Purge the Wicked).duration < 2" },
  { "Schism" },
  { "Penance" },
  { "Smite" },


  ------------------
  -- End Rotation --
  ------------------

})

-- PtW (purge the wicked) Level 100 talent >    Rapture>PWSx6-8>PWR x 1-2>MB>Penance


NetherMachine.rotation.register_custom(256, "bbPriest Discipline", {
-- COMBAT ROTATION
  -- Pause Rotation
  { "pause", "modifier.lalt" },
  { "pause", "player.buff(Food)" },

  -- DISPELLS
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Aqua Bomb)" }, "mouseover" }, -- Proving Grounds
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Shadow Word: Bane)" }, "mouseover" }, -- Fallen Protectors
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Lingering Corruption)" }, "mouseover" }, -- Norushen
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Mark of Arrogance)", "player.buff(Power of the Titans)" }, "mouseover" }, -- Sha of Pride
  --{ "Dispel", { "toggle.dispel", "mouseover.debuff(Corrosive Blood)" }, "mouseover" }, -- Thok
  -- Dispel Magic Removes 1 beneficial Magic effect from an enemy.
  -- Mass Dispel - Removes one harmful magical effect from every friendly target and one beneficial magical effect from every enemy target in an area. If Glyph of Mass Dispel Icon Glyph of Mass Dispel is used, then it also removes effects that are not normally dispellable.
  -- Purify - Removes all Magic and Disease effects from a friendly target (8-second cooldown)

  -- DEFENSIVE COOLDOWNS
  { "Psychic Scream", { "talent(4, 2)", "player.area(3).enemies > 2" } },
  { "Fade", "player.state.stun" },
  { "Fade", "player.state.root" },
  { "Fade", "player.state.snare" },
  { "Fade", "player.area(1).enemies > 1" },

  -- SURGE OF LIGHT
  { "Flash Heal", { "lowest.health < 100", "player.buff(Surge of Light)" }, "lowest" },

  -- HEALING COOLDOWNS
  -- Pain Suppression should be used on a tank, before a damage spike. Alternatively, it can be used on a raid member who is targeted by a very damaging ability.
  -- Power Word: Barrier should be used to mitigate intense AoE damage; it requires the raid to be stacked in one place.
  -- Power Infusion should be used whenever a period of intense healing is coming up, or simply when you want to conserve your Mana. Exceptionally, you can use it to deal more damage, if the encounter calls for it.
  -- Spirit Shell should be used whenever there is high sustained damage to heal. You should aim to use it as many times as possible throughout the fight. It can also be used to pre-shield a target before they receive a lot of damage.
  { "Power Infusion", { "talent(5, 2)", "@coreHealing.needsHealing(70, 5)" } },
  -- Cascade is a sort of chain heal. It heals an initial target (with the healing being greater the farther away that target is), and then bouncing to additional allies up to 4 times. Each time that the heal bounces, it splits into 2 heals. It can never heal the same target twice.
  { "Cascade", { "talent(6, 1)", "lowest.health < 90", "@bbLib.NeedHealsAroundUnit('Cascade')" }, "lowest" },
  { "Mindbender", "player.mana < 90" },

  -- SELF HEALING
  { "Desperate Prayer", "player.health < 80", "player" },
  { "Power Word: Shield", "!player.debuff(Weakened Soul)", "player" },
  { "Penance", "player.health < 80", "player" },
  { "Flash Heal", "player.health < 70", "player" },
  { "Heal", "player.health < 90", "player" },

  -- RAID HEALING
  -- Prayer of Healing is your go-to AoE heal. To make optimal use of it, the members of your target's party must be significantly damaged.
  -- Holy Nova is another AoE heal that does a surprisingly good amount of healing. As an added bonus, this can be cast while moving.
  --{ "Holy Nova", { "!modifer.last", "@bbLib.NeedHealsAroundUnit('Holy Nova', 'player', 3, 12, 90)" } },

  -- CLARITY OF WILL
  { "Clarity of Will", { "focus.exists", "focus.friend", "!focus.buff(Clarity of Will)", "focus.distance < 40" }, "focus" },
  { "Clarity of Will", { "!focus.exists", "tank.exists", "tank.friend", "!tank.buff(Clarity of Will)", "tank.distance < 40" }, "tank" },

  -- PENANCE
  { "Penance", { "!player.moving", "focus.exists", "focus.friend", "focus.health < 100", "target.distance < 40" }, "focus" },
  { "Penance", { "!player.moving",  "tank.exists", "tank.friend", "tank.health < 100", "tank.distance < 40" }, "tank" },
  { "Penance", { "!player.moving",  "boss1target.exists", "boss1target.friend", "boss1target.health < 100", "boss1target.distance < 40" }, "boss1target" },
  { "Penance", { "!player.moving",  "boss2target.exists", "boss2target.friend", "boss2target.health < 100", "boss2target.distance < 40" }, "boss2target" },
  { "Penance", { "!player.moving",  "boss3target.exists", "boss3target.friend", "boss3target.health < 100", "boss3target.distance < 40" }, "boss3target" },
  { "Penance", { "!player.moving",  "boss4target.exists", "boss4target.friend", "boss4target.health < 100", "boss4target.distance < 40" }, "boss4target" },
  --{ "Penance", { "!player.moving",  "target.exists", "target.friend", "target.health < 100", "target.distance < 40" }, "target" },
  --{ "Penance", { "!player.moving",  "toggle.mouseover", "mouseover.exists", "mouseover.friend", "mouseover.health < 100", "mouseover.distance < 40" }, "mouseover" },
  --{ "Penance", { "!player.moving",  "lowest.exists", "lowest.friend", "lowest.health < 100", "lowest.distance < 40" }, "lowest" },

  -- PWS
  { "Power Word: Shield", { "focus.exists", "focus.friend", "!focus.debuff(Weakened Soul)", "focus.distance < 40" }, "focus" },
  { "Power Word: Shield", { "tank.exists", "tank.friend", "!tank.debuff(Weakened Soul)", "tank.distance < 40" }, "tank" },
  { "Power Word: Shield", { "boss1target.exists", "boss1target.friend", "!boss1target.debuff(Weakened Soul)", "boss1target.distance < 40" }, "boss1target" },
  { "Power Word: Shield", { "boss2target.exists", "boss2target.friend", "!boss2target.debuff(Weakened Soul)", "boss2target.distance < 40" }, "boss2target" },
  { "Power Word: Shield", { "boss3target.exists", "boss3target.friend", "!boss3target.debuff(Weakened Soul)", "boss3target.distance < 40" }, "boss3target" },
  { "Power Word: Shield", { "boss4target.exists", "boss4target.friend", "!boss4target.debuff(Weakened Soul)", "boss4target.distance < 40" }, "boss4target" },
  { "Power Word: Shield", { "target.exists", "target.friend", "!target.debuff(Weakened Soul)", "target.distance < 40" }, "target" },
  { "Power Word: Shield", { "toggle.mouseover", "mouseover.exists", "mouseover.friend", "!mouseover.debuff(Weakened Soul)", "mouseover.distance < 40" }, "mouseover" },

  { "Power Word: Shield", { "!modifier.raid", "!party1.debuff(Weakened Soul)", "party1.distance < 40" }, "party1" },
  { "Power Word: Shield", { "!modifier.raid", "!party2.debuff(Weakened Soul)", "party2.distance < 40" }, "party2" },
  { "Power Word: Shield", { "!modifier.raid", "!party3.debuff(Weakened Soul)", "party3.distance < 40" }, "party3" },
  { "Power Word: Shield", { "!modifier.raid", "!party4.debuff(Weakened Soul)", "party4.distance < 40" }, "party4" },

  { "Power Word: Shield", { "lowest.health < 100", "!lowest.debuff(Weakened Soul)", "lowest.distance < 40" }, "lowest" },

  -- PRAYER OF MENDING
  { {
    { "Prayer of Mending", { "focus.exists", "focus.friend", "!focus.buff(Prayer of Mending)" }, "focus" },
    { "Prayer of Mending", { "tank.exists", "tank.friend", "!tank.buff(Prayer of Mending)" }, "tank" },
    { "Prayer of Mending", { "boss1target.exists", "boss1target.friend", "!boss1target.buff(Prayer of Mending)" }, "boss1target" },
    { "Prayer of Mending", { "boss2target.exists", "boss2target.friend", "!boss2target.buff(Prayer of Mending)" }, "boss2target" },
    { "Prayer of Mending", { "boss3target.exists", "boss3target.friend", "!boss3target.buff(Prayer of Mending)" }, "boss3target" },
    { "Prayer of Mending", { "boss4target.exists", "boss4target.friend", "!boss4target.buff(Prayer of Mending)" }, "boss4target" },
  }, "!player.spell(Prayer of Mending).ingroup" },


  -- HEALING DUMP
  { "Flash Heal", { "lowest.health < 50", "target.distance < 40" }, "lowest" },
  { "Power Word: Solace", { "lowest.health > 90", "player.mana < 80" } },
  { "Heal", { "lowest.health < 100", "target.distance < 40" }, "lowest" },

}, {
-- OUT OF COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lalt" },
  { "pause", "player.buff(Food)" },

  -- BUFFS
  { "Power Word: Fortitude", { "!player.buffs.stamina", "lowest.distance < 40" }, "lowest" },

  { "Power Word: Shield", { "focus.moving", "focus.exists", "focus.friend", "!focus.debuff(Weakened Soul)", "focus.distance < 40" }, "focus" },
  { "Power Word: Shield", { "tank.moving", "tank.exists", "tank.friend", "!tank.debuff(Weakened Soul)", "tank.distance < 40" }, "tank" },

  -- REZ
  --{ "Resurrection", { "target.exists", "target.dead", "!player.moving", "target.player" }, "target" },
  --{ "Resurrection", { "party1.exists", "party1.dead", "!player.moving", "party1.range < 35" }, "party1" },
  --{ "Resurrection", { "party2.exists", "party2.dead", "!player.moving", "party2.range < 35" }, "party2" },
  --{ "Resurrection", { "party3.exists", "party3.dead", "!player.moving", "party3.range < 35" }, "party3" },
  --{ "Resurrection", { "party4.exists", "party4.dead", "!player.moving", "party4.range < 35" }, "party4" },

  -- HEAL
  { "Flash Heal", { "!player.moving", "lowest.health < 85" }, "lowest" },
  { "Heal", { "!player.moving", "lowest.health < 100" }, "lowest" },

  -- AUTO FOLLOW
  { "/follow focus", { "toggle.autofollow", "focus.exists", "focus.alive", "focus.friend", "!focus.range < 3", "focus.range < 20" } }, -- TODO: NYI: isFollowing()

},
function()
  NetherMachine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
  NetherMachine.toggle.create('mouseover', 'Interface\\Icons\\spell_nature_resistnature', 'Mouseovers', 'Toggle usage of mouseover healing.')
  NetherMachine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target. Must be another player.')
end)
