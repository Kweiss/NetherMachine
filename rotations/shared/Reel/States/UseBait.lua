-----------------------------------------------------------------------------------------------------------------------
			--------------   BAITING   --------------
-----------------------------------------------------------------------------------------------------------------------

if not baitFish or baitFish["_cancelled"] then
  local function BaitMe()
    if not Reel.__isFishing then return end
    for i=1,20 do
      buffname = UnitBuff("player",i)
      if buffname and type(string.find(buffname," Bait"))=="number" then
        return
      end
    end
    local zone = GetZoneText()
    if type(string.find(zone,"Frostwall"))=="number" then
      local baits = {}
      for i=0,4 do
        for k=1,GetContainerNumSlots(i) do
          local id = GetContainerItemID(i,k)
          if id then
            local name = GetItemInfo(id)
            if type(string.find(name," Bait"))=="number" then
              tinsert(baits, name)
            end
          end
        end
      end
      if #baits>0 then
        print("Applying random bait.")
        UseItemByName(baits[ceil(random()*#baits)])
      end
    end
    local realzone = GetRealZoneText()
    local minizone = GetMinimapZoneText()
    if minizone == "Barrier Sea" and GetItemCount(110292)>0 then
      print("Applying Sea Scorpion bait.")
      UseItemByName(110292)
    elseif realzone == "Shadowmoon Valley" and GetItemCount(110290)>0 then
      print("Applying Blind Sturgeon bait.")
      UseItemByName(110290)
    elseif realzone == "Gorgrond" and GetItemCount(110274)>0 then
      print("Applying Jawless Skulker bait.")
      UseItemByName(110274)
    elseif realzone == "Talador" and GetItemCount(110294)>0 then
      print("Applying Blackwater Whiptail bait.")
      UseItemByName(110294)
    elseif realzone == "Spires of Arak" and GetItemCount(110293)>0 then
      print("Applying Abyssal Gulper Eel bait.")
      UseItemByName(110293)
    elseif realzone == "Nagrand" and GetItemCount(110289)>0 then
      print("Applying Fat Sleeper bait.")
      UseItemByName(110289)
    elseif realzone == "Frostfire Ridge" and GetItemCount(110291)>0 then
      print("Applying Fire Ammonite bait.")
      UseItemByName(110291)
    end
  end
  baitFish = C_Timer.NewTicker(1, function() BaitMe() end)
  print("Baiting automatically.")
else
  baitFish:Cancel()
  print("Stopped baiting.")
end