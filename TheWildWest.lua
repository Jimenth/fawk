local TrackedModels = {}
local Workspace = findfirstchildofclass(Game, "Workspace")
local Entities = findfirstchild(Workspace, "WORKSPACE_Entities")
local Players = findfirstchild(Entities, "Players")
local Animals = findfirstchild(Entities, "Animals")

local function RefreshLocalCharacter()
    LocalPlayer = findfirstchild(Players, getname(getlocalplayer()))
    return LocalPlayer
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

local function GetAnimalParts(Model)
	return {
		Head = findfirstchild(Model, "Head"),

		UpperTorso = findfirstchild(Model, "Body"),
		LowerTorso = findfirstchild(Model, "Body"),

		LeftUpperArm = findfirstchild(Model, "LeftShoulder"),
		LeftLowerArm = findfirstchild(Model, "LeftArm"),
		LeftHand = findfirstchild(Model, "LeftFrontHoof"),

		RightUpperArm = findfirstchild(Model, "RightShoulder"),
		RightLowerArm = findfirstchild(Model, "RightArm"),
		RightHand = findfirstchild(Model, "RightFrontHoof"),

		LeftUpperLeg = findfirstchild(Model, "LeftThigh"),
		LeftLowerLeg = findfirstchild(Model, "LeftLeg"),
		LeftFoot = findfirstchild(Model, "LeftLeg"),

		RightUpperLeg = findfirstchild(Model, "RightThigh"),
		RightLowerLeg = findfirstchild(Model, "RightLeg"),
		RightFoot = findfirstchild(Model, "RightLeg"),

		HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart"),
	}
end

local function PlayerData(Model, Parts)
	local Humanoid = findfirstchild(Model, "Humanoid")
	local Health = gethealth(Humanoid)

	local Data = {
		Username = tostring(Model),
		Displayname = getname(Model),
		Userid = 3,
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
		RigType = 1,
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

local function AnimalData(Model, Parts)
	local Humanoid = findfirstchild(Model, "Humanoid")
	local Health = gethealth(Humanoid)

	local Data = {
		Username = tostring(Model),
		Displayname = getname(Model),
		Userid = 2,
		Character = Model,
		PrimaryPart = getprimarypart(Model),
		Humanoid = Humanoid,
		Head = Parts.Head,
        Torso = Parts.UpperTorso,
        UpperTorso = Parts.UpperTorso,
        LowerTorso = Parts.LowerTorso,
        LeftArm = Parts.LeftUpperArm, 
		LeftLeg = Parts.LeftUpperLeg,
        RightArm = Parts.RightUpperArm, 
		RightLeg = Parts.RightUpperLeg,
        LeftUpperArm = Parts.LeftUpperArm,
        LeftLowerArm = Parts.LeftUpperArm,
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
		Whitelisted = false,
		Archenemies = false,
		Aimbot_Part = findfirstchild(Model, "Head"),
		Aimbot_TP_Part = findfirstchild(Model, "Head"),
		Triggerbot_Part = findfirstchild(Model, "Head"),
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

local function LocalPlayerData()
    if not RefreshLocalCharacter() then
        return nil
    end

    local Humanoid = findfirstchild(LocalPlayer, "Humanoid")
    if not Humanoid then
        return nil
    end

    local Health = gethealth(Humanoid)

    local LocalData = {
        LocalPlayer = LocalPlayer,
        Character = LocalPlayer,
        Username = tostring(LocalPlayer),
        Displayname = getname(getlocalplayer()),
        Userid = 1,

        Humanoid = Humanoid,
        Health = Health,
        MaxHealth = getmaxhealth(Humanoid),
        RigType = 0,

        Head = findfirstchild(LocalPlayer, "Head"),
        RootPart = findfirstchild(LocalPlayer, "HumanoidRootPart"),
        LeftFoot = findfirstchild(LocalPlayer, "LeftFoot"),
        LowerTorso = findfirstchild(LocalPlayer, "LowerTorso"),

        LeftArm = findfirstchild(LocalPlayer, "LeftUpperArm"),
        LeftLeg = findfirstchild(LocalPlayer, "LeftUpperLeg"),
        RightArm = findfirstchild(LocalPlayer, "RightUpperArm"),
        RightLeg = findfirstchild(LocalPlayer, "RightUpperLeg"),
        UpperTorso = findfirstchild(LocalPlayer, "UpperTorso"),
    }

    return tostring(LocalPlayer), LocalData
end

local function Update()
	local Seen = {}

	for _, Player in ipairs(getchildren(Players)) do
		local Humanoid = findfirstchild(Player, "Humanoid")
		if Humanoid and getparent(Humanoid) then
			local Key = tostring(Player)
			local Parts = GetBodyParts(Player)

			if Parts.Head and Parts.HumanoidRootPart and getname(Player) ~= getname(getlocalplayer()) then
				if not TrackedModels[Key] then
					local ID, Data = PlayerData(Player, Parts)
					if add_model_data(Data, ID) then
						TrackedModels[ID] = Player
					end
				else
					edit_model_data({Health = gethealth(Humanoid)}, Key)
				end
				Seen[Key] = true
			end
		end
	end

	if not is_team_check_active() then
		for _, Animal in ipairs(getchildren(Animals)) do
			local Humanoid = findfirstchild(Animal, "Humanoid")
			if Humanoid and getparent(Humanoid) then
				local Key = tostring(Animal)
				local Parts = GetAnimalParts(Animal)

				if Parts.Head and Parts.HumanoidRootPart and not string.find(getname(Animal), "Horse") then
					if not TrackedModels[Key] then
						local ID, Data = AnimalData(Animal, Parts)
						if add_model_data(Data, ID) then
							TrackedModels[ID] = Animal
						end
					else
						edit_model_data({ Health = gethealth(Humanoid) }, Key)
					end
					Seen[Key] = true
				end
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
        wait(1/60)
        Update()

        if LocalPlayerData() then
            override_local_data(LocalPlayerData())
        end
    end
end)
