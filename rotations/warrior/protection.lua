-- SPEC ID 73
NetherMachine.rotation.register(73, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Buffs
  { "Berserker Rage" },

  -- Survival
  { "Rallying Cry", {
    "player.health < 10",
    "modifier.cooldowns",
  }},

  { "Last Stand", {
    "player.health < 20",
    "modifier.cooldowns",
  }},

  { "Shield Wall", {
    "player.health < 30",
    "modifier.cooldowns",
  }},

  { "Impending Victory", "player.health <= 85" },
  { "Victory Rush", "player.health <= 85" },

  -- Survival Buffs
  { "Shield Block", "!player.buff(Shield Block)" },

  { "Shield Barrier", {
    "!player.buff(Shield Barrier)",
    "player.rage > 80",
  }},

  -- Threat Control w/ Toggle
  { "Taunt", "toggle.tc", "target.threat < 100" },
  { "Taun", "toggle.tc", "mouseover.threat < 100", "mouseover" },

  -- Kicks
  { "Pummel", "modifier.interrupts" },
  { "Disrupting Shout", "modifier.interrupts", "target.range <= 8" },

  -- Ranged
  { "Heroic Throw", "target.range >= 10" },

  { "Throw", {
    "target.range >= 10",
    "!player.moving",
  }},

  -- Cooldowns
  { "Bloodbath", "modifier.cooldowns"  },
  { "Avatar", "modifier.cooldowns"  },
  { "Recklessness", "target.range <= 8", "modifier.cooldowns"  },
  { "Skull Banner", "modifier.cooldowns"  },
  { "Bladestorm", "target.range <= 8", "modifier.cooldowns"  },

  -- AoE
  { "Sweeping Strikes", "modifier.multitarget", "target.range <= 5" },
  { "Thunder Clap", "modifier.multitarget", "target.range <= 5" },
  { "Whirlwind", "modifier.multitarget", "target.range <= 5" },
  { "Dragon Roar", "modifier.multitarget", "target.range <= 5" },
  { "Cleave", "player.rage > 60", "modifier.multitarget" },
  { "modifier.multitarget" },

  -- Rotation
  { "Shield Slam" },
  { "Revenge", { "player.rage <= 80", }},

  -- Bleed
  { "Devastate", "!target.debuff(Deep Wounds)" },

  -- Weakened Armor
  { "Devastate", { "target.debuff(Weakened Armor).count < 3" }},

  { "Sunder Armor", {
    "player.level < 26",
    "target.debuff(Weakened Armor).count < 3",
  }},

  -- Weakened Blows
  { "Thunder Clap", {
    "!target.debuff(Weakened Blows).any",
    "target.range <= 8",
  }},

  -- Filler lol
  { "Devastate" },

  ------------------
  -- End Rotation --
  ------------------

},
 function ()
  NetherMachine.toggle.create('tc', 'Interface\\Icons\\ability_deathwing_bloodcorruption_death', 'Threat Control', '')
  end)




  -- NetherMachine Rotation
  -- Protection Warrior Rotation for WoD 6.0.3
  -- Updated on Dec 28th 2014

  -- PLAYER CONTROLLED: Pots, Charge, Heroic Leap, Rallying Cry
  -- OPTIMAL TALENTS: 1113323
  -- OPTIMAL GLYPHS: unending_rage/cleave/heroic_leap
  -- CONTROLS: Pause - Left Control

  -- /script print("Distance: "..NetherMachine.condition["distance"]('target'))

  NetherMachine.rotation.register_custom(73, "bbWarrior Protection (SimC)", {



  },{
  -- OUT OF COMBAT

  	-- BUTTONS
  	{ "Heroic Leap", { "modifier.lshift" }, "ground" },

  },function()
  	NetherMachine.toggle.create('shieldblock', 'Interface\\ICONS\\ability_defend', 'Shield Block', 'Toggle usage of Shield Block for Physical Damage')
  	NetherMachine.toggle.create('shieldbarrier', 'Interface\\ICONS\\inv_shield_07', 'Shield Barrier', 'Toggle usage of Shield Barrier for Magic/Bleed Damage')
  end)

--[[

actions.prot=shield_block,if=!buff.neltharions_fury.up&((cooldown.shield_slam.remains<6&!buff.shield_block.up)|(cooldown.shield_slam.remains<6+buff.shield_block.remains&buff.shield_block.up))
actions.prot+=/ignore_pain,if=(rage>=60&!talent.vengeance.enabled)|(buff.vengeance_ignore_pain.up&buff.ultimatum.up)|(buff.vengeance_ignore_pain.up&rage>=39)|(talent.vengeance.enabled&!buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage<30)
actions.prot+=/focused_rage,if=(buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(buff.ultimatum.up&buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(talent.vengeance.enabled&buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage>=30)|(buff.ultimatum.up&buff.vengeance_ignore_pain.up&cooldown.shield_slam.remains=0&rage<10)|(rage>=100)
actions.prot+=/demoralizing_shout,if=incoming_damage_2500ms>health.max*0.20
actions.prot+=/shield_wall,if=incoming_damage_2500ms>health.max*0.50
actions.prot+=/last_stand,if=incoming_damage_2500ms>health.max*0.50&!cooldown.shield_wall.remains=0
actions.prot+=/potion,name=unbending_potion,if=(incoming_damage_2500ms>health.max*0.15&!buff.potion.up)|target.time_to_die<=25
actions.prot+=/call_action_list,name=prot_aoe,if=spell_targets.neltharions_fury>=2
actions.prot+=/focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot+=/neltharions_fury,if=incoming_damage_2500ms>health.max*0.20&!buff.shield_block.up
actions.prot+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot+=/revenge,if=cooldown.shield_slam.remains<=gcd.max*2
actions.prot+=/devastate

actions.prot_aoe=focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot_aoe+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot_aoe+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot_aoe+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot_aoe+=/neltharions_fury,if=buff.battle_cry.up
actions.prot_aoe+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot_aoe+=/revenge
actions.prot_aoe+=/thunder_clap,if=spell_targets.thunder_clap>=3
actions.prot_aoe+=/devastate

]]--
