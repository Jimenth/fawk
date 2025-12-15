--! optimization 2
loadstring(game: HttpGet("https://raw.githubusercontent.com/Sploiter13/severefuncs/refs/heads/main/merge.lua"))();
local Load = luau.load(game: HttpGet("https://raw.githubusercontent.com/DCHARLESAKAMRGREEN/Severe-Luas/main/Libraries/Pseudosynonym.lua"))
local Version = "1.0.0"

local Offsets = {
    TextLabelText = 3648
}

local Workspace = game:GetService("Workspace")
local Tycoons = Workspace.  Tycoon.  Tycoons
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = Load()
local Window = Library:  CreateWindow({
    Title = "War Tycoon | " .. Version,
    Tag = LocalPlayer.DisplayName,
    Keybind = "Alt",
    AutoShow = true
})

-- // Assistants Tab \\ --
local AssistantsTab = Window:AddTab({ Name = "Assistants" })
local AssistantsContainer = AssistantsTab:AddContainer({ Name = "Assistants", Side = "Left", AutoSize = true })
local MainAssistants = AssistantsContainer:AddTab("Main")
local CollectCash = MainAssistants:  AddToggle({ Name = "Loop Collect Cash", Value = false, Tooltip = "Automatically Collect Cash" })
local CompleteTycoon = MainAssistants:  AddToggle({ Name = "Loop Complete Tycoon", Value = false, Tooltip = "Automatically Complete Tycoon" })

-- // Settings Tab \\ --
local SettingsTab = Window:  AddTab({ Name = "Settings" })
local MenuContainer = SettingsTab:AddContainer({ Name = "Menu", Side = "Left", AutoSize = true })
MenuContainer:AddMenuBind({})
MenuContainer:AddSeparator()
MenuContainer:AddWatermark({ Watermark = "Hello Croski", ShowFPS = true })
MenuContainer:AddKeybindList({})
MenuContainer:AddButton({ Name = "Unload", Unsafe = true, Callback = function() Library:Unload() end })

local function GetCompletion()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return 0 end

    local HUD = PlayerGui.UI.Container.HUD.Menu.HUD

    local Left = HUD:FindFirstChild("Left")
    if not Left then return 0 end

    local Completion = Left:FindFirstChild("TycoonCompletion")
    if not Completion then return 0 end
    
    local Bar = Completion:FindFirstChild("Bar")
    if not Bar then return end

    local Progress = Bar:FindFirstChild("BarProgressAmount")
    if not Progress then return end

    local RealAmount = 0
    local Percentage = tostring(memory.readstring(Progress, Offsets.TextLabelText))
    if Progress then RealAmount = tonumber(Percentage:match("(%d+%.?%d*)")) end

    return RealAmount or 0
end

local function GetCash()
    local Stats = LocalPlayer:FindFirstChild("leaderstats")
    if not Stats then return 0 end

    local Cash = Stats:FindFirstChild("Cash")
    if not Cash then return 0 end

    return Cash.Value or 0
end

local function GetRebirths()
    local Stats = LocalPlayer:FindFirstChild("leaderstats")
    if not Stats then return 0 end

    local Rebirths = Stats:FindFirstChild("Rebirths")
    if not Rebirths then return 0 end

    return Rebirths.Value or 0
end

local function GetPlot()
    for Index, Plot in ipairs(Tycoons:GetChildren()) do
        local Owner = Plot: GetAttribute("Owner")
        if Owner and Owner == LocalPlayer. Name then
            return Plot
        end
    end
    return nil
end

local function SetPosition(Object, Target)
    Object.Position = Target + vector.create(0.2, 0.2, 0.2)
end

local function AutoCollect()
    local Character = LocalPlayer.Character
    if not Character then return end

    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    local Plot = GetPlot()
    if not Plot then return end

    local Collector = Plot:FindFirstChild("Essentials") and Plot.Essentials:FindFirstChild("CollectorParts")

    local Object = Collector and Collector:FindFirstChild("Display")
    if Object then
        SetPosition(HRP, Object.Position + vector.create(0, 0, -3))
    end
end

local function AutoComplete()
    if not CompleteTycoon.Value then return end

    local Character = LocalPlayer.Character
    if not Character then return end

    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    local Plot = GetPlot()
    if not Plot then return end

    local Items = Plot:FindFirstChild("UnpurchasedButtons")
    if not Items then return end

    local RebirthButtons = {}
    local OilButtons = {}
    local CashButtons = {}

    for _, Item in ipairs(Items:GetChildren()) do
        local ButtonType = Item:GetAttribute("ButtonType")
        local name = Item.Name or ""
        if ButtonType == "Rebirth" then
            local Requirement = tonumber(Item:GetAttribute("RebirthRequirement"))
            local Primary = Item:FindFirstChild("Gradient")
            if Requirement and Primary then
                if GetRebirths() >= Requirement then
                    RebirthButtons[#RebirthButtons + 1] = {
                        Pad = Primary,
                        Req = Requirement
                    }
                end
            end
        elseif ButtonType == "Cash" then
            local Price = tonumber(Item:GetAttribute("Price"))
            local Primary = Item:FindFirstChild("Gradient")
            if Price and Primary then
                if name:sub(1, 3) == "Oil" then
                    OilButtons[#OilButtons + 1] = {
                        Pad = Primary,
                        Price = Price
                    }
                else
                    CashButtons[#CashButtons + 1] = {
                        Pad = Primary,
                        Price = Price
                    }
                end
            end
        end
    end

    if #RebirthButtons > 0 then
        table.sort(RebirthButtons, function(a, b) return a.Req < b.Req end)
        local Target = RebirthButtons[1]
        SetPosition(HRP, Target.Pad.Position)
        return
    end

    if #OilButtons > 0 then
        table.sort(OilButtons, function(a, b) return a.Price < b.Price end)
        local Target = OilButtons[1]
        if GetCash() < Target.Price then
            AutoCollect()
            return
        end
        SetPosition(HRP, Target.Pad.Position)
        return
    end

    table.sort(CashButtons, function(a, b)
        return a.Price < b.Price
    end)

    if #CashButtons == 0 then return end

    local CheapestButton = CashButtons[1]

    if GetCash() < CheapestButton.Price then
        AutoCollect()
        return
    end

    SetPosition(HRP, CheapestButton.Pad.Position)
end

task.spawn(function()
    while true do
        if CollectCash. Value then
            AutoCollect()
        end
        task.wait(0.4)
    end
end)

task.spawn(function()
    while true do
        if CompleteTycoon. Value then
            AutoComplete()
            task.wait(0.5)
        end
        task.wait(0.4)
    end
end)

GetCompletion()
