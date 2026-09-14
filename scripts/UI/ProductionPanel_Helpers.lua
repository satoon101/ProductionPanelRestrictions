-- ===========================================================================
--  Production Panel Restrictions - UI Script
--  Provides Dam District based functionality to gameplay scripts.
-- ===========================================================================

include("ProductionPanel_Constants")

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
            local pinName = pin:GetIconName():gsub("^ICON_", "")
            local info = GameInfo.Buildings[pinName]
            if info ~= nil and info.Index == GREAT_BATH_BUILDING_INDEX then
                return true, "No suitable location to zone this district"
            end
        end
    end
end

function RestrictForStableGovernor(obj, stableGovernorState)
    local city = CityManager.GetCity(obj.playerID, obj.cityID)
    local governor = city:GetAssignedGovernor()
    if governor == nil then
        return false, ""
    end

    local hasStableGovernor = StableGovernors[governor:GetType()] or false
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

function GetExistingMuseumsOfAntiquity()
    -- loop through all cities to find 
end

function GetArtifactCount()
    -- loop through Museums of Antiquity and count the number of artifacts
    -- loop through all plots and count the number of artifacts
end

print("=== Production Panel Restrictions (Helpers) Loaded ===")
