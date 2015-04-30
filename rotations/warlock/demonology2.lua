-- NetherMachine Rotation
-- Demonolody Warlock - WoD 6.0.3
-- Updated on Jan 23rd 2015

-- SUGGESTED TALENTS: 0000111
-- REQUIRED GLYPHS: dark_soul
-- CONTROLS: Pause - Left Control
NetherMachine.rotation.register_custom(266, "bbWarlock Demonology", {
  -- COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },
  { "pause", "target.istheplayer" },

  -- AUTO ATTACK
  { {
    { "Dark Intent", "@bbLib.engaugeUnit('ANY', 40, false)" },
  }, "toggle.autoattack" },

  -- AUTO TARGET
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- PET MANAGEMENT

  -- DEFENSIVE COOLDOWNS
  { "Exhilaration", "player.health < 40" },
  { "#5512", { "toggle.consume", "player.health < 35" } }, -- Healthstone (5512)
  { "#76097", { "toggle.consume", "player.health < 15", "target.boss" } }, -- Master Healing Potion (76097)
  { "#118916", { "toggle.consume", "player.health < 40", "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Healing Tonic

  -- Pre-DPS PAUSE
  { "pause", "target.debuff(Wyvern Sting).any" },
  { "pause", "target.debuff(Scatter Shot).any" },
  { "pause", "target.debuff(Freezing Trap).any" },
  { "pause", "target.debuff(Banish).any" },
  { "pause", "target.debuff(Seduction).any" },
  { "pause", "target.debuff(Mesmerize).any" },
  { "pause", "target.immune.all" },
  { "pause", "target.status.disorient" },
  { "pause", "target.status.incapacitate" },
  { "pause", "target.status.sleep" },





  -- actions=potion,name=draenic_intellect,if=buff.bloodlust.react|(buff.dark_soul.up&(trinket.proc.any.react|trinket.stacking_proc.any.react>6)&!buff.demonbolt.remains)|target.health.pct<20
  { "#118914", { "player.minimapzone(Brawl'gar Arena)" } }, -- Brawler's Bottomless Draenic Intellect Potion
  { "#109218", { "toggle.consume", "target.boss", "player.hashero" } }, -- Draenic Intellect Potion
  { "#109218", { "toggle.consume", "target.boss", "player.buff(Dark Soul)", "!player.buff(Demonbolt)" } }, -- Draenic Intellect Potion
  -- actions+=/berserking
  { "Berserking" },
  -- actions+=/blood_fury
  { "Blood Fury" },
  -- actions+=/arcane_torrent
  { "Arcane Torrent" },
  -- actions+=/mannoroths_fury
  { "Mannoroth's Fury" },
  -- actions+=/dark_soul,if=talent.demonbolt.enabled&(charges=2|target.time_to_die<buff.demonbolt.remains|(!buff.demonbolt.remains&demonic_fury>=790))
  -- actions+=/dark_soul,if=!talent.demonbolt.enabled&(charges=2|!talent.archimondes_darkness.enabled|(target.time_to_die<=20&!glyph.dark_soul.enabled|target.time_to_die<=10)|(target.time_to_die<=60&demonic_fury>400)|((trinket.stacking_proc.multistrike.remains>7.5|trinket.proc.any.remains>7.5)&demonic_fury>=400))
  -- actions+=/imp_swarm,if=(buff.dark_soul.up|(cooldown.dark_soul.remains>(120%(1%spell_haste)))|time_to_die<32)&time>3
  -- actions+=/felguard:felstorm
  -- actions+=/wrathguard:wrathstorm
  -- actions+=/hand_of_guldan,if=!in_flight&dot.shadowflame.remains<travel_time+action.shadow_bolt.cast_time&(((set_bonus.tier17_4pc=0&((charges=1&recharge_time<4)|charges=2))|(charges=3|(charges=2&recharge_time<13.8-travel_time*2))&(cooldown.cataclysm.remains>dot.shadowflame.duration|!talent.cataclysm.enabled)&cooldown.dark_soul.remains>dot.shadowflame.duration)|dot.shadowflame.remains>travel_time)
  -- actions+=/hand_of_guldan,if=!in_flight&dot.shadowflame.remains<travel_time+action.shadow_bolt.cast_time&talent.demonbolt.enabled&((set_bonus.tier17_4pc=0&((charges=1&recharge_time<4)|charges=2))|(charges=3|(charges=2&recharge_time<13.8-travel_time*2))|dot.shadowflame.remains>travel_time)
  -- actions+=/hand_of_guldan,if=!in_flight&dot.shadowflame.remains<travel_time+3&buff.demonbolt.remains<gcd*2&charges>=2&action.dark_soul.charges>=1
  -- actions+=/service_pet,if=talent.grimoire_of_service.enabled
  -- actions+=/summon_doomguard,if=!talent.demonic_servitude.enabled&active_enemies<5
  -- actions+=/summon_infernal,if=!talent.demonic_servitude.enabled&active_enemies>=5

  --{ {

    -- actions.db=immolation_aura,if=demonic_fury>450&active_enemies>=5&buff.immolation_aura.down
    -- actions.db+=/doom,cycle_targets=1,if=buff.metamorphosis.up&active_enemies>=6&target.time_to_die>=30*spell_haste&remains<=(duration*0.3)&(buff.dark_soul.down|!glyph.dark_soul.enabled)
    -- actions.db+=/kiljaedens_cunning,moving=1,if=buff.demonbolt.stack=0|(buff.demonbolt.stack<4&buff.demonbolt.remains>=(40*spell_haste-execute_time))
    -- actions.db+=/demonbolt,if=buff.demonbolt.stack=0|(buff.demonbolt.stack<4&buff.demonbolt.remains>=(40*spell_haste-execute_time))
    -- actions.db+=/doom,cycle_targets=1,if=buff.metamorphosis.up&target.time_to_die>=30*spell_haste&remains<=(duration*0.3)&(buff.dark_soul.down|!glyph.dark_soul.enabled)
    -- actions.db+=/corruption,cycle_targets=1,if=target.time_to_die>=6&remains<=(0.3*duration)&buff.metamorphosis.down
    -- actions.db+=/cancel_metamorphosis,if=buff.metamorphosis.up&buff.demonbolt.stack>3&demonic_fury<=600&target.time_to_die>buff.demonbolt.remains&buff.dark_soul.down
    -- actions.db+=/chaos_wave,if=buff.metamorphosis.up&buff.dark_soul.up&active_enemies>=3&demonic_fury>450
    -- actions.db+=/soul_fire,if=buff.metamorphosis.up&buff.molten_core.react&(((buff.dark_soul.remains>execute_time)&demonic_fury>=175)|(target.time_to_die<buff.demonbolt.remains))
    -- actions.db+=/soul_fire,if=buff.metamorphosis.up&buff.molten_core.react&target.health.pct<=25&(((demonic_fury-80)%800)>(buff.demonbolt.remains%(40*spell_haste)))&demonic_fury>=750
    -- actions.db+=/touch_of_chaos,cycle_targets=1,if=buff.metamorphosis.up&dot.corruption.remains<17.4&demonic_fury>750
    -- actions.db+=/touch_of_chaos,if=buff.metamorphosis.up&(target.time_to_die<buff.demonbolt.remains|demonic_fury>=750&buff.demonbolt.remains)
    -- actions.db+=/touch_of_chaos,if=buff.metamorphosis.up&(((demonic_fury-40)%800)>(buff.demonbolt.remains%(40*spell_haste)))&demonic_fury>=750
    -- actions.db+=/metamorphosis,if=buff.dark_soul.remains>gcd&demonic_fury>=240&(buff.demonbolt.down|target.time_to_die<buff.demonbolt.remains|(buff.dark_soul.remains>execute_time&demonic_fury>=175))
    -- actions.db+=/metamorphosis,if=buff.demonbolt.down&demonic_fury>=480&(action.dark_soul.charges=0|!talent.archimondes_darkness.enabled&cooldown.dark_soul.remains)
    -- actions.db+=/metamorphosis,if=(demonic_fury%80)*2*spell_haste>=target.time_to_die&target.time_to_die<buff.demonbolt.remains
    -- actions.db+=/metamorphosis,if=target.time_to_die>=30*spell_haste&!dot.doom.ticking&buff.dark_soul.down
    -- actions.db+=/metamorphosis,if=demonic_fury>750&buff.demonbolt.remains>=action.metamorphosis.cooldown
    -- actions.db+=/metamorphosis,if=(((demonic_fury-120)%800)>(buff.demonbolt.remains%(40*spell_haste)))&buff.demonbolt.remains>=10&dot.doom.remains<=dot.doom.duration*0.3
    -- actions.db+=/cancel_metamorphosis
    -- actions.db+=/hellfire,interrupt=1,if=active_enemies>=5
    -- actions.db+=/soul_fire,if=buff.molten_core.react&(buff.dark_soul.remains<action.shadow_bolt.cast_time|buff.dark_soul.remains>cast_time)
    -- actions.db+=/life_tap,if=mana.pct<40
    -- actions.db+=/hellfire,interrupt=1,if=active_enemies>=4
    -- actions.db+=/shadow_bolt
    -- actions.db+=/hellfire,moving=1,interrupt=1
    -- actions.db+=/life_tap
  --}, "talent(7, 1)" }, -- actions+=/call_action_list,name=db,if=talent.demonbolt.enabled

  -- actions+=/kiljaedens_cunning,if=!cooldown.cataclysm.remains&buff.metamorphosis.up
  -- actions+=/cataclysm,if=buff.metamorphosis.up
  -- actions+=/immolation_aura,if=demonic_fury>450&active_enemies>=3&buff.immolation_aura.down
  -- actions+=/doom,if=buff.metamorphosis.up&target.time_to_die>=30*spell_haste&remains<=(duration*0.3)&(remains<cooldown.cataclysm.remains|!talent.cataclysm.enabled)&(buff.dark_soul.down|!glyph.dark_soul.enabled)&trinket.stacking_proc.multistrike.react<10
  -- actions+=/corruption,cycle_targets=1,if=target.time_to_die>=6&remains<=(0.3*duration)&buff.metamorphosis.down
  -- actions+=/cancel_metamorphosis,if=buff.metamorphosis.up&((demonic_fury<650&!glyph.dark_soul.enabled)|demonic_fury<450)&buff.dark_soul.down&(trinket.stacking_proc.multistrike.down&trinket.proc.any.down|demonic_fury<(800-cooldown.dark_soul.remains*(10%spell_haste)))&target.time_to_die>20
  -- actions+=/cancel_metamorphosis,if=buff.metamorphosis.up&action.hand_of_guldan.charges>0&dot.shadowflame.remains<action.hand_of_guldan.travel_time+action.shadow_bolt.cast_time&demonic_fury<100&buff.dark_soul.remains>10
  -- actions+=/cancel_metamorphosis,if=buff.metamorphosis.up&action.hand_of_guldan.charges=3&(!buff.dark_soul.remains>gcd|action.metamorphosis.cooldown<gcd)
  -- actions+=/chaos_wave,if=buff.metamorphosis.up&(buff.dark_soul.up&active_enemies>=3|(charges=3|set_bonus.tier17_4pc=0&charges=2))
  -- actions+=/soul_fire,if=buff.metamorphosis.up&buff.molten_core.react&(buff.dark_soul.remains>execute_time|target.health.pct<=25)&(((buff.molten_core.stack*execute_time>=trinket.stacking_proc.multistrike.remains-1|demonic_fury<=ceil((trinket.stacking_proc.multistrike.remains-buff.molten_core.stack*execute_time)*40)+80*buff.molten_core.stack)|target.health.pct<=25)&trinket.stacking_proc.multistrike.remains>=execute_time|trinket.stacking_proc.multistrike.down|!trinket.has_stacking_proc.multistrike)
  -- actions+=/touch_of_chaos,cycle_targets=1,if=buff.metamorphosis.up&dot.corruption.remains<17.4&demonic_fury>750
  -- actions+=/touch_of_chaos,if=buff.metamorphosis.up
  -- actions+=/metamorphosis,if=buff.dark_soul.remains>gcd&(demonic_fury>300|!glyph.dark_soul.enabled)&(demonic_fury>=80&buff.molten_core.stack>=1|demonic_fury>=40)
  -- actions+=/metamorphosis,if=(trinket.stacking_proc.multistrike.react|trinket.proc.any.react)&((demonic_fury>450&action.dark_soul.recharge_time>=10&glyph.dark_soul.enabled)|(demonic_fury>650&cooldown.dark_soul.remains>=10))
  -- actions+=/metamorphosis,if=!cooldown.cataclysm.remains&talent.cataclysm.enabled
  -- actions+=/metamorphosis,if=!dot.doom.ticking&target.time_to_die>=30%(1%spell_haste)&demonic_fury>300
  -- actions+=/metamorphosis,if=(demonic_fury>750&(action.hand_of_guldan.charges=0|(!dot.shadowflame.ticking&!action.hand_of_guldan.in_flight_to_target)))|floor(demonic_fury%80)*action.soul_fire.execute_time>=target.time_to_die
  -- actions+=/metamorphosis,if=demonic_fury>=950
  -- actions+=/cancel_metamorphosis
  -- actions+=/hellfire,interrupt=1,if=active_enemies>=5
  -- actions+=/soul_fire,if=buff.molten_core.react&(buff.molten_core.stack>=7|target.health.pct<=25|(buff.dark_soul.remains&cooldown.metamorphosis.remains>buff.dark_soul.remains)|trinket.proc.any.remains>execute_time|trinket.stacking_proc.multistrike.remains>execute_time)&(buff.dark_soul.remains<action.shadow_bolt.cast_time|buff.dark_soul.remains>execute_time)
  -- actions+=/soul_fire,if=buff.molten_core.react&target.time_to_die<(time+target.time_to_die)*0.25+cooldown.dark_soul.remains
  -- actions+=/life_tap,if=mana.pct<40
  -- actions+=/hellfire,interrupt=1,if=active_enemies>=4
  -- actions+=/shadow_bolt
  -- actions+=/hellfire,moving=1,interrupt=1
  -- actions+=/life_tap



  -- Cooldowns
  { "Summon Doomguard", "modifier.cooldowns" },

  -- Rotation
  { "Command Demon", "pet.energy > 60" },

  -- Metamorphosis Rotation
  { {
    { "Immolation Aura", "modifier.multitarget" },
    { "Dark Soul: Knowledge", "modifier.cooldowns" },
    { "Corruption", "target.debuff(Doom).duration < 10" },
    { "Soul Fire", "player.buff(Molten Core)" },
    { "/cancelaura Metamorphosis", { "player.demonicfury < 700", "!player.buff(Dark Soul: Knowledge)" } },
    { "Void Ray", "modifier.multitarget" },
    { "Shadow Bolt" },
  }, "player.buff(Metamorphosis)" },

  -- Regular Rotation (w/o Meta)
  { {
    { "Life Tap", { "player.mana < 40", "player.health > 70" } },
    { "Corruption", "!target.debuff(Corruption)" },
    { "Metamorphosis", "player.demonicfury > 900" },
    { "Hand of Gul'dan", "!target.debuff(Shadowflame)" },
    { "Soul Fire", "player.buff(Molten Core)" },
    { "Harvest Life", "modifier.multitarget" },
    { "Shadow Bolt" }
  }, "!player.buff(Metamorphosis)" },

},{
-- OUT OF COMBAT ROTATION
  -- PAUSES
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

-- PET MANAGEMENT
-- { "883", { "!talent(7, 3)", "!pet.exists", "!modifier.last" } }, -- Call Pet 1
-- { "Mend Pet", { "pet.exists", "pet.alive", "pet.health < 70", "pet.distance < 45", "!pet.buff(Mend Pet)", "!modifier.last" } },
-- { "Revive Pet", { "pet.exists", "pet.dead", "!player.moving", "pet.distance < 45", "!modifier.last" } },

  -- BUFFS
  { "Dark Intent", { "!player.buffs.spellpower", "!player.buff(Dark Intent)", "!modifier.last" } },

  -- AUTO ATTACK
  { {
    { "Dark Intent", "@bbLib.engaugeUnit('ANY', 40, false)" },
    { "Corruption", { "target.exists", "target.enemy", "!target.debuff(Corruption)" } },
  }, "toggle.autoattack" },

  -- PRE COMBAT
  -- actions.precombat=flask,type=greater_draenic_intellect_flask
  -- actions.precombat+=/food,type=sleeper_surprise
  -- actions.precombat+=/dark_intent,if=!aura.spell_power_multiplier.up
  -- actions.precombat+=/summon_pet,if=!talent.demonic_servitude.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.grimoire_of_sacrifice.down)
  -- actions.precombat+=/summon_doomguard,if=talent.demonic_servitude.enabled&active_enemies<5
  -- actions.precombat+=/summon_infernal,if=talent.demonic_servitude.enabled&active_enemies>=5
  -- actions.precombat+=/snapshot_stats
  -- actions.precombat+=/service_pet,if=talent.grimoire_of_service.enabled
  -- actions.precombat+=/potion,name=draenic_intellect
  -- actions.precombat+=/soul_fire

},function()
  NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_hunter_quickshot', 'Use Mouseovers', 'Toggle automatic usage of stings/scatter/etc on eligible mouseover targets.')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automatically target and attack any enemy units in range.')
end)
