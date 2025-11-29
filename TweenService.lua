local TweenService = {}
TweenService.__index = TweenService

local EasingFunctions = {
    Linear = {
        In = function(t) return t end,
        Out = function(t) return t end,
        InOut = function(t) return t end
    },
    Sine = {
        In = function(t) return 1 - math.cos(t * math.pi / 2) end,
        Out = function(t) return math.sin(t * math.pi / 2) end,
        InOut = function(t) return -(math.cos(math.pi * t) - 1) / 2 end
    },
    Quad = {
        In = function(t) return t * t end,
        Out = function(t) return 1 - (1 - t) * (1 - t) end,
        InOut = function(t) return t < 0.5 and 2 * t * t or 1 - math.pow(-2 * t + 2, 2) / 2 end
    },
    Cubic = {
        In = function(t) return t * t * t end,
        Out = function(t) return 1 - math.pow(1 - t, 3) end,
        InOut = function(t) return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2 end
    },
    Quart = {
        In = function(t) return t * t * t * t end,
        Out = function(t) return 1 - math.pow(1 - t, 4) end,
        InOut = function(t) return t < 0.5 and 8 * t * t * t * t or 1 - math.pow(-2 * t + 2, 4) / 2 end
    },
    Quint = {
        In = function(t) return t * t * t * t * t end,
        Out = function(t) return 1 - math.pow(1 - t, 5) end,
        InOut = function(t) return t < 0.5 and 16 * t * t * t * t * t or 1 - math.pow(-2 * t + 2, 5) / 2 end
    },
    Exponential = {
        In = function(t) return t == 0 and 0 or math.pow(2, 10 * t - 10) end,
        Out = function(t) return t == 1 and 1 or 1 - math.pow(2, -10 * t) end,
        InOut = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return t < 0.5 and math.pow(2, 20 * t - 10) / 2 or (2 - math.pow(2, -20 * t + 10)) / 2
        end
    },
    Back = {
        In = function(t)
            local c1 = 1.70158
            local c3 = c1 + 1
            return c3 * t * t * t - c1 * t * t
        end,
        Out = function(t)
            local c1 = 1.70158
            local c3 = c1 + 1
            return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
        end,
        InOut = function(t)
            local c1 = 1.70158
            local c2 = c1 * 1.525
            return t < 0.5
                and (math.pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2)) / 2
                or (math.pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
        end
    },
    Bounce = {
        In = function(t) return 1 - EasingFunctions.Bounce.Out(1 - t) end,
        Out = function(t)
            local n1 = 7.5625
            local d1 = 2.75
            if t < 1 / d1 then
                return n1 * t * t
            elseif t < 2 / d1 then
                t = t - 1.5 / d1
                return n1 * t * t + 0.75
            elseif t < 2.5 / d1 then
                t = t - 2.25 / d1
                return n1 * t * t + 0.9375
            else
                t = t - 2.625 / d1
                return n1 * t * t + 0.984375
            end
        end,
        InOut = function(t)
            return t < 0.5
                and (1 - EasingFunctions.Bounce.Out(1 - 2 * t)) / 2
                or (1 + EasingFunctions.Bounce.Out(2 * t - 1)) / 2
        end
    },
    Elastic = {
        In = function(t)
            local c4 = (2 * math.pi) / 3
            return t == 0 and 0 or t == 1 and 1 or -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * c4)
        end,
        Out = function(t)
            local c4 = (2 * math.pi) / 3
            return t == 0 and 0 or t == 1 and 1 or math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
        end,
        InOut = function(t)
            local c5 = (2 * math.pi) / 4.5
            return t == 0 and 0 or t == 1 and 1 or t < 0.5
                and -(math.pow(2, 20 * t - 10) * math.sin((20 * t - 11.125) * c5)) / 2
                or (math.pow(2, -20 * t + 10) * math.sin((20 * t - 11.125) * c5)) / 2 + 1
        end
    }
}

local Enum = {
    EasingStyle = {
        Linear = "Linear",
        Sine = "Sine",
        Quad = "Quad",
        Cubic = "Cubic",
        Quart = "Quart",
        Quint = "Quint",
        Exponential = "Exponential",
        Back = "Back",
        Bounce = "Bounce",
        Elastic = "Elastic"
    },
    EasingDirection = {
        In = "In",
        Out = "Out",
        InOut = "InOut"
    }
}

local TweenInfo = {}
TweenInfo.__index = TweenInfo

function TweenInfo.new(Time, EasingStyle, EasingDirection, RepeatCount, Reverses, DelayTime)
    local self = setmetatable({}, TweenInfo)
    self.Time = Time or 1
    self.EasingStyle = EasingStyle or Enum.EasingStyle.Quad
    self.EasingDirection = EasingDirection or Enum.EasingDirection.Out
    self.RepeatCount = RepeatCount or 0
    self.Reverses = Reverses or false
    self.DelayTime = DelayTime or 0
    return self
end

local Tween = {}
Tween.__index = Tween

function Tween.new(Instance, TweenInfo, Properties)
    local self = setmetatable({}, Tween)
    
    self.Instance = Instance
    self.TweenInfo = TweenInfo
    self.Properties = Properties
    self.PlaybackState = "Begin"
    
    self.InitialValues = {}
    for PropertyName, _ in pairs(Properties) do
        local Success, Value = pcall(function() return Instance[PropertyName] end)
        if Success then
            self.InitialValues[PropertyName] = Value
        end
    end
    
    self.StartTime = 0
    self.CurrentRepeat = 0
    self.IsReversed = false
    
    self.Completed = Signal.new()
    
    return self
end

function Tween:Play()
    if self.PlaybackState == "Playing" then return end
    
    self.PlaybackState = "Playing"
    self.StartTime = os.clock()
    
    table.insert(TweenService.ActiveTweens, self)
end

function Tween:Pause()
    if self.PlaybackState ~= "Playing" then return end
    self.PlaybackState = "Paused"
end

function Tween:Cancel()
    self.PlaybackState = "Cancelled"
    
    for Index, CurrentTween in ipairs(TweenService.ActiveTweens) do
        if CurrentTween == self then
            table.remove(TweenService.ActiveTweens, Index)
            break
        end
    end
end

function Tween:Destroy()
    self:Cancel()
    self.Completed:fire("Cancelled")
end

function Tween:UpdateInternal(CurrentTime)
    if self.PlaybackState ~= "Playing" then return end
    
    local Elapsed = CurrentTime - self.StartTime - self.TweenInfo.DelayTime
    
    if Elapsed < 0 then return end
    
    local Duration = self.TweenInfo.Time
    local Alpha = math.clamp(Elapsed / Duration, 0, 1)
    
    local EasingFunc = EasingFunctions[self.TweenInfo.EasingStyle][self.TweenInfo.EasingDirection]
    local EasedAlpha = EasingFunc(Alpha)
    
    if self.IsReversed then
        EasedAlpha = 1 - EasedAlpha
    end
    
    for PropertyName, TargetValue in pairs(self.Properties) do
        local InitialValue = self.InitialValues[PropertyName]
        
        if InitialValue then
            local NewValue = self:InterpolateValue(InitialValue, TargetValue, EasedAlpha)
            
            if NewValue then
                pcall(function() self.Instance[PropertyName] = NewValue end)
            end
        end
    end
    
    if Alpha >= 1 then
        self:HandleCycleComplete()
    end
end

function Tween:InterpolateValue(Initial, Target, Alpha)
    if type(Initial) == "number" then
        return Initial + (Target - Initial) * Alpha
    elseif type(Initial) == "userdata" then
        if tostring(Initial):match("^vector") then
            return vector.create(
                Initial.x + (Target.x - Initial.x) * Alpha,
                Initial.y + (Target.y - Initial.y) * Alpha,
                Initial.z + (Target.z - Initial.z) * Alpha
            )
        end
    elseif type(Initial) == "table" and Initial.Position then
        return {
            Position = vector.create(
                Initial.Position.x + (Target.Position.x - Initial.Position.x) * Alpha,
                Initial.Position.y + (Target.Position.y - Initial.Position.y) * Alpha,
                Initial.Position.z + (Target.Position.z - Initial.Position.z) * Alpha
            )
        }
    end
    
    return nil
end

function Tween:HandleCycleComplete()
    if self.TweenInfo.Reverses then
        self.IsReversed = not self.IsReversed
        self.StartTime = os.clock()
        
        if not self.IsReversed then
            self.CurrentRepeat = self.CurrentRepeat + 1
        end
    else
        self.CurrentRepeat = self.CurrentRepeat + 1
    end
    
    if self.CurrentRepeat > self.TweenInfo.RepeatCount and self.TweenInfo.RepeatCount >= 0 then
        self.PlaybackState = "Completed"
        self.Completed:fire("Completed")
        
        for Index, CurrentTween in ipairs(TweenService.ActiveTweens) do
            if CurrentTween == self then
                table.remove(TweenService.ActiveTweens, Index)
                break
            end
        end
    else
        self.StartTime = os.clock()
    end
end

TweenService.ActiveTweens = {}

function TweenService:Create(Instance, TweenInfo, Properties)
    return Tween.new(Instance, TweenInfo, Properties)
end

RunService.Render:Connect(function()
    local CurrentTime = os.clock()
    
    for Index = #TweenService.ActiveTweens, 1, -1 do
        local CurrentTween = TweenService.ActiveTweens[Index]
        CurrentTween:UpdateInternal(CurrentTime)
    end
end)

return {
    TweenService = TweenService,
    TweenInfo = TweenInfo,
    Enum = Enum
}
