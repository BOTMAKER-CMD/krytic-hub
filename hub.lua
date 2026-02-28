-- KRYTIC HUB FREE v1.5 | Blox Fruits 2nd/3rd Sea (Lv700+) | Anti-Leak Protected
-- Pirate = ALL Kill | Marine = Pirates Only | Live Ping/Factions/Sea | Auto Hop | Cool Load
copyright krytic services ltd.2026

local OFFICIAL_RAW_URL = "https://raw.githubusercontent.com/BOTMAKER-CMD/krytic-hub/main/hub.lua" 

local http = game:GetService("HttpService")
local success, sourceCode = pcall(function()
    return http:GetAsync(OFFICIAL_RAW_URL)
end)

if not success or not sourceCode:find("KRYTIC HUB FREE v1.5") or not sourceCode:find("-- Official Source Only") then
    game.Players.LocalPlayer:Kick("Anti-Leak Triggered\nLeaked / Tampered / Renamed script detected\nUse official link only: github.com/YOUR_USERNAME/krytic-hub")
    return
end


local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Junk Obfuscation
local _krytic = math.random(1337, 6969)

-- Config
local Config = { AutoHunt = false, StatsEnabled = false, AutoServerHop = false, PingThreshold = 350 }
local GrindedAmount = 0
local StartGrindVal = 0
local PiratesCount = 0
local MarinesCount = 0
local CurrentPing = 0

-- Tween Infos
local tpTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local loadInfo = TweenInfo.new(2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local hoverInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tabSwitchInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local fadeInInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Skills
local Skills = {"Z", "X", "C", "V"}

-- Get Grind Stat
local function GetGrindStat()
    local ls = LocalPlayer:FindFirstChild("Leaderstats")
    if ls then
        if ls:FindFirstChild("Bounty") then return ls.Bounty end
        if ls:FindFirstChild("Honor") then return ls.Honor end
    end
    return nil
end

local stat = GetGrindStat()
StartGrindVal = stat and stat.Value or 0

-- Count Factions
local function CountFactions()
    local p, m = 0, 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Faction") then
            if plr.Data.Faction.Value == "Pirates" then p = p + 1 else m = m + 1 end
        end
    end
    return p, m
end

-- Server Hop
local function ServerHop()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

-- Nearest Target
local function GetNearestTarget()
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    if not myPos then return nil end
    local myFaction = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Faction") and LocalPlayer.Data.Faction.Value
    local nearest, minDist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local tFaction = plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Faction") and plr.Data.Faction.Value
            local isValid = (myFaction == "Pirates") or (myFaction == "Marines" and tFaction == "Pirates")
            if isValid then
                local dist = (plr.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < minDist and dist < 3000 and plr.Character.HumanoidRootPart.Velocity.Magnitude < 100 then
                    minDist = dist
                    nearest = plr
                end
            end
        end
    end
    return nearest
end

-- Safe TP
local function SafeTP(targetPos)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local offset = Vector3.new(math.random(-6,6)/10, math.random(2,5)/10, math.random(-15,-3)/10 * (math.random() > 0.5 and 1 or -1))
    local tween = TweenService:Create(root, tpTweenInfo, {CFrame = CFrame.new(targetPos + offset)})
    tween:Play()
    tween.Completed:Wait()
end

-- Attack
local function Attack()
    VirtualInputManager:SendMouseButtonEvent(math.random(1,10), math.random(1,10), 0, true, game, 1)
    task.wait(math.random(5,15)/100)
    VirtualInputManager:SendMouseButtonEvent(math.random(1,10), math.random(1,10), 0, false, game, 1)

    for i = 1, math.random(2,4) do
        local skill = Skills[math.random(1, #Skills)]
        local hold = math.random(15,40)/100
        VirtualInputManager:SendKeyEvent(true, skill, false, game)
        task.wait(hold)
        VirtualInputManager:SendKeyEvent(false, skill, false, game)
        task.wait(math.random(20,50)/100)
    end
end

-- Cool Loading Screen
local function ShowLoadingScreen()
    local LoadGui = Instance.new("ScreenGui")
    LoadGui.Name = "KryticLoad"
    LoadGui.Parent = game.CoreGui

    local LoadFrame = Instance.new("Frame", LoadGui)
    LoadFrame.Size = UDim2.new(0.5, 0, 0.4, 0)
    LoadFrame.Position = UDim2.new(0.25, 0, 0.3, 0)
    LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    LoadFrame.BorderSizePixel = 0

    local lCorner = Instance.new("UICorner", LoadFrame); lCorner.CornerRadius = UDim.new(0, 20)
    local lGrad = Instance.new("UIGradient", LoadFrame)
    lGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30,0,50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,0,30))}
    lGrad.Rotation = 45

    local LoadTitle = Instance.new("TextLabel", LoadFrame)
    LoadTitle.Size = UDim2.new(1, 0, 0.4, 0)
    LoadTitle.Position = UDim2.new(0, 0, 0.1, 0)
    LoadTitle.Text = "KRYTIC HUB"
    LoadTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
    LoadTitle.BackgroundTransparency = 1
    LoadTitle.Font = Enum.Font.GothamBlack
    LoadTitle.TextScaled = true

    local Spinner = Instance.new("Frame", LoadFrame)
    Spinner.Size = UDim2.new(0.15, 0, 0.15, 0)
    Spinner.Position = UDim2.new(0.425, 0, 0.55, 0)
    Spinner.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Spinner.BorderSizePixel = 0

    local sCorner = Instance.new("UICorner", Spinner); sCorner.CornerRadius = UDim.new(1, 0)

    local Progress = Instance.new("Frame", LoadFrame)
    Progress.Size = UDim2.new(0.8, 0, 0.05, 0)
    Progress.Position = UDim2.new(0.1, 0, 0.8, 0)
    Progress.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Progress.BorderSizePixel = 0

    local pCorner = Instance.new("UICorner", Progress); pCorner.CornerRadius = UDim.new(0, 5)
    local pFill = Instance.new("Frame", Progress)
    pFill.Size = UDim2.new(0, 0, 1, 0)
    pFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    pFill.BorderSizePixel = 0
    local pfCorner = Instance.new("UICorner", pFill); pfCorner.CornerRadius = UDim.new(0, 5)

    LoadFrame.BackgroundTransparency = 1
    TweenService:Create(LoadFrame, loadInfo, {BackgroundTransparency = 0}):Play()
    local spinTween = TweenService:Create(Spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    spinTween:Play()
    local progTween = TweenService:Create(pFill, TweenInfo.new(2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)})
    progTween:Play()

    task.wait(2.5)
    LoadGui:Destroy()
end

-- Main UI
local function LoadMainUI()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "KryticHub"
    MainGui.Parent = game.CoreGui
    MainGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.45, 0, 0.65, 0)
    MainFrame.Position = UDim2.new(0.275, 0, 0.175, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGui

    local mCorner = Instance.new("UICorner", MainFrame); mCorner.CornerRadius = UDim.new(0, 16)
    local mGrad = Instance.new("UIGradient", MainFrame)
    mGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,20))}
    mGrad.Rotation = 45

    local mStroke = Instance.new("UIStroke", MainFrame)
    mStroke.Color = Color3.fromRGB(0, 255, 150)
    mStroke.Thickness = 2
    mStroke.Transparency = 0.4

    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Size = UDim2.new(1, 0, 0.08, 0)
    TitleBar.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel", TitleBar)
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "KRYTIC HUB"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBlack

    -- Draggable (supports touch for Delta)
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Tabs
    local tabs = {"Profile", "Config", "Premium", "About"}
    local tabFrames = {}
    for i, tabName in ipairs(tabs) do
        local TabButton = Instance.new("TextButton", MainFrame)
        TabButton.Size = UDim2.new(0.25, 0, 0.08, 0)
        TabButton.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextScaled = true

        local btnCorner = Instance.new("UICorner", TabButton); btnCorner.CornerRadius = UDim.new(0, 8)

        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, hoverInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
        end)
        TabButton.MouseLeave:Connect(function()
            TweenService:Create(TabButton, hoverInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        end)

        local TabFrame = Instance.new("Frame", MainFrame)
        TabFrame.Size = UDim2.new(1, 0, 0.92, 0)
        TabFrame.Position = UDim2.new(0, 0, 0.08, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        tabFrames[tabName] = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(tabFrames) do
                frame.Visible = false
            end
            TabFrame.Visible = true
        end)
    end

    -- Profile Label
    local ProfileLabel = Instance.new("TextLabel", tabFrames["Profile"])
    ProfileLabel.Size = UDim2.new(1, 0, 1, 0)
    ProfileLabel.BackgroundTransparency = 1
    ProfileLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ProfileLabel.TextScaled = true
    ProfileLabel.TextXAlignment = Enum.TextXAlignment.Left
    ProfileLabel.TextYAlignment = Enum.TextYAlignment.Top
    ProfileLabel.TextWrapped = true
    ProfileLabel.Text = "Loading Krytic Hub..."

    -- Config Toggles
    local StatsToggle = Instance.new("TextButton", tabFrames["Config"])
    StatsToggle.Size = UDim2.new(0.8, 0, 0.12, 0)
    StatsToggle.Position = UDim2.new(0.1, 0, 0.1, 0)
    StatsToggle.Text = "Enable Stats: OFF (REQUIRED!)"
    StatsToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    StatsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatsToggle.Font = Enum.Font.GothamBold
    StatsToggle.TextScaled = true

    local sCorner = Instance.new("UICorner", StatsToggle); sCorner.CornerRadius = UDim.new(0, 10)

    StatsToggle.MouseButton1Click:Connect(function()
        Config.StatsEnabled = not Config.StatsEnabled
        StatsToggle.Text = "Enable Stats: " .. (Config.StatsEnabled and "ON" or "OFF (REQUIRED!)")
        StatsToggle.BackgroundColor3 = Config.StatsEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 50, 50)
    end)

    local HuntToggle = Instance.new("TextButton", tabFrames["Config"])
    HuntToggle.Size = UDim2.new(0.8, 0, 0.12, 0)
    HuntToggle.Position = UDim2.new(0.1, 0, 0.3, 0)
    HuntToggle.Text = "Auto Hunt: OFF"
    HuntToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    HuntToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HuntToggle.Font = Enum.Font.GothamBold
    HuntToggle.TextScaled = true

    local hCorner = Instance.new("UICorner", HuntToggle); hCorner.CornerRadius = UDim.new(0, 10)

    HuntToggle.MouseButton1Click:Connect(function()
        Config.AutoHunt = not Config.AutoHunt
        HuntToggle.Text = "Auto Hunt: " .. (Config.AutoHunt and "ON" or "OFF")
        HuntToggle.BackgroundColor3 = Config.AutoHunt and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(50, 50, 60)
    end)

    local HopToggle = Instance.new("TextButton", tabFrames["Config"])
    HopToggle.Size = UDim2.new(0.8, 0, 0.12, 0)
    HopToggle.Position = UDim2.new(0.1, 0, 0.5, 0)
    HopToggle.Text = "Auto Server Hop: OFF"
    HopToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    HopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HopToggle.Font = Enum.Font.GothamBold
    HopToggle.TextScaled = true

    local hopCorner = Instance.new("UICorner", HopToggle); hopCorner.CornerRadius = UDim.new(0, 10)

    HopToggle.MouseButton1Click:Connect(function()
        Config.AutoServerHop = not Config.AutoServerHop
        HopToggle.Text = "Auto Server Hop: " .. (Config.AutoServerHop and "ON" or "OFF")
        HopToggle.BackgroundColor3 = Config.AutoServerHop and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(50, 50, 60)
    end)

    -- Premium Tab
    local PremiumLabel = Instance.new("TextLabel", tabFrames["Premium"])
    PremiumLabel.Size = UDim2.new(1, 0, 1, 0)
    PremiumLabel.BackgroundTransparency = 1
    PremiumLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    PremiumLabel.TextScaled = true
    PremiumLabel.Text = "KRYTIC PREMIUM\nComing Soon!\n\n• Faster Hunt\n• Better TP\n• Rainbow Glow\n• Exclusive Features\n\nStay tuned @ kryticservices.com"

    -- About Tab
    local AboutLabel = Instance.new("TextLabel", tabFrames["About"])
    AboutLabel.Size = UDim2.new(1, 0, 1, 0)
    AboutLabel.BackgroundTransparency = 1
    AboutLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
    AboutLabel.TextScaled = true
    AboutLabel.Text = "KRYTIC HUB FREE v1.5\nBlox Fruits 2nd/3rd Sea Grind\nPirate: Kill All | Marine: Kill Pirates\nAuto Hop on Low Players\nLive Ping & Faction Count\nDelta Compatible\nOfficial GitHub: github.com/YOUR_USERNAME/krytic-hub"

    -- Fade In
    MainFrame.BackgroundTransparency = 1
    MainFrame.Visible = true
    TweenService:Create(MainFrame, fadeInInfo, {BackgroundTransparency = 0}):Play()

    tabFrames["Profile"].Visible = true
    TweenService:Create(tabFrames["Profile"], fadeInInfo, {BackgroundTransparency = 0}):Play()

    -- Update Profile
    local function UpdateProfile()
        local current = GetGrindStat() and GetGrindStat().Value or 0
        GrindedAmount = current - StartGrindVal
        PiratesCount, MarinesCount = CountFactions()
        CurrentPing = LocalPlayer:GetNetworkPing() * 1000

        local pingColor = CurrentPing < 150 and "🟢" or CurrentPing < 300 and "🟡" or "🔴"
        local level = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") and LocalPlayer.Data.Level.Value or 0
        local sea = level < 700 and "1st Sea (Low Lv)" or level < 1500 and "2nd Sea" or "3rd Sea"

        ProfileLabel.Text = string.format([[
User: %s

Grinded: %d
Current: %d

Faction: %s
Sea: %s
Players: Pirates %d | Marines %d

Ping: %dms %s
Auto Hunt: %s | Hop: %s
        ]],
        LocalPlayer.Name,
        GrindedAmount,
        current,
        LocalPlayer.Data and LocalPlayer.Data.Faction.Value or "Unknown",
        sea,
        PiratesCount,
        MarinesCount,
        math.floor(CurrentPing),
        pingColor,
        Config.AutoHunt and "ON" or "OFF",
        Config.AutoServerHop and "ON" or "OFF"
        )
    end

    -- Heartbeat Loop
    local hopTimer = 0
    RunService.Heartbeat:Connect(function()
        UpdateProfile()

        if CurrentPing > Config.PingThreshold then
            LocalPlayer:Kick("KRYTIC: High Ping (" .. math.floor(CurrentPing) .. "ms) - Rejoin Safe")
            return
        end

        hopTimer = hopTimer + 1
        if hopTimer >= 1800 and Config.AutoServerHop then
            hopTimer = 0
            local pirates, marines = CountFactions()
            local myFaction = LocalPlayer.Data and LocalPlayer.Data.Faction.Value
            local low = (myFaction == "Pirates" and (pirates + marines < 5)) or (myFaction == "Marines" and pirates < 3)
            if low then ServerHop() end
        end

        local level = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") and LocalPlayer.Data.Level.Value or 0
        if Config.AutoHunt and Config.StatsEnabled and level >= 700 then
            pcall(function()
                local target = GetNearestTarget()
                if target then
                    SafeTP(target.Character.HumanoidRootPart.Position)
                    task.wait(math.random(50,150)/1000)
                    Attack()
                end
            end)
        end
    end)
end

-- Start
ShowLoadingScreen()
task.wait(2.6)
LoadMainUI()
