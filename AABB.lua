local function GetAABB(Model, Method)
	if not Model then return nil end

	local Parts = {}
	local Objects

	if Method == "Descendants" then Objects = Model:GetDescendants() elseif Method == "Children" then Objects = Model:GetChildren() end

	for _, Part in Objects do
		if Part.ClassName == "Part" or Part.ClassName == "MeshPart" then
		    local _, OnScreen = workspace.CurrentCamera:WorldToScreenPoint(Part.Position)
		    if OnScreen then
		    	Parts[#Parts + 1] = Part
		    end
        end
	end

	if #Parts == 0 then return nil end

	local MinX, MinY = math.huge, math.huge
	local MaxX, MaxY = -math.huge, -math.huge
	local OnScreen = false

	for _, Part in Parts do
		local CFrame = Part.CFrame
		local Size = Part.Size
		local Right, Up, Look = CFrame.RightVector, CFrame.UpVector, CFrame.LookVector
		local Position = CFrame.Position

		for X = -0.5, 0.5, 1 do
			for Y = -0.5, 0.5, 1 do
				for Z = -0.5, 0.5, 1 do
					local Offset = Vector3.new(
						Right.X * X * Size.X + Up.X * Y * Size.Y + Look.X * Z * Size.Z,
						Right.Y * X * Size.X + Up.Y * Y * Size.Y + Look.Y * Z * Size.Z,
						Right.Z * X * Size.X + Up.Z * Y * Size.Y + Look.Z * Z * Size.Z
					)

                    if Position and Offset then
					    local Screen, Visible = workspace.CurrentCamera:WorldToScreenPoint(Position + Offset)
					    if not Visible then continue end

					    OnScreen = true
					    local ScreenX, ScreenY = Screen.X, Screen.Y

					    if ScreenX < MinX then MinX = ScreenX end
					    if ScreenY < MinY then MinY = ScreenY end
					    if ScreenX > MaxX then MaxX = ScreenX end
					    if ScreenY > MaxY then MaxY = ScreenY end
                    end
				end
			end
		end
	end

	if not OnScreen then
		return nil
	end

	return {
		Min = Vector2.new(MinX, MinY),
		Size = Vector2.new(MaxX - MinX, MaxY - MinY)
	}
end

return {
	GetAABB = GetAABB
}
