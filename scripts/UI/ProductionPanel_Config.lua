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
--      Quota = A table used to limit the count by era (see below)
--          When using Quota, you should also specify an Era
--
-- Building Level Configs:
--      Keys can be building names or tier names
--      CapitalOnly = never allowed to build except in the capital
--      Disabled = never allowed to build
--      Era = Building/tier disabled until the given Era
--      Function = Special Function run for specific building/tier
--      Argument = Extra argument value passed to the Special Function
--      Quota = An object used to limit the count per building/tier by era (see below)
--          When using Quota, you should also specify an Era
--
-- Quota Level Configs:
--      Keys are always indexes representing an Era
--      Values are the total number allowed per Era for the building/tier

DistrictConfig = {
    DISTRICT_AERODROME = {
        Era = INFORMATION_ERA_INDEX,
    },
    DISTRICT_AQUEDUCT = {
        Disabled = true,
        Buildings = {
            [TIER_ONE] = {
                Era = INFORMATION_ERA_INDEX,
            },

            [TIER_TWO] = {
                Era = INFORMATION_ERA_INDEX,
            },

            [TIER_THREE] = {
                Era = INFORMATION_ERA_INDEX,
            },

            -- Tier 2
            BUILDING_JNR_BATHHOUSE = {
                Disabled = true,
            },
            BUILDING_JNR_HAMMER_WORKS = {
                Disabled = true,
            },
        },
    },
    DISTRICT_CAMPUS = {
        Disabled = true,
        Buildings = {
            [TIER_ONE] = {
                Era = ATOMIC_ERA_INDEX,
            },

            [TIER_TWO] = {
                Era = ATOMIC_ERA_INDEX,
            },

            [TIER_THREE] = {
                Era = ATOMIC_ERA_INDEX,
            },

            [TIER_FOUR] = {
                Era = ATOMIC_ERA_INDEX,
            },

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
    },
    DISTRICT_CANAL = {
        Disabled = true,
    },
    DISTRICT_CITY_CENTER = {
        Buildings = {
            [TIER_THREE] = {
                Era = INDUSTRIAL_ERA_INDEX,
            },

            -- Tier 1
            BUILDING_MONUMENT = {
                CapitalOnly = true,
            },
            -- Tier 3
            BUILDING_JNR_WHARF_TRADE = {
                Disabled = true,
            },
        },
    },
    DISTRICT_COMMERCIAL_HUB = {
        Quota = {
            [CLASSICAL_ERA_INDEX] = 6,
            [MEDIEVAL_ERA_INDEX] = 10,
            [RENAISSANCE_ERA_INDEX] = 16,
            [INDUSTRIAL_ERA_INDEX] = 20,
            [MODERN_ERA_INDEX] = 30,
        },
        Buildings = {
            [TIER_ONE] = {
                Era = CLASSICAL_ERA_INDEX,
                Quota = {
                    [CLASSICAL_ERA_INDEX] = 4,
                    [MEDIEVAL_ERA_INDEX] = 8,
                    [RENAISSANCE_ERA_INDEX] = 12,
                    [INDUSTRIAL_ERA_INDEX] = 16,
                    [MODERN_ERA_INDEX] = 24,
                },
            },

            [TIER_TWO] = {
                Era = INDUSTRIAL_ERA_INDEX,
                Quota = {
                    [INDUSTRIAL_ERA_INDEX] = 12,
                    [MODERN_ERA_INDEX] = 18,
                },
            },

            [TIER_THREE] = {
                Era = ATOMIC_ERA_INDEX,
            },

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
    },
    DISTRICT_DAM = {
        Function = CheckDamRestricted,
        Buildings = {
            [TIER_ONE] = {
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
        Era = MODERN_ERA_INDEX,
        Quota = {
            [MODERN_ERA_INDEX] = 20,
        },
        Buildings = {
            [TIER_ONE] = {
                Era = MODERN_ERA_INDEX,
                Quota = {
                    [MODERN_ERA_INDEX] = 15,
                },
            },

            [TIER_TWO] = {
                Era = RENAISSANCE_ERA_INDEX,
                Quota = {
                    [MODERN_ERA_INDEX] = 12,
                },
            },

            [TIER_THREE] = {
                Era = ATOMIC_ERA_INDEX,
            },

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
    },
    DISTRICT_ENTERTAINMENT_COMPLEX = {
        Buildings = {
            [TIER_ONE] = {
                Era = CLASSICAL_ERA_INDEX,
            },

            [TIER_TWO] = {
                Era = MODERN_ERA_INDEX,
                Quota = {
                    [MODERN_ERA_INDEX] = 16,
                },
            },

            [TIER_THREE] = {
                Era = ATOMIC_ERA_INDEX,
            },

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
        Era = MEDIEVAL_ERA_INDEX,
        Buildings = {
            [TIER_ONE] = {
                Era = CLASSICAL_ERA_INDEX,
            },

            [TIER_TWO] = {
                Era = RENAISSANCE_ERA_INDEX,
            },

            [TIER_THREE] = {
                Era = ATOMIC_ERA_INDEX,
            },

            -- Tier 1
            BUILDING_JNR_LIGHTHOUSE_FISHING = {
                Disabled = true,
            },
            -- Tier 2
            BUILDING_JNR_ENTREPOT = {
                Disabled = true,
            },
            -- TODO: implement these functions
            BUILDING_SHIPYARD = {
                Function = nil,
            },
            BUILDING_JNR_FISH_MARKET = {
                Function = nil,
            },
            -- Tier 3
            BUILDING_JNR_OFFSHORE_TERMINAL = {
                Disabled = true,
            },
            BUILDING_SEAPORT = {
                Disabled = true,
            },
        },
    },
    DISTRICT_HOLY_SITE = {
        Buildings = {
            [TIER_FOUR] = {
                Era = ATOMIC_ERA_INDEX,
            },

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
    },
    DISTRICT_INDUSTRIAL_ZONE = {
        Era = INDUSTRIAL_ERA_INDEX,
        Quota = {
            [INDUSTRIAL_ERA_INDEX] = 20,
            [MODERN_ERA_INDEX] = 30,
        },
        Buildings = {
            [TIER_ONE] = {
                Era = INDUSTRIAL_ERA_INDEX,
                Quota = {
                    [INDUSTRIAL_ERA_INDEX] = 10,
                    [MODERN_ERA_INDEX] = 16,
                },
            },

            [TIER_TWO] = {
                Era = ATOMIC_ERA_INDEX,
            },

            [TIER_THREE] = {
                Era = ATOMIC_ERA_INDEX,
            },

            [TIER_FOUR] = {
                Era = ATOMIC_ERA_INDEX,
            },

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
    },
    DISTRICT_NEIGHBORHOOD = {
        Disabled = true,
        Era = ATOMIC_ERA_INDEX,
        Buildings = {
            [TIER_ONE] = {
                Era = INDUSTRIAL_ERA_INDEX,
            },

            [TIER_TWO] = {
                Era = INDUSTRIAL_ERA_INDEX,
            },

            -- Tier 2
            BUILDING_JNR_ART_GALLERY = {
                Disabled = true,
            },
            BUILDING_JNR_HOSPITAL = {
                Disabled = true,
            },
        },
    },
    DISTRICT_PRESERVE = {
        Era = ATOMIC_ERA_INDEX,
        Quota = {
            [ATOMIC_ERA_INDEX] = 1,
            [INFORMATION_ERA_INDEX] = 2,
            [FUTURE_ERA_INDEX] = 3,
        },
        Buildings = {
            [TIER_ONE] = {
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
            [TIER_ONE] = {
                Era = ATOMIC_ERA_INDEX,
            },

            [TIER_TWO] = {
                Era = ATOMIC_ERA_INDEX,
            },

            [TIER_THREE] = {
                Era = INFORMATION_ERA_INDEX,
            },

            [TIER_FOUR] = {
                Era = INFORMATION_ERA_INDEX,
            },

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
                Function = RestrictMuseumsForArtifacts,
                Argument = false,
            },
            BUILDING_MUSEUM_ARTIFACT = {
                Function = RestrictMuseumsForArtifacts,
                Argument = true,
            },
            -- Tier 4
            BUILDING_BROADCAST_CENTER = {
                Disabled = true,
            },
        },
    },
    DISTRICT_WATER_ENTERTAINMENT_COMPLEX = {
        Buildings = {
            [TIER_ONE] = {
                Era = INDUSTRIAL_ERA_INDEX,
                Quota = {
                    [INDUSTRIAL_ERA_INDEX] = 16,
                    [MODERN_ERA_INDEX] = 24,
                },
            },

            [TIER_TWO] = {
                Era = MODERN_ERA_INDEX,
            },

            [TIER_THREE] = {
                Era = ATOMIC_ERA_INDEX,
            },

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
