
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
            local pinName = pin:GetIconName():gsub("^ICON_", "")
            local buildingInfo = GameInfo.Buildings[pinName]
            if buildingInfo ~= nil and buildingInfo.IsWonder then
                self.wonderName = pinName
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

    self.prereqBuildings = {}
    if self.prereqDistrict ~= nil then
        local function StorePrereqsForBuilding(info)
            if #info.PrereqBuildingCollection > 0 then
                for i = 1, #info.PrereqBuildingCollection do
                    local newInfo = info.PrereqBuildingCollection[i]
                    self.prereqBuildings[info.BuildingType] = true
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
    local districtConfig = DistrictConfig[baseDistrictType]
    if districtConfig ~= nil then
        local currentEraIndex = Game.GetEras():GetCurrentEra()
        if baseDistrictType ~= self.prereqDistrict then
            if districtConfig["Disabled"] then
                local string = DistrictWonderMapping[self.wonderName]
                if string == nil then
                    string = "Always disabled"
                end
                return true, string
            end

            if (
                districtConfig["Era"] ~= nil and
                currentEraIndex < districtConfig["Era"]
            ) then
                local eraInfo = GameInfo.Eras[districtConfig["Era"]]
                local eraName = Locale.Lookup(eraInfo.Name)
                return true, "Disabled until the " .. eraName .. "."
            end
        end

        if districtConfig["Function"] ~= nil then
            return districtConfig["Function"](self)
        end
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
    return false, ""
end

function CityProductionManager:IsBuildingBlocked(
    districtType, buildingType, isWonder
)
    if isWonder then
        if buildingType ~= self.wonderName then
            return true, "This wonder is for a different city."
        end
    else
        local districtConfig = DistrictConfig[districtType]
        local buildingConfigs = districtConfig["Buildings"] or {}
        local buildingConfig = buildingConfigs
        -- local x = {};
        -- for row in GameInfo.BuildingReplaces() do
        --     local y = row.CivUniqueBuildingType;
        --     local z = row.ReplacesBuildingType;
        --     if x[y] == nil then
        --         x[y] = {};
        --     end;
        --     table.insert(x[y], z);
        -- end;
        -- for k, v in pairs(x) do
        --     print(k);
        --     for i = 1, #v do
        --         print("", v[i]);
        --     end;
        -- end;
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
