local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local GameID = game.GameId

local Cache = {}

local Games = {
	[2838077] = Workspace:FindFirstChild("Entities") and Workspace:FindFirstChild("Entities"):FindFirstChild("Infected"), -- // Those Who Remain
	[12527656] = Workspace:FindFirstChild("Ignore") and Workspace:FindFirstChild("Ignore"):FindFirstChild("Zombies"), -- // Michael's Zombies
	[3576655] = Workspace:FindFirstChild("enemies"), -- // Zombie Attack
	[35510367] = Workspace:FindFirstChild("NPCs"), -- // AI Test
	[22025] = Workspace:FindFirstChild("Zombies"), -- // Zombie Uprising
	[219856] = Workspace:FindFirstChild("Baddies"), -- // Project Lazarus
	[15961940] = Workspace:FindFirstChild("Zombies"), -- // Korrupt Zombies
	[41271406] = Workspace:FindFirstChild("NPCs") and Workspace:FindFirstChild("NPCs"):FindFirstChild("policeForce"), -- // Infamy
	[10668871] = Workspace:FindFirstChild("OtherWaifus"), -- // AniPhobia
	[6568965] = Workspace:FindFirstChild("NPCs") and Workspace:FindFirstChild("NPCs"):FindFirstChild("Custom"), -- // Blackout: Revival [FREE ZOMBIES]
	[22718068] = Workspace:FindFirstChild("GameObjects") and Workspace:FindFirstChild("GameObjects"):FindFirstChild("Physical") and Workspace:FindFirstChild("GameObjects"):FindFirstChild("Physical"):FindFirstChild("Employees"), -- // SCP 3008
	[33054943] = Workspace:FindFirstChild("Bots"), -- // Jailbird
	[2652656] = Workspace:FindFirstChild("Zombies"), -- // Reminiscence Zombies
	[93693150] = Workspace:FindFirstChild("mainGame") and Workspace:FindFirstChild("mainGame"):FindFirstChild("active_anomaly"), -- // A-888
	[1066925] = Workspace:FindFirstChild("Zombies"), -- // AR2
	[35229570] = Workspace:FindFirstChild("Zombies"), -- // Survive Wave Z
	[29761878] = Workspace, -- // The Rake Remastered
	[1070403] = Workspace:FindFirstChild("NPCs"), -- // Identity Fraud
	[35794027] = Workspace:FindFirstChild("Bots"), -- // Da Track
}

local function GetWeapon(Entity)
	for _, Tool in ipairs(Entity:GetChildren()) do
		if Tool.ClassName == "Tool" then
			return Tool.Name
		end
	end

	for _, Model in ipairs(Entity:GetChildren()) do
		if Model and Model.ClassName == "Model" then
			if Model.ClassName ~= "Hat" and Model.ClassName ~= "Accessory" and 
			   Model.Name ~= "Hair" and Model.Name ~= "GunModel" and 
			   Model.Name:sub(1, 5) ~= "Armor" and Model.Name ~= "HolsterModel" and 
			   Model.Name ~= "Model" then
			   
				if Model:FindFirstChild("Muzzle") or Model:FindFirstChild("Handle") then
					return Model.Name
				end
			end
		end
	end

	return "None"
end

local function GetEntityParts(Model)
	if not Model then return nil end 

	return {
		Head = Model:FindFirstChild("Head"),
		UpperTorso = Model:FindFirstChild("UpperTorso"),
		LowerTorso = Model:FindFirstChild("LowerTorso"),

		LeftUpperArm = Model:FindFirstChild("LeftUpperArm"),
		LeftLowerArm = Model:FindFirstChild("LeftLowerArm"),
		LeftHand = Model:FindFirstChild("LeftHand"),

		RightUpperArm = Model:FindFirstChild("RightUpperArm"),
		RightLowerArm = Model:FindFirstChild("RightLowerArm"),
		RightHand = Model:FindFirstChild("RightHand"),

		LeftUpperLeg = Model:FindFirstChild("LeftUpperLeg"),
		LeftLowerLeg = Model:FindFirstChild("LeftLowerLeg"),
		LeftFoot = Model:FindFirstChild("LeftFoot"),

		RightUpperLeg = Model:FindFirstChild("RightUpperLeg"),
		RightLowerLeg = Model:FindFirstChild("RightLowerLeg"),
		RightFoot = Model:FindFirstChild("RightFoot"),

		LeftLeg = Model:FindFirstChild("Left Leg") or Model:FindFirstChild("LeftLeg"),
		RightLeg = Model:FindFirstChild("Right Leg") or Model:FindFirstChild("RightLeg"),
		LeftArm = Model:FindFirstChild("Left Arm") or Model:FindFirstChild("LeftArm"),
		RightArm = Model:FindFirstChild("Right Arm") or Model:FindFirstChild("RightArm"),
		Torso = Model:FindFirstChild("Torso") or Model:FindFirstChild("Body"),

		HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChild("Root"),
	}
end

local function GetEntityData(Model, Parts)
	if not Model then return nil end 

	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	local Health = 100
	local MaxHealth = 100
	
	if Humanoid then
		Health = Humanoid.Health
		MaxHealth = Humanoid.MaxHealth
	end

	local Data = {
		Username = tostring(Model),
		Displayname = Model.Name,
		Userid = -1,
		Character = Model,
		PrimaryPart = Model.PrimaryPart or Parts.HumanoidRootPart,
		Humanoid = Humanoid or Model.PrimaryPart,
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
		RigType = Model:FindFirstChild("Torso") and 0 or 1,
		Toolname = GetWeapon(Model),
		Teamname = "NPCs",
		Whitelisted = false,
		Archenemies = false,
		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,
		Health = Health,
		MaxHealth = MaxHealth,
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

local function GetPlayerData(Player)
	if not Player then return nil end

	local Character = Player.Character
	if not Character then return nil end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return nil end

	local Parts = GetEntityParts(Character)
	if not Parts then return nil end

	local Health = Humanoid.Health
	local MaxHealth = Humanoid.MaxHealth

	local Data = {
		Username = Player.Name,
		Displayname = Player.DisplayName,
		Userid = Player.UserId,

		Character = Character,
		PrimaryPart = Character.PrimaryPart,
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
		RigType = Character:FindFirstChild("Torso") and 0 or 1,
		Toolname = GetWeapon(Character),
		Teamname = Player.Team or "No Team",

		Whitelisted = false,
		Archenemies = false,

		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,

		Health = Health,
		MaxHealth = MaxHealth,

		body_parts_data = {
			{ name = "LowerTorso", part = Character:FindFirstChild("LowerTorso") },
			{ name = "LeftUpperLeg", part = Character:FindFirstChild("LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = Character:FindFirstChild("LeftLowerLeg") },
			{ name = "RightUpperLeg", part = Character:FindFirstChild("RightUpperLeg") },
			{ name = "RightLowerLeg", part = Character:FindFirstChild("RightLowerLeg") },
			{ name = "LeftUpperArm", part = Character:FindFirstChild("LeftUpperArm") },
			{ name = "LeftLowerArm", part = Character:FindFirstChild("LeftLowerArm") },
			{ name = "RightUpperArm", part = Character:FindFirstChild("RightUpperArm") },
			{ name = "RightLowerArm", part = Character:FindFirstChild("RightLowerArm") },
		},

		full_body_data = {
			{ name = "Head", part = Character:FindFirstChild("Head") },
			{ name = "UpperTorso", part = Character:FindFirstChild("UpperTorso") },
			{ name = "LowerTorso", part = Character:FindFirstChild("LowerTorso") },
			{ name = "HumanoidRootPart", part = Character:FindFirstChild("HumanoidRootPart") },

			{ name = "LeftUpperArm", part = Character:FindFirstChild("LeftUpperArm") },
			{ name = "LeftLowerArm", part = Character:FindFirstChild("LeftLowerArm") },
			{ name = "LeftHand", part = Character:FindFirstChild("LeftHand") },

			{ name = "RightUpperArm", part = Character:FindFirstChild("RightUpperArm") },
			{ name = "RightLowerArm", part = Character:FindFirstChild("RightLowerArm") },
			{ name = "RightHand", part = Character:FindFirstChild("RightHand") },

			{ name = "LeftUpperLeg", part = Character:FindFirstChild("LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = Character:FindFirstChild("LeftLowerLeg") },
			{ name = "LeftFoot", part = Character:FindFirstChild("LeftFoot") },

			{ name = "RightUpperLeg", part = Character:FindFirstChild("RightUpperLeg") },
			{ name = "RightLowerLeg", part = Character:FindFirstChild("RightLowerLeg") },
			{ name = "RightFoot", part = Character:FindFirstChild("RightFoot") },
		},
	}

	return tostring(Character), Data
end

local function GetScanPath()
	if Games[GameID] then
		return Games[GameID], false
	end
	
	local Bots = Workspace:FindFirstChild("Bots")
	if Bots and #Bots:GetChildren() > 0 then return Bots, false end
	
	local NPCs = Workspace:FindFirstChild("NPCs")
	if NPCs and #NPCs:GetChildren() > 0 then return NPCs, false end
	
	local Zombies = Workspace:FindFirstChild("Zombies")
	if Zombies and #Zombies:GetChildren() > 0 then return Zombies, false end
	
	return Workspace, true
end

RunService.PostLocal:Connect(function()
	if not Games or not GameID or not Players or not Cache then return end

	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then return end

	local LocalCharacter = LocalPlayer.Character

	local Seen = {}
	local Entry, Descendants = GetScanPath()
	if not Entry then Entry = Workspace end

	local Path

	pcall(function()
		if typeof(Entry) == "Instance" then
			if Descendants then
				Path = Entry:GetDescendants()
			else
				Path = Entry:GetChildren()
			end
		elseif typeof(Entry) == "table" then
			Path = Entry
		end
	end)

	if not Path or #Path == 0 then Path = Workspace:GetDescendants() end

	for _, NPC in ipairs(Path) do
		pcall(function()
			if NPC and typeof(NPC) == "Instance" and NPC ~= LocalCharacter then
				local Weapon = GetWeapon(NPC)
				local Humanoid = NPC:FindFirstChildOfClass("Humanoid")
				local Key = tostring(NPC)
				local Parts = GetEntityParts(NPC)

				if Parts and Parts.HumanoidRootPart then
					if not Cache[Key] then
						local ID, Data = GetEntityData(NPC, Parts)
						if ID and Data and add_model_data(Data, ID) then
							Cache[ID] = NPC
						end
					else
						edit_model_data({ Toolname = Weapon }, Key)
						if Humanoid then
							edit_model_data({ Health = Humanoid.Health }, Key)
						end
					end

					Seen[Key] = true
				end
			end
		end)
	end

	for _, Player in ipairs(Players:GetChildren()) do
		local TeamCheck = is_team_check_active()

		pcall(function()
			if Player and Player ~= LocalPlayer then
				local Character = Player.Character
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if Humanoid and Character ~= LocalCharacter then
					local Weapon = GetWeapon(Character)
					local Key = tostring(Character)
					local Parts = GetEntityParts(Character)

					if Parts and Parts.HumanoidRootPart then
						if TeamCheck then
							if Player.Team == LocalPlayer.Team then
								if Cache[Key] then
									local ID = tostring(Character)
									remove_model_data(ID)
									Cache[ID] = nil
								end
								Seen[Key] = nil
							else
								if not Cache[Key] then
									local ID, Data = GetPlayerData(Player)
									if ID and Data and add_model_data(Data, ID) then
										Cache[ID] = Character
									end
								else
									edit_model_data({ Toolname = Weapon }, Key)
									edit_model_data({ Health = Humanoid.Health }, Key)
								end
								Seen[Key] = true
							end
						else
							if not Cache[Key] then
								local ID, Data = GetPlayerData(Player)
								if ID and Data and add_model_data(Data, ID) then
								   Cache[ID] = Character
								end
							else
								edit_model_data({ Toolname = Weapon }, Key)
								edit_model_data({ Health = Humanoid.Health }, Key)
							end
							Seen[Key] = true
						end
					end
				end
			end
		end)
	end

	for Key, Model in pairs(Cache) do
		pcall(function()
			if not Model.Parent then
				remove_model_data(Key)
				Cache[Key] = nil
				return
			end

			local HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart or not Seen[Key] then
				remove_model_data(Key)
				Cache[Key] = nil
			end
		end)
	end
end)
