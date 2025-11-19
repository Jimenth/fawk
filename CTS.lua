local Vehicles = game:GetService("Workspace"):FindFirstChild("Vehicles")
local Players = game:GetService("Players")
local CurrentCamera = workspace.CurrentCamera

RunService.Render:Connect(function()
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end

    for _, Tank in ipairs(Vehicles:GetChildren()) do
        if Tank and Tank.Name ~= "Chassis" .. LocalPlayer.Name then

            local PrimaryNode = Tank:FindFirstChild("HullNode")
            if not PrimaryNode then continue end

            local RealName = string.sub(Tank.Name, 8)
            local PlayerObject = Players:FindFirstChild(RealName)
            if not PlayerObject then continue end

            if PlayerObject and PlayerObject.Team == LocalPlayer.Team then continue end

            local PlayerDisplayName = PlayerObject.DisplayName or PlayerObject.Name

            local Hull = Tank:FindFirstChild("Hull")
            local HullModelObject = Hull
                and Hull:FindFirstChildOfClass("Model")
                and Hull:FindFirstChildOfClass("Model"):FindFirstChild("Hull")

            local HullName = Hull and Hull:FindFirstChildOfClass("Model")
                and Hull:FindFirstChildOfClass("Model").Name

            local Turret = Tank:FindFirstChild("Turret")
            local TurretModelObject = Turret
                and Turret:FindFirstChildOfClass("Model")
                and Turret:FindFirstChildOfClass("Model"):FindFirstChild("Turret")

            local AmmoContainer = nil

            if HullModelObject then
                for _, Child in ipairs(HullModelObject:GetChildren()) do
                    if Child.ClassName == "MeshPart" and Child.Name == "Ammunition" then
                        AmmoContainer = HullModelObject
                        break
                    end
                end
            end

            if not AmmoContainer and TurretModelObject then
                for _, Child in ipairs(TurretModelObject:GetChildren()) do
                    if Child.ClassName == "MeshPart" and Child.Name == "Ammunition" then
                        AmmoContainer = TurretModelObject
                        break
                    end
                end
            end

            if AmmoContainer then
                for _, AmmoPart in ipairs(AmmoContainer:GetChildren()) do
                    if AmmoPart.ClassName == "MeshPart" and AmmoPart.Name == "Ammunition" then

                        local Cf = AmmoPart.CFrame
                        local Size = AmmoPart.Size
                        local Half = Size * 0.5

                        local Offsets = {
                            Vector3.new(-Half.X, -Half.Y, -Half.Z),
                            Vector3.new( Half.X, -Half.Y, -Half.Z),
                            Vector3.new( Half.X,  Half.Y, -Half.Z),
                            Vector3.new(-Half.X,  Half.Y, -Half.Z),

                            Vector3.new(-Half.X, -Half.Y,  Half.Z),
                            Vector3.new( Half.X, -Half.Y,  Half.Z),
                            Vector3.new( Half.X,  Half.Y,  Half.Z),
                            Vector3.new(-Half.X,  Half.Y,  Half.Z),
                        }

                        local Points2D = {}

                        for i = 1, 8 do
                            local Offset = Offsets[i]

                            local WorldPoint =
                                Cf.Position
                                + Cf.RightVector * Offset.X
                                + Cf.UpVector    * Offset.Y
                                + Cf.LookVector  * Offset.Z

                            local ScreenPos, Visible = CurrentCamera:WorldToScreenPoint(WorldPoint)
                            if Visible then
                                Points2D[#Points2D + 1] = Vector2.new(ScreenPos.X, ScreenPos.Y)
                            end
                        end

                        if #Points2D >= 3 then
                            table.sort(Points2D, function(A, B)
                                return (A.X == B.X) and (A.Y < B.Y) or (A.X < B.X)
                            end)

                            local function Cross(O, A, B)
                                return (A.X - O.X) * (B.Y - O.Y) - (A.Y - O.Y) * (B.X - O.X)
                            end

                            local Lower, Upper = {}, {}

                            for _, P in ipairs(Points2D) do
                                while #Lower >= 2 and Cross(Lower[#Lower-1], Lower[#Lower], P) <= 0 do
                                    Lower[#Lower] = nil
                                end
                                Lower[#Lower + 1] = P
                            end

                            for i = #Points2D, 1, -1 do
                                local P = Points2D[i]
                                while #Upper >= 2 and Cross(Upper[#Upper-1], Upper[#Upper], P) <= 0 do
                                    Upper[#Upper] = nil
                                end
                                Upper[#Upper + 1] = P
                            end

                            Upper[#Upper] = nil
                            Lower[#Lower] = nil

                            local Hull = {}
                            for _, P in ipairs(Lower) do Hull[#Hull + 1] = P end
                            for _, P in ipairs(Upper) do Hull[#Hull + 1] = P end

                            if #Hull >= 3 then
                                local LinePoints = {}
                                for i = 1, #Hull do
                                    LinePoints[#LinePoints + 1] = Hull[i]
                                end
                                LinePoints[#LinePoints + 1] = Hull[1]

                                DrawingImmediate.Polyline(LinePoints, Color3.fromRGB(255, 255, 255), 1, 1.5)
                            end
                        end
                    end
                end
            end

            local Screen, OnScreen = CurrentCamera:WorldToScreenPoint(PrimaryNode.Position)
            if OnScreen then
                DrawingImmediate.OutlinedText(Screen, 12, Color3.fromRGB(255, 255, 255), 1, PlayerDisplayName .. "'s " .. HullName, true, "LilitaOne")
            end
        end
    end
end)
