-- NetherMachine Rotation
-- Guardian Druid - WoD 6.0.3
-- Updated on Jan 7th 2015

-- PLAYER CONTROLLED:
-- TALENTS: (Feline Swiftness or Wild Charge), Cenarion Ward, Typhoon, Soul of the Forest, Mighty Bash, Dream of Cenarius, Pulverize
-- GLYPHS: Glyph of Maul, Glyph of Rebirth, Glyph of Fae Silence, Glyph of Grace (minor)
-- CONTROLS: Pause - Left Control

NetherMachine.rotation.register_custom(104, "bbDruid Guardian (SimC T17N)", {
-- COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- AUTO TARGET
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead", "!target.friend" } },

	-- AUTO ATTACK
	{ {
		{ "Mark of the Wild", "@bbLib.engaugeUnit('ANY', 30, true)" },
	}, "toggle.autoattack" },

	-- BEAR FORM
	{ "Bear Form", { "!player.buff(Bear Form)", "!player.flying", "!player.buff(Dash)", "!modifier.last" } },

	-- INTERRUPTS
	{ "Skull Bash", "modifier.interrupt" },
	{ "Faerie Fire", { "modifier.interrupt", "player.glyph(114237)" } }, -- Glyph of Fae Silence (114237)
	{ "Faerie Fire", { "toggle.mouseovers", "mouseover.alive", "mouseover.enemy", "mouseover.interrupt", "player.glyph(114237)" }, "mouseover" }, -- Glyph of Fae Silence (114237)
	{ "Mighty Bash", { "talent(5, 3)", "modifier.interrupt" } },
	{ "War Stomp", { "modifier.interrupt", "target.range < 5" } },

	-- DREAM PROCS
	{ "Rebirth", { "target.exists", "target.friend", "target.dead", "player.buff(Dream of Cenarius).remains >= 1.5" }, "target" },

	-- RANGED PULLS
	{ "Faerie Fire", { "target.exists", "target.distance > 5" } },
	{ "Faerie Fire", { "toggle.mouseovers", "mouseover.exists", "mouseover.alive", "mouseover.enemy", "mouseover.distance > 5" }, "mouseover" },

	-- DEFENSIVE COOLDOWNS
	{ "#5512", { "toggle.consume", "player.health < 40" } }, -- Healthstone (5512)
	{ "#76097", { "toggle.consume", "player.health < 20", "target.boss" } }, -- Master Healing Potion (76097)
	{ {
		{ "Bristling Fur", { "player.health < 80" } },
		{ "Savage Defense", { "player.health < 95", "player.rage >= 60" } },
		{ "Survival Instincts", { "player.health < 70", "player.spell(Survival Instincts).charges > 1" } },
		{ "Barkskin", { "player.health < 90" } },
		{ "#trinket1" },
		{ "#trinket2" },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "targettarget.istheplayer", "!player.buff(Bristling Fur)", "!player.buff(Survival Instincts)", "!player.buff(Barkskin)", "!player.buff(Savage Defense)"
	} },

	-- OFFENSIVE COOLDOWNS
	{ {
		{ "Blood Fury" },
		{ "Berserking" },
		{ "Arcane Torrent", "player.rage <= 75" },
	},{
		"modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)",
	} },

	-- THREAT ROTATION
	-- actions+=/maul,if=buff.tooth_and_claw.react&incoming_damage_1s
	{ "Maul", { "toggle.cleave", "player.buff(Tooth and Claw)", "!modifier.last" } }, -- Empowered Maul causes its primary victim's next autoattack to deal (Attack power * 2.4) less damage.
	-- actions+=/berserk,if=buff.pulverize.remains>10
	{ "Berserk", { "player.buff(Pulverize).remains > 10" } }, -- When used in Bear Form, removes the cooldown from Mangle and causes it to hit up to 3 targets and lasts 10 sec.
	-- actions+=/frenzied_regeneration,if=rage>=80
	{ "Frenzied Regeneration", { "modifier.cooldowns", "player.rage >= 80", "!modifier.last", "player.health < 90" } }, -- Heal streangth is: max(2 x (AttackPower - Agility x 2), Stamina x 2.5)
	-- actions+=/cenarion_ward
	{ "Cenarion Ward", true, "player" },
	-- actions+=/renewal,if=health.pct<30
	{ "Renewal", "player.health < 60" },
	-- actions+=/heart_of_the_wild
	{ "Heart of the Wild", "modifier.cooldowns" },
	-- actions+=/rejuvenation,if=buff.heart_of_the_wild.up&remains<=3.6
	{ "Rejuvenation", { "player.buff(Heart of the Wild)", "player.buff.remains <= 3.6" }, "player" },
	-- actions+=/natures_vigil
	{ "Nature's Vigil", "player.health < 95" },
	-- actions+=/healing_touch,if=buff.dream_of_cenarius.react&health.pct<30
	{ "Healing Touch", { "player.buff(Dream of Cenarius).remains >= 1.5", "player.health < 70" }, "player" },
	-- actions+=/pulverize,if=buff.pulverize.remains<=3.6
	{ "Pulverize", { "target.debuff(Lacerate).count == 3", "player.buff(Pulverize).remains <= 3.6" } }, -- check to see how many lacerate stacks pulverize will trigger with
	-- actions+=/lacerate,if=talent.pulverize.enabled&buff.pulverize.remains<=(3-dot.lacerate.stack)*gcd&buff.berserk.down
	{ "Lacerate", { "target.exists", "talent(7, 2)", "!player.buff(Berserk)", (function() return NetherMachine.condition["buff.remains"]('player', 'Pulverize') <= (3 - NetherMachine.condition["debuff.count"]('target', 'Lacerate')) * 1.5 end) } },
	-- actions+=/incarnation
	{ "Incarnation: Son of Ursoc", { "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "!target.classification(minus, trivial, normal)", "player.health < 80" } },
	-- actions+=/lacerate,if=!ticking
	{ "Lacerate", "!target.debuff(Lacerate)" },
	-- actions+=/thrash_bear,if=!ticking
	{ "Thrash", { "toggle.cleave", "!target.debuff(Thrash)" } },
	-- actions+=/mangle
	{ "Mangle" },
	-- actions+=/thrash_bear,if=remains<=4.8
	{ "Thrash", { "toggle.cleave", "target.debuff(Thrash).remains <= 4.8" } },
	-- actions+=/lacerate
	{ "Lacerate" },

},{
-- OUT OF COMBAT ROTATION
	-- PAUSE
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- BUFFS
	{ "Mark of the Wild", { "!player.buffs.stats", "!modifier.last" } },

	-- REZ
	{ "Revive", { "target.exists", "target.dead", "target.player", "!player.moving" }, "target" },

	-- AUTO FORMS
	{ "pause", { "target.exists", "target.istheplayer" } },
	{ {
		{ "/cancelform", { "target.isfriendlynpc", "!player.form == 0", "!player.ininstance", "target.range <= 2" } },
		{ "pause", { "target.isfriendlynpc", "target.range <= 2" } },
		{ "Travel Form", { "!player.buff(Travel Form)", "!target.exists", "!player.ininstance", "player.moving", "player.outdoors" } },
		{ "Cat Form", { "!player.buff(Cat Form)", "!player.buff(Travel Form)", "!target.exists", "player.moving" } },
		{ "Bear Form", { "!player.buff(Bear Form)", "target.exists", "target.enemy", "target.distance < 30" } },
	},{
		"toggle.forms", "!player.flying", "!player.buff(Dash)",
	} },

	-- AUTO ATTACK
	{ {
		{ "Mark of the Wild", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Soothe", true, "target" },
	}, "toggle.autoattack" },

},function()
	NetherMachine.toggle.create('forms', 'Interface\\Icons\\ability_racial_bearform', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\spell_nature_faeriefire', 'Use Mouseovers', 'Toggle usage of Faerie Fire on mouseover targets.')
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('autoattack', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack units in range.')
	NetherMachine.toggle.create('cleave', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Cleave', 'Toggle the usage of multi target abilities when in single target mode.')
end)





-- SINGLE Target Rotation
-- Use Mangle on cooldown (its cooldown has a chance to be reset by Lacerate, so you need to watch out for this).
-- Use Lacerate until it has 3 stacks on the target.
-- Use Pulverize (consuming the Lacerate stacks).
-- Re-stack Lacerate to 3 before the 12-second buff from Pulverize expires.
-- Keep up the Thrash bleed (lasts 16 seconds).
-- Use Maul Icon Maul only when
-- you are under the effect of a Tooth and Claw proc;
-- you are at or very close to maximum Rage;
-- you do not need to use your active mitigation.
--
-- MULTIPLE Target Rotation
-- Keep up the Thrash bleed (lasts 16 seconds).
-- Use Lacerate until it has 3 stacks on the target.
-- Use Pulverize (consuming the Lacerate stacks).
-- Use Mangle on cooldown.
-- Re-stack Lacerate to 3 before the 12-second buff from Pulverize expires.
-- You will want to alternate using Mangle on various enemies, preferring those on which your threat is lowest.


NetherMachine.rotation.register_custom(104, "bbDruid Guardian (Experimental)", {
---------------------------
--      MODIFIERS       --
---------------------------
{"!108294", "modifier.ralt", "talent(6,1)"}, --Heart of the wild
{"!124974", "modifier.ralt", "talent(6,3)"},--Natures Vigil
{"!106898", "modifier.lshift"}, --Stampeding Roar
{"!20484", "modifier.rshift", "mouseover"}, --Rebirth
---------------------------
--      SURVIVAL        --
---------------------------

{"Cenarion Ward",{"player.health < 85", "player.spell(Cenarion Ward).exists"},"player"},
{ "108238", { "player.health <= 40", "talent(2,2)" }, "Player" },--Renewal
{ "#5512", "player.health <= 30" },  --healthstone
--{"!50334", {"player.health <= 30"}},
{"Healing Touch",{"player.buff(145162)","player.health < 90"},"player"},
{"!Survival Instincts",{"target.target(player)","player.health < 50", "!lastcast(Survival Instincts)" ,"!player.buff(Survival Instincts)"}},
{"!barkskin",{"target.target(player)","player.health < 70", "!lastcast(Survival Instincts)" ,"!player.buff(Survival Instincts)"}},
{"5487",{"player.stance != 1"}},
--145162 DoC
--135286  TnC

---------------------------
--      AUTO TAUNT      --
---------------------------
{{
{"Growl",{"!target.target(player)", "focus.debuff(Open Wounds).count >= 2"},"target"},
{"Growl",{"!target.target(player)", "focus.debuff(The Tenderizer)", "!player.debuff(The Tenderizer)"},"target"},
{"/target Brackenspore",{"!boss1.target(player)", "focus.debuff(Rot).count >= 4", "!player.debuff(Rot)"},"boss1"},
{"Growl",{"!target.target(player)", "focus.debuff(Rot).count >= 4", "!player.debuff(Rot)"},"boss1"},
},"toggle.AutoTaunt"},


---------------------------
--      INTERRUPTS       --
---------------------------

{ "Skull Bash", { "modifier.interrupt", "target.interruptAt(40)" },"target" },
{ "Mighty Bash",{ "modifier.interrupt", "player.spell(Skull Bash).cooldown"}, "target" },
---------------------------
--       COOLDOWNS       --
---------------------------

{ "Berserk", "modifier.cooldowns" },
{ "Nature's Vigil", "modifier.cooldowns"},
{ "Incarnation", "modifier.cooldowns"},


---------------------------
--   ACTIVE MITIGATION   --
---------------------------
{{
{"!62606", { "player.health <= 95", "!lastcast(62606)", "!player.buff(132402)", "target.threat >= 100"}},

{"Maul",{"player.buff(Tooth and Claw).count = 3", "target.range <= 6"},"target"},
{"Maul",{"player.buff(Tooth and Claw)","player.rage >= 70","target.range <= 6"},"target"},
{"Maul",{"player.buff(Tooth and Claw)", "target.range <= 6", "player.spell(62606).charges < 1", "player.spell(62606).recharge >= 3"},"target"},
{"Maul",{"player.buff(Tooth and Claw)", "target.range <= 6", "player.buff(132402).duration > 2",},"target"},


{"!Frenzied Regeneration",{"Player.health <= 20", "player.rage >= 20","!player.buff(Tooth and Claw)","player.spell(62606).recharge >= 3"}},
{"!Frenzied Regeneration",{"Player.health <= 85", "player.rage >= 20", "player.spell(62606).charges < 1", "player.spell(62606).recharge > 3"}},
{"!Frenzied Regeneration",{"Player.health <= 90", "player.rage >= 60", "!target.target(player)","target.exists","target.enemy"}},

},"toggle.ActiveMit"},
---------------------------
--    TOOTH AND CLAW     --
---------------------------
{"Maul",{"player.buff(Tooth and Claw)","target.range < 6","!toggle.ActiveMit"},"target"},
{"Maul",{"player.rage > 60", "!target.target(player)"},"target"},
---------------------------
--    COMBAT ROTATION    --
---------------------------
{ "770", {"!target.debuff(770)", "target.boss"} }, -- Faerie Fire
{ "Pulverize", {"target.debuff(Lacerate).count >= 3", "player.buff(Pulverize).duration <= 3", "target.target(player)"} }, -- Pulverize
{ "Mangle" },

{ "Thrash", "modifier.multitarget" },
{ "Thrash", "target.debuff(77758).duration <= 3" },
{ "Lacerate" },

--Targeting & Focus
  { "/targetenemy [noexists]", "!target.exists" },


},{
	--out of combat
	{ "/cancelform", {"!player.buffs.stats", "player.stance = 1" }},
	{ "!1126", "!player.buffs.stats" }, --stats
	{"5487",{"player.stance != 1"}},

},function()
	NetherMachine.toggle.create('ActiveMit', 'Interface\\Icons\\ability_druid_enrage', 'Active Mitigation','Auto use of Active Mitigation')
	NetherMachine.toggle.create('AutoTaunt', 'Interface\\Icons\\ability_physical_taunt', 'Auto TAUNT','BROKEN FOR NOW')
end)
