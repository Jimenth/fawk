--!nonstrict

local Raycast = {}
Raycast.__index = Raycast

local Workspace = game:GetService("Workspace")

local CachedParts = {}
local LastCacheTime = 0
local CacheInterval = 5

local RayVisualization = {
    Enabled = false,
    RayOrigin = nil,
    RayDirection = nil,
    HitPoint = nil,
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 1,
    Opacity = 1,
}

local Vector3 = {}
Vector3.__index = Vector3

function Vector3.new(x, y, z)
    return setmetatable({X = x or 0, Y = y or 0, Z = z or 0}, Vector3)
end

function Vector3.__add(a, b)
    return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end

function Vector3.__sub(a, b)
    return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end

function Vector3.__mul(a, b)
    if type(b) == "number" then
        return Vector3.new(a.X * b, a.Y * b, a.Z * b)
    else
        return Vector3.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
    end
end

function Vector3.__tostring(self)
    return string.format("Vector3(%.2f, %.2f, %.2f)", self.X, self.Y, self.Z)
end

function Vector3:Magnitude()
    return math.sqrt(self.X * self.X + self.Y * self.Y + self.Z * self.Z)
end

function Raycast:SetVisualization(enabled, color, thickness, opacity)
    RayVisualization.Enabled = enabled
    RayVisualization.Color = color or Color3.fromRGB(255, 255, 255)
    RayVisualization.Thickness = thickness or 1
    RayVisualization.Opacity = opacity or 1
end

local function RenderRayVisualization()
    if not RayVisualization.Enabled or not RayVisualization.RayOrigin then
        return
    end
    
    local Camera = workspace.CurrentCamera
    local Origin3D = RayVisualization.RayOrigin
    local EndPoint3D = RayVisualization.HitPoint or (Origin3D + RayVisualization.RayDirection)
    
    local Origin2D = Camera:WorldToScreenPoint(Vector3.new(Origin3D.X, Origin3D.Y, Origin3D.Z))
    local EndPoint2D = Camera:WorldToScreenPoint(Vector3.new(EndPoint3D.X, EndPoint3D.Y, EndPoint3D.Z))
    
    DrawingImmediate.Line(
        Vector2.new(Origin2D.X, Origin2D.Y),
        Vector2.new(EndPoint2D.X, EndPoint2D.Y),
        RayVisualization.Color,
        RayVisualization.Opacity,
        1,
        RayVisualization.Thickness
    )
end

-- Connect render function to RunService
RunService.Render:Connect(RenderRayVisualization)

local function UpdatePartCache()
    local CurrentTime = os.time()
    if CurrentTime - LastCacheTime < CacheInterval then
        return
    end
    
    CachedParts = {}
    LastCacheTime = CurrentTime
    
    if Workspace then
        local Descendants = Workspace:GetDescendants()
        for _, Obj in pairs(Descendants) do
            if Obj and Obj.Size and Obj.CFrame then
                table.insert(CachedParts, Obj)
            end
        end
    end
end

local function RayBoxIntersect(RayOrigin, RayDir, BoxMin, BoxMax)
    local DirX, DirY, DirZ = RayDir.X, RayDir.Y, RayDir.Z
    local OriginX, OriginY, OriginZ = RayOrigin.X, RayOrigin.Y, RayOrigin.Z
    
    local TMin = -math.huge
    local TMax = math.huge
    
    -- X axis
    if math.abs(DirX) > 1e-8 then
        local T1 = (BoxMin.X - OriginX) / DirX
        local T2 = (BoxMax.X - OriginX) / DirX
        if T1 > T2 then T1, T2 = T2, T1 end
        TMin = math.max(TMin, T1)
        TMax = math.min(TMax, T2)
    else
        if OriginX < BoxMin.X or OriginX > BoxMax.X then
            return false, 0, nil
        end
    end
    
    if TMin > TMax then return false, 0, nil end
    
    -- Y axis
    if math.abs(DirY) > 1e-8 then
        local T1 = (BoxMin.Y - OriginY) / DirY
        local T2 = (BoxMax.Y - OriginY) / DirY
        if T1 > T2 then T1, T2 = T2, T1 end
        TMin = math.max(TMin, T1)
        TMax = math.min(TMax, T2)
    else
        if OriginY < BoxMin.Y or OriginY > BoxMax.Y then
            return false, 0, nil
        end
    end
    
    if TMin > TMax then return false, 0, nil end
    
    -- Z axis
    if math.abs(DirZ) > 1e-8 then
        local T1 = (BoxMin.Z - OriginZ) / DirZ
        local T2 = (BoxMax.Z - OriginZ) / DirZ
        if T1 > T2 then T1, T2 = T2, T1 end
        TMin = math.max(TMin, T1)
        TMax = math.min(TMax, T2)
    else
        if OriginZ < BoxMin.Z or OriginZ > BoxMax.Z then
            return false, 0, nil
        end
    end
    
    if TMin > TMax then return false, 0, nil end
    
    local Distance = TMin >= 0 and TMin or TMax
    if Distance < 0 then return false, 0, nil end
    
    local HitPoint = RayOrigin + RayDir * Distance
    return true, Distance, HitPoint
end

local function RayOBBIntersect(RayOrigin, RayDir, Part)
    local CF = Part.CFrame
    local Size = Part.Size
    local HalfSize = Size * 0.5
    
    local PartPos = CF.Position
    
    local BoxMin = PartPos - HalfSize
    local BoxMax = PartPos + HalfSize
    
    return RayBoxIntersect(RayOrigin, RayDir, BoxMin, BoxMax)
end

function Raycast:Cast(origin, direction, params)
    params = params or {}
    UpdatePartCache()
    
    local blacklist = params.Blacklist or {}
    local visualize = params.Visualize or false
    
    local closestHit = nil
    local closestDistance = math.huge
    local closestPoint = nil
    
    for _, part in pairs(CachedParts) do
        local shouldSkip = false
        
        if blacklist[part.Name] then
            shouldSkip = true
        end
        
        if not shouldSkip and (not part.CanCollide or part.Transparency and part.Transparency >= 1) then
            shouldSkip = true
        end
        
        if not shouldSkip then
            local hit, distance, hitPoint = RayOBBIntersect(origin, direction, part)
            
            if hit and distance < closestDistance then
                closestDistance = distance
                closestHit = part
                closestPoint = hitPoint
            end
        end
    end
    
    if visualize then
        RayVisualization.RayOrigin = origin
        RayVisualization.RayDirection = direction
        RayVisualization.HitPoint = closestPoint
    end
    
    if closestHit then
        return {
            Instance = closestHit,
            Position = closestPoint,
            Distance = closestDistance
        }
    end
    
    return nil
end

function Raycast.new()
    return setmetatable({}, Raycast)
end

return Raycast
