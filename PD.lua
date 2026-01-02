local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/fawk/refs/heads/main/Epstein%20Highlighter.lua"))();
Bytecode = game:HttpGet("https://raw.githubusercontent.com/DCHARLESAKAMRGREEN/Severe-Luas/main/Libraries/Pseudosynonym.lua")
local Load = luau.load(Bytecode)
local Library = Load()

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Dropped = Workspace:FindFirstChild("DroppedItems")
local Containers = Workspace:FindFirstChild("Containers")
local Vehicles = Workspace:FindFirstChild("Vehicles")
local Zones = Workspace:FindFirstChild("AiZones")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Version = "1.0.0"

local Window = Library:CreateWindow({
    Title = "Project Dih | "..  Workspace:GetAttribute("MapName")..  " | "..  Version,
    Tag = LocalPlayer.Name,
    Keybind = "Insert",
    AutoShow = true
})

local Crates = {
    ["Military"] = {
        "MilitaryCrate",
        "LargeMilitaryBox",
        "SmallMilitaryBox",
        "GrenadeCrate",
        "SupplyDropMilitary",
        "SupplyDropMilitary_XMAS",
        "SupplyDropMilitary_Default"
    },

    ["Civilian"] = {
        "MedBag",
        "PC",
        "Toolbox",
        "CashRegister",
        "SportBag",
        "SatchelBag",
        "Safe",
        "Fridge",
        "FilingCabinet"
    },

    ["EDF"] = {
        "SupplyDropEDF",
        "SupplyDropEDF_XMAS",
        "SupplyDropEDF_Default"
    },

    ["Other"] = {
        "HiddenCache",
        "KGBBag",
        "SerumContainer",
        "ModificationStation",
        "LargeABPOPABox",
        "LargeShippingCrate",
        "SmallShippingCrate"
    }
}

local Items = {
    ["Weapons"] = {
        "AKM",
        "AKMN",
        "AsVal",
        "FAL",
        "IZh81",
        "IZh12",
        "M4",
        "MK23",
        "MP443",
        "MP5SD",
        "Mosin",
        "PKM",
        "PPSH41",
        "R700",
        "RPG7",
        "Saiga12",
        "SKS",
        "SVD",
        "TFZ98S",
        "TT33",
        "VZ61",
        "FlareGun",
        "ADAR15",
        "M9Fade"
    },

    ["Attachments"] = {
        "ACOG",
        "DV2",
        "DAGR",
        "FlashHiderAKM",
        "FlashHiderFAL",
        "FlashHiderKAC",
        "FlashHiderM4",
        "FlashHiderSVD",
        "Flashlight",
        "FrontAKMN",
        "FrontAsVal",
        "FrontFAL",
        "FrontIZh12",
        "FrontIZh81",
        "FrontM4",
        "FrontMK12",
        "FrontPKM",
        "FrontSKS",
        "FrontSVD",
        "FrontSaiga",
        "FrontTimberwolf",
        "FrontADAR",
        "GoldenDV2",
        "HandleAKMN",
        "HandleAsVal",
        "HandleFAL",
        "HandleM4",
        "HandleRK3AKMN",
        "HoloSight",
        "ImprFrontAKM",
        "ImprHandleAKM",
        "ImprStockAKM",
        "KACSuppressor",
        "LaserPointer",
        "LaserPointerOLD",
        "LPVO",
        "MuzzleBrakeAKM",
        "OKP7",
        "OilCanSuppressor",
        "PBS1",
        "PSO1",
        "PistolMuzzleBrake",
        "PolymerStockAKMN",
        "PuScope",
        "Scope6X",
        "SniperScope",
        "SOCOM556",
        "SRO",
        "StockA5",
        "StockAKMN",
        "StockAsVal",
        "StockFAL",
        "StockIZh12",
        "StockIZh81",
        "StockM4",
        "StockMK12",
        "StockMP5",
        "StockPKM",
        "StockPPSH41",
        "StockPT1AKMN",
        "StockSKS",
        "StockSVD",
        "StockADAR",
        "T1Sight",
        "TacticalFrontAKMN",
        "TacticalFrontSKS",
        "TacticalFrontSVD",
        "TacticalStockSKS",
        "TacticalStockSVD",
        "TimberWolfSuppressor",
        "DefaultFrontMosin",
        "DefaultStockMosin"
    },

    ["Magazines"] = {
        "20Rnd556",
        "20rndFAL",
        "762x25MAG",
        "762x25Rnd71Mag",
        "762x25TTMAG",
        "762x39MAG",
        "762x39ImprMAG",
        "762x39Rnd75Mag",
        "762x54Rnd10Mag",
        "762x54Rnd20Mag",
        "9x18MakarovMAG",
        "9x18MakarovDrumMag",
        "9x18vzMag",
        "9x18vzDrumMag",
        "9x19MP443MAG",
        "9x19MP5MAG",
        "9x19MP5DrumMAG",
        "9x39Mag",
        "9x39Rnd30Mag",
        "AmmoBoxPKM100rnd",
        "Mag556",
        "Mag556Rnd100",
        "MagR700",
        "MagTFZ98",
        "MK23ExtMag",
        "PMAG10rnd",
        "SaigaMag5rnd",
        "SaigaMag20rnd"
    },

    ["Ammo"] = {
        "12gaAP",
        "12gaBuckshot",
        "12gaFlechette",
        "12gaSlug",
        "338AP",
        "338T",
        "45AP",
        "45Tracer",
        "556x45AP",
        "556x45Tracer",
        "762x25AP",
        "762x25Tracer",
        "762x39AP",
        "762x39Tracer",
        "762x51AP",
        "762x51Tracer",
        "762x54AP",
        "762x54Tracer",
        "9x18AP",
        "9x18Tracer",
        "9x18Z",
        "9x19AP",
        "9x19Tracer",
        "9x39AP",
        "9x39Z",
        "PG7"
    },

    ["Medical"] = {
        "AI2",
        "AI4",
        "AA2",
        "Bandage",
        "IFAK",
        "Rags",
        "WoundDressing",
        "SerumYellow",
        "SerumRed",
        "SerumGreen"
    },

    ["Armor"] = {
        "6B2",
        "6b 23",
        "6b 27",
        "6b 43",
        "6b 47",
        "6B5",
        "Altyn",
        "Attak5",
        "Bandoiler",
        "ConcealedVest",
        "DozerArmor",
        "FastMT",
        "HSPV",
        "IOTV4",
        "JPC",
        "Kulon",
        "LegArmor",
        "Lynx",
        "MotorcycleHelmet",
        "SSH68",
        "Smersh",
        "TORS",
        "TankCap",
        "Tortilla",
        "ZSh",
        "UNOVest",
        "UNOHelmet",
        "ScavKingVest",
        "ScavKingHelmet"
    },

    ["Clothing"] = {
        "Balaclava",
        "CamoPants",
        "CamoShirt",
        "CivilianPants",
        "CivilianShirt",
        "CombatGloves",
        "GhillieHood",
        "GhillieLegs",
        "GhillieTorso",
        "GorkaPants",
        "GorkaShirt",
        "HandWraps",
        "KneePads",
        "SpecopsBackpack",
        "WastelandBackpack",
        "WastelandPants",
        "WastelandShirt",
        "SantaHat"
    },

    ["Visors"] = {
        "AltynVisor",
        "FastVisor",
        "LowCutVisor",
        "MaskaVisor",
        "MotorcycleHelmetVisor",
        "ZShVisor"
    },

    ["Optics"] = {
        "GP5",
        "GP5Filter",
        "HeadMount",
        "ONV9",
        "QuadNVG",
        "PN6K5",
        "SPSh44"
    },

    ["Melee"] = {
        "AnarchyTomahawk",
        "Cutlass",
        "Greatsword",
        "IceAxe",
        "IceDagger",
        "Karambit",
        "Kukri",
        "Longsword",
        "PlasmaNinjato",
        "Reapir",
        "Scythe",
        "TitanShield"
    },

    ["Grenades"] = {
        "f1",
        "M84",
        "RGD5",
        "RGO"
    },

    ["Deployables"] = {
        "Barricade",
        "GrenadeTrap",
        "MON50",
        "PMN2",
        "Sandbag"
    },

    ["Food"] = {
        "Beans",
        "BloxyCola",
        "CatfrogSoda",
        "ChocolateBar",
        "CondensedMilk",
        "KevCola",
        "MaxEnergy",
        "ResKola",
        "WaterBottle"
    },

    ["Keys"] = {
        "AirfieldTunnelsKey",
        "Apartment13Key",
        "Apartment21Key",
        "ATCKey",
        "B05Key",
        "CitySubstationtKey",
        "CraneKey",
        "DormA211Key",
        "DormB203Key",
        "EVACKey",
        "FactoryGarageKey",
        "FrigateKey",
        "FuelingStationKey",
        "HydroBasementKey",
        "LighthouseKey",
        "PoolKey",
        "VillageKey",
        "Villa1Key",
        "BlueCard",
        "OrangeCard",
        "RedCard",
        "KeyChain"
    },

    ["Tools"] = {
        "FlatScrewdriver",
        "Hammer",
        "Lighter",
        "PH2Screwdriver",
        "Wrench",
        "RepairKit"
    },

    ["Materials"] = {
        "AABattery",
        "AramidFabric",
        "Bolts",
        "CopperCoil",
        "CottonFabric",
        "DuctTape",
        "Fuze",
        "Gold50g",
        "Gunpowder",
        "LinenFabric",
        "Lvl4Plate",
        "MetalChunks",
        "Nails",
        "Nuts",
        "OilCan",
        "Planks",
        "RipstopFabric",
        "Rubles",
        "SteelPipe",
        "SuperGlue",
        "WeaponParts"
    },

    ["Electronics"] = {
        "CFan",
        "CPU",
        "GPU",
        "PortableConsole",
        "PSU",
        "RAM",
        "SSD",
        "Smartphone"
    },

    ["Valuables"] = {
        "GoldWatch",
        "GoldenTicket",
        "SolterStatue"
    },

    ["Maps"] = {
        "EstonianBorderMap",
        "Map",
        "Pathfinder",
        "Radio"
    },

    ["Special"] = {
        "GiftTier1",
        "GiftTier2",
        "GiftTier3",
        "Snowball",
        "TFZ0"
    }
}

local VisualsTab = Window:AddTab({ Name = "Visuals" })
local Visuals = VisualsTab:AddContainer({ Name = "Main", Side = "Left", AutoSize = true })
local MainDrops = Visuals:AddTab("Drops")
local MainCrates = Visuals:AddTab("Crates")
local MainCorpses = Visuals:AddTab("Corpses")

local RenderDrops = MainDrops:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Renders All Item Drops" })
local RenderDropsHighlight = MainDrops:AddToggle({ Name = "Highlight", Value = false, Tooltip = "Enable Highlights for Drops" })
local DropDistance = MainDrops:AddSlider({ Name = "Distance", Min = 0, Max = 1500, Default = 150, Rounding = 5 })
local DropFilter = MainDrops:AddDropdown({ Name = "Item Filter", Values = {"Weapons", "Attachments", "Magazines", "Ammo", "Medical", "Armor", "Clothing", "Visors", "Optics", "Melee", "Grenades", "Deployables", "Food", "Keys", "Tools", "Materials", "Electronics", "Valuables", "Maps", "Special"}, Default = {"Weapons"}, Multi = true })

local RenderCrates = MainCrates:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Render All Loot Crates" })
local RenderCratesHighlight = MainCrates:AddToggle({ Name = "Highlight", Value = false, Tooltip = "Enable Highlights for Crates" })
local CrateDistance = MainCrates:AddSlider({ Name = "Distance", Min = 0, Max = 1500, Default = 150, Rounding = 5 })
local CrateFilter = MainCrates:AddDropdown({ Name = "Crate Filter", Values = {"Military", "Civilian", "EDF", "Other"}, Default = {"Civilian"}, Multi = true })
MainCrates:AddSeparator()
local DisplayInventory = MainCrates:AddToggle({ Name = "Display Inventory", Value = false, Tooltip = "Show items inside crates" })
local InventoryFilter = MainCrates:AddDropdown({ Name = "Inventory Filter", Values = {"Weapons", "Attachments", "Magazines", "Ammo", "Medical", "Armor", "Clothing", "Visors", "Optics", "Melee", "Grenades", "Deployables", "Food", "Keys", "Tools", "Materials", "Electronics", "Valuables", "Maps", "Special"}, Default = {"Weapons"}, Multi = true })

local RenderCorpses = MainCorpses:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Render All Player Corpses" })
local RenderCorpsesHighlight = MainCorpses:AddToggle({ Name = "Highlight", Value = false, Tooltip = "Performance Intensive" })
local CorpseDistance = MainCorpses:AddSlider({ Name = "Distance", Min = 0, Max = 1500, Default = 150, Rounding = 5 })

local VehiclesContainer = VisualsTab:AddContainer({ Name = "Vehicles", Side = "Right", AutoSize = true })
local MainVehicles = VehiclesContainer:AddTab("Vehicles")
local RenderVehicles = MainVehicles:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Render All Vehicles" })
local VehicleDistance = MainVehicles:AddSlider({ Name = "Distance", Min = 0, Max = 2500, Default = 400, Rounding = 5 })

local SettingsTab = Window:AddTab({ Name = "Settings" })
local MenuContainer = SettingsTab:AddContainer({ Name = "Menu", Side = "Left", AutoSize = true })

MenuContainer:AddMenuBind({})
MenuContainer:AddSeparator()

MenuContainer:AddWatermark({
    Watermark = "Project Dih | ".. Version.. " | "..  Workspace:GetAttribute("MapName"),
    ShowFPS = true
})

MenuContainer:AddKeybindList({})
MenuContainer:AddButton({ Name = "Copy Discord Link", Callback = function() setclipboard("discord.gg/severe1") end })
MenuContainer:AddButton({ Name = "Unload", Unsafe = true, Callback = function() Library:Unload() end })

local Stored = {
    Drops  = {},
    Crates = {},
    Corpses = {},
    Vehicles = {},
    AI = {},
    Players = {}
}

local Client = {
    Character = nil,
    HumanoidRootPart = nil,
    Position = Vector3.new(0, 0, 0)
}

local function GetBodyParts(Model)
    return {
        Head = Model:FindFirstChild("Head"),
        UpperTorso = Model:FindFirstChild("LowerTorso"),
        LowerTorso = Model:FindFirstChild("LowerTorso"),

        LeftUpperArm = Model:FindFirstChild("LeftUpperArm"),
        LeftLowerArm = Model:FindFirstChild("LeftLowerArm"),
        LeftHand = Model:FindFirstChild("LeftHand"),

        RightUpperArm = Model:FindFirstChild("RightUpperArm"),
        RightLowerArm = Model:FindFirstChild("RightLowerArm"),
        RightHand = Model:FindFirstChild("RightHand"),

        LeftUpperLeg = Model:FindFirstChild("LeftUpperLeg"),
        LeftLowerLeg = Model:FindFirstChild("LeftLowerLeg"),
        LeftFoot = Model:FindFirstChild("LeftFoot"),

        RightUpperLeg = Model:FindFirstChild("RightUpperLeg"),
        RightLowerLeg = Model:FindFirstChild("RightLowerLeg"),
        RightFoot = Model:FindFirstChild("RightFoot"),

        HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart"),
    }
end

local function EntityData(Model, Parts)
	if not Model then return nil end 

	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	local Health = 100
	local MaxHealth = 100
	
	if Humanoid then
		Health = Humanoid.Health
		MaxHealth = Humanoid.MaxHealth
	end

	local Data = {
		Username = tostring(Model),
		Displayname = Model.Name,
		Userid = -1,
		Character = Model,
		PrimaryPart = Model.PrimaryPart or Parts.HumanoidRootPart,
		Humanoid = Humanoid or Model.PrimaryPart,
		Head = Parts.Head,
		Torso = Parts.UpperTorso,
		UpperTorso = Parts.UpperTorso,
		LowerTorso = Parts.LowerTorso,
		LeftArm = Parts.LeftArm or Parts.LeftUpperArm, 
		LeftLeg = Parts.LeftLeg or Parts.LeftUpperLeg,
		RightArm = Parts.RightArm or Parts.RightUpperArm, 
		RightLeg = Parts.RightLeg or Parts.RightUpperLeg,
		LeftUpperArm = Parts.LeftUpperArm,
		LeftLowerArm = Parts.LeftLowerArm,
		LeftHand = Parts.LeftHand,
		RightUpperArm = Parts.RightUpperArm,
		RightLowerArm = Parts.RightLowerArm,
		RightHand = Parts.RightHand,
		LeftUpperLeg = Parts.LeftUpperLeg,
		LeftLowerLeg = Parts.LeftLowerLeg,
		LeftFoot = Parts.LeftFoot,
		RightUpperLeg = Parts.RightUpperLeg,
		RightLowerLeg = Parts.RightLowerLeg,
		RightFoot = Parts.RightFoot,
		BodyHeightScale = 1,
		RigType = 1,
		Toolname = Model:FindFirstChildOfClass("Model").Name,
		Teamname = "AI",
		Whitelisted = false,
		Archenemies = true,
		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,
		Health = Health,
		MaxHealth = MaxHealth,
        body_parts_data = {
			{ name = "LowerTorso", part = Parts.LowerTorso },
			{ name = "LeftUpperLeg", part = Parts.LeftUpperLeg },
			{ name = "LeftLowerLeg", part = Parts.LeftLowerLeg },
			{ name = "RightUpperLeg", part = Parts.RightUpperLeg },
			{ name = "RightLowerLeg", part = Parts.RightLowerLeg },
			{ name = "LeftUpperArm", part = Parts.LeftUpperArm },
			{ name = "LeftLowerArm", part = Parts.LeftLowerArm },
			{ name = "RightUpperArm", part = Parts.RightUpperArm },
			{ name = "RightLowerArm", part = Parts.RightLowerArm },
		},
		full_body_data = {
			{ name = "Head", part = Parts.Head },
			{ name = "UpperTorso", part = Parts.UpperTorso },
			{ name = "LowerTorso", part = Parts.LowerTorso },
			{ name = "HumanoidRootPart", part = Parts.HumanoidRootPart },
		
			{ name = "LeftUpperArm", part = Parts.LeftUpperArm },
			{ name = "LeftLowerArm", part = Parts.LeftLowerArm },
			{ name = "LeftHand", part = Parts.LeftHand },
		
			{ name = "RightUpperArm", part = Parts.RightUpperArm },
			{ name = "RightLowerArm", part = Parts.RightLowerArm },
			{ name = "RightHand", part = Parts.RightHand },
		
			{ name = "LeftUpperLeg", part = Parts.LeftUpperLeg },
			{ name = "LeftLowerLeg", part = Parts.LeftLowerLeg },
			{ name = "LeftFoot", part = Parts.LeftFoot },
		
			{ name = "RightUpperLeg", part = Parts.RightUpperLeg },
			{ name = "RightLowerLeg", part = Parts.RightLowerLeg },
			{ name = "RightFoot", part = Parts.RightFoot },
		}
	}

	return tostring(Model), Data
end

local function GetPlayerData(Player)
	if not Player then return nil end

	local Character = Player.Character
	if not Character then return nil end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return nil end

	local Parts = GetBodyParts(Character)
	if not Parts then return nil end

	local Health = Humanoid.Health
	local MaxHealth = Humanoid.MaxHealth

	local Data = {
		Username = Player.Name,
		Displayname = Player.DisplayName,
		Userid = Player.UserId,

		Character = Character,
		PrimaryPart = Character.PrimaryPart,
		Humanoid = Humanoid,

		Head = Parts.Head,
		Torso = Parts.Torso or Parts.UpperTorso,
		UpperTorso = Parts.UpperTorso,
		LowerTorso = Parts.LowerTorso,

		LeftArm = Parts.LeftArm or Parts.LeftUpperArm,
		LeftLeg = Parts.LeftLeg or Parts.LeftUpperLeg,
		RightArm = Parts.RightArm or Parts.RightUpperArm,
		RightLeg = Parts.RightLeg or Parts.RightUpperLeg,

		LeftUpperArm = Parts.LeftUpperArm,
		LeftLowerArm = Parts.LeftLowerArm,
		LeftHand = Parts.LeftHand,

		RightUpperArm = Parts.RightUpperArm,
		RightLowerArm = Parts.RightLowerArm,
		RightHand = Parts.RightHand,

		LeftUpperLeg = Parts.LeftUpperLeg,
		LeftLowerLeg = Parts.LeftLowerLeg,
		LeftFoot = Parts.LeftFoot,

		RightUpperLeg = Parts.RightUpperLeg,
		RightLowerLeg = Parts.RightLowerLeg,
		RightFoot = Parts.RightFoot,

		BodyHeightScale = 1,
		RigType = 1,
		Toolname = "Unknown",
		Teamname = Player.Team or "No Team",

		Whitelisted = false,
		Archenemies = false,

		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,

		Health = Health,
		MaxHealth = MaxHealth,

		body_parts_data = {
			{ name = "LowerTorso", part = Character:FindFirstChild("LowerTorso") },
			{ name = "LeftUpperLeg", part = Character:FindFirstChild("LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = Character:FindFirstChild("LeftLowerLeg") },
			{ name = "RightUpperLeg", part = Character:FindFirstChild("RightUpperLeg") },
			{ name = "RightLowerLeg", part = Character:FindFirstChild("RightLowerLeg") },
			{ name = "LeftUpperArm", part = Character:FindFirstChild("LeftUpperArm") },
			{ name = "LeftLowerArm", part = Character:FindFirstChild("LeftLowerArm") },
			{ name = "RightUpperArm", part = Character:FindFirstChild("RightUpperArm") },
			{ name = "RightLowerArm", part = Character:FindFirstChild("RightLowerArm") },
		},

		full_body_data = {
			{ name = "Head", part = Character:FindFirstChild("Head") },
			{ name = "UpperTorso", part = Character:FindFirstChild("UpperTorso") },
			{ name = "LowerTorso", part = Character:FindFirstChild("LowerTorso") },
			{ name = "HumanoidRootPart", part = Character:FindFirstChild("HumanoidRootPart") },

			{ name = "LeftUpperArm", part = Character:FindFirstChild("LeftUpperArm") },
			{ name = "LeftLowerArm", part = Character:FindFirstChild("LeftLowerArm") },
			{ name = "LeftHand", part = Character:FindFirstChild("LeftHand") },

			{ name = "RightUpperArm", part = Character:FindFirstChild("RightUpperArm") },
			{ name = "RightLowerArm", part = Character:FindFirstChild("RightLowerArm") },
			{ name = "RightHand", part = Character:FindFirstChild("RightHand") },

			{ name = "LeftUpperLeg", part = Character:FindFirstChild("LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = Character:FindFirstChild("LeftLowerLeg") },
			{ name = "LeftFoot", part = Character:FindFirstChild("LeftFoot") },

			{ name = "RightUpperLeg", part = Character:FindFirstChild("RightUpperLeg") },
			{ name = "RightLowerLeg", part = Character:FindFirstChild("RightLowerLeg") },
			{ name = "RightFoot", part = Character:FindFirstChild("RightFoot") },
		},
	}

	return tostring(Character), Data
end

local function UpdateClient()
    local Character = LocalPlayer and LocalPlayer.Character
    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart and HumanoidRootPart.Parent then
            Client.Character = Character
            Client.HumanoidRootPart = HumanoidRootPart
            Client.Position = HumanoidRootPart.Position
            return true
        end
    end
    Client.Character = nil
    Client.HumanoidRootPart = nil
    return false
end

local function CrateValid(Name)
    local Selected = CrateFilter.Value

    if not next(Selected) then
        return true
    end

    for Category, Enabled in pairs(Selected) do
        if Enabled then
            local CrateList = Crates[Category]
            if CrateList then
                for _, CrateName in ipairs(CrateList) do
                    if Name == CrateName then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function ItemValid(Name)
    local Selected = DropFilter.Value

    if not next(Selected) then
        return true
    end

    for Category, Enabled in pairs(Selected) do
        if Enabled then
            local ItemList = Items[Category]
            if ItemList then
                for _, ItemName in ipairs(ItemList) do
                    if Name == ItemName then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function CrateItemValid(Name)
    local Selected = InventoryFilter.Value

    if not next(Selected) then
        return true
    end

    for Category, Enabled in pairs(Selected) do
        if Enabled then
            local ItemList = Items[Category]
            if ItemList then
                for _, ItemName in ipairs(ItemList) do
                    if Name == ItemName then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function Cache()
    if not UpdateClient() then return end

    if RenderDrops.Value then
        local MaxDistance = DropDistance.Value
        for Drop, Data in pairs(Stored.Drops) do
            if not Drop.Parent or not ItemValid(Data.Item.Name) then
                Stored.Drops[Drop] = nil
            end
        end
        
        for Drop, Data in pairs(Stored.Drops) do
            if Drop.Parent then
                local Object = Drop.PrimaryPart
                if not Object or vector.magnitude(Client.Position - Object.Position) > MaxDistance then
                    Stored.Drops[Drop] = nil
                end
            end
        end
        
        if Dropped then
            for _, Drop in ipairs(Dropped:GetChildren()) do
                if Drop.ClassName == "Model" and not Drop:FindFirstChild("Head") and not Stored.Drops[Drop] then
                    local Object = Drop.PrimaryPart
                    if Object then
                        local Distance = vector.magnitude(Client.Position - Object.Position)
                        local Name = Drop.Name
                        if Distance <= MaxDistance and ItemValid(Drop.Name) then
                            Stored.Drops[Drop] = {
                                Item = Drop,
                                Object = Object,
                                Name = Name
                            }
                        end
                    end
                end
            end
        end
    end

    if RenderCrates.Value then
        local MaxDistance = CrateDistance.Value
        for Crate, Data in pairs(Stored.Crates) do
            if not Crate.Parent or not CrateValid(Crate.Name) then
                Stored.Crates[Crate] = nil
            end
        end
        
        for Crate, Data in pairs(Stored.Crates) do
            if Crate.Parent then
                local Object = Crate.PrimaryPart
                if not Object or vector.magnitude(Client.Position - Object.Position) > MaxDistance then
                    Stored.Crates[Crate] = nil
                else
                    if DisplayInventory.Value then
                        local InventoryFolder = Crate:FindFirstChild("Inventory")
                        local FilteredItems = {}
                        if InventoryFolder then
                            for _, Item in ipairs(InventoryFolder:GetChildren()) do
                                if CrateItemValid(Item.Name) then
                                    table.insert(FilteredItems, Item.Name)
                                end
                            end
                        end
                        Data.Inventory = FilteredItems
                    else
                        Data.Inventory = {}
                    end
                end
            end
        end
        
        if Containers then
            for _, Container in ipairs(Containers:GetChildren()) do
                if Container.ClassName == "Folder" then
                    for _, Crate in ipairs(Container:GetChildren()) do
                        if not Stored.Crates[Crate] and Crate:GetAttribute("CanSpawnLoot") then
                            local Object = Crate.PrimaryPart
                            if Object then
                                local Distance = vector.magnitude(Client.Position - Object.Position)
                                local Name = Crate:GetAttribute("DisplayName") or Crate.Name
                                if Distance <= MaxDistance and CrateValid(Crate.Name) then
                                    local FilteredItems = {}
                                    if DisplayInventory.Value then
                                        local InventoryFolder = Crate:FindFirstChild("Inventory")
                                        if InventoryFolder then
                                            for _, Item in ipairs(InventoryFolder:GetChildren()) do
                                                if CrateItemValid(Item.Name) then
                                                    table.insert(FilteredItems, Item.Name)
                                                end
                                            end
                                        end
                                    end
                                    Stored.Crates[Crate] = {
                                        Item = Crate,
                                        Object = Object,
                                        Name = Name,
                                        Inventory = FilteredItems
                                    }
                                end
                            end
                        end
                    end
                elseif Container.ClassName == "Model" and not Stored.Crates[Container] and Container:GetAttribute("CanSpawnLoot") then
                    local Object = Container.PrimaryPart
                    if Object then
                        local Distance = vector.magnitude(Client.Position - Object.Position)
                        local Name = Container:GetAttribute("DisplayName") or Container.Name
                        if Distance <= MaxDistance and CrateValid(Container.Name) then
                            local FilteredItems = {}
                            if DisplayInventory.Value then
                                local InventoryFolder = Container:FindFirstChild("Inventory")
                                if InventoryFolder then
                                    for _, Item in ipairs(InventoryFolder:GetChildren()) do
                                        if CrateItemValid(Item.Name) then
                                            table.insert(FilteredItems, Item.Name)
                                        end
                                    end
                                end
                            end
                            Stored.Crates[Container] = {
                                Item = Container,
                                Object = Object,
                                Name = Name,
                                Inventory = FilteredItems
                            }
                        end
                    end
                end
            end
        end
    end

    if RenderCorpses.Value then
        local MaxDistance = CorpseDistance.Value
        for Corpse, Data in pairs(Stored.Corpses) do
            if not Corpse.Parent then
                Stored.Corpses[Corpse] = nil
            else
                local Object = Corpse.PrimaryPart
                if not Object or vector.magnitude(Client.Position - Object.Position) > MaxDistance then
                    Stored.Corpses[Corpse] = nil
                end
            end
        end
        
        if Dropped then
            for _, Corpse in ipairs(Dropped:GetChildren()) do
                if Corpse:FindFirstChild("Head") and Corpse.ClassName == "Model" and not Stored.Corpses[Corpse] then
                    local Object = Corpse.PrimaryPart
                    if Object then
                        local Distance = vector.magnitude(Client.Position - Object.Position)
                        if Distance <= MaxDistance then
                            Stored.Corpses[Corpse] = {
                                Item = Corpse,
                                Object = Object,
                                Name = Corpse:GetAttribute("DisplayName") or Corpse.Name
                            }
                        end
                    end
                end
            end
        end
    end

    if RenderVehicles.Value then
        local MaxDistance = VehicleDistance.Value
        for Vehicle, Data in pairs(Stored.Vehicles) do
            if not Vehicle.Parent or not ItemValid(Data.Item.Name) then
                Stored.Vehicles[Vehicle] = nil
            end
        end
        
        for Vehicle, Data in pairs(Stored.Vehicles) do
            if Vehicle.Parent then
                local Body = Vehicle:FindFirstChild("Body")
                local Object = Body and Body.PrimaryPart
                if not Object or vector.magnitude(Client.Position - Object.Position) > MaxDistance then
                    Stored.Vehicles[Vehicle] = nil
                end
            end
        end
        
        if Vehicles then
            for _, Vehicle in ipairs(Vehicles:GetChildren()) do
                if Vehicle.ClassName == "Model" and not Stored.Vehicles[Vehicle] then
                    local Body = Vehicle:FindFirstChild("Body")
                    local Object = Body and Body.PrimaryPart
                    if Object then
                        local Distance = vector.magnitude(Client.Position - Object.Position)
                        local Name = Vehicle.Name.. " [".. Vehicle:GetAttribute("VehicleType").. "]"
                        if Distance <= MaxDistance then
                            Stored.Vehicles[Vehicle] = {
                                Item = Vehicle,
                                Object = Object,
                                Name = Name
                            }
                        end
                    end
                end
            end
        end
    end
end

local function Render()
    if not Client.HumanoidRootPart then return end
    
    if RenderDrops.Value then
        for _, Data in pairs(Stored.Drops) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    if RenderDropsHighlight.Value then
                        Module.Highlight(Color3.fromRGB(255, 255, 255), Object, { Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0), OutlineThickness = 1, Inline = true, InlineColor = Color3.fromRGB(0, 0, 0), InlineThickness = 1, Fill = true, FillColor = Color3.fromRGB(255, 100, 150), FillOpacity = 1})
                    end
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name, true, "Proggy")
                end
            end
        end
    end

    if RenderCrates.Value then
        for _, Data in pairs(Stored.Crates) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    if RenderCratesHighlight.Value then
                        Module.Highlight(Color3.fromRGB(255, 255, 255), Object, { Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0), OutlineThickness = 1, Inline = true, InlineColor = Color3.fromRGB(0, 0, 0), InlineThickness = 1, Fill = true, FillColor = Color3.fromRGB(255, 100, 150), FillOpacity = 1})
                    end
                    
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name, true, "Proggy")
                    
                    if DisplayInventory.Value and Data.Inventory and #Data.Inventory > 0 then
                        local InventoryText = "[" .. table.concat(Data.Inventory, ", ") .. "]"
                        local InventoryScreen = Vector2.new(Screen.X, Screen.Y + 15)
                        DrawingImmediate.OutlinedText(InventoryScreen, 13, Color3.fromRGB(255, 255, 150), 1, InventoryText, true, "Proggy")
                    end
                end
            end
        end
    end

    if RenderCorpses.Value then
        for _, Data in pairs(Stored.Corpses) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    if RenderCorpsesHighlight.Value then
                        Module.Highlight(Color3.fromRGB(255, 255, 255), Data.Item, { Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0), OutlineThickness = 1, Inline = true, InlineColor = Color3.fromRGB(0, 0, 0), InlineThickness = 1, Fill = true, FillColor = Color3.fromRGB(255, 100, 150), FillOpacity = 1})
                    end
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name..  "'s Corpse", true, "Proggy")
                end
            end
        end
    end

    if RenderVehicles.Value then
        for _, Data in pairs(Stored.Vehicles) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name, true, "Proggy")
                end
            end
        end
    end
end

task.spawn(function()
	while true do
		task.wait(0.5)
        Cache()

		local Seen = {}
		
		local CurrentAI = Zones and Zones:GetChildren() or {}

		for _, Zone in ipairs(CurrentAI) do
			pcall(function()
				for _, NPC in ipairs(Zone:GetChildren()) do
					pcall(function()
						if typeof(NPC) ~= "Instance" or NPC.ClassName ~= "Model" then
							return
						end

						local Humanoid = NPC:FindFirstChildOfClass("Humanoid")
						if not Humanoid then return end

						local HumanoidRootPart = NPC:FindFirstChild("HumanoidRootPart")
						if not HumanoidRootPart then return end

						if NPC.PrimaryPart ~= HumanoidRootPart then return end

						local Parts = GetBodyParts(NPC)
						if not Parts or not Parts.HumanoidRootPart then return end

						local Key = tostring(NPC)

						if not Stored.AI[Key] then
							local ID, Data = EntityData(NPC, Parts)
							if ID and Data and add_model_data(Data, ID) then
								Stored.AI[ID] = NPC
							end
						else
							edit_model_data({
								Health = Humanoid.Health
							}, Key)
						end

						Seen[Key] = true
					end)
				end
			end)
		end

	    for _, Player in ipairs(Players:GetChildren()) do
		    pcall(function()
		        if Player and Player ~= LocalPlayer then
				    local Character = Player.Character
				    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				    if Humanoid and Character ~= Client.Character then
					    local Key = tostring(Character)
					    local Parts = GetBodyParts(Character)

					    if Parts and Parts.HumanoidRootPart then
						    if is_team_check_active() then
						    	if Player.Team == LocalPlayer.Team then
								    if Stored.Players[Key] then
								    	local ID = tostring(Character)
								    	remove_model_data(ID)
								    	Stored.Players[ID] = nil
								    end
								    Seen[Key] = nil
						    	else
								    if not Stored.Players[Key] then
									    local ID, Data = GetPlayerData(Player)
									    if ID and Data and add_model_data(Data, ID) then
									    	Stored.Players[ID] = Character
									    end
								    else
								    	edit_model_data({ Health = Humanoid.Health }, Key)
							    	end
							    	Seen[Key] = true
						    	end
					    	else
						    	if not Stored.Players[Key] then
								    local ID, Data = GetPlayerData(Player)
								    if ID and Data and add_model_data(Data, ID) then
								        Stored.Players[ID] = Character
								    end
								else
									edit_model_data({ Health = Humanoid.Health }, Key)
								end
								Seen[Key] = true
							end
						end
					end
				end
			end)
		end

		for ID, Model in pairs(Stored.AI) do
			pcall(function()
				if not Model or not Model.Parent or not Seen[ID] then
					remove_model_data(ID)
					Stored.AI[ID] = nil
				end
			end)
		end

		for ID, Model in pairs(Stored.Players) do
			pcall(function()
				if not Model or not Model.Parent or not Seen[ID] then
					remove_model_data(ID)
					Stored.Players[ID] = nil
				end
			end)
		end
	end
end)

RunService.Render:Connect(Render)
