-- SPEC ID 104
-- talents=3331321
-- For stuff that dies quickly (most Mythic+) use : lunar, brambles, GG

--[[

( Pawn: v1: "Survival": Agility=1.33, Stamina=4.91, CritRating=1.99, HasteRating=1.67, MasteryRating=2.60, Versatility=2.70, Armor=40.74 ) @845
( Pawn: v1: "Survival": Agility=1.03, Stamina=5.12, CritRating=1.7, HasteRating=1.4, MasteryRating=2.21, Versatility=2.30, Armor=35.74 ) @870



]]--

NetherMachine.rotation.register(104, {

  --------------------
  -- Start Rotation --
  --------------------

  { "Skull Bash", { "target.interruptAt(75)", "!last.cast(Mighty Bash)", "!last.cast(War Stomp)", "modifier.interrupt" }},
	{ "Mighty Bash", { "target.interruptAt(75)", "!last.cast(Skull Bash)", "!last.cast(War Stomp)", "modifier.interrupt" }},
	{ "War Stomp", { "target.interruptAt(50)", "!last.cast(Skull Bash)", "!last.cast(Mighty Bash)", "modifier.interrupt", "target.range <= 10" }},

    -- Survival
  {{
    { "#140352", { "player.health < 25" } }, -- Dream Berries

    { "61336", { "player.health <= 40", "player.spell(61336).charges > 1" }}, --Survival Instincts

    { "#5512", { "player.health <= 50" }}, --Healthstone

    { "192081", { "player.rage > 90", "!player.buff(Ironfur)", "target.threat >= 100" }}, -- Ironfur
    { "192081", { "player.rage > 95", "target.threat >= 100" }}, -- Ironfur
    { "192081", { "player.health <= 96", "player.rage > 60", "!player.buff(Ironfur)" }}, -- Ironfur
    { "192081", { "player.health <= 70", "player.rage > 50", "!player.buff(Ironfur)" }}, -- Ironfur
    { "192081", { "player.health <= 75", "player.rage > 75" }}, -- Ironfur
    { "192081", { "player.health <= 55", "player.rage > 55" }}, -- Ironfur

    { "192083", { "player.health <= 90", "player.rage > 60", "toggle.Magic" }}, -- Mark of Ursol

    { "22842", { "player.health <= 78", "!modifier.last(22842)", "player.spell(22842).charges > 1" }}, --Frenzied Regeneration

    { "200851", { "player.health <= 70", "modifier.cooldowns" }}, --Rage of the Sleeper

    { "22812", { "player.health <= 80" }}, --Barkskin

    },{
  		"toggle.Survival", "target.exists", "target.enemy", "target.alive", "targettarget.istheplayer", "!player.buff(Bristling Fur)", "!player.buff(Survival Instincts)"
  	} },

  -- Cooldowns
  { "200851", { "player.buff(Bloodlust)", "modifier.cooldowns" }}, --Rage of the Sleeper
  { "#trinket2", { "player.buff(Rage of the Sleeper)" }}, --Vers Trinket

  -- Kill stuff
  { "33917" }, --Mangle
  { "77758", { "target.range <= 9" }}, --Thrash
  { "Moonfire", { "talent(5,3)", "player.buff(Galactic Guardian)", "!last.cast(Moonfire)", "player.spell(33917).cooldown > 1", "player.spell(77758).cooldown > 1" }},

  { "213764", { "target.range <= 9", "modifier.multitarget" }}, --Swipe

  { "Moonfire", { "talent(5,3)", "player.buff(Galactic Guardian)" }},
  { "Moonfire", { "target.debuff(Moonfire).duration < 2", "player.spell(33917).cooldown > 1", "player.spell(77758).cooldown > 1" }},

  { "213764", { "target.range <= 9", "player.spell(33917).cooldown > 1", "player.spell(77758).cooldown > 1" }}, --Swipe

  { "6807", { "player.rage >= 85", "player.health > 95 ", "!modifier.last(6807)" }}, --Maul

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
