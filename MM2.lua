local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Camera = Workspace.CurrentCamera

local Roles = {
    ["Knife"] = {"Murderer", {255, 0, 0}},
    ["Gun"]   = {"Sheriff",  {0, 0, 255}}
}

local function GetVisibleParts(Character)
    local Parts = {}
    for _, Part in ipairs(Character:GetChildren()) do
        if Part.ClassName == "Part" or Part.ClassName == "MeshPart" then
            local Pos = Part.Position
            local _, OnScreen = Camera:WorldToScreenPoint(Pos)
            if OnScreen then
                table.insert(Parts, Part)
            end
        end
    end
    return Parts
end

local function CalculateCorners(Part)
    local Size = Part.Size
    local Position = Part.CFrame.Position
    local Look = Part.CFrame.LookVector
    local Right = Part.CFrame.RightVector
    local Up = Part.CFrame.UpVector
    local Corners = {}

    for X = -0.5, 0.5, 1 do
        for Y = -0.5, 0.5, 1 do
            for Z = -0.5, 0.5, 1 do
                local OffsetX = X * Size.X
                local OffsetY = Y * Size.Y
                local OffsetZ = Z * Size.Z

                local WorldX = Position.X + Right.X * OffsetX + Up.X * OffsetY + Look.X * OffsetZ
                local WorldY = Position.Y + Right.Y * OffsetX + Up.Y * OffsetY + Look.Y * OffsetZ
                local WorldZ = Position.Z + Right.Z * OffsetX + Up.Z * OffsetY + Look.Z * OffsetZ

                table.insert(Corners, {X = WorldX, Y = WorldY, Z = WorldZ})
            end
        end
    end

    return Corners
end

local function GetAABB(Parts)
    local MinX, MinY = math.huge, math.huge
    local MaxX, MaxY = -math.huge, -math.huge
    local OnScreen = false

    for _, Part in ipairs(Parts) do
        for _, Corner in ipairs(CalculateCorners(Part)) do
            local ScreenPos, Visible = Camera:WorldToScreenPoint(Corner)
            if Visible then
                OnScreen = true
                MinX = math.min(MinX, ScreenPos.X)
                MinY = math.min(MinY, ScreenPos.Y)
                MaxX = math.max(MaxX, ScreenPos.X)
                MaxY = math.max(MaxY, ScreenPos.Y)
            end
        end
    end

    if not OnScreen then return nil end
    return {
        Min = {X = MinX, Y = MinY},
        Size = {X = MaxX - MinX, Y = MaxY - MinY}
    }
end

RunService.Render:Connect(function()
	for _, Player in ipairs(Players:GetChildren()) do
		if Player == Players.LocalPlayer then
			continue
		end

		local Character = Player.Character
		if not Character then continue end

		local Backpack = Player:FindFirstChild("Backpack")
		if not Backpack then continue end

		local Role, Color

		for _, Container in ipairs({Backpack, Character}) do
			for _, Tool in ipairs(Container:GetChildren()) do
				local Data = Roles[Tool.Name]
				if Data then
					Role, Color = unpack(Data)
					break
				end
			end
			if Role then break end
		end

		if not Role then continue end

		local Parts = GetVisibleParts(Character)
        local AABB = GetAABB(Parts)
		
        if AABB then
            local CenterX = AABB.Min.X + AABB.Size.X / 2
            local BottomY = AABB.Min.Y + AABB.Size.Y
            DrawingImmediate.OutlinedText(Vector2.new(CenterX, BottomY + 1), 14, Color, 1, Role, true, "LilitaOne")
        end
	end
end)
