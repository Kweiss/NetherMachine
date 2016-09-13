--[[
Interface file for Destruction [Mirakuru Profiles]
Created by Mirakuru
]]
mirakuru_destru_config = {
key = "miraDestruConfig",
profiles = true,
title = "Destruction Warlock",
subtitle = "Configuration",
color = "005522",
width = 250,
height = 450,
config = {
{type = "spacer"},
{
type = "texture",texture = "Interface\\AddOns\\NetherMachine_Mirakuru\\interface\\media\\splash.blp",
width = 100,
height = 100,
offset = 70,
y = 40,
center = true
},
{type = "spacer"},{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "General Settings",
align = "center",
},
{type = "rule"},
{
type = "checkbox",
default = false,
text = "Auto Target",
key = "auto_target",
desc = "Set new target if your target is dead or you have no target."
},
{type = "spacer"},
{
type = "checkbox",
default = false,
text = "Force Attack",
key = "force_attack",
desc = "Force attack your target even if not in combat!"
},
{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Use Cataclysm in Single-target rotation.",
key = "cata_st",
desc = "Enables the use of Cataclysm in both the single-target and AOE rotations."
},
{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Only use cooldowns on bosses.",
key = "cd_bosses_only",
desc = "Forces the combat rotation to only use long-term cooldowns on Boss type units."
},
{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Command Demon",
key = "command_demon",
desc = "Enables the Combat Rotation to control your demon for you in combat using smart-logic."
},
{type = "spacer"},
{
type = "checkspin",
default_check = true,
default_spin = 35,
width = 50,
text = "Healing Tonic \ Healthstone",
key = "hs_pot_healing",
desc = "Enable automatic usage of Healing Tonic or Healthstone when your HP drops bellow this %."
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Destruction Specific Settings",
align = "center",
},
{type = "rule"},
{
type = "spinner",
text = "Minimum Embers for Dark Soul",
key = "embers_darksoul",
width = 50,
min = 0,
max = 40,
default = 9,
step = 1,
desc = "Minimum Embers required before casting Dark Soul: Instability."
},
{type = "spacer"},
{
type = "spinner",
text = "Max Embers for Chaos Bolt",
key = "embers_cb_max",
width = 50,
min = 0,
max = 40,
default = 30,
step = 1,
desc = "This setting is ignored with temporary crit buffs! Maximum Embers before casting Chaos Bolt."
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "AOE Settings",
align = "center",
},
{type = "rule"},
{
type = "spinner",
text = "AOE Unit Count",
key = "aoe_units",
width = 50,
default = 4,
desc = "When enabled, start AoEing at this unit threshold."
},
{type = "spacer"},{type = "spacer"},
{
type = "spinner",
text = "Min. Embers for Fire and Brimstone",
key = "embers_fnb",
width = 50,
min = 0,
max = 40,
default = 15,
step = 1,
desc = "Minimum embers before casting Fire and Brimstone to start AOEing."
},
{type = "spacer"},
{
type = "spinner",
text = "AoE Chaos Bolt minimum units",
key = "cb_fnb_units",
width = 50,
min = 0,
max = 40,
default = 4,
step = 1,
desc = "Minimum units in range required to cast Chaos Bolt with Fire and Brimstone without Charred Remains."
},
{type = "spacer"},
{
type = "spinner",
text = "AoE Chaos Bolt minimum Embers",
key = "cb_fnb_embers",
width = 50,
min = 0,
max = 40,
default = 25,
step = 1,
desc = "Minimum Embers to cast Chaos Bolt during Fire and Brimstone with Charred Remains."
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Grimoire & Pet Settings",
align = "center",
},
{type = "rule"},
{
type = "checkbox",
default = true,
text = "Auto Summon Pet",
key = "auto_summon_pet",
desc = "Automatically summon the selected pet when it's dead or no pets are active!"
},
{
type = "checkbox",
default = true,
text = ".. and only using instant abilities.",
key = "auto_summon_pet_instant",
desc = "Only summon a pet in combat using instant abilities."
},
{
type = "dropdown",
text = "Select Pet",
key = "summon_pet",
list = {
{
text = "Imp",
key = "688"
},
{
text = "Voidwalker",
key = "697"
},
{
text = "Felhunter",
key = "691"
},
{
text = "Succubus",
key = "712"
},
{
text = "Doomguard",
key = "157757"
},
{
text = "Infernal",
key = "157898"
}
},
desc = "Set which pet to summon or sacrifice.",
default = "691",
},
{type = "spacer"},{type = "spacer"},
{
type = "dropdown",
text = "Select Service Pet",
key = "service_pet",
list = {
{
text = "Imp",
key = "111859"
},
{
text = "Voidwalker",
key = "111895"
},
{
text = "Felhunter",
key = "111897"
},
{
text = "Succubus",
key = "111896"
},
{
text = "Doomguard",
key = "157906"
},
{
text = "Infernal",
key = "157907"
}
},
desc = "Set which pet use for Grimoire of Service.",
default = "111897",
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Defensive Settings",
align = "center",
},
{type = "rule"},
{
type = "checkspin",
text = "Dark Regeneration",
key = "darkregen_hp",
default_spin = 40,
width = 50,
default_check = true,
desc = "Activates after reaching this HP value."
},
{
type = "spinner",
text = "Incoming Healing",
key = "darkregen_healing",
width = 50,
min = 1000,
max = 20000,
default = 15000,
step = 100,
desc = "Incoming healing required to activate Dark Regeneration."
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Talent Settings",
align = "center",
},
{type = "rule"},
{
type = "checkspin",
text = "Mortal Coil",
key = "mortal_coil",
default_spin = 85,
width = 50,
default_check = true,
desc = "Use at or under this HP value."
},
{
type = "checkspin",
text = "Burning Rush",
key = "burning_rush",
default_spin = 70,
width = 50,
default_check = true,
desc = "Minimum health required for Burning Rush."
}
}
}



--[[
Destruction Warlock - Custom NetherMachine Rotation Profile
Created by Mirakuru

Fully updated for Warlords of Draenor!
- More advanced encounter-specific coming with the release of WoD raids
]]
-- Dynamically evaluate settings
local fetch = NetherMachine.interface.fetchKey

local function dynamicEval(condition, spell)
if not condition then return false end
return NetherMachine.dsl.parse(condition, spell or '')
end

-- Pet Functions
function destru_pet()
local pet = tonumber(fetch('miraDestruConfig', 'summon_pet'))
local spellName = GetSpellName(pet)

if UnitCastingInfo("player") == GetSpellInfo(pet) then return false end

if NetherMachine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end

if pet == 157757 or pet == 157898 then
if NetherMachine.dsl.parse("talent(7, 3)") then CastSpellByName(spellName)
else return false end
else CastSpellByID(pet) end
end
function destru_service_pet()
local pet = tonumber(fetch('miraDestruConfig', 'service_pet'))
local spellName = GetSpellName(pet)

if NetherMachine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end
if NetherMachine.dsl.parse("talent(5, 2)") then CastSpellByName(spellName) end
end

-- Buttons
local btn = function()
NetherMachine.toggle.create('mdots', 'Interface\\Icons\\spell_fire_felimmolation.png', 'Mousover Dotting', "Enables mouseover-dotting within the combat rotation.")
NetherMachine.toggle.create('aoe', 'Interface\\Icons\\ability_warlock_fireandbrimstone.png', 'AOE', "Enables the AOE rotation within the combat rotation.")
NetherMachine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() miLib.displayFrame(mirakuru_destru_config) end))

-- Force open/close to save default settings
miLib.displayFrame(mirakuru_destru_config)
miLib.displayFrame(mirakuru_destru_config)
end

-- Combat Rotation
local combatRotation = {
-- Auto target enemy when Enabled
{{
{"/targetenemy [noexists]", "!target.exists"},
{"/targetenemy [dead]", {"target.exists", "target.dead"}}
}, (function() return fetch('miraDestruConfig', 'auto_target') end)},

-- Healing Tonic / Healthstone
{{
{{
{"#5512"},
{"#109223"}
}, "player.glyph(56224)"},
{{
{"#109223"},
{"#5512"}

}, "!player.glyph(56224)"}
}, {
(function() return fetch('miraDestruConfig', 'hs_pot_healing_check') end),
(function() return dynamicEval('player.health <= '..fetch('miraDestruConfig', 'hs_pot_healing_spin')) end)
}},

-- Dark Intent
{"!109773", "!player.buffs.multistrike"},
{"!109773", "!player.buffs.spellpower"},

-- Burning Rush
{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
{{
{"/cancelaura "..GetSpellInfo(111400), {
"player.buff(111400)",
(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'burning_rush_spin')) end)
}}
}, (function() return fetch('miraDestruConfig', 'burning_rush_check') end)},

-- Summon Pet
{{
{"!120451", {
"!pet.alive",
"!pet.exists",
"player.embers > 10",
"!player.buff(108503)",
"player.spell(120451).cooldown = 0",
(function() return fetch('miraDestruConfig', 'auto_summon_pet_instant') end)
}},

{"/run destru_pet()", {
"!pet.alive",
"!pet.exists",
"!player.dead",
"!player.moving",
"!player.buff(108503)",
"timeout(petCombat, 3)",
(function() return fetch('miraDestruConfig', 'auto_summon_pet') end)
}}
}},

-- Cooldown Management --
{{
{"#trinket1"},
{"#trinket2"},
{"!26297", {"player.spell(26297).cooldown = 0", "!player.hashero"}},
{"!33702", "player.spell(33702).cooldown = 0"},
{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},
{"!18540", {"!talent(7, 3)", "player.spell(18540).cooldown = 0"}},
{"!112927", {"!talent(7, 3)", "talent(5, 1)", "player.spell(112927).cooldown = 0"}},
{{
{"!113858", "player.spell(113858).charges = 2"},
{"!113858", "int.procs > 0"},
{"!113858", "target.health <= 10"}
}, {
"talent(6, 1)", "player.spell(113858).charges > 0",
(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
}},
{"!113858", {
"!talent(6, 1)", "player.spell(113858).cooldown = 0",
(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
}},
{"/run destru_service_pet()", "talent(5, 2)"}
}, {
"modifier.cooldowns",
(function()
if fetch('miraDestruConfig', 'cd_bosses_only') then
if miLib.unitBoss("target") then return true else return false end
else return true end
end)
}},

-- Command Demon --
{{
{"/petattack", {"timeout(petAttack, 1)", "pet.exists", "pet.alive"}},
{"119913", "player.pet(115770).spell", "target.ground"},
{"119909", "player.pet(6360).spell", "target.ground"},
{"119911", {"player.pet(115781).spell"}},
{"119910", {"player.pet(19467).spell"}},
{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
{"119905", {"player.pet(115276).spell", "player.health < 80"}},
{"119905", {"player.pet(89808).spell", "player.health < 80"}}
}, {(function() return fetch('miraDestruConfig', 'command_demon') end), "pet.exists", "pet.alive"}},

-- Talents --
{{
{"!108359", {
"talent(1, 1)",
(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'darkregen_hp_spin')) end),
"player.spell(108359).cooldown = 0",
(function() return (UnitGetIncomingHeals("player") >= fetch('miraDestruConfig', 'darkregen_healing') and true or false) end)
}}
}, (function() return fetch('miraDestruConfig', 'darkregen_hp_check') end)},
{{
{"6789", {
"talent(2, 2)",
(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'mortal_coil_spin')) end),
"player.spell(6789).cooldown = 0"
}}
}, (function() return fetch('miraDestruConfig', 'mortal_coil_check') end)},
{"!30283", {"talent(2, 3)", "modifier.ralt", "player.spell(30283).cooldown = 0"}, "ground"},
{"!111400", {
"talent(4, 2)", "player.moving", "!player.buff(111400)",
(function() return fetch('miraDestruConfig', 'burning_rush_check') end),
(function() return dynamicEval("player.health > " .. fetch('miraDestruConfig', 'burning_rush_spin')) end)
}},
{"!108503", {
"talent(5, 3)",
"!player.buff(108503)",
"player.spell(108503).cooldown = 0",
"pet.exists",
"pet.alive"
}},
{"!137587", {"talent(6, 2)", "player.moving", "player.spell(137587).cooldown = 0"}},

-- Rain of Fire hotkey --
{"104232", "modifier.lalt", "mouseover.ground"},

-- Immolate Mouseover --
{{
{"348", "!mouseover.debuff(157736)", "mouseover"}
}, {"!player.target(mouseover)", "mouseover.enemy(player)", "toggle.mdots"}},

-- RoF Target while moving
{"104232", {"player.moving", "target.distance <= 20", "!target.debuff(104232)"}, "target.ground"},

-- AoE Rotation --
{{
{"152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0", "!player.moving"}, "target.ground"},
{"108683", "!player.buff(108683)"},
{"108686", {"!target.debuff(157736)", "!player.moving"}},
{"157701", {
"talent(7, 1)",
(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'cb_fnb_embers')) end)
}},
{"108685", "player.spell(108685).charges > 0"},
{"114654", "!player.moving"}
}, {
"toggle.aoe",
(function()
if FireHack then
if dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) then
if dynamicEval("target.area(10).enemies >= "..fetch('miraDestruConfig', 'aoe_units')) then return true else return false end
else return false end
else
if dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) then
if NetherMachine.condition["modifier.control"]() then return true else return false end
else return false end
end
end)
}},


-- Single Target Rotation --
{{
-- Fire and Brimstone
{"/cancelaura "..GetSpellInfo(108683), "player.buff(108683)"},

-- Havoc
{{{"!80240", "@miLib.manager(80240)"}}, "modifier.multitarget"},

-- Shadowburn
{{
-- Shadowburn: Multitarget
{{
{"!17877", "@miLib.manager(17877, 0, 20)"}
}, "modifier.multitarget"},

-- Shadowburn: Target
{{
{"!17877", "player.embers >= 30"},
{"!17877", "player.buff(113858)"},
{"!17877", "target.ttd < 10"}
}, "target.health <= 20"}
}, "player.embers >= 10"},

-- Emergency Immolate
{{
{"348", {"talent(7, 2)", "player.spell(152108).cooldown > 1.5"}},
{"348", "!talent(7, 2)"}
}, {
"!player.moving",
"!modifier.last(348)",
"target.debuff(157736)",
"target.debuff(157736).duration < 1.5",
(function()
if dynamicEval("player.buff(80240).count >= 3") then
if dynamicEval("player.embers >= 10") then return false else return true end
else return true end
end)
}},

-- Chaos Bolt, close to capping embers
{"116858", {"player.time < 5", "player.embers > 35"}},

-- Cleaving time
{{
{"!17877", {"target.health <= 20", "player.buff(80240)"}},
{"!116858", {
"target.health > 20", "!player.moving", "!player.casting(116858)", "player.buff(80240).count >= 3",
(function() return dynamicEval("player.buff(80240).duration >= "..miLib.round((2.5/((GetHaste("player")/100)+1)),2)) end)
}}
}, "player.embers >= 10"},

-- Cataclysm
{"152108", {"talent(7, 2)", (function() return fetch('miraDestruConfig', 'cata_st') end), "player.spell(152108).cooldown = 0", "!player.moving"}, "target.ground"},

-- Prevent normal spells while Havoc is active
{{
-- Conflagrate
{"17962", {"player.spell(17962).charges = 2", "target.debuff(157736)"}},

-- Chaos Bolt
{{
{"116858", "player.int.procs > 0"},
{"116858", "player.crit.procs > 0"},
{"116858", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)},
{"116858", (function() return dynamicEval("player.buff(113858).duration >= "..miLib.round((2.5 / ((GetHaste("player") / 100)  + 1)),2)) end)},
{"116858", {"target.ttd >= 4", "target.ttd < 20"}}
}, {"player.buff(117828).count < 3", "player.embers >= 10", "!player.moving"}},

-- Immolate
{"348", {"target.debuff(157736).duration < 4.5", "!player.moving", "!modifier.last(348)", "!player.buff(113858)"}},
{"348", {"!target.debuff(157736)", "!player.moving", "!modifier.last(348)"}},

-- Conflagrate
{"17962", "player.spell(17962).charges > 0"},

-- Immolate multidotting
{{{"348", "@miLib.manager(348, 4)"}}, {"modifier.multitarget", "!player.moving"}},

-- Incinerlol
{"29722", "!player.moving"}
}, {
(function()
if dynamicEval("player.buff(80240).count >= 3") then
if dynamicEval("player.embers >= 10") then return false else return true end
else return true end
end)
}}
},
(function()
if FireHack then
if NetherMachine.config.read('button_states', 'aoe', false) then
  if dynamicEval("target.area(10).enemies >= "..fetch('miraDestruConfig', 'aoe_units')) then
    if dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) then return false else return true end
    else return true end
    else return true end
  else
    if NetherMachine.config.read('button_states', 'aoe', false) then
      if NetherMachine.condition["modifier.control"]() then
        if dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) then return false else return true end
        else return true end
        else return true end
      end
      end)
    }
  }

  -- Out of Combat
  local beforeCombat = {
    --{"#110293", "!player.buff(158038)"},
    --[[{"#118391", {
    "!modifier.last(174471)",
    "!player.buff(131490)",
    (function()
    local hasEnchant,time,_,_,_,_ = GetWeaponEnchantInfo()
    if not hasEnchant then return true end
    if hasEnchant and time/1000 < 5 then return true end
    end)
    }},]]

    -- Dark Intent
    {"109773", "!player.buffs.multistrike"},
    {"109773", "!player.buffs.spellpower"},

    -- Summon Pet --
    {"/run destru_pet()", {
      "!pet.exists", "!pet.alive", "!player.moving", "!player.buff(108503)", "timeout(petOOC, 3)", "!player.dead",
      (function() return fetch('miraDestruConfig', 'auto_summon_pet') end)
      }},

      -- Talents --
      {{
        {"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
        {"/cancelaura "..GetSpellInfo(111400), {
          "player.buff(111400)",
          (function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'burning_rush_spin')) end)
          }}
          }, (function() return fetch('miraDestruConfig', 'burning_rush_check') end)},
          {"108503", {
            "talent(5, 3)",
            "!player.buff(108503)",
            "player.spell(108503).cooldown = 0",
            "pet.exists",
            "pet.alive"
            }},
            {"!30283", {
              "talent(2, 3)",
              "modifier.ralt",
              "player.spell(30283).cooldown = 0"
              }, "mouseover.ground"},

              -- Auto combat
              {{
                {"/tar Poundfist"},
                {"/cast "..GetSpellInfo(17962), "target.alive"}
                }, (function() return fetch('miraDestruConfig', 'force_attack') end)}
              }

              -- Register our rotation
              NetherMachine.rotation.register_custom(267, "[|cff005522Mirakuru Rotations|r] Destruction Warlock", combatRotation, beforeCombat, btn)
