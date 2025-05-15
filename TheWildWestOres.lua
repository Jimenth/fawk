local TWW = {
    Enabled = true,
    RenderDistance = 400,
}

local Workspace = FindFirstChildOfClass(Game, "Workspace")
local Entities = FindFirstChild(Workspace, "WORKSPACE_Entities")
local Players = FindFirstChild(Entities, "Players")
local Interactables = FindFirstChild(Workspace, "WORKSPACE_Interactables")
local Ores = FindFirstChild(FindFirstChild(Interactables, "Mining"), "OreDeposits")

local Drawings = {}
local LocalPlayerName = GetName(GetLocalPlayer())

local function RefreshLocalCharacter()
    return FindFirstChild(Players, LocalPlayerName)
end

local function CalculateDistance(Pos1, Pos2)
    local dx, dy, dz = Pos1.x - Pos2.x, Pos1.y - Pos2.y, Pos1.z - Pos2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function AddEntity(OreName, Object, Ore)
    if Drawings[Object] then return end

    local Character = RefreshLocalCharacter()
    if not Character then return end

    local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
    if not HumanoidRootPart then return end

    local DepositInfo = FindFirstChild(Ore, "DepositInfo")
    local OreRemainingObj = DepositInfo and FindFirstChild(DepositInfo, "OreRemaining")
    local OreRemaining = OreRemainingObj and getvalue(OreRemainingObj)

    if not OreRemaining or OreRemaining <= 0 then return end

    local DisplayName = OreName:gsub("(%l)(%u)", "%1 %2") .. " [" .. tostring(OreRemaining) .. "]"

    local Text = Drawing.new("Text")
    Text.Text = DisplayName
    Text.Visible = true
    Text.Center = true
    Text.Size = 13
    Text.Font = 1
    Text.Color = {255, 255, 255}
    Text.Outline = true

    Drawings[Object] = {
        Drawing = Text,
        Object = Object,
        Ore = Ore,
        HRP = HumanoidRootPart,
    }

    spawn(function()
        while true do
            wait()

            if not TWW.Enabled then
                Text.Visible = false
                continue
            end

            if not Object then
                Text:Remove()
                Drawings[Object] = nil
                break
            end

            local ObjPos = GetPosition(Object)
            local HRPPos = GetPosition(HumanoidRootPart)
            local Distance = CalculateDistance(HRPPos, ObjPos)

            if Distance <= TWW.RenderDistance then
                local ScreenPos, OnScreen = WorldToScreenPoint({ObjPos.x, ObjPos.y, ObjPos.z})
                if OnScreen and ScreenPos and ScreenPos.x and ScreenPos.y then
                    local UpdatedRemaining = OreRemainingObj and getvalue(OreRemainingObj)
                    if not UpdatedRemaining or UpdatedRemaining <= 0 then
                        Text:Remove()
                        Drawings[Object] = nil
                        break
                    end

                    local Scale = math.max(0.8, 1 - (Distance / TWW.RenderDistance) * 0.535)
                    Text.Size = 13 * Scale
                    Text.Position = {ScreenPos.x - Text.Size / 2, ScreenPos.y - Text.Size / 2}
                    Text.Text = OreName:gsub("(%l)(%u)", "%1 %2") .. " [" .. tostring(UpdatedRemaining) .. "]"
                    Text.Visible = true
                else
                    Text.Visible = false
                end
            else
                Text.Visible = false
            end
        end
    end)
end

spawn(function()
    while wait(2) do
        if not TWW.Enabled then continue end

        local Character = RefreshLocalCharacter()
        if not Character then continue end

        for _, OreParent in ipairs(GetChildren(Ores)) do
            local OreName = GetName(OreParent)
            for _, Ore in ipairs(GetChildren(OreParent)) do
                local Root = GetPrimaryPart(Ore)
                if Root then
                    AddEntity(OreName, Root, Ore)
                end
            end
        end

        for Object, Data in pairs(Drawings) do
            if not Data.Object then
                Data.Drawing:Remove()
                Drawings[Object] = nil
            end
        end
    end
end)
