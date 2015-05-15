-----------------------------------------------------------------------------------------------------------------------
			--------------   API   --------------
-----------------------------------------------------------------------------------------------------------------------

if not FireHack then
	return
end

-- Object API.
local OBJECT_DISPLAY_ID_OFFSET = 0x40
local OBJECT_BOBBING_OFFSET = 0x1e0
local OBJECT_CREATOR_OFFSET = 0x30

-- Get the display ID of an object.
--
-- @returns The display ID of the object.
function GetObjectDisplayID(object)
	return ObjectDescriptor(object, OBJECT_DISPLAY_ID_OFFSET, Types.UInt)
end

-- Get the GUID of an object.
--
-- @returns The GUID of the object.
function GetObjectGUID(object)
	return tonumber(ObjectDescriptor(object, 0, Types.ULong))
end

-- Check whether or not the object is marked as bobbing.
--
-- @return True if the object is bobbing.
function IsObjectBobbing(object)
	return (ObjectField(object, OBJECT_BOBBING_OFFSET, Types.Byte) == 1)
end

-- Test whether an object is created/belongs to another object.
--
-- @return True if it's created by the other object.
function IsObjectCreatedBy(owner, object)
	return tonumber(ObjectDescriptor(object, OBJECT_CREATOR_OFFSET, Types.ULong)) == GetObjectGUID(owner)
end

-- Unit API.
local UNIT_DISPLAY_ID_OFFSET = 0x190

-- Get the display ID of a unit.
--
-- @return The display ID of the unit.
function GetUnitDisplayID(object)
	return ObjectDescriptor(object, UNIT_DISPLAY_ID_OFFSET, Types.UInt)
end

-----------------------------------------------------------------------------------------------------------------------
			--------------   REEL   --------------
-----------------------------------------------------------------------------------------------------------------------

Reel = {
	__frame = nil,
	__timer = nil,
	__bobber = nil,
	__isRunning = false,
	__isFishing = false,
	__fishingSpellID = 0,
	__fishingSpellBookIndex = 0,
	__currentState,
	__states = {},
	__equipment = {
		rods = {},
		hats = {},
		buffs = {},
		lures = {}
		},
}

if not Reel_Options then
	Reel_Options = {}
end

-- Constants.
local BOBBER_DISPLAY_ID = 668
local CHANNELED_FISHING_SPELL_ID = 131476
local CHANNELED_FISHING_SPELL_BUFFED_ID = 131490

-- Delegate spell events, such as start fishing, stop fishing, etc.
local function HandleOnEvent(self, event, ...)
	if event == "UNIT_SPELLCAST_CHANNEL_START" then
		local unitID, spell, rank, lineID, spellID = ...

	if unitID == "player" and (spellID == CHANNELED_FISHING_SPELL_ID or spellID == CHANNELED_FISHING_SPELL_BUFFED_ID) then
		Reel:FishingStarted()
	end
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		local unitID, spell, rank, lineID, spellID = ...

	if unitID == "player" and (spellID == CHANNELED_FISHING_SPELL_ID or spellID == CHANNELED_FISHING_SPELL_BUFFED_ID) then
		Reel:FishingStopped()
	end
	elseif event == "UNIT_SPELLCAST_FAILED" then
		local unitID, spell, rank, lineID, spellID = ...

	if unitID == "player" and (spellID == CHANNELED_FISHING_SPELL_ID or spellID == CHANNELED_FISHING_SPELL_BUFFED_ID) then
		Reel:FishingFailed()
	end
	elseif event == "BAG_UPDATE" then
	-- TODO: Change it to only update the affected bag.
		Reel:UpdateEquipment()
	elseif event == "LOOT_CLOSED" then
		Reel:LootClosed()
	elseif event == "PLAYER_ENTERING_WORLD" then
		Reel:Load()
	end
end

-- Used for caching owned items (rods, buffs, lure, ...) for faster lookups.
local function CacheContainerItems(container)
	local itemID = 0
	local equipment = Reel.__equipment

	for i = 1, GetContainerNumSlots(container) do
		itemID = GetContainerItemID(container, i)

	-- Cache fishing rods.
	if Reel:IsFishingRod(itemID) then 
		table.insert(equipment.rods, 1, itemID)
	end

	-- Cache lure items.
	if Reel:IsLureItem(itemID) then
		table.insert(equipment.lures, 1, itemID)
	end

	-- Cache buff items.
    if Reel:IsBuffItem(itemID) then
		table.insert(equipment.buffs, 1, itemID)
	end

	-- Cache fishing hats.
	if Reel:IsFishingHat(itemID) then
		table.insert(equipment.hats, 1, itemID)
	end
	end
end

local function CacheInventoryItems()
	local itemID = GetInventoryItemID("player", INVSLOT_MAINHAND)

	if Reel:IsFishingRod(itemID) then
		table.insert(Reel.__equipment.rods, 1, itemID)
	end

	itemID = GetInventoryItemID("player", INVSLOT_HEAD)

	if Reel:IsFishingHat(itemID) then
		table.insert(Reel.__equipment.hats, 1, itemID)
	end
end

-- Initializes the addon. Called when the addon is loaded.
function Reel:Initialize(frame)
	self.__frame = frame

	frame:SetScript("OnEvent", HandleOnEvent)
	frame:RegisterEvent("BAG_UPDATE")
	frame:RegisterEvent("LOOT_CLOSED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
end

-- Caches information like fishing rods in bags, buff items in bags, etc. 
-- Called when the player is entering the world.
function Reel:Load()
	self.__fishingSpellID = self:GetFishingSpellID()
	self.__fishingSpellBookIndex = self:GetFishingSpellBookIndex()

	self:UpdateEquipment()
end

-- Updates the cached information about rods, hats, etc. currently being
-- carried.
function Reel:UpdateEquipment()
	-- Reset the equipment cache.
	self.__equipment = {
		rods = {},
		hats = {},
		buffs = {},
		lures = {}
	}

	-- Re-cache everything.
	CacheInventoryItems()

	for i = 1, NUM_BAG_SLOTS do
		CacheContainerItems(i)
	end
end

-- Get a list of cached equipment.
--
-- @returns Table with cached equipment.
function Reel:GetEquipment()
	return self.__equipment
end

-- Count the number of cached fishing rods.
--
-- @returns The number of fishing rods.
function Reel:GetNumFishingRods()
	return #self.__equipment.rods
end

-- Count the number of cached lure items.
--
-- @returns The number of lure items.
function Reel:GetNumLureItems()
	return #self.__equipment.lures
end

-- Count the number of cached fishing hats.
--
-- @returns The number of fishing hats.
function Reel:GetNumFishingHats()
	return #self.__equipment.hats
end

-- Adds a state to the state machine.
function Reel:AddState(name, state)
	state.name = name
		table.insert(self.__states, 1, state)

	if Reel_Options.Debug then
		self:PrintMessage("Added state with name \"%s\"", name)
	end
end

-- Remove a state from the state machine.
--
-- @returns True if the state was removed.
function Reel:RemoveState(name)
	for key, value in ipairs(self.States) do
		if value.name == name then
			table.remove(self.__states, key)

		return true
		end
	end
end

-- Run the state machine.
function Reel:Run()
	if not self.__isRunning then
		return
	end

	local nextState = nil

	for index, state in pairs(self.__states) do
		if state:IsApplicable() then nextState = state end
	end

	if self.__currentState and self.__currentState ~= nextState then
		self.__currentState:OnLeave()
	end

	if nextState and nextState ~= self.__currentState then
		nextState:OnEnter()
	end

	self.__currentState = nextState
end

-- Stop running.
function Reel:Stop()
	if self.__isRunning then
		self.__frame:Hide()
		self:Disable()
		SpellStopCasting()
	end
end

-- Figure out whether the player currently has a fishing rod equipped.
--
-- @returns True if the player has a fishing rod equipped.
function Reel:IsFishingRodEquipped()
	local currentWeaponID = GetInventoryItemID("player", INVSLOT_MAINHAND)

	return self:IsFishingRod(currentWeaponID)
end

-- Figure out the spell ID for fishing.
-- This works regardless of the clients localization and fishing rank.
--
-- @returns The fishing spell ID.
function Reel:GetFishingSpellID()
	local fishingSpellIndex = self:GetFishingSpellBookIndex()

	if fishingSpellIndex then
		local skillType, spellID = GetSpellBookItemInfo(fishingSpellIndex, BOOKTYPE_PROFESSION)
		return spellID
	else
		self:PrintMessage("Could not find the profession index for fishing. Are you sure you have the profession?")
	end
end

function Reel:SetStatus(status)
	ReelStatusText:SetText(format("Reel is %s …", status))
end

-- Figure out the fishing spellbook index.
--
-- @returns The fishing spellbook index.
function Reel:GetFishingSpellBookIndex()
	local fishingProfessionIndex = select(4, GetProfessions())
	local fishingButtonID = 1 -- The index of the button with the fishing spell.

	if fishingProfessionIndex then
		local spellOffset = select(6, GetProfessionInfo(fishingProfessionIndex))
		return fishingButtonID + spellOffset
	end
end

-- Enables Reel.
--
-- @returns True, since Reel is enabled.
function Reel:Enable()
	self.__isRunning = true
	return self.__isRunning
end

-- Disables Reel.
--
-- @returns False, since Reel is disabled.
function Reel:Disable()
	self.__isRunning = false
	self.__isFishing = false

	if self.__currentState then
		self.__currentState:OnLeave()
		self.__currentState = nil
	end

	self.__frame:Hide()
		return self.__isRunning
end

-- Toggles the fishing state.
--
-- @returns True if Reel is enabled.
function Reel:Toggle()
	if self.__isRunning then
		return Enable()
	else
		return Disable()
	end
end

-- Start fishing by casting the fishing spell.
function Reel:StartFishing()
	CastSpell(self.__fishingSpellBookIndex, BOOKTYPE_PROFESSION)
end

-- Prints a formatted message.
function Reel:PrintMessage(message, ...)
	DEFAULT_CHAT_FRAME:AddMessage(format("[Reel] %s", format(message, ...)))
end

local fishingAttempts = 0

-- Called when the player starts fishing.
function Reel:FishingStarted()
	if not self.__isRunning then
		self.__frame:Show()
		self:Enable()
  end
  
	fishingAttempts = 0
	self.__isFishing = true
end

-- Called when the player stops fishing.
function Reel:FishingStopped()
	if self.__isRunning then
		self.__isFishing = false
	end
end

-- Called when the player tries to start fishing, but fails.
function Reel:FishingFailed()
	if self.__isRunning then
		fishingAttempts = fishingAttempts + 1

	if fishingAttempts >= 3 then
		self:PrintMessage("Fishing failed. Giving up.")
		self.__isFishing = false
		self:Disable()
		
		fishingAttempts = 0
	else
		self:PrintMessage("Fishing failed, retrying.")

		C_Timer.After(.1, function()
			if Reel.__isRunning then
				self:StartFishing()
			end
		end)
	end
	end
end

-- Called when the loot window is closed.
function Reel:LootClosed()
	if self.__isRunning then
	-- …
	end
end

-- Get a pointer to the fishing bobber.
--
-- @returns Pointer to the players bobber.
function Reel:GetBobber()
	local bobber = nil

	for index = 1, ObjectCount() do
		object = ObjectWithIndex(index)

	if GetObjectDisplayID(object) == BOBBER_DISPLAY_ID then
		if IsObjectCreatedBy("player", object) then
			bobber = object

		break
		end
	end
	end

	return bobber
end

-----------------------------------------------------------------------------------------------------------------------
			--------------   LURES   --------------
-----------------------------------------------------------------------------------------------------------------------

local CONTINENT_PANDARIA = 6

Reel.Enchantments = {
	{ id = 4919, bonus = 150 }, -- +150 Temporary fishing lure
	{ id = 265, bonus = 75 } -- +75 Temporary fishing lure
}

Reel.Lures = {
	{ id = 6532, bonus = 75 }, -- Bright Baubles / +75
	{ id = 34861, bonus = 100 }, -- Sharpened Fish Hook / +100
	{ id = 118391, bonus = 200 } -- Worm Supreme / +200
}

Reel.Hats = {
	{ id = 88710, bonus = 5, enchantment = 4919 }, -- Nat's Hat
	{ id = 117405, bonus = 10, enchantment = 4919 }, -- Nat's Drinking Hat
	{ id = 33820, bonus = 5, enchantment = 265 }, -- Weather-Beaten Fishing Hat
	{ id = 19972, bonus = 5 }, -- Lucky Fishing Hat
	{ id = 93732, bonus = 5 }, -- Darkmoon Fishing Cap
	{ id = 118380, bonus = 100 }, -- Hightfish Cap
	{ id = 118393, bonus = 100 } -- Tentacled Hat
}

Reel.Rods = {
	{ id = 46337, bonus = 3 }, -- Staats' Fishing Pole / +3
	{ id = 120163, bonus = 3 }, -- Thruk's Fishing Rod / +3
	{ id = 6365, bonus = 5 }, -- Strong Fishing Pole / +5
	{ id = 84660, bonus = 10 }, -- Pandaren Fishing Pole / +10
	{ id = 6366, bonus = 15 }, -- Darkwood Fishing Pole / +15
	{ id = 6367, bonus = 20 }, -- Big Iron Fishing Pole / +20
	{ id = 25978, bonus = 20 }, -- Seth's Graphite Fishing Pole / +20
	{ id = 19022, bonus = 20 }, -- Nat Pagle's Extreme Angler FC-5000 / +20
	{ id = 45858, bonus = 25 }, -- Nat's Lucky Fishing Pole / +25
	{ id = 45991, bonus = 30 }, -- Bone Fishing Pole / +30
	{ id = 44050, bonus = 30 }, -- Mastercraft Kalu'ak Fishing Pole / +30
	{ id = 45992, bonus = 30 }, -- Jeweled Fishing Pole / +30
	{ id = 84661, bonus = 30 }, -- Dragon Fishing Pole / +30
	{ id = 116826, bonus = 30 }, -- Draenic Fishing Pole / +30
	{ id = 116825, bonus = 30 }, -- Savage Fishing Pole / +30
	{ id = 19970, bonus = 40 }, -- Arcanite Fishing Pole / +40
	{ id = 118381, bonus = 100 } -- Ephemeral Fishing Pole / +100
}

Reel.Buffs = {
	-- Ancient Pandaren Fishing Charm
	{ id = 85973, buff = 125167, condition = function() return GetCurrentMapContinent() == CONTINENT_PANDARIA end },
	{ id = 110294, buff = 158039, condition = function() return GetCurrentMapAreaID() == 946 or GetCurrentMapAreaID() == 976 end }, --Blackwater Whiptail Bait 110294 158039 Talador
    { id = 110292, buff = 158037, condition = function() return GetCurrentMapAreaID() == 9999 or GetCurrentMapAreaID() == 976 end }, --Sea Scorpion Bait 110292 158037 Ocean Waters
    { id = 110289, buff = 158034, condition = function() return GetCurrentMapAreaID() == 950 or GetCurrentMapAreaID() == 976 end }, --Fat Sleeper Bait 110289 158034 Nagrand
    { id = 110293, buff = 158038, condition = function() return GetCurrentMapAreaID() == 946 or GetCurrentMapAreaID() == 976 end }, --Abyssal Gulper Eel Bait 110293 158038 Spires of Arrak
    { id = 110290, buff = 158035, condition = function() return GetCurrentMapAreaID() == 947 or GetCurrentMapAreaID() == 976 end }, --Blind Lake Sturgeon Bait 110290 158035 Shadowmoon
    { id = 110274, buff = 158031, condition = function() return GetCurrentMapAreaID() == 949 or GetCurrentMapAreaID() == 976 end }, --Jawless Skulker Bait 110274 158031 Gorgrond
    { id = 110291, buff = 158036, condition = function() return GetCurrentMapAreaID() == 941 or GetCurrentMapAreaID() == 976  end } --Fire Ammonite Bait 110291 158036 Frostfire
    -- All Baits work in your garrison. Need to make sure we only use one at a time.
}

-- Check whether an item is a fishing rod.
--
-- @returns True if the item is a fishing rod.
function Reel:IsFishingRod(itemID)
	for i, rod in ipairs(self.Rods) do
		if rod.id == itemID then
			return true
		end
	end
end

-- Check whether an item is a lure item.
--
-- @returns True if the item is a lure item.
function Reel:IsLureItem(itemID)
	for i, lure in ipairs(self.Lures) do
		if lure.id == itemID then
			return true
		end
	end
end

-- Check whether an item is a fishing buff item.
--
-- @returns True if the item is a fishing buff item.
function Reel:IsBuffItem(itemID)
	for i, buff in ipairs(self.Buffs) do
		if buff.id == itemID then
			return true
		end
	end
end

-- Check whether an item is a fishing hat.
--
-- @returns True if the item is a fishing hat.
function Reel:IsFishingHat(itemID)
	for i, hat in ipairs(self.Hats) do
		if hat.id == itemID then
			return true
		end
	end
end


-----------------------------------------------------------------------------------------------------------------------
			--------------   EQUIP FISHING GEAR   --------------
-----------------------------------------------------------------------------------------------------------------------

local EquipFishingGear = {}

-- Pick up an item from the inventory or from the bags based on item ID.
--
-- @returns True if the item was found.
local function PickupPlayerItem(itemID)
	local currentItemID = 0

	-- Look through the player inventory.
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		currentItemID = GetInventoryItemID("player", i)

	if currentItemID == itemID then
		PickupInventoryItem(i)

		return true
		end
	end

	-- Look through the players bags.
	for i = 1, NUM_BAG_SLOTS do
	for j = 1, GetContainerNumSlots(i) do
		currentItemID = GetContainerItemID(i, j)

	if currentItemID == itemID then
		PickupContainerItem(i, j)

			return true
		end
	end
	end
end

-- Get the skill bonus provided by an enchantment.
--
-- @returns The skill bonus.
local function GetEnchantmentBonus(enchantmentID)
	for i, enchant in ipairs(Reel.Enchantments) do
		if enchant.id == enchantmentID then
			return enchant.bonus
		end
	end

	return 0
end

-- Get the total fishing hat bonus.
--
-- @returns The total fishing hat bonus.
local function GetFishingHatBonus(itemID)
	local hat = nil

	for i, h in ipairs(Reel.Hats) do
		if h.id == itemID then hat = h; break end
	end

	local bonus = hat.bonus

	if hat.enchantment then
		bonus = bonus + GetEnchantmentBonus(hat.enchantment)
	end

	return bonus
end

-- Get the best fishing hat (the one that provides the highest bonus).
--
-- @returns The ID of the fishing hat.
local function GetBestFishingHat()
	local bestBonus = 0
	local bestHat = 0
	local bonus = 0

	for i, hat in ipairs(Reel.__equipment.hats) do
		bonus = GetFishingHatBonus(hat)

	if bonus > bestBonus then
		bestBonus = bonus
		bestHat = hat
		end
	end

	return bestHat
end

-- Get the fishing rod bonus.
--
-- @returns The fishing rod bonus.
local function GetFishingRodBonus(itemID)
	for i, rod in ipairs(Reel.Rods) do
		if rod.id == itemID then
			return rod.bonus
		end
	end
end

-- Get the best fishing rod.
--
-- @retusn The ID of the fishing rod.
local function GetBestFishingRod()
	local bonus = 0
	local bestRod = 0
	local bestBonus = 0

	for i, rod in ipairs(Reel.__equipment.rods) do
		bonus = GetFishingRodBonus(rod)

	if bonus > bestBonus then
		bestBonus = bonus
		bestRod = rod
		end
	end

	return bestRod
end

function EquipFishingGear:IsApplicable()
	if Reel.__isFishing then
		return false
	end

	if Reel:GetNumFishingRods() > 0 and not Reel:IsFishingRodEquipped() then
		return true
	end

	if Reel:GetNumFishingHats() > 0 and not Reel:IsFishingHat(GetInventoryItemID("player", INVSLOT_HEAD)) then
		return true
	end
end

function EquipFishingGear:OnEnter()
	Reel:SetStatus("equipping fishing gear")

	local fishingRodItemID = GetBestFishingRod()

	if fishingRodItemID and PickupPlayerItem(fishingRodItemID) then
		AutoEquipCursorItem()
	end

	local fishingHatItemID = GetBestFishingHat()

	if fishingHatItemID and PickupPlayerItem(fishingHatItemID) then
		AutoEquipCursorItem()
	end
end

function EquipFishingGear:OnLeave()
end

Reel:AddState("EquipFishingGear", EquipFishingGear)


-----------------------------------------------------------------------------------------------------------------------
			--------------   USE BUFF   --------------
-----------------------------------------------------------------------------------------------------------------------

local UseBuff = {}

function UseBuff:IsApplicable()
end

function UseBuff:OnEnter()
	Reel:SetStatus("Applying buff(s)")
end

function UseBuff:OnLeave()
end

Reel:AddState("UseBuff", UseBuff)


-----------------------------------------------------------------------------------------------------------------------
			--------------   USE LURE   --------------
-----------------------------------------------------------------------------------------------------------------------

local UseLure = {}

local function IsFishingRodEnchanted()
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, _ = GetWeaponEnchantInfo()

	return hasMainHandEnchant
end

local function HasLureToApply()
	local headItemID = GetInventoryItemID("player", INVSLOT_HEAD)

	for i, hat in ipairs(Reel.Hats) do
		if hat.enchantment and hat.id == headItemID then
			local start, duration, enable = GetInventoryItemCooldown("player", INVSLOT_HEAD)
      
		if duration == 0 then
			return true
			end
		end
	end
end

function UseLure:IsApplicable()
	if not Reel.__isFishing and Reel:IsFishingRodEquipped() then
		if IsFishingRodEnchanted() then
			return false
		else
			return HasLureToApply()
		end
	else
		return false
	end
end

function UseLure:OnEnter()
	Reel:SetStatus("Applying lure")

	C_Timer.After(2, function()
		UseInventoryItem(INVSLOT_HEAD)
	end)
end

function UseLure:OnLeave()
end

Reel:AddState("UseLure", UseLure)


-----------------------------------------------------------------------------------------------------------------------
			--------------   CATCHING   --------------
-----------------------------------------------------------------------------------------------------------------------

local Catching = {}

function Catching:IsApplicable()
	return Reel.__isFishing
end

function Catching:OnEnter()
	self.__bobber = nil
	Reel:SetStatus("baiting")
	
	self.timer = C_Timer.NewTicker(.5, function()
		self:Tick()
	end, nil)
end

function Catching:Tick()
	if self.__bobber ~= nil then
		if IsObjectBobbing(self.__bobber) then
			ObjectInteract(self.__bobber)
		end
	else
		local bobber = Reel:GetBobber()

		if bobber then
			self.__bobber = bobber
		end
	end
end

function Catching:OnLeave()
	self.timer:Cancel()
end

Reel:AddState("Catching", Catching)


-----------------------------------------------------------------------------------------------------------------------
			--------------   LOOTING   --------------
-----------------------------------------------------------------------------------------------------------------------

local Looting = {}

function Looting:IsApplicable()
	return IsFishingLoot()
end

function Looting:OnEnter()
	Reel:SetStatus("looting")
end

function Looting:OnLeave()
end

Reel:AddState("Looting", Looting)


-----------------------------------------------------------------------------------------------------------------------
			--------------   MOVING   --------------
-----------------------------------------------------------------------------------------------------------------------

local Moving = {}

function Moving:IsApplicable()
	return IsPlayerMoving() or IsMounted() or IsFlying()
end

function Moving:OnEnter()
	Reel:Disable()
end

function Moving:OnLeave()
end

Reel:AddState("Moving", Moving)


-----------------------------------------------------------------------------------------------------------------------
			--------------   FISHING   --------------
-----------------------------------------------------------------------------------------------------------------------

local Fishing = {}

function Fishing:IsApplicable()
	if not Reel.__isFishing and not UnitChannelInfo("player") then
		return true
	end
end

function Fishing:OnEnter()
	Reel:SetStatus("casting the line")

	Reel:StartFishing()
end

function Fishing:OnLeave()
end

Reel:AddState("Fishing", Fishing)