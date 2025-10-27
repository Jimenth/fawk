local Module = {}

function Module.GetAABB(Model, Method)
	if not Model then return nil end

	local Parts = {}
	local Objects

	if Method == "Descendants" then
		Objects = Model:GetDescendants()
	elseif Method == "Children" then
		Objects = Model:GetChildren()
	else
		return nil
	end

	for _, Part in ipairs(Objects) do
		if Part:IsA("BasePart") then
			local _, OnScreen = workspace.CurrentCamera:WorldToScreenPoint(Part.Position)
			if OnScreen then
				table.insert(Parts, Part)
			end
		end
	end

	if #Parts == 0 then
		return nil
	end

	local MinX, MinY = math.huge, math.huge
	local MaxX, MaxY = -math.huge, -math.huge
	local OnScreen = false

	for _, Part in ipairs(Parts) do
		local CFrame = Part.CFrame
		local Size = Part.Size
		local Right, Up, Look = CFrame.RightVector, CFrame.UpVector, CFrame.LookVector
		local Position = CFrame.Position

		for X = -0.5, 0.5, 1 do
			for Y = -0.5, 0.5, 1 do
				for Z = -0.5, 0.5, 1 do
					local Offset = (Right * X * Size.X) + (Up * Y * Size.Y) + (Look * Z * Size.Z)
					local Screen, Visible = workspace.CurrentCamera:WorldToScreenPoint(Position + Offset)

					if Visible then
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

return Module

