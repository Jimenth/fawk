local Workspace = findfirstchildofclass(Game, "Workspace")
local GameFolder = findfirstchild(Workspace, "Game")
local PlayersFolder = findfirstchild(GameFolder, "Players")
local LocalPlayerName = getname(getlocalplayer())
local TrackedModels = {}

local function GetBodyParts(Model)
	return {
		Head = findfirstchild(Model, "Head"),
		UpperTorso = findfirstchild(Model, "UpperTorso"),
		LowerTorso = findfirstchild(Model, "LowerTorso"),

		LeftUpperArm = findfirstchild(Model, "UpperLeftArm"),
		LeftLowerArm = findfirstchild(Model, "LowerLeftArm"),
		LeftHand = findfirstchild(Model, "LeftHandle"),

		RightUpperArm = findfirstchild(Model, "UpperRightArm"),
		RightLowerArm = findfirstchild(Model, "LowerRightArm"),
		RightHand = findfirstchild(Model, "RightHandle"),

		LeftUpperLeg = findfirstchild(Model, "UpperLeftLeg"),
		LeftLowerLeg = findfirstchild(Model, "LowerLeftLeg"),
		LeftFoot = findfirstchild(Model, "LeftFoot"),

		RightUpperLeg = findfirstchild(Model, "UpperRightLeg"),
		RightLowerLeg = findfirstchild(Model, "LowerRightLeg"),
		RightFoot = findfirstchild(Model, "RightFoot"),

		HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart"),
	}
end

local function PlayerData(Model, Parts)
    local Health = getvalue(findfirstchild(Model, "Health"))

	local Data = {
		Username = tostring(Model),
		Displayname = getname(Model),
		Userid = 0,
		Character = Model,
		PrimaryPart = Parts.Head,
		Humanoid = Parts.Head,
		Head = Parts.Head,
        Torso = Parts.UpperTorso, 
        UpperTorso = Parts.UpperTorso,
        LowerTorso = Parts.LowerTorso,
        LeftArm = Parts.LeftUpperArm, 
        LeftLeg = Parts.LeftLowerLeg, 
        RightArm = Parts.RightUpperArm, 
        RightLeg = Parts.RightLowerLeg, 
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

local function GetLocalPlayerTeam()
	for _, Team in ipairs({ "Blue", "Green" }) do
		local TeamFolder = findfirstchild(PlayersFolder, Team)
		if TeamFolder then
			for _, Model in ipairs(getchildren(TeamFolder)) do
				if getname(Model) == LocalPlayerName then
					return TeamFolder
				end
			end
		end
	end
	return nil
end

local function Update()
	local Seen = {}
	local LocalTeam = GetLocalPlayerTeam()

	for _, Team in ipairs({ "Blue", "Green" }) do
		local TeamFolder = findfirstchild(PlayersFolder, Team)
		if TeamFolder and TeamFolder ~= LocalTeam then
			for _, Player in ipairs(getchildren(TeamFolder)) do
				if getclassname(Player) == "Model" and getname(Player) ~= LocalPlayerName then
					local Key = tostring(Player)
					local Parts = GetBodyParts(Player)

					if Parts.Head and Parts.HumanoidRootPart then
						if not TrackedModels[Key] then
							local ID, Data = PlayerData(Player, Parts)
							if add_model_data(Data, ID) then
								TrackedModels[ID] = Player
							end
						else
							edit_model_data({ Health = getvalue(findfirstchild(Player, "Health")) }, Key)
						end
						Seen[Key] = true
					end
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

local function LocalPlayerData()
	local LocalModel = nil

	for _, Team in ipairs({ "Blue", "Green" }) do
		local TeamFolder = findfirstchild(PlayersFolder, Team)
		if TeamFolder then
			for _, Model in ipairs(getchildren(TeamFolder)) do
				if getname(Model) == LocalPlayerName then
					LocalModel = Model
					break
				end
			end
		end
		if LocalModel then break end
	end

	if not LocalModel then
        return nil
    end

	local Parts = GetBodyParts(LocalModel)
	if not Parts.Head or not Parts.HumanoidRootPart then return end

	local LocalData = {
		LocalPlayer = LocalModel,
		Character = LocalModel,
		Username = LocalPlayerName,
		Displayname = LocalPlayerName,
		Userid = 1,
		Team = nil,
		Tool = nil,
		Humanoid = Parts.Head,
		Health = 100,
		MaxHealth = 100,
		RigType = 1,

		Head = Parts.Head,
		RootPart = Parts.HumanoidRootPart,
		LeftFoot = Parts.LeftFoot,
		LowerTorso = Parts.LowerTorso,

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

	return tostring(LocalPlayer), LocalData
end

spawn(function()
	while true do
		wait()
		Update()
		local ID, LocalData = LocalPlayerData()
        if ID and LocalData then
            override_local_data(LocalData)
        end
	end
end)
