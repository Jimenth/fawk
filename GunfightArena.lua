local Added = {}
local Workspace = findfirstchildofclass(Game, "Workspace")
local Players = findfirstchildofclass(Game, "Players")
local LocalPlayer = getlocalplayer()

local function IsPlayer(Model)
	local PlayerModel = findfirstchild(Players, getname(Model)) 
    return PlayerModel and getclassname(PlayerModel) ~= "Folder"
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

		HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart"),
	}
end

local function PlayerData(Model, Parts)
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
	local Seen = {}

	for _, Model in ipairs(getchildren(Workspace)) do
		local Humanoid = findfirstchildofclass(Model, "Humanoid")

		if getclassname(Model) == "Model" and not IsPlayer(Model) and Model ~= getcharacter(LocalPlayer) then
			local Key = tostring(Model)
			local Parts = GetBodyParts(Model)

			if Parts.Head and Parts.HumanoidRootPart then
				if not Added[Key] then
					local ID, Data = PlayerData(Model, Parts)
					if add_model_data(Data, ID) then
						Added[ID] = Model
					end
				else
                    edit_model_data({Health = gethealth(Humanoid)}, Key)
				end

				Seen[Key] = true
			end
		end
	end

	for Key, Model in pairs(Added) do
		local HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart")
		if not HumanoidRootPart or not Seen[Key] then
			remove_model_data(Key)
			Added[Key] = nil
		end
	end
end

spawn(function()
    while true do
		wait(1/60)
		Update()
	end
end)
