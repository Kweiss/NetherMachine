-- SPEC ID 104
-- talents=3331321
NetherMachine.rotation.register(104, {

  --------------------
  -- Start Rotation --
  --------------------

  { "#5512", { "player.health < 50" } }, -- Healthstone (5512)
	{ "Survival Instincts", { "!player.buff(Survival Instincts)", "!modifier.last", "player.health <= 40" } },

	{ "Skull Bash", { "target.interruptAt(75)", "!last.cast(Mighty Bash)", "!last.cast(War Stomp)", "modifier.interrupt" }},
	{ "Mighty Bash", { "target.interruptAt(75)", "!last.cast(Skull Bash)", "!last.cast(War Stomp)", "modifier.interrupt" }},
	{ "War Stomp", { "target.interruptAt(50)", "!last.cast(Skull Bash)", "!last.cast(Mighty Bash)", "modifier.interrupt" }},

    -- Survival
  {{

    { "61336", { "player.health <= 40", "player.spell(61336).charges > 1" }}, --Survival Instincts

    { "#5512", { "player.health <= 50" }}, --Healthstone

    { "192081", { "player.rage > 90", "!player.buff(Ironfur)" }}, -- Ironfur
    { "192081", { "player.health <= 96", "player.rage > 60", "!player.buff(Ironfur)" }}, -- Ironfur
    { "192081", { "player.health <= 70", "player.rage > 50", "player.buff(Ironfur)" }}, -- Ironfur

    { "192083", { "player.health <= 90", "player.rage > 60", "toggle.Magic" }}, -- Mark of Ursol

    { "22842", { "player.health <= 80", "!modifier.last(22842)", "player.spell(22842).charges > 1" }}, --Frenzied Regeneration

    { "200851", { "player.health <= 70", "modifier.cooldowns" }}, --Rage of the Sleeper

    { "22812", { "player.health <= 80" }}, --Barkskin

    },{
  		"toggle.Survival", "target.exists", "target.enemy", "target.alive", "targettarget.istheplayer", "!player.buff(Bristling Fur)", "!player.buff(Survival Instincts)", "!player.buff(Barkskin)", "!player.buff(Savage Defense)"
  	} },

  -- Mob Control
  { "200851", { "player.buff(Bloodlust)", "modifier.cooldowns" }}, --Rage of the Sleeper
  { "Moonfire", { "talent(5,3)", "player.buff(Galactic Guardian)", "!last.cast(Moonfire)" }},
  { "33917" }, --Mangle
  { "77758", { "target.range <= 5" }}, --Thrash
  { "213764", { "target.range <= 5", "modifier.multitarget" }}, --Swipe
  { "Moonfire", { "talent(5,3)", "player.buff(Galactic Guardian)" }},
  { "Moonfire", { "target.debuff(Moonfire).duration < 2" }},
  { "213764", { "target.range <= 5" }}, --Swipe

  -- { "6807", { "player.rage >= 80", "player.health > 90 ", "!modifier.last(6807)" }}, --Maul

  ------------------
  -- End Rotation --
  ------------------

},{
  ---------------
  -- OOC Begin --
  ---------------

 -------------
  -- OOC End --
  -------------

},
function()
  NetherMachine.toggle.create('Survival', 'Interface\\Icons\\Ability_druid_tigersroar','Survivability','Enable or Disable the usage of Survivability Cooldowns')
  NetherMachine.toggle.create('Magic', 'Interface\\Icons\\inv_shield_04','Magic','This is the Magic active mitigation')
end)
