local Workspace = findfirstchildofclass(Game, "Workspace")
local TrackedModels = {}

local function GetLocalModel()
    return findfirstchild(findfirstchild(Workspace, "characters"), "StarterCharacter")
end

local function TeamCheck(Entity)
	local LocalPlayer = GetLocalModel()
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
		PrimaryPart = getprimarypart(Model),
		Humanoid = Parts.HumanoidRootPart,
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

local function LocalPlayerData()
	local LocalPlayer = findfirstchild(Workspace, "Camera")

	local LocalData = {
		LocalPlayer = LocalPlayer,
		Character = LocalPlayer,
		Username = tostring(LocalPlayer),
		Displayname = getname(getlocalplayer()),
		Userid = 1,
		Team = nil,
		Tool = nil,
		Humanoid = LocalPlayer,
		Health = 100,
		MaxHealth = 100,
		RigType = 0,

		Head = LocalPlayer,
		RootPart = LocalPlayer,
		LeftFoot = LocalPlayer,
		LowerTorso = LocalPlayer,
		
		LeftArm = LocalPlayer,
		LeftLeg = LocalPlayer,
		RightArm = LocalPlayer,
		RightLeg = LocalPlayer,
		UpperTorso = LocalPlayer,
	}

	return tostring(LocalPlayer), LocalData
end

local function Update()
    local LocalID, LocalData = LocalPlayerData()

    if LocalID and LocalData then
        override_local_data(LocalData)
    end

    local Descendants = getchildren(findfirstchild(Workspace, "characters"))
    local Seen = {}

    for _, Player in ipairs(Descendants) do
        if getname(Player) ~= "StarterCharacter" then
            local Key = tostring(Player)
            local Parts = GetBodyParts(Player)

            local Enemy = true

            if is_team_check_active() then
                Enemy = not TeamCheck(Player)
            end
            
            if Parts.Head and Parts.HumanoidRootPart and Enemy then
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

    for Key, Model in pairs(TrackedModels) do
        local HumanoidRootPart = findfirstchild(Model, "humanoid_root_part")
        if not HumanoidRootPart or not Seen[Key] then
            remove_model_data(Key)
            TrackedModels[Key] = nil
        end
    end
end

spawn(function()
    while not GetLocalModel() do
        wait()
    end

    while true do
        wait()
        Update()
    end
end)
