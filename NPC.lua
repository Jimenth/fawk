local Workspace = findfirstchildofclass(Game, "Workspace")
local Players = findfirstchildofclass(Game, "Players")
local Added = {}

local function Games()
	return {
		[187796008] = function()
			return findfirstchild(findfirstchild(Workspace, "Entities"), "Infected")
		end,
		[3104101863] = function()
			return findfirstchild(findfirstchild(Workspace, "Ignore"), "Zombies")
		end,
		[504035427] = function()
			return findfirstchild(Workspace, "enemies")
		end,
		[3349613241] = function()
			return findfirstchild(Workspace, "NPCs")
		end,
		[1709832923] = function()
			return findfirstchild(Workspace, "Zombies")
		end,
		[169302362] = function()
			return findfirstchild(Workspace, "Baddies")
		end,
		[3956073837] = function()
			return findfirstchild(Workspace, "Zombies")
		end,
		[2263267302] = function()
			return findfirstchild(findfirstchild(Workspace, "NPCs"), "policeForce")
		end,
		[2575793677] = function()
			return findfirstchild(Workspace, "OtherWaifus")
		end,
		[3766480386] = function()
			local Map = getchildren(findfirstchild(Workspace, "CURRENT MAP"))[1]
			return { findfirstchild(Map, "ZOMBIES") }
		end,
		[5497606909] = function()
			local Map = getchildren(findfirstchild(Workspace, "CURRENT_MAP"))[1]
			return {
				findfirstchild(Map, "ZombiesSpawnedIn"),
				Map
			}
		end,
		[3326279937] = function()
			return findfirstchild(findfirstchild(Workspace, "NPCs"), "Custom")
		end,
		[1000233041] = function()
			return findfirstchild(findfirstchild(findfirstchild(Workspace, "GameObjects"), "Physical"), "Employees")
		end,
		[5091490171] = function()
			return findfirstchild(Workspace, "Bots")
		end,
		[1003981402] = function()
			return findfirstchild(Workspace, "Zombies")
		end,
		[3747388906] = function()
			return getchildren(findfirstchild(Workspace, "Military"))
		end,
		[6907570572] = function()
			return findfirstchild(findfirstchild(Workspace, "mainGame"), "active_anomaly")
		end,
	}
end

local function EntityParts(Model)
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

local function EntityData(Model, Parts)
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

local function PlayerData(Player)
	local Character = getcharacter(Player)
	local Humanoid = findfirstchildofclass(Character, "Humanoid")
	local Health = gethealth(Humanoid)

	local Data = {
		Username = getname(Player),
		Displayname = getdisplayname(Player),
		Userid = getuserid(Player),
		Character = Character,
		PrimaryPart = getprimarypart(Character),
		Humanoid = Humanoid,
		Head = findfirstchild(Character, "Head"),
		Torso = findfirstchild(Character, "Torso") or findfirstchild(Character, "UpperTorso"),
		UpperTorso = findfirstchild(Character, "UpperTorso"),
		LowerTorso = findfirstchild(Character, "LowerTorso"),
		LeftArm = findfirstchild(Character, "Left Arm") or findfirstchild(Character, "LeftUpperArm"),
		LeftLeg = findfirstchild(Character, "Left Leg") or findfirstchild(Character, "LeftUpperLeg"),
		RightArm = findfirstchild(Character, "Right Arm") or findfirstchild(Character, "RightUpperArm"),
		RightLeg = findfirstchild(Character, "Right Leg") or findfirstchild(Character, "RightUpperLeg"),
		LeftUpperArm = findfirstchild(Character, "LeftUpperArm"),
		LeftLowerArm = findfirstchild(Character, "LeftLowerArm"),
		LeftHand = findfirstchild(Character, "LeftHand"),
		RightUpperArm = findfirstchild(Character, "RightUpperArm"),
		RightLowerArm = findfirstchild(Character, "RightLowerArm"),
		RightHand = findfirstchild(Character, "RightHand"),
		LeftUpperLeg = findfirstchild(Character, "LeftUpperLeg"),
		LeftLowerLeg = findfirstchild(Character, "LeftLowerLeg"),
		LeftFoot = findfirstchild(Character, "LeftFoot"),
		RightUpperLeg = findfirstchild(Character, "RightUpperLeg"),
		RightLowerLeg = findfirstchild(Character, "RightLowerLeg"),
		RightFoot = findfirstchild(Character, "RightFoot"),
		BodyHeightScale = 1,
		RigType = findfirstchild(Character, "Torso") and 0 or 1,
		Whitelisted = false,
		Archenemies = false,
		Aimbot_Part = findfirstchild(Character, "Head"),
		Aimbot_TP_Part = findfirstchild(Character, "Head"),
		Triggerbot_Part = findfirstchild(Character, "Head"),
		Health = Health,
		MaxHealth = getmaxhealth(Humanoid),
		body_parts_data = {
			{ name = "LowerTorso", part = findfirstchild(Character, "LowerTorso") },
			{ name = "LeftUpperLeg", part = findfirstchild(Character, "LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = findfirstchild(Character, "LeftLowerLeg") },
			{ name = "RightUpperLeg", part = findfirstchild(Character, "RightUpperLeg") },
			{ name = "RightLowerLeg", part = findfirstchild(Character, "RightLowerLeg") },
			{ name = "LeftUpperArm", part = findfirstchild(Character, "LeftUpperArm") },
			{ name = "LeftLowerArm", part = findfirstchild(Character, "LeftLowerArm") },
			{ name = "RightUpperArm", part = findfirstchild(Character, "RightUpperArm") },
			{ name = "RightLowerArm", part = findfirstchild(Character, "RightLowerArm") },
		},

		full_body_data = {
			{ name = "Head", part = findfirstchild(Character, "Head") },
			{ name = "UpperTorso", part = findfirstchild(Character, "UpperTorso") },
			{ name = "LowerTorso", part = findfirstchild(Character, "LowerTorso") },
			{ name = "HumanoidRootPart", part = findfirstchild(Character, "HumanoidRootPart") },

			{ name = "LeftUpperArm", part = findfirstchild(Character, "LeftUpperArm") },
			{ name = "LeftLowerArm", part = findfirstchild(Character, "LeftLowerArm") },
			{ name = "LeftHand", part = findfirstchild(Character, "LeftHand") },

			{ name = "RightUpperArm", part = findfirstchild(Character, "RightUpperArm") },
			{ name = "RightLowerArm", part = findfirstchild(Character, "RightLowerArm") },
			{ name = "RightHand", part = findfirstchild(Character, "RightHand") },

			{ name = "LeftUpperLeg", part = findfirstchild(Character, "LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = findfirstchild(Character, "LeftLowerLeg") },
			{ name = "LeftFoot", part = findfirstchild(Character, "LeftFoot") },

			{ name = "RightUpperLeg", part = findfirstchild(Character, "RightUpperLeg") },
			{ name = "RightLowerLeg", part = findfirstchild(Character, "RightLowerLeg") },
			{ name = "RightFoot", part = findfirstchild(Character, "RightFoot") },
		}
	}

	return tostring(Character), Data
end

local function Update()
    local Seen = {}
    local Entry = Games()[getgameid()]
    local Resolved = Entry and Entry()
    local NPCPath = getchildren(Resolved) or getchildren(Workspace)

    for _, NPC in ipairs(NPCPath) do
        local Humanoid = findfirstchildofclass(NPC, "Humanoid")
        
        if Humanoid and getparent(Humanoid) and NPC ~= getcharacter(getlocalplayer()) then
            if is_team_check_active() then
                continue
            end

            local Key = tostring(NPC)
            local Parts = EntityParts(NPC)

            if Parts.HumanoidRootPart then
                if not Added[Key] then
                    local ID, Data = EntityData(NPC, Parts)
                    if add_model_data(Data, ID) then
                        Added[ID] = NPC
                    end
                else
                    edit_model_data({Health = gethealth(Humanoid)}, Key)
                end
                
                Seen[Key] = true
            end
        end
    end

	for _, Player in ipairs(getchildren(Players)) do
		local Character = getcharacter(Player)
        local Humanoid = findfirstchildofclass(Character, "Humanoid")
        
        if Character and Character ~= getcharacter(getlocalplayer()) then
            local Key = tostring(Character)
            local Parts = EntityParts(Character)

            if Parts.HumanoidRootPart then
                if not Added[Key] then
                    local ID, Data = PlayerData(Player)
                    if add_model_data(Data, ID) then
                        Added[ID] = Character
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
        wait(1 / 60)
        Update()
    end
end)
