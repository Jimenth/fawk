local Workspace = findfirstchildofclass(Game, "Workspace")
local TrackedModels = {}
local Teamates = {}

local function CalculateDistance(Position1, Position2)
    return math.sqrt((Position1.x - Position2.x) ^ 2 + (Position1.y - Position2.y) ^ 2 + (Position1.z - Position2.z) ^ 2)
end

local function GetSelf()
	local Camera = findfirstchild(Workspace, "Camera")
	if not Camera then return nil end

	local Folder = 0
	local Target = nil

	for _, Child in ipairs(getchildren(Workspace)) do
		if getclassname(Child) == "Folder" then
			Folder += 1
			if Folder == 5 then
				Target = Child
				break
			end
		end
	end

	if not Target then return nil end

	local ClosestModel = nil
	local ShortestDistance = math.huge

	for _, Model in ipairs(getchildren(Target)) do
		if getclassname(Model) == "Model" then
			local Head = findfirstchild(Model, "head")
			if Head and Camera then
				local HeadPos = getposition(Head)
				local CameraPos = getposition(Camera)
				local Distance = CalculateDistance(HeadPos, CameraPos)
				if Distance < ShortestDistance then
					ShortestDistance = Distance
					ClosestModel = Model
				end
			end
		end
	end

	return ClosestModel
end

local function GetBodyParts(Model)
	return {
		Head = findfirstchild(Model, "head"),
		UpperTorso = findfirstchild(Model, "torso"),
		LowerTorso = findfirstchild(Model, "stomach"),

		LeftUpperArm = findfirstchild(Model, "lArmUpper"),
		LeftLowerArm = findfirstchild(Model, "lArmLower"),
		LeftHand = findfirstchild(Model, "lHand"),

		RightUpperArm = findfirstchild(Model, "rArmUpper"),
		RightLowerArm = findfirstchild(Model, "rArmLower"),
		RightHand = findfirstchild(Model, "rArmLower"),

		LeftUpperLeg = findfirstchild(Model, "lLegUpper"),
		LeftLowerLeg = findfirstchild(Model, "lLegLower"),
		LeftFoot = findfirstchild(Model, "lLegLower"),

		RightUpperLeg = findfirstchild(Model, "rLegUpper"),
		RightLowerLeg = findfirstchild(Model, "rLegLower"),
		RightFoot = findfirstchild(Model, "rFoot"),

		HumanoidRootPart = findfirstchild(Model, "root"),
	}
end

local function PlayerData(Model, Parts)
	local Data = {
		Username = tostring(Model),
		Displayname = "Player",
		Userid = 0,
		Character = Model,
		PrimaryPart = Parts.Head,
		Humanoid = Parts.Head,
		Head = Parts.Head,
        Torso = Parts.UpperTorso, 
        UpperTorso = Parts.UpperTorso,
        LowerTorso = Parts.LowerTorso,
        LeftArm = Parts.LeftUpperArm, 
        LeftLeg = Parts.LeftUpperLeg, 
        RightArm = Parts.RightUpperArm, 
        RightLeg = Parts.RightUpperLeg, 
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
		Health = 100,
		MaxHealth = 100,
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
	if not GetSelf() then
        return nil
    end

	local LocalPlayer = GetSelf()

    local LocalData = {
        LocalPlayer = LocalPlayer,
        Character = LocalPlayer,
        Username = tostring(LocalPlayer),
        Displayname = getname(getlocalplayer()),
        Userid = 1,

        Humanoid = findfirstchild(LocalPlayer, "root"),
        Health = 100,
        MaxHealth = 100,
        RigType = 1,

        Head = findfirstchild(LocalPlayer, "head"),
        RootPart = findfirstchild(LocalPlayer, "root"),
        LeftFoot = findfirstchild(LocalPlayer, "lLegLower"),
        LowerTorso = findfirstchild(LocalPlayer, "stomach"),

        LeftArm = findfirstchild(LocalPlayer, "lArmUpper"),
        LeftLeg = findfirstchild(LocalPlayer, "lLegUpper"),
        RightArm = findfirstchild(LocalPlayer, "rArmUpper"),
        RightLeg = findfirstchild(LocalPlayer, "rLegUpper"),
        UpperTorso = findfirstchild(LocalPlayer, "torso"),
    }

	return tostring(LocalPlayer), LocalData
end

local function Update()
	local Folder = 0
	local Descendants = nil
	
	for _, Child in ipairs(getchildren(Workspace)) do
		if getclassname(Child) == "Folder" then
			Folder += 1
			if Folder == 5 then
				Descendants = getchildren(Child)
				break
			end
		end
	end

	local Seen = {}

    if Descendants then
	    for _, Player in ipairs(Descendants) do
		    if getclassname(Player) == "Model" and Player ~= LocalPlayer then
				local Key = tostring(Player)
			
				if not Teamates[Key] then
					local Torso = findfirstchild(Player, "torso")
					
					if is_team_check_active() and Torso and findfirstchild(Torso, "tag") then
						Teamates[Key] = true
					else
						local Parts = GetBodyParts(Player)
						if Parts.Head and Parts.HumanoidRootPart then
							if not TrackedModels[Key] then
								local ID, Data = PlayerData(Player, Parts)
								if add_model_data(Data, ID) then
									TrackedModels[ID] = Player
								end
							end
							
							Seen[Key] = true
						end
					end
				end
			end
	    end
	end

	for Key, Model in pairs(TrackedModels) do
		local HumanoidRootPart = findfirstchild(Model, "root")
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

        local LocalID, LocalData = LocalPlayerData()
        if LocalID and LocalData then
            override_local_data(LocalData)
        end
	end
end)
