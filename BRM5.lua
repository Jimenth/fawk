local Allowed_Entities = {"NPCs"}  -- "NPCs", "Players" (Only for PVE)

local Workspace = findfirstchildofclass(Game, "Workspace")
local TrackedModels = {}
local Offsets = {
	PlaceID = 0x198
}

local function IsPlayerModel(Model)
	if findfirstchild(Model, "BillboardGui") then
		return true
	else
		return false
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

		HumanoidRootPart = findfirstchild(Model, "Root"),
	}
end

local function PlayerData(Model, Parts)
	local Data = {
		Username = tostring(Model),
		Displayname = IsPlayerModel(Model) and "Player" or "NPC",
		Userid = IsPlayerModel(Model) and 0 or -1,
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

local function Update()
	local Descendants = getchildren(Workspace)
	local Seen = {}
	local PlaceID = getmemoryvalue(Game, Offsets.PlaceID, "qword")

	for _, Obj in ipairs(Descendants) do
		if getclassname(Obj) == "Model" and getname(Obj) == "Male" then
			local Key = tostring(Obj)
			local Parts = GetBodyParts(Obj)
	
			if Parts.Head and Parts.HumanoidRootPart then
				if PlaceID == 1054526971 then
				    if not table.find(Allowed_Entities, IsPlayerModel(Obj) and "Players" or "NPCs") then
					    continue
				    end
			    end
	
				if not TrackedModels[Key] then
					local ID, Data = PlayerData(Obj, Parts)
					if add_model_data(Data, ID) then
						TrackedModels[ID] = Obj
					end
				end
				Seen[Key] = true
			end
		end
	end

	for Key, Model in pairs(TrackedModels) do
		local Root = findfirstchild(Model, "Root")
		if not Root or not Seen[Key] then
			remove_model_data(Key)
			TrackedModels[Key] = nil
		end
	end
end

local function LocalPlayerData()
	local Camera = findfirstchild(Workspace, "Camera")
	if not Camera then return end

	local LocalData = {
		LocalPlayer = Camera,
		Character = Camera,
		Username = "diddy",
		Displayname = "diddy",
		Userid = 300,
		Team = nil,
		Tool = nil,
		Humanoid = Camera,
		Health = 100,
		MaxHealth = 100,
		RigType = 1,

		Head = Camera,
		RootPart = Camera,
		LeftFoot = Camera,
		LowerTorso = Camera,
	}

	override_local_data(LocalData)
end

spawn(function()
    while true do
		wait(0.2)
		Update()
	end
end)

spawn(LocalPlayerData)
