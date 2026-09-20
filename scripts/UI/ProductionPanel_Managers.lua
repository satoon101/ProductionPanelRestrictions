
include("ProductionPanel_Config")

CityProductionManager = {}
CityProductionManager.__index = CityProductionManager
CityProductionManager.Registry = {}

function CityProductionManager:new(playerID, cityID)
    local city = CityManager.GetCity(playerID, cityID)
    local iX = city:GetX()
    local iY = city:GetY()
    local cityPlotIDMap = {}
    local cityPlotIDArray = {}
    local radiusPlots = Map.GetNeighborPlots(iX, iY, 3)
    for i = 1, #radiusPlots do
        local plotID = radiusPlots[i]:GetIndex()
        cityPlotIDMap[plotID] = true
        table.insert(cityPlotIDArray, plotID)
    end
    local plot = Map.GetPlot(iX, iY)
    local plotID = plot:GetIndex()
    if CityProductionManager.Registry[plotID] then
        return CityProductionManager.Registry[plotID]
    end

    local instance = {
        playerID = playerID,
        cityID = cityID,
        plotID = plotID,
        cityPlotIDArray = cityPlotIDArray,
        cityPlotIDMap = cityPlotIDMap,
        mountainCount = nil,
        wonderName = nil,
        wonderEstablished = false,
        prereqDistrict = nil,
        prereqBuildings = {},
        prereqBuildingsByTier = {},
        districtPurposes = {},
    }

    setmetatable(instance, self)
    instance:GetWonderPrereqInfo()
    CityProductionManager.Registry[plotID] = instance
    return instance
end

function CityProductionManager:HasAllDistrictPurposes()
    self:GetCurrentDistrictPurposes()
    for purpose, _ in pairs(DistrictPurposesArray) do
        if self.districtPurposes[purpose] == nil then
            return false
        end
    end
    return true
end

function CityProductionManager:HasDistrict(districtType)
    local city = CityManager.GetCity(self.playerID, self.cityID)
    local districts = city:GetDistricts()
    return districts:HasDistrict(GameInfo.Districts[districtType].Index)
end

function CityProductionManager:GetCurrentDistrictPurposes()
    local city = CityManager.GetCity(self.playerID, self.cityID)
    local districts = city:GetDistricts()
    self.districtPurposes = {}
    for districtType, purpose in pairs(CityDistrictPurposesByType) do
        local index = GameInfo.Districts[districtType].index
        if districts:HasDistrict(index) then
            self.districtPurposes[purpose] = districtType
        end
    end
end

function CityProductionManager:GetMountainCount()
    self.mountainCount = 0
    for i = 1, #self.cityPlotIDArray do
        local plotID = self.cityPlotIDArray[i]
        local plot = Map.GetPlotByIndex(plotID)
        if plot:IsMountain() then
            self.mountainCount = self.mountainCount + 1
        end
    end
    return self.mountainCount
end

function CityProductionManager:GetWonderForCity()
    self.wonderName = nil
    local config = PlayerConfigurations[self.playerID]
    local pins = config:GetMapPins()
    for _, pin in pairs(pins) do
        local iX = pin:GetHexX()
        local iY = pin:GetHexY()
        local plot = Map.GetPlot(iX, iY)
        local plotID = plot:GetIndex()
        if self.cityPlotIDMap[plotID] ~= nil then
            local iconName = pin:GetIconName():gsub("^ICON_", "")
            local buildingInfo = GameInfo.Buildings[iconName]
            if buildingInfo ~= nil and buildingInfo.IsWonder then
                self.wonderName = iconName
                return
            end
        end
    end
    local city = CityManager.GetCity(self.playerID, self.cityID)
    local districts = city:GetDistricts()
    local district = districts:GetDistrict(WONDER_INDEX)
    if district ~= nil then
        local location = district:GetLocation()
        local buildingIndex = nil
        if district:IsComplete() then
            local buildings = city:GetBuildings()
            buildingIndex = buildings:GetBuildingsAtLocation(location)[1]
        else
            local queue = city:GetBuildQueue()
            local buildings = queue:GetConstructionsAtLocation(location)
            buildingIndex = buildings[1]
        end
        if buildingIndex ~= nil then
            local info = GameInfo.Buildings[buildingIndex]
            if info.IsWonder then
                self.wonderName = info.BuildingType
                return
            end
        end
    end
end

function CityProductionManager:GetWonderPrereqInfo()
    self:GetWonderForCity()
    if self.wonderName == nil then
        return
    end

    if self.wonderEstablished then
        return
    end

    self.prereqDistrict = nil
    local buildingInfo = GameInfo.Buildings[self.wonderName]
    if buildingInfo.AdjacentDistrict ~= nil then
        self.prereqDistrict = buildingInfo.AdjacentDistrict
    elseif #buildingInfo.PrereqBuildingCollection > 0 then
        local prereqInfo = buildingInfo.PrereqBuildingCollection[1]
        local districtInfo = GameInfo.Districts[prereqInfo.PrereqDistrict]
        self.prereqDistrict = districtInfo.DistrictType
    end

    if TiersByBuildingType == nil then
        GetBuildingTierHierarchy()
    end

    self.prereqBuildings = {}
    self.prereqBuildingsByTier = {}
    if self.prereqDistrict ~= nil then
        local function StorePrereqsForBuilding(info)
            if #info.PrereqBuildingCollection > 0 then
                for i = 1, #info.PrereqBuildingCollection do
                    local newInfo = info.PrereqBuildingCollection[i]
                    local building = newInfo.BuildingType
                    local buildingTier = TiersByBuildingType[building]
                    if self.prereqBuildingsByTier[buildingTier] == nil then
                        self.prereqBuildingsByTier[buildingTier] = {}
                    end
                    self.prereqBuildings[building] = true
                    self.prereqBuildingsByTier[buildingTier][building] = true
                    StorePrereqsForBuilding(newInfo)
                end
            end
        end
        StorePrereqsForBuilding(buildingInfo)
    end
end

function CityProductionManager:IsDistrictBlocked(districtType)
    if DistrictWonderMapping == nil then
        GetDisabledDistrictWonderRequirements()
    end
    local baseDistrictType = districtType
    local replaceInfo = GameInfo.DistrictReplaces[districtType]
    if replaceInfo ~= nil then
        baseDistrictType = replaceInfo.ReplacesDistrictType
    end
    if baseDistrictType == self.prereqDistrict then
        return false, ""
    end

    local districtConfig = DistrictConfig[baseDistrictType] or {}
    local currentEraIndex = Game.GetEras():GetCurrentEra()
    if districtConfig["Disabled"] then
        local string = DistrictWonderMapping[self.wonderName]
        if string == nil then
            string = "Always disabled"
        end
        return true, string
    end

    local era = districtConfig["Era"]
    if era ~= nil and currentEraIndex < era then
        local eraName = Locale.Lookup(GameInfo.Eras[era].Name)
        return true, "Disabled until the " .. eraName .. "."
    end

    if districtConfig["Function"] ~= nil then
        return districtConfig["Function"](self)
    end

    if CityDistrictPurposesByType[baseDistrictType] then
        local purpose = CityDistrictPurposesByType[baseDistrictType]
        local purposeMap = DistrictPurposesMapping[purpose]
        if purposeMap ~= nil and purposeMap[baseDistrictType] then
            local checkDistrictType = purposeMap[baseDistrictType]
            if self:HasDistrict(checkDistrictType) then
                if not self:HasAllDistrictPurposes() then
                    local string = "Disabled until all purposes have been met."
                    return true, string
                end
            end
        end
    end

    local quotaData = districtConfig["Quota"] or {}
    local quota = quotaData[currentEraIndex]
    if quota ~= nil then
        local currentCount = GetDistrictCount(self.playerID, districtType)
        if currentCount >= quota then
            return true, "Quota for this era has already been met."
        end
    end

    return false, ""
end

function CityProductionManager:IsBuildingBlocked(
    districtType, buildingType, isWonder
)
    if isWonder and buildingType ~= self.wonderName then
        return true, "This wonder is for a different city."
    end

    local baseDistrictType = districtType
    local replaceInfo = GameInfo.DistrictReplaces[districtType]
    if replaceInfo ~= nil then
        baseDistrictType = replaceInfo.ReplacesDistrictType
    end
    local districtConfig = DistrictConfig[baseDistrictType] or {}
    local buildingConfigs = districtConfig["Buildings"] or {}
    local baseBuildingType = buildingType
    local info = GameInfo.Buildings[buildingType]
    if #info.ReplacesCollection == 1 then
        baseBuildingType = info.ReplacesCollection[1].ReplacesBuildingType
    elseif #info.ReplacesCollection > 1 then
        for i = 1, #info.ReplacesCollection do
            local row = info.ReplacesCollection[i]
            local buildingConfig = buildingConfigs[row.ReplacesBuildingType] or {}
            local isDisabled = buildingConfig["Disabled"] or false
            if not isDisabled or i == #info.ReplacesCollection then
                baseBuildingType = row.ReplacesBuildingType
                break
            end
        end
    end

    local tier = TiersByBuildingType[baseBuildingType] or -1
    local isRequiredForWonder = false
    if self.prereqBuildings[baseBuildingType] ~= nil then
        isRequiredForWonder = true
        if tier ~= nil then
            local tierData = BuildingTypesByTier[baseDistrictType] or {}
            tierData = tierData[tier] or {}
            if #tierData > 0 then
                for i = 1, #tierData do
                    local thisBuildingType = tierData[i]
                    local thisConfig = buildingConfigs[thisBuildingType] or {}
                    if (
                        thisConfig["Disabled"] ~= true and
                        self.prereqBuildings[thisBuildingType] ~= nil
                    ) then
                        isRequiredForWonder = false
                    end
                end
            end
        end
    end

    if baseDistrictType == self.prereqDistrict then
        if (
            self.prereqBuildingsByTier[tier] ~= nil and
            self.prereqBuildingsByTier[tier][baseBuildingType] == nil
        ) then
            return true, "Only prerequisite building(s) for district/tier allowed for city wonder."
        end
    end

    if isRequiredForWonder then
        return false, ""
    end

    local buildingConfig = buildingConfigs[baseBuildingType] or {}
    local tierConfig = buildingConfigs[tier] or {}
    local isDisabled = (
        buildingConfig["Disabled"] or tierConfig["Disabled"] or false
    )
    local capitalOnly = (
        buildingConfig["CapitalOnly"] or tierConfig["CapitalOnly"] or false
    )
    if capitalOnly == true then
        local city = CityManager.GetCity(self.playerID, self.cityID)
        if not city:IsCapital() then
            isDisabled = true
        end
    end

    if isDisabled then
        return true, "Always disabled."
    end

    local runFunction = buildingConfig["Function"] or tierConfig["Function"]
    local argument = buildingConfig["Argument"] or tierConfig["Argument"]
    if runFunction ~= nil then
        local isBlocked, reason = runFunction(self, argument)
        if isBlocked then
            return isBlocked, reason
        end
    end

    local currentEraIndex = Game.GetEras():GetCurrentEra()
    local quotaData = {}
    local isTier = false
    local index = GameInfo.Buildings[buildingType].Index
    if buildingConfig["Quota"] ~= nil then
        quotaData = buildingConfig["Quota"]
    elseif tierConfig["Quota"] ~= nil then
        quotaData = tierConfig["Quota"]
        index = tier
        isTier = true
    end
    local quota = quotaData[currentEraIndex]
    if quota ~= nil then
        local currentCount = GetBuildingCount(
            self.playerID, baseDistrictType, index, isTier
        )
        if currentCount >= quota then
            return true, "Quota for this era has already been met."
        end
    end

    return false, ""
end

function CityProductionManager:GetCurrentBuildingProgress()
    local city = CityManager.GetCity(self.playerID, self.cityID)
    local queue = city:GetBuildQueue()
    local item = queue:GetAt(0)
    if item == nil then
        return nil
    end

    if item.BuildingType == nil then
        return nil
    end

    return queue:GetBuildingProgress(item.BuildingType)
end

print("=== Production Panel Restrictions (Managers) Loaded ===")
