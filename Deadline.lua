local Workspace = findfirstchildofclass(Game, "Workspace")
local LocalPlayer = findfirstchild(findfirstchild(Workspace, "characters"), "StarterCharacter")
local TrackedModels = {}

local function TeamCheck(Entity)
	if not LocalPlayer then return false end

	local Head = findfirstchild(Entity, "head")
	local Head2 = findfirstchild(Head, "head")
	local HeadObject = findfirstchild(Head2, "item")

	local LocalPlayerHead = findfirstchild(LocalPlayer, "head")
	local LocalPlayerHead2 = findfirstchild(LocalPlayerHead, "head")
	local LocalPlayerHeadObject = findfirstchild(LocalPlayerHead2, "item")

	if getclassname(HeadObject) == getclassname(LocalPlayerHeadObject) then
		return true
	else
		return false
	end
end

local function GetBodyParts(Model)
	return {
        Head = findfirstchild(Model, "head"),
		LeftArm = findfirstchild(Model, "left_arm_vis"),
		RightArm = findfirstchild(Model, "right_arm_vis"),
		RightLeg = findfirstchild(Model, "right_leg_vis"),
		LeftLeg = findfirstchild(Model, "left_leg_vis"),
		Torso = findfirstchild(Model, "torso"),
		HumanoidRootPart = findfirstchild(Model, "humanoid_root_part")
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
		Health = 100,
		MaxHealth = 100,
	}

	return tostring(Model), Data
end

local function Update()
	local Descendants = getchildren(findfirstchild(Workspace, "characters"))
	local Seen = {}

	for _, Obj in ipairs(Descendants) do
		if getname(Obj) ~= "StarterCharacter" then
			local Key = tostring(Obj)
			local Parts = GetBodyParts(Obj)
	
			if Parts.Head and Parts.HumanoidRootPart and not TeamCheck(Obj) then
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
		local HumanoidRootPart = findfirstchild(Model, "humanoid_root_part")
		if not HumanoidRootPart or not Seen[Key] then
			remove_model_data(Key)
			TrackedModels[Key] = nil
		end
	end
end

local function LocalPlayerData()
	if not LocalPlayer then return end

	local LocalData = {
		LocalPlayer = LocalPlayer,
		Character = LocalPlayer,
		Username = "diddy",
		Displayname = "diddy",
		Userid = 300,
		Team = nil,
		Tool = nil,
		Humanoid = findfirstchild(LocalPlayer, "humanoid_root_part"),
		Health = 100,
		MaxHealth = 100,
		RigType = 0,

		Head = findfirstchild(LocalPlayer, "head"),
		RootPart = findfirstchild(LocalPlayer, "humanoid_root_part"),
		LeftFoot = findfirstchild(LocalPlayer, "left_leg_vis"),
		LowerTorso = findfirstchild(LocalPlayer, "torso"),
		
		LeftArm = findfirstchild(LocalPlayer, "left_arm_vis"),
		LeftLeg = findfirstchild(LocalPlayer, "left_leg_vis"),
		RightArm = findfirstchild(LocalPlayer, "right_arm_vis"),
		RightLeg = findfirstchild(LocalPlayer, "right_leg_vis"),
		UpperTorso = findfirstchild(LocalPlayer, "torso"),
	}

	override_local_data(LocalData)
end

spawn(function()
    while true do
		wait()
		Update()
		LocalPlayerData()
	end
end)
