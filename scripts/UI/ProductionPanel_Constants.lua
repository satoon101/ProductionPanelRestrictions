-- ===========================================================================
--  Production Panel Restrictions (Config) - Gameplay Script
--  Provides Constants for use in configurations and restrictions.
-- ===========================================================================

-- ERA REFERENCE:
--      0 = ERA_ANCIENT
--      1 = ERA_CLASSICAL (turn 61)
--      2 = ERA_MEDIEVAL (turn 121)
--      3 = ERA_RENAISSANCE (turn 181)
--      4 = ERA_INDUSTRIAL (turn 241)
--      5 = ERA_MODERN (turn 301)
--      6 = ERA_ATOMIC (turn 361)
--      7 = ERA_INFORMATION (turn 421)
--      8 = ERA_FUTURE (turn 481)

ANCIENT_ERA_INDEX = GameInfo.Eras["ERA_ANCIENT"].Index
CLASSICAL_ERA_INDEX = GameInfo.Eras["ERA_CLASSICAL"].Index
MEDIEVAL_ERA_INDEX = GameInfo.Eras["ERA_MEDIEVAL"].Index
RENAISSANCE_ERA_INDEX = GameInfo.Eras["ERA_RENAISSANCE"].Index
INDUSTRIAL_ERA_INDEX = GameInfo.Eras["ERA_INDUSTRIAL"].Index
MODERN_ERA_INDEX = GameInfo.Eras["ERA_MODERN"].Index
ATOMIC_ERA_INDEX = GameInfo.Eras["ERA_ATOMIC"].Index
INFORMATION_ERA_INDEX = GameInfo.Eras["ERA_INFORMATION"].Index
FUTURE_ERA_INDEX = GameInfo.Eras["ERA_FUTURE"].Index

CULTURAL_HERITAGE_INDEX = GameInfo.Civics["CIVIC_CULTURAL_HERITAGE"].Index

GREAT_BATH_BUILDING_INDEX = GameInfo.Buildings["BUILDING_GREAT_BATH"].Index
MUSEUM_OF_ART_INDEX = GameInfo.Buildings["BUILDING_MUSEUM_ART"].Index
MUSEUM_OF_ARCHAEOLOGY_INDEX = GameInfo.Buildings["BUILDING_MUSEUM_ARTIFACT"].Index

WONDER_DISTRICT_INDEX = GameInfo.Districts["DISTRICT_WONDER"].Index

ANTIQUITY_SITE_INDEX = GameInfo.Resources["RESOURCE_ANTIQUITY_SITE"].Index
SHIPWRECK_INDEX = GameInfo.Resources["RESOURCE_SHIPWRECK"].Index

VICTOR_INDEX = GameInfo.Governors["GOVERNOR_THE_DEFENDER"].Index
AMANI_INDEX = GameInfo.Governors["GOVERNOR_THE_AMBASSADOR"].Index
MOKSHA_INDEX = GameInfo.Governors["GOVERNOR_THE_CARDINAL"].Index
MAGNUS_INDEX = GameInfo.Governors["GOVERNOR_THE_RESOURCE_MANAGER"].Index
LIANG_INDEX = GameInfo.Governors["GOVERNOR_THE_BUILDER"].Index
PINGALA_INDEX = GameInfo.Governors["GOVERNOR_THE_EDUCATOR"].Index
REYNA_INDEX = GameInfo.Governors["GOVERNOR_THE_MERCHANT"].Index

StableGovernorBuildings = {
    BUILDING_JNR_MINT = true,
    BUILDING_JNR_ALTAR = true,
}

CityDistrictPurposesByType = {
    DISTRICT_COMMERCIAL_HUB = "commerce",
    DISTRICT_HARBOR = "commerce",
    DISTRICT_ENTERTAINMENT_COMPLEX = "entertainment",
    DISTRICT_WATER_ENTERTAINMENT_COMPLEX = "entertainment",
    DISTRICT_INDUSTRIAL_ZONE = "power",
    DISTRICT_THEATER = "culture",
    DISTRICT_ENCAMPMENT = "bonus",
    DISTRICT_HOLY_SITE = "bonus",
}

MIN_MOUNTAIN_COUNT_FOR_MONASTERY = 3

TIER_ONE = 1
TIER_TWO = 2
TIER_THREE = 3
TIER_FOUR = 4

DistrictPurposesArray = {}
for key, value in pairs(CityDistrictPurposesByType) do
    if DistrictPurposesArray[value] == nil then
        DistrictPurposesArray[value] = {}
    end
    table.insert(DistrictPurposesArray[value], key)
end

DistrictPurposesMapping = {}
for key, value in pairs(DistrictPurposesArray) do
    if #value == 2 then
        if DistrictPurposesMapping[key] == nil then
            DistrictPurposesMapping[key] = {}
        end
        local item1 = DistrictPurposesArray[key][1]
        local item2 = DistrictPurposesArray[key][2]
        DistrictPurposesMapping[key][item1] = item2
        DistrictPurposesMapping[key][item2] = item1
    end
end

print("=== Production Panel Restrictions (Constants) Loaded ===")
