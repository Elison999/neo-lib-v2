-- ╔══════════════════════════════════════════════════════════╗
-- ║              NEON LIB V2 - Ultra Modern UI               ║
-- ║         by Elison999 | github.com/Elison999             ║
-- ╚══════════════════════════════════════════════════════════╝

local NeonLib = {}
NeonLib.__index = NeonLib

-- ══════════════════════════════════════════
--            SERVICES
-- ══════════════════════════════════════════
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService     = game:GetService("HttpService")
local CoreGui         = game:GetService("CoreGui")
local StarterGui      = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════════════
--            UTILITY FUNCTIONS
-- ══════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(t or 0.3, style, dir), props)
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging   = true
            dragStart  = input.Position
            startPos   = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function HSV(h,s,v) return Color3.fromHSV(h,s,v) end

local function WriteFile(path, data)
    if writefile then writefile(path, data) end
end

local function ReadFile(path)
    if readfile and isfile and isfile(path) then
        return readfile(path)
    end
    return nil
end

local function ListFiles(folder)
    if listfiles and isfolder and isfolder(folder) then
        return listfiles(folder)
    end
    return {}
end

local function MakeFolders()
    if makefolder then
        if not isfolder("NeonLib") then makefolder("NeonLib") end
        if not isfolder("NeonLib/Saves") then makefolder("NeonLib/Saves") end
    end
end

-- ══════════════════════════════════════════
--            THEMES  (20 temas)
-- ══════════════════════════════════════════
local Themes = {
    ["Neon Purple"]  = { Accent = Color3.fromRGB(138,  43, 226), Bg = Color3.fromRGB(15, 10, 25),  Tab = Color3.fromRGB(22, 14, 38),  Element = Color3.fromRGB(30, 20, 50),  Text = Color3.fromRGB(220,210,255) },
    ["Neon Blue"]    = { Accent = Color3.fromRGB( 30, 144, 255), Bg = Color3.fromRGB( 8, 12, 25),  Tab = Color3.fromRGB(12, 18, 38),  Element = Color3.fromRGB(16, 24, 50),  Text = Color3.fromRGB(200,220,255) },
    ["Neon Green"]   = { Accent = Color3.fromRGB( 57, 255, 120), Bg = Color3.fromRGB( 8, 18, 12),  Tab = Color3.fromRGB(10, 26, 16),  Element = Color3.fromRGB(12, 34, 20),  Text = Color3.fromRGB(200,255,220) },
    ["Neon Pink"]    = { Accent = Color3.fromRGB(255,  20, 147), Bg = Color3.fromRGB(25,  8, 18),  Tab = Color3.fromRGB(36, 10, 26),  Element = Color3.fromRGB(48, 12, 34),  Text = Color3.fromRGB(255,200,230) },
    ["Neon Orange"]  = { Accent = Color3.fromRGB(255, 120,  30), Bg = Color3.fromRGB(22, 12,  6),  Tab = Color3.fromRGB(32, 16,  8),  Element = Color3.fromRGB(42, 22, 10),  Text = Color3.fromRGB(255,230,200) },
    ["Neon Cyan"]    = { Accent = Color3.fromRGB(  0, 255, 255), Bg = Color3.fromRGB( 6, 20, 22),  Tab = Color3.fromRGB( 8, 28, 32),  Element = Color3.fromRGB(10, 36, 42),  Text = Color3.fromRGB(200,255,255) },
    ["Neon Red"]     = { Accent = Color3.fromRGB(255,  50,  50), Bg = Color3.fromRGB(22,  8,  8),  Tab = Color3.fromRGB(32, 10, 10),  Element = Color3.fromRGB(42, 12, 12),  Text = Color3.fromRGB(255,200,200) },
    ["Neon Yellow"]  = { Accent = Color3.fromRGB(255, 240,   0), Bg = Color3.fromRGB(20, 18,  6),  Tab = Color3.fromRGB(28, 26,  8),  Element = Color3.fromRGB(36, 34, 10),  Text = Color3.fromRGB(255,255,200) },
    ["Dark Slate"]   = { Accent = Color3.fromRGB(100, 149, 237), Bg = Color3.fromRGB(12, 14, 18),  Tab = Color3.fromRGB(18, 20, 26),  Element = Color3.fromRGB(24, 28, 36),  Text = Color3.fromRGB(210,215,230) },
    ["Midnight"]     = { Accent = Color3.fromRGB( 80,  80, 200), Bg = Color3.fromRGB( 8,  8, 15),  Tab = Color3.fromRGB(12, 12, 22),  Element = Color3.fromRGB(16, 16, 30),  Text = Color3.fromRGB(180,180,240) },
    ["Rose Gold"]    = { Accent = Color3.fromRGB(255, 180, 150), Bg = Color3.fromRGB(22, 14, 12),  Tab = Color3.fromRGB(32, 20, 16),  Element = Color3.fromRGB(42, 26, 20),  Text = Color3.fromRGB(255,220,210) },
    ["Arctic"]       = { Accent = Color3.fromRGB(150, 220, 255), Bg = Color3.fromRGB(12, 18, 22),  Tab = Color3.fromRGB(16, 24, 30),  Element = Color3.fromRGB(20, 30, 38),  Text = Color3.fromRGB(200,235,255) },
    ["Forest"]       = { Accent = Color3.fromRGB( 80, 200, 100), Bg = Color3.fromRGB(10, 16, 10),  Tab = Color3.fromRGB(14, 22, 14),  Element = Color3.fromRGB(18, 28, 18),  Text = Color3.fromRGB(200,240,200) },
    ["Ember"]        = { Accent = Color3.fromRGB(255, 100,  30), Bg = Color3.fromRGB(18, 10,  6),  Tab = Color3.fromRGB(26, 14,  8),  Element = Color3.fromRGB(34, 18, 10),  Text = Color3.fromRGB(255,210,180) },
    ["Lavender"]     = { Accent = Color3.fromRGB(180, 130, 255), Bg = Color3.fromRGB(16, 12, 22),  Tab = Color3.fromRGB(22, 16, 32),  Element = Color3.fromRGB(28, 20, 42),  Text = Color3.fromRGB(220,200,255) },
    ["Sakura"]       = { Accent = Color3.fromRGB(255, 160, 190), Bg = Color3.fromRGB(22, 12, 16),  Tab = Color3.fromRGB(32, 16, 22),  Element = Color3.fromRGB(42, 20, 28),  Text = Color3.fromRGB(255,210,225) },
    ["Cobalt"]       = { Accent = Color3.fromRGB( 30,  80, 200), Bg = Color3.fromRGB( 8, 10, 20),  Tab = Color3.fromRGB(10, 14, 28),  Element = Color3.fromRGB(12, 18, 36),  Text = Color3.fromRGB(180,200,255) },
    ["Gold Rush"]    = { Accent = Color3.fromRGB(255, 200,  50), Bg = Color3.fromRGB(18, 14,  6),  Tab = Color3.fromRGB(26, 20,  8),  Element = Color3.fromRGB(34, 26, 10),  Text = Color3.fromRGB(255,240,180) },
    ["Matrix"]       = { Accent = Color3.fromRGB(  0, 255, 100), Bg = Color3.fromRGB( 4, 10,  4),  Tab = Color3.fromRGB( 6, 14,  6),  Element = Color3.fromRGB( 8, 18,  8),  Text = Color3.fromRGB(180,255,180) },
    ["White Mist"]   = { Accent = Color3.fromRGB(120, 170, 255), Bg = Color3.fromRGB(230,232,240), Tab = Color3.fromRGB(215,218,230), Element = Color3.fromRGB(200,204,220), Text = Color3.fromRGB( 30, 30, 60) },
}

local ThemeList = {}
for k in pairs(Themes) do table.insert(ThemeList, k) end
table.sort(ThemeList)

-- ══════════════════════════════════════════
--          MAIN LIBRARY  CREATE
-- ══════════════════════════════════════════
function NeonLib:CreateWindow(config)
    config = config or {}

    -- Config defaults
    local windowTitle    = config.Title         or "NeonLib"
    local windowSize     = config.Size          or UDim2.new(0, 427, 0, 307)
    local defaultTheme   = config.Theme         or "Neon Purple"
    local KeySystem      = config.KeySystem     or false
    local KeyName        = config.KeyName       or "Key System"
    local Key            = config.Key           or "DEFAULT_KEY"
    local AutoSaveKey    = config.AutoSaveKey   ~= false
    local AutoLoadKey    = config.AutoLoadKey   ~= false
    local GetKeyByWebsite= config.GetKeybyWebsite or false
    local WebSite        = config.WebSite       or ""
    local DecalId        = config.DecalId       or "rbxassetid://0"
    local LoadingName    = config.LoadingName   or "Welcome!"

    if not tostring(DecalId):find("rbxassetid://") then
        DecalId = "rbxassetid://" .. tostring(DecalId)
    end

    MakeFolders()

    local currentTheme = Themes[defaultTheme] or Themes["Neon Purple"]
    local WindowObj    = { Tabs = {}, Elements = {}, _transparent = false }
    local activeTab    = nil

    -- ════════════════════════════════
    --   SCREEN GUI
    -- ════════════════════════════════
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name             = "NeonLib_" .. windowTitle
    ScreenGui.ResetOnSpawn     = false
    ScreenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset   = true
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ════════════════════════════════
    --   HELPER: APPLY THEME
    -- ════════════════════════════════
    local applyThemeFns = {}
    local function onTheme(fn) table.insert(applyThemeFns, fn) end
    local function applyTheme()
        for _, fn in ipairs(applyThemeFns) do
            pcall(fn, currentTheme)
        end
    end

    -- ════════════════════════════════
    --   LOADING SCREEN
    -- ════════════════════════════════
    local LoadFrame = Instance.new("Frame")
    LoadFrame.Name            = "LoadScreen"
    LoadFrame.Size            = UDim2.new(1, 0, 1, 0)
    LoadFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
    LoadFrame.ZIndex          = 100
    LoadFrame.Parent          = ScreenGui

    local LoadImg = Instance.new("ImageLabel")
    LoadImg.Size              = UDim2.new(0, 80, 0, 80)
    LoadImg.AnchorPoint       = Vector2.new(0.5, 0.5)
    LoadImg.Position          = UDim2.new(0.5, 0, 0.42, 0)
    LoadImg.BackgroundTransparency = 1
    LoadImg.Image             = DecalId
    LoadImg.ZIndex            = 101
    LoadImg.Parent            = LoadFrame

    local LoadCorner = Instance.new("UICorner")
    LoadCorner.CornerRadius   = UDim.new(0, 12)
    LoadCorner.Parent         = LoadImg

    local LoadTitle = Instance.new("TextLabel")
    LoadTitle.Size            = UDim2.new(0, 267, 0, 27)
    LoadTitle.AnchorPoint     = Vector2.new(0.5, 0.5)
    LoadTitle.Position        = UDim2.new(0.5, 0, 0.58, 0)
    LoadTitle.BackgroundTransparency = 1
    LoadTitle.Text            = LoadingName
    LoadTitle.TextColor3      = Color3.fromRGB(220, 210, 255)
    LoadTitle.TextSize = 17
    LoadTitle.Font            = Enum.Font.GothamBold
    LoadTitle.ZIndex          = 101
    LoadTitle.Parent          = LoadFrame

    local LoadSub = Instance.new("TextLabel")
    LoadSub.Size              = UDim2.new(0, 267, 0, 19)
    LoadSub.AnchorPoint       = Vector2.new(0.5, 0.5)
    LoadSub.Position          = UDim2.new(0.5, 0, 0.64, 0)
    LoadSub.BackgroundTransparency = 1
    LoadSub.Text              = "Loading..."
    LoadSub.TextColor3        = Color3.fromRGB(140, 120, 200)
    LoadSub.TextSize = 11
    LoadSub.Font              = Enum.Font.Gotham
    LoadSub.ZIndex            = 101
    LoadSub.Parent            = LoadFrame

    -- Progress bar
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Size           = UDim2.new(0, 200, 0, 4)
    ProgressBg.AnchorPoint    = Vector2.new(0.5, 0.5)
    ProgressBg.Position       = UDim2.new(0.5, 0, 0.72, 0)
    ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    ProgressBg.ZIndex         = 101
    ProgressBg.Parent         = LoadFrame
    Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1, 0)

    local ProgressFill = Instance.new("Frame")
    ProgressFill.Size         = UDim2.new(0, 0, 1, 0)
    ProgressFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    ProgressFill.ZIndex       = 102
    ProgressFill.Parent       = ProgressBg
    Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

    -- Animate loading bar
    task.spawn(function()
        local grd = Instance.new("UIGradient")
        grd.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(138,43,226)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200,100,255))
        })
        grd.Rotation = 90
        grd.Parent = ProgressFill

        for i = 1, 100 do
            ProgressFill.Size = UDim2.new(i/100, 0, 1, 0)
            if i == 30  then LoadSub.Text = "Initializing UI..."   end
            if i == 60  then LoadSub.Text = "Loading elements..."  end
            if i == 85  then LoadSub.Text = "Almost ready..."      end
            if i == 100 then LoadSub.Text = "Done!"                end
            task.wait(0.018)
        end
        task.wait(0.35)
        Tween(LoadFrame, {BackgroundTransparency = 1}, 0.6):Play()
        for _, v in ipairs(LoadFrame:GetDescendants()) do
            if v:IsA("GuiObject") then
                Tween(v, {BackgroundTransparency = 1}, 0.6):Play()
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    Tween(v, {TextTransparency = 1}, 0.6):Play()
                end
                if v:IsA("ImageLabel") then
                    Tween(v, {ImageTransparency = 1}, 0.6):Play()
                end
            end
        end
        task.wait(0.65)
        LoadFrame:Destroy()
    end)

    -- ════════════════════════════════
    --   KEY SYSTEM
    -- ════════════════════════════════
    local keyPassed = not KeySystem
    local keyFile   = "NeonLib/key_" .. tostring(windowTitle):gsub("%s","_") .. ".txt"

    if KeySystem and AutoLoadKey then
        local saved = ReadFile(keyFile)
        if saved and saved:gsub("%s","") == Key then
            keyPassed = true
        end
    end

    if KeySystem and not keyPassed then
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name             = "KeyFrame"
        KeyFrame.Size             = UDim2.new(0, 267, 0, 187)
        KeyFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
        KeyFrame.Position         = UDim2.new(0.5, 0, 0.5, 0)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
        KeyFrame.ZIndex           = 200
        KeyFrame.Parent           = ScreenGui
        Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 11)

        local KeyStroke = Instance.new("UIStroke", KeyFrame)
        KeyStroke.Color     = Color3.fromRGB(138, 43, 226)
        KeyStroke.Thickness = 1.0

        local KTitle = Instance.new("TextLabel")
        KTitle.Size               = UDim2.new(1, 0, 0, 32)
        KTitle.Position           = UDim2.new(0, 0, 0, 0)
        KTitle.BackgroundTransparency = 1
        KTitle.Text               = "🔑  " .. KeyName
        KTitle.TextColor3         = Color3.fromRGB(220, 210, 255)
        KTitle.TextSize = 13
        KTitle.Font               = Enum.Font.GothamBold
        KTitle.ZIndex             = 201
        KTitle.Parent             = KeyFrame

        local KSub = Instance.new("TextLabel")
        KSub.Size                 = UDim2.new(0.85, 0, 0, 19)
        KSub.AnchorPoint          = Vector2.new(0.5, 0)
        KSub.Position             = UDim2.new(0.5, 0, 0, 35)
        KSub.BackgroundTransparency = 1
        KSub.Text                 = "Enter your access key below"
        KSub.TextColor3           = Color3.fromRGB(140, 120, 180)
        KSub.TextSize = 9
        KSub.Font                 = Enum.Font.Gotham
        KSub.ZIndex               = 201
        KSub.Parent               = KeyFrame

        local KInput = Instance.new("TextBox")
        KInput.Size               = UDim2.new(0.85, 0, 0, 28)
        KInput.AnchorPoint        = Vector2.new(0.5, 0)
        KInput.Position           = UDim2.new(0.5, 0, 0, 64)
        KInput.BackgroundColor3   = Color3.fromRGB(22, 14, 38)
        KInput.Text               = ""
        KInput.PlaceholderText    = "Paste your key here..."
        KInput.TextColor3         = Color3.fromRGB(220, 210, 255)
        KInput.PlaceholderColor3  = Color3.fromRGB(100, 80, 140)
        KInput.TextSize = 10
        KInput.Font               = Enum.Font.Gotham
        KInput.ClearTextOnFocus   = false
        KInput.ZIndex             = 201
        KInput.Parent             = KeyFrame
        Instance.new("UICorner", KInput).CornerRadius = UDim.new(0, 7)
        Instance.new("UIStroke", KInput).Color = Color3.fromRGB(80, 50, 120)
        local kpad = Instance.new("UIPadding", KInput)
        kpad.PaddingLeft = UDim.new(0, 8)

        local KStatus = Instance.new("TextLabel")
        KStatus.Size              = UDim2.new(0.85, 0, 0, 15)
        KStatus.AnchorPoint       = Vector2.new(0.5, 0)
        KStatus.Position          = UDim2.new(0.5, 0, 0, 99)
        KStatus.BackgroundTransparency = 1
        KStatus.Text              = ""
        KStatus.TextColor3        = Color3.fromRGB(255, 80, 80)
        KStatus.TextSize = 9
        KStatus.Font              = Enum.Font.Gotham
        KStatus.ZIndex            = 201
        KStatus.Parent            = KeyFrame

        local KBtn = Instance.new("TextButton")
        KBtn.Size                 = UDim2.new(0.85, 0, 0, 28)
        KBtn.AnchorPoint          = Vector2.new(0.5, 0)
        KBtn.Position             = UDim2.new(0.5, 0, 0, 120)
        KBtn.BackgroundColor3     = Color3.fromRGB(138, 43, 226)
        KBtn.Text                 = "Unlock Access"
        KBtn.TextColor3           = Color3.fromRGB(255, 255, 255)
        KBtn.TextSize = 11
        KBtn.Font                 = Enum.Font.GothamBold
        KBtn.ZIndex               = 201
        KBtn.Parent               = KeyFrame
        Instance.new("UICorner", KBtn).CornerRadius = UDim.new(0, 7)

        if GetKeyByWebsite and WebSite ~= "" then
            local KWeb = Instance.new("TextButton")
            KWeb.Size               = UDim2.new(0.85, 0, 0, 20)
            KWeb.AnchorPoint        = Vector2.new(0.5, 0)
            KWeb.Position           = UDim2.new(0.5, 0, 0, 156)
            KWeb.BackgroundTransparency = 1
            KWeb.Text               = "🌐 Get Key →  " .. WebSite
            KWeb.TextColor3         = Color3.fromRGB(138, 43, 226)
            KWeb.TextSize = 8
            KWeb.Font               = Enum.Font.Gotham
            KWeb.ZIndex             = 201
            KWeb.Parent             = KeyFrame
            KWeb.MouseButton1Click:Connect(function()
                if setclipboard then setclipboard(WebSite) end
                KWeb.Text = "📋 Copied to clipboard!"
                task.delay(2, function() KWeb.Text = "🌐 Get Key →  " .. WebSite end)
            end)
        end

        -- Block until correct key
        local keyEvent = Instance.new("BindableEvent")
        KBtn.MouseButton1Click:Connect(function()
            local entered = KInput.Text:gsub("%s","")
            if entered == Key then
                KStatus.TextColor3 = Color3.fromRGB(80, 255, 120)
                KStatus.Text = "✔ Access granted!"
                if AutoSaveKey then WriteFile(keyFile, entered) end
                Tween(KBtn, {BackgroundColor3 = Color3.fromRGB(50,200,100)}, 0.3):Play()
                task.wait(0.7)
                Tween(KeyFrame, {BackgroundTransparency = 1}, 0.4):Play()
                for _, v in ipairs(KeyFrame:GetDescendants()) do
                    if v:IsA("GuiObject") then
                        if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                            Tween(v, {TextTransparency = 1}, 0.4):Play()
                        end
                        Tween(v, {BackgroundTransparency = 1}, 0.4):Play()
                    end
                end
                task.wait(0.45)
                KeyFrame:Destroy()
                keyEvent:Fire()
            else
                KStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
                KStatus.Text = "✘ Invalid key. Try again."
                Tween(KeyFrame, {Position = UDim2.new(0.5, -5, 0.5, 0)}, 0.05):Play()
                task.wait(0.05)
                Tween(KeyFrame, {Position = UDim2.new(0.5, 5, 0.5, 0)}, 0.05):Play()
                task.wait(0.05)
                Tween(KeyFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.05):Play()
            end
        end)

        keyEvent.Event:Wait()
        keyEvent:Destroy()
    end

    -- ════════════════════════════════
    --   MAIN WINDOW FRAME
    -- ════════════════════════════════
    -- ────────────────────────────────────────────────────────
    -- CORREÇÃO CANTOS: MainFrame tem UICorner MAS *nunca*
    -- ClipsDescendants (combinar os dois causa o bug de cantos
    -- ao redimensionar). O ClipFrame interno (sem UICorner)
    -- faz o clip do conteúdo de forma segura.
    -- ────────────────────────────────────────────────────────
    local MainFrame = Instance.new("Frame")
    MainFrame.Name                  = "MainFrame"
    MainFrame.Size                  = windowSize
    MainFrame.AnchorPoint           = Vector2.new(0.5, 0.5)
    MainFrame.Position              = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3      = currentTheme.Bg
    MainFrame.BackgroundTransparency = 0
    MainFrame.ClipsDescendants      = false   -- NUNCA true aqui!
    MainFrame.Parent                = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 9)

    -- Frame interno: mesma posição/tamanho, sem UICorner, com ClipsDescendants
    local ClipFrame = Instance.new("Frame")
    ClipFrame.Name                  = "ClipFrame"
    ClipFrame.Size                  = UDim2.new(1, 0, 1, 0)
    ClipFrame.Position              = UDim2.new(0, 0, 0, 0)
    ClipFrame.BackgroundTransparency = 1
    ClipFrame.ClipsDescendants      = true    -- clip sem UICorner = sem bug
    ClipFrame.Parent                = MainFrame


    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color     = currentTheme.Accent
    MainStroke.Thickness = 0.8

    -- Subtle gradient overlay
    local MainGrad = Instance.new("UIGradient")
    MainGrad.Rotation = 135
    MainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,180))
    })
    MainGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.96),
        NumberSequenceKeypoint.new(1, 0.99)
    })
    MainGrad.Parent = MainFrame

    onTheme(function(t)
        MainFrame.BackgroundColor3 = t.Bg
        MainStroke.Color           = t.Accent
    end)

    -- Entrance animation
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 20)
    MainFrame.BackgroundTransparency = 1
    task.defer(function()
        Tween(MainFrame, {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 0
        }, 0.45, Enum.EasingStyle.Back):Play()
    end)

    -- ════════════════════════════════
    --   TITLE BAR
    -- ════════════════════════════════
    local TitleBar = Instance.new("Frame")
    TitleBar.Name              = "TitleBar"
    TitleBar.Size              = UDim2.new(1, 0, 0, 29)
    TitleBar.BackgroundColor3  = currentTheme.Tab
    TitleBar.BackgroundTransparency = 0
    TitleBar.Parent            = ClipFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 9)

    -- Fix bottom corners of title bar
    local TitleFix = Instance.new("Frame")
    TitleFix.Size             = UDim2.new(1, 0, 0, 5)
    TitleFix.AnchorPoint      = Vector2.new(0, 1)
    TitleFix.Position         = UDim2.new(0, 0, 1, 0)
    TitleFix.BackgroundColor3 = currentTheme.Tab
    TitleFix.BorderSizePixel  = 0
    TitleFix.Parent           = TitleBar

    onTheme(function(t)
        TitleBar.BackgroundColor3 = t.Tab
        TitleFix.BackgroundColor3 = t.Tab
    end)

    -- Accent left stripe
    local TitleAccent = Instance.new("Frame")
    TitleAccent.Size             = UDim2.new(0, 2, 0, 17)
    TitleAccent.AnchorPoint      = Vector2.new(0, 0.5)
    TitleAccent.Position         = UDim2.new(0, 7, 0.5, 0)
    TitleAccent.BackgroundColor3 = currentTheme.Accent
    TitleAccent.Parent           = TitleBar
    Instance.new("UICorner", TitleAccent).CornerRadius = UDim.new(1, 0)

    onTheme(function(t) TitleAccent.BackgroundColor3 = t.Accent end)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size              = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position          = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text              = windowTitle
    TitleLabel.TextColor3        = currentTheme.Text
    TitleLabel.TextSize = 11
    TitleLabel.Font              = Enum.Font.GothamBold
    TitleLabel.TextXAlignment    = Enum.TextXAlignment.Left
    TitleLabel.Parent            = TitleBar

    onTheme(function(t) TitleLabel.TextColor3 = t.Text end)

    -- Close / Minimize
    local BtnClose = Instance.new("TextButton")
    BtnClose.Size              = UDim2.new(0, 19, 0, 19)
    BtnClose.AnchorPoint       = Vector2.new(1, 0.5)
    BtnClose.Position          = UDim2.new(1, -7, 0.5, 0)
    BtnClose.BackgroundColor3  = Color3.fromRGB(255, 70, 70)
    BtnClose.Text              = "✕"
    BtnClose.TextColor3        = Color3.fromRGB(255,255,255)
    BtnClose.TextSize = 9
    BtnClose.Font              = Enum.Font.GothamBold
    BtnClose.Parent            = TitleBar
    Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(1, 0)

    local BtnMin = Instance.new("TextButton")
    BtnMin.Size                = UDim2.new(0, 19, 0, 19)
    BtnMin.AnchorPoint         = Vector2.new(1, 0.5)
    BtnMin.Position            = UDim2.new(1, -29, 0.5, 0)
    BtnMin.BackgroundColor3    = Color3.fromRGB(255, 190, 50)
    BtnMin.Text                = "—"
    BtnMin.TextColor3          = Color3.fromRGB(120, 80, 0)
    BtnMin.TextSize = 10
    BtnMin.Font                = Enum.Font.GothamBold
    BtnMin.Parent              = TitleBar
    Instance.new("UICorner", BtnMin).CornerRadius = UDim.new(1, 0)

    MakeDraggable(MainFrame, TitleBar)

    -- Topbar toggle button (outside window, floating)
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name             = "NeonToggle"
    ToggleBtn.Size             = UDim2.new(0, 25, 0, 25)
    ToggleBtn.Position         = UDim2.new(0, 8, 0, 8)
    ToggleBtn.BackgroundColor3 = currentTheme.Accent
    ToggleBtn.Image            = DecalId
    ToggleBtn.Parent           = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255,255,255)

    onTheme(function(t) ToggleBtn.BackgroundColor3 = t.Accent end)

    local windowOpen = true
    local function setWindowOpen(open, animate)
        windowOpen = open
        if animate then
            if open then
                MainFrame.Visible = true
                Tween(MainFrame, {
                    Size = windowSize,
                    BackgroundTransparency = WindowObj._transparent and 0.5 or 0
                }, 0.35, Enum.EasingStyle.Back):Play()
                Tween(ToggleBtn, {Rotation = 0}, 0.35):Play()
            else
                local t = Tween(MainFrame, {
                    Size = UDim2.new(windowSize.X.Scale, windowSize.X.Offset, 0, 0),
                    BackgroundTransparency = 1
                }, 0.3, Enum.EasingStyle.Quart):Play()
                Tween(ToggleBtn, {Rotation = 180}, 0.3):Play()
                task.delay(0.32, function() MainFrame.Visible = false end)
            end
        else
            MainFrame.Visible = open
        end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        setWindowOpen(not windowOpen, true)
    end)

    BtnClose.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(windowSize.X.Scale, windowSize.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.3):Play()
        Tween(ToggleBtn, {ImageTransparency = 1, BackgroundTransparency = 1}, 0.3):Play()
        task.delay(0.35, function()
            ScreenGui:Destroy()
        end)
    end)

    local minimized = false
    BtnMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        setWindowOpen(not minimized, true)
        if minimized then
            ToggleBtn.Visible = true
        end
    end)

    -- ════════════════════════════════
    --   SIDEBAR (TAB BUTTONS)
    -- ════════════════════════════════
    local SideBar = Instance.new("Frame")
    SideBar.Name              = "SideBar"
    SideBar.Size              = UDim2.new(0, 100, 1, -29)
    SideBar.Position          = UDim2.new(0, 0, 0, 29)
    SideBar.BackgroundColor3  = currentTheme.Tab
    SideBar.BackgroundTransparency = 0
    SideBar.Parent            = ClipFrame

    onTheme(function(t) SideBar.BackgroundColor3 = t.Tab end)

    -- Search bar inside sidebar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name            = "SearchBox"
    SearchBox.Size            = UDim2.new(1, -8, 0, 21)
    SearchBox.AnchorPoint     = Vector2.new(0.5, 0)
    SearchBox.Position        = UDim2.new(0.5, 0, 0, 5)
    SearchBox.BackgroundColor3 = currentTheme.Element
    SearchBox.PlaceholderText = "🔍 Search..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 130)
    SearchBox.Text            = ""
    SearchBox.TextColor3      = currentTheme.Text
    SearchBox.TextSize = 9
    SearchBox.Font            = Enum.Font.Gotham
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent          = SideBar
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 5)
    local sp = Instance.new("UIPadding", SearchBox)
    sp.PaddingLeft = UDim.new(0, 7)

    onTheme(function(t)
        SearchBox.BackgroundColor3 = t.Element
        SearchBox.TextColor3       = t.Text
    end)

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name             = "TabScroll"
    TabScroll.Size             = UDim2.new(1, 0, 1, -35)
    TabScroll.Position         = UDim2.new(0, 0, 0, 33)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0.7
    TabScroll.ScrollBarImageColor3 = currentTheme.Accent
    TabScroll.CanvasSize       = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.Parent           = SideBar

    onTheme(function(t) TabScroll.ScrollBarImageColor3 = t.Accent end)

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder          = Enum.SortOrder.LayoutOrder
    TabList.Padding            = UDim.new(0, 3)
    TabList.Parent             = TabScroll
    local TabPad = Instance.new("UIPadding", TabScroll)
    TabPad.PaddingTop    = UDim.new(0, 3)
    TabPad.PaddingLeft   = UDim.new(0, 4)
    TabPad.PaddingRight  = UDim.new(0, 4)

    -- ════════════════════════════════
    --   CONTENT AREA
    -- ════════════════════════════════
    local ContentArea = Instance.new("Frame")
    ContentArea.Name           = "ContentArea"
    ContentArea.Size           = UDim2.new(1, -100, 1, -29)
    ContentArea.Position       = UDim2.new(0, 100, 0, 29)
    ContentArea.BackgroundColor3 = currentTheme.Bg
    ContentArea.BackgroundTransparency = 0
    ContentArea.ClipsDescendants = true
    ContentArea.Parent         = ClipFrame

    onTheme(function(t) ContentArea.BackgroundColor3 = t.Bg end)

    -- Divider line between sidebar and content
    local Divider = Instance.new("Frame")
    Divider.Size              = UDim2.new(0, 1, 1, -29)
    Divider.Position          = UDim2.new(0, 100, 0, 29)
    Divider.BackgroundColor3  = currentTheme.Accent
    Divider.BackgroundTransparency = 0.7
    Divider.Parent            = ClipFrame

    onTheme(function(t) Divider.BackgroundColor3 = t.Accent end)

    -- ════════════════════════════════
    --   OVERLAY LAYER para Dropdowns
    --   Filho direto do ScreenGui com ZIndex alto.
    --   ZIndexBehavior=Sibling: ZIndex é comparado entre
    --   irmãos, logo este frame fica sempre na frente do MainFrame.
    -- ════════════════════════════════
    local OverlayLayer = Instance.new("Frame")
    OverlayLayer.Name                   = "NeonLib_Overlay"
    OverlayLayer.Size                   = UDim2.new(1, 0, 1, 0)
    OverlayLayer.BackgroundTransparency = 1
    OverlayLayer.ZIndex                 = 100   -- MainFrame está no ZIndex padrão (1)
    OverlayLayer.Parent                 = ScreenGui

    -- ════════════════════════════════
    --   SEARCH LOGIC
    -- ════════════════════════════════
    local allElements = {} -- { name, tabName, tabObj }

    local function doSearch(query)
        query = query:lower():gsub("%s","")
        if query == "" then return end
        for _, entry in ipairs(allElements) do
            local eName = entry.name:lower():gsub("%s","")
            if eName:find(query, 1, true) then
                -- Switch to that tab
                if activeTab ~= entry.tabName then
                    for _, t in ipairs(WindowObj.Tabs) do
                        if t.Name == entry.tabName then
                            t:Select()
                            break
                        end
                    end
                end
                -- Highlight element
                if entry.frame then
                    local origColor = entry.frame.BackgroundColor3
                    Tween(entry.frame, {BackgroundColor3 = currentTheme.Accent}, 0.2):Play()
                    task.delay(1.2, function()
                        Tween(entry.frame, {BackgroundColor3 = origColor}, 0.3):Play()
                    end)
                end
                break
            end
        end
    end

    SearchBox.FocusLost:Connect(function(enter)
        if enter then doSearch(SearchBox.Text) end
    end)

    -- ════════════════════════════════
    --   ADD TAB
    -- ════════════════════════════════
    local function createTabButton(tabName, order)
        local Btn = Instance.new("TextButton")
        Btn.Name               = tabName
        Btn.Size               = UDim2.new(1, 0, 0, 24)
        Btn.BackgroundColor3   = currentTheme.Element
        Btn.BackgroundTransparency = 0.4
        Btn.Text               = ""
        Btn.LayoutOrder        = order or 0
        Btn.Parent             = TabScroll
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

        local BtnLabel = Instance.new("TextLabel")
        BtnLabel.Size          = UDim2.new(1, -11, 1, 0)
        BtnLabel.Position      = UDim2.new(0, 7, 0, 0)
        BtnLabel.BackgroundTransparency = 1
        BtnLabel.Text          = tabName
        BtnLabel.TextColor3    = currentTheme.Text
        BtnLabel.TextSize = 9
        BtnLabel.Font          = Enum.Font.Gotham
        BtnLabel.TextXAlignment = Enum.TextXAlignment.Left
        BtnLabel.Parent        = Btn

        local BtnIndicator = Instance.new("Frame")
        BtnIndicator.Size      = UDim2.new(0, 2, 0, 15)
        BtnIndicator.AnchorPoint = Vector2.new(0, 0.5)
        BtnIndicator.Position  = UDim2.new(0, 1, 0.5, 0)
        BtnIndicator.BackgroundColor3 = currentTheme.Accent
        BtnIndicator.BackgroundTransparency = 1
        BtnIndicator.Parent    = Btn
        Instance.new("UICorner", BtnIndicator).CornerRadius = UDim.new(1, 0)

        onTheme(function(t)
            Btn.BackgroundColor3   = t.Element
            BtnLabel.TextColor3    = t.Text
            BtnIndicator.BackgroundColor3 = t.Accent
        end)

        return Btn, BtnLabel, BtnIndicator
    end

    function WindowObj:AddTab(tabName)
        local tabIndex = #self.Tabs + 1
        local Btn, BtnLabel, BtnInd = createTabButton(tabName, tabIndex)

        -- Content scroll for this tab
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name            = "Tab_" .. tabName
        TabContent.Size            = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 1.3
        TabContent.ScrollBarImageColor3 = currentTheme.Accent
        TabContent.CanvasSize      = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible         = false
        TabContent.Parent          = ContentArea

        onTheme(function(t) TabContent.ScrollBarImageColor3 = t.Accent end)

        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder  = Enum.SortOrder.LayoutOrder
        ContentList.Padding    = UDim.new(0, 4)
        ContentList.Parent     = TabContent
        local ContentPad = Instance.new("UIPadding", TabContent)
        ContentPad.PaddingTop    = UDim.new(0, 7)
        ContentPad.PaddingLeft   = UDim.new(0, 8)
        ContentPad.PaddingRight  = UDim.new(0, 8)
        ContentPad.PaddingBottom = UDim.new(0, 7)

        local TabObj  = {
            Name        = tabName,
            Frame       = TabContent,
            Btn         = Btn,
            _elCount    = 0,
            _sections   = {}
        }
        table.insert(self.Tabs, TabObj)

        local function selectThisTab()
            activeTab = tabName
            for _, t in ipairs(WindowObj.Tabs) do
                t.Frame.Visible = (t.Name == tabName)
                if t.Name == tabName then
                    Tween(t.Btn, {BackgroundTransparency = 0}, 0.2):Play()
                    Tween(t.Btn:FindFirstChild("Frame") or BtnInd, {BackgroundTransparency = 0}, 0.2):Play()
                    t.Btn:FindFirstChildOfClass("TextLabel").Font = Enum.Font.GothamBold
                else
                    Tween(t.Btn, {BackgroundTransparency = 0.4}, 0.2):Play()
                    local ind = t.Btn:FindFirstChildOfClass("Frame")
                    if ind then Tween(ind, {BackgroundTransparency = 1}, 0.2):Play() end
                    t.Btn:FindFirstChildOfClass("TextLabel").Font = Enum.Font.Gotham
                end
            end
        end

        TabObj.Select = selectThisTab

        Btn.MouseButton1Click:Connect(selectThisTab)

        if #self.Tabs == 1 then
            selectThisTab()
        end

        -- ──────────────────────────────
        --  SECTION LABEL
        -- ──────────────────────────────
        function TabObj:AddSection(sectionName)
            local SFrame = Instance.new("Frame")
            SFrame.Size            = UDim2.new(1, 0, 0, 19)
            SFrame.BackgroundTransparency = 1
            SFrame.LayoutOrder     = self._elCount
            self._elCount          = self._elCount + 1
            SFrame.Parent          = TabContent

            local SLabel = Instance.new("TextLabel")
            SLabel.Size            = UDim2.new(1, -5, 1, 0)
            SLabel.Position        = UDim2.new(0, 3, 0, 0)
            SLabel.BackgroundTransparency = 1
            SLabel.Text            = sectionName:upper()
            SLabel.TextColor3      = currentTheme.Accent
            SLabel.TextSize = 8
            SLabel.Font            = Enum.Font.GothamBold
            SLabel.TextXAlignment  = Enum.TextXAlignment.Left
            SLabel.Parent          = SFrame

            onTheme(function(t) SLabel.TextColor3 = t.Accent end)

            local SLine = Instance.new("Frame")
            SLine.Size             = UDim2.new(1, -5, 0, 1)
            SLine.Position         = UDim2.new(0, 3, 1, -1)
            SLine.BackgroundColor3 = currentTheme.Accent
            SLine.BackgroundTransparency = 0.7
            SLine.Parent           = SFrame

            onTheme(function(t) SLine.BackgroundColor3 = t.Accent end)
        end

        -- Helper: base element frame
        local function makeBase(height, name, order)
            order = order or TabObj._elCount
            TabObj._elCount = TabObj._elCount + 1

            local F = Instance.new("Frame")
            F.Name                 = name or "Element"
            F.Size                 = UDim2.new(1, 0, 0, height)
            F.BackgroundColor3     = currentTheme.Element
            F.LayoutOrder          = order
            F.Parent               = TabContent
            Instance.new("UICorner", F).CornerRadius = UDim.new(0, 7)

            onTheme(function(t) F.BackgroundColor3 = t.Element end)
            return F
        end

        -- ──────────────────────────────
        --  BUTTON
        -- ──────────────────────────────
        function TabObj:AddButton(cfg)
            cfg = cfg or {}
            local name     = cfg.Name     or "Button"
            local callback = cfg.Callback or function() end

            local F = makeBase(44, name)
            table.insert(allElements, {name=name, tabName=tabName, frame=F})

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(0.6, 0, 1, 0)
            Lbl.Position           = UDim2.new(0, 9, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = name
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            local Btn = Instance.new("TextButton")
            Btn.Size               = UDim2.new(0, 60, 0, 19)
            Btn.AnchorPoint        = Vector2.new(1, 0.5)
            Btn.Position           = UDim2.new(1, -8, 0.5, 0)
            Btn.BackgroundColor3   = currentTheme.Accent
            Btn.Text               = cfg.ButtonText or "Execute"
            Btn.TextColor3         = Color3.fromRGB(255,255,255)
            Btn.TextSize = 9
            Btn.Font               = Enum.Font.GothamBold
            Btn.Parent             = F
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
            onTheme(function(t) Btn.BackgroundColor3 = t.Accent end)

            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, {BackgroundTransparency = 0.4}, 0.1):Play()
                task.delay(0.15, function() Tween(Btn, {BackgroundTransparency = 0}, 0.15):Play() end)
                pcall(callback)
            end)
        end

        -- ──────────────────────────────
        --  TOGGLE
        -- ──────────────────────────────
        function TabObj:AddToggle(cfg)
            cfg = cfg or {}
            local name     = cfg.Name     or "Toggle"
            local default  = cfg.Value    ~= nil and cfg.Value or false
            local callback = cfg.Callback or function() end
            local flag     = cfg.Flag

            local state = default
            local F = makeBase(44, name)
            table.insert(allElements, {name=name, tabName=tabName, frame=F})

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(0.7, 0, 1, 0)
            Lbl.Position           = UDim2.new(0, 9, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = name
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            -- Toggle track
            local Track = Instance.new("Frame")
            Track.Size             = UDim2.new(0, 31, 0, 16)
            Track.AnchorPoint      = Vector2.new(1, 0.5)
            Track.Position         = UDim2.new(1, -9, 0.5, 0)
            Track.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(60,60,80)
            Track.Parent           = F
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
            onTheme(function(t) if state then Track.BackgroundColor3 = t.Accent end end)

            -- Knob
            local Knob = Instance.new("Frame")
            Knob.Size              = UDim2.new(0, 12, 0, 12)
            Knob.AnchorPoint       = Vector2.new(0, 0.5)
            Knob.Position          = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            Knob.BackgroundColor3  = Color3.fromRGB(255,255,255)
            Knob.Parent            = Track
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size         = UDim2.new(1, 0, 1, 0)
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text         = ""
            ToggleBtn.Parent       = F

            local ToggleObj = {}
            ToggleObj.Value = state

            local function setToggle(val, silent)
                state = val
                ToggleObj.Value = val
                if flag then WindowObj.Flags = WindowObj.Flags or {}; WindowObj.Flags[flag] = val end
                Tween(Track, {BackgroundColor3 = val and currentTheme.Accent or Color3.fromRGB(60,60,80)}, 0.25):Play()
                Tween(Knob, {Position = val and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.25):Play()
                if not silent then pcall(callback, val) end
            end

            ToggleBtn.MouseButton1Click:Connect(function() setToggle(not state) end)

            function ToggleObj:Set(v, silent) setToggle(v, silent) end

            if flag then
                WindowObj._flagRegistry = WindowObj._flagRegistry or {}
                WindowObj._flagRegistry[flag] = { obj = ToggleObj, kind = "toggle" }
            end

            return ToggleObj
        end

        -- ──────────────────────────────
        --  SLIDER
        -- ──────────────────────────────
        function TabObj:AddSlider(cfg)
            cfg = cfg or {}
            local name     = cfg.Name     or "Slider"
            local min      = cfg.Min      or 0
            local max      = cfg.Max      or 100
            local default  = cfg.Value    ~= nil and cfg.Value or min
            local callback = cfg.Callback or function() end
            local flag     = cfg.Flag

            local value = math.clamp(default, min, max)
            local F = makeBase(56, name)
            table.insert(allElements, {name=name, tabName=tabName, frame=F})

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(0.6, 0, 0, 15)
            Lbl.Position           = UDim2.new(0, 9, 0, 4)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = name
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            local ValLbl = Instance.new("TextLabel")
            ValLbl.Size            = UDim2.new(0, 33, 0, 15)
            ValLbl.AnchorPoint     = Vector2.new(1, 0)
            ValLbl.Position        = UDim2.new(1, -9, 0, 4)
            ValLbl.BackgroundTransparency = 1
            ValLbl.Text            = tostring(value)
            ValLbl.TextColor3      = currentTheme.Accent
            ValLbl.TextSize = 9
            ValLbl.Font            = Enum.Font.GothamBold
            ValLbl.TextXAlignment  = Enum.TextXAlignment.Right
            ValLbl.Parent          = F
            onTheme(function(t) ValLbl.TextColor3 = t.Accent end)

            local Track = Instance.new("Frame")
            Track.Size             = UDim2.new(1, -19, 0, 4)
            Track.AnchorPoint      = Vector2.new(0.5, 1)
            Track.Position         = UDim2.new(0.5, 0, 1, -7)
            Track.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
            Track.Parent           = F
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Size              = UDim2.new((value-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3  = currentTheme.Accent
            Fill.Parent            = Track
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            onTheme(function(t) Fill.BackgroundColor3 = t.Accent end)

            local Knob = Instance.new("Frame")
            Knob.Size              = UDim2.new(0, 9, 0, 9)
            Knob.AnchorPoint       = Vector2.new(0.5, 0.5)
            Knob.Position          = UDim2.new((value-min)/(max-min), 0, 0.5, 0)
            Knob.BackgroundColor3  = Color3.fromRGB(255,255,255)
            Knob.ZIndex            = 2
            Knob.Parent            = Track
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local draggingSlider = false
            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Size         = UDim2.new(1, 0, 1, 5)
            SliderBtn.AnchorPoint  = Vector2.new(0, 0.5)
            SliderBtn.Position     = UDim2.new(0, 0, 0.5, 0)
            SliderBtn.BackgroundTransparency = 1
            SliderBtn.Text         = ""
            SliderBtn.ZIndex       = 3
            SliderBtn.Parent       = Track

            local SliderObj = {}
            SliderObj.Value = value

            local function setSlider(v, silent)
                value = math.clamp(math.round(v), min, max)
                SliderObj.Value = value
                if flag then WindowObj.Flags = WindowObj.Flags or {}; WindowObj.Flags[flag] = value end
                local pct = (value - min) / (max - min)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                ValLbl.Text = tostring(value)
                if not silent then pcall(callback, value) end
            end

            local function onInput(input)
                local abs = Track.AbsolutePosition
                local size = Track.AbsoluteSize
                local x = math.clamp((input.Position.X - abs.X) / size.X, 0, 1)
                setSlider(min + (max - min) * x)
            end

            SliderBtn.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    onInput(inp)
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if draggingSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    onInput(inp)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            function SliderObj:Set(v, silent) setSlider(v, silent) end

            if flag then
                WindowObj._flagRegistry = WindowObj._flagRegistry or {}
                WindowObj._flagRegistry[flag] = { obj = SliderObj, kind = "slider" }
            end

            return SliderObj
        end

        -- ──────────────────────────────
        --  TEXTBOX
        -- ──────────────────────────────
        function TabObj:AddTextBox(cfg)
            cfg = cfg or {}
            local name      = cfg.Name      or "TextBox"
            local default   = cfg.Value     or ""
            local placeholder = cfg.Placeholder or "Type here..."
            local callback  = cfg.Callback  or function() end
            local flag      = cfg.Flag

            local F = makeBase(56, name)
            table.insert(allElements, {name=name, tabName=tabName, frame=F})

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(1, -19, 0, 13)
            Lbl.Position           = UDim2.new(0, 9, 0, 3)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = name
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            local Input = Instance.new("TextBox")
            Input.Size             = UDim2.new(1, -19, 0, 17)
            Input.Position         = UDim2.new(0, 9, 0, 17)
            Input.BackgroundColor3 = currentTheme.Bg
            Input.Text             = default
            Input.PlaceholderText  = placeholder
            Input.PlaceholderColor3 = Color3.fromRGB(100, 90, 130)
            Input.TextColor3       = currentTheme.Text
            Input.TextSize = 9
            Input.Font             = Enum.Font.Gotham
            Input.ClearTextOnFocus = false
            Input.Parent           = F
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
            local ipad = Instance.new("UIPadding", Input)
            ipad.PaddingLeft = UDim.new(0, 5)
            onTheme(function(t) Input.BackgroundColor3 = t.Bg; Input.TextColor3 = t.Text end)

            local TextBoxObj = { Value = default }
            Input.FocusLost:Connect(function(enter)
                TextBoxObj.Value = Input.Text
                if flag then WindowObj.Flags = WindowObj.Flags or {}; WindowObj.Flags[flag] = Input.Text end
                if enter then pcall(callback, Input.Text) end
            end)
            function TextBoxObj:Set(v)
                Input.Text = v; self.Value = v
            end
            if flag then
                WindowObj._flagRegistry = WindowObj._flagRegistry or {}
                WindowObj._flagRegistry[flag] = { obj = TextBoxObj, kind = "textbox" }
            end
            return TextBoxObj
        end

        -- ──────────────────────────────
        --  DROPDOWN
        -- ──────────────────────────────
        function TabObj:AddDropdown(cfg)
            cfg = cfg or {}
            local name     = cfg.Name     or "Dropdown"
            local options  = cfg.Options  or {}
            local default  = cfg.Value    or (options[1] or "")
            local callback = cfg.Callback or function() end
            local flag     = cfg.Flag

            local selected = default
            local open     = false

            local F = makeBase(44, name)
            table.insert(allElements, {name=name, tabName=tabName, frame=F})

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(0.45, 0, 1, 0)
            Lbl.Position           = UDim2.new(0, 9, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = name
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            local SelBtn = Instance.new("TextButton")
            SelBtn.Size            = UDim2.new(0, 93, 0, 19)
            SelBtn.AnchorPoint     = Vector2.new(1, 0.5)
            SelBtn.Position        = UDim2.new(1, -8, 0.5, 0)
            SelBtn.BackgroundColor3 = currentTheme.Bg
            SelBtn.Text            = selected .. "  ▾"
            SelBtn.TextColor3      = currentTheme.Text
            SelBtn.TextSize = 9
            SelBtn.Font            = Enum.Font.Gotham
            SelBtn.Parent          = F
            Instance.new("UICorner", SelBtn).CornerRadius = UDim.new(0, 5)
            Instance.new("UIStroke", SelBtn).Color = currentTheme.Accent
            onTheme(function(t)
                SelBtn.BackgroundColor3 = t.Bg
                SelBtn.TextColor3       = t.Text
                SelBtn:FindFirstChildOfClass("UIStroke").Color = t.Accent
            end)

            -- ─────────────────────────────────────────────────────────
            -- Dropdown panel: filho do ScreenGui para nunca ser cortado
            -- por ClipsDescendants de nenhum frame intermediário.
            -- A posição é calculada via AbsolutePosition do SelBtn.
            -- ─────────────────────────────────────────────────────────
            local panelH = math.min(#options, 5) * 30 + 8

            local Panel = Instance.new("Frame")
            Panel.Name             = "DropPanel"
            Panel.Size             = UDim2.new(0, 93, 0, panelH)
            Panel.AnchorPoint      = Vector2.new(0, 0)
            Panel.Position         = UDim2.new(0, 0, 0, 0)   -- será atualizado ao abrir
            Panel.BackgroundColor3 = currentTheme.Tab
            Panel.ZIndex           = 2     -- relativo ao OverlayLayer (ZIndex 100 no ScreenGui)
            Panel.Visible          = false
            Panel.ClipsDescendants = true
            Panel.Parent           = OverlayLayer  -- <-- OverlayLayer garante ficar na frente
            Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 7)
            local PanStroke = Instance.new("UIStroke", Panel)
            PanStroke.Color = currentTheme.Accent
            onTheme(function(t)
                Panel.BackgroundColor3 = t.Tab
                PanStroke.Color        = t.Accent
            end)

            local PanelScroll = Instance.new("ScrollingFrame")
            PanelScroll.Size       = UDim2.new(1, 0, 1, 0)
            PanelScroll.BackgroundTransparency = 1
            PanelScroll.ScrollBarThickness = 0.7
            PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            PanelScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            PanelScroll.ZIndex     = 3
            PanelScroll.Parent     = Panel

            local PanList = Instance.new("UIListLayout")
            PanList.SortOrder      = Enum.SortOrder.LayoutOrder
            PanList.Padding        = UDim.new(0, 1)
            PanList.Parent         = PanelScroll
            local PanPad = Instance.new("UIPadding", PanelScroll)
            PanPad.PaddingTop    = UDim.new(0, 3)
            PanPad.PaddingLeft   = UDim.new(0, 3)
            PanPad.PaddingRight  = UDim.new(0, 3)
            PanPad.PaddingBottom = UDim.new(0, 3)

            local DropObj = { Value = selected }

            -- Fecha este dropdown (usado também ao abrir outro)
            local function closePanel()
                open = false
                Tween(Panel, {Size = UDim2.new(0, 93, 0, 0)}, 0.18):Play()
                task.delay(0.19, function() Panel.Visible = false end)
            end

            local function selectOption(opt, silent)
                selected = opt
                DropObj.Value = opt
                if flag then WindowObj.Flags = WindowObj.Flags or {}; WindowObj.Flags[flag] = opt end
                SelBtn.Text = opt .. "  ▾"
                if not silent then pcall(callback, opt) end
                closePanel()
            end

            local function buildOptions(opts)
                -- Limpa botões antigos
                for _, c in ipairs(PanelScroll:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for i, opt in ipairs(opts) do
                    local OBtn = Instance.new("TextButton")
                    OBtn.Size            = UDim2.new(1, 0, 0, 19)
                    OBtn.BackgroundColor3 = currentTheme.Element
                    OBtn.BackgroundTransparency = opt == selected and 0 or 0.5
                    OBtn.Text            = opt
                    OBtn.TextColor3      = currentTheme.Text
                    OBtn.TextSize = 9
                    OBtn.Font            = Enum.Font.Gotham
                    OBtn.LayoutOrder     = i
                    OBtn.ZIndex          = 4
                    OBtn.Parent          = PanelScroll
                    Instance.new("UICorner", OBtn).CornerRadius = UDim.new(0, 4)
                    onTheme(function(t)
                        OBtn.BackgroundColor3 = t.Element
                        OBtn.TextColor3       = t.Text
                    end)
                    OBtn.MouseButton1Click:Connect(function() selectOption(opt) end)
                end
            end

            buildOptions(options)

            -- Botao X para fechar o dropdown
            local CloseBtn = Instance.new("TextButton")
            CloseBtn.Size              = UDim2.new(0, 18, 0, 18)
            CloseBtn.AnchorPoint       = Vector2.new(1, 0.5)
            CloseBtn.Position          = UDim2.new(1, -3, 0, 12)
            CloseBtn.BackgroundColor3  = Color3.fromRGB(255, 70, 70)
            CloseBtn.Text              = "✕"
            CloseBtn.TextColor3        = Color3.fromRGB(255, 255, 255)
            CloseBtn.TextSize          = 9
            CloseBtn.Font              = Enum.Font.GothamBold
            CloseBtn.ZIndex            = 5
            CloseBtn.Parent            = Panel
            Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
            CloseBtn.MouseButton1Click:Connect(closePanel)

            SelBtn.MouseButton1Click:Connect(function()
                if open then
                    closePanel()
                    return
                end
                open = true

                -- Calcula posição absoluta do SelBtn no ScreenGui
                local abs     = SelBtn.AbsolutePosition
                local size    = SelBtn.AbsoluteSize
                local PANW    = 93   -- largura do painel (140 / 1.5)
                local ITEMH   = 20   -- altura de cada item (30 / 1.5)
                local newH    = math.min(#options, 5) * ITEMH + 6

                -- Posiciona abaixo do botão, alinhado à direita
                local panX = abs.X + size.X - PANW
                local panY = abs.Y + size.Y + 3

                -- Se ultrapassar a tela embaixo, abre para cima
                local screenH = ScreenGui.AbsoluteSize.Y
                if panY + newH > screenH then
                    panY = abs.Y - newH - 3
                end

                Panel.Size     = UDim2.new(0, PANW, 0, 0)
                Panel.Position = UDim2.new(0, panX, 0, panY)
                Panel.Visible  = true
                Tween(Panel, {Size = UDim2.new(0, PANW, 0, newH)}, 0.22, Enum.EasingStyle.Back):Play()

                -- Auto-scroll ate a opcao selecionada
                task.defer(function()
                    local selIdx = 1
                    for i, opt in ipairs(options) do
                        if opt == selected then selIdx = i; break end
                    end
                    local itemY     = (selIdx - 1) * ITEMH
                    local centerOff = (newH / 2) - (ITEMH / 2)
                    local targetY   = math.max(0, itemY - centerOff)
                    Tween(PanelScroll, {CanvasPosition = Vector2.new(0, targetY)}, 0.25):Play()
                end)
            end)

            function DropObj:Set(v, silent) selectOption(v, silent) end
            function DropObj:Refresh(newOpts)
                options = newOpts
                buildOptions(newOpts)
            end

            if flag then
                WindowObj._flagRegistry = WindowObj._flagRegistry or {}
                WindowObj._flagRegistry[flag] = { obj = DropObj, kind = "dropdown" }
            end

            return DropObj
        end

        -- ──────────────────────────────
        --  COLOR PICKER
        -- ──────────────────────────────
        function TabObj:AddColorPicker(cfg)
            cfg = cfg or {}
            local name     = cfg.Name     or "Color Picker"
            local default  = cfg.Value    or Color3.fromRGB(138,43,226)
            local callback = cfg.Callback or function() end
            local flag     = cfg.Flag

            local F = makeBase(29, name)
            table.insert(allElements, {name=name, tabName=tabName, frame=F})

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(0.6, 0, 1, 0)
            Lbl.Position           = UDim2.new(0, 9, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = name
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize           = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            -- Preview swatch (igual ao SelBtn do dropdown)
            local Preview = Instance.new("TextButton")
            Preview.Size           = UDim2.new(0, 62, 0, 19)
            Preview.AnchorPoint    = Vector2.new(1, 0.5)
            Preview.Position       = UDim2.new(1, -8, 0.5, 0)
            Preview.BackgroundColor3 = default
            Preview.Text           = "  ▾"
            Preview.TextColor3     = Color3.fromRGB(255,255,255)
            Preview.TextSize       = 9
            Preview.Font           = Enum.Font.GothamBold
            Preview.TextXAlignment = Enum.TextXAlignment.Right
            Preview.Parent         = F
            Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 5)
            local PrevStroke = Instance.new("UIStroke", Preview)
            PrevStroke.Color = currentTheme.Accent
            onTheme(function(t) PrevStroke.Color = t.Accent end)

            local ColorObj   = { Value = default }
            local cpOpen     = false
            local hVal, sVal, vVal = Color3.toHSV(default)

            -- ── Popup no OverlayLayer (igual ao Panel do dropdown) ──────
            local POPW = 160
            local POPH = 0  -- será calculado ao abrir

            local Popup = Instance.new("Frame")
            Popup.Name             = "ColorPopup"
            Popup.Size             = UDim2.new(0, POPW, 0, 0)
            Popup.Position         = UDim2.new(0, 0, 0, 0)
            Popup.BackgroundColor3 = currentTheme.Tab
            Popup.ZIndex           = 2
            Popup.Visible          = false
            Popup.ClipsDescendants = false
            Popup.Parent           = OverlayLayer
            Instance.new("UICorner", Popup).CornerRadius = UDim.new(0, 7)
            local PopStroke = Instance.new("UIStroke", Popup)
            PopStroke.Color = currentTheme.Accent
            onTheme(function(t)
                Popup.BackgroundColor3 = t.Tab
                PopStroke.Color        = t.Accent
            end)

            -- ── Botão X (igual ao dropdown) ─────────────────────────────
            local CPClose = Instance.new("TextButton")
            CPClose.Size             = UDim2.new(0, 18, 0, 18)
            CPClose.AnchorPoint      = Vector2.new(1, 0)
            CPClose.Position         = UDim2.new(1, -3, 0, 3)
            CPClose.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            CPClose.Text             = "✕"
            CPClose.TextColor3       = Color3.fromRGB(255,255,255)
            CPClose.TextSize         = 9
            CPClose.Font             = Enum.Font.GothamBold
            CPClose.ZIndex           = 5
            CPClose.Parent           = Popup
            Instance.new("UICorner", CPClose).CornerRadius = UDim.new(1, 0)

            -- ── Hex label ───────────────────────────────────────────────
            local HexLbl = Instance.new("TextLabel")
            HexLbl.Size              = UDim2.new(1, -28, 0, 14)
            HexLbl.Position          = UDim2.new(0, 7, 0, 5)
            HexLbl.BackgroundTransparency = 1
            HexLbl.Text              = "#8B2BE2"
            HexLbl.TextColor3        = currentTheme.Accent
            HexLbl.TextSize          = 9
            HexLbl.Font              = Enum.Font.GothamBold
            HexLbl.TextXAlignment    = Enum.TextXAlignment.Left
            HexLbl.ZIndex            = 3
            HexLbl.Parent            = Popup
            onTheme(function(t) HexLbl.TextColor3 = t.Accent end)

            -- ── HSV sliders ─────────────────────────────────────────────
            local sliderYStart = 22
            local sliderGap    = 30

            local function updateColor()
                local c = Color3.fromHSV(hVal, sVal, vVal)
                Preview.BackgroundColor3 = c
                ColorObj.Value = c
                -- atualiza hex label
                local r = math.floor(c.R * 255 + 0.5)
                local g = math.floor(c.G * 255 + 0.5)
                local b = math.floor(c.B * 255 + 0.5)
                HexLbl.Text = string.format("#%02X%02X%02X", r, g, b)
                if flag then WindowObj.Flags = WindowObj.Flags or {}; WindowObj.Flags[flag] = c end
                pcall(callback, c)
            end

            local sliderDefs = {
                { label="H", get=function() return hVal end, set=function(v) hVal=v end },
                { label="S", get=function() return sVal end, set=function(v) sVal=v end },
                { label="V", get=function() return vVal end, set=function(v) vVal=v end },
            }

            for si, sd in ipairs(sliderDefs) do
                local yBase = sliderYStart + (si-1)*sliderGap

                local SLbl = Instance.new("TextLabel")
                SLbl.Size              = UDim2.new(0, 10, 0, 10)
                SLbl.Position          = UDim2.new(0, 7, 0, yBase)
                SLbl.BackgroundTransparency = 1
                SLbl.Text              = sd.label
                SLbl.TextColor3        = currentTheme.Text
                SLbl.TextSize          = 8
                SLbl.Font              = Enum.Font.GothamBold
                SLbl.ZIndex            = 3
                SLbl.Parent            = Popup
                onTheme(function(t) SLbl.TextColor3 = t.Text end)

                local ValLbl = Instance.new("TextLabel")
                ValLbl.Size            = UDim2.new(0, 28, 0, 10)
                ValLbl.AnchorPoint     = Vector2.new(1, 0)
                ValLbl.Position        = UDim2.new(1, -7, 0, yBase)
                ValLbl.BackgroundTransparency = 1
                ValLbl.Text            = string.format("%.2f", sd.get())
                ValLbl.TextColor3      = currentTheme.Accent
                ValLbl.TextSize        = 8
                ValLbl.Font            = Enum.Font.Gotham
                ValLbl.TextXAlignment  = Enum.TextXAlignment.Right
                ValLbl.ZIndex          = 3
                ValLbl.Parent          = Popup
                onTheme(function(t) ValLbl.TextColor3 = t.Accent end)

                local STrk = Instance.new("Frame")
                STrk.Size              = UDim2.new(1, -14, 0, 6)
                STrk.Position          = UDim2.new(0, 7, 0, yBase + 13)
                STrk.BackgroundColor3  = Color3.fromRGB(40,30,60)
                STrk.ZIndex            = 3
                STrk.Parent            = Popup
                Instance.new("UICorner", STrk).CornerRadius = UDim.new(1, 0)

                local SFill = Instance.new("Frame")
                SFill.Size             = UDim2.new(sd.get(), 0, 1, 0)
                SFill.BackgroundColor3 = currentTheme.Accent
                SFill.ZIndex           = 4
                SFill.Parent           = STrk
                Instance.new("UICorner", SFill).CornerRadius = UDim.new(1, 0)
                onTheme(function(t) SFill.BackgroundColor3 = t.Accent end)

                local SKnob = Instance.new("Frame")
                SKnob.Size             = UDim2.new(0, 10, 0, 10)
                SKnob.AnchorPoint      = Vector2.new(0.5, 0.5)
                SKnob.Position         = UDim2.new(sd.get(), 0, 0.5, 0)
                SKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
                SKnob.ZIndex           = 5
                SKnob.Parent           = STrk
                Instance.new("UICorner", SKnob).CornerRadius = UDim.new(1, 0)

                local SBtn = Instance.new("TextButton")
                SBtn.Size              = UDim2.new(1, 0, 1, 10)
                SBtn.AnchorPoint       = Vector2.new(0, 0.5)
                SBtn.Position          = UDim2.new(0, 0, 0.5, 0)
                SBtn.BackgroundTransparency = 1
                SBtn.Text              = ""
                SBtn.ZIndex            = 6
                SBtn.Parent            = STrk

                local draggingCP = false
                local function applyPos(inp)
                    local pct = math.clamp((inp.Position.X - STrk.AbsolutePosition.X) / STrk.AbsoluteSize.X, 0, 1)
                    SFill.Size   = UDim2.new(pct, 0, 1, 0)
                    SKnob.Position = UDim2.new(pct, 0, 0.5, 0)
                    ValLbl.Text  = string.format("%.2f", pct)
                    sd.set(pct)
                    updateColor()
                end

                SBtn.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        draggingCP = true
                        applyPos(inp)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if draggingCP and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                        applyPos(inp)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        draggingCP = false
                    end
                end)
            end

            -- Altura total do popup: 3 sliders * 30 + header + padding
            POPH = sliderYStart + 3 * sliderGap + 6

            -- ── Open / Close ────────────────────────────────────────────
            local function closePopup()
                cpOpen = false
                Tween(Popup, {Size = UDim2.new(0, POPW, 0, 0)}, 0.18):Play()
                task.delay(0.19, function() Popup.Visible = false end)
            end

            CPClose.MouseButton1Click:Connect(closePopup)

            Preview.MouseButton1Click:Connect(function()
                if cpOpen then
                    closePopup()
                    return
                end
                cpOpen = true

                local abs  = Preview.AbsolutePosition
                local size = Preview.AbsoluteSize
                local px   = abs.X + size.X - POPW
                local py   = abs.Y + size.Y + 3

                local screenH = ScreenGui.AbsoluteSize.Y
                if py + POPH > screenH then
                    py = abs.Y - POPH - 3
                end

                Popup.Size     = UDim2.new(0, POPW, 0, 0)
                Popup.Position = UDim2.new(0, px, 0, py)
                Popup.Visible  = true
                Tween(Popup, {Size = UDim2.new(0, POPW, 0, POPH)}, 0.22, Enum.EasingStyle.Back):Play()
            end)

            function ColorObj:Set(v, silent)
                Preview.BackgroundColor3 = v
                self.Value = v
                hVal, sVal, vVal = Color3.toHSV(v)
                if not silent then pcall(callback, v) end
            end

            if flag then
                WindowObj._flagRegistry = WindowObj._flagRegistry or {}
                WindowObj._flagRegistry[flag] = { obj = ColorObj, kind = "color" }
            end

            return ColorObj
        end

        -- ──────────────────────────────
        --  KEYBIND
        -- ──────────────────────────────
        function TabObj:AddKeybind(cfg)
            cfg = cfg or {}
            local name     = cfg.Name     or "Keybind"
            local default  = cfg.Value    or Enum.KeyCode.Unknown
            local callback = cfg.Callback or function() end
            local flag     = cfg.Flag

            local bound  = default
            local listening = false

            local F = makeBase(44, name)
            table.insert(allElements, {name=name, tabName=tabName, frame=F})

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(0.6, 0, 1, 0)
            Lbl.Position           = UDim2.new(0, 9, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = name
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            local KBtn = Instance.new("TextButton")
            KBtn.Size              = UDim2.new(0, 60, 0, 19)
            KBtn.AnchorPoint       = Vector2.new(1, 0.5)
            KBtn.Position          = UDim2.new(1, -8, 0.5, 0)
            KBtn.BackgroundColor3  = currentTheme.Bg
            KBtn.Text              = tostring(bound.Name)
            KBtn.TextColor3        = currentTheme.Accent
            KBtn.TextSize = 9
            KBtn.Font              = Enum.Font.GothamBold
            KBtn.Parent            = F
            Instance.new("UICorner", KBtn).CornerRadius = UDim.new(0, 5)
            Instance.new("UIStroke", KBtn).Color = currentTheme.Accent
            onTheme(function(t)
                KBtn.BackgroundColor3 = t.Bg
                KBtn.TextColor3       = t.Accent
                KBtn:FindFirstChildOfClass("UIStroke").Color = t.Accent
            end)

            local BindObj = { Value = bound }

            KBtn.MouseButton1Click:Connect(function()
                listening = true
                KBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(inp, gp)
                if gp then return end
                if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                    bound = inp.KeyCode
                    BindObj.Value = bound
                    if flag then WindowObj.Flags = WindowObj.Flags or {}; WindowObj.Flags[flag] = bound end
                    KBtn.Text = tostring(bound.Name)
                    listening = false
                elseif not listening and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == bound then
                    pcall(callback, bound)
                end
            end)

            function BindObj:Set(v) bound = v; KBtn.Text = tostring(v.Name); self.Value = v end
            if flag then
                WindowObj._flagRegistry = WindowObj._flagRegistry or {}
                WindowObj._flagRegistry[flag] = { obj = BindObj, kind = "keybind" }
            end
            return BindObj
        end

        -- ──────────────────────────────
        --  LABEL
        -- ──────────────────────────────
        function TabObj:AddLabel(cfg)
            cfg = cfg or {}
            local text = cfg.Text or "Label"

            local F = makeBase(36, text)
            table.insert(allElements, {name=text, tabName=tabName, frame=F})
            F.BackgroundTransparency = 0.6

            local Lbl = Instance.new("TextLabel")
            Lbl.Size               = UDim2.new(1, -19, 1, 0)
            Lbl.Position           = UDim2.new(0, 9, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text               = text
            Lbl.TextColor3         = currentTheme.Text
            Lbl.TextSize = 9
            Lbl.Font               = Enum.Font.Gotham
            Lbl.TextXAlignment     = Enum.TextXAlignment.Left
            Lbl.TextWrapped        = true
            Lbl.Parent             = F
            onTheme(function(t) Lbl.TextColor3 = t.Text end)

            local LabelObj = {}
            function LabelObj:Set(v) Lbl.Text = v end
            return LabelObj
        end

        -- ──────────────────────────────
        --  PARAGRAPH
        -- ──────────────────────────────
        function TabObj:AddParagraph(cfg)
            cfg = cfg or {}
            local title = cfg.Title or ""
            local text  = cfg.Value or ""
            local flag  = cfg.Flag

            local F = makeBase(70, title)
            table.insert(allElements, {name=title, tabName=tabName, frame=F})

            if title ~= "" then
                local TLbl = Instance.new("TextLabel")
                TLbl.Size              = UDim2.new(1, -19, 0, 13)
                TLbl.Position          = UDim2.new(0, 9, 0, 4)
                TLbl.BackgroundTransparency = 1
                TLbl.Text              = title
                TLbl.TextColor3        = currentTheme.Accent
                TLbl.TextSize = 9
                TLbl.Font              = Enum.Font.GothamBold
                TLbl.TextXAlignment    = Enum.TextXAlignment.Left
                TLbl.Parent            = F
                onTheme(function(t) TLbl.TextColor3 = t.Accent end)
            end

            local BLbl = Instance.new("TextLabel")
            BLbl.Size              = UDim2.new(1, -19, 0, 27)
            BLbl.Position          = UDim2.new(0, 9, 0, title~="" and 28 or 8)
            BLbl.BackgroundTransparency = 1
            BLbl.Text              = text
            BLbl.TextColor3        = currentTheme.Text
            BLbl.TextSize = 8
            BLbl.Font              = Enum.Font.Gotham
            BLbl.TextXAlignment    = Enum.TextXAlignment.Left
            BLbl.TextWrapped       = true
            BLbl.Parent            = F
            onTheme(function(t) BLbl.TextColor3 = t.Text end)

            local PObj = { Value = text }
            function PObj:Set(v) BLbl.Text = v; self.Value = v end
            return PObj
        end

        return TabObj
    end

    -- ════════════════════════════════
    --   CONFIG TAB  (AddConfig)
    -- ════════════════════════════════
    function WindowObj:AddConfig()
        local configTab = self:AddTab("⚙ Config")

        configTab:AddSection("Appearance")

        -- Transparent background toggle
        local transToggle = configTab:AddToggle({
            Name     = "Transparent Background",
            Value    = false,
            Callback = function(val)
                WindowObj._transparent = val
                local t = val and 0.5 or 0
                Tween(MainFrame, {BackgroundTransparency = t}, 0.3):Play()
                Tween(ContentArea, {BackgroundTransparency = t}, 0.3):Play()
                Tween(SideBar, {BackgroundTransparency = t > 0 and t + 0.1 or 0}, 0.3):Play()
                Tween(TitleBar, {BackgroundTransparency = t > 0 and t + 0.1 or 0}, 0.3):Play()
            end
        })

        -- Theme dropdown
        configTab:AddDropdown({
            Name     = "UI Theme",
            Options  = ThemeList,
            Value    = defaultTheme,
            Callback = function(theme)
                if Themes[theme] then
                    currentTheme = Themes[theme]
                    applyTheme()
                end
            end
        })

        configTab:AddSection("Save System")

        -- Save name textbox
        local saveNameBox = configTab:AddTextBox({
            Name        = "Save Name",
            Placeholder = "my_config",
            Value       = "my_config"
        })

        -- Saved files dropdown
        local function getSaveList()
            local list = {}
            local files = ListFiles("NeonLib/Saves")
            for _, f in ipairs(files) do
                local n = f:gsub("NeonLib/Saves/", ""):gsub("%.json", "")
                table.insert(list, n)
            end
            if #list == 0 then list = {"(no saves)"} end
            return list
        end

        local saveDrop = configTab:AddDropdown({
            Name    = "Load Save",
            Options = getSaveList()
        })

        -- Save button
        configTab:AddButton({
            Name       = "Save Config",
            ButtonText = "Save",
            Callback   = function()
                local sName = saveNameBox.Value
                if sName == "" then sName = "my_config" end

                -- Collect flags
                local data = {}
                if WindowObj.Flags then
                    for k, v in pairs(WindowObj.Flags) do
                        local t = typeof(v)
                        if t == "boolean" or t == "number" or t == "string" then
                            data[k] = v
                        elseif t == "Color3" then
                            data[k] = { __type = "Color3", r = v.R, g = v.G, b = v.B }
                        elseif t == "EnumItem" then
                            data[k] = { __type = "Enum", val = tostring(v) }
                        end
                    end
                end

                local json = HttpService:JSONEncode(data)
                WriteFile("NeonLib/Saves/" .. sName .. ".json", json)

                saveDrop:Refresh(getSaveList())
            end
        })

        -- Load button
        configTab:AddButton({
            Name       = "Load Selected",
            ButtonText = "Load",
            Callback   = function()
                local sel = saveDrop.Value
                if sel == "(no saves)" or sel == "" then return end

                local raw = ReadFile("NeonLib/Saves/" .. sel .. ".json")
                if not raw or raw == "" then return end

                local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
                if not ok or type(decoded) ~= "table" then return end

                local registry = WindowObj._flagRegistry or {}

                for k, v in pairs(decoded) do
                    -- Deserializa tipos especiais
                    local realVal
                    if type(v) == "table" then
                        if v.__type == "Color3" then
                            realVal = Color3.new(v.r or 0, v.g or 0, v.b or 0)
                        elseif v.__type == "Enum" then
                            -- Keybind: tenta resolver via Enum.KeyCode
                            pcall(function()
                                local parts = tostring(v.val):split(".")
                                if parts and #parts >= 3 then
                                    realVal = Enum[parts[2]][parts[3]]
                                end
                            end)
                        end
                    else
                        realVal = v
                    end

                    if realVal ~= nil then
                        -- Atualiza o valor na tabela Flags
                        WindowObj.Flags[k] = realVal

                        -- Chama :Set() no elemento registrado para atualizar a UI
                        local entry = registry[k]
                        if entry and entry.obj and entry.obj.Set then
                            pcall(function() entry.obj:Set(realVal, true) end)
                        end
                    end
                end
            end
        })

        configTab:AddSection("Info")
        configTab:AddLabel({ Text = "NeonLib V2 — Ultra Modern UI" })

        return configTab
    end

    WindowObj.Flags         = {}
    WindowObj._flagRegistry = {}  -- flag -> { obj, type }

    -- Theme apply on init
    applyTheme()

    return WindowObj
end

return NeonLib
