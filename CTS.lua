local Module = {
	Functions = {},
	Vehicles = {},
}

local Workspace = game:FindFirstChildOfClass("Workspace")
local Players = game:FindFirstChildOfClass("Players")

local GameStorage = {
	Vehicles = Workspace and Workspace:FindFirstChild("Vehicles"),
}

local LocalPlayer = Players and Players.LocalPlayer

--?
local function GetOwnerName(Value)
	if not Value then return nil end

	if typeof(Value) == "Instance" then return Value.Name elseif typeof(Value) == "number" then return tostring(Value) elseif typeof(Value) == "string" then return Value else return tostring(Value) end
end

function Module.Functions.GetLocalModel()
	local Vehicles = GameStorage.Vehicles
	if not (Vehicles and LocalPlayer) then return end

	return Vehicles:FindFirstChild("Chassis" .. LocalPlayer.Name)
end

function Module.Functions.GetObjects(Model)
	if not Model then return end

	local RightTrack, LeftTrack, Ammunition, Engine

	for _, Object in ipairs(Model:GetDescendants()) do
		if Object.ClassName == "MeshPart" then
			if Object.Name == "Right Track" then RightTrack = Object elseif Object.Name == "Left Track" then LeftTrack = Object elseif Object.Name == "Ammunition" then Ammunition = Object elseif Object.Name == "Engine" then Engine = Object end
		end
	end

	return {
		RightTrack = RightTrack,
		LeftTrack = LeftTrack,
		Ammunition = Ammunition,
		Engine = Engine,
	}
end

function Module.Functions.PlayerData(Model)
	if not Model then return nil, nil end

	local OwnerInstance = Model:FindFirstChild("Owner")
	local OwnerName = OwnerInstance and GetOwnerName(OwnerInstance.Value)
	if not OwnerName then return nil, nil end

	local Primary = Model:FindFirstChild("HullNode")
	local Parts = Module.Functions.GetObjects(Model)

	local Data = {
		Username = tostring(Model),
		Displayname = OwnerName,
		Userid = math.random(100000, 999999),
		Character = Model,
		PrimaryPart = Primary,
		Humanoid = Primary,

		Head = (Parts and Parts.Engine) or Primary,
		Torso = (Parts and Parts.Ammunition) or Primary,
		LeftArm = (Parts and Parts.LeftTrack) or Primary,
		LeftLeg = (Parts and Parts.LeftTrack) or Primary,
		RightArm = (Parts and Parts.RightTrack) or Primary,
		RightLeg = (Parts and Parts.RightTrack) or Primary,

		BodyHeightScale = 1,
		RigType = 0,
		Whitelisted = false,
		Archenemies = false,

		Aimbot_Part = Primary,
		Aimbot_TP_Part = Primary,
		Triggerbot_Part = Primary,

		Health = 100,
		MaxHealth = 100,
	}

	return tostring(Model), Data
end

function Module.Functions.LocalPlayerData()
	local LocalModel = Module.Functions.GetLocalModel()
	if not LocalModel or not LocalPlayer then return end

	local HullNode = LocalModel:FindFirstChild("HullNode") or LocalModel

	local Data = {
		LocalPlayer = LocalModel,
		Character = LocalModel,
		Username = tostring(LocalModel),
		Displayname = LocalPlayer.DisplayName,
		Userid = LocalPlayer.UserId,
		Team = LocalPlayer.Team,

		Humanoid = HullNode,
		Health = 100,
		MaxHealth = 100,
		RigType = 0,

		Head = HullNode,
		RootPart = HullNode,
		LeftFoot = HullNode,
		LowerTorso = HullNode,
		LeftArm = HullNode,
		LeftLeg = HullNode,
		RightArm = HullNode,
		RightLeg = HullNode,
		UpperTorso = HullNode,
	}

	return tostring(LocalModel), Data
end

function Module.Functions.Update()
	local Vehicles = GameStorage.Vehicles
	if not Vehicles then return end

	local LocalModel = Module.Functions.GetLocalModel()
	local LocalTeam = LocalPlayer and LocalPlayer.Team
	local Seen = {}

	for _, Tank in ipairs(Vehicles:GetChildren()) do
		if not (Tank and LocalModel and Tank.Name ~= LocalModel.Name) then continue end

		local OwnerInstance = Tank:FindFirstChild("Owner")
		local OwnerName = OwnerInstance and GetOwnerName(OwnerInstance.Value)
		if not OwnerName then continue end

		local Player = Players:FindFirstChild(OwnerName)
		if Player and Player.Team == LocalTeam then continue end

		local Key = tostring(Tank)
		local Primary = Tank:FindFirstChild("HullNode")
		if not Primary then continue end

		if not Module.Vehicles[Key] then
			local ID, Data = Module.Functions.PlayerData(Tank)
			if ID and type(Data) == "table" and add_model_data(Data, ID) then
				Module.Vehicles[ID] = Tank
			end
		end

		Seen[Key] = true
	end

	for Key, Model in pairs(Module.Vehicles) do
		if not Seen[Key] or not (Model and Model:FindFirstChild("HullNode")) then
			remove_model_data(Key)
			Module.Vehicles[Key] = nil
		end
	end
end

task.spawn(function()
	while task.wait(1 / 60) do
		Module.Functions.Update()

		local LocalID, LocalData = Module.Functions.LocalPlayerData()
		if LocalID and LocalData then
			override_local_data(LocalData)
		end
	end
end)
