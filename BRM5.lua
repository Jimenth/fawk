local Options = {
    ["Allowed Entities"] = {"NPCs", "Players"}, -- "NPCs", "Players"
    ["Render Distance"] = 400,
    ["Aimbot"] = {
        ["Enabled"] = true,
        ["Aim Part"] = "Head",
        ["Sensitivity"] = 0.6,
        ["Smoothness"] = {
            ["X"] = 1,
            ["Y"] = 1
        },
        ["FOV"] = {
            ["Visible"] = true,
            ["Color"] = {255, 255, 255},
            ["Transparency"] = 1,
            ["Filled"] = false,
            ["Thickness"] = 1,
            ["Radius"] = {
                ["Dynamic"] = true,
                ["Size"] = 80
            }
        }
    },

    ["Box"] = {
        ["Enabled"] = true,
        ["Color"] = {255, 255, 255},
        ["Thickness"] = 1,
        ["Transparency"] = 1,
        ["Style"] = "3D", -- "2D, "3D"
    },
    
    ["Name"]     = { ["Enabled"] = true, ["Color"] = {255, 255, 255}, ["Font"] = 5 },
    ["Distance"] = { ["Enabled"] = true, ["Color"] = {255, 255, 255}, ["Font"] = 5 },
    ["Skeleton"] = { ["Enabled"] = true, ["Color"] = {255, 255, 255}, ["Thickness"] = 1, ["Transparency"] = 1 }
}

local Drawings = {}
local TrackedEntities = {}
local Joints = {
    {"LeftHand", "LeftLowerArm"},
    {"LeftLowerArm", "LeftUpperArm"},
    {"LeftUpperArm", "UpperTorso"},
    {"RightHand", "RightLowerArm"},
    {"RightLowerArm", "RightUpperArm"},
    {"RightUpperArm", "UpperTorso"},
    {"LeftFoot", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftUpperLeg"},
    {"LeftUpperLeg", "LowerTorso"},
    {"RightFoot", "RightLowerLeg"},
    {"RightLowerLeg", "RightUpperLeg"},
    {"RightUpperLeg", "LowerTorso"},
    {"LowerTorso", "UpperTorso"},
    {"UpperTorso", "Head"}
}

local Workspace = findfirstchildofclass(Game, "Workspace")
local MouseService = findfirstchildofclass(Game, "MouseService")
local Camera = findfirstchild(Workspace, "Camera")
local UserInput = true
local Target = nil

local function GetMousePos()
    local Mouse = getmouselocation(MouseService)
    return {x = Mouse.x, y = Mouse.y}
end

local FOV = Drawing.new("Circle")
FOV.Color = Options.Aimbot.FOV.Color
FOV.Transparency = Options.Aimbot.FOV.Transparency
FOV.Visible = Options.Aimbot.FOV.Visible
FOV.Filled = Options.Aimbot.FOV.Filled
FOV.Thickness = Options.Aimbot.FOV.Thickness

local function FOVCheck(ScreenPos)
    local dx = ScreenPos.x - GetMousePos().x
    local dy = ScreenPos.y - GetMousePos().y
    local Distance = math.sqrt(dx * dx + dy * dy)
    return Distance <= FOV.Radius
end

local function CalculateDistance(Position1, Position2)
    return math.sqrt((Position1.x - Position2.x) ^ 2 + (Position1.y - Position2.y) ^ 2 + (Position1.z - Position2.z) ^ 2)
end

function IsNPC(Model)
    if not findfirstchild(Model, "BillboardGui") then
        return true
    end

    return false
end

local function FindClosestPaki()
    local ClosestEntity = nil
    local ShortestDistance = math.huge
    local MousePos = GetMousePos()
    
    for _, Child in ipairs(getchildren(Workspace)) do
        if getclassname(Child) == "Model" then
            local HumanoidRootPart = findfirstchild(Child, "Root")
            if HumanoidRootPart then
                local RootPos = getposition(HumanoidRootPart)
                local CameraPos = getposition(Camera)
                local Position, OnScreen = worldtoscreenpoint({RootPos.x, RootPos.y, RootPos.z})

                local ShouldAdd = false
                if IsNPC(Child) then
                    if table.find(Options["Allowed Entities"], "NPCs") then
                        ShouldAdd = true
                    end
                else
                    if table.find(Options["Allowed Entities"], "Players") then
                        ShouldAdd = true
                    end
                end

                if OnScreen and ShouldAdd and CalculateDistance(CameraPos, RootPos) <= Options["Render Distance"] then
                    local dx = Position.x - MousePos.x
                    local dy = Position.y - MousePos.y
                    local Distance = math.sqrt(dx * dx + dy * dy)
                    if Distance < ShortestDistance and FOVCheck(Position) then
                        ClosestEntity = Child
                        ShortestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestEntity
end

spawn(function()
    while UserInput do
        local IsHeld = isrightpressed()
        if IsHeld then
            Options.Aimbot.Enabled = true
            Target = FindClosestPaki()
        elseif not IsHeld then
            Options.Aimbot.Enabled = false
        end
        wait(0)
    end
end)

function AddEntity(Entity)
    if Drawings[Entity] then return end

    local Box = Drawing.new("Square")
    Box.Visible = true
    Box.Color = Options.Box.Color
    Box.Thickness = Options.Box.Thickness
    Box.Transparency = Options.Box.Transparency

    local Name = Drawing.new("Text")
    Name.Visible = true
    Name.Color = Options.Name.Color
    Name.Size = 12
    Name.Font = Options.Name.Font
    Name.Outline = true

    local Distance = Drawing.new("Text")
    Distance.Visible = true
    Distance.Color = Options.Distance.Color
    Distance.Size = 12
    Distance.Font = Options.Distance.Font
    Distance.Outline = true

    if IsNPC(Entity) then
        Name.Text = "NPC"
    else
        Name.Text = "Player"
    end

    local Skeleton = {}
    for _, Joint in ipairs(Joints) do
        local Line = Drawing.new("Line")
        Line.Visible = true
        Line.Thickness = Options.Skeleton.Thickness
        Line.Color = Options.Skeleton.Color
        Line.Transparency = Options.Skeleton.Transparency
        table.insert(Skeleton, Line)
    end

    local Box3DLines = {}
    for _ = 1, 12 do
        local Line = Drawing.new("Line")
        Line.Visible = false
        Line.Thickness = Options.Box.Thickness
        Line.Color = Options.Box.Color
        Line.Transparency = Options.Box.Transparency
        table.insert(Box3DLines, Line)
    end

    Drawings[Entity] = {
        Box = Box,
        Name = Name,
        Distance = Distance,
        Skeleton = Skeleton,
        Box3D = Box3DLines
    }

    table.insert(TrackedEntities, Entity)
end

spawn(function()
    while wait() do
        local CameraPos = getposition(Camera)

        for I = #TrackedEntities, 1, -1 do
            local Entity = TrackedEntities[I]
            local EntityDrawings = Drawings[Entity]
            local Box = EntityDrawings.Box
            local Name = EntityDrawings.Name
            local Distance = EntityDrawings.Distance
            local Skeleton = EntityDrawings.Skeleton
            local Box3D = EntityDrawings.Box3D

            local HumanoidRootPart = findfirstchild(Entity, "Root")
            local Head = findfirstchild(Entity, "Head")
            local RootPos = HumanoidRootPart and getposition(HumanoidRootPart)

            if not Entity or not isdescendantof(Entity, Workspace) or not HumanoidRootPart then
                if Box then Box:Remove() end
                if Name then Name:Remove() end
                if Distance then Distance:Remove() end
                if Skeleton then
                    for _, Line in ipairs(Skeleton) do
                        Line:Remove()
                    end
                end
                if Box3D then
                    for _, Line in ipairs(Box3D) do
                        Line:Remove()
                    end
                end
                Drawings[Entity] = nil
                table.remove(TrackedEntities, I)
            else
                if CalculateDistance(CameraPos, RootPos) > Options["Render Distance"] then
                    Box.Visible = false
                    Name.Visible = false
                    Distance.Visible = false
                    for _, Line in ipairs(Skeleton) do
                        Line.Visible = false
                    end
                    for _, Line in ipairs(Box3D) do
                        Line.Visible = false
                    end
                else
                    if Head then
                        local MinX, MinY, MinZ = math.huge, math.huge, math.huge
                        local MaxX, MaxY, MaxZ = -math.huge, -math.huge, -math.huge

                        for _, Part in ipairs(getchildren(Entity)) do
                            if getclassname(Part) == "Part" or getclassname(Part) == "MeshPart" then
                                local Pos = getposition(Part)
                                local Size = getsize(Part)
                                if Pos and Size then
                                    MinX = math.min(MinX, Pos.x - Size.x / 2)
                                    MinY = math.min(MinY, Pos.y - Size.y / 2)
                                    MinZ = math.min(MinZ, Pos.z - Size.z / 2)
                                    MaxX = math.max(MaxX, Pos.x + Size.x / 2)
                                    MaxY = math.max(MaxY, Pos.y + Size.y / 2)
                                    MaxZ = math.max(MaxZ, Pos.z + Size.z / 2)
                                end
                            end
                        end

                        local Corners = {
                            {MinX, MinY, MinZ}, {MaxX, MinY, MinZ},
                            {MinX, MaxY, MinZ}, {MaxX, MaxY, MinZ},
                            {MinX, MinY, MaxZ}, {MaxX, MinY, MaxZ},
                            {MinX, MaxY, MaxZ}, {MaxX, MaxY, MaxZ}
                        }

                        local ScreenPoints = {}
                        for _, Corner in ipairs(Corners) do
                            local ScreenPoint, OnScreen = WorldToScreenPoint(Corner)
                            if OnScreen then
                                table.insert(ScreenPoints, ScreenPoint)
                            end
                        end

                        if #ScreenPoints > 0 then
                            local MinX2, MinY2 = math.huge, math.huge
                            local MaxX2, MaxY2 = -math.huge, -math.huge

                            for _, Point in ipairs(ScreenPoints) do
                                MinX2 = math.min(MinX2, Point.x)
                                MinY2 = math.min(MinY2, Point.y)
                                MaxX2 = math.max(MaxX2, Point.x)
                                MaxY2 = math.max(MaxY2, Point.y)
                            end

                            local Width = MaxX2 - MinX2
                            local Height = MaxY2 - MinY2

                            Box.Position = {MinX2, MinY2}
                            Box.Size = {Width, Height}

                            Name.Position = {MinX2 + Width / 2 - Name.TextBounds.x / 2, MinY2 - 15}

                            Distance.Position = {MinX2 + Width / 2 - Distance.TextBounds.x / 2, MaxY2 + 5}
                            Distance.Text = tostring(math.floor(CalculateDistance(CameraPos, RootPos))) .. " m"

                            if Options.Box.Style == "2D" then
                                Box.Visible = Options.Box.Enabled
                                for _, Line in ipairs(Box3D) do Line.Visible = false end
                            else
                                Box.Visible = false
                            
                                local Edges = {
                                    {1, 2}, {2, 4}, {4, 3}, {3, 1},
                                    {5, 6}, {6, 8}, {8, 7}, {7, 5},
                                    {1, 5}, {2, 6}, {3, 7}, {4, 8}
                                }
                            
                                for i, Edge in ipairs(Edges) do
                                    local A = Corners[Edge[1]]
                                    local B = Corners[Edge[2]]
                                    local A2D, OnScreenA = worldtoscreenpoint(A)
                                    local B2D, OnScreenB = worldtoscreenpoint(B)
                            
                                    local Line = Box3D[i]
                                    if OnScreenA and OnScreenB then
                                        Line.From = {A2D.x, A2D.y}
                                        Line.To = {B2D.x, B2D.y}
                                        Line.Visible = Options.Box.Enabled
                                    else
                                        Line.Visible = false
                                    end
                                end
                            end
                            
                            Name.Visible = Options.Name.Enabled
                            Distance.Visible = Options.Distance.Enabled

                            local Index = 1
                            for _, Joint in ipairs(Joints) do
                                local Part1 = findfirstchild(Entity, Joint[1])
                                local Part2 = findfirstchild(Entity, Joint[2])

                                if Part1 and Part2 then
                                    local Pos1 = getposition(Part1)
                                    local Pos2 = getposition(Part2)

                                    local SkeletonOffsets = {
                                        UpperTorso = 0.7,
                                        Head = -0.2,
                                    }

                                    for i = 1, 2 do
                                        local JointType = Joint[i]
                                        local Offset = SkeletonOffsets[JointType]
                                        if Offset then
                                            if i == 1 then
                                                Pos1.y = Pos1.y + Offset
                                            else
                                                Pos2.y = Pos2.y + Offset
                                            end
                                        end
                                    end

                                    if Pos1 and Pos2 then
                                        local ScreenPos1, OnScreen1 = WorldToScreenPoint({Pos1.x, Pos1.y, Pos1.z})
                                        local ScreenPos2, OnScreen2 = WorldToScreenPoint({Pos2.x, Pos2.y, Pos2.z})

                                        if OnScreen1 and OnScreen2 then
                                            local Line = Skeleton[Index]
                                            if Line then
                                                Line.From = {ScreenPos1.x, ScreenPos1.y}
                                                Line.To = {ScreenPos2.x, ScreenPos2.y}
                                                Line.Visible = Options.Skeleton.Enabled
                                            end
                                        else
                                            if Skeleton[Index] then
                                                Skeleton[Index].Visible = false
                                            end
                                        end
                                    else
                                        if Skeleton[Index] then
                                            Skeleton[Index].Visible = false
                                        end
                                    end
                                elseif Skeleton[Index] then
                                    Skeleton[Index].Visible = false
                                end

                                Index = Index + 1
                            end
                        else
                            Box.Visible = false
                            Name.Visible = false
                            Distance.Visible = false
                            for _, Line in ipairs(Skeleton) do
                                Line.Visible = false
                            end
                            for _, Line in ipairs(Box3D) do
                                Line.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while wait(2) do
        for _, Child in ipairs(getchildren(Workspace)) do
            local ShouldAdd = false

            if getclassname(Child) == "Model" and getname(Child) == "Male" then
                if IsNPC(Child) and table.find(Options["Allowed Entities"], "NPCs") then
                    ShouldAdd = true
                elseif not IsNPC(Child) and table.find(Options["Allowed Entities"], "Players") then
                    ShouldAdd = true
                end

                if ShouldAdd then
                    AddEntity(Child)
                end
            end
        end
    end
end)

spawn(function()
    while true do
        wait()
        
        local ScreenSize = getscreendimensions()
        FOV.Position = {ScreenSize.x / 2, ScreenSize.y / 2}
        
        if Options.Aimbot.FOV.Radius.Dynamic then
            FOV.Radius = 0.9 / math.tan(math.rad(getcamerafov(Camera) / 2)) * Options.Aimbot.FOV.Radius.Size
        else 
            FOV.Radius = Options.Aimbot.FOV.Radius.Size
        end

        if Options.Aimbot.Enabled and Target then
            if Target then
                local Object = findfirstchild(Target, Options.Aimbot["Aim Part"])
                if Object then
                    local Position = getposition(Object)
                    local ScreenPos = worldtoscreenpoint({Position.x, Position.y, Position.z})
                    if ScreenPos then
                        local MousePos = GetMousePos()
                        local dx = ((ScreenPos.x - MousePos.x) / Options.Aimbot.Smoothness.X) * Options.Aimbot.Sensitivity
                        local dy = ((ScreenPos.y - MousePos.y) / Options.Aimbot.Smoothness.Y) * Options.Aimbot.Sensitivity
                        mousemoverel(dx, dy)
                    end
                end
            end
        end
    end
end)