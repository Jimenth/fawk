local Workspace = findfirstchildofclass(Game, "Workspace")
local Added = {}
local Path = nil

local function GetBodyParts(Model)
	return {
        Head = findfirstchild(Model, "Head"),
		LeftArm = findfirstchild(Model, "left arm"),
		RightArm = findfirstchild(Model, "right arm"),
		RightLeg = findfirstchild(Model, "right leg"),
		LeftLeg = findfirstchild(Model, "left leg"),
		Torso = findfirstchild(Model, "Torso"),
		HumanoidRootPart = findfirstchild(Model, "HumanoidRootPart") or getprimarypart(Model)
	}
end

local function PlayerData(Model, Parts)
	local Humanoid = findfirstchildofclass(Model, "Humanoid")
	local Health = gethealth(Humanoid)

	local Data = {
		Username = tostring(Model),
		Displayname = getname(Model),
		Userid = 0,
		Character = Model,
		PrimaryPart = getprimarypart(Model) or Parts.HumanoidRootPart,
		Humanoid = Humanoid,
		Head = Parts.Head,
        Torso = Parts.Torso,
        LeftArm = Parts.LeftArm, 
        LeftLeg = Parts.LeftLeg, 
        RightArm = Parts.RightArm, 
        RightLeg = Parts.RightLeg, 
		BodyHeightScale = 1,
		RigType = 0,
		Whitelisted = false,
		Archenemies = false,
		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,
		Health = Health,
		MaxHealth = getmaxhealth(Humanoid),
	}

	return tostring(Model), Data
end

local function FindPath()
	local Children = getchildren(Workspace)
	for i = #Children, 1, -1 do
		local Model = Children[i]
		if getclassname(Model) == "Model" and getname(Model) == "Model" then
			return Model
		end
	end
	return nil
end

local function Update()
	Path = FindPath()
	if not Path then return end

	local Descendants = getchildren(Path)
	local Seen = {}

	for _, Player in ipairs(Descendants) do
		local Humanoid = findfirstchildofclass(Player, "Humanoid")
		
		if getname(Player) ~= getname(getlocalplayer()) then
			local Key = tostring(Player)
			local Parts = GetBodyParts(Player)

			if Parts.Head and Parts.HumanoidRootPart then
				if not Added[Key] then
					local ID, Data = PlayerData(Player, Parts)
					if add_model_data(Data, ID) then
						Added[ID] = Player
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
		wait(1/15)
		Update()
	end
end)
