-- ===========================================================================
--  Production Panel Restrictions - UI Script
--  Overrides ProductionPanel to block certain districts.
-- ===========================================================================

print("=== Production Panel Restrictions (ProductionPanel) Loading ===")

include("ProductionPanel")
include("ProductionPanel_Managers")

local BASE_GetData = GetData

function GetData()
    local data = BASE_GetData()
    if data == nil then
        return data
    end

    local city = data.City
    local cityID = city:GetID()
    local playerID = data.Owner
    local player = Players[playerID]
    if not player:IsHuman() then
        return data
    end

    local obj = CityProductionManager:new(playerID, cityID)
    if obj == nil then
        return data
    end

    --------------------------------------------------------------------------
    -- Block production of Districts
    --------------------------------------------------------------------------
    if #data.DistrictItems > 0 then
        for i = 1, #data.DistrictItems do
            local item = data.DistrictItems[i]
            if (
                not item.Disabled and
                not item.HasBeenBuilt and
                item.Progress == 0
            ) then
                local isBlocked, reason = obj:IsDistrictBlocked(item.Type)
                if isBlocked then
                    item.Disabled = true
                    item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_Red]" .. reason
                end
            end
        end
    end

    --------------------------------------------------------------------------
    -- Block production of Buildings
    --------------------------------------------------------------------------
    local progressData = {}
    local disabledItems = {}
    if #data.BuildingItems > 0 then
        for i = 1, #data.BuildingItems do
            local item = data.BuildingItems[i]
            progressData[item.Type] = item.Progress
            if not item.Disabled and item.Progress == 0 then
                local isBlocked, reason = obj:IsBuildingBlocked(
                    item.PrereqDistrict, item.Type, item.IsWonder
                )
                if isBlocked then
                    item.Disabled = true
                    item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_Red]" .. reason
                    disabledItems[item.Type] = item.ToolTip
                end
            end
        end
    end

    --------------------------------------------------------------------------
    -- Block purchasing of Buildings
    --------------------------------------------------------------------------
    -- the item currently at the front of the queue will not be included,
    --  so we need to retrieve that value separately
    local currentProgressAmount = obj:GetCurrentBuildingProgress()
    if currentProgressAmount ~= nil then
        progressData[data.CurrentProductionType] = currentProgressAmount
    end
    if #data.BuildingPurchases > 0 then
        for i = 1, #data.BuildingPurchases do
            local item = data.BuildingPurchases[i]
            if not item.Disabled then
                local tooltip = disabledItems[item.Type]
                if tooltip ~= nil then
                    item.Disabled = true
                    item.ToolTip = tooltip
                elseif progressData[item.Type] > 0 then
                    item.Disabled = true
                    local reason = "Building process has already begun"
                    item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_Red]" .. reason
                end
            end
        end
    end
    return data
end

print("=== Production Panel Restrictions (ProductionPanel) Loaded ===")
