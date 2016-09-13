NetherMachine.rotation.register_custom(255, 'Survival Hunter', {
  { "Misdirection", { "pet.exists", "pet.alive", "!player.party", "player.time < 2" }, "pet" },
  { "Exhilaration", "player.health <= 50" },
  { "Mend Pet", { "pet.health <= 90", "!pet.buff" } },
  { "Counter Shot", { "player.spell(Counter Shot).cooldown = 0", "modifier.interrupts" } },
  { "Ice Trap", { "modifier.shift", "modifier.xkey", "target.exists" }, "target.ground" },
  { "Freezing Trap", { "modifier.shift", "modifier.ckey", "target.exists" }, "target.ground" },
  { "Explosive Trap", { "modifier.shift", "modifier.zkey", "target.exists" }, "target.ground" },
  { "Ice Trap", { "modifier.shift", "modifier.xkey", "!target.exists" }, "ground" },
  { "Explosive Trap", { "modifier.shift", "modifier.zkey", "!target.exists" }, "ground" },
  { "Freezing Trap", { "modifier.shift", "modifier.ckey", "!target.exists" }, "ground" },
  { "Explosive Trap", { "modifier.multitarget", "!target.moving" }, "target.ground" },
  { "Black Arrow" },
  { "Explosive Shot" },
  { "Barrage", "target.area(20).enemies > 2" },
  { "Barrage", "modifier.cooldowns" },
  { "A Murder of Crows" },
  { "Stampede" },
  { "Multi-Shot", { "player.buff(Thrill of the Hunt)", "player.focus >= 35", "player.spell(Barrage).cooldown >= 5", "target.area(8).enemies >= 2" } },
  { "Arcane Shot", { "player.buff(Thrill of the Hunt)", "player.focus >= 35", "player.spell(Barrage).cooldown >= 5", "target.area(8).enemies = 1" } },
  { "Glaive Toss" },
  { "Arcane Shot", "player.focus >= 70" },
  { "Cobra Shot" },
  { "Focusing Shot" },
},{
  { "Trap Launcher", "!player.buff" },
  { "Ice Trap", { "modifier.shift", "modifier.xkey", "target.exists" }, "target.ground" },
  { "Freezing Trap", { "modifier.shift", "modifier.ckey", "target.exists" }, "target.ground" },
  { "Explosive Trap", { "modifier.shift", "modifier.zkey", "target.exists" }, "target.ground" },
  { "Ice Trap", { "modifier.shift", "modifier.xkey", "!target.exists" }, "ground" },
  { "Explosive Trap", { "modifier.shift", "modifier.zkey", "!target.exists" }, "ground" },
  { "Freezing Trap", { "modifier.shift", "modifier.ckey", "!target.exists" }, "ground" },
}, function()
  NetherMachine.condition.register("modifier.zkey", function()
    if FireHack then
      return GetKeyState(0x5A)
    end
  end)
  NetherMachine.condition.register("modifier.xkey", function()
    if FireHack then
      return GetKeyState(0x58)
    end
  end)
  NetherMachine.condition.register("modifier.ckey", function()
    if FireHack then
      return GetKeyState(0x43)
    end
  end)

  if FireHack then
    local LibDraw = LibStub("LibDraw-1.0")
    LibDraw.Sync(function()
      if IsShiftKeyDown() then
        if UnitExists('target') then
          local x, y, z = ObjectPosition('target')
          LibDraw.SetColor(255, 168, 5)
          LibDraw.Circle(x, y, z, 5)
        end
      end
    end)
  end

  local state = 0
  local angle = 0
  local launching = false
  local delay = false
  C_Timer.NewTicker(0.025, function()
    if _G['doLaunchForwards'] or launching then
      local cd, _ = GetSpellCooldown('Disengage')
      if cd == 0 or state > 2 then
        _G['doLaunchForwards'] = false
        launching = true
        if state == 0 then
          JumpOrAscendStart()
          state = 1
        elseif state == 1 then
          angle = ObjectFacing('player')
          FaceDirection((angle + math.pi) % (math.pi * 2))
          state = 2
        elseif state == 2 then
          local oangle = (angle + math.pi) % (math.pi * 2)
          local tangle = ObjectFacing('player')
          if not delay then
            delay = true
            C_Timer.NewTimer(0.2, function()
              delay = false
              SpellStopCasting()
              CastSpellByName("Disengage")
              SpellStopCasting()
              CastSpellByName("Disengage")
              state = 3
            end)
          end
        elseif state == 3 then
          FaceDirection(angle)
          state = 0
          launching = false
        end
      else
        state, angle, launching, delay = 0, 0, false, false
        _G['doLaunchForwards'] = false
      end
    end
  end)
end)
