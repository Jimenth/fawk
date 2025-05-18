local Workspace = findfirstchildofclass(Game, "Workspace")
local PlaceID = getmemoryvalue(Game, 0x1A0, "qword")
local TrackedModels = {}
local PIDtoContainer = {}

local Path = Workspace
local Universington = {
    [187796008] = findfirstchild(findfirstchild(Workspace, "Entities"), "Infected"), -- Those Who Remain
	[3104101863] = findfirstchild(findfirstchild(Workspace, "Ignore"), "Zombies"), -- Michaels Zombies
	[504035427] = findfirstchild(Workspace, "enemies"), -- Zombie Attack
    [3349613241] = findfirstchild(Workspace, "NPCs"), -- AI Test
	[1709832923] = findfirstchild(Workspace, "Zombies"), -- Zombie Uprising
	[169302362] = findfirstchild(Workspace, "Baddies"), -- Project Lazarus
	[3956073837] = findfirstchild(Workspace, "Zombies"), -- Korrupt Zombies
	[2263267302] = findfirstchild(findfirstchild(Workspace, "NPCs"), "policeForce"), -- Infamy (Insanely Unoptimized Game)
	[2575793677] = findfirstchild(Workspace, "OtherWaifus") -- Aniphobia
}

local function UniverseCache(UniverseID, Container)
    local URL = ("https://develop.roblox.com/v1/universes/%d/places?sortOrder=Asc&limit=100"):format(UniverseID)
    local Data = JSONDecode(httpget(URL))
    local Places = Data["data"]
    if not Places then
        return
    end

    for _, Place in ipairs(Places) do
        local PID = Place["id"] or Place["placeId"] or Place["placeid"]
        if PID then
            if Container then
                PIDtoContainer[PID] = Container
            end
        end
    end
end

for UniverseID, Container in pairs(Universington) do
    UniverseCache(UniverseID, Container)
end

local function GetBodyParts(Model)
	return {
		Head = findfirstchild(Model, "Head"),
		UpperTorso = findfirstchild(Model, "UpperTorso"),
		LowerTorso = findfirstchild(Model, "LowerTorso"),

		LeftUpperArm = findfirstchild(Model, "LeftUpperArm"),
		LeftLowerArm = findfirstchild(Model, "LeftLowerArm"),
		LeftHand = findfirstchild(Model, "LeftHand"),

		RightUpperArm = findfirstchild(Model, "RightUpperArm"),
		RightLowerArm = findfirstchild(Model, "RightLowerArm"),
		RightHand = findfirstchild(Model, "RightHand"),

		LeftUpperLeg = findfirstchild(Model, "LeftUpperLeg"),
		LeftLowerLeg = findfirstchild(Model, "LeftLowerLeg"),
		LeftFoot = findfirstchild(Model, "LeftFoot"),

		RightUpperLeg = findfirstchild(Model, "RightUpperLeg"),
		RightLowerLeg = findfirstchild(Model, "RightLowerLeg"),
		RightFoot = findfirstchild(Model, "RightFoot"),

		LeftLeg = findfirstchild(Model, "Left Leg"),
		RightLeg = findfirstchild(Model, "Right Leg"),
		LeftArm = findfirstchild(Model, "Left Arm"),
		RightArm = findfirstchild(Model, "Right Arm"),
		Torso = findfirstchild(Model, "Torso"),

		HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart"),
	}
end

local function NPCData(Model, Parts)
	local Humanoid = findfirstchildofclass(Model, "Humanoid")
	local Health = gethealth(Humanoid)

	local Data = {
		Username = tostring(Model),
		Displayname = getname(Model),
		Userid = -1,
		Character = Model,
		PrimaryPart = getprimarypart(Model),
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
		RigType = findfirstchild(Model, "Torso") and 0 or 1,
		Whitelisted = false,
		Archenemies = false,
		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,
		Health = Health,
		MaxHealth = getmaxhealth(Humanoid),
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

local function Update()
    local Container = PIDtoContainer[PlaceID] or Path
    local NPCPath = getchildren(Container) or {}
    local Seen = {}

    for _, NPC in ipairs(NPCPath) do
        local Humanoid = findfirstchildofclass(NPC, "Humanoid")

        if Humanoid and getparent(Humanoid) then
            if is_team_check_active() then
                continue
            end

            local Key = tostring(NPC)
            local Parts = GetBodyParts(NPC)

            if Parts.Head and Parts.HumanoidRootPart and NPC ~= getcharacter(getlocalplayer()) then
                if not TrackedModels[Key] then
                    local ID, Data = NPCData(NPC, Parts)
                    if add_model_data(Data, ID) then
                        TrackedModels[ID] = NPC
                    end
                else
                    edit_model_data({Health = gethealth(Humanoid)}, Key)
                end
                Seen[Key] = true
            end
        end
    end

    for Key, Model in pairs(TrackedModels) do
        local HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart")
        if not HumanoidRootPart or not Seen[Key] then
            remove_model_data(Key)
            TrackedModels[Key] = nil
        end
    end
end

spawn(function()
    while true do
		wait()
		Update()
	end
end)
