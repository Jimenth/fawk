local Workspace = findfirstchildofclass(Game, "Workspace")
local PlaceID = getplaceid()
local TrackedModels = {}
local PIDtoContainer = {}

local Path = Workspace

local function Universington()
	return {
		[187796008] = findfirstchild(findfirstchild(Workspace, "Entities"), "Infected"), -- Those Who Remain
		[3104101863] = findfirstchild(findfirstchild(Workspace, "Ignore"), "Zombies"), -- Michaels Zombies
		[504035427] = findfirstchild(Workspace, "enemies"), -- Zombie Attack
		[3349613241] = findfirstchild(Workspace, "NPCs"), -- AI Test
		[1709832923] = findfirstchild(Workspace, "Zombies"), -- Zombie Uprising
		[169302362] = findfirstchild(Workspace, "Baddies"), -- Project Lazarus
		[3956073837] = findfirstchild(Workspace, "Zombies"), -- Korrupt Zombies
		[2263267302] = findfirstchild(findfirstchild(Workspace, "NPCs"), "policeForce"), -- Infamy
		[2575793677] = findfirstchild(Workspace, "OtherWaifus"), -- Aniphobia
		[3766480386] = {findfirstchild(getchildren(findfirstchild(Workspace, "CURRENT MAP"))[1], "ZOMBIES")}, -- Call of Mini™ Zombies
		[5497606909] = { -- Call of Mini™ Zombies 2
			findfirstchild(getchildren(findfirstchild(Workspace, "CURRENT_MAP"))[1], "ZombiesSpawnedIn"),
			getchildren(findfirstchild(Workspace, "CURRENT_MAP"))[1]
		},
		[3326279937] = findfirstchild(findfirstchild(Workspace, "NPCs"), "Custom"), -- Blackout Zombies
	}
end

local function UniverseCache(UniverseID, Container)
	local URL = ("https://develop.roblox.com/v1/universes/%d/places?sortOrder=Asc&limit=100"):format(UniverseID)
	local Data = JSONDecode(httpget(URL))
	local Places = Data["data"]

	if not Places then
		return
	end

	for _, Place in ipairs(Places) do
		local PID = Place["id"] or Place["placeId"] or Place["placeid"]
		if PID and Container then
			PIDtoContainer[PID] = type(Container) == "table" and Container or {Container}
		end
	end
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

		LeftLeg = findfirstchild(Model, "Left Leg") or findfirstchild(Model, "LeftLeg"),
		RightLeg = findfirstchild(Model, "Right Leg") or findfirstchild(Model, "RightLeg"),
		LeftArm = findfirstchild(Model, "Left Arm") or findfirstchild(Model, "LeftArm"),
		RightArm = findfirstchild(Model, "Right Arm") or findfirstchild(Model, "RightArm"),
		Torso = findfirstchild(Model, "Torso") or findfirstchild(Model, "Body"),

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
    local Containers = PIDtoContainer[PlaceID] or {Path}
    local NPCPath = {}
    local Seen = {}

    for _, Container in ipairs(Containers) do
        local Entities = Container and getchildren(Container)
        for _, Entity in ipairs(Entities) do
            table.insert(NPCPath, Entity)
        end
    end

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

		local Uni = Universington()
		for UniverseID, Container in pairs(Uni) do
			UniverseCache(UniverseID, Container)
		end
	end
end)
