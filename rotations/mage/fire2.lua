-- SPEC ID 63
NetherMachine.rotation.register_custom(63, "bbFireMage", {
-- PLAYER CONTROLLED: Temporal Shield, Blizzard, Blink, Frost Bomb
-- SUGGESTED TALENTS:
-- CONTROLS: Pause - Left Control

-- COMBAT
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "player.buff(Food)" },
	{ "pause", "modifier.looting" },
	{ "pause", "target.buff(Reckless Provocation)" }, -- Iron Docks - Fleshrender
	{ "pause", "target.buff(Sanguine Sphere)" }, -- Iron Docks - Enforcers

	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- Racials
	{ "Stoneform", "player.health <= 65" },
	{ "Every Man for Himself", "player.state.charm" },
	{ "Every Man for Himself", "player.state.fear" },
	{ "Every Man for Himself", "player.state.incapacitate" },
	{ "Every Man for Himself", "player.state.sleep" },
	{ "Every Man for Himself", "player.state.stun" },
	{ "Gift of the Naaru", "player.health <= 70", "player" },
	{ "Escape Artist", "player.state.root" },
	{ "Escape Artist", "player.state.snare" },
	{ "Shadowmeld", "target.threat >= 80" },
	{ "Shadowmeld", "focus.threat >= 80"},
	{ "Will of the Forsaken", "player.state.fear" },
	{ "Will of the Forsaken", "player.state.charm" },
	{ "Will of the Forsaken", "player.state.sleep" },
	{ "Quaking Palm", "modifier.interrupts" },

	-- Survival
	{ "Ice Block", { "modifier.cooldowns", "player.health <= 20" } },
	{ "Cold Snap", { "modifier.cooldowns", "player.health <= 15", "player.spell(45438).cooldown" } },
	{ "Ice Barrier", { "!player.buff(110909)", "!player.buff", "player.spell(11426).exists" }, "player" },
	{ "Frost Nova", { "!target.boss", "target.threat > 80", "target.range <= 9" } },

	-- Interrupts
	{ "Counterspell", "modifier.interrupts" },
	{ "Frostjaw", "modifier.interrupts" },

	-- Pre DPS Cooldowns
	{ "#36799", { "@bbLib.useManaGem", "player.mana < 70" } }, -- Mana Gem
	{ "Dragon's Breath", { "target.enemy", "target.range <= 5" } },

	--  DPS Rotation
	{ "Time Warp", { "modifier.cooldowns", "target.boss", "target.health < 25", "player.time > 5" } },
	{ "Evocation", { "player.spell(Invocation).exists", "!player.buff(Invoker's Energy)", "target.debuff(Living Bomb).duration > 3" } },
	{ "Berserking", { "modifier.cooldowns", "target.exists", "target.boss", "!player.buff(Alter Time)", "target.deathin < 18" } },
	{ "#114757", { "modifier.cooldowns", "@bbLib.useIntPot", "player.hashero", "target.exists", "!player.buff(Alter Time)", "target.deathin < 45" } }, -- Jade Serpent Potion
	{ "Mirror Image", { "modifier.cooldowns", "target.boss" } },
	{ "Combustion",  { "modifier.cooldowns", "target.boss", "target.deathin < 22" } },
	--{ "11129",  "target.debuff(12654)" }, -- Combustion
	-- combustion,if=dot.ignite.tick_dmg>=((3*action.pyroblast.crit_damage)*mastery_value*0.5)
	-- combustion,if=dot.ignite.tick_dmg>=((action.fireball.crit_damage+action.inferno_blast.crit_damage+action.pyroblast.hit_damage)*mastery_value*0.5)&dot.pyroblast.ticking&buff.alter_time.down&buff.pyroblast.down&buff.presence_of_mind.down
	{ "Berserking", { "modifier.cooldowns", "target.exists", "!player.buff(Alter Time)", "player.spell(Alter Time).cooldown == 0" } },
	{ "Presence of Mind", { "target.exists", "!player.buff(Alter Time)", "player.spell(Alter Time).cooldown == 0" } },
	{ "#114757", { "modifier.cooldowns", "@bbLib.useIntPot", "target.exists", "target.boss", "!player.buff(Alter Time)", "player.spell(Alter Time).cooldown == 0" } }, -- Jade Serpent Potion
	{ "#gloves", { "modifier.cooldowns", "target.exists", "target.boss", "player.spell(Alter Time).cooldown == 0" } },
	{ "Alter Time", { "modifier.cooldowns", "player.spell(Mirror Image).cooldown <= 180", "!player.buff(Alter Time)", "player.buff(48108)" } }, -- if > 180sec till lust at 25%
	{ "#gloves", { "modifier.cooldowns", "target.exists", "target.boss", "player.spell(Alter Time).cooldown > 40" } },
	{ "#gloves", { "modifier.cooldowns", "target.exists", "target.boss", "target.deathin < 12" } },
	{ "Presence of Mind", { "target.exists", "player.spell(Alter Time).cooldown > 60" } },
	{ "Presence of Mind", { "target.exists", "target.deathin < 5" } },
	{ "Flamestrike", { "modifier.multitarget", "modifier.enemies > 4" }, "ground" }, -- AOE
	{ "Inferno Blast", { "target.debuff(Combustion)", "modifier.enemies > 1" } }, --AOE
	{ "Pyroblast", "player.buff(48108)" },
	{ "Pyroblast", "player.buff(Presence of Mind)" },
	{ "Inferno Blast", { "player.buff(Heating Up)", "!player.buff(48108)" } },
	{ "Living Bomb", "target.debuff(Living Bomb).duration < 3" }, -- TODO: CYCLE TARGETS
	{ "Living Bomb", { "toggle.mouseovers", "!mouseover.debuff(Living Bomb)" }, "mouseover" },
	{ "Nether Tempest", "target.debuff(Nether Tempest).duration < 3" }, -- TODO: CYCLE TARGETS
	{ "Nether Tempest", { "toggle.mouseovers", "!mouseover.debuff(Nether Tempest)", "mouseover.deathin > 9" }, "mouseover" },
	{ "Scorch", "player.moving" },
	{ "Fireball", "!player.moving" },

	-- PRE COMBAT
	-- flask,type=warm_sun
  -- food,type=mogu_fish_stew
  -- arcane_brilliance
  -- snapshot_stats
  -- rune_of_power
  -- mirror_image
  -- potion,name=jade_serpent
  -- pyroblast

	-- COMBUST_SEQUENCE
	-- stop_pyro_chain,if=cooldown.combustion.duration-cooldown.combustion.remains<15
	-- prismatic_crystal
	-- blood_fury
	-- berserking
	-- arcane_torrent
	-- potion,name=jade_serpent
	-- meteor
	-- pyroblast,if=set_bonus.tier17_4pc&buff.pyromaniac.up
	-- inferno_blast,if=set_bonus.tier16_4pc_caster&(buff.pyroblast.up^buff.heating_up.up)
	-- fireball,if=!dot.ignite.ticking&!in_flight
	-- pyroblast,if=buff.pyroblast.up
	-- inferno_blast,if=talent.meteor.enabled&cooldown.meteor.duration-cooldown.meteor.remains<gcd.max*3
  -- combustion

	-- INIT_COMBUST
	-- start_pyro_chain,if=talent.meteor.enabled&cooldown.meteor.up&((cooldown.combustion.remains<gcd.max*3&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
	-- start_pyro_chain,if=talent.prismatic_crystal.enabled&cooldown.prismatic_crystal.up&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
	-- start_pyro_chain,if=talent.prismatic_crystal.enabled&!glyph.combustion.enabled&cooldown.prismatic_crystal.remains>20&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
	-- start_pyro_chain,if=!talent.prismatic_crystal.enabled&!talent.meteor.enabled&((cooldown.combustion.remains<gcd.max*4&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*(gcd.max+talent.kindling.enabled)))

	-- SINGLE_TARGET
	-- inferno_blast,if=(dot.combustion.ticking&active_dot.combustion<active_enemies)|(dot.living_bomb.ticking&active_dot.living_bomb<active_enemies)
	-- pyroblast,if=buff.pyroblast.up&buff.pyroblast.remains<action.fireball.execute_time
	-- pyroblast,if=set_bonus.tier16_2pc_caster&buff.pyroblast.up&buff.potent_flames.up&buff.potent_flames.remains<gcd.max
	-- pyroblast,if=set_bonus.tier17_4pc&buff.pyromaniac.react
	-- pyroblast,if=buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight
	-- inferno_blast,if=buff.pyroblast.down&buff.heating_up.up
	-- call_action_list,name=active_talents
	-- inferno_blast,if=buff.pyroblast.up&buff.heating_up.down&!action.fireball.in_flight
	-- fireball
	-- scorch,moving=1

},{
	-- OUT OF COMBAT
	{ "Arcane Brilliance", "!player.buff" },
	{ "Molten Armor", "!player.buff" },
	{ "Conjure Mana Gem", { "!player.moving", "@bbLib.conjureManaGem" } },

	-- TODO: Opener Toggle
	-- flask,type=warm_sun
	-- food,type=mogu_fish_stew
	-- arcane_brilliance
	-- molten_armor
	-- rune_of_power
	-- jade_serpent_potion
	-- mirror_image
	-- evocation
},
function()
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP Mode', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\ability_mage_livingbomb', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
end)










---------------------------
--   Macks Pyromania    --
---------------------------

NetherMachine.rotation.register_custom(63, "bbMage Fire (Experimental)", {


-- Pause for Invis
--blastwave target.enemy and exitst
---------------------------
--       MODIFIERS       --
---------------------------
--{ "Ring of Frost", "modifier.lalt", "ground" },
{ "1459", "!player.buffs.spellpower" }, --spellpower
{ "1459", "!player.buffs.crit" }, --scrit
{"Rune of Power",{"!player.moving","modifier.rcontrol"},"mouseover.ground"},
{"Amplify Magic",{"modifier.lalt"},},
{"!Ice Block",{"modifier.lshift","!player.spell(157913).exists"}},
{"!157913",{"modifier.lshift","player.spell(157913).exists"}},
{"Alter Time",{"modifer.rshift","player.spell(Alter Time).exists"}},
{"!Combustion",  {"modifier.lcontrol","player.spell(Pyroblast).casted >= 1"}, "target"},
---------------------------
--     SURVIVAL/misc     --
---------------------------
{"#5512", "player.health <= 40" },  --healthstone
{"!Cold Snap",{"player.health < 25","player.spell(Cold Snap).exists"},"player"},
{"Ice Floes",{"player.moving", "!player.buff(108839)", "!lastcast(Ice Floes)", "player.spell(Ice Floes).exists"},"player"},
{"Ice Barrier",{"player.health <= 80", "!player.buff(Ice Barrier)", "player.spell(Ice Barrier).exists"},"player"},
{"!Ice Block",{"!player.spell(157913).exists","player.health <= 15"},"player"},
{"!157913",{"player.spell(157913).exists","player.health <= 15"},"player"},--evanesce
{"!Greater Invisibility",{"player.spell(110959).exists","player.health <= 15"},"player"},

---------------------------
--INTERRUPT & SPELLSTEAL--
---------------------------
-- Interrupts
{ "Counterspell", "modifier.interrupts" },
{"!Inferno Blast",{"player.buff(Heating Up)", "!player.buff(Pyroblast!)","lastcast(Pyroblast)","player.spell(Pyroblast).casted >= 1","target.range <= 40"}, "target" },


---------------------------
--  MI/RoP & METEOR/PC   --
---------------------------

{"Mirror Image", "modifier.cooldowns" },
{"Rune of Power",{"!player.buff(Rune of Power)", "!player.moving", },"player.ground"},

--Meteor combustion setup
{"Meteor",{"target.enemy","player.buff(Heating Up)","player.buff(Pyroblast!)","modifier.cooldowns"},"target.ground"},
{"Fireball",{"lastcast(Meteor)", "!player.moving"},"target"},
{"Pyroblast",{"lastcast(Fireball)", "player.buff(Pyroblast!)","player.spell(Meteor).cooldown > 40"},"target"},
{"Pyroblast",{"lastcast(Meteor)", "player.buff(Pyroblast!)","player.spell(Meteor).cooldown > 40"},"target"},

--PC rotationn
{"Prismatic Crystal",{"target.enemy","player.buff(Heating Up)","player.buff(Pyroblast!)","modifier.cooldowns"},"target.ground"},
{"Fireball",{"lastcast(Prismatic Crystal)", "!player.moving"},"target"},
{"Pyroblast",{"lastcast(Fireball)", "player.buff(Pyroblast!)","player.spell(Prismatic Crystal).cooldown > 80"},"target"},
{"Pyroblast",{"lastcast(Prismatic Crystal)", "player.buff(Pyroblast!)","player.spell(Prismatic Crystal).cooldown > 80"},"target"},
{"Inferno Blast",{"lastcast(Combustion)","player.spell(Combustion).casted >= 1","player.spell(Prismatic Crystal).cooldown > 80"}, "target" },
{"Pyroblast",{"player.totem(Prismatic Crystal)", "player.buff(Pyroblast!)"},"target"},




---------------------------
-- PRYOBLAST MANAGEMENT --
---------------------------
--Tier 17
{ "!Pyroblast", { "player.buff(Pyromanic)" }, "target" },
--Chain pryos together
{ "Pyroblast", { "lastcast(Pyroblast)","player.buff(Pyroblast!)" }, "target" },
-- Dont wanna lose our Buff (Bad RNG protection)
{ "!Pyroblast", { "player.buff(Pyroblast!).duration < 3", "!player.buff(Pyroblast!).duration == 0" },"target" },


--Cast an extra Fireball before Your Pyros for additional chance for crit (as per Icy Veins Pyro trick)
{"Fireball",{"!player.moving", "player.buff(Heating Up).duration >= 9", "player.buff(Pyroblast!)","!toggle.Trashmode"},"target"},
--Otherwise we wait until we have both Heatingup and Pyro
{ "Pyroblast", { "player.buff(Heating Up)", "player.buff(Pyroblast!)","!toggle.Trashmode" }, "target"},
--Dont bother if its Trash
{ "Pyroblast", { "player.buff(Pyroblast!)","toggle.Trashmode" }, "target"},

--Proc pryo from heating up
{"Inferno Blast",{"player.buff(Heating Up)", "!player.buff(Pyroblast!)"}, "target" },



---------------------------
--    AUTO COMBUSTION    --
---------------------------

{"Combustion",{"target.debuff(Pyroblast)","target.debuff(155158)","target.debuff(Ignite)","talent(7,3)", "player.spell(Pyroblast).casted >= 1"},"target"},
{"Combustion",{"!player.buff(Pyroblast!)","target.debuff(Ignite)","talent(7,2)", "player.spell(Pyroblast).casted >= 3"},"target"},

{"Inferno Blast",{"lastcast(Combustion)","modifier.multitarget", "!lastcast(Inferno Blast)"}, "target" },

--"toggle.AutoCombust"

---------------------------
--    DoT/Blast Wave     --
---------------------------

{"Living Bomb", {"!target.debuff(Living Bomb)", "talent(5,1)" },"target" }, --Living Bomb

{{  -- Casts when Meteor is on CD. For opener purposes.
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(116267).count >= 4" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(Rune of Power)" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "talent(6,1)" },"target" },
},{"toggle.UseBlastWave","talent(7,3)","player.spell(Meteor).cooldown > 0", "!player.buff(Heating Up)"}},

{{  --Casts when PC is on CD. For opener purposes.
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(116267).count >= 4" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(Rune of Power)" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "talent(6,1)" },"target" },
},{"toggle.UseBlastWave","talent(7,2)","player.spell(Prismatic Crystal).cooldown > 0", "!player.buff(Pyroblast!)"}},



{{  -- Kindling
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(116267).count >= 4" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(Rune of Power)" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "talent(6,1)" },"target" },
},{"toggle.UseBlastWave","talent(7,1)"}},


{{  --Trashmode
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(116267).count >= 4" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "player.buff(Rune of Power)" },"target" },
{"Blast Wave", {"target.exists","talent(5,3)", "talent(6,1)" },"target" },
},{"toggle.UseBlastWave","toggle.Trashmode", "!player.buff(Heating Up)"}},

---------------------------
--     AOE ROTATION     --
---------------------------

{{
{"Flamestrike",{"target.exists","target.enemy","!player.moving","!target.debuff(Flamestrike)"},"target.ground"},
{ "Dragon's Breath", { "target.enemy", "target.range <= 5" },"target"},
},"modifier.multitarget"},


---------------------------
--     SINGLE TARGET     --
---------------------------
{"Dragon's Breath",{"!modifier.raid","!modifier.party","target.range <= 5"},"target"},
{"Ice Ward",{"!modifier.raid","!modifier.party","target.range <= 5","talent(3,2)"},"player"},
{"Ring of Frost",{"!modifier.raid","!modifier.party","target.range <= 5","talent(3,1)"},"player.ground"},

{{
{"Fireball", {"!glyph(61205)"},"target"},
{"Frostfire Bolt", {"glyph(61205)"},"target"},
},"player.buff(Ice Floes)"},

{"Scorch",{"player.moving"},"target" },

{"Fireball", {"!player.moving", "!glyph(61205)"},"target"},
{"Frostfire Bolt", {"!player.moving", "glyph(61205)"},"target"},
{"Scorch",{"player.moving"},"target" },


{ "/targetenemy [noexists]", { "!target.exists" } },
{ "/targetenemy [dead]", { "target.exists", "target.dead" } },

---------------------------
--!!!!!!END COMBAT!!!!!!!--
---------------------------


  },{


---------------------------
--   OOC / PRE-PULL     --
---------------------------
{ "1459", "!player.buffs.spellpower" }, --spellpower
{ "1459", "!player.buffs.crit" }, --scrit

{"Rune of Power",{"!player.moving","modifier.rcontrol"},"mouseover.ground"},
{"#109218",{"modifier.lcontrol"},"player"},
{"Mirror Image",{"modifier.lcontrol","!lastcast(Mirror Image)","talent(6,1)"}},
{"Pyroblast",{"modifier.lcontrol"},"target"},


--player.buffs.stats  (GetRaidBuffTrayAuraInfo(1))
--player.buffs.stamina  (GetRaidBuffTrayAuraInfo(2))
--player.buffs.attackpower  (GetRaidBuffTrayAuraInfo(3))
--player.buffs.haste  (GetRaidBuffTrayAuraInfo(4))
--player.buffs.spellpower  (GetRaidBuffTrayAuraInfo(5))
--player.buffs.crit  (GetRaidBuffTrayAuraInfo(6))
--player.buffs.mastery  (GetRaidBuffTrayAuraInfo(7))
--player.buffs.multistrike  (GetRaidBuffTrayAuraInfo(8))
--player.buffs.versatility  (GetRaidBuffTrayAuraInfo(9))

}, function()
NetherMachine.toggle.create('AutoCombust', 'Interface\\Icons\\spell_fire_sealoffire', 'Automated Combustion','Automated Combustion only works with Meteor talent')
NetherMachine.toggle.create('UseBlastWave', 'Interface\\Icons\\spell_holy_excorcism_02', 'Blast Wave','Toggle on for Blastwave usage, off if you want to Pool')
NetherMachine.toggle.create('Trashmode', 'Interface\\Icons\\ability_mage_firestarter', 'Trash Burn','Toggle on for trash, off for boss')

end)
