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

NetherMachine.rotation.register_custom(270, "bbMonk Mistweaver (Alpha)", {
-- COMBAT ROTATION
  --SURVIVAL
  { "!115203", { "player.health <= 35" }, "player" },--fortifying brew
  { "#5512", "player.health <= 50" },  --healthstone

  --CDs
  { "!115310", "modifier.lalt" },  --Revival
  { "!115313", "modifier.rcontrol", "ground" }, --statue
  { "!115310", { "modifier.cooldowns", "raid.health <= 60" } }, --auto revival if CD enabled
  --Tier 2 CD's

  { "!123986", "modifier.lcontrol", "player" },  --chi burst
  { "!124081", "modifier.lcontrol", "lowest" }, --zen shpere
  { "!115098", "modifier.lcontrol", "lowest" }, --chi wave

  --Expel Harm on CD if not channeling
  { "Expel Harm", { "lowest.health <= 100", "!player.casting(Uplift)", "player.chi < 4" }, "lowest" },

  --Dispells
  { "!Detox", { "!modifier.last", "player.mana > 10", "player.spell(Detox).casted < 1", "@coreHealing.needsDispelled('Corrupted Blood')" }, nil },

  --JADE SERPENT STANCE
  { {
    --ReM @3 stacks
    { "!/stopcasting", { "player.casting(Soothing Mist)", "player.spell(Renewing Mist).charges = 3" ,"!player.casting(Uplift)", "player.chi < 4", "player.mana >= 5" } },
    { "!Renewing Mist", { "lowest.buff(119611).duration <= 2", "!player.casting(Uplift)","player.spell(Renewing Mist).charges = 3", "player.chi < 4" }, "lowest" },
    { "!Renewing Mist", { "tank.buff(119611).duration <= 2", "!player.casting(Uplift)","player.spell(Renewing Mist).charges = 3", "player.chi < 4" },"tank" },
    { "!Renewing Mist", { "focus.buff(119611).duration <= 2", "!player.casting(Uplift)","player.spell(Renewing Mist).charges = 3", "player.chi < 4" },"focus" },
    { "!115151", { "!player.casting(Uplift)", "player.spell(Renewing Mist).charges = 3", "player.chi < 4" }, "lowest" },

    --Need mana Emergency
    { "!115294", { "player.mana < 8", "player.buff(115867).count >= 2", "!player.casting(Uplift)", "!player.moving" } }, -- mana tea

    --Focus emergency
    { "!115175", { "focus.health <= 15", "!player.moving", "!player.casting(Uplift)", "!modifier.last(115175)" }, "focus" }, -- Soothing Mist
    { "116680", "focus.health <= 15", "player" }, -- TFT
    { "124682", { "player.casting(Soothing Mist)", "focus.health <= 14", "player.chi >= 3" }, "focus" }, -- EnM
    { "116694", { "player.casting(Soothing Mist)", "focus.health <= 14" }, "focus" }, -- Surging Mist

    --Tank emergency Healing
    { "!115175", { "tank.health <= 15", "!player.moving", "!player.casting(Uplift)", "!modifier.last(115175)" }, "tank" }, -- Soothing Mist
    { "116680", "tank.health <= 15", "player" }, -- TFT
    { "124682", { "player.casting(Soothing Mist)", "tank.health <= 14", "player.chi >= 3" }, "tank" }, -- EnM
    { "116694", { "player.casting(Soothing Mist)", "tank.health <= 14" }, "tank" }, -- Surging Mist

    --Emergency Healing
    { "!115175", { "lowest.health <= 10", "!player.moving", "!player.casting(Uplift)", "!modifier.last(115175)" }, "lowest" }, -- Soothing Mist
    { "116680", "lowest.health <= 10", "player" }, -- TFT
    { "124682", { "player.casting(Soothing Mist)", "lowest.health <= 10", "player.chi >= 3" }, "lowest" }, -- EnM
    { "116694", { "player.casting(Soothing Mist)", "lowest.health <= 10" }, "lowest" }, -- Surging Mist

    --MANA
    { "115294", { "player.mana < 75", "player.buff(115867).count >= 2", "!player.casting(Uplift)", "!player.moving" } }, -- mana tea



    -- AoE If multitarget is enabled. ReM/Uplift healing
    { {
      { "!/stopcasting", { "!player.casting(Uplift)", "raid.health <= 90", "player.chi >= 2", "player.channeling" } },--soothe cancel for uplift
      { "!Uplift", { "raid.health <= 90", "!player.moving", "!player.casting(Uplift)", "player.chi >= 2" }, "lowest" }, --Uplift
      { "116680" },
      { "!Renewing Mist", { "lowest.buff(119611).duration <= 4","!player.casting(Uplift)", "player.spell(Renewing Mist).charges > 1", "player.chi < 4"}, "lowest" }, --ReM
      { "!Renewing Mist", { "focus.buff(119611).duration <= 4","!player.casting(Uplift)", "player.spell(Renewing Mist).charges > 1", "player.chi < 4"}, "focus" }, --ReM
      { "!Renewing Mist", { "@coreHealing.needsHealing(80, 5)", "!player.casting(Uplift)", "player.spell(Renewing Mist).charges > 1", "player.chi <= 2"}, "lowest" }, --ReM
      { "!Renewing Mist", { "!player.casting(Uplift)", "player.chi < 2", "@coreHealing.needsHealing(80, 5)" }, "focus" }, --ReM Need Chi
      { "!Renewing Mist", { "!player.casting(Uplift)", "player.chi < 2", "@coreHealing.needsHealing(80, 5)" }, "tank" }, --ReM Need Chi
      --Need more Chi for uplift
      { "116694", { "player.channeling", "lowest.health <= 90", "!modifier.last(Surging Mist)", "player.chi <= 1", "player.spell(Renewing Mist).charges < 1" }, "lowest" }, -- Surging Mist
      { "115175", { "lowest.health <= 100", "!modifier.last(115175)", "!player.casting(Uplift)", "!player.moving"}, "lowest" }, -- Soothing Mist
    }, "modifier.multitarget" },
    --Lowest if below 60% (tank included), tank if below 80%, anyone
    {{
      { "!115175", { "lowest.health <= 60","!player.moving", "!modifier.last(115175)"}, "lowest" }, -- Soothing Mist
      { "124682", { "player.casting(Soothing Mist)", "lowest.health <= 60", "player.chi > 2" }, "lowest" }, -- EnM
      { "116694", { "player.casting(Soothing Mist)", "lowest.health <= 50","!modifier.last(Surging Mist)" }, "lowest" }, -- Surging Mist
      { "115175", { "tank.health <= 80","!player.moving", "!modifier.last(115175)"}, "tank" }, -- Soothing Mist
      { "124682", { "player.casting(Soothing Mist)", "tank.health <= 70", "player.chi > 2" }, "tank" }, -- EnM
      { "116694", { "player.casting(Soothing Mist)", "tank.health <= 60", "!modifier.last(Surging Mist)" }, "tank" }, -- Surging Mist
      { "115175", { "focus.health <= 90","!player.moving"}, "focus" }, -- Soothing Mist
    }, "!modifier.multitarget" },
  }, "player.stance = 1" },



  --CRANE STANCE DPS
  { {
    { "Surging Mist", "player.buff(Vital Mists).count = 5" },
    {"Tiger Palm", {"player.buff(Vital Mists.count = 4", "player.chi > 0" }},
    { "Rising Sun Kick", {"target.debuff(130320).duration < 5", "player.chi > 1"} },
    {"Blackout Kick", {"player.buff(127722).duration < 5", "player.chi > 1" }},
    {"Tiger Palm", {"player.buff(125359).duration < 5", "player.chi > 0" }},
    {"Blackout Kick", "player.chi > 1" },
    {"Jab"},
  }, "player.stance = 2"},

  { "/targetenemy [noexists]", "!target.exists" },
  { "/focus [@targettarget]" },
  { "/target [target=focustarget, harm, nodead]", "target.range > 40" },

},{
-- OUT OF COMBAT ROTATION
  { "115921", "!player.buffs.stats" }, --stats


},function()

end)











NetherMachine.rotation.register_custom(270, "bbMonk Mistweaver (Experimental)", {


---------------------------
--       BUFFS        --
---------------------------
{ "115921", "!player.buffs.stats" }, --stats

---------------------------
--       STANCES       --
---------------------------
{"154436",{"!lastcast(115070)","player.stance = 1","toggle.AutoStanceSwap","target.range <= 5", "target.enemy"},},
{"115070",{"!lastcast(154436)","player.stance = 2","toggle.AutoStanceSwap","target.range > 5",  "target.enemy"},},
{"154436",{"player.stance = 1","modifier.rshift"}},
{"115070",{"player.stance = 2","modifier.rshift"}},

---------------------------
--       SURVIVAL        --
---------------------------
{ "!115203", { "player.health <= 35" }, "Player" },--fortifying brew
{ "#5512", "player.health <= 50" },  --healthstone
{ "Stoneform", "player.health <= 65" },
{ "Gift of the Naaru", "player.health <= 70", "player" },

---------------------------
--    MODIFIERS/MISC    --
---------------------------
{ "!115310", "modifier.lalt" },  --Revival
{"!115313", "modifier.rcontrol", "mouseover.ground" }, --statue
{ "#trinket1" },
{ "#trinket2" },
{ "!123986", "modifier.lcontrol", "player" },  --chi burst


---------------------------
--       DISPELLS        --
---------------------------
{"Detox", {"!lastcast(Detox)","player.mana > 10","@coreHealing.needsDispelled('Corrupted Blood')" }, nil },
{"Detox", {"!lastcast(Detox)","player.mana > 10","@coreHealing.needsDispelled('Slow')"}, nil },




--TESTINg
--{"/stopcasting",{"player.channeling", "player.chi >= 1"}},
--{ "!115175", { "lowest.health <= 100", "!player.moving", "!lastcast", "lowest.buff(115175).duration <= 1"}, "lowest" }, -- Soothing Mist
--{ "124682", {"player.casting(soothing mist)", "lowest.health <= 100", "player.chi >= 3" }, "lowest" }, -- EnM
--{ "116694", { "player.casting","lowest.health <= 100" }, "lowest" }, -- Surging Mist



--!!!!!!!!!!!!!!!    JADE SERPENT STANCE      !!!!!!!!!!!!!!!!!
  {{
---------------------------
--       EMERGENCY     --
---------------------------
  { "115294", { "player.mana < 8", "player.buff(115867).count >= 2","!player.casting", "!player.moving"},}, -- mana tea

---------------------------
--       FOCUS          --
---------------------------
  {{
  {"!Life Cocoon", {"focus.health <= 35", "focus.friend", "player.channeling"}, "focus"},
  {"Life Cocoon", {"focus.health <= 35", "focus.friend", "!player.channeling"}, "focus"},

  { "!115175", {"player.channeling", "focus.health <= 38", "!player.moving", "!lastcast(115175)", "focus.buff(115175).duration <= 1"}, "focus" }, -- Soothing Mist
  { "115175", {"!player.channeling", "focus.health <= 38", "!player.moving", "!lastcast(115175)", "focus.buff(115175).duration <= 1"}, "focus" }, -- Soothing Mist
  { "116680", "focus.health <= 38" , "player" }, -- TFT
  { "124682", { "player.channeling", "focus.health <= 38", "player.chi >= 3" }, "focus" }, -- EnM
  { "116694", { "player.channeling", "focus.health <= 38" }, "focus" }, -- Surging Mist
},"focus.range <= 40"},
---------------------------
--       TANK        --
---------------------------
 {{
  {"!Life Cocoon", {"tank.health <= 38", "player.channeling"}, "tank"},
  {"Life Cocoon", {"tank.health <= 38", "!player.channeling"}, "tank"},

  { "!115175", {"player.channeling", "tank.health <= 38", "!player.moving", "!lastcast(115175)",  "tank.buff(115175).duration <= 1"}, "tank" }, -- Soothing Mist
  { "115175", {"!player.channeling", "tank.health <= 38", "!player.moving", "!lastcast(115175)",  "tank.buff(115175).duration <= 1"}, "tank" }, -- Soothing Mist
  { "116680", "tank.health <= 38" , "player" }, -- TFT
  { "124682", { "player.channeling", "tank.health <= 38", "player.chi >= 3" }, "tank" }, -- EnM
  { "116694", { "player.channeling", "tank.health <= 38" }, "tank" }, -- Surging Mist
},"tank.range <= 40"},
---------------------------
--        LOWEST         --
---------------------------
 {{
  { "!115175", {"player.channeling", "lowest.health <= 35", "!player.moving", "!lastcast(115175)", "lowest.buff(115175).duration <= 1"}, "lowest" }, -- Soothing Mist
  { "115175", {"!player.channeling", "lowest.health <= 35", "!player.moving", "!lastcast(115175)", "lowest.buff(115175).duration <= 1"}, "lowest" }, -- Soothing Mist
  { "116680", "lowest.health <= 35" , "player" }, -- TFT
  { "124682", { "player.channeling", "lowest.health <= 35", "player.chi >= 3" }, "lowest" }, -- EnM
  { "116694", { "player.channeling", "lowest.health <= 35" }, "lowest" }, -- Surging Mist
},"lowest.range <= 40"},

---------------------------
--  ReM Pools of Mist   --
---------------------------
{{
{ "!Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "!Renewing Mist", { "tank.buff(119611).duration <= 2","tank.range <= 40" } ,"tank" },
{ "!Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "!Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "!Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "!Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "!Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "!Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "!Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "!Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "!Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "!Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "!Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "!Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "!Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "!Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "!Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "!Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "!Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "!Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "!Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "!Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "!Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "!Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "!Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"player.channeling","player.spell(Renewing Mist).charges = 3","player.chi < 4", "talent(7,3)"},},
{{
{ "Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "Renewing Mist", { "tank.buff(119611).duration <= 2", "tank.range <= 40"} ,"tank" },
{ "Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"!player.channeling","player.spell(Renewing Mist).charges = 3","player.chi < 4", "talent(7,3)"},},
---------------------------
--    ReM without PoM  --
---------------------------
{{
{ "!Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "!Renewing Mist", { "tank.buff(119611).duration <= 2", "tank.range <= 40"} ,"tank" },
{ "!Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "!Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "!Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "!Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "!Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "!Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "!Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "!Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "!Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "!Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "!Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "!Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "!Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "!Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "!Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "!Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "!Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "!Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "!Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "!Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "!Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "!Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "!Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"player.channeling","player.chi < 4", "!talent(7,3)", "player.spell(Renewing Mist).cooldown == 0"},},
{{
{ "Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "Renewing Mist", { "tank.buff(119611).duration <= 2", "tank.range <= 40"} ,"tank" },
{ "Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"!player.channeling","player.chi < 4", "!talent(7,3)", "player.spell(Renewing Mist).cooldown == 0"},},


---------------------------
--  EXPEL HARM & Talents --
---------------------------
{ "Expel Harm", {"lowest.health <= 100","player.chi < 4","lowest.range <= 40"}, "lowest" },
{"Chi Brew",{"!lastcast(Chi Brew)", "talent(3,3)", "player.chi <= 2", "@coreHealing.needsHealing(80,5)" },"player"},
{"Chi Brew",{"!lastcast(Chi Brew)", "player.spell(Chi Brew).charges > 1","talent(3,3)", "player.chi <= 2","@coreHealing.needsHealing(90,4)"},"player"},

{ "124081", {"lowest.health <= 90"}, "lowest" }, --zen shpere
{ "Chi Wave",{"lowest.health <= 100 "}, "lowest" }, --chi wave



---------------------------
--   UPLIFT ROTATION     --
---------------------------
  -------------!!!!  AoE If multitarget is enabled. ReM/Uplift healing  !!!!-------------------
    {{
   -- {"/stopcasting",{"raid.health <= 90", "player.chi >= 2", "player.channeling"}},

    { "!Uplift", {"player.channeling","raid.health <= 90","!player.moving","player.chi >= 2","@coreHealing.needsHealing(95,5)" },"player"}, --Uplift
    { "Uplift", {"!player.channeling","raid.health <= 90","!player.moving","player.chi >= 2","@coreHealing.needsHealing(95,5)" },"player"}, --Uplift

    { "116680",{"!player.spell(Uplift).casting"}, "player"},

{{-- ReM keep 2 charges Rolling PoM
{ "!Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "!Renewing Mist", { "tank.buff(119611).duration <= 2","tank.range <= 40"} ,"tank" },
{ "!Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "!Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "!Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "!Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "!Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "!Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "!Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "!Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "!Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "!Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "!Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "!Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "!Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "!Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "!Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "!Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "!Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "!Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "!Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "!Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "!Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "!Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "!Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"player.channeling","player.spell(Renewing Mist).charges >= 2","player.chi < 4", "talent(7,3)","@coreHealing.needsHealing(99,4)"},},

{{-- ReM keep 2 charges Rolling PoM
{ "Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "Renewing Mist", { "tank.buff(119611).duration <= 2","tank.range <= 40"} ,"tank" },
{ "Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"!player.channeling","player.spell(Renewing Mist).charges >= 2","player.chi < 4", "talent(7,3)","@coreHealing.needsHealing(99,4)"},},

---------------------------
--       MANA TEA        --
---------------------------
  { "115294", { "!@coreHealing.needsHealing(95,5)","!lastcast(115294)","player.mana < 75", "player.buff(115867).count >= 2","!player.moving"},}, -- mana tea



{{-- Cast Third charge for Chi, and when raid is lower HP
{ "!Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "!Renewing Mist", { "tank.buff(119611).duration <= 2","tank.range <= 40"} ,"tank" },
{ "!Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "!Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "!Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "!Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "!Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "!Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "!Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "!Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "!Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "!Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "!Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "!Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "!Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "!Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "!Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "!Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "!Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "!Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "!Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "!Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "!Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "!Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "!Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"player.channeling","player.spell(Renewing Mist).charges >= 1","player.chi < 2", "talent(7,3)","@coreHealing.needsHealing(80, 5)"},},
{{-- Cast Third charge for Chi, and when raid is lower HP
{ "Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.range <= 40"  } , "lowest" },
{ "Renewing Mist", { "tank.buff(119611).duration <= 2","tank.range <= 40"} ,"tank" },
{ "Renewing Mist", { "focus.buff(119611).duration <= 2", "focus.range <= 40" } ,"focus" },
{ "Renewing Mist", { "raid1.range <= 40","raid1.buff(119611).duration <= 2", "raid1.health <= 85"}, "raid1" }, --
{ "Renewing Mist", { "player.buff(119611).duration <= 2", "player.health <= 90" }, "player" }, --
{ "Renewing Mist", { "raid2.range <= 40","raid2.buff(119611).duration <= 2"}, "raid2" }, --
{ "Renewing Mist", { "raid3.range <= 40","raid3.buff(119611).duration <= 2"}, "raid3" }, --
{ "Renewing Mist", { "raid4.range <= 40","raid4.buff(119611).duration <= 2"}, "raid4" }, --
{ "Renewing Mist", { "raid5.range <= 40","raid5.buff(119611).duration <= 2"}, "raid5" }, --
{ "Renewing Mist", { "raid6.range <= 40","raid6.buff(119611).duration <= 2"}, "raid6" }, --
{ "Renewing Mist", { "raid7.range <= 40","raid7.buff(119611).duration <= 2"}, "raid7" }, --
{ "Renewing Mist", { "raid8.range <= 40","raid8.buff(119611).duration <= 2"}, "raid8" }, --
{ "Renewing Mist", { "raid9.range <= 40","raid9.buff(119611).duration <= 2"}, "raid9" }, --
{ "Renewing Mist", { "raid10.range <= 40","raid10.buff(119611).duration <= 2"}, "raid10" },
{ "Renewing Mist", { "raid11.range <= 40","raid11.buff(119611).duration <= 2"}, "raid11" },
{ "Renewing Mist", { "raid12.range <= 40","raid12.buff(119611).duration <= 2"}, "raid12" },
{ "Renewing Mist", { "raid13.range <= 40","raid13.buff(119611).duration <= 2"}, "raid13" },
{ "Renewing Mist", { "raid14.range <= 40","raid14.buff(119611).duration <= 2"}, "raid14" },
{ "Renewing Mist", { "raid15.range <= 40","raid15.buff(119611).duration <= 2"}, "raid15" },
{ "Renewing Mist", { "raid16.range <= 40","raid16.buff(119611).duration <= 2"}, "raid16" },
{ "Renewing Mist", { "raid17.range <= 40","raid17.buff(119611).duration <= 2"}, "raid17" },
{ "Renewing Mist", { "raid18.range <= 40","raid18.buff(119611).duration <= 2"}, "raid18" },
{ "Renewing Mist", { "raid19.range <= 40","raid19.buff(119611).duration <= 2"}, "raid19" },
{ "Renewing Mist", { "raid20.range <= 40","raid20.buff(119611).duration <= 2"}, "raid20" },
{ "Renewing Mist", { "raid21.range <= 40","raid21.buff(119611).duration <= 2"}, "raid21" },
},{"!player.channeling","player.spell(Renewing Mist).charges >= 1","player.chi < 2", "talent(7,3)","@coreHealing.needsHealing(80, 5)"},},


    --Need more Chi for uplift
    { "116694", {"player.channeling","player.mana >= 40","@coreHealing.needsHealing(85,5)","lowest.health <= 90", "player.chi < 2","!lastcast(116694)"}, "lowest" }, -- Surging Mist

    { "115175", {"!player.channeling","lowest.health <= 92","!lastcast(115175)","!player.moving", "lowest.buff(115175).duration <= 1"}, "lowest" }, -- Soothing Mist
    { "!115175", {"player.channeling","lowest.health <= 92","!lastcast(115175)","!player.moving", "lowest.buff(115175).duration <= 1"}, "lowest" }, -- Soothing Mist


    }, "modifier.multitarget"},
    ----------------------!!!! AoE END !!!!---------------------------




---------------------------
--     SINGLE TARGET     --
---------------------------
  --!!!!!!!!!!!!!!!      SINGLE TARGET  (multitarget disabled)  !!!!!!!!!!!!!
    --Lowest if below 80% (tank included), tank if below 90%, anyone
    {{
    { "116680", {"lowest.health <= 50"} , "player" }, -- TFT
    { "!115175", {"lowest.health <= 50","!player.moving", "!lastcast(115175)","lowest.buff(115175).duration <= 1"}, "lowest" }, -- Soothing Mist
    { "124682", { "player.channeling", "lowest.health <= 50", "player.chi > 2" }, "lowest" }, -- EnM
    { "116694", { "player.channeling", "lowest.health <= 45"}, "lowest" }, -- Surging Mist

    { "!115175", {"lowest.health <= 70","!player.moving", "!lastcast(115175)", "tank.buff(115175).duration <= 1"}, "lowest" }, -- Soothing Mist
    { "124682", { "player.channeling", "lowest.health <= 70", "player.chi > 2" }, "lowest" }, -- EnM
    { "116694", { "player.channeling","lowest.health <= 65", "!lastcast(116694)" }, "lowest" }, -- Surging Mist
    ---------------------------
--       MANA TEA        --
---------------------------
  { "115294", { "!@coreHealing.needsHealing(95,5)","!lastcast(115294)","player.mana < 75", "player.buff(115867).count >= 2","!player.moving"},}, -- mana tea

    { "124682", { "player.channeling", "lowest.health <= 85", "player.chi > 3" }, "lowest" }, -- EnM dump chi
    {"115175", { "lowest.health <= 90", "!player.moving", "lowest.buff(115175).duration <= 1"}, "lowest" }, --soothing

    {"!115175", { "tank.health <= 97", "!player.moving", "tank.buff(115175).duration <= 1"}, "tank" }, --soothing


    }, "!modifier.multitarget"},
    --!!!!!!!!!!!!!!!      END SINGLE TARGET  (multitarget disabled)  !!!!!!!!!!!!!
{"117952",{"target.range <= 40", "!player.moving","target.enemy"},"target"},
{"Detonate Chi",{"player.moving", "!lastcast(Detonate Chi)"},"player"},
  }, "player.stance = 1" },
  --!!!!!!!!!!!!!!!        END SERPANT STANCE HEALING        !!!!!!!!!!!!!!!!!!!!!!


---------------------------
--      CRANE STANCE     --
---------------------------

--!!!!!!!!!!!!!!!         CRANE STANCE DPS          !!!!!!!!!!!!!!!!!!!!!!
  {{
  { "Expel Harm", {"lowest.health <= 100","player.chi < 4"}, "lowest" },
  { "Surging Mist", {"player.buff(Vital Mists).count = 5"},"lowest" },
  {"Tiger Palm", {"player.buff(Vital Mists.count = 4", "player.chi > 0" }},
  { "Rising Sun Kick", {"target.debuff(130320).duration < 5", "player.chi > 1"} },
  {"Blackout Kick", {"player.buff(127722).duration < 5", "player.chi > 1" }},
  {"Tiger Palm", {"player.buff(125359).duration < 5", "player.chi > 0" }},
  {"Blackout Kick", "player.chi > 1" },
  {"Jab"},

  }, "player.stance = 2"},
  --!!!!!!!!!!!!!       END CRANE STANCE        !!!!!!!!!!!

---------------------------
--    AUTO TARGETING     --
---------------------------

{{
{ "/targetenemy [noexists]", "!target.exists" },
{ "/focus [@targettarget]",{ "target.enemy","target(target).friend" } },
{ "/target [target=focustarget, harm, nodead]", "target.range > 40" },
}, "toggle.AutoTarget"},


},{ --END COMBAT


---------------------------
--     OUT OF COMABT     --
---------------------------
{ "115921", "!player.buffs.stats" }, --stats
{"!115313",{"modifier.rcontrol"}, "mouseover.ground" }, --statue

},function()


NetherMachine.toggle.create('AutoStanceSwap', 'Interface\\Icons\\monk_stance_redcrane', 'Auto Crane','Auto Stance Swap when in melee')
NetherMachine.toggle.create('AutoTarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target and Focus','Target boss and focus currently active Tank')


end)
