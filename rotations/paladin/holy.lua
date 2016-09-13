local ignoreDebuffs = {
  'Mark of Arrogance',
  'Displaced Energy',
  'Convulsive Shadows',
  'Blazing Radiance'
}

local function Dispell()
  local prefix = (IsInRaid() and 'raid') or 'party'
  for i = -1, GetNumGroupMembers() - 1 do
    local unit = (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i
    if IsSpellInRange('Cleanse', unit) then
      for j = 1, 40 do
        local debuffName, _, _, _, dispelType, duration, expires, _, _, _, spellID, _, isBossDebuff, _, _, _ = UnitDebuff(unit, j)
        if dispelType and dispelType == 'Magic' or dispelType == 'Poison' or dispelType == 'Disease' then
          local ignore = false
          for k = 1, #ignoreDebuffs do
            if debuffName == ignoreDebuffs[k] then
              ignore = true
              break
            end
          end
          if not ignore then
            NetherMachine.dsl.parsedTarget = unit
            return true
          end
        end
        if not debuffName then
          break
        end
      end
    end
  end
  return false
end

NetherMachine.library.register('lameHealing', {
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

-- NetherMachine Rotation
-- Holy Paladin - WoD 6.1
-- Updated on March 19th 2015

-- PLAYER CONTROLLED:
-- SUGGESTED TALENTS:
-- SUGGESTED GLYPHS:
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(65, "bbPaladin Holy", {
-- COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- AUTO TARGET
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- INTERRUPTS
  { "Rebuke", "target.interruptAt(50)" },
  { "Rebuke", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.interrupt"}, "mouseover" },
  { "Arcane Torrent", { "modifier.interrupt", "target.distance < 8" } },

  { "#5512", { "modifier.cooldowns", "player.health < 30" } }, -- Healthstone (5512)

  -- Mouseovers
  { {
    { "Hand of Salvation", { "toggle.usehands", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "!mouseover.role(tank)", "mouseover.aggro(target)" }, "mouseover" },
    { "Cleanse", { "!modifier.last(Cleanse)", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range <= 40", "mouseover.dispellable(Cleanse)" }, "mouseover" },
  },{
    "toggle.mouseovers", "player.health > 50",
  } },

  -- DISPELL
  --{ "Cleanse", { "!modifier.last", "player.dispellable(Cleanse)" }, "player" }, -- Cleanse Poison or Disease
  { {
    { "Cleanse", { (function() return Dispell() end) } }, -- Dispel Everything
    --{ "Cleanse", { "!lastcast(88423)", "@lameHealing.needsDispelled('Corrupted Blood')" }, nil },
    --{ "Cleanse", { "!lastcast(88423)", "@lameHealing.needsDispelled('Slow')" }, nil },
  },{
    "toggle.dispell", "player.mana > 10"
  } },
  --{ "Cleanse", "player.dispellable(Cleanse)" },

  -- HANDS/Emergency
  { {
    { "!Hand of Protection", { "!lastcast(Hand of Protection)", "!player.buff", "player.health <= 10" }, "player" },
    --{ "!Hand of Protection", { "!target.target(lowest)", "!lastcast(Hand of Protection)","!lowest.buff", "lowest.health <= 10" }, "lowest" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!player.buff", "player.state.root" }, "player" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!lowest.buff", "lowest.state.root" }, "lowest" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid2.buff", "raid2.state.root" }, "raid2" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid3.buff", "raid3.state.root" }, "raid3" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid4.buff", "raid4.state.root" }, "raid4" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid5.buff", "raid5.state.root" }, "raid5" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid6.buff", "raid6.state.root" }, "raid6" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid7.buff", "raid7.state.root" }, "raid7" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid8.buff", "raid8.state.root" }, "raid8" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid9.buff", "raid9.state.root" }, "raid9" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid10.buff", "raid10.state.root" }, "raid10" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid11.buff", "raid11.state.root" }, "raid11" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid12.buff", "raid12.state.root" }, "raid12" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid13.buff", "raid13.state.root" }, "raid13" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid14.buff", "raid14.state.root" }, "raid14" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid15.buff", "raid15.state.root" }, "raid15" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid16.buff", "raid16.state.root" }, "raid16" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid17.buff", "raid17.state.root" }, "raid17" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid18.buff", "raid18.state.root" }, "raid18" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid19.buff", "raid19.state.root" }, "raid19" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!player.buff", "player.state.snare" }, "player" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!lowest.buff", "lowest.state.snare" }, "lowest" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid2.buff", "raid2.state.snare" }, "raid2" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid3.buff", "raid3.state.snare" }, "raid3" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid4.buff", "raid4.state.snare" }, "raid4" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid5.buff", "raid5.state.snare" }, "raid5" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid6.buff", "raid6.state.snare" }, "raid6" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid7.buff", "raid7.state.snare" }, "raid7" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid8.buff", "raid8.state.snare" }, "raid8" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid9.buff", "raid9.state.snare" }, "raid9" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid10.buff", "raid10.state.snare" }, "raid10" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid11.buff", "raid11.state.snare" }, "raid11" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid12.buff", "raid12.state.snare" }, "raid12" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid13.buff", "raid13.state.snare" }, "raid13" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid14.buff", "raid14.state.snare" }, "raid14" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid15.buff", "raid15.state.snare" }, "raid15" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid16.buff", "raid16.state.snare" }, "raid16" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid17.buff", "raid17.state.snare" }, "raid17" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid18.buff", "raid18.state.snare" }, "raid18" },
    { "Hand of Freedom", { "!lastcast(Hand of Freedom)", "!raid19.buff", "raid19.state.snare" }, "raid19" },
    { "Lay on Hands", { "player.health < 20", "!player.debuff(Forbearance)" }, "player" },
    { "Lay on Hands", { "focus.exists", "focus.friend", "focus.alive", "focus.health < 20", "!focus.debuff(Forbearance)" }, "focus" },
    { "Lay on Hands", { "boss1target.exists", "boss1target.friend", "boss1target.alive", "boss1target.health < 20", "!boss1target.debuff(Forbearance)" }, "boss1target" },
    { "Lay on Hands", { "tank.health < 20", "!tank.debuff(Forbearance)" }, "tank" },
    { "!Hand of Sacrifice", { "focus.exists", "focus.friend", "focus.alive", "focus.health < 30" }, "focus" },
    { "!Hand of Sacrifice", { "boss1target.exists", "boss1target.friend", "boss1target.alive", "boss1target.health < 30" }, "boss1target" },
    { "!Hand of Sacrifice", { "tank.exists", "tank.health < 30" }, "tank" },
  }, "toggle.usehands" },

  -- COOLDOWNS
  { {
    --{ "Blood Fury", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },
    --{ "Berserking", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive" } },
    { "Arcane Torrent", { "modifier.cooldowns", "player.mana <= 70" } },
    --{ "31821", "@lameHealing.needsHealing(40, 5)", nil }, -- Devotion Aura
    { "Avenging Wrath", { "tank.health < 65" }, "tank" },
    { "Avenging Wrath", { "!modifier.raid", "modifier.party", "@lameHealing.needsHealing(75,4)" } },
    { "Avenging Wrath", { "modifier.raid", "@lameHealing.needsHealing(75,8)" } },
    { "105809", "talent(5, 1)", nil }, -- Holy Avenger
    { "Divine Protection", { "player.health < 50" }, "player" },
    { "Divine Protection", { "player.health < 100", "target.exists", "target.enemy", "target.casting.time > 0", "targettarget.istheplayer" }, "player" },
  }, "modifier.cooldowns" },

  -- MMM BACON
  { "Beacon of Light", { "focus.exists", "focus.friend", "focus.alive", "!focus.buff", "!focus.buff(Beacon of Faith)" }, "focus" },
  { "Beacon of Faith", { "toggle.beacon", "focus.exists", "focus.friend", "focus.alive", "!focus.buff", "!focus.buff(Beacon of Light)" }, "focus" },
  { "Beacon of Light", { "!focus.exists", "boss1target.exists", "boss1target.friend", "boss1target.alive", "!boss1target.buff", "!boss1target.buff(Beacon of Faith)" }, "boss1target" },
  { "Beacon of Faith", { "toggle.beacon", "!focus.exists", "boss1target.exists", "boss1target.friend", "boss1target.alive", "!boss1target.buff", "!boss1target.buff(Beacon of Light)" }, "boss1target" },
  { "Beacon of Light", { "!focus.exists", "!boss1target.exists", "tank.exists", "!tank.buff", "!tank.buff(Beacon of Faith)" }, "tank" },
  { "Beacon of Faith", { "toggle.beacon", "!focus.exists", "!boss1target.exists", "tank.exists", "!tank.buff", "!tank.buff(Beacon of Light)" }, "tank" },
  { "Beacon of Light", { "!focus.exists", "!boss1target.exists", "!tank.exists", "!player.buff", "!player.buff(Beacon of Faith)" }, "player" },
  { "Beacon of Faith", { "toggle.beacon", "!focus.exists", "!boss1target.exists", "!tank.exists", "!player.buff", "!player.buff(Beacon of Light)" }, "player" },

  { "Eternal Flame", { "player.holypower >= 3", "focus.exists", "focus.friend", "focus.alive", "!focus.buff", "focus.health < 100", "focus.distance < 40" }, "focus" },
  { "Eternal Flame", { "player.holypower >= 3", "boss1target.exists", "boss1target.friend", "boss1target.alive", "!boss1target.buff", "boss1target.health < 100", "boss1target.distance < 40" }, "boss1target" },
  { "Eternal Flame", { "player.holypower >= 3", "!tank.buff", "tank.health < 100", "tank.distance < 40" }, "tank" },
  { "Eternal Flame", { "player.holypower >= 3", "!player.buff" }, "player" },
  { "Eternal Flame", { "player.holypower >= 3", "!lowest.buff", "lowest.health < 75", "lowest.distance < 40" }, "lowest" },

  { "Sacred Shield", { "talent(3, 3)", "!player.buff" }, "player" },

  { "Holy Prism", { "target.exists", "target.enemy", "target.alive", "target.distance < 40" }, "target" },
  { "Holy Prism", { "boss1.exists", "boss1.enemy", "boss1.alive", "boss1.distance < 40" }, "boss1" },
  { "Holy Prism", { "targettarget.exists", "targettarget.enemy", "targettarget.alive", "targettarget.distance < 40" }, "targettarget" },

  -- TODO: Holy Radiance on a person when multiple people low around them.
  -- TODO: Light of Dawn

  { "Flash of Light", { "lowest.health < 20", "lowest.distance < 40" }, "lowest" },

  { "Holy Shock", { "lowest.health < 100", "lowest.distance < 40" }, "lowest" },

  --{ "Crusader Strike", { "target.exists", "target.enemy", "target.distance < 3" } },

  --{ "Holy Light", { "lowest.health < 100", "tank.distance < 40" }, "lowest" },

  -- Auto Follow
  { "/follow focus", { "toggle.autofollow", "focus.exists", "focus.alive", "focus.friend", "focus.distance < 30", "focus.distance > 8" } }, -- TODO: NYI: isFollowing() -- Primal strike was replaced withLava Burst

},{
  -- OUT OF COMBAT ROTATION
  -- Pause
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.pauses" },

  -- Blessings
  { "Blessing of Might", { "!player.buffs.mastery", "!player.buff(Blessing of Might)", "!modifier.last" } },

  -- Stance
  { "Seal of Insight", { "!player.buff", "!modifier.last" } },

  -- Auto Follow
  { "/follow focus", { "toggle.autofollow", "focus.exists", "focus.alive", "focus.friend", "focus.distance < 30", "focus.distance > 8" } }, -- TODO: NYI: isFollowing() -- Primal strike was replaced withLava Burst


},function()
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets.')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('usehands', 'Interface\\Icons\\spell_holy_sealofprotection', 'Use Hands', 'Toggles usage of Hand spells such as Hand of Protection.')
  NetherMachine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target. Must be another player.')
  NetherMachine.toggle.create('dispell', 'Interface\\Icons\\spell_holy_purify', 'Auto Cleanse Raid', 'Automaticaly cleanse debuffs from raid members.')
  NetherMachine.toggle.create('beacon', 'Interface\\Icons\\ability_paladin_beaconsoflight', 'Use Beacon of Faith', 'Automaticaly use Beacon of Faith on focus, bosstarget, tank, then player.')
end)














NetherMachine.rotation.register_custom(65, "|cff00FFFFMacks|r - [|cffF58CBAHoly v1.3|r]", {
  ---------------------------
  --Blessings/Buffs/BEACON --
  ---------------------------
  { "20217", {"!player.buffs.stats" ,"toggle.Blessing" }, "player" },--Lings
  { "19740", { "!player.buffs.mastery" ,"!toggle.Blessing" }, "player" },--Might
  { "20165", {  "player.seal != 2"}, "player" }, --Seal of Insight
  { "156910",{ "tank.alive", "tank.agro","!tank.buff(53563)","!tank.buff(156910)", "talent(7,1)","!lastcast(156910)","player.spell(156910).casted < 1"},"tank"},
  { "53563",{ "tank.alive", "tank.agro","!tank.buff(53563)","!tank.buff(156910)", "!lastcast(53563)","player.spell(53563).casted < 1"},"tank"},
  --BoL buff  53563
  --Bof buff 156910

  ---------------------------
  --       MODIFIERS     --
  ---------------------------
  {"!Devotion Aura",{"modifier.ralt"},"player"},
  {"!Light's Hammer",{"modifier.lcontrol"},"mouseover.ground"},
  {"!Avenging Wrath",{"modifier.lalt"},"player"},
  {"!Holy Avenger",{"modifier.rcontrol","talent(5,1)"},"player"},
  {"Rebuke", {"modifier.interrupts","target.range <= 6"}, "target" },
  ---------------------------
  --       SURVIVAL        --
  ---------------------------
  { "!Divine Shield", { "player.health <= 15" }, "player" },
  { "Divine Protection", { "player.health <= 45" }, "player" },
  { "#5512", "player.health <= 35","player" },  --healthstone
  { "Stoneform", "player.health <= 65" },
  { "Gift of the Naaru", "player.health <= 70", "player" },
  {"!633",{"tank.health <= 20", "modifier.cooldowns"},"tank"}, --Lay on Hands
  {"!633",{"lowest.health <= 15", "modifier.cooldowns"},"lowest"},
  { "Arcane Torrent", {"@lameHealing.needsHealing(85,5)","player.holypower <= 2","player.spell(Holy Shock).cooldown > 1"},"player" },

  ---------------------------
  --       DISPELLS        --
  ---------------------------
  {{
    {"Cleanse", {"!lastcast(88423)","player.mana > 10", "@lameHealing.needsDispelled('Corrupted Blood')"}, nil },
    {"Cleanse", {"!lastcast(88423)","player.mana > 10", "@lameHealing.needsDispelled('Slow')"}, nil },
  },"player.mana > 10" },
  --{ "Cleanse", "player.dispellable(Cleanse)" },
  -------------------------
  -- HANDS/Emergency     --
  -------------------------
  {{
    { "!Hand of Protection", {"!lastcast(Hand of Protection)","!player.buff", "player.health <= 10" }, "player" },
    { "!Hand of Protection", {"!target.target(lowest)","!lastcast(Hand of Protection)","!lowest.buff", "lowest.health <= 10" }, "lowest" },
    { "!Hand of Sacrifice", {"!lastcast(Hand of Sacrifice)","!player.buff", "tank.health <= 45" }, "tank" },
    { "!Hand of Sacrifice", {"!lastcast(Hand of Sacrifice)","!lowest.buff", "lowest.health <= 25" }, "lowest" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!player.buff", "player.state.root" }, "player" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!lowest.buff", "lowest.state.root" }, "lowest" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid2.buff", "raid2.state.root" }, "raid2" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid3.buff", "raid3.state.root" }, "raid3" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid4.buff", "raid4.state.root" }, "raid4" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid5.buff", "raid5.state.root" }, "raid5" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid6.buff", "raid6.state.root" }, "raid6" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid7.buff", "raid7.state.root" }, "raid7" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid8.buff", "raid8.state.root" }, "raid8" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid9.buff", "raid9.state.root" }, "raid9" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid10.buff", "raid10.state.root" }, "raid10" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid11.buff", "raid11.state.root" }, "raid11" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid12.buff", "raid12.state.root" }, "raid12" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid13.buff", "raid13.state.root" }, "raid13" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid14.buff", "raid14.state.root" }, "raid14" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid15.buff", "raid15.state.root" }, "raid15" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid16.buff", "raid16.state.root" }, "raid16" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid17.buff", "raid17.state.root" }, "raid17" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid18.buff", "raid18.state.root" }, "raid18" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid19.buff", "raid19.state.root" }, "raid19" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!player.buff", "player.state.snare" }, "player" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!lowest.buff", "lowest.state.snare" }, "lowest" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid2.buff", "raid2.state.snare" }, "raid2" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid3.buff", "raid3.state.snare" }, "raid3" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid4.buff", "raid4.state.snare" }, "raid4" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid5.buff", "raid5.state.snare" }, "raid5" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid6.buff", "raid6.state.snare" }, "raid6" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid7.buff", "raid7.state.snare" }, "raid7" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid8.buff", "raid8.state.snare" }, "raid8" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid9.buff", "raid9.state.snare" }, "raid9" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid10.buff", "raid10.state.snare" }, "raid10" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid11.buff", "raid11.state.snare" }, "raid11" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid12.buff", "raid12.state.snare" }, "raid12" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid13.buff", "raid13.state.snare" }, "raid13" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid14.buff", "raid14.state.snare" }, "raid14" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid15.buff", "raid15.state.snare" }, "raid15" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid16.buff", "raid16.state.snare" }, "raid16" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid17.buff", "raid17.state.snare" }, "raid17" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid18.buff", "raid18.state.snare" }, "raid18" },
    { "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid19.buff", "raid19.state.snare" }, "raid19" },
  },"toggle.AutoHands"},

  ---------------------------
  --      EMERGENCY/Proc   --
  ---------------------------
  {{
    {"Flash of Light",{"!player.moving","tank.health <= 60", "tank.range <= 40","player.spell(Holy Shock).cooldown > 1"},"tank"},
    {"Flash of Light",{"!player.moving","lowest.health <= 50", "lowest.range <= 40","player.spell(Holy Shock).cooldown > 1"},"lowest"},
    {"Flash of Light",{"!player.moving","tank.health <= 50", "tank.range <= 40","player.holypower = 5"},"tank"},
    {"Flash of Light",{"!player.moving","lowest.health <= 40", "lowest.range <= 40","player.holypower = 5"},"lowest"},
    {"Flash of Light",{"!player.moving","tank.health <= 40", "tank.range <= 40"},"tank"},
    {"Flash of Light",{"!player.moving","lowest.health <= 30", "lowest.range <= 40"},"lowest"},
  },"!modifier.raid"},

  {"Holy Shock",{"lowest.health <= 96", "lowest.range <= 40", "player.holypower < 5","!player.buff(105809)"},"lowest"},
  {"Holy Shock",{"lowest.health <= 96", "lowest.range <= 40", "player.holypower < 3","player.buff(105809)"},"lowest"},
  {"Execution Sentence",{"tank.health <= 80", "tank.range <= 40", "talent(6,3)","player.spell(Holy Shock).cooldown > 1"},"tank"},
  {"Execution Sentence",{"lowest.health <= 70", "lowest.range <= 40","talent(6,3)","player.spell(Holy Shock).cooldown > 1"},"lowest"},
  {"Holy Prism",{"@lameHealing.needsHealing(95,3)", "target.range <= 40", "talent(6,1)","target.enemy"},"target"},
  {"Execution Sentence",{"tank.health <= 80", "tank.range <= 40", "talent(6,3)","player.holypower = 5"},"tank"},
  {"Execution Sentence",{"lowest.health <= 70", "lowest.range <= 40","talent(6,3)","player.holypower = 5"},"lowest"},
  {"Holy Prism",{"@lameHealing.needsHealing(95,5)", "target.range <= 40", "talent(6,1)","player.holypower = 5"},"target"},
  {"Flash of Light",{"!player.moving","tank.health <= 40", "tank.range <= 40","player.spell(Holy Shock).cooldown > 1"},"tank"},
  {"Flash of Light",{"!player.moving","lowest.health <= 30", "lowest.range <= 40","player.spell(Holy Shock).cooldown > 1"},"lowest"},
  {"Flash of Light",{"!player.moving","tank.health <= 40", "tank.range <= 40","player.holypower = 5"},"tank"},
  {"Flash of Light",{"!player.moving","lowest.health <= 30", "lowest.range <= 40","player.holypower = 5"},"lowest"},

  ---------------------------
  --  SAcRED SHIELD   CR  --
  ---------------------------
{{--Start SS CR
  --148039 Sacred shield buff
  --105809 Holy avenger
  {"Light of Dawn",{"!player.moving","@lameHealing.needsHealing(96,2)", "lowest.range <= 40","player.buff(90174)"},"tank"},
  --add agro too SS
  {"Light of Dawn",{"!player.moving","player.holypower == 5","@lameHealing.needsHealing(96,5)", "lowest.range <= 40"},"lowest"},
  {"Light of Dawn",{"!player.moving","player.holypower == 5","@lameHealing.needsHealing(93,4)", "lowest.range <= 40"},"lowest"},
  {"Light of Dawn",{"!player.moving","player.holypower == 5","@lameHealing.needsHealing(90,3)", "lowest.range <= 40"},"lowest"},
  {"Light of Dawn",{"!player.moving","player.holypower >= 3","@lameHealing.needsHealing(88,5)", "lowest.range <= 40"},"lowest"},
  {"Light of Dawn",{"!player.moving","player.holypower >= 3","@lameHealing.needsHealing(80,3)", "lowest.range <= 40"},"lowest"},
  {"Light of Dawn",{"!player.moving","player.holypower >= 3","@lameHealing.needsHealing(75,2)", "lowest.range <= 40"},"lowest"},
  {"Sacred Shield",{"player.spell(Holy Shock).cooldown > 1","!lastcast(Sacred Shield)","tank.buff(148039).duration <= 5","tank.range <= 40", "tank.health <= 99" },"tank"},
  {"Sacred Shield",{"player.spell(Holy Shock).cooldown > 1","!lastcast(Sacred Shield)","lowest.range <= 40", "lowest.buff(148039).duration <= 5","player.spell(Sacred Shield).charges >= 1", "lowest.health <= 95"},"lowest"},
  {"Sacred Shield",{"player.holypower = 5","!lastcast(Sacred Shield)","tank.buff(148039).duration <= 5","tank.range <= 40", "tank.health <= 99" },"tank"},
  {"Sacred Shield",{"player.holypower = 5","!lastcast(Sacred Shield)","lowest.range <= 40", "lowest.buff(148039).duration <= 5","player.spell(Sacred Shield).charges >= 1", "lowest.health <= 95"},"lowest"},
  {{
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(75,6)","player.holypower < 5","!player.buff(105809)"},"lowest"},
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(75,6)","player.holypower < 3","player.buff(105809)"},"lowest"},
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(65,5)","player.holypower < 5","!player.buff(105809)"},"lowest"},
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(65,5)","player.holypower < 3","player.buff(105809)"},"lowest"},
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(55,4)","player.holypower < 5","!player.buff(105809)"},"lowest"},
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(55,4)","player.holypower < 3","player.buff(105809)"},"lowest"},
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(45,3)","player.holypower < 5","!player.buff(105809)"},"lowest"},
    {"Holy Radiance",{"player.mana >= 20","@lameHealing.needsHealing(45,3)","player.holypower < 3","player.buff(105809)"},"lowest"},
  },"toggle.HRad"},
  --{"Word of Glory",{"!@lameHealing.needsHealing(95, 4)","player.holypower = 5","lowest.health <= 77","lowest.range <= 40", "!player.moving"},"lowest"},
  --{"Word of Glory",{"!@lameHealing.needsHealing(95, 4)","player.holypower = 5","lowest.health <= 88","tank.range <= 40", "!player.moving"},"tank"},
  {"Holy Light",{"lowest.health <= 85","lowest.range <= 40", "!player.moving","player.spell(Holy Shock).cooldown > 1"},"lowest"},
  {"Holy Light",{"tank.health <= 92","tank.range <= 40", "!player.moving","player.spell(Holy Shock).cooldown > 1"},"tank"},
  {"Holy Light",{"lowest.health <= 85","lowest.range <= 40", "!player.moving","player.holypower = 5"},"lowest"},
  {"Holy Light",{"tank.health <= 92","tank.range <= 40", "!player.moving","player.holypower = 5"},"tank"},
},"talent(3,3)"},--End SS CR

  ---------------------------
  -- TARGETING AND FOCUS  --
  ---------------------------
  {{
    { "/targetenemy [noexists]", "!target.exists" },
    { "/focus [@targettarget]",{ "target.enemy","target(target).friend" } },
    { "/target [target=focustarget, harm, nodead]", "target.range > 40" },
  }, "toggle.AutoTarget"},

},{  --OOC
  ---------------------------
  --       Blessings      --
  ---------------------------
  { "20217", {"!player.buffs.stats" ,"toggle.Blessing" }, "player" },
  { "19740", { "!player.buffs.mastery" ,"!toggle.Blessing" }, "player" },

},function()
  NetherMachine.toggle.create('Blessing', 'Interface\\Icons\\spell_magic_greaterblessingofkings', 'Blessings','On for Kings off for Might')
  NetherMachine.toggle.create('HRad', 'Interface\\Icons\\spell_paladin_divinecircle', 'Holy Radiance','Toggle on/off use of Holy Radiance')
  NetherMachine.toggle.create('AutoHands', 'Interface\\Icons\\spell_holy_sealofwisdom', 'Automatic Hands Usage','SAC/BoP/Freedom Automatic Usage Not for Pros')
  NetherMachine.toggle.create('AutoTarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target and Focus','Target boss and focus currently active Tank')
end)














local inCombat = {
  -- Dispel Everything
  { "4987", { "toggle.dispell", (function() return Dispell() end) } },

  -- Hand of Freedom
  { "1044", "player.state.root" },

  -- Buffs
  { "20217", { "!player.buffs.stats" }, nil }, -- Blessing of Kings
  { "19740", { "!player.buffs.mastery" }, nil },  -- Blessing of Might

  -- Seals
  { "20165", { "player.seal != 2" }, nil }, -- seal of Insight
  { "105361", { "player.seal != 1" }, nil }, -- seal of Command

  -- keybinds
  { "114158", "modifier.shift", "target.ground"}, -- Light´s Hammer
  { "!/focus [target=mouseover]", "modifier.alt" }, -- Mouseover Focus

  -- Items
  { "#5512", "player.health < 40" }, -- Healthstone
  { "#trinket1" }, -- Trinket 1
  { "#trinket2" }, -- Trinket 2

  {{-- Beacon of Faith
    { "156910", {
      "!player.buff(53563)", -- Beacon of light
      "!player.buff(156910)" -- Beacon of Faith
    }, "player" },
  }, "talent(7,1)" },

  -- Beacon of light
  { "53563", {
    "!tank.buff(53563)", -- Beacon of light
    "!tank.buff(156910)", -- Beacon of Faith
    "tank.spell(53563).range"
  }, "tank" },

  -- Interrupts
  { "96231", { -- Rebuke
    "modifier.interrupts",
    "target.range <= 6"
  }, "target" },

  -- Hands
  { "6940", { -- Hand of Sacrifice
  "tank.spell(6940).range", "tank.health <= 40" }, "tank" },
  { "6940", { -- Hand of Sacrifice
  "focus.spell(6940).range", "focus.health <= 40" }, "focus" },

  -- Survival
  { "498", "player.health <= 90", nil }, -- Divine Protection
  { "642", "player.health <= 20", nil }, -- Divine Shield

  -- Lay on Hands
  { "!633", {
    "focus.health <= 15",
    "focus.spell(633).range"
  }, "focus" },
  { "!633", {
    "tank.health <= 15",
    "tank.spell(633).range"
  }, "tank" },
  { "!633", "lowest.health <= 15", "lowest" },

  -- Infusion of Light // proc
  {{-- AoE
    { "82327", { -- Holy Radiance - Party
      "@lameHealing.needsHealing(80, 3)",
      "player.buff(54149)",
      "!player.moving"
    }, "lowest" },
  }, "modifier.multitarget" },
  { "82326", { -- Holy Light
    "lowest.health <= 100",
    "player.buff(54149)",
    "!player.moving"
  }, "lowest" },

  -- Holy Shock
  { "20473", {
    "focus.health <= 100",
    "focus.spell(20473).range"
  }, "focus" },
  { "20473", {
    "tank.health <= 100",
    "tank.spell(20473).range"
  }, "tank" },
  { "20473", "lowest.health <= 100", "lowest" },

  {{-- AoE
    -- Light of Dawn
    { "85222", { "@lameHealing.needsHealing(90, 3)", "player.holypower >= 3", "modifier.party" }, "lowest" },
    { "85222", { "@lameHealing.needsHealing(90, 5)", "player.holypower >= 3", "modifier.raid", "!modifier.members > 10" }, "lowest" },
    { "85222", { "@lameHealing.needsHealing(90, 8)", "player.holypower >= 3", "modifier.members > 10" }, "lowest" },
    -- Holy Radiance
    { "82327", { -- Holy Radiance - Party
      "@lameHealing.needsHealing(80, 3)",
      "!modifier.last",
      "!player.moving",
      "modifier.party"
    }, "lowest" },
    { "82327", { -- Holy Radiance - Raid 10
      "@lameHealing.needsHealing(90, 5)",
      "!modifier.last",
      "!player.moving",
      "modifier.raid",
      "!modifier.members > 10"
    }, "lowest" },
    { "82327", { -- Holy Radiance 10+
      "@lameHealing.needsHealing(90, 8)",
      "!modifier.last",
      "!player.moving",
      "modifier.members > 10"
    }, "lowest" },
  }, "modifier.multitarget" },

  {{-- Beacon of Insight
    { "157007", nil, "lowest" },
    { "19750", { -- flash of light
      "lowest.health <= 40",
      "!player.moving"
    }, "lowest" },
    { "82326", { -- Holy Light
      "lowest.health < 80",
      "!player.moving"
    }, "lowest" },
  }, "talent(7,2)" },

  -- Flash of Light
  { "!19750", { "focus.health <= 20", "!player.moving", "focus.spell(19750).range" }, "focus" },
  { "!19750", { "tank.health <= 20", "!player.moving", "tank.spell(19750).range" }, "tank" },
  { "!19750", { "lowest.health <= 20", "!player.moving" }, "lowest" },

  {{-- Cooldowns
    { "#gloves" }, -- gloves
    { "31821", "@lameHealing.needsHealing(40, 5)", nil }, -- Devotion Aura
    { "31884", "@lameHealing.needsHealing(95, 4)", nil }, -- Avenging Wrath
    { "86669", "@lameHealing.needsHealing(85, 4)", nil }, -- Guardian of Ancient Kings
    { "31842", "@lameHealing.needsHealing(90, 4)", nil }, -- Divine Favor
    { "105809", "talent(5, 1)", nil }, -- Holy Avenger
  }, "modifier.cooldowns" },

  -- Execution Sentence // Talent
  { "114157", {
    "focus.health <= 80",
    "focus.spell(114157).range"
  }, "focus" },
  { "114157", {
    "tank.health <= 80",
    "tank.spell(114157).range"
  }, "tank" },
  { "114157", "lowest.health <= 10", "lowest" },

  {{-- Divine Purpose
    { "85222", { -- Light of Dawn
      "@lameHealing.needsHealing(90, 3)",
      "player.holypower >= 1",
      "modifier.party"
    }, "lowest" },
    { "85673", "lowest.health <= 85", "lowest"  }, -- Word of Glory
    { "114163", { -- Eternal Flame
      "!lowest.buff(114163)",
      "lowest.health <= 85"
    }, "lowest" },
  }, "player.buff(86172)" },

  {{-- Selfless Healer
    { "20271", "target.spell(20271).range", "target" }, -- Judgment
    {{ -- If got buff
      { "19750", { -- Flash of light
        "lowest.health <= 85",
        "!player.moving"
      }, "lowest" },
    }, "player.buff(114250).count = 3" }
  }, "talent(3, 1)" },

  {{-- Sacred Shield // Talent
    { "148039", {
      "player.spell(148039).charges >= 1",
      "tank.health <= 100",
      "!tank.buff(148039)", -- SS
      "tank.range < 40"
    }, "tank" },
    { "148039", {
      "player.spell(148039).charges >= 1",
      "focus.health <= 100",
      "!focus.buff(148039)",
      "focus.range < 40"
    }, "focus" },
    { "148039", { -- Sacred Shield
      "player.spell(148039).charges >= 2",
      "player.health <= 80",
      "!player.buff(148039)"
    }, "player" },
    { "148039", { -- Sacred Shield
      "player.spell(148039).charges >= 2",
      "lowest.health <= 80",
      "!lowest.buff(148039)"
    }, "lowest" },
  }, "talent(3,3)" },

  {{-- Eternal Flame // talent
  { "114163", {
    "player.holypower >= 3",
    "!focus.buff(114163)",
    "focus.spell(114163).range",
    "lowest.health <= 75"
  }, "focus" },
  { "114163", {
    "player.holypower >= 3",
    "!tank.buff(114163)",
    "focus.spell(114163).range",
    "lowest.health <= 75"
  }, "tank" },
  { "114163", {
    "player.holypower >= 1",
    "!lowest.buff(114163)",
    "lowest.health <= 93"
  }, "lowest" },
  }, "talent(3,2)" },

  -- Word of Glory
  { "85673", {
    "player.holypower >= 3",
    "focus.spell(85673).range",
    "lowest.health <= 80"
  }, "focus" },
  { "85673", {
    "player.holypower >= 3",
    "focus.spell(85673).range",
    "lowest.health <= 80"
  }, "tank"  },
  { "85673", {
    "player.holypower >= 3",
    "lowest.health <= 80"
  }, "lowest"  },

  -- Crusader Strike
  { "35395", {
    "target.range <= 6",
    "toggle.cstrike"
  }, "target" },

  -- Holy Prism // Talent
  { "114165", { -- Holy Prism
    "player.holypower >= 3",
    "focus.health <= 85",
    "!player.moving",
    "focus.spell(114165).range"
  }, "focus"},
  { "114165", { -- Holy Prism
    "tank.health <= 85",
    "!player.moving",
    "tank.spell(114165).range"
  }, "tank"},
  { "114165", { -- Holy Prism
    "lowest.health <= 85",
    "!player.moving"
  }, "lowest"},

  -- Holy Light
  { "82326", {
    "focus.health < 100",
    "!player.moving",
    "focus.spell(82326).range"
  }, "focus" },
  { "82326", {
    "tank.health < 100",
    "!player.moving",
    "focus.spell(82326).range"
  }, "tank" },
  { "82326", {
    "lowest.health < 100",
    "!player.moving"
  }, "lowest" },

}

local outCombat = {

  -- keybinds
  { "114158", "modifier.shift", "mouseover.ground"}, -- Light´s Hammer
  { "!/focus [target=mouseover]", "modifier.alt" }, -- Mouseover Focus

  -- Buffs
  { "20217", { -- Blessing of Kings
    "!player.buffs.stats",
    "toggle.seal",
  }, nil },
  { "19740", { -- Blessing of Might
    "!player.buffs.mastery",
    "!toggle.seal",
  }, nil },

  -- Seals
  { "20165", { -- seal of Insight
    "player.seal != 2",
    "toggle.seal",
  }, nil },
  { "105361", { -- seal of Command
    "player.seal != 1",
    "!toggle.seal",
  }, nil },

  {{-- Beacon of Faith
    { "156910", {
      "!player.buff(53563)", -- Beacon of light
      "!player.buff(156910)" -- Beacon of Faith
    }, "player" },
  }, "talent(7,1)" },

  -- Beacon of light
  { "53563", {
    "!tank.buff(53563)", -- Beacon of light
    "!tank.buff(156910)", -- Beacon of Faith
    "tank.spell(53563).range"
  }, "tank" },

  -- hands
  { "1044", "player.state.root" }, -- Hand of Freedom

  -- Start
  { "20473", "lowest.health < 100", "lowest" }, -- Holy Shock

  { {-- AoE
    -- Light of Dawn
    { "85222", { -- party
      "@lameHealing.needsHealing(90, 3)",
      "player.holypower >= 3",
      "modifier.party"
    }, "lowest" },
    { "85222", { -- raid
      "@lameHealing.needsHealing(90, 5)",
      "player.holypower >= 3",
      "modifier.raid",
      "!modifier.members > 10"
    }, "lowest" },
    { "85222", { -- raid 25
      "@lameHealing.needsHealing(90, 8)",
      "player.holypower >= 3",
      "modifier.members > 10"
    }, "lowest" },
    -- Holy Radiance
    { "82327", { -- Holy Radiance - Party
      "@lameHealing.needsHealing(80, 3)",
      "!modifier.last",
      "!player.moving",
      "modifier.party"
    }, "lowest" },
    { "82327", { -- Holy Radiance - Raid 10
      "@lameHealing.needsHealing(90, 5)",
      "!modifier.last",
      "!player.moving",
      "modifier.raid",
      "!modifier.members > 10"
    }, "lowest" },
    { "82327", { -- Holy Radiance 10+
      "@lameHealing.needsHealing(90, 8)",
      "!modifier.last",
      "!player.moving",
      "modifier.members > 10"
    }, "lowest" },
  }, "modifier.multitarget" },

  -- Holy Light
  { "82326", { "lowest.health < 100", "!player.moving" }, "lowest" },

}

NetherMachine.rotation.register_custom(65, "bbPaladin Holy (derp)", inCombat, outCombat, function()
  NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets.')
  NetherMachine.toggle.create('pvpmode', 'Interface\\Icons\\achievement_pvp_o_h', 'Enable PvP', 'Toggle the usage of PvP abilities.')
  NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
  NetherMachine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target. Must be another player.')
  NetherMachine.toggle.create('dispell', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Dispell', 'Automatically dispell the group.')
  NetherMachine.toggle.create('blessing', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Blessing of Kings', 'Enabled = Kings   Disabled = Might')
  NetherMachine.toggle.create('seal', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Seal of Insight', 'Enabled = Insight   Disabled = Command')
  NetherMachine.toggle.create('cstrike', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Crusader Strike', 'Toggle usage of Crusader Strike on enemies.')
end)





















NetherMachine.rotation.register_custom(65, "bbPaladin Holy (Experimental)", {
---------------------------
--Blessings/Buffs/BEACON --
---------------------------
{ "20217", {"!player.buffs.stats" ,"toggle.Blessing" }, "player" },--Lings
{ "19740", { "!player.buffs.mastery" ,"!toggle.Blessing" }, "player" },--Might
{ "20165", {  "player.seal != 2"}, "player" }, --Seal of Insight
{"156910",{"tank.agro","!tank.buff(53563)","!tank.buff(156910)", "talent(7,1)","!lastcast(156910)","player.spell(156910).casted < 1"},"tank"},
{"53563",{"tank.agro","!tank.buff(53563)","!tank.buff(156910)", "!lastcast(53563)","player.spell(53563).casted < 1"},"tank"},
--BoL buff  53563
--Bof buff 156910

---------------------------
--       MODIFIERS     --
---------------------------
{"!Devotion Aura",{"modifier.ralt"},"player"},
{"!Light's Hammer",{"modifier.lcontrol"},"mouseover.ground"},
{"!Avenging Wrath",{"modifier.lalt"},"player"},
{"!Holy Avenger",{"modifier.rcontrol","talent(5,1)"},"player"},
{"Rebuke", {"modifier.interrupts","target.range <= 6"}, "target" },
---------------------------
--       SURVIVAL        --
---------------------------
{ "!Divine Shield", { "player.health <= 15" }, "player" },
{ "Divine Protection", { "player.health <= 45" }, "player" },
{ "#5512", "player.health <= 35","player" },  --healthstone
{ "Stoneform", "player.health <= 65" },
{ "Gift of the Naaru", "player.health <= 70", "player" },
{"!633",{"tank.health <= 20", "modifier.cooldowns"},"tank"}, --Lay on Hands
{"!633",{"lowest.health <= 15", "modifier.cooldowns"},"lowest"},
{ "Arcane Torrent", {"@coreHealing.needsHealing(85,5)","player.holypower <= 2","player.spell(Holy Shock).cooldown > 1"},"player" },

---------------------------
--       DISPELLS        --
---------------------------
{{
{"Cleanse", {"!lastcast(88423)","player.mana > 10", "@coreHealing.needsDispelled('Corrupted Blood')"}, nil },
{"Cleanse", {"!lastcast(88423)","player.mana > 10", "@coreHealing.needsDispelled('Slow')"}, nil },
},"player.mana > 10" },
--{ "Cleanse", "player.dispellable(Cleanse)" },
-------------------------
-- HANDS/Emergency     --
-------------------------
{{
{ "!Hand of Protection", {"!lastcast(Hand of Protection)","!player.buff", "player.health <= 10" }, "player" },
{ "!Hand of Protection", {"!target.target(lowest)","!lastcast(Hand of Protection)","!lowest.buff", "lowest.health <= 10" }, "lowest" },
{ "!Hand of Sacrifice", {"!lastcast(Hand of Sacrifice)","!player.buff", "tank.health <= 45" }, "tank" },
{ "!Hand of Sacrifice", {"!lastcast(Hand of Sacrifice)","!lowest.buff", "lowest.health <= 25" }, "lowest" },

{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!player.buff", "player.state.root" }, "player" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!lowest.buff", "lowest.state.root" }, "lowest" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid2.buff", "raid2.state.root" }, "raid2" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid3.buff", "raid3.state.root" }, "raid3" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid4.buff", "raid4.state.root" }, "raid4" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid5.buff", "raid5.state.root" }, "raid5" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid6.buff", "raid6.state.root" }, "raid6" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid7.buff", "raid7.state.root" }, "raid7" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid8.buff", "raid8.state.root" }, "raid8" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid9.buff", "raid9.state.root" }, "raid9" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid10.buff", "raid10.state.root" }, "raid10" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid11.buff", "raid11.state.root" }, "raid11" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid12.buff", "raid12.state.root" }, "raid12" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid13.buff", "raid13.state.root" }, "raid13" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid14.buff", "raid14.state.root" }, "raid14" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid15.buff", "raid15.state.root" }, "raid15" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid16.buff", "raid16.state.root" }, "raid16" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid17.buff", "raid17.state.root" }, "raid17" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid18.buff", "raid18.state.root" }, "raid18" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid19.buff", "raid19.state.root" }, "raid19" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!player.buff", "player.state.snare" }, "player" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!lowest.buff", "lowest.state.snare" }, "lowest" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid2.buff", "raid2.state.snare" }, "raid2" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid3.buff", "raid3.state.snare" }, "raid3" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid4.buff", "raid4.state.snare" }, "raid4" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid5.buff", "raid5.state.snare" }, "raid5" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid6.buff", "raid6.state.snare" }, "raid6" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid7.buff", "raid7.state.snare" }, "raid7" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid8.buff", "raid8.state.snare" }, "raid8" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid9.buff", "raid9.state.snare" }, "raid9" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid10.buff", "raid10.state.snare" }, "raid10" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid11.buff", "raid11.state.snare" }, "raid11" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid12.buff", "raid12.state.snare" }, "raid12" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid13.buff", "raid13.state.snare" }, "raid13" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid14.buff", "raid14.state.snare" }, "raid14" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid15.buff", "raid15.state.snare" }, "raid15" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid16.buff", "raid16.state.snare" }, "raid16" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid17.buff", "raid17.state.snare" }, "raid17" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid18.buff", "raid18.state.snare" }, "raid18" },
{ "Hand of Freedom", {"!lastcast(Hand of Freedom)","!raid19.buff", "raid19.state.snare" }, "raid19" },
},"toggle.AutoHands"},

---------------------------
--      EMERGENCY/Proc   --
---------------------------
{{
{"Flash of Light",{"!player.moving","tank.health <= 60", "tank.range <= 40","player.spell(Holy Shock).cooldown > 1"},"tank"},
{"Flash of Light",{"!player.moving","lowest.health <= 50", "lowest.range <= 40","player.spell(Holy Shock).cooldown > 1"},"lowest"},
{"Flash of Light",{"!player.moving","tank.health <= 50", "tank.range <= 40","player.holypower = 5"},"tank"},
{"Flash of Light",{"!player.moving","lowest.health <= 40", "lowest.range <= 40","player.holypower = 5"},"lowest"},
{"Flash of Light",{"!player.moving","tank.health <= 40", "tank.range <= 40"},"tank"},
{"Flash of Light",{"!player.moving","lowest.health <= 30", "lowest.range <= 40"},"lowest"},
},"!modifier.raid"},

{"Holy Shock",{"lowest.health <= 96", "lowest.range <= 40", "player.holypower < 5","!player.buff(105809)"},"lowest"},
{"Holy Shock",{"lowest.health <= 96", "lowest.range <= 40", "player.holypower < 3","player.buff(105809)"},"lowest"},

{"Execution Sentence",{"tank.health <= 80", "tank.range <= 40", "talent(6,3)","player.spell(Holy Shock).cooldown > 1"},"tank"},
{"Execution Sentence",{"lowest.health <= 70", "lowest.range <= 40","talent(6,3)","player.spell(Holy Shock).cooldown > 1"},"lowest"},
{"Holy Prism",{"@coreHealing.needsHealing(95,3)", "target.range <= 40", "talent(6,1)","target.enemy"},"target"},
{"Execution Sentence",{"tank.health <= 80", "tank.range <= 40", "talent(6,3)","player.holypower = 5"},"tank"},
{"Execution Sentence",{"lowest.health <= 70", "lowest.range <= 40","talent(6,3)","player.holypower = 5"},"lowest"},
{"Holy Prism",{"@coreHealing.needsHealing(95,5)", "target.range <= 40", "talent(6,1)","player.holypower = 5"},"target"},

{"Flash of Light",{"!player.moving","tank.health <= 40", "tank.range <= 40","player.spell(Holy Shock).cooldown > 1"},"tank"},
{"Flash of Light",{"!player.moving","lowest.health <= 30", "lowest.range <= 40","player.spell(Holy Shock).cooldown > 1"},"lowest"},

{"Flash of Light",{"!player.moving","tank.health <= 40", "tank.range <= 40","player.holypower = 5"},"tank"},
{"Flash of Light",{"!player.moving","lowest.health <= 30", "lowest.range <= 40","player.holypower = 5"},"lowest"},


---------------------------
--  SAcRED SHIELD   CR  --
---------------------------
{{--Start SS CR
  --148039 Sacred shield buff
--105809 Holy avenger
{"Light of Dawn",{"!player.moving","@coreHealing.needsHealing(96,2)", "lowest.range <= 40","player.buff(90174)"},"tank"},
--add agro too SS



{"Light of Dawn",{"!player.moving","player.holypower == 5","@coreHealing.needsHealing(96,5)", "lowest.range <= 40"},"lowest"},
{"Light of Dawn",{"!player.moving","player.holypower == 5","@coreHealing.needsHealing(93,4)", "lowest.range <= 40"},"lowest"},
{"Light of Dawn",{"!player.moving","player.holypower == 5","@coreHealing.needsHealing(90,3)", "lowest.range <= 40"},"lowest"},

{"Light of Dawn",{"!player.moving","player.holypower >= 3","@coreHealing.needsHealing(88,5)", "lowest.range <= 40"},"lowest"},
{"Light of Dawn",{"!player.moving","player.holypower >= 3","@coreHealing.needsHealing(80,3)", "lowest.range <= 40"},"lowest"},
{"Light of Dawn",{"!player.moving","player.holypower >= 3","@coreHealing.needsHealing(75,2)", "lowest.range <= 40"},"lowest"},

{"Sacred Shield",{"player.spell(Holy Shock).cooldown > 1","!lastcast(Sacred Shield)","tank.buff(148039).duration <= 5","tank.range <= 40", "tank.health <= 99" },"tank"},
{"Sacred Shield",{"player.spell(Holy Shock).cooldown > 1","!lastcast(Sacred Shield)","lowest.range <= 40", "lowest.buff(148039).duration <= 5","player.spell(Sacred Shield).charges >= 1", "lowest.health <= 95"},"lowest"},
{"Sacred Shield",{"player.holypower = 5","!lastcast(Sacred Shield)","tank.buff(148039).duration <= 5","tank.range <= 40", "tank.health <= 99" },"tank"},
{"Sacred Shield",{"player.holypower = 5","!lastcast(Sacred Shield)","lowest.range <= 40", "lowest.buff(148039).duration <= 5","player.spell(Sacred Shield).charges >= 1", "lowest.health <= 95"},"lowest"},





{{
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(75,6)","player.holypower < 5","!player.buff(105809)"},"lowest"},
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(75,6)","player.holypower < 3","player.buff(105809)"},"lowest"},
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(65,5)","player.holypower < 5","!player.buff(105809)"},"lowest"},
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(65,5)","player.holypower < 3","player.buff(105809)"},"lowest"},
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(55,4)","player.holypower < 5","!player.buff(105809)"},"lowest"},
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(55,4)","player.holypower < 3","player.buff(105809)"},"lowest"},
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(45,3)","player.holypower < 5","!player.buff(105809)"},"lowest"},
{"Holy Radiance",{"player.mana >= 20","@coreHealing.needsHealing(45,3)","player.holypower < 3","player.buff(105809)"},"lowest"},
},"toggle.HRad"},
--{"Word of Glory",{"!@coreHealing.needsHealing(95, 4)","player.holypower = 5","lowest.health <= 77","lowest.range <= 40", "!player.moving"},"lowest"},
--{"Word of Glory",{"!@coreHealing.needsHealing(95, 4)","player.holypower = 5","lowest.health <= 88","tank.range <= 40", "!player.moving"},"tank"},
{"Holy Light",{"lowest.health <= 85","lowest.range <= 40", "!player.moving","player.spell(Holy Shock).cooldown > 1"},"lowest"},
{"Holy Light",{"tank.health <= 92","tank.range <= 40", "!player.moving","player.spell(Holy Shock).cooldown > 1"},"tank"},
{"Holy Light",{"lowest.health <= 85","lowest.range <= 40", "!player.moving","player.holypower = 5"},"lowest"},
{"Holy Light",{"tank.health <= 92","tank.range <= 40", "!player.moving","player.holypower = 5"},"tank"},

},"talent(3,3)"},--End SS CR


---------------------------
-- TARGETING AND FOCUS  --
---------------------------
{{
{ "/targetenemy [noexists]", "!target.exists" },
{ "/focus [@targettarget]",{ "target.enemy","target(target).friend" } },
{ "/target [target=focustarget, harm, nodead]", "target.range > 40" },
}, "toggle.AutoTarget"},


},{  --OOC
---------------------------
--       Blessings      --
---------------------------
{ "20217", {"!player.buffs.stats" ,"toggle.Blessing" }, "player" },
{ "19740", { "!player.buffs.mastery" ,"!toggle.Blessing" }, "player" },

},function()
  NetherMachine.toggle.create('Blessing', 'Interface\\Icons\\spell_magic_greaterblessingofkings', 'Blessings','On for Kings off for Might')
  NetherMachine.toggle.create('HRad', 'Interface\\Icons\\spell_paladin_divinecircle', 'Holy Radiance','Toggle on/off use of Holy Radiance')
  NetherMachine.toggle.create('AutoHands', 'Interface\\Icons\\spell_holy_sealofwisdom', 'Automatic Hands Usage','SAC/BoP/Freedom Automatic Usage Not for Pros')
  NetherMachine.toggle.create('AutoTarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target and Focus','Target boss and focus currently active Tank')
end)
