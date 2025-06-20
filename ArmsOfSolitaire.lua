local Added = {}
local Workspace = findfirstchildofclass(Game, "Workspace")
local GameFolder = findfirstchild(Workspace, "Game")
local PlayersFolder = findfirstchild(GameFolder, "Players")

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
				if getname(Model) == getname(getlocalplayer()) then
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
				if getclassname(Player) == "Model" and getname(Player) ~= getname(getlocalplayer()) then
					local Key = tostring(Player)
					local Parts = GetBodyParts(Player)

					if Parts.Head and Parts.HumanoidRootPart then
						if not Added[Key] then
							local ID, Data = PlayerData(Player, Parts)
							if add_model_data(Data, ID) then
								Added[ID] = Player
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

	for Key, Model in pairs(Added) do
		local HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart")
		if not HumanoidRootPart or not Seen[Key] then
			remove_model_data(Key)
			Added[Key] = nil
		end
	end
end

local function LocalPlayerData()
	local LocalPlayer = nil

	for _, Team in ipairs({ "Blue", "Green" }) do
		local TeamFolder = findfirstchild(PlayersFolder, Team)
		if TeamFolder then
			for _, Model in ipairs(getchildren(TeamFolder)) do
				if getname(Model) == getname(getlocalplayer()) then
					LocalPlayer = Model
					break
				end
			end
		end
		if LocalPlayer then break end
	end

	if not LocalPlayer then
        return nil
    end

	local Parts = GetBodyParts(LocalPlayer)
	if not Parts.HumanoidRootPart then return end

	local LocalData = {
		LocalPlayer = LocalPlayer,
		Character = LocalPlayer,
		Username = tostring(LocalPlayer),
		Displayname = getname(getlocalplayer()),
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
		wait(1/60)
		Update()

        local LocalID, LocalData = LocalPlayerData()
        if LocalID and LocalData then
            override_local_data(LocalData)
        end
	end
end)
