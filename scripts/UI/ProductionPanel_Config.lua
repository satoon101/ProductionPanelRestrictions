-- ===========================================================================
--  Production Panel Restrictions (Config) - Gameplay Script
--  Provides Configuration values for restricting districts/buildings.
-- ===========================================================================

include("ProductionPanel_Helpers")

-- District Level Configs:
--      Buildings = Building specific configs for District (see below)
--      Disabled = never allowed to build (exception when required for Wonder)
--      Era = District can't be built until given era
--      Function = Special Function run for District restrictions
--
-- Building Level Configs:
--      Disabled = never allowed to build
--      Function = Special Function run for specific Building restritions
--      Era = Building(s) can't be built until given era
--          If integers are used as keys, they represent the Tier of building

DistrictConfig = {
    DISTRICT_AERODROME = {
        Era = INFORMATION_ERA_INDEX,
    },
    DISTRICT_AQUEDUCT = {
        Disabled = true,
        Buildings = {
            -- Tier 2
            BUILDING_JNR_BATHHOUSE = {
                Disabled = true,
            },
            BUILDING_JNR_HAMMER_WORKS = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = INFORMATION_ERA_INDEX,
            },
            [2] = {
                Era = INFORMATION_ERA_INDEX,
            },
            [3] = {
                Era = INFORMATION_ERA_INDEX,
            },
        },
    },
    DISTRICT_CAMPUS = {
        Disabled = true,
        Buildings = {
            -- Tier 1
            BUILDING_JNR_ACADEMY = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_JNR_SCHOOL = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_LIBERAL_ARTS = {
                Disabled = true,
            },
            -- Tier 4
            BUILDING_JNR_EDUCATION = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = CLASSICAL_ERA_INDEX,
            },
            [2] = {
                Era = RENAISSANCE_ERA_INDEX,
            },
            [3] = {
                Era = ATOMIC_ERA_INDEX,
            },
            [4] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_CANAL = {
        Disabled = true,
    },
    DISTRICT_CITY_CENTER = {
        Buildings = {
            -- Tier 1
            BUILDING_MONUMENT = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_WHARF_TRADE = {
                Disabled = true,
            },
        },
        Tiers = {
            [3] = {
                Era = INDUSTRIAL_ERA_INDEX,
            },
        },
    },
    DISTRICT_COMMERCIAL_HUB = {
        Buildings = {
            -- Tier 1
            BUILDING_JNR_WAYSTATION = {
                Disabled = true,
            },
            BUILDING_JNR_MINT = {
                Function = RestrictForStableGovernor,
                Argument = true,
            },
            BUILDING_MARKET = {
                Function = RestrictForStableGovernor,
                Argument = false,
            },
            -- Tier 2
            BUILDING_JNR_GUILDHALL = {
                Disabled = true,
            },
            BUILDING_JNR_MERCHANT_QUARTER = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_COMMODITY_EXCHANGE = {
                Disabled = true,
            },
            BUILDING_STOCK_EXCHANGE = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = CLASSICAL_ERA_INDEX,
            },
            [2] = {
                Era = INDUSTRIAL_ERA_INDEX,
            },
            [3] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_DAM = {
        Function = CheckDamRestricted,
        Tiers = {
            [1] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_DIPLOMATIC_QUARTER = {
        Disabled = true,
        Era = ATOMIC_ERA_INDEX,
        Buildings = {
            -- Tier 1
            BUILDING_CONSULATE = {
                Disabled = true,
            },
            BUILDING_JNR_CONSULATE_SPIES = {
                Disabled = true,
            },
        },
    },
    DISTRICT_ENCAMPMENT = {
        Buildings = {
            -- Tier 1
            BUILDING_JNR_TARGET_RANGE = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_JNR_CASEMATES = {
                Disabled = true,
            },
            BUILDING_JNR_DEPOT = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_ORDNANCE_BOARD = {
                Disabled = true,
            },
            BUILDING_JNR_PRISON = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = CLASSICAL_ERA_INDEX,
            },
            [2] = {
                Era = RENAISSANCE_ERA_INDEX,
            },
            [3] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_ENTERTAINMENT_COMPLEX = {
        Buildings = {
            -- Tier 1
            BUILDING_ARENA = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_JNR_BOTANICAL_GARDEN = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_CONVENTION = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = CLASSICAL_ERA_INDEX,
            },
            [2] = {
                Era = MODERN_ERA_INDEX,
            },
            [3] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_GOVERNMENT = {
        Disabled = true,
        Buildings = {
            -- Tier 1
            BUILDING_GOV_CONQUEST = {
                Disabled = true,
            },
            BUILDING_GOV_TALL = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_GOV_CITYSTATES = {
                Disabled = true,
            },
            BUILDING_GOV_SPIES = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_GOV_CULTURE = {
                Disabled = true,
            },
            BUILDING_GOV_SCIENCE = {
                Disabled = true,
            },
            -- Tier 4
            BUILDING_GOV_JNR_DIPLOMACY = {
                Disabled = true,
            },
            BUILDING_GOV_JNR_PROPAGANDA = {
                Disabled = true,
            },
        },
    },
    DISTRICT_HARBOR = {
        Buildings = {
            -- Tier 1
            BUILDING_JNR_LIGHTHOUSE_FISHING = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_JNR_ENTREPOT = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_OFFSHORE_TERMINAL = {
                Disabled = true,
            },
            BUILDING_SEAPORT = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = CLASSICAL_ERA_INDEX,
            },
            [2] = {
                Era = RENAISSANCE_ERA_INDEX,
            },
            [3] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_HOLY_SITE = {
        Buildings = {
            -- Tier 1
            BUILDING_JNR_ALTAR = {
                Function = RestrictForStableGovernor,
                Argument = true,
            },
            BUILDING_SHRINE = {
                Function = RestrictForStableGovernor,
                Argument = false,
            },
            -- Tier 2
            BUILDING_JNR_MONASTERY = {
                Function = RestrictForTier2HolySite,
                Argument = true,
            },
            BUILDING_TEMPLE = {
                Function = RestrictForTier2HolySite,
                Argument = false,
            },
            -- Tier 4
            BUILDING_JNR_HOSPITIUM = {
                Disabled = true,
            },
        },
        Tiers = {
            [4] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_INDUSTRIAL_ZONE = {
        Buildings = {
            -- Tier 1
            BUILDING_JNR_WIND_MILL = {
                Function = CanCityBuildBuilding,
                Argument = "BUILDING_JNR_IZ_WATER_MILL",
            },
            -- Tier 2
            BUILDING_JNR_MANUFACTURY = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_FACTORY = {
                Disabled = true,
            },
            -- Tier 4
            BUILDING_COAL_POWER_PLANT = {
                Disabled = true,
            },
            BUILDING_FOSSIL_FUEL_POWER_PLANT = {
                Disabled = true,
            },
            BUILDING_JNR_FREIGHT_YARD = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = INDUSTRIAL_ERA_INDEX,
            },
            [2] = {
                Era = ATOMIC_ERA_INDEX,
            },
            [3] = {
                Era = ATOMIC_ERA_INDEX,
            },
            [4] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
    DISTRICT_NEIGHBORHOOD = {
        Disabled = true,
        Era = ATOMIC_ERA_INDEX,
        Buildings = {
            -- Tier 2
            BUILDING_JNR_ART_GALLERY = {
                Disabled = true,
            },
            BUILDING_JNR_HOSPITAL = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = INFORMATION_ERA_INDEX,
            },
            [2] = {
                Era = INFORMATION_ERA_INDEX,
            },
        },
    },
    DISTRICT_PRESERVE = {
        Era = ATOMIC_ERA_INDEX,
        Buildings = {
        },
        Tiers = {
            [1] = {
                Era = INFORMATION_ERA_INDEX,
            },
        },
    },
    DISTRICT_SPACEPORT = {
        Disabled = true,
        Era = ATOMIC_ERA_INDEX,
    },
    DISTRICT_THEATER = {
        Era = ATOMIC_ERA_INDEX,
        Buildings = {
            -- Tier 1
            BUILDING_JNR_ASSEMBLY = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_JNR_CABINET = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_OPERA = {
                Disabled = true,
            },
            BUILDING_MUSEUM_ART = {
                -- TODO: add function
                Function = nil,
            },
            BUILDING_MUSEUM_ARTIFACT = {
                -- TODO: add function
                Function = nil,
            },
            -- Tier 4
            BUILDING_BROADCAST_CENTER = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = ATOMIC_ERA_INDEX,
            },
            [2] = {
                Era = ATOMIC_ERA_INDEX,
            },
            [3] = {
                Era = INFORMATION_ERA_INDEX,
            },
            [4] = {
                Era = INFORMATION_ERA_INDEX,
            },
        },
    },
    DISTRICT_WATER_ENTERTAINMENT_COMPLEX = {
        Buildings = {
            -- Tier 1
            BUILDING_JNR_MARINA = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_AQUARIUM = {
                Disabled = true,
            },
            -- Tier 3
            BUILDING_JNR_CRUISE_TERMINAL = {
                Disabled = true,
            },
        },
        Tiers = {
            [1] = {
                Era = INDUSTRIAL_ERA_INDEX,
            },
            [2] = {
                Era = MODERN_ERA_INDEX,
            },
            [3] = {
                Era = ATOMIC_ERA_INDEX,
            },
        },
    },
}

-- Stable Governors are governors that never change cities once established
StableGovernors = {
    [VICTOR_INDEX] = false,
    [AMANI_INDEX] = false,
    [MOKSHA_INDEX] = true,
    [MAGNUS_INDEX] = false,
    [LIANG_INDEX] = true,
    [PINGALA_INDEX] = true,
    [REYNA_INDEX] = false,
}

print("=== Production Panel Restrictions (Config) Loaded ===")
