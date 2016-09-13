
--[[
Interface file for Affliction [Mirakuru Profiles]
Created by Mirakuru
]]
mirakuru_aff_config = {
key = "miraAffConfig",
profiles = true,
title = "Affliction Warlock",
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
{type = "spacer"},
{
type = "checkbox",
default = true,
text = "Save Haunt for Bosses",
key = "haunt_boss",
desc = "Prevents usage of Haunt on any units besides rares, rare-elites and bosses."
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
default = 5,
width = 50,
desc = "When enabled, start AoEing at this unit threshold."
},
{type = "spacer"},{type = "spacer"},
{
type = "header",
text = "Multi-dotting Settings",
align = "center",
},
{type = "rule"},
{
type = "spinner",
text = "Agony Count",
key = "agony_units",
default = 4,
width = 50,
desc = "How many units to cast Agony on when multidotting."
},
{
type = "spinner",
text = "Corruption Count",
key = "corruption_units",
default = 4,
width = 50,
desc = "How many units to cast Corruption on when multidotting."
},
{
type = "spinner",
text = "Unstable Affliction Count",
key = "ua_units",
default = 4,
width = 50,
desc = "How many units to cast Unstable Affliction on when multidotting."
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
Affliction Warlock - Custom NetherMachine Rotation Profile
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
function aff_pet()
local pet = tonumber(fetch('miraAffConfig', 'summon_pet'))
local spellName = GetSpellName(pet)

if UnitCastingInfo("player") == GetSpellInfo(pet) then return false end

if NetherMachine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end

if pet == 157757 or pet == 157898 then
if NetherMachine.dsl.parse("talent(7, 3)") then CastSpellByName(spellName)
else return false end
else CastSpellByID(pet) end
end
function aff_service_pet()
local pet = tonumber(fetch('miraDestruConfig', 'service_pet'))
local spellName = GetSpellName(pet)

if NetherMachine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end
if NetherMachine.dsl.parse("talent(5, 2)") then CastSpellByName(spellName) end
end

-- Buttons
local btn = function()
NetherMachine.toggle.create('mdots', 'Interface\\Icons\\spell_shadow_abominationexplosion.png', 'Mousover Dotting', "Enables mouseover-dotting within the combat rotation.")
NetherMachine.toggle.create('aoe', 'Interface\\Icons\\spell_shadow_seedofdestruction.png', 'AOE', "Enables the AOE rotation within the combat rotation.")
NetherMachine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() miLib.displayFrame(mirakuru_aff_config) end))

-- Force open/close to save default settings
miLib.displayFrame(mirakuru_aff_config)
miLib.displayFrame(mirakuru_aff_config)
end

-- Combat Rotation
local combatRotation = {
-- Misc --
{{	-- Autotarget
{"/targetenemy [noexists]", "!target.exists"},
{"/targetenemy [dead]", {"target.exists", "target.dead"}}
}, (function() return fetch('miraAffConfig', 'auto_target') end)},


-- Cancel Burning Rush
{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
{{
{"/cancelaura "..GetSpellInfo(111400), {
"player.buff(111400)",
(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'burning_rush_spin')) end)
}}
}, (function() return fetch('miraAffConfig', 'burning_rush_check') end)},


-- Defensive Abilities --
{{	-- Healing Tonic / Healthstone
{{
{"#5512"},
{"#109223"}
}, "player.glyph(56224)"},
{{
{"#109223"},
{"#5512"}

}, "!player.glyph(56224)"}
}, {
(function() return fetch('miraAffConfig', 'hs_pot_healing_check') end),
(function() return dynamicEval('player.health <= '..fetch('miraAffConfig', 'hs_pot_healing_spin')) end)
}},

-- Dark Intent
{"!109773", "!player.buffs.multistrike"},
{"!109773", "!player.buffs.spellpower"},


-- Talents --
{{
{"!108359", {
"talent(1, 1)",
(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'darkregen_hp_spin')) end),
"player.spell(108359).cooldown = 0",
(function() return (UnitGetIncomingHeals("player") >= fetch('miraAffConfig', 'darkregen_healing') and true or false) end)
}}
}, (function() return fetch('miraAffConfig', 'darkregen_hp_check') end)},
{{
{"6789", {
"talent(2, 2)",
(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'mortal_coil_spin')) end),
"player.spell(6789).cooldown = 0"
}}
}, (function() return fetch('miraAffConfig', 'mortal_coil_check') end)},
{"!30283", {"talent(2, 3)", "modifier.ralt", "player.spell(30283).cooldown = 0"}, "mouseover.ground" },
{"!111400", {
"talent(4, 2)", "player.moving", "!player.buff(111400)",
(function() return fetch('miraAffConfig', 'burning_rush_check') end),
(function() return dynamicEval("player.health > " .. fetch('miraAffConfig', 'burning_rush_spin')) end)
}},
{"!108503", {
"talent(5, 3)",
"!player.buff(108503)",
"player.spell(108503).cooldown = 0",
"pet.exists",
"pet.alive"
}},
{"!137587", {"talent(6, 2)", "player.moving", "player.spell(137587).cooldown = 0"}},
{"152108", {"talent(7, 2)", (function() return fetch('miraAffConfig', 'cata_st') end), "player.spell(152108).cooldown = 0", "!player.moving"}, "target.ground"},


-- Summon Pet
{{
{{	-- Summon pet using instant abilities
{"!74434", {
"!pet.alive",
"!pet.exists",
"!player.dead",
"!player.buff(74434)",
"player.soulshards > 0",
"player.spell(688).cooldown = 0",
(function() return fetch('miraAffConfig', 'auto_summon_pet_instant') end)
}},
{"/run aff_pet()", {
"!pet.alive",
"!pet.exists",
"!player.dead",
"player.buff(74434)",
"!player.buff(108503)",
"timeout(petCombat, 3)",
"player.spell(688).cooldown = 0"
}}
}, (function() return fetch('miraAffConfig', 'auto_summon_pet_instant') end)},

-- Summon pet without instant abilities
{"/run aff_pet()", {
"!pet.alive",
"!pet.exists",
"!player.dead",
"!player.moving",
"!player.buff(74434)",
"!player.buff(108503)",
"timeout(petCombat, 3)",
"player.spell(688).cooldown = 0"
}}
}, (function() return fetch('miraAffConfig', 'auto_summon_pet') end)},


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
}, {(function() return fetch('miraAffConfig', 'command_demon') end), "pet.exists", "pet.alive"}},


-- Cooldown Management --
{{
-- Arcane Torrent (Blood Elf)
{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},

-- Doomguard / Terrorguard
{"!18540", {"!talent(7, 3)", "player.spell(18540).cooldown = 0"}},
{"!112927", {"!talent(7, 3)", "talent(5, 1)", "player.spell(112927).cooldown = 0"}},

-- We only want to use CDs together
{{
-- Trinkets
{"#trinket1"},
{"#trinket2"},

-- Racials
{"!26297", "player.spell(26297).cooldown = 0"},
{"!33702", "player.spell(33702).cooldown = 0"},

-- Grimoire of Service
{"!/run service_pet()", {"talent(5, 2)", "player.spell(111859).cooldown = 0"}}
}, "player.buff(113860)"},


-- Dark Soul
{{
-- Dark Soul on procs and enemy close to dying
{{
{"!113860", "player.int.procs > 0"},
{"!113860", "player.crit.procs > 0"},
{"!113860", "player.haste.procs > 0"},
{"!113860", "player.mastery.procs > 0"},
{{
{"!113860", {"player.spell(113860).charges = 2", "target.ttd <= 50"}},
{"!113860", {"player.spell(113860).charges = 1", "target.ttd <= 30"}}
}, "target.ttd > 20"}
}, "!player.buff(113860)"},

-- Dark Soul when ready
{"!113860", {
"target.ttd > 60",
"target.debuff(980)",
"target.debuff(30108)",
"target.debuff(146739)",
"player.spell(113860).charges = 2"
}}
}, {"talent(6, 1)", "player.spell(113860).charges > 0"}},


-- Dark Soul without Archimonde's Darkness
{"!113860", {"!talent(6, 1)", "player.spell(113860).cooldown = 0"}}
}, {
"modifier.cooldowns",
(function()
if fetch('miraAffConfig', 'cd_bosses_only') then
if miLib.unitBoss("target") then return true else return false end
else return true end
end)
}},


-- Mouseover multidotting --
{{
{"!172", {"mouseover.debuff(146739).duration < 6", "!player.casting(48181)"}, "mouseover"},
{"!980", {"mouseover.debuff(980).duration < 6", "!player.casting(48181)"}, "mouseover"},
{"!30108", {"mouseover.debuff(30108).duration < 6", "!player.casting(48181)", "!player.moving", "!modifier.last(30108)"}, "mouseover"},
}, {"toggle.mdots", "!player.target(mouseover)", "mouseover.enemy(player)"}},


-- AOE Rotation --
{{
{"!108508", {"talent(6, 3)", "player.spell(108508).cooldown = 0"}},
{"152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0", "!player.moving"}, "target.ground"},
{"!74434", {
"!talent(7, 1)",
"!player.buff(74434)",
"!target.debuff(27243)",
"player.soulshards > 2",
"!target.debuff(114790)"
}},
{"!114790", {
"!talent(7, 1)",
"!player.moving",
"player.buff(74434)",
"!target.debuff(27243)",
"!target.debuff(114790)",
"!modifier.last(114790)"
}},
{"!27243", {"!target.debuff(27243)", "!target.debuff(114790)", "!modifier.last(114790)", "!player.moving"}},
{"103103", "!player.moving"},
{"1454", "player.health > 40"}
}, {
"toggle.aoe",
(function()
if FireHack then
if dynamicEval("target.area(10).enemies >= "..fetch('miraAffConfig', 'aoe_units')) then return true else return false end
else
if NetherMachine.condition["modifier.control"]() then return true else return false end
end
end)
}},

-- Main Combat Rotation --
{{
-- Soulburn
{{
{"!74434", {"player.soulshards >= 3", "player.shardregen > 15"}},
{"!74434", "player.soulshards = 4"},
{"!74434", "!player.buff(157698)"},
{"!74434", "player.buff(157698).duration <= 3"}
}, {
"talent(7, 1)",
"!player.buff(74434)",
"player.soulshards >= 2",
(function()
if fetch('miraAffConfig', 'haunt_boss') then
if miLib.unitBoss("target") then return true else return false end
else return true end
end)
}},

-- Haunt
{{
-- Haunt Logic
{{	-- Soulburn: Haunt
{"!48181", "player.buff(74434).duration <= 3"},
{"!48181", {"player.buff(157698)", "player.buff(157698).duration <= 3"}},
{"!48181", "!player.buff(157698)"}
}, "player.buff(74434)"},

-- Regular Haunt during Dark Soul
{{
{"!48181", "!target.debuff(48181)"},
{"!48181", "target.debuff(48181).duration <= 3"},
}, "player.buff(113860).duration > 5"},

-- Target close to dying
{{
{"!48181", {"player.soulshards = 4", "target.ttd <= 60"}},
{"!48181", {"player.soulshards = 3", "target.ttd <= 50"}},
{"!48181", {"player.soulshards = 2", "target.ttd <= 40"}},
{"!48181", {"player.soulshards = 1", "target.ttd <= 30"}}
}, "target.ttd > 1"},

-- Haunt when capped without SB: Haunt
{{
{"!48181", "player.soulshards = 4"},
{"!48181", "player.soulshards > 2"},
{"!48181", "player.int.procs > 0"},
{"!48181", "player.crit.procs > 0"},
{"!48181", "player.haste.procs > 0"},
{"!48181", "player.mastery.procs > 0"},
}, {"!talent(7, 1)", "target.debuff(48181).duration < 3"}},
-- Haunt Logic
}, {
"!player.moving",
"player.soulshards >= 1",
"player.spell.traveling",
(function()
if fetch('miraAffConfig', 'haunt_boss') then
if miLib.unitBoss("target") then return true else return false end
else return true end
end)
}},

-- Dots
{"!980", {"talent(7, 2)", "player.spell(152108).cooldown > 17", "target.debuff(980).duration < 4"}},
{"!980", {"!talent(7, 2)", "target.debuff(980).duration < 4"}},
{"!172", "target.debuff(146739).duration < 6"},
{"!30108", {"target.debuff(30108).duration < 6", "!player.moving", "!modifier.last(30108)"}},

-- Life Tap
{"1454", "player.mana < 40"},

-- Multidotting
{{
{"980", "@miLib.manager(980)"},
{"172", "@miLib.manager(172)"},
{"30108", "@miLib.manager(30108)"}
}, {"modifier.multitarget", "!player.buff(113860)"}},

-- Cast Corruption on our current target if it wasn't the last target
{"172", "target.corruption"},

-- Drain Soul
{"103103", "!player.moving"},

-- While moving
{"172", "player.moving"},
{"1454", "player.health > 40"}
},
(function()
if FireHack then
if NetherMachine.config.read('button_states', 'aoe', false) then
if dynamicEval("target.area(10).enemies >= "..fetch('miraAffConfig', 'aoe_units')) then return false else return true end
else return true end
else
if NetherMachine.condition["modifier.control"]() then return false else return true end
end
end)
}
}

-- Out of combat
local beforeCombat = {
-- Buffs
{"109773", "!player.buffs.multistrike"},
{"109773", "!player.buffs.spellpower"},

-- Burning Rush
{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
{{
{"/cancelaura "..GetSpellInfo(111400), {
"player.buff(111400)",
(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'burning_rush_spin')) end)
}}
}, (function() return fetch('miraAffConfig', 'burning_rush_check') end)},

-- Grimoire of Sacrifice
{"108503", {
"talent(5, 3)",
"!player.buff(108503)",
"player.spell(108503).cooldown = 0",
"pet.exists",
"pet.alive"
}},

-- Shadowfury
{"!30283", {
"talent(2, 3)",
"modifier.ralt",
"player.spell(30283).cooldown = 0"
}, "mouseover.ground"},

-- Summon Pet
{"/run aff_pet()", {
"!pet.exists", "!pet.alive", "!player.moving", "!player.buff(108503)", "timeout(affPet, 3)", "!player.dead",
(function() return fetch('miraAffConfig', 'auto_summon_pet') end)
}},

{{	-- Attack anything when Enabled (Corruption)
{"/cast "..GetSpellInfo(172), "target.alive"}
}, (function() return fetch('miraAffConfig', 'force_attack') end)}
}

-- Register our rotation
NetherMachine.rotation.register_custom(265, "bbWarlock Affliction (ALPHA)", combatRotation, beforeCombat, btn)
