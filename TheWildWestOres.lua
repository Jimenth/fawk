local TWW = {
    Enabled = true,
    RenderDistance = 400,
}

local Workspace = findfirstchildofclass(Game, "Workspace")
local Entities = findfirstchild(Workspace, "WORKSPACE_Entities")
local Players = findfirstchild(Entities, "Players")
local Interactables = findfirstchild(Workspace, "WORKSPACE_Interactables")
local Ores = findfirstchild(findfirstchild(Interactables, "Mining"), "OreDeposits")

local Drawings = {}
local LocalPlayerName = getname(getlocalplayer())

local function RefreshLocalCharacter()
    return findfirstchild(Players, LocalPlayerName)
end

local function CalculateDistance(Pos1, Pos2)
    local dx, dy, dz = Pos1.x - Pos2.x, Pos1.y - Pos2.y, Pos1.z - Pos2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function AddEntity(OreName, Object, Ore)
    if Drawings[Object] then return end

    local DepositInfo = findfirstchild(Ore, "DepositInfo")
    local Remaining = DepositInfo and findfirstchild(DepositInfo, "OreRemaining")
    local OreRemaining = Remaining and getvalue(Remaining)
    if not OreRemaining or OreRemaining <= 0 then return end

    local Format = OreName:gsub("(%l)(%u)", "%1 %2")

    local Text = Drawing.new("Text")
    Text.Visible = true
    Text.Center = true
    Text.Size = 14
    Text.Font = 1
    Text.Color = {255, 255, 255}
    Text.Outline = true
    Text.Text = Format .. " [" .. tostring(OreRemaining) .. "]"

    Drawings[Object] = {
        Drawing = Text,
        Object = Object,
        Ore = Ore,
        OreName = Format,
        Remaining = Remaining,
        LastRemaining = OreRemaining,
    }
end

spawn(function()
    while true do
        wait(2)
        if not TWW.Enabled then continue end

        local Character = RefreshLocalCharacter()
        if not Character then continue end

        for _, OreParent in ipairs(getchildren(Ores)) do
            local OreName = getname(OreParent)
            for _, Ore in ipairs(getchildren(OreParent)) do
                local Root = getprimarypart(Ore)
                if Root then
                    AddEntity(OreName, Root, Ore)
                end
            end
        end
    end
end)

spawn(function()
    while true do
        wait(1/240)
        if not TWW.Enabled then
            for _, data in pairs(Drawings) do
                data.Drawing.Visible = false
            end
            continue
        end

        local Character = RefreshLocalCharacter()
        if not Character then continue end
        local HRP = findfirstchild(Character, "HumanoidRootPart")
        if not HRP then continue end

        local HRPPos = getposition(HRP)

        for Object, Data in pairs(Drawings) do
            local Ore, Text = Data.Ore, Data.Drawing
            local Remaining = Data.Remaining

            if not Object or not Ore or not Remaining then
                Text:Remove()
                Drawings[Object] = nil
                continue
            end

            local OrePos = getposition(Object)
            local Distance = CalculateDistance(HRPPos, OrePos)

            if Distance > TWW.RenderDistance then
                Text.Visible = false
                continue
            end

            local ScreenPos, OnScreen = worldtoscreenpoint({OrePos.x, OrePos.y, OrePos.z})
            if not OnScreen then
                Text.Visible = false
                continue
            end

            local UpdatedRemaining = getvalue(Remaining)
            if not UpdatedRemaining or UpdatedRemaining <= 0 then
                Text:Remove()
                Drawings[Object] = nil
                continue
            end

            if UpdatedRemaining ~= Data.LastRemaining then
                Data.LastRemaining = UpdatedRemaining
                Text.Text = Data.OreName .. " [" .. tostring(UpdatedRemaining) .. "]"
            end

            local Scale = math.max(0.8, 1 - (Distance / TWW.RenderDistance) * 0.535)
            local Size = 14 * Scale
            Text.Size = Size
            Text.Position = {ScreenPos.x - Size / 2, ScreenPos.y - Size / 2}
            Text.Visible = true
        end
    end
end)
