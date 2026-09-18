-- ===========================================================================
--  Production Panel Restrictions - UI Script
--  Provides Dam District based functionality to gameplay scripts.
-- ===========================================================================

include("ProductionPanel_Constants")

-------------------------------------------------------------------------------
-- Data mapping based functions
-------------------------------------------------------------------------------
DistrictWonderMapping = nil

function GetDisabledDistrictWonderRequirements()
    DistrictWonderMapping = {}
    for districtType, config in pairs(DistrictConfig) do
        if config["Disabled"] then
            local string = nil
            for row in GameInfo.Buildings() do
                if row.IsWonder and row.AdjacentDistrict == districtType then
                    local name = Locale.Lookup(row.Name)
                    if string == nil then
                        string = "Disabled except as prereq for " .. name
                    else
                        string = string .. ", " .. name
                    end
                end
            end
            if string == nil then
                string = "Disabled except for city marked for district"
            end
            DistrictWonderMapping[districtType] = string
        end
    end
end

TiersByBuildingType = nil
BuildingTypesByTier = nil

function GetBuildingTierHierarchy()
    TiersByBuildingType = {}
    BuildingTypesByTier = {}
    local prereqData = {}
    for row in GameInfo.Buildings() do
        if (
            not row.InternalOnly
            and row.TraitType == nil
            and #row.ReplacesCollection
            and not row.IsWonder
        ) then
            if prereqData[row.PrereqDistrict] == nil then
                prereqData[row.PrereqDistrict] = {}
            end
            prereqData[row.PrereqDistrict][row.BuildingType] = true
        end
    end

    for row in GameInfo.BuildingPrereqs() do
        local districtType = GameInfo.Buildings[row.Building].PrereqDistrict
        if districtType ~= nil then
            if (
                prereqData[districtType][row.PrereqBuilding] ~= nil
                and prereqData[districtType][row.Building] ~= nil
            ) then
                prereqData[districtType][row.Building] = row.PrereqBuilding
            end
        end
    end

    for districtType, prereqBuildings in pairs(prereqData) do
        BuildingTypesByTier[districtType] = {}
        for buildingType in pairs(prereqBuildings) do
            local tier = 1
            local currentBuildingType = buildingType
            while currentBuildingType do
                currentBuildingType = prereqBuildings[currentBuildingType]
                if (
                    currentBuildingType ~= nil and
                    currentBuildingType ~= true
                ) then
                    tier = tier + 1
                end
            end

            if BuildingTypesByTier[districtType][tier] == nil then
                BuildingTypesByTier[districtType][tier] = {}
            end

            TiersByBuildingType[buildingType] = tier
            table.insert(BuildingTypesByTier[districtType][tier], buildingType)
        end
    end
end

-------------------------------------------------------------------------------
-- Current counts based helper functions
-------------------------------------------------------------------------------
function GetDistrictCount(playerID, districtType)
    local count = 0
    local index = GameInfo.Districts[districtType].Index
    local player = Players[playerID]
    local cities = player:GetCities()
    for _, city in cities:Members() do
        local districts = city:GetDistricts()
        if districts:HasDistrict(index) then
            count = count + 1
        else
            local queue = city:GetBuildQueue()
            local length = queue:GetSize()
            for i = 0, length - 1 do
                local item = queue:GetAt(i)
                if item.DistrictType == index then
                    count = count + 1
                    break
                end
            end
        end
    end
    return count
end

function GetBuildingCount(playerID, districtType, index, isTier)
    local buildingTypes = {index}
    if isTier then
        local tiers = BuildingTypesByTier[districtType] or {}
        buildingTypes = tiers[index] or {}
    end

    local count = 0
    if #buildingTypes == 0 then
        return count
    end

    local player = Players[playerID]
    local cities = player:GetCities()
    for _, city in cities:Members() do
        local buildings = city:GetBuildings()
        local queue = city:GetBuildQueue()
        for i = 1, #buildingTypes do
            local found = false
            local buildingType = buildingTypes[i]
            local buildingIndex = GameInfo.Buildings[buildingType].Index
            if (
                buildings:HasBuilding(buildingIndex)
                or queue:HasBeenPlaced(buildingIndex)
            ) then
                found = true
                count = count + 1
                break
            end

            local length = queue:GetSize()
            for n = 0, length - 1 do
                local item = queue:GetAt(n)
                if item.BuildingType == buildingIndex then
                    found = true
                    count = count + 1
                    break
                end
            end

            if found then
                break
            end
        end
    end
    return count
end

-------------------------------------------------------------------------------
-- District based Function restrictions
-------------------------------------------------------------------------------
function CheckDamRestricted(obj)
    local city = CityManager.GetCity(obj.playerID, obj.cityID)
    local districtHash = GameInfo.Districts["DISTRICT_DAM"].Hash
    local riverDamPlots = GetCityRelatedPlotIndexesDistrictsAlternative(
        city, districtHash
    )
    local riverNamesMap = {}
    local riverNamesArray = {}
    local riverPlotID = nil
    for i = 1, #riverDamPlots do
        local plotID = riverDamPlots[i]
        local plot = Map.GetPlotByIndex(plotID)
        local riverName = RiverManager.GetRiverName(plot)
        if riverNamesMap[riverName] == nil then
            riverPlotID = plotID
            riverNamesMap[riverName] = true
            table.insert(riverNamesArray, riverName)
        end
    end
    if #riverNamesArray > 1 then
        return false, ""
    end

    if riverPlotID == nil then
        return false, ""
    end

    -- if only 1 river, find if river has dam pin or Great Bath
    local rivers = RiverManager.EnumerateRivers(riverPlotID)
    local river = rivers[1]
    local riverPlots = {}
    for i = 1, #river.Edges do
        local edge = river.Edges[i]
        for n = 1, #edge do
            local plotID = edge[n]
            if riverPlots[plotID] == nil then
                riverPlots[plotID] = true
                local plot = Map.GetPlotByIndex(plotID)
                if plot:GetDistrictType() == WONDER_INDEX then
                    local checkCity = Cities.GetPlotPurchaseCity(plot)
                    if checkCity ~= nil then
                        local districts = city:GetDistricts()
                        local district = districts:GetDistrict(WONDER_INDEX)
                        local location = district:GetLocation()
                        local buildingIndex = nil
                        if district:IsComplete() then
                            local buildings = city:GetBuildings()
                            buildingIndex = buildings:GetBuildingsAtLocation(
                                location
                            )
                        else
                            local queue = city:GetBuildQueue()
                            local buildings = queue:GetConstructionsAtLocation(
                                location
                            )
                            buildingIndex = buildings[1]
                        end
                        if buildingIndex == GREAT_BATH_BUILDING_INDEX then
                            return true, "No suitable location to zone this district"
                        end
                    end
                end
            end
        end
    end

    local config = PlayerConfigurations[obj.playerID]
    local pins = config:GetMapPins()
    for _, pin in pairs(pins) do
        local x = pin:GetHexX()
        local y = pin:GetHexY()
        local plot = Map.GetPlot(x, y)
        local plotID = plot:GetIndex()
        if riverPlots[plotID] ~= nil then
            local iconName = pin:GetIconName():gsub("^ICON_", "")
            local info = GameInfo.Buildings[iconName]
            if info ~= nil and info.Index == GREAT_BATH_BUILDING_INDEX then
                return true, "No suitable location to zone this district"
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Building based Function restrictions
-------------------------------------------------------------------------------
function RestrictForStableGovernor(obj, stableGovernorState)
    local city = CityManager.GetCity(obj.playerID, obj.cityID)
    local governor = city:GetAssignedGovernor()
    local hasStableGovernor = false
    if (
        governor ~= nil and
        StableGovernors[governor:GetType()] == true
    ) then
        hasStableGovernor = true
    end

    if stableGovernorState and not hasStableGovernor then
        return true, "Only allowed for cities with a stable governor."
    end
    if hasStableGovernor and not stableGovernorState then
        return true, "Not allowed for cities with a stable governor."
    end
    return false, ""
end

function RestrictForTier2HolySite(obj, mountainState)
    local hasMountains = obj.mountainCount >= MIN_MOUNTAIN_COUNT_FOR_MONASTERY
    if hasMountains and not mountainState then
        return true, "Enough mountains to prioritize the Monastery."
    end
    if mountainState and not hasMountains then
        return true, "Not enough mountains to prioritize the Monastery."
    end
    return false, ""
end

function CanCityBuildBuilding(obj, buildingType)
    local city = CityManager.GetCity(obj.playerID, obj.cityID)
    local queue = city:GetBuildQueue()
    return queue:CanProduce(buildingType)
end

-----------------------------------------
-- Museum of Art/Archaeology Functions
-----------------------------------------
function RestrictMuseumsForArtifacts(obj, isForArtifacts)
    local artifactCount = GetArtifactCount(obj.playerID)
    local allowedCount = math.ceil(artifactCount / 3)
    local currentCount = GetBuildingCount(
        obj.playerID, MUSEUM_OF_ARCHAEOLOGY_INDEX
    )
    if currentCount < allowedCount and not isForArtifacts then
        return true, "Quota for Museum of Archaeology not met, yet."
    elseif currentCount >= allowedCount and isForArtifacts then
        return true, "Quota for Museum of Archaeology already met."
    end

    return false, ""
end

function GetArtifactCount(playerID)
    local count = 0
    local iW, iH = Map.GetGridSize()
    for x = 0, iW - 1 do
        for y = 0, iH -1 do
            local plot = Map.GetPlot(x, y)
            local resourceType = plot:GetResourceType()
            if (
                resourceType == ANTIQUITY_SITE_INDEX
                or resourceType == SHIPWRECK_INDEX
            ) then
                count = count + 1
            end
        end
    end

    local player = Players[playerID]
    local cities = player:GetCities()
    for _, city in cities:Members() do
        local buildings = city:GetBuildings()
        if buildings:HasBuilding(MUSEUM_OF_ARCHAEOLOGY_INDEX) then
            local length = buildings:GetNumGreatWorkSlots(MUSEUM_OF_ARCHAEOLOGY_INDEX)
            for i = 0, length - 1 do
                local index = buildings:GetGreatWorkInSlot(MUSEUM_OF_ARCHAEOLOGY_INDEX, i)
                if index ~= -1 then
                    count = count + 1
                end
            end
        end
    end
    return count
end

print("=== Production Panel Restrictions (Helpers) Loaded ===")
