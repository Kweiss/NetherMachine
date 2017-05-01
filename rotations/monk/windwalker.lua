-- SPEC ID 269
-- talents=3010033
NetherMachine.rotation.register(269, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Get Fucked Button
  { "Touch of Death", "modifier.cooldowns" },

  { "Tiger's Lust", "player.state.snare" },
	{ "Tiger's Lust", "player.state.root" },

  -- Interrupts
  { "Spear Hand Strike", {"target.interruptAt(75)", "!modifier.last(Leg Sweep)" }},
  { "Leg Sweep", {"target.interruptAt(75)", "!modifier.last(Spear Hand Strike)", "target.range <= 5" }},
  { "Spear Hand Strike", {"focus.interruptAt(50)", "!modifier.last(Leg Sweep)" }, focus },

  -- Survival
  { "Touch of Karma", "player.health < 75" },
  { "Healing Elixir", "player.health < 80" },

  -- Talents
  { "Tiger's Lust", "target.range >= 15" },

  --DPS Time
  { "Fists of Fury", {"target.range <= 5", "!modifier.last(Storm, Earth, and Fire)" } },

  -- Cooldowns
  {{
    { "Arcane Torrent", {"player.chi < 6", "player.energy < 130"  }},
    { "Energizing Elixir", {"player.energy < 50", "player.chi <= 1" }}, --chi<=1&(cooldown.rising_sun_kick.remains=0|(artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains=0)|energy<50)
    { "Energizing Elixir", {"player.spell(Rising Sun Kick).cooldown < 1", "player.chi <= 1" }},
    { "Energizing Elixir", {"player.spell(Strike of the Windlord).cooldown < 1", "player.chi <= 1" }},
    { "Invoke Xuen, The White Tiger", },
    { "Storm, Earth, and Fire", {"player.spell(Strike of the Windlord).cooldown < 14", "player.spell(Fists of Fury).cooldown <= 9", "player.spell(Rising Sun Kick).cooldown <= 5" }},
    { "Strike of the Windlord", },
    { "Whirling Dragon Punch", },
    { "#trinket2", {"!player.buff(Storm, Earth, and Fire)", "!player.channeling", "player.energy < 60"}},
  },{
    "modifier.cooldowns", "target.exists", "target.range < 6", "!target.dead",
  } },

  -- Rotation
  { "Tiger Palm", { "player.chi < 4", "!modifier.last(Tiger Palm)", "player.energy > 133" }},
  { "Rising Sun Kick", },
  { "Rushing Jade Wind", {"!modifier.last(Rushing Jade Wind)", "player.chi > 1 " }},
  { "Chi Wave", "player.energy < 75 " },
  { "Chi Burst", "player.energy < 75 " },

  -- Multi-Target
  { "Spinning Crane Kick", {"modifier.multitarget", "!modifier.last(Spinning Crane Kick)" }},

  { "100784", {"player.chi > 1", "!modifier.last(100784)" }}, --Blackout Kick
  { "100784", {"player.buff(Blackout Kick!)", "!modifier.last(100784)" }},
  { "Tiger Palm", { "player.chi < 4", "!modifier.last(Tiger Palm)" }},

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
  { "Spear Hand Strike", {"target.interruptAt(70)", "!modifier.last(Leg Sweep)" }},
actions+=/potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
actions+=/call_action_list,name=serenity,if=(talent.serenity.enabled&cooldown.serenity.remains<=0)&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=15&cooldown.fists_of_fury.remains<8&cooldown.rising_sun_kick.remains<=4)|buff.serenity.up)
{{
  --actions.serenity=call_action_list,name=cd
  { "Touch of Death", "modifier.cooldowns"},
  --actions.serenity+=/serenity
  { "Serenity", "modifier.cooldowns"},
  --actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies<3
  { "Rising Sun Kick", },
  --actions.serenity+=/strike_of_the_windlord
  { "Strike of the Windlord", {"modifier.cooldowns", "target.range <= 8" } },
  --actions.serenity+=/fists_of_fury,if=(!equipped.drinking_horn_cover&(cooldown.rising_sun_kick.remains>1|active_enemies>1))|buff.serenity.remains<1
  { "Fists of Fury", {"target.range <= 8", "player.buff(serenity).duration < 2" } },
  --actions.serenity+=/spinning_crane_kick,if=active_enemies>=3&!prev_gcd.1.spinning_crane_kick
  {"Spinning Crane Kick", {"target.range < 7", "player.area(6).enemies >= 3", "!modifier.lastSpinning Crane Kick)"}}
  --actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies>=3
  --actions.serenity+=/spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick
  --actions.serenity+=/blackout_kick,cycle_targets=1,if=!prev_gcd.1.blackout_kick
  { "100784", {"player.chi > 1", "!modifier.last(100784)" }}, --Blackout Kick
  --actions.serenity+=/rushing_jade_wind,if=!prev_gcd.1.rushing_jade_wind
    { "Rushing Jade Wind", {"!modifier.last(Rushing Jade Wind)", "player.chi > 1 " }},
},{
    "talent(7,3)", "player.spell(Strike of the Windlord).cooldown <= 15", "player.spell(Fists of Fury).cooldown < 8", "player.spell(Rising Sun Kick).cooldown <=4"
} },
actions+=/call_action_list,name=sef,if=!talent.serenity.enabled&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=14&cooldown.fists_of_fury.remains<=6&cooldown.rising_sun_kick.remains<=6)|buff.storm_earth_and_fire.up)
actions+=/call_action_list,name=serenity,if=(talent.serenity.enabled&cooldown.serenity.remains<=0)&(!artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<14&cooldown.fists_of_fury.remains<=15&cooldown.rising_sun_kick.remains<7)|buff.serenity.up
actions+=/call_action_list,name=sef,if=!talent.serenity.enabled&((!artifact.strike_of_the_windlord.enabled&cooldown.fists_of_fury.remains<=9&cooldown.rising_sun_kick.remains<=5)|buff.storm_earth_and_fire.up)


actions+=/call_action_list,name=st
actions.cd=invoke_xuen
  { "Invoke Xuen, The White Tiger", "modifier.cooldowns" },
actions.cd+=/use_item,name=tirathons_betrayal
actions.cd+=/blood_fury
  { "Blood Fury" },
actions.cd+=/berserking
  { "Berserking" },
actions.cd+=/touch_of_death,cycle_targets=1,max_cycle_targets=2,if=!artifact.gale_burst.enabled&equipped.hidden_masters_forbidden_touch&!prev_gcd.1.touch_of_death
actions.cd+=/touch_of_death,if=!artifact.gale_burst.enabled&!equipped.hidden_masters_forbidden_touch
actions.cd+=/touch_of_death,cycle_targets=1,max_cycle_targets=2,if=artifact.gale_burst.enabled&((talent.serenity.enabled&cooldown.serenity.remains<=1)|chi>=2)&(cooldown.strike_of_the_windlord.remains<8|cooldown.fists_of_fury.remains<=4)&cooldown.rising_sun_kick.remains<7&!prev_gcd.1.touch_of_death
  { "Touch of Death", {"modifier.cooldowns", "player.chi >= 2", "player.spell(Strike of the Windlord).cooldown < 8", "player.spell(Rising Sun Kick).cooldown < 7", "!modifier.last(Touch of Death)" }},
  { "Touch of Death", {"modifier.cooldowns", "player.chi >= 2", "player.spell(Fists of Fury).cooldown <= 4", "player.spell(Rising Sun Kick).cooldown < 7", "!modifier.last(Touch of Death)" }},

actions.sef=tiger_palm,if=energy=energy.max&chi<1
  { "Tiger Palm", { "player.chi < 1", "!modifier.last(Tiger Palm)", "player.energy > 135" }},
actions.sef+=/arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
  { "Arcane Torrent", {"player.chi < 5", "player.timetomax >= .5"}},
actions.sef+=/call_action_list,name=cd



actions.sef+=/storm_earth_and_fire,if=!buff.storm_earth_and_fire.up



actions.sef+=/call_action_list,name=st

actions.serenity=call_action_list,name=cd
actions.serenity+=/serenity
actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies<3
actions.serenity+=/strike_of_the_windlord
actions.serenity+=/fists_of_fury,if=(!equipped.drinking_horn_cover&(cooldown.rising_sun_kick.remains>1|active_enemies>1))|buff.serenity.remains<1
actions.serenity+=/spinning_crane_kick,if=active_enemies>=3&!prev_gcd.1.spinning_crane_kick
actions.serenity+=/rising_sun_kick,cycle_targets=1,if=active_enemies>=3
actions.serenity+=/spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick
actions.serenity+=/blackout_kick,cycle_targets=1,if=!prev_gcd.1.blackout_kick
actions.serenity+=/rushing_jade_wind,if=!prev_gcd.1.rushing_jade_wind

actions.st=call_action_list,name=cd
actions.st+=/energizing_elixir,if=energy<energy.max&chi<=1
actions.st+=/arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
actions.st+=/tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm&energy=energy.max&chi<=3
actions.st+=/strike_of_the_windlord,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=10
actions.st+=/strike_of_the_windlord,if=!(equipped.convergence_of_fates&talent.serenity.enabled)
actions.st+=/rising_sun_kick,cycle_targets=1,if=(chi>=3&energy>=40)|chi=5
actions.st+=/fists_of_fury,if=equipped.convergence_of_fates&talent.serenity.enabled&!equipped.drinking_horn_cover&cooldown.serenity.remains>=5
actions.st+=/fists_of_fury,if=!(equipped.convergence_of_fates&talent.serenity.enabled&!equipped.drinking_horn_cover)
actions.st+=/rising_sun_kick,cycle_targets=1,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=2
actions.st+=/rising_sun_kick,cycle_targets=1,if=!(equipped.convergence_of_fates&talent.serenity.enabled)
actions.st+=/whirling_dragon_punch
actions.st+=/crackling_jade_lightning,if=equipped.the_emperors_capacitor&buff.the_emperors_capacitor.stack>=19&energy.time_to_max>3
actions.st+=/crackling_jade_lightning,if=equipped.the_emperors_capacitor&buff.the_emperors_capacitor.stack>=14&cooldown.serenity.remains<13&talent.serenity.enabled&energy.time_to_max>3
actions.st+=/spinning_crane_kick,if=(active_enemies>=3|spinning_crane_kick.count>=3)&!prev_gcd.1.spinning_crane_kick
actions.st+=/rushing_jade_wind,if=chi.max-chi>1&!prev_gcd.1.rushing_jade_wind
actions.st+=/blackout_kick,cycle_targets=1,if=(chi>1|buff.bok_proc.up)&!prev_gcd.1.blackout_kick
actions.st+=/chi_wave,if=energy.time_to_max>=2.25
actions.st+=/chi_burst,if=energy.time_to_max>=2.25
actions.st+=/tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm

]]--
