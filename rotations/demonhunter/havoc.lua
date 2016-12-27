--   SPEC ID 577
NetherMachine.rotation.register_custom(577, '|cff69ACC8Havoc 7.1|r',{


	{ "Blur", { "!player.buff(Blur)", "!modifier.last", "player.health <= 40" } },

	{ "Fel Rush", "modifier.shift" },
	{ "Demon's Bite", { "player.fury < 50", "player.spell(Throw Glaive).cooldown > 0"}},
	{ "Chaos Strike" , "!modifier.multitarget"},
	{ "Eye Beam", "modifier.multitarget"},
	{ "Throw Glaive" },
	--   { "Wilde Strike",   { "!modifier.multitarget","player.rage > 90"												 }},


	{ "Consume Magic", "modifier.interrupts"									},
	{ "Annihilation",{"player.buff(Metamorphosis)", "!modifier.multitarget"	}},
	{ "Death Sweep", {"player.buff(Metamorphosis)", "modifier.multitarget"	}},
	{ "Throw Glaive" 													  	},
	{ "Metamorphosis", "modifier.cooldowns", "ground"									},
	{ "Demon's Bite", "player.fury < 50"										},

	{ "Blade Dance", {"player.spell(Eye Beam).cooldown > 5","modifier.multitarget" }},
	{ "Chaos Strike" , "!modifier.multitarget"								},
	{ "Chaos Strike" , { "player.spell(Eye Beam).cooldown > 3", "modifier.multitarget", "player.spell(Blade Dance).cooldown > 2"} },
	{ "Eye Beam", "modifier.multitarget"										},
	{ "Demon's Bite", "player.spell(Blade Dance).cooldown > 2"				},
	{ "Demon's Bite", "player.spell(Death Sweep).cooldown > 2"				},

},
{
  -- Out of Combat Buffing Buffing



}, function()
	-- "toggle.custom_toggle_name"
end)

--[[

# Executed every time the actor is available.
actions=auto_attack
# "Getting ready to use meta" conditions, this is used in a few places.
actions+=/variable,name=pooling_for_meta,value=cooldown.metamorphosis.ready&buff.metamorphosis.down&(!talent.demonic.enabled|!cooldown.eye_beam.ready)&(!talent.chaos_blades.enabled|cooldown.chaos_blades.ready)&(!talent.nemesis.enabled|debuff.nemesis.up|cooldown.nemesis.ready)

# Blade Dance conditions. Always if First Blood is talented, otherwise 3+ targets with Chaos Cleave or 2+ targets without.
actions+=/variable,name=blade_dance,value=talent.first_blood.enabled|spell_targets.blade_dance1>=2+talent.chaos_cleave.enabled

# Blade Dance pooling condition, so we don't spend too much fury when we need it soon. No need to pool on
# single target since First Blood already makes it cheap enough and delaying it a tiny bit isn't a big deal.
actions+=/variable,name=pooling_for_blade_dance,value=variable.blade_dance&fury-40<35-talent.first_blood.enabled*20&spell_targets.blade_dance1>=2

actions+=/blur,if=artifact.demon_speed.enabled&cooldown.fel_rush.charges_fractional<0.5&cooldown.vengeful_retreat.remains-buff.momentum.remains>4
actions+=/call_action_list,name=cooldown

# Fel Rush in at the start of combat.
actions+=/fel_rush,animation_cancel=1,if=time=0
actions+=/pick_up_fragment,if=talent.demonic_appetite.enabled&fury.deficit>=30
actions+=/consume_magic

# Vengeful Retreat backwards through the target to minimize downtime.
actions+=/vengeful_retreat,if=(talent.prepared.enabled|talent.momentum.enabled)&buff.prepared.down&buff.momentum.down

# Fel Rush for Momentum and for fury from Fel Mastery.
actions+=/fel_rush,animation_cancel=1,if=(talent.momentum.enabled|talent.fel_mastery.enabled)&(!talent.momentum.enabled|(charges=2|cooldown.vengeful_retreat.remains>4)&buff.momentum.down)&(!talent.fel_mastery.enabled|fury.deficit>=25)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))

# Use Fel Barrage at max charges, saving it for Momentum and adds if possible.
actions+=/fel_barrage,if=charges>=5&(buff.momentum.up|!talent.momentum.enabled)&(active_enemies>desired_targets|raid_event.adds.in>30)
actions+=/throw_glaive,if=talent.bloodlet.enabled&(!talent.momentum.enabled|buff.momentum.up)&charges=2
actions+=/fury_of_the_illidari,if=active_enemies>desired_targets|raid_event.adds.in>55&(!talent.momentum.enabled|buff.momentum.up)
actions+=/eye_beam,if=talent.demonic.enabled&buff.metamorphosis.down&fury.deficit<30
actions+=/death_sweep,if=variable.blade_dance
actions+=/blade_dance,if=variable.blade_dance
actions+=/throw_glaive,if=talent.bloodlet.enabled&spell_targets>=2+talent.chaos_cleave.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&(spell_targets>=3|raid_event.adds.in>recharge_time+cooldown)
actions+=/fel_eruption
actions+=/felblade,if=fury.deficit>=30+buff.prepared.up*8
actions+=/annihilation,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance
actions+=/throw_glaive,if=talent.bloodlet.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&raid_event.adds.in>recharge_time+cooldown
actions+=/eye_beam,if=!talent.demonic.enabled&((spell_targets.eye_beam_tick>desired_targets&active_enemies>1)|(raid_event.adds.in>45&!variable.pooling_for_meta&buff.metamorphosis.down&(artifact.anguish_of_the_deceiver.enabled|active_enemies>1)))
#
 If Demonic is talented, pool fury as Eye Beam is coming off cooldown.
actions+=/demons_bite,if=talent.demonic.enabled&buff.metamorphosis.down&cooldown.eye_beam.remains<gcd&fury.deficit>=20
actions+=/demons_bite,if=talent.demonic.enabled&buff.metamorphosis.down&cooldown.eye_beam.remains<2*gcd&fury.deficit>=45
actions+=/throw_glaive,if=buff.metamorphosis.down&spell_targets>=2
actions+=/chaos_strike,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance&(!talent.demonic.enabled|!cooldown.eye_beam.ready)

# Use Fel Barrage if its nearing max charges, saving it for Momentum and adds if possible.
actions+=/fel_barrage,if=charges=4&buff.metamorphosis.down&(buff.momentum.up|!talent.momentum.enabled)&(active_enemies>desired_targets|raid_event.adds.in>30)
actions+=/fel_rush,animation_cancel=1,if=!talent.momentum.enabled&raid_event.movement.in>charges*10
actions+=/demons_bite
actions+=/throw_glaive,if=buff.out_of_range.up|buff.raid_movement.up
actions+=/felblade,if=movement.distance|buff.out_of_range.up
actions+=/fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
actions+=/vengeful_retreat,if=movement.distance>15
actions+=/throw_glaive,if=talent.felblade.enabled

actions.cooldown=nemesis,target_if=min:target.time_to_die,if=raid_event.adds.exists&debuff.nemesis.down&(active_enemies>desired_targets|raid_event.adds.in>60)
actions.cooldown+=/nemesis,if=!raid_event.adds.exists&(cooldown.metamorphosis.remains>100|target.time_to_die<70)
actions.cooldown+=/nemesis,sync=metamorphosis,if=!raid_event.adds.exists
actions.cooldown+=/chaos_blades,if=buff.metamorphosis.up|cooldown.metamorphosis.remains>100|target.time_to_die<20
actions.cooldown+=/metamorphosis,if=variable.pooling_for_meta&fury.deficit<30&(talent.chaos_blades.enabled|!cooldown.fury_of_the_illidari.ready)
actions.cooldown+=/potion,name=old_war,if=buff.metamorphosis.remains>25|target.time_to_die<30

]]--
