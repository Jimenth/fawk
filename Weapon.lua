local Settings = {
    ['Box'] = {
        ['Enabled'] = true,
        ['Color'] = {255, 255, 255},

        ['Outline'] = true,

        ['Transparency'] = 1,
        ['Thickness'] = 1,
    },
    
    ['Weapon'] = {
        ['Enabled'] = true,
        ['Color'] = {255, 255, 255},
        ['Transparency'] = 1,

        ['Outline'] = true,
        ['Outline Color'] = {0, 0, 0}
    }
}

local Module = { Functions = {}, Drawings = {}, Players = {}, Characters = {}, PlayerTeams = {} }

local Services = {
    Core = {
        Players = findfirstchildofclass(Game, "Players"),
        Workspace = findfirstchildofclass(Game, "Workspace")
    },

    References = {
        LocalPlayer = getlocalplayer()
    }
}

local GameID = getgameid()
local PreviouslyActive = is_team_check_active()

Module.Functions.Teamcheck = function(LocalPlayer, Player)
    if not LocalPlayer then return false end
    local Team1 = getteam(LocalPlayer)
    local Team2 = getteam(Player)

    return not (Team1 and Team2 and Team1 == Team2)
end

Module.Functions.Draw = function(Type, Properties)
    local New = Drawing.new(Type)
    for i, v in next, Properties or {} do
        New[i] = v
    end
    return New
end

Module.Functions.Drawings = function(Player, Character)
    if Module.Drawings[Player] then return end
    local AABBOutline = Module.Functions.Draw("Square", { Color = {0, 0, 0}, Thickness = Settings['Box']['Thickness'] + 2, Transparency = Settings['Box']['Transparency'], Filled = false })
    local AABB = Module.Functions.Draw("Square",{ Color = Settings['Box']['Color'], Thickness = Settings['Box']['Thickness'], Transparency = Settings['Box']['Transparency'], Filled = false })
    local Weapon = Module.Functions.Draw("Text", { Color = Settings['Weapon']['Color'], Outline = Settings['Weapon']['Outline'], OutlineColor = Settings['Weapon']['Outline Color'], Transparency = Settings['Weapon']['Transparency'], Center = true, Size = 12, Font = 29 })

    Module.Drawings[Player] = { AABB = AABB, AABBOutline = AABBOutline, Weapon = Weapon }
    table.insert(Module.Players, Player)

    Module.Characters[Player] = Character
    Module.PlayerTeams[Player] = getteam(Player)
end

local Games = {
    [3747388906] = { -- Fallen Survival
        Weapon = function(Character)
            for _, Child in ipairs(getchildren(Character)) do
                if getclassname(Child) == "Model" and findfirstchild(Child, "Handle") and not getname(Child):sub(1, 5) == "Armor" and not getname(Child) == "Hair" or getname(Child) == "HolsterModel" then
                    return getname(Child) or "None"
                end
            end

            return "None"
        end
    },

    [2257943402] = { -- Energy Assault FPS
        Weapon = function(Character)
            local Replicated = findfirstchild(Character, "animinfo")
            local Value = findfirstchild(Replicated, "weapon")
            
            if Value then return getvalue(Value) or "None" end

            return "None"
        end
    },

    [1865489894] = { -- Base Battles
        Weapon = function(Character)
            for _, Child in ipairs(getchildren(Character)) do
                if getclassname(Child) == "Model" and getname(Child) ~= "GunModel" and findfirstchild(Child, "Muzzle") then
                    return getname(Child) or "None"
                end
            end

            return "None"
        end
    },

    [5611522097] = { -- Airsoft Battles
        Weapon = function(Character)
            for _, Child in ipairs(getchildren(Character)) do
                if getclassname(Child) == "Model" and findfirstchild(Child, "Handle") then
                    return getname(Child) or "None"
                end
            end

            return "None"
        end
    },

    [5091490171] = { -- Jailbird
        Weapon = function(Character)
            for _, Child in ipairs(getchildren(Character)) do
                if getclassname(Child) == "Model" and findfirstchild(Child, "Handle") then
                    return getname(Child) or "None"
                end
            end

            return "None"
        end
    },

    [4914269443] = { -- Unnamed Shooter
        Weapon = function(Character)
            local Value = findfirstchild(Character, "Equipped")
            if Value then return getname(getvalue(Value)) or "None" end

            return "None"
        end
    },

    [2382284116] = { -- No Scope Arcade
        Weapon = function(Character)
            for _, Child in ipairs(getchildren(Character)) do
                if getclassname(Child) == "Model" and findfirstchild(Child, "Handle") then
                    return getname(Child) or "None"
                end
            end

            return "None"
        end
    },

    [6676525126] = { -- Planks
        Weapon = function(Character)
            for _, Child in ipairs(getchildren(Character)) do
                if getclassname(Child) == "Model" and findfirstchild(Child, "FirePart") then
                    return getname(Child) or "None"
                end
            end

            return "None"
        end
    },

    [2862098693] = { -- Project Delta
        Weapon = function(Character)
            local Items = {}

            for _, Child in ipairs(getchildren(Character)) do
                if getclassname(Child) == "Model" and findfirstchild(Child, "ItemRoot") then
                    table.insert(Items, getname(Child))
                end
            end

            if #Items > 0 then
                return table.concat(Items, ", ")
            else
                return "None"
            end
        end
    }
}

Module.Functions.GetDistance = function(Position1, Position2)
    if not Position1 or not Position2 then return math.huge end

    local DeltaX = Position1.x - Position2.x
    local DeltaY = Position1.y - Position2.y
    local DeltaZ = Position1.z - Position2.z

    return (DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ) ^ 0.5
end

Module.Functions.HandleGame = function()
    local Game = Games[GameID] or {}
    return {
        Weapon = Game.Weapon or function(Character)
            for _, Tool in ipairs(getchildren(Character)) do
                if getclassname(Tool) == "Tool" then
                    return getname(Tool) or "None"
                end
            end
            return "None"
        end
    }
end

Module.Functions.Cache = function()
    local CurrentlyActive = is_team_check_active()

    if PreviouslyActive ~= CurrentlyActive then
        PreviouslyActive = CurrentlyActive
    end

    for i = #Module.Players, 1, -1 do
        local Player = Module.Players[i]

        local Character = getcharacter(Player)
        if Character and Character ~= Module.Characters[Player] then
            Module.Characters[Player] = Character
        end

        local Valid = Character and isdescendantof(Character, Services.Core.Workspace)
        local Humanoid = Character and findfirstchildofclass(Character, "Humanoid")

        if not Valid or (Humanoid and gethealth(Humanoid) <= 2) then
            if Module.Drawings[Player] then
                for _, Drawing in pairs(Module.Drawings[Player]) do
                    if type(Drawing) == "table" and type(Drawing.Remove) == "function" then
                        Drawing:Remove()
                    elseif type(Drawing) == "table" and Drawing.Visible ~= nil then
                        Drawing.Visible = false
                    end
                end
                Module.Drawings[Player] = nil
            end

            Module.Characters[Player] = nil
            Module.PlayerTeams[Player] = nil
            table.remove(Module.Players, i)
        else
            Module.PlayerTeams[Player] = getteam(Player)
        end
    end
end

Module.Functions.GetBoundingBox = function(Character)
    if not Character then
        return nil, nil, nil, nil, false
    end

    local HumanoidRootPart = findfirstchild(Character, "HumanoidRootPart")
    if not HumanoidRootPart then
        return nil, nil, nil, nil, false
    end

    local MinX, MinY = math.huge, math.huge
    local MaxX, MaxY = -math.huge, -math.huge
    local FoundPart = false

    for _, Part in ipairs(getchildren(Character)) do
        if getclassname(Part) == "Part" or getclassname(Part) == "MeshPart" and getname(Part) ~= "HumanoidRootPart" then
            local PartPosition = getposition(Part)
            local RootPosition = getposition(HumanoidRootPart)
            local Distance = Module.Functions.GetDistance(PartPosition, RootPosition)

            if Distance <= 25 then
                FoundPart = true
                local Size = getsize(Part)

                local HalfX, HalfY, HalfZ = Size.x * 0.5, Size.y * 0.5, Size.z * 0.5

                local Corners = {
                    {PartPosition.x - HalfX, PartPosition.y - HalfY, PartPosition.z - HalfZ},
                    {PartPosition.x - HalfX, PartPosition.y + HalfY, PartPosition.z - HalfZ},
                    {PartPosition.x + HalfX, PartPosition.y - HalfY, PartPosition.z - HalfZ},
                    {PartPosition.x + HalfX, PartPosition.y + HalfY, PartPosition.z - HalfZ},
                    {PartPosition.x - HalfX, PartPosition.y - HalfY, PartPosition.z + HalfZ},
                    {PartPosition.x - HalfX, PartPosition.y + HalfY, PartPosition.z + HalfZ},
                    {PartPosition.x + HalfX, PartPosition.y - HalfY, PartPosition.z + HalfZ},
                    {PartPosition.x + HalfX, PartPosition.y + HalfY, PartPosition.z + HalfZ},
                }

                for _, Corner in ipairs(Corners) do
                    local ScreenPos = worldtoscreenpoint(Corner)
                    MinX = math.min(MinX, ScreenPos.x)
                    MinY = math.min(MinY, ScreenPos.y)
                    MaxX = math.max(MaxX, ScreenPos.x)
                    MaxY = math.max(MaxY, ScreenPos.y)
                end
            end
        end
    end

    if not FoundPart then
        return nil, nil, nil, nil, false
    end

    return MinX, MinY, MaxX, MaxY, true
end

Module.Functions.Render = function()
    for _, Player in ipairs(Module.Players) do
        local Character = Module.Characters[Player]
        if not Module.Drawings[Player] then continue end

        local AABB = Module.Drawings[Player].AABB
        local AABBOutline = Module.Drawings[Player].AABBOutline
        local Weapon = Module.Drawings[Player].Weapon

        local MinX, MinY, MaxX, MaxY, Visible = Module.Functions.GetBoundingBox(Character)

        local IsValid = not is_team_check_active() or Module.Functions.Teamcheck(Services.References.LocalPlayer, Player)

        if Visible and IsValid then
            local Scale = 1.2
            local Width, Height = MaxX - MinX, MaxY - MinY
            local ScaledWidth, ScaledHeight = Width * Scale, Height * Scale
            local OffsetX, OffsetY = (ScaledWidth - Width) / 2, (ScaledHeight - Height) / 2
            local Position = {MinX - OffsetX, MinY - OffsetY}
            local Size = {ScaledWidth, ScaledHeight}

            if Settings['Box']['Enabled'] and AABB then
                AABB.Position = Position
                AABB.Size = Size
                AABB.Visible = true
            end

            if Settings['Box']['Enabled'] and Settings['Box']['Outline'] and AABB and AABBOutline then
                AABBOutline.Position = Position
                AABBOutline.Size = Size
                AABBOutline.Visible = true
            end

            if Settings['Weapon']['Enabled'] and Weapon then
                Weapon.Position = {Position[1] + ScaledWidth / 2, Position[2] + ScaledHeight + 5}
                Weapon.Text = Module.Functions.HandleGame().Weapon(Character)
                Weapon.Visible = true
            end
        else
            if AABB then AABB.Visible = false end
            if AABBOutline then AABBOutline.Visible = false end
            if Weapon then Weapon.Visible = false end
        end
    end
end

spawn(function()
    while true do
        Module.Functions.Cache()
        wait(1 / 15)
    end
end)

spawn(function()
    while true do
        Module.Functions.Render()

        for _, Player in ipairs(getchildren(Services.Core.Players)) do
            if Player and Player ~= Services.References.LocalPlayer and not table.find(Module.Players, Player) then
                local Character = getcharacter(Player)
                local Humanoid = Character and findfirstchildofclass(Character, "Humanoid")

                if Character and isdescendantof(Character, Services.Core.Workspace) and Humanoid and gethealth(Humanoid) > 2 then
                    Module.Functions.Drawings(Player, Character)
                end
            end
        end

        wait(1 / get_overlay_fps())
    end
end)
