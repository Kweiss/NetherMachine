-- SPEC ID 269
-- talents=3010033
NetherMachine.rotation.register(269, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Get Fucked Button
  { "Touch of Death", "player.buff(Death Note)" },

  -- Interrupts
  { "Spear Hand Strike", {"target.interruptAt(75)", "!modifier.last(Leg Sweep)" }},
  { "Leg Sweep", {"target.interruptAt(75)", "!modifier.last(Spear Hand Strike)", "target.range <= 5" }},

  -- Survival
  { "Touch of Karma", "player.health < 75" },
  { "Healing Elixir", "player.health < 84" },

  -- Cooldowns
  { "Energizing Elixir", {"modifier.cooldowns", "target.range <= 8", "player.energy < 35", "player.chi < 1" }},

  { "Invoke Xuen, The White Tiger", "modifier.cooldowns" },

  { "Storm, Earth, and Fire", {"modifier.cooldowns", "player.spell(Strike of the Windlord).cooldown < 14", "player.spell(Fists of Fury).cooldown <= 9", "player.spell(Rising Sun Kick).cooldown <= 5", "target.range <= 8" }},
  { "Strike of the Windlord", {"modifier.cooldowns", "target.range <= 8" } },
  { "Whirling Dragon Punch", {"modifier.cooldowns", "target.range <= 8" } },
  { "Fists of Fury", {"target.range <= 8" } },
  { "#trinket2", {"modifier.cooldowns", "target.range <= 8" }},

  -- Talents
  { "Tiger's Lust", "target.range >= 15" },

  -- Multi-Target
  { "Spinning Crane Kick", {"modifier.multitarget", "!modifier.last(Spinning Crane Kick)" }},

  -- Rotation
  { "Tiger Palm", { "player.chi < 4", "!modifier.last(Tiger Palm)", "player.energy > 93" }},
  { "Rising Sun Kick", },
  { "Rushing Jade Wind", {"!modifier.last(Rushing Jade Wind)", "player.chi > 1 " }},
  { "Chi Wave", "player.energy < 75 " },
  { "Chi Burst", "player.energy < 75 " },
  { "100784", {"player.chi > 1", "!modifier.last(100784)" }}, --Blackout Kick
  { "100784", {"player.buff(Blackout Kick!)", "!modifier.last(100784)" }},
  { "Tiger Palm", { "player.chi < 4", "!modifier.last(Tiger Palm)" }},
  { "Tiger Palm", { "player.chi < 4", "target.health > 96" }},

  ------------------
  -- End Rotation --
  ------------------

  },{

  ---------------
  -- OOC Begin --
  ---------------
  { "Healing Elixir", "player.health < 84" },

  -- Keybinds
  { "Paralysis", "modifier.alt", "mouseover" },
  { "Crackling Jade Lightning", "modifier.shift", "target" },

  -------------
  -- OOC End --
  -------------
})



--[[

# Executed every time the actor is available.
actions=auto_attack
actions+=/spear_hand_strike,if=target.debuff.casting.react
actions+=/potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
actions+=/call_action_list,name=serenity,if=(talent.serenity.enabled&cooldown.serenity.remains<=0)&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=15&cooldown.fists_of_fury.remains<8&cooldown.rising_sun_kick.remains<=4)|buff.serenity.up)
actions+=/call_action_list,name=sef,if=!talent.serenity.enabled&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=14&cooldown.fists_of_fury.remains<=6&cooldown.rising_sun_kick.remains<=6)|buff.storm_earth_and_fire.up)
actions+=/call_action_list,name=serenity,if=(talent.serenity.enabled&cooldown.serenity.remains<=0)&(!artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<14&cooldown.fists_of_fury.remains<=15&cooldown.rising_sun_kick.remains<7)|buff.serenity.up
actions+=/call_action_list,name=sef,if=!talent.serenity.enabled&((!artifact.strike_of_the_windlord.enabled&cooldown.fists_of_fury.remains<=9&cooldown.rising_sun_kick.remains<=5)|buff.storm_earth_and_fire.up)
actions+=/call_action_list,name=st

actions.cd=invoke_xuen
actions.cd+=/use_item,name=tirathons_betrayal
actions.cd+=/blood_fury
actions.cd+=/berserking
actions.cd+=/touch_of_death,cycle_targets=1,max_cycle_targets=2,if=!artifact.gale_burst.enabled&equipped.137057&!prev_gcd.touch_of_death
actions.cd+=/touch_of_death,if=!artifact.gale_burst.enabled&!equipped.137057
actions.cd+=/touch_of_death,cycle_targets=1,max_cycle_targets=2,if=artifact.gale_burst.enabled&equipped.137057&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7&!prev_gcd.touch_of_death
actions.cd+=/touch_of_death,if=artifact.gale_burst.enabled&!equipped.137057&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7

actions.sef=energizing_elixir
actions.sef+=/arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
actions.sef+=/call_action_list,name=cd
actions.sef+=/storm_earth_and_fire
actions.sef+=/call_action_list,name=st

actions.serenity=energizing_elixir
actions.serenity+=/call_action_list,name=cd
actions.serenity+=/serenity
actions.serenity+=/strike_of_the_windlord
actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies<3
actions.serenity+=/fists_of_fury
actions.serenity+=/spinning_crane_kick,if=active_enemies>=3&!prev_gcd.spinning_crane_kick
actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies>=3
actions.serenity+=/blackout_kick,cycle_targets=1,if=!prev_gcd.blackout_kick
actions.serenity+=/spinning_crane_kick,if=!prev_gcd.spinning_crane_kick
actions.serenity+=/rushing_jade_wind,if=!prev_gcd.rushing_jade_wind

actions.st=call_action_list,name=cd
actions.st+=/arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
actions.st+=/energizing_elixir,if=energy<energy.max&chi<=1
actions.st+=/strike_of_the_windlord,if=talent.serenity.enabled|active_enemies<6
actions.st+=/fists_of_fury
actions.st+=/rising_sun_kick,cycle_targets=1
actions.st+=/whirling_dragon_punch
actions.st+=/spinning_crane_kick,if=active_enemies>=3&!prev_gcd.spinning_crane_kick
actions.st+=/rushing_jade_wind,if=chi.max-chi>1&!prev_gcd.rushing_jade_wind
actions.st+=/blackout_kick,cycle_targets=1,if=(chi>1|buff.bok_proc.up)&!prev_gcd.blackout_kick
actions.st+=/chi_wave,if=energy.time_to_max>=2.25
actions.st+=/chi_burst,if=energy.time_to_max>=2.25
actions.st+=/tiger_palm,cycle_targets=1,if=!prev_gcd.tiger_palm


]]--
