--[[
local State = false;
local WaitForMount = false;
local AttemptedMountTime = 0;
local AttemptedMounts = 0;
local UseMount = true;
local CurrentObject = nil;


State = true;
UseMount = true;
WaitForMount = false;
AttemptedMountTime = 0;
AttemptedMounts = 0;
CurrentObject = nil;
if GetCVar("AutoLootDefault") ~= "1" then
  SetCVar("AutoLootDefault", "1")
  DEFAULT_CHAT_FRAME:AddMessage("Enabled AutoLoot.", 0, 0.5, 0.8);
end

function CommandHandler (Command)
  if Command:sub(1, 3) ~= "/al" then
    return false;
  end

  local ALCommand = Command:sub(5):lower();

  if ALCommand == "on" then
    if AreLootableCorpsesNearby() then
      DEFAULT_CHAT_FRAME:AddMessage("AutoLoot enabled.", 0, 0.5, 0.8);
    else
      DEFAULT_CHAT_FRAME:AddMessage("No lootable corpses are nearby.", 0, 0.5, 0.8);
      return true;
    end

    State = true;
    UseMount = true;
    WaitForMount = false;
    AttemptedMountTime = 0;
    AttemptedMounts = 0;
    CurrentObject = nil;

    if GetCVar("AutoLootDefault") ~= "1" then
      SetCVar("AutoLootDefault", "1")
      DEFAULT_CHAT_FRAME:AddMessage("Enabled AutoLoot.", 0, 0.5, 0.8);
    end
  elseif ALCommand == "off" then
    State = false;
    UseMount = true;
    WaitForMount = false;
    AttemptedMountTime = 0;
    AttemptedMounts = 0;
    CurrentObject = nil;

    DEFAULT_CHAT_FRAME:AddMessage("AutoLoot disabled.", 0, 0.5, 0.8);
  elseif ALCommand:sub(1, 5) == "mount" then
    local MountName = Command:sub(11);
    if not MountName or MountName == "" or MountName:lower() == "none" then
      MountName = "None";
      print("|c000080B0AutoLoot mount set to:|r |cFFFFFFFF" .. MountName .. "|r");
      SetCharacterScriptVariable("AL_Mount", MountName);
    else
      local i = 1;
      while i <= GetNumCompanions("Mount") do
        if select(2, GetCompanionInfo("Mount", i)):lower() == MountName:lower() then
          SetCharacterScriptVariable("AL_Mount", MountName);
          print("|c000080B0AutoLoot mount set to:|r |cFFFFFFFF" .. MountName .. "|r");
          return true;
        end

        i = i + 1;
      end

      print("|c000080B0Unknown mount:|r |cFFFFFFFF" .. MountName .. "|r");
    end
  elseif ALCommand == "help" then
    print("|c000080B0AutoLoot commands:|r");
    print("|cFFFFFFFF/AL On|r |c000080B0to start AutoLoot.|r");
    print("|cFFFFFFFF/AL Off|r |c000080B0to stop AutoLoot.|r");
    print("|cFFFFFFFF/AL Mount <Name>|r |c000080B0to set the mount for AutoLoot to use. Use None to not use a mount.|r");
    print("|cFFFFFFFF/AL Help|r |c000080B0to display this help message.|r");
  else
    print("|c000080B0Unknown AutoLoot command. Use|r |cFFFFFFFF.AL Help|r |c000080B0to get a list of AutoLoot commands.|r");
  end

  return true;
end

function AreLootableCorpsesNearby ()
  return not EnumerateObjects(function (ThisObject)
    return not (ThisObject:IsLootable() and ThisObject:InLineOfSight());
    end, TYPE_UNIT);
end

function GetNearestLootableCorpse ()
  local BestObject = nil;
  EnumerateObjects(function (ThisObject)
    if (not BestObject or ThisObject:GetDistance() < BestObject:GetDistance()) and ThisObject:InLineOfSight() and ThisObject:IsLootable() then
      BestObject = ThisObject;
    end

    return true;
    end, TYPE_UNIT);

  return BestObject;
end

function TimerCallback ()
  if not State then
    return;
  end

  if UnitAffectingCombat('player') or GetUnitSpeed('player') > 0 then
    return;
  end

  if not AreLootableCorpsesNearby() then
    DEFAULT_CHAT_FRAME:AddMessage("No more lootable corpses are nearby. Stopping.", 0, 0.5, 0.8);
    State = false;
    CurrentObject = nil;
    return;
  end

  if WaitForMount and UseMount and not IsMounted() then
    if GetTime() - AttemptedMountTime <= 5 then
      return;
    else
      if AttemptedMounts <= 2 then
        DEFAULT_CHAT_FRAME:AddMessage("Failed to mount. Retrying.", 0, 0.5, 0.8);
        AttemptedMounts = AttemptedMounts + 1;

        local MountName = GetCharacterScriptVariable("AL_Mount");
        if UseMount and not IsMounted() and IsOutdoors() and MountName and MountName:lower() ~= "none" then
          CastSpellByName(MountName);
          AttemptedMountTime = GetTime();
          WaitForMount = true;
          return;
        end
      else
        DEFAULT_CHAT_FRAME:AddMessage("Failed to mount. Not using a mount.", 0, 0.5, 0.8);
        UseMount = false;
      end
    end
  end

  WaitForMount = false;
  AttemptedMountTime = 0;
  AttemptedMounts = 0;

  local MountName = GetCharacterScriptVariable("AL_Mount");
  if UseMount and not IsMounted() and IsOutdoors() and MountName and MountName:lower() ~= "none" then
    CastSpellByName(MountName);
    AttemptedMountTime = GetTime();
    WaitForMount = true;
    return;
  end

  if not CurrentObject then
    CurrentObject = GetNearestLootableCorpse();
    return;
  end

  if CurrentObject:GetDistance() > 2 then
    local X, Y, Z = CurrentObject:GetLocation();
    X = X + math.random(-0.5, 0.5);
    Y = Y + math.random(-0.5, 0.5);

    MoveTo(X, Y, Z);
  else
    if not CurrentObject:IsLootable() then
      CurrentObject = GetNearestLootableCorpse();
      return;
    end

    CurrentObject:Interact();
    CurrentObject = nil;
  end
end

--SetCommandCallback(CommandHandler);
--SetTimerCallback(TimerCallback, 50);
local ticker = C_Timer.NewTicker(0.05, TimerCallback, nil)

DEFAULT_CHAT_FRAME:AddMessage("AutoLoot loaded.", 0, 0.5, 0.8);
]]--
