local Vehicles = game:GetService("Workspace"):FindFirstChild("Vehicles")
local Players = game:GetService("Players")
local CurrentCamera = workspace.CurrentCamera

RunService.Render:Connect(function()
    local LocalPlayer = Players and Players.LocalPlayer
    if not LocalPlayer then return nil end

    for _, Tank in ipairs(Vehicles:GetChildren()) do
        if Tank and Tank.Name ~= "Chassis".. LocalPlayer.Name then
            local Primary = Tank:FindFirstChild("HullNode")

            if Primary then
                local RealName = string.sub(Tank.Name, 8)
                local Player = game.Players:FindFirstChild(RealName)
                
                if Player and Player.Team ~= LocalPlayer.Team then
                    local Screen, OnScreen = CurrentCamera:WorldToScreenPoint(Primary.Position)
                    if OnScreen then
                        DrawingImmediate.OutlinedText(Screen, 14, Color3.fromRGB(255, 255, 255), 1, RealName, true, "LilitaOne")
                    end
                end
            end
        end
    end
end)
