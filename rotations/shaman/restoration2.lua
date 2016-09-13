-- NetherMachine Rotation
-- Restoration Shaman Rotation - WoD 6.0.3
-- Updated on Jan 4th 2015

-- RECOMMENDED TALENTS: Nature's Guardian, Windwalk Totem, Call of the Elements, Ancestral Swiftness, Rushing Streams, Primal Elementalist, High Tide
-- RECOMMENDED GLYPHS: Healing Stream Totem
-- CONTROLS: Pause - Left Control, Healing Rain - Left Shift


NetherMachine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return NetherMachine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for unit,_ in pairs(NetherMachine.raid.roster) do
      if UnitDebuff(unit, spell) then
        NetherMachine.dsl.parsedTarget = unit
        return true
      end
    end
  end,
})

NetherMachine.rotation.register_custom(264, "bbShaman Restoration", {
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- Racials
	--{ "Stoneform", "player.health <= 65" },
	--{ "Gift of the Naaru", "player.health <= 70", "player" },
	--{ "Lifeblood", { "modifier.cooldowns", "player.spell(Lifeblood).cooldown < 1" }, "player" },

	-- PvP
	{ "Call of the Elements", { "player.state.root", "player.spell(Wind Walk Totem).cooldown > 1", "talent(3, 1)" } },
	{ "Call of the Elements", { "player.state.snare", "player.spell(Wind Walk Totem).cooldown > 1", "talent(3, 1)" } },
	{ "Call of the Elements", { "player.state.fear", "player.spell(Tremor Totem).cooldown > 1", "talent(3, 1)" } },
	{ "Call of the Elements", { "player.state.charm", "player.spell(Tremor Totem).cooldown > 1", "talent(3, 1)" } },
	{ "Call of the Elements", { "player.state.sleep", "player.spell(Tremor Totem).cooldown > 1", "talent(3, 1)" } },
	{ "Wind Walk Totem", "player.state.root" },
	{ "Wind Walk Totem", "player.state.snare" },
	{ "Tremor Totem", "player.state.fear" },
	{ "Tremor Totem", "player.state.charm" },
	{ "Tremor Totem", "player.state.sleep" },

	-- Healing Rain Mouseover
	{ "Healing Rain", "modifier.lshift", "ground" },

	-- Buffs
	{ "Water Shield", "!player.buff" },

	-- Defensive Cooldowns
	{ "Astral Shift", { "player.health < 30", "talent(1, 3)" } },

	-- Cooldowns
	--{ "Elemental Mastery", { "modifier.cooldowns", "focustarget.boss", "talent(4, 1)" } }, -- T4
	{ "Spirit Walker's Grace", { "modifier.cooldowns", "player.buff(Ascendance)", "player.movingfor > 1" } },
	{ "Fire Elemental Totem", { "modifier.cooldowns", "@coreHealing.needsHealing(75, 5)", "!player.totem(Earth Elemental Totem)" } },
	{ "118350", "!player.buff(Empower)" }, -- Pet: Empower
	{ "Earth Elemental Totem", { "modifier.cooldowns", "@coreHealing.needsHealing(75, 5)", "!player.totem(Fire Elemental Totem)", "player.spell(Fire Elemental Totem).cooldown > 0" } },
	{ "118347", "!player.buff(Reinforce)" }, -- Pet: Reinforce

	--Use Healing Tide Totem,  Spirit Link Totem, or Ascendance during heavy raid damage.  Healing Tide Totem is particularly good when players are spread out, while Ascendance and  Spirit Link Totem benefit from a stacked raid.
	{ "Healing Tide Totem", { "modifier.cooldowns", "!player.totem(Spirit Link Totem)", "!player.buff(Ascendance)", "@coreHealing.needsHealing(50, 5)" } }, -- heals raid now no range requirement
	{ "Spirit Link Totem", { "modifier.cooldowns", "!player.totem(Healing Tide Totem)", "!player.buff(Ascendance)", "@coreHealing.needsHealing(45, 4)" } },
	{ "Ascendance", { "modifier.cooldowns", "!player.totem(Spirit Link Totem)", "!player.totem(Healing Tide Totem)", "@coreHealing.needsHealing(40, 5)" } },

	--Keep Earth Shield on the active tank.
	{ "Earth Shield", { "focus.exists", "focus.alive", "!focus.buff(Earth Shield)" }, "focus" },
	{ "Earth Shield", { "tank.exists", "tank.alive", "!focus.exists", "!focus.buff(Earth Shield)", "!tank.buff(Earth Shield)" }, "tank" },

	--Use Healing Stream Totem on CD.
	{ "Healing Stream Totem", "!player.totem(Healing Tide Totem)" },

	--Use Unleash Life to empower Chain Heals (particularly if taking the  High Tide talent), Riptides, or Healing Surges.
	{ "Unleash Life", "lowest.health < 70" },


	-- RIPTIDE
	{ "Riptide", { "!player.buff", "player.health <= 95" }, "player" },
	{ "Riptide", { "focus.exists", "focus.friend", "!focus.buff(Riptide)" }, "focus" },
	{ "Riptide", { "tank.exists", "tank.friend", "!tank.buff(Riptide)" }, "tank" },
	{ "Riptide", { "boss1target.exists", "boss1target.friend", "!boss1target.buff(Riptide)" }, "boss1target" },
	{ "Riptide", { "boss2target.exists", "boss2target.friend", "!boss2target.buff(Riptide)" }, "boss2target" },
	{ "Riptide", { "boss3target.exists", "boss3target.friend", "!boss3target.buff(Riptide)" }, "boss3target" },
	{ "Riptide", { "boss4target.exists", "boss4target.friend", "!boss4target.buff(Riptide)" }, "boss4target" },
	{ "Riptide", { "target.health < 100", "target.friend", "!target.buff(Riptide)" }, "target" },
	{ "Riptide", { "mouseover.exists", "mouseover.friend", "mouseover.health < 100", "!mouseover.buff(Riptide)" }, "mouseover" },

	-- Elemental Blast buff up
	{ "Elemental Blast", { "target.exists", "target.enemy", "target.alive", "target.combat", "!player.moving", "player.mana < 80", "target.combat" }, "target" },
	{ "Elemental Blast", { "focustarget.exists", "!player.moving", "focustarget.enemy", "focustarget.alive", "focustarget.combat", "player.mana < 80" }, "focustarget" },


	-- PRESERVE MANA
	{ "pause", { "player.mana < 25", "lastcast.time < 5" } },

	-- RIPTIDE SPAM
	{ "Riptide", "!lowest.buff(Riptide)", "lowest" },
	{ {
		{ "Riptide", { "!party1.buff", "party1.health <= 95" }, "party1" },
		{ "Riptide", { "!party2.buff", "party2.health <= 95" }, "party2" },
		{ "Riptide", { "!party3.buff", "party3.health <= 95" }, "party3" },
		{ "Riptide", { "!party4.buff", "party4.health <= 95" }, "party4" },
		{ "Riptide", { "!party5.buff", "party5.health <= 95" }, "party5" },
	}, "!modifier.raid" },
	{ {
		{ "Riptide", { "!raid1.buff", "raid1.health <= 95"}, "raid1" },
		{ "Riptide", { "!raid2.buff", "raid2.health <= 95"}, "raid2" },
		{ "Riptide", { "!raid3.buff", "raid3.health <= 95"}, "raid3" },
		{ "Riptide", { "!raid4.buff", "raid4.health <= 95"}, "raid4" },
		{ "Riptide", { "!raid5.buff", "raid5.health <= 95"}, "raid5" },
		{ "Riptide", { "!raid6.buff", "raid6.health <= 95"}, "raid6" },
		{ "Riptide", { "!raid7.buff", "raid7.health <= 95"}, "raid7" },
		{ "Riptide", { "!raid8.buff", "raid8.health <= 95"}, "raid8" },
		{ "Riptide", { "!raid9.buff", "raid9.health <= 95"}, "raid9" },
		{ "Riptide", { "!raid10.buff", "raid10.health <= 95"}, "raid10" },
		{ "Riptide", { "!raid11.buff", "raid11.health <= 95"}, "raid11" },
		{ "Riptide", { "!raid12.buff", "raid12.health <= 95"}, "raid12" },
		{ "Riptide", { "!raid13.buff", "raid13.health <= 95"}, "raid13" },
		{ "Riptide", { "!raid14.buff", "raid14.health <= 95"}, "raid14" },
		{ "Riptide", { "!raid15.buff", "raid15.health <= 95"}, "raid15" },
		{ "Riptide", { "!raid16.buff", "raid16.health <= 95"}, "raid16" },
		{ "Riptide", { "!raid17.buff", "raid17.health <= 95"}, "raid17" },
		{ "Riptide", { "!raid18.buff", "raid18.health <= 95"}, "raid18" },
		{ "Riptide", { "!raid19.buff", "raid19.health <= 95"}, "raid19" },
		{ "Riptide", { "!raid20.buff", "raid20.health <= 95"}, "raid20" },
	}, "modifier.raid" },


	--Cast Healing Rain on a clump of injured players when AoE healing is needed.
	--{ "Healing Rain", { "lowest.health <= 90", "!lowest.moving", "@bbLib.NeedHealsAroundUnit('Healing Rain')" }, "lowest.ground" }, -- lowest.ground is not working

	--Cast Chain Heal on  Riptided targets for additional AoE healing.
	-- bbLib.NeedHealsAroundUnit(spell, unit, count, distance, threshold)
	{ "Chain Heal", { "modifier.multitarget", "focus.health <= 90", "@coreHealing.needsHealing(80, 4)", "focus.area(10).friendly > 1" }, "focus" },
	{ "Chain Heal", { "modifier.multitarget", "tank.health <= 90", "@coreHealing.needsHealing(80, 4)", "tank.area(10).friendly > 1" }, "tank" },
	{ "Chain Heal", { "modifier.multitarget", "lowest.health <= 80", "@coreHealing.needsHealing(80, 4)", "lowest.area(10).friendly > 1" }, "lowest" },
	{ "Chain Heal", { "modifier.multitarget", "!modifier.last", "lowest.health <= 80", "@bbLib.NeedHealsAroundUnit('Chain Heal')" }, "lowest" },

	--Spend Tidal Waves procs on Healing Surges for tank healing.
	{ "Healing Surge", { "focus.health <= 65", "player.buff(Tidal Waves)" }, "focus" },
	{ "Healing Surge", { "tank.health <= 65", "player.buff(Tidal Waves)" }, "tank" },

	-- Quick Healing Surge
	{ "Healing Surge", "focus.health < 50", "focus" },
	{ "Healing Surge", "tank.health < 50", "tank" },
	{ "Healing Surge", "lowest.health < 30", "lowest" },

	--Cast  Healing Wave on injured targets during periods of low damage.
	{ "Healing Wave", { "focus.health <= 95" }, "focus" },
	{ "Healing Wave", { "tank.health <= 95" }, "tank" },
	{ "Healing Wave", { "lowest.health <= 95" }, "lowest" },

	-- Interrupt
	--{ "Quaking Palm", "modifier.interrupts" }, -- Pandaren Racial
	{ "Wind Shear", "modifier.interrupt" },
	{ "Wind Shear", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },
	{ "Wind Shear", { "focustarget.exists", "focustarget.enemy", "focustarget.interrupt" }, "focustarget" },

	-- Dispel Self
	--{ "Purify Spirit", "player.dispellable(Purify Spirit)", "player" },

	-- DPS ROTATION
	-- Put down Searing Totem Icon Searing Totem and refresh it when it expires.
	-- Apply Flame Shock Icon Flame Shock and refresh it when there are 9 seconds or less duration.
	-- Cast Lava Burst Icon Lava Burst.
	-- Cast Frost Shock Icon Frost Shock.
	-- Cast Lightning Bolt Icon Lightning Bolt, as a filler.
	-- If you did not use your Fire Elemental Totem Icon Fire Elemental Totem and Earth Elemental Totem Icon Earth Elemental Totem to boost your healing (thanks to  Primal Elementalist Icon Primal Elementalist), then it is a good idea to use them for increased damage.

	-- Auto Follow
	{ "/follow focus", { "toggle.autofollow", "focus.exists", "focus.alive", "focus.friend", "focus.spell(Water Walking).range", "!focus.spell(Primal Strike).range" } }, -- TODO: NYI: isFollowing() -- Primal Strike was replaced by Lava Burst.

}, {
-- OUT OF COMBAT ROTATION
	-- PAUSES
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	{ {
		-- Buffs
		{ "Water Shield", { "!modifier.last", "!player.buff" } },

		-- Pull us into combat and out of Ghost Wolf
		{ "Earth Shield", { "focus.exists", "focus.friend", "focus.alive", "focustarget.exists", "focustarget.enemy", "focustarget.alive", "focustarget.distance <= 30", "focus.buff(Earth Shield).remains < 2", "focus.distance < 40" }, "focus" },
		{ "Earth Shield", { "tank.exists", "tank.alive", "tanktarget.exists", "tanktarget.enemy", "tanktarget.alive", "tanktarget.distance <= 30", "!focus.buff(Earth Shield)", "tank.buff(Earth Shield).remains < 2", "tank.distance < 40" }, "tank" },
		{ "Riptide", { "focus.exists", "focus.friend", "focus.alive", "focustarget.exists", "focustarget.enemy", "focustarget.alive", "focustarget.distance <= 30", "focus.buff(Riptide).remains < 2", "focus.distance < 40" }, "focus" },
		{ "Riptide", { "tank.exists", "tank.alive", "tanktarget.exists", "tanktarget.enemy", "tanktarget.alive", "tanktarget.distance <= 30", "!focus.buff(Riptide)", "tank.buff(Riptide).remains < 2", "tank.distance < 40" }, "tank" },

		-- Heal
		{ "Healing Stream Totem", { "!player.moving", "player.health < 80" } },
		{ "Healing Wave", { "!player.moving", "player.health < 80" }, "player" },
	}, "player.ooctime > 5" },

	-- Ghost Wolf
	{ "Ghost Wolf", { "!player.buff(Ghost Wolf)", "player.movingfor > 2", "!player.casting", "!modifier.last(Ghost Wolf)" } },

	-- Auto Follow
	{ "/follow focus", { "toggle.autofollow", "focus.exists", "focus.alive", "focus.friend", "focus.distance < 30", "focus.distance > 8" } }, -- TODO: NYI: isFollowing() -- Primal strike was replaced withLava Burst

},
function()
	NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'PvP', 'Toggle the usage of PvP abilities.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_fire_flameshock', 'Toggle Mouseovers', 'Automatically cast spells on mouseover targets')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target. Must be another player.')
end)









NetherMachine.rotation.register_custom(264, "bbShaman Restoration (Experimental)", {
---------------------------
--    BUFFS and STUFF    --
---------------------------
{"/cancelaura Ghost Wolf",{"!player.moving", "player.buff(Ghost Wolf)"}},
{"/cancelaura Ghost Wolf",{"player.buff(79206)", "player.buff(Ghost Wolf)"}},
{ "52127", "!player.buff(52127)" },--Water Shield
{ "!Healing Tide Totem", "modifier.lalt" },-- HTT
{ "!Ascendance", "modifier.ralt" },--Ascendance
{"!98008",{"modifier.rcontrol"},"player"},--Spirit Link
{ "!Healing Rain",{"!player.moving","modifier.lcontrol"} , "mouseover.ground" },
{ "974", {"!player.buff(114052)", "!target.target(player)","focus.buff(974).count < 2","focus.range <= 40", "player.spell(974).casted < 1" }, "focus" }, --Eaarth Shield
{ "974", {"!player.buff(114052)","!target.target(player)", "tank.buff(974).count < 2", "tank.range <= 40", "player.spell(974).casted < 1" }, "tank" }, --Earth Shield
{ "57994", "modifier.interrupt" },   --  Wind Shear
{"79206",{"player.movingfor >= 1", "modifier.cooldowns", "!player.buff(79206)"}},--Spiritwalkers Gravce if Cooldown enabled and moving
{ "#trinket1","modifier.cooldowns" },
{ "#trinket2","modifier.cooldowns" },
{"!Storm Elemental Totem",{"talent(7,2)","modifier.rshift"}},
{"!2894",{"modifier.rshift"}},
{"!2062",{"modifier.rshift"}},
{{-- Primal Ele + Buffs
{"!2894",{"modifier.rshift"}},
{"!2062",{"modifier.rshift"}},
{"/cast Empower",{"player.totem(2894)","!player.buff(Empower)"}},
{"/cast Reinforce",{"player.totem(2062)","!player.buff(Reinforce)"}},
},"talent(6,2)"},
---------------------------
--       SURVIVAL        --
---------------------------
{ "!108271", { "player.health <= 45", "talent(1,3)" }, "player" },--Astral shift
{ "!108270", { "player.health <= 45","talent(1,2)" }, "player" },--Bulwark Totem
{ "#5512", "player.health <= 35" },  --healthstone
{ "Stoneform", "player.health <= 65" },
{ "Gift of the Naaru", "player.health <= 70", "player" },




---------------------------
--       DISPELLS        --
---------------------------
{"77130", {"!player.buff(114052)","!lastcast(77130)","player.mana > 10","@coreHealing.needsDispelled('Corrupted Blood')" }, nil },
{"77130", {"!player.buff(114052)","!lastcast(77130)","player.mana > 10","@coreHealing.needsDispelled('Slow')"}, nil },


---------------------------
--  WATER TOTEM/ Rains   --
---------------------------
{{
{"5394",{"!player.totem(108280)", "!player.totem(157153)","!player.totem(5394)"},"player"}, --Healing Stream
{"157153",{"!player.totem(108280)", "!player.totem(5394)","!player.totem(157153)", "talent(7,1)"},"player"}, --Cloud Burst

{{ --Always keep it down if you have Able to use 2 at once
{"5394",{"!player.totem(157153)"},"player"}, --Healing Stream
{"157153",{"!player.totem(5394)","talent(7,1)"},"player"}, --Cloud Burst
},"talent(3,2)"},
--Totem Reset
{ "108285", {"talent(3,1)", "@coreHealing.needsHealing(80, 3)", "player.spell(5394).cooldown >= 10"}, "player" },
--healing Rain
{{
{"Healing Rain",{"!player.moving","toggle.Rains"},"focus.ground"},
{"Healing Rain",{"!player.moving","!toggle.Rains","!player.buff(Healing Rain)"},"player.ground"},
},"toggle.AutoRains"},
},"!player.buff(114052)"},
---------------------------
--       EMERGENCY     --
---------------------------
{{
{"73685",{"!player.buff(73685)","!lastcast(73685)", "lowest.health <= 90"},"tank"}, --Unleash Life on CD
{"73685",{"!player.buff(73685)","!lastcast(73685)", "player.moving"},"tank"}, --Unleash Life on CD
},"!player.buff(114052)"},
{"16188", {"lowest.health <= 40"}},
{"Healing Wave",{"player.buff(16188)"},"lowest"},
{"Healing Surge",{"!player.moving","tank.health <= 25","tank.range <= 40"},"tank"},
{"Healing Surge",{"!player.moving","lowest.health <= 20","lowest.range <= 40"},"lowest"},
{"Healing Surge",{"!player.moving","lowest.health <= 30","lowest.range <= 40", "player.buff(53390)"},"lowest"},


---------------------------
--       DPS MODE   --
---------------------------
{{
{"Searing Totem","player.totem(Searing Totem).duration <= 2"},
{"Flame Shock",{"target.debuff(Flame Shock).duration <= 8", "target.range <= 25"},"target"},
{"Lava Burst",{ "!player.moving", "target.range <= 30", "target.debuff(Flame Shock)"},"target"},
{"Elemental Blast",{"target.range <= 30", "!player.moving", "talent(6,3)"},"target"},
{"Frost Shock",{"target.debuff(Flame Shock).duration >= 8", "target.range <= 25"},"target"},
{"Lightning Bolt",{"target.range <= 30", "!player.moving"},"target"},
},"toggle.dps"},
 --Elemental Blast if talented Regardless of DPS toggle. For Mana Buff
{"Elemental Blast",{"target.range <= 30", "!player.moving", "talent(6,3)"},"target"},


---------------------------
--     MULTITARGET      --
---------------------------
{{

{{
{ "Chain Heal", {"lowest.range <= 40", "lowest.buff(Riptide)", "lowest.health <= 90"}, "lowest" },
{ "Chain Heal", {"focus.range <= 40", "focus.buff(Riptide)", "focus.health <= 30"}, "focus" },
{ "Chain Heal", {"tank.buff(Riptide)", "tank.health <= 30"}, "tank" },
},"!player.moving"},

{{
{ "Chain Heal", {"lowest.range <= 40", "lowest.buff(Riptide)", "lowest.health <= 90"}, "lowest" },
{ "Chain Heal", {"focus.range <= 40", "focus.buff(Riptide)", "focus.health <= 30"}, "focus" },
{ "Chain Heal", {"tank.buff(Riptide)", "tank.health <= 30"}, "tank" },
},"player.buff(Spiritwalker's Grace)"},

{{--Not Moving
{ "Chain Heal", {"raid1.range <= 40","raid1.buff(Riptide)", "raid1.health <= 30"}, "raid1" },
{ "Chain Heal", {"player.buff(Riptide)", "player.health <= 30" }, "player" },
{ "Chain Heal", {"raid2.range <= 40","raid2.buff(Riptide)", "raid2.health <= 30"}, "raid2" },
{ "Chain Heal", {"raid3.range <= 40","raid3.buff(Riptide)", "raid3.health <= 30"}, "raid3" },
{ "Chain Heal", {"raid4.range <= 40","raid4.buff(Riptide)", "raid4.health <= 30"}, "raid4" },
{ "Chain Heal", {"raid5.range <= 40","raid5.buff(Riptide)", "raid5.health <= 30"}, "raid5" },
{ "Chain Heal", {"raid6.range <= 40","raid6.buff(Riptide)", "raid6.health <= 30"}, "raid6" },
{ "Chain Heal", {"raid7.range <= 40","raid7.buff(Riptide)", "raid7.health <= 30"}, "raid7" },
{ "Chain Heal", {"raid8.range <= 40","raid8.buff(Riptide)", "raid8.health <= 30"}, "raid8" },
{ "Chain Heal", {"raid9.range <= 40","raid9.buff(Riptide)", "raid9.health <= 30"}, "raid9" },
{ "Chain Heal", {"raid10.range <= 40","raid10.buff(Riptide)", "raid10.health <= 30"}, "raid10" },
{ "Chain Heal", {"raid11.range <= 40","raid11.buff(Riptide)", "raid11.health <= 30"}, "raid11" },
{ "Chain Heal", {"raid12.range <= 40","raid12.buff(Riptide)", "raid12.health <= 30"}, "raid12" },
{ "Chain Heal", {"raid13.range <= 40","raid13.buff(Riptide)", "raid13.health <= 30"}, "raid13" },
{ "Chain Heal", {"raid14.range <= 40","raid14.buff(Riptide)", "raid14.health <= 30"}, "raid14" },
{ "Chain Heal", {"raid15.range <= 40","raid15.buff(Riptide)", "raid15.health <= 30"}, "raid15" },
{ "Chain Heal", {"raid16.range <= 40","raid16.buff(Riptide)", "raid16.health <= 30"}, "raid16" },
{ "Chain Heal", {"raid17.range <= 40","raid17.buff(Riptide)", "raid17.health <= 30"}, "raid17" },
{ "Chain Heal", {"raid18.range <= 40","raid18.buff(Riptide)", "raid18.health <= 30"}, "raid18" },
{ "Chain Heal", {"raid19.range <= 40","raid19.buff(Riptide)", "raid19.health <= 30"}, "raid19" },
{ "Chain Heal", {"raid20.range <= 40","raid20.buff(Riptide)", "raid20.health <= 30"}, "raid20" },
{ "Chain Heal", {"raid21.range <= 40","raid21.buff(Riptide)", "raid21.health <= 30"}, "raid21" },
},"!player.moving"},

{{
{ "Riptide", {"lowest.range <= 40", "!lowest.buff(Riptide)", "lowest.health <= 90"}, "lowest" },
{ "Riptide", {"focus.range <= 40", "!focus.buff(Riptide)", "focus.health <= 31"}, "focus" },
{ "Riptide", {"tank.range <= 40","!tank.buff(Riptide)", "tank.health <= 31"}, "tank" },
{ "Riptide", { "raid1.range <= 40","!raid1.buff(Riptide)", "raid1.health <= 30"}, "raid1" }, -- Rejuv.
{ "Riptide", { "!player.buff(Riptide)", "player.health <= 30" }, "player" }, -- Rejuv.
{ "Riptide", { "raid2.range <= 40","!raid2.buff(Riptide)", "raid2.health <= 30"}, "raid2" }, -- Rejuv.
{ "Riptide", { "raid3.range <= 40","!raid3.buff(Riptide)", "raid3.health <= 30"}, "raid3" }, -- Rejuv.
{ "Riptide", { "raid4.range <= 40","!raid4.buff(Riptide)", "raid4.health <= 30"}, "raid4" }, -- Rejuv.
{ "Riptide", { "raid5.range <= 40","!raid5.buff(Riptide)", "raid5.health <= 30"}, "raid5" }, -- Rejuv.
{ "Riptide", { "raid6.range <= 40","!raid6.buff(Riptide)", "raid6.health <= 30"}, "raid6" }, -- Rejuv.
{ "Riptide", { "raid7.range <= 40","!raid7.buff(Riptide)", "raid7.health <= 30"}, "raid7" }, -- Rejuv.
{ "Riptide", { "raid8.range <= 40","!raid8.buff(Riptide)", "raid8.health <= 30"}, "raid8" }, -- Rejuv.
{ "Riptide", { "raid9.range <= 40","!raid9.buff(Riptide)", "raid9.health <= 30"}, "raid9" }, -- Rejuv.
{ "Riptide", { "raid10.range <= 40","!raid10.buff(Riptide)", "raid10.health <= 30"}, "raid10" }, -- Rejuv.
{ "Riptide", { "raid11.range <= 40","!raid11.buff(Riptide)", "raid11.health <= 30"}, "raid11" }, -- Rejuv.
{ "Riptide", { "raid12.range <= 40","!raid12.buff(Riptide)", "raid12.health <= 30"}, "raid12" }, -- Rejuv.
{ "Riptide", { "raid13.range <= 40","!raid13.buff(Riptide)", "raid13.health <= 30"}, "raid13" }, -- Rejuv.
{ "Riptide", { "raid14.range <= 40","!raid14.buff(Riptide)", "raid14.health <= 30"}, "raid14" }, -- Rejuv.
{ "Riptide", { "raid15.range <= 40","!raid15.buff(Riptide)", "raid15.health <= 30"}, "raid15" }, -- Rejuv.
{ "Riptide", { "raid16.range <= 40","!raid16.buff(Riptide)", "raid16.health <= 30"}, "raid16" }, -- Rejuv.
{ "Riptide", { "raid17.range <= 40","!raid17.buff(Riptide)", "raid17.health <= 30"}, "raid17" }, -- Rejuv.
{ "Riptide", { "raid18.range <= 40","!raid18.buff(Riptide)", "raid18.health <= 30"}, "raid18" }, -- Rejuv.
{ "Riptide", { "raid19.range <= 40","!raid19.buff(Riptide)", "raid19.health <= 30"}, "raid19" }, -- Rejuv.
{ "Riptide", { "raid20.range <= 40","!raid20.buff(Riptide)", "raid20.health <= 30"}, "raid20" }, -- Rejuv.
{ "Riptide", { "raid21.range <= 40","!raid21.buff(Riptide)", "raid21.health <= 30"}, "raid21" }, -- Rejuv.
},"player.spell(Riptide).casted <= 6"},--This incase you glyphed it

{{--Not Moving
{ "Chain Heal", {"raid1.range <= 40","raid1.buff(Riptide)", "raid1.health <= 60"}, "raid1" },
{ "Chain Heal", {"player.buff(Riptide)", "player.health <= 60" }, "player" },
{ "Chain Heal", {"raid2.range <= 40","raid2.buff(Riptide)", "raid2.health <= 60"}, "raid2" },
{ "Chain Heal", {"raid3.range <= 40","raid3.buff(Riptide)", "raid3.health <= 60"}, "raid3" },
{ "Chain Heal", {"raid4.range <= 40","raid4.buff(Riptide)", "raid4.health <= 60"}, "raid4" },
{ "Chain Heal", {"raid5.range <= 40","raid5.buff(Riptide)", "raid5.health <= 60"}, "raid5" },
{ "Chain Heal", {"raid6.range <= 40","raid6.buff(Riptide)", "raid6.health <= 60"}, "raid6" },
{ "Chain Heal", {"raid7.range <= 40","raid7.buff(Riptide)", "raid7.health <= 60"}, "raid7" },
{ "Chain Heal", {"raid8.range <= 40","raid8.buff(Riptide)", "raid8.health <= 60"}, "raid8" },
{ "Chain Heal", {"raid9.range <= 40","raid9.buff(Riptide)", "raid9.health <= 60"}, "raid9" },
{ "Chain Heal", {"raid10.range <= 40","raid10.buff(Riptide)", "raid10.health <= 60"}, "raid10" },
{ "Chain Heal", {"raid11.range <= 40","raid11.buff(Riptide)", "raid11.health <= 60"}, "raid11" },
{ "Chain Heal", {"raid12.range <= 40","raid12.buff(Riptide)", "raid12.health <= 60"}, "raid12" },
{ "Chain Heal", {"raid13.range <= 40","raid13.buff(Riptide)", "raid13.health <= 60"}, "raid13" },
{ "Chain Heal", {"raid14.range <= 40","raid14.buff(Riptide)", "raid14.health <= 60"}, "raid14" },
{ "Chain Heal", {"raid15.range <= 40","raid15.buff(Riptide)", "raid15.health <= 60"}, "raid15" },
{ "Chain Heal", {"raid16.range <= 40","raid16.buff(Riptide)", "raid16.health <= 60"}, "raid16" },
{ "Chain Heal", {"raid17.range <= 40","raid17.buff(Riptide)", "raid17.health <= 60"}, "raid17" },
{ "Chain Heal", {"raid18.range <= 40","raid18.buff(Riptide)", "raid18.health <= 60"}, "raid18" },
{ "Chain Heal", {"raid19.range <= 40","raid19.buff(Riptide)", "raid19.health <= 60"}, "raid19" },
{ "Chain Heal", {"raid20.range <= 40","raid20.buff(Riptide)", "raid20.health <= 60"}, "raid20" },
{ "Chain Heal", {"raid21.range <= 40","raid21.buff(Riptide)", "raid21.health <= 60"}, "raid21" },
},"!player.moving"},

{{
{ "Riptide", {"focus.range <= 40", "!focus.buff(Riptide)", "focus.health <= 60"}, "focus" },
{ "Riptide", {"tank.range <= 40","!tank.buff(Riptide)", "tank.health <= 60"}, "tank" },
{ "Riptide", { "raid1.range <= 40","!raid1.buff(Riptide)", "raid1.health <= 60"}, "raid1" }, -- Rejuv.
{ "Riptide", { "!player.buff(Riptide)", "player.health <= 60" }, "player" }, -- Rejuv.
{ "Riptide", { "raid2.range <= 40","!raid2.buff(Riptide)", "raid2.health <= 60"}, "raid2" }, -- Rejuv.
{ "Riptide", { "raid3.range <= 40","!raid3.buff(Riptide)", "raid3.health <= 60"}, "raid3" }, -- Rejuv.
{ "Riptide", { "raid4.range <= 40","!raid4.buff(Riptide)", "raid4.health <= 60"}, "raid4" }, -- Rejuv.
{ "Riptide", { "raid5.range <= 40","!raid5.buff(Riptide)", "raid5.health <= 60"}, "raid5" }, -- Rejuv.
{ "Riptide", { "raid6.range <= 40","!raid6.buff(Riptide)", "raid6.health <= 60"}, "raid6" }, -- Rejuv.
{ "Riptide", { "raid7.range <= 40","!raid7.buff(Riptide)", "raid7.health <= 60"}, "raid7" }, -- Rejuv.
{ "Riptide", { "raid8.range <= 40","!raid8.buff(Riptide)", "raid8.health <= 60"}, "raid8" }, -- Rejuv.
{ "Riptide", { "raid9.range <= 40","!raid9.buff(Riptide)", "raid9.health <= 60"}, "raid9" }, -- Rejuv.
{ "Riptide", { "raid10.range <= 40","!raid10.buff(Riptide)", "raid10.health <= 60"}, "raid10" }, -- Rejuv.
{ "Riptide", { "raid11.range <= 40","!raid11.buff(Riptide)", "raid11.health <= 60"}, "raid11" }, -- Rejuv.
{ "Riptide", { "raid12.range <= 40","!raid12.buff(Riptide)", "raid12.health <= 60"}, "raid12" }, -- Rejuv.
{ "Riptide", { "raid13.range <= 40","!raid13.buff(Riptide)", "raid13.health <= 60"}, "raid13" }, -- Rejuv.
{ "Riptide", { "raid14.range <= 40","!raid14.buff(Riptide)", "raid14.health <= 60"}, "raid14" }, -- Rejuv.
{ "Riptide", { "raid15.range <= 40","!raid15.buff(Riptide)", "raid15.health <= 60"}, "raid15" }, -- Rejuv.
{ "Riptide", { "raid16.range <= 40","!raid16.buff(Riptide)", "raid16.health <= 60"}, "raid16" }, -- Rejuv.
{ "Riptide", { "raid17.range <= 40","!raid17.buff(Riptide)", "raid17.health <= 60"}, "raid17" }, -- Rejuv.
{ "Riptide", { "raid18.range <= 40","!raid18.buff(Riptide)", "raid18.health <= 60"}, "raid18" }, -- Rejuv.
{ "Riptide", { "raid19.range <= 40","!raid19.buff(Riptide)", "raid19.health <= 60"}, "raid19" }, -- Rejuv.
{ "Riptide", { "raid20.range <= 40","!raid20.buff(Riptide)", "raid20.health <= 60"}, "raid20" }, -- Rejuv.
{ "Riptide", { "raid21.range <= 40","!raid21.buff(Riptide)", "raid21.health <= 60"}, "raid21" }, -- Rejuv.
},"player.spell(Riptide).casted <= 6"},--This incase you glyphed it

{"Healing Wave",{"!player.moving","player.buff(53390)", "tank.health <= 90"}, "tank"},
{"Healing Wave",{"player.buff(Spiritwalker's Grace)","player.buff(53390)", "tank.health <= 90"}, "tank"},

{{--Not Moving
{ "Chain Heal", {"raid1.range <= 40","raid1.buff(Riptide)", "raid1.health <= 90"}, "raid1" },
{ "Chain Heal", {"player.buff(Riptide)", "player.health <= 90" }, "player" },
{ "Chain Heal", {"raid2.range <= 40","raid2.buff(Riptide)", "raid2.health <= 90"}, "raid2" },
{ "Chain Heal", {"raid3.range <= 40","raid3.buff(Riptide)", "raid3.health <= 90"}, "raid3" },
{ "Chain Heal", {"raid4.range <= 40","raid4.buff(Riptide)", "raid4.health <= 90"}, "raid4" },
{ "Chain Heal", {"raid5.range <= 40","raid5.buff(Riptide)", "raid5.health <= 90"}, "raid5" },
{ "Chain Heal", {"raid6.range <= 40","raid6.buff(Riptide)", "raid6.health <= 90"}, "raid6" },
{ "Chain Heal", {"raid7.range <= 40","raid7.buff(Riptide)", "raid7.health <= 90"}, "raid7" },
{ "Chain Heal", {"raid8.range <= 40","raid8.buff(Riptide)", "raid8.health <= 90"}, "raid8" },
{ "Chain Heal", {"raid9.range <= 40","raid9.buff(Riptide)", "raid9.health <= 90"}, "raid9" },
{ "Chain Heal", {"raid10.range <= 40","raid10.buff(Riptide)", "raid10.health <= 90"}, "raid10" },
{ "Chain Heal", {"raid11.range <= 40","raid11.buff(Riptide)", "raid11.health <= 90"}, "raid11" },
{ "Chain Heal", {"raid12.range <= 40","raid12.buff(Riptide)", "raid12.health <= 90"}, "raid12" },
{ "Chain Heal", {"raid13.range <= 40","raid13.buff(Riptide)", "raid13.health <= 90"}, "raid13" },
{ "Chain Heal", {"raid14.range <= 40","raid14.buff(Riptide)", "raid14.health <= 90"}, "raid14" },
{ "Chain Heal", {"raid15.range <= 40","raid15.buff(Riptide)", "raid15.health <= 90"}, "raid15" },
{ "Chain Heal", {"raid16.range <= 40","raid16.buff(Riptide)", "raid16.health <= 90"}, "raid16" },
{ "Chain Heal", {"raid17.range <= 40","raid17.buff(Riptide)", "raid17.health <= 90"}, "raid17" },
{ "Chain Heal", {"raid18.range <= 40","raid18.buff(Riptide)", "raid18.health <= 90"}, "raid18" },
{ "Chain Heal", {"raid19.range <= 40","raid19.buff(Riptide)", "raid19.health <= 90"}, "raid19" },
{ "Chain Heal", {"raid20.range <= 40","raid20.buff(Riptide)", "raid20.health <= 90"}, "raid20" },
{ "Chain Heal", {"raid21.range <= 40","raid21.buff(Riptide)", "raid21.health <= 90"}, "raid21" },
},"!player.moving"},

},"modifier.multitarget"},



---------------------------
--     SINGLE TARGET     --
---------------------------

{"Riptide",{"tank.range <= 40", "!player.buff(53390)", "!tank.buff(61295)", "tank.health <= 95"},"tank"}, --to keep up Tidal Waves
{"Riptide",{"lowest.range <= 40", "!player.buff(53390)", "!lowest.buff(61295)", "lowest.health <= 95"},"tank"}, --to keep up Tidal Waves

{"Healing Wave",{"!player.moving","player.buff(53390)", "lowest.health <= 85"}, "lowest"},
{"Healing Wave",{"!player.moving","player.buff(53390)", "tank.health <= 90"}, "tank"},
{{
{"Healing Wave",{"player.buff(53390)", "lowest.health <= 85"}, "lowest"},
{"Healing Wave",{"player.buff(53390)", "tank.health <= 90"}, "tank"},
},"player.buff(Spiritwalker's Grace)"},
---------------------------
--       ghost wolf!     --
---------------------------
{"Ghost Wolf",{"player.movingfor >= 1", "!lastcast(Ghost Wolf)","!player.buff(Spiritwalker's Grace)"},},
{{
{ "/targetenemy [noexists]", "!target.exists" },
{ "/focus [@targettarget]",{ "target.enemy","target(target).friend" } },
{ "/target [target=focustarget, harm, nodead]", "target.range > 40" },
}, "toggle.AutoTarget"},


--OOC
},{

{ "52127", "!player.buff(52127)" },--Water Shield

},function()
NetherMachine.toggle.create('AutoRains', 'Interface\\Icons\\spell_nature_giftofthewaterspirit', 'AutoMatic Healing Rain','Enable Use of Automatic Healing Rain')
NetherMachine.toggle.create('Rains', 'Interface\\Icons\\ability_shaman_fortifyingwaters', 'Healing Rain Selector','On for Tank / Off for Player ONLY WORKS WITH Automatic HR ENABLED')
NetherMachine.toggle.create('AutoTarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target and Focus','Target boss and focus currently active Tank')
NetherMachine.toggle.create('dps', 'Interface\\Icons\\spell_nature_lightning', 'DPS MODE','Toggle on for DPS')

end)
