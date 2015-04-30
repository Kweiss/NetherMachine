local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local L = NetherMachine.locale.get

local player = {
  castCache = {},
  behind = false,
  behindTime = 0,
  infront = true,
  infrontTime = 0,
  moving = false,
  movingTime = 0
}

function player.updateSpec()
  local spec = GetSpecialization()
  local name, classFileName, classID = UnitClass('player')
  local color = RAID_CLASS_COLORS[classFileName]
  local specID, specName, _, specIcon = player.classID
  if spec then
    specID, specName, _, specIcon = GetSpecializationInfo(spec)
  end

  if specID ~= player.specID then
    if specIcon then
      NetherMachine.buttons.icon('MasterToggle', specIcon)
    else
      NetherMachine.buttons.icon('MasterToggle', 'Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES')
      local coords = CLASS_ICON_TCOORDS[player.classFileName]
      NetherMachine.buttons.buttons.MasterToggle.icon:SetTexCoord(unpack(coords))
    end

    NetherMachine.rotation.activeRotation = NetherMachine.rotation.rotations[specID]
    if NetherMachine.rotation.oocrotations[specID] then
      NetherMachine.rotation.activeOOCRotation = NetherMachine.rotation.oocrotations[specID]
    else
      NetherMachine.rotation.activeOOCRotation = false
    end
    NetherMachine.buttons.resetButtons()
    if NetherMachine.rotation.buttons[specID] then
      NetherMachine.rotation.add_buttons()
    end
    player.specID = specID
    player.specName = specName and specName or player.className

    NetherMachine.print('|c' .. color.colorStr .. player.specName .. ' ' .. name .. '|r ' .. L('rotation_loaded'))
    NetherMachine.rotation.loadLastRotation()
  end
end

function player.init()
  local name, classFileName, classID = UnitClass('player')
  player.classID = classID
  player.className = name
  player.classFileName = classFileName
  player.updateSpec()
end

local nextCastIndex = 1
function player.cast(spell)
  player.castCache[nextCastIndex] = spell
  nextCastIndex = nextCastIndex % 10 + 1
end

function player.casted(query)
  local count = 0

  for i = 1, 10 do
    if query == player.castCache[i] then
      count = count + 1
    end
  end

  return count
end

NetherMachine.module.register("player", player)
