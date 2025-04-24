clear_model_data()

local Workspace = findfirstchildofclass(Game, "Workspace")
local TrackedModels = {}
local TeammateKeys = {}
local GameStartTime = 0
local GameStarted = false
local DetectionComplete = false
local PreviousCameraPosition = Vector3.new(0, 0, 0)
local TeleportThreshold = 10

local Offsets = {
	PlaceID = 0x198
}

local PlaceID = getmemoryvalue(Game, Offsets.PlaceID, "qword")
if PlaceID ~= 1054526971 then return end

local SpawnerMisc = findfirstchild(Workspace, "SpawnersMisc")

local function IsPlayerModel(Model)
	return findfirstchild(Model, "BillboardGui") ~= nil
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

local function CalculateDistance(Pos1, Pos2)
	local Dx, Dy, Dz = Pos1.x - Pos2.x, Pos1.y - Pos2.y, Pos1.z - Pos2.z
	return math.sqrt(Dx * Dx + Dy * Dy + Dz * Dz)
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
		RightArm = Parts.RightUpperArm,
		LeftLeg = Parts.LeftUpperLeg,
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
	local SecondLoop = {}
	local TempPlayers = {}
	local TruePlayers = getchildren(findfirstchildofclass(Game, "Players"))
	local Camera = findfirstchild(Workspace, "Camera")

	if not Camera then return end
	if not SpawnerMisc then
		local CameraPosition = getposition(Camera)
		local CameraMoved = CalculateDistance(CameraPosition, PreviousCameraPosition)

		if CameraMoved > TeleportThreshold then
			GameStarted = true
			GameStartTime = os.time()
			DetectionComplete = false
			TeammateKeys = {}
		end

		PreviousCameraPosition = CameraPosition

		for _, Obj in ipairs(Descendants) do
			if getclassname(Obj) == "Model" and getname(Obj) == "Male" then
				table.insert(SecondLoop, Obj)
			end
		end

		local ValidPlayerCount = 0
		for _, Obj in ipairs(SecondLoop) do
			local Parts = GetBodyParts(Obj)
			if Parts.Head and Parts.HumanoidRootPart then
				ValidPlayerCount += 1
			end
		end

		if ValidPlayerCount == #TruePlayers - 1 and not GameStarted then
			GameStarted = true
			GameStartTime = os.time()
			DetectionComplete = false
			TeammateKeys = {}
		end

		for _, Obj in ipairs(SecondLoop) do
			local Key = tostring(Obj)
			local Parts = GetBodyParts(Obj)

			if Parts.Head and Parts.HumanoidRootPart then
				local HeadPosition = getposition(Parts.Head)
				local Distance = CalculateDistance(CameraPosition, HeadPosition)

				table.insert(TempPlayers, {
					object = Obj,
					key = Key,
					parts = Parts,
					distance = Distance
				})
			end
		end

		table.sort(TempPlayers, function(a, b)
			return a.distance < b.distance
		end)

		if GameStarted and not DetectionComplete then
			local TimeSinceStart = os.time() - GameStartTime
			if TimeSinceStart <= 10 then
				for _, Player in ipairs(TempPlayers) do
					if Player.distance <= 50 then
						TeammateKeys[Player.key] = true
					end
				end
			else
				DetectionComplete = true
			end
		end

		for _, Player in ipairs(TempPlayers) do
			local Key = Player.key
			if TeammateKeys[Key] then
				Seen[Key] = true
				remove_model_data(Key)
				continue
			end

			if not TrackedModels[Key] then
				local ID, Data = PlayerData(Player.object, Player.parts)
				if add_model_data(Data, ID) then
					TrackedModels[ID] = Player.object
				end
			end
			Seen[Key] = true
		end
	else
		for _, Obj in ipairs(Descendants) do
			if getclassname(Obj) == "Model" and getname(Obj) == "Male" then
				local Key = tostring(Obj)
				local Parts = GetBodyParts(Obj)

				if Parts.Head and Parts.HumanoidRootPart and not IsPlayerModel(Obj) then
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
	end

	for Key, Model in pairs(TrackedModels) do
		if not findfirstchild(Model, "Root") or not Seen[Key] then
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
