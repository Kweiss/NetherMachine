local bloodTap = {
  { {
    { "Blood Tap", "player.runes(unholy).count = 0" },
    { "Blood Tap", "player.runes(frost).count = 0" },
    { "Blood Tap", "player.runes(blood).count = 0" },
  }, "player.buff(Blood Charge).count >= 5" },
}

local plagueLeech = {
  { {
    { {
      { "Plague Leech", "player.runes(unholy).frac <= 0.95" },
      { "Plague Leech", "player.runes(frost).frac <= 0.95" },
      { "Plague Leech", "player.runes(blood).frac <= 0.95" },
    }, "player.spell(Outbreak).cooldown = 0" },
    { {
      { "Plague Leech", "player.runes(unholy).frac <= 0.95" },
      { "Plague Leech", "player.runes(frost).frac <= 0.95" },
      { "Plague Leech", "player.runes(blood).frac <= 0.95" },
    }, "target.debuff(Blood Plague).duration < 3" },
  },{
    "target.debuff(Blood Plague)", "target.debuff(Frost Fever)"
  } },
}

local outbreak = {
  { "Outbreak", { "target.debuff(Frost Fever).duration < 3", "target.debuff(Blood Plague).duration < 3" }, "target" },
}

local defile = {
  { "Defile", "player.time > 5", "target.ground" },
  { "Defile", { "modifier.xkey", "target.exists" }, "target.ground" },
  { "Defile", { "modifier.xkey", "!target.exists" }, "ground" },
}

local runicEmpower = {
  { {
    { "Frost Strike", "player.runes(frost).count = 0" },
    { "Frost Strike", "player.runes(unholy).count = 0" },
    { "Frost Strike", "player.runes(blood).count = 0" },
  },{
    "!player.buff(Killing Machine)", "player.spell(Obliterate).cooldown > 1"
  } },
}

local singleTarget = {
  { defile },
  { "Howling Blast", { "target.debuff(Frost Fever).duration > 5", "target.debuff(Blood Plague).duration > 5", "player.buff(Killing Machine)", "player.buff(Freezing Fog)" } },
  { "Obliterate", "player.buff(Killing Machine)" },
  { "Howling Blast", { "!target.debuff(Frost Fever)", "player.buff(Freezing Fog)" } },
  { outbreak },
  { plagueLeech },
  { "Howling Blast", "!target.debuff(Frost Fever)" },
  { "Plague Strike", "!target.debuff(Blood Plague)" },
  { "Frost Strike", "player.runicpower > 75" },
  { "Howling Blast", { "player.buff(Freezing Fog)", "player.runes(blood).frac >= 1.8" } },
  { "Howling Blast", { "player.buff(Freezing Fog)", "player.runes(unholy).frac >= 1.8" } },
  { "Howling Blast", { "player.buff(Freezing Fog)", "player.runes(frost).frac >= 1.8" } },
  { "Obliterate", "player.runes(blood).frac >= 1.8" },
  { "Obliterate", "player.runes(unholy).frac >= 1.8" },
  { "Obliterate", "player.runes(frost).frac >= 1.8" },
  { runicEmpower },
  { "Howling Blast", "player.buff(Freezing Fog)" },
  { "Obliterate", "player.runes(blood).frac >= 1.5" },
  { "Obliterate", "player.runes(unholy).frac >= 1.6" },
  { "Obliterate", "player.runes(frost).frac >= 1.6" },
  { "Obliterate", "player.hashero" },
  { "Obliterate", "player.spell(Plague Leech).cooldown <= 4" },
  { "Frost Strike", "!player.buff(Killing Machine)" },
}


local multiTarget = {
  { outbreak },
  { defile },
  { "Howling Blast" },
  { "Plague Strike" },
  { "Frost Strike" },
  { plagueLeech },
}


NetherMachine.rotation.register_custom(251, 'Frost Death Knight', {
  { "Mind Freeze", "modifier.interrupts" },
  { "Strangualte", {  "modifier.interrupts", "!modifier.last(Mind Freeze)" } },
  { "Gift of the Naaru", "player.health <= 30" },
  { "Soul Reaper", "target.health <= 35" },
  { "Pillar of Frost", "modifier.cooldown" },
  { "Empower Rune Weapon", { "modifier.cooldowns", "player.runicpower <= 70", "player.runes(unholy).count = 0", "player.runes(frost).count = 0", "player.runes(blood).count = 0" } },
  { bloodTap },
  { multiTarget, { "modifier.multitarget", "target.area(10).enemies > 3" } },
  { singleTarget },
}, {

}, function()
  NetherMachine.condition.register("modifier.xkey", function()
    if FireHack then
      return GetKeyState(0x58)
    end
  end)
  NetherMachine.condition.register("runes.fac", function()
  end)
end)
