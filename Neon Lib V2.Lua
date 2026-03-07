--[[
    ██╗      ██████╗ ██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗
    ██║     ██╔═══██╗██║  ██║    ██║  ██║██║   ██║██╔══██╗
    ██║     ██║   ██║███████║    ███████║██║   ██║██████╔╝
    ██║     ██║   ██║██╔══██║    ██╔══██║██║   ██║██╔══██╗
    ███████╗╚██████╔╝██║  ██║    ██║  ██║╚██████╔╝██████╔╝
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
    
    LOH HUB - Ultra Modern UI Library v3.0
    Author: LOH_HUB.GG
    Build: 2025 | Luau Strict Mode Compatible
--]]

-- ============================================================
-- SERVIÇOS
-- ============================================================
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local CoreGui         = game:GetService("CoreGui")
local TextService     = game:GetService("TextService")

local LocalPlayer     = Players.LocalPlayer

-- ============================================================
-- UTILIDADES INTERNAS
-- ============================================================
local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function TweenWait(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    t.Completed:Wait()
end

local function Make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function MakeCorner(radius, parent)
    return Make("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local function MakeStroke(color, thickness, parent)
    return Make("UIStroke", {Color = color, Thickness = thickness}, parent)
end

local function MakePad(top, bottom, left, right, parent)
    return Make("UIPadding", {
        PaddingTop    = UDim.new(0, top),
        PaddingBottom = UDim.new(0, bottom),
        PaddingLeft   = UDim.new(0, left),
        PaddingRight  = UDim.new(0, right),
    }, parent)
end

local function MakeList(spacing, parent)
    return Make("UIListLayout", {
        SortOrder      = Enum.SortOrder.LayoutOrder,
        Padding        = UDim.new(0, spacing),
    }, parent)
end

local function RandomID()
    return HttpService:GenerateGUID(false):sub(1,8)
end

-- ============================================================
-- SISTEMA DE FICHEIROS (pcall safe)
-- ============================================================
local FS = {}
function FS.Write(path, data)
    pcall(function() writefile(path, data) end)
end
function FS.Read(path)
    local ok, data = pcall(function() return readfile(path) end)
    return ok and data or nil
end
function FS.Exists(path)
    local ok, v = pcall(function() return isfile(path) end)
    return ok and v or false
end
function FS.MakeFolder(path)
    pcall(function()
        if not isfolder(path) then makefolder(path) end
    end)
end

-- ============================================================
-- TEMAS (20 temas)
-- ============================================================
local Themes = {
    ["Neon Void"]       = { BG="#0a0a0f", Surface="#12121a", Accent="#7c3aed", Text="#e2e8f0", Sub="#94a3b8", Border="#1e1e2e", Glow=Color3.fromRGB(124,58,237) },
    ["Cyber Red"]       = { BG="#0d0505", Surface="#160a0a", Accent="#ef4444", Text="#fef2f2", Sub="#fca5a5", Border="#2a1010", Glow=Color3.fromRGB(239,68,68) },
    ["Ocean Depth"]     = { BG="#020b18", Surface="#071525", Accent="#0ea5e9", Text="#e0f2fe", Sub="#7dd3fc", Border="#0c2137", Glow=Color3.fromRGB(14,165,233) },
    ["Forest Dark"]     = { BG="#030d06", Surface="#071509", Accent="#22c55e", Text="#dcfce7", Sub="#86efac", Border="#0d2410", Glow=Color3.fromRGB(34,197,94) },
    ["Rose Gold"]       = { BG="#120810", Surface="#1e0f1c", Accent="#f472b6", Text="#fce7f3", Sub="#f9a8d4", Border="#2d1328", Glow=Color3.fromRGB(244,114,182) },
    ["Arctic White"]    = { BG="#f8fafc", Surface="#ffffff", Accent="#6366f1", Text="#0f172a", Sub="#475569", Border="#e2e8f0", Glow=Color3.fromRGB(99,102,241) },
    ["Amber Blaze"]     = { BG="#0d0800", Surface="#160e00", Accent="#f59e0b", Text="#fffbeb", Sub="#fcd34d", Border="#291a00", Glow=Color3.fromRGB(245,158,11) },
    ["Synthwave"]       = { BG="#0d001a", Surface="#150026", Accent="#e879f9", Text="#fdf4ff", Sub="#e879f9", Border="#2d0050", Glow=Color3.fromRGB(232,121,249) },
    ["Graphite"]        = { BG="#111111", Surface="#1c1c1c", Accent="#a3a3a3", Text="#fafafa", Sub="#737373", Border="#2a2a2a", Glow=Color3.fromRGB(163,163,163) },
    ["Dracula"]         = { BG="#282a36", Surface="#1e1f29", Accent="#bd93f9", Text="#f8f8f2", Sub="#6272a4", Border="#44475a", Glow=Color3.fromRGB(189,147,249) },
    ["Nord"]            = { BG="#2e3440", Surface="#3b4252", Accent="#88c0d0", Text="#eceff4", Sub="#d8dee9", Border="#4c566a", Glow=Color3.fromRGB(136,192,208) },
    ["Catppuccin"]      = { BG="#1e1e2e", Surface="#181825", Accent="#cba6f7", Text="#cdd6f4", Sub="#a6adc8", Border="#313244", Glow=Color3.fromRGB(203,166,247) },
    ["Tokyonight"]      = { BG="#1a1b26", Surface="#16161e", Accent="#7aa2f7", Text="#c0caf5", Sub="#565f89", Border="#292e42", Glow=Color3.fromRGB(122,162,247) },
    ["Gruvbox"]         = { BG="#282828", Surface="#1d2021", Accent="#b8bb26", Text="#ebdbb2", Sub="#a89984", Border="#3c3836", Glow=Color3.fromRGB(184,187,38) },
    ["Monokai"]         = { BG="#272822", Surface="#1e1f1c", Accent="#a6e22e", Text="#f8f8f2", Sub="#75715e", Border="#3e3d32", Glow=Color3.fromRGB(166,226,46) },
    ["Midnight Blue"]   = { BG="#0a0e1a", Surface="#0f1629", Accent="#3b82f6", Text="#dbeafe", Sub="#93c5fd", Border="#1e2d4a", Glow=Color3.fromRGB(59,130,246) },
    ["Sakura"]          = { BG="#fef0f5", Surface="#fff5f9", Accent="#fb7185", Text="#1e0010", Sub="#9d4f6c", Border="#fecdd3", Glow=Color3.fromRGB(251,113,133) },
    ["Terminal"]        = { BG="#000000", Surface="#0a0a0a", Accent="#00ff41", Text="#00ff41", Sub="#00cc33", Border="#1a1a1a", Glow=Color3.fromRGB(0,255,65) },
    ["Sunset"]          = { BG="#0d0008", Surface="#1a0015", Accent="#fb923c", Text="#fff7ed", Sub="#fdba74", Border="#2a0020", Glow=Color3.fromRGB(251,146,60) },
    ["Lavender"]        = { BG="#1a1230", Surface="#231848", Accent="#a78bfa", Text="#f5f3ff", Sub="#c4b5fd", Border="#2d1f5e", Glow=Color3.fromRGB(167,139,250) },
}

local function HexToColor3(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber("0x"..hex:sub(1,2)),
        tonumber("0x"..hex:sub(3,4)),
        tonumber("0x"..hex:sub(5,6))
    )
end

-- ============================================================
-- LIBRARY PRINCIPAL
-- ============================================================
local Library = {}
Library.__index = Library

function Library.new(config)
    local self = setmetatable({}, Library)

    -- CONFIG PADRÃO
    self.Config = {
        -- Key System
        KeySystem      = config.KeySystem      or false,
        KeyName        = config.KeyName        or "Key System",
        Key            = config.Key            or "LOH_HUB.GG",
        AutoSaveKey    = config.AutoSaveKey    or true,
        AutoLoadKey    = config.AutoLoadKey    or true,
        GetKeybyWebsite= config.GetKeybyWebsite or false,
        WebSite        = config.WebSite        or "",
        -- Loading
        DecalId        = config.DecalId        or "rbxassetid://7148140395",
        LoadingName    = config.LoadingName    or "Welcome Back!!",
        -- Tema inicial
        Theme          = config.Theme          or "Neon Void",
        -- Misc
        Title          = config.Title          or "LOH HUB",
        SubTitle       = config.SubTitle       or "LOH_HUB.GG",
    }

    self._theme         = Themes[self.Config.Theme] or Themes["Neon Void"]
    self._windows       = {}
    self._open          = true
    self._transparent   = false
    self._debugErrors   = {}
    self._saveFolder    = "LohHub_Saves"
    self._currentSaves  = {}
    self._callbacks     = {}
    self._elements      = {}   -- {id, name, tabRef, elementObj}

    FS.MakeFolder(self._saveFolder)

    -- GUI ROOT
    local existing = CoreGui:FindFirstChild("LohHub_UI")
    if existing then existing:Destroy() end

    self._gui = Make("ScreenGui", {
        Name            = "LohHub_UI",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset  = true,
    }, CoreGui)

    -- DEBUG OVERLAY (checker loop)
    self:_StartDebugChecker()

    if self.Config.KeySystem then
        self:_ShowKeySystem(function()
            self:_ShowLoading(function()
                self:_BuildUI()
            end)
        end)
    else
        self:_ShowLoading(function()
            self:_BuildUI()
        end)
    end

    return self
end

-- ============================================================
-- DEBUG CHECKER (verifica a cada 0.5s)
-- ============================================================
function Library:_StartDebugChecker()
    task.spawn(function()
        while self._gui and self._gui.Parent do
            local ok, err = pcall(function()
                -- Verifica integridade dos elementos
                for _, elem in ipairs(self._elements) do
                    if elem.obj and not elem.obj.Parent then
                        warn("[LohHub Debug] Elemento órfão detectado: " .. tostring(elem.name))
                    end
                end
                -- Verifica callbacks
                for id, cb in pairs(self._callbacks) do
                    if type(cb) ~= "function" then
                        warn("[LohHub Debug] Callback inválido para ID: " .. tostring(id))
                        self._callbacks[id] = function() end
                    end
                end
            end)
            if not ok then
                warn("[LohHub Debug] Erro no checker: " .. tostring(err))
            end
            task.wait(0.5)
        end
    end)
end

-- ============================================================
-- KEY SYSTEM
-- ============================================================
function Library:_ShowKeySystem(callback)
    local T = self._theme
    local keyFile = self._saveFolder .. "/key.dat"

    -- Auto Load
    if self.Config.AutoLoadKey and FS.Exists(keyFile) then
        local saved = FS.Read(keyFile)
        if saved == self.Config.Key then
            callback()
            return
        end
    end

    local bg = Make("Frame", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundColor3= HexToColor3(T.BG),
        ZIndex          = 100,
    }, self._gui)
    MakeCorner(0, bg)

    -- Glass panel
    local panel = Make("Frame", {
        Size             = UDim2.new(0, 420, 0, 320),
        Position         = UDim2.new(0.5, -210, 0.5, -160),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 101,
    }, bg)
    MakeCorner(18, panel)
    MakeStroke(HexToColor3(T.Border), 1.5, panel)

    -- Glow accent top
    local glowBar = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = T.Glow,
        ZIndex           = 102,
    }, panel)
    MakeCorner(3, glowBar)

    Make("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 40),
        Position         = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text             = "🔑  " .. self.Config.KeyName,
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.GothamBold,
        TextSize         = 22,
        ZIndex           = 102,
    }, panel)

    Make("TextLabel", {
        Size             = UDim2.new(1, -40, 0, 30),
        Position         = UDim2.new(0, 20, 0, 65),
        BackgroundTransparency = 1,
        Text             = "Digite sua key para continuar",
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 102,
    }, panel)

    local keyBox = Make("TextBox", {
        Size             = UDim2.new(1, -40, 0, 48),
        Position         = UDim2.new(0, 20, 0, 110),
        BackgroundColor3 = HexToColor3(T.BG),
        TextColor3       = HexToColor3(T.Text),
        PlaceholderText  = "Cole sua key aqui...",
        PlaceholderColor3= HexToColor3(T.Sub),
        Font             = Enum.Font.GothamMono,
        TextSize         = 15,
        ClearTextOnFocus = false,
        ZIndex           = 102,
        Text             = "",
    }, panel)
    MakeCorner(10, keyBox)
    MakeStroke(HexToColor3(T.Border), 1, keyBox)
    MakePad(0, 0, 12, 12, keyBox)

    local statusLbl = Make("TextLabel", {
        Size             = UDim2.new(1, -40, 0, 24),
        Position         = UDim2.new(0, 20, 0, 168),
        BackgroundTransparency = 1,
        Text             = "",
        TextColor3       = Color3.fromRGB(239,68,68),
        Font             = Enum.Font.Gotham,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 102,
    }, panel)

    -- Confirm button
    local confirmBtn = Make("TextButton", {
        Size             = UDim2.new(1, -40, 0, 46),
        Position         = UDim2.new(0, 20, 0, 200),
        BackgroundColor3 = T.Glow,
        TextColor3       = Color3.fromRGB(255,255,255),
        Font             = Enum.Font.GothamBold,
        TextSize         = 16,
        Text             = "Confirmar Key",
        ZIndex           = 102,
    }, panel)
    MakeCorner(12, confirmBtn)

    -- Website button
    if self.Config.GetKeybyWebsite and self.Config.WebSite ~= "" then
        local webBtn = Make("TextButton", {
            Size             = UDim2.new(1, -40, 0, 36),
            Position         = UDim2.new(0, 20, 0, 255),
            BackgroundColor3 = HexToColor3(T.Border),
            TextColor3       = HexToColor3(T.Sub),
            Font             = Enum.Font.Gotham,
            TextSize         = 13,
            Text             = "🌐  Pegar Key no Site",
            ZIndex           = 102,
        }, panel)
        MakeCorner(10, webBtn)
        webBtn.MouseButton1Click:Connect(function()
            pcall(function() setclipboard(self.Config.WebSite) end)
            statusLbl.TextColor3 = Color3.fromRGB(34,197,94)
            statusLbl.Text = "✓  Link copiado! Cole no navegador."
        end)
    end

    -- Hover effect
    confirmBtn.MouseEnter:Connect(function()
        Tween(confirmBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Glow:Lerp(Color3.new(1,1,1), 0.15)})
    end)
    confirmBtn.MouseLeave:Connect(function()
        Tween(confirmBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Glow})
    end)

    confirmBtn.MouseButton1Click:Connect(function()
        local input = keyBox.Text:gsub("%s+", "")
        if input == self.Config.Key then
            if self.Config.AutoSaveKey then
                FS.Write(keyFile, input)
            end
            statusLbl.TextColor3 = Color3.fromRGB(34,197,94)
            statusLbl.Text = "✓  Key válida! Carregando..."
            task.wait(0.8)
            TweenWait(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1})
            bg:Destroy()
            callback()
        else
            statusLbl.TextColor3 = Color3.fromRGB(239,68,68)
            statusLbl.Text = "✗  Key inválida! Tente novamente."
            Tween(panel, TweenInfo.new(0.05, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.5, -205, 0.5, -160)})
            task.wait(0.05)
            Tween(panel, TweenInfo.new(0.05, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.5, -215, 0.5, -160)})
            task.wait(0.05)
            Tween(panel, TweenInfo.new(0.1), {Position = UDim2.new(0.5, -210, 0.5, -160)})
        end
    end)

    -- Fade in
    bg.BackgroundTransparency = 1
    Tween(bg, TweenInfo.new(0.4), {BackgroundTransparency = 0})
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(panel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160),
    })
end

-- ============================================================
-- LOADING SCREEN
-- ============================================================
function Library:_ShowLoading(callback)
    local T = self._theme
    local bg = Make("Frame", {
        Size             = UDim2.fromScale(1, 1),
        BackgroundColor3 = HexToColor3(T.BG),
        ZIndex           = 90,
    }, self._gui)

    -- Logo/Decal
    local logo = Make("ImageLabel", {
        Size             = UDim2.new(0, 120, 0, 120),
        Position         = UDim2.new(0.5, -60, 0.5, -130),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://" .. self.Config.DecalId,
        ZIndex           = 91,
    }, bg)
    MakeCorner(16, logo)

    Make("TextLabel", {
        Size             = UDim2.new(0, 400, 0, 50),
        Position         = UDim2.new(0.5, -200, 0.5, 10),
        BackgroundTransparency = 1,
        Text             = self.Config.LoadingName,
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.GothamBold,
        TextSize         = 30,
        ZIndex           = 91,
    }, bg)

    Make("TextLabel", {
        Size             = UDim2.new(0, 400, 0, 30),
        Position         = UDim2.new(0.5, -200, 0.5, 55),
        BackgroundTransparency = 1,
        Text             = self.Config.SubTitle,
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize         = 16,
        ZIndex           = 91,
    }, bg)

    -- Progress bar container
    local barBG = Make("Frame", {
        Size             = UDim2.new(0, 320, 0, 6),
        Position         = UDim2.new(0.5, -160, 0.5, 100),
        BackgroundColor3 = HexToColor3(T.Border),
        ZIndex           = 91,
    }, bg)
    MakeCorner(3, barBG)

    local bar = Make("Frame", {
        Size             = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.Glow,
        ZIndex           = 92,
    }, barBG)
    MakeCorner(3, bar)

    local pct = Make("TextLabel", {
        Size             = UDim2.new(0, 320, 0, 20),
        Position         = UDim2.new(0.5, -160, 0.5, 115),
        BackgroundTransparency = 1,
        Text             = "Carregando... 0%",
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.GothamMono,
        TextSize         = 12,
        ZIndex           = 91,
    }, bg)

    -- Animate bar
    local steps = {"Inicializando módulos", "Carregando temas", "Configurando UI", "Preparando elementos", "Concluído"}
    for i, step in ipairs(steps) do
        local p = i / #steps
        Tween(bar, TweenInfo.new(0.35, Enum.EasingStyle.Sine), {Size = UDim2.new(p, 0, 1, 0)})
        pct.Text = step .. "... " .. math.floor(p * 100) .. "%"
        task.wait(0.25)
    end

    task.wait(0.3)
    TweenWait(bg, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1})
    bg:Destroy()
    callback()
end

-- ============================================================
-- BUILD UI PRINCIPAL
-- ============================================================
function Library:_BuildUI()
    local T = self._theme

    -- TOPBAR TOGGLE BUTTON
    self._topbarBtn = Make("ImageButton", {
        Size             = UDim2.new(0, 36, 0, 36),
        Position         = UDim2.new(0, 8, 0, 4),
        BackgroundColor3 = HexToColor3(T.Surface),
        Image            = "rbxassetid://7072725342",
        ImageColor3      = T.Glow,
        ZIndex           = 200,
    }, self._gui)
    MakeCorner(10, self._topbarBtn)
    MakeStroke(T.Glow, 1.5, self._topbarBtn)

    self._topbarBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    -- MAIN WINDOW
    local W = Make("Frame", {
        Name             = "MainWindow",
        Size             = UDim2.new(0, 820, 0, 540),
        Position         = UDim2.new(0.5, -410, 0.5, -270),
        BackgroundColor3 = HexToColor3(T.BG),
        ZIndex           = 10,
        ClipsDescendants = true,
    }, self._gui)
    MakeCorner(16, W)
    MakeStroke(HexToColor3(T.Border), 1.5, W)
    self._mainWindow = W

    -- Draggable
    self:_MakeDraggable(W)

    -- ACCENT LINE TOP
    local accentLine = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = T.Glow,
        ZIndex           = 11,
    }, W)
    MakeCorner(0, accentLine)

    -- HEADER
    local header = Make("Frame", {
        Name             = "Header",
        Size             = UDim2.new(1, 0, 0, 52),
        Position         = UDim2.new(0, 0, 0, 3),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 11,
    }, W)

    Make("TextLabel", {
        Size             = UDim2.new(0, 200, 1, 0),
        Position         = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text             = self.Config.Title,
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.GothamBold,
        TextSize         = 20,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 12,
    }, header)

    Make("TextLabel", {
        Size             = UDim2.new(0, 200, 1, 0),
        Position         = UDim2.new(0, 130, 0, 6),
        BackgroundTransparency = 1,
        Text             = self.Config.SubTitle,
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 12,
    }, header)

    -- Fechar botão no header
    local closeBtn = Make("TextButton", {
        Size             = UDim2.new(0, 32, 0, 32),
        Position         = UDim2.new(1, -44, 0, 10),
        BackgroundColor3 = Color3.fromRGB(239,68,68),
        Text             = "×",
        TextColor3       = Color3.fromRGB(255,255,255),
        Font             = Enum.Font.GothamBold,
        TextSize         = 20,
        ZIndex           = 12,
    }, header)
    MakeCorner(8, closeBtn)
    closeBtn.MouseButton1Click:Connect(function() self:Toggle() end)
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220,38,38)})
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(239,68,68)})
    end)

    -- SIDEBAR
    local sidebar = Make("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, 190, 1, -55),
        Position         = UDim2.new(0, 0, 0, 55),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 11,
    }, W)

    -- Barra de pesquisa
    local searchBox = Make("TextBox", {
        Size             = UDim2.new(1, -20, 0, 34),
        Position         = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = HexToColor3(T.BG),
        TextColor3       = HexToColor3(T.Text),
        PlaceholderText  = "🔍 Pesquisar...",
        PlaceholderColor3= HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize          = 13,
        ClearTextOnFocus = false,
        ZIndex           = 12,
        Text             = "",
    }, sidebar)
    MakeCorner(10, searchBox)
    MakeStroke(HexToColor3(T.Border), 1, searchBox)
    MakePad(0, 0, 10, 10, searchBox)
    self._searchBox = searchBox

    -- TAB LIST
    local tabList = Make("ScrollingFrame", {
        Size             = UDim2.new(1, 0, 1, -56),
        Position         = UDim2.new(0, 0, 0, 54),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Glow,
        ZIndex           = 12,
        CanvasSize        = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, sidebar)
    MakePad(6, 6, 8, 8, tabList)
    MakeList(4, tabList)
    self._tabList = tabList
    self._tabs = {}
    self._activeTab = nil

    -- CONTENT AREA
    local content = Make("Frame", {
        Name             = "Content",
        Size             = UDim2.new(1, -190, 1, -55),
        Position         = UDim2.new(0, 190, 0, 55),
        BackgroundTransparency = 1,
        ZIndex           = 11,
        ClipsDescendants = true,
    }, W)
    self._contentArea = content

    -- Separador vertical
    Make("Frame", {
        Size             = UDim2.new(0, 1, 1, -55),
        Position         = UDim2.new(0, 189, 0, 55),
        BackgroundColor3 = HexToColor3(T.Border),
        ZIndex           = 11,
    }, W)

    -- SEARCH LOGIC
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        if query == "" or query == "🔍 pesquisar..." then return end
        -- Procura o elemento e navega até a tab
        for _, e in ipairs(self._elements) do
            if e.name:lower():find(query, 1, true) then
                self:_SetActiveTab(e.tabRef)
                -- Highlight
                if e.obj and e.obj:IsA("Frame") then
                    local orig = e.obj.BackgroundColor3
                    Tween(e.obj, TweenInfo.new(0.2), {BackgroundColor3 = T.Glow:Lerp(Color3.new(0,0,0), 0.4)})
                    task.delay(0.8, function()
                        Tween(e.obj, TweenInfo.new(0.3), {BackgroundColor3 = orig})
                    end)
                end
                break
            end
        end
    end)

    -- Fade in window
    W.Size = UDim2.new(0, 0, 0, 0)
    W.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(W, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, 820, 0, 540),
        Position = UDim2.new(0.5, -410, 0.5, -270),
    })

    self._windowObj = W
end

-- ============================================================
-- TOGGLE ANIMADO
-- ============================================================
function Library:Toggle()
    self._open = not self._open
    local W = self._mainWindow
    if not W then return end
    if self._open then
        W.Visible = true
        Tween(W, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size     = UDim2.new(0, 820, 0, 540),
            Position = UDim2.new(0.5, -410, 0.5, -270),
        })
        Tween(self._topbarBtn, TweenInfo.new(0.2), {ImageColor3 = self._theme.Glow})
    else
        TweenWait(W, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size     = UDim2.new(0, 820, 0, 0),
            Position = UDim2.new(0.5, -410, 0.5, -2),
        })
        W.Visible = false
        W.Size     = UDim2.new(0, 820, 0, 540)
        W.Position = UDim2.new(0.5, -410, 0.5, -270)
        Tween(self._topbarBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150,150,150)})
    end
end

-- ============================================================
-- DRAGGABLE
-- ============================================================
function Library:_MakeDraggable(frame)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================
-- SET ACTIVE TAB
-- ============================================================
function Library:_SetActiveTab(tabRef)
    local T = self._theme
    if self._activeTab == tabRef then return end

    -- Deselect current
    if self._activeTab then
        local old = self._activeTab
        Tween(old._btn, TweenInfo.new(0.2), {BackgroundColor3 = HexToColor3(T.Surface)})
        old._btn.TextColor3 = HexToColor3(T.Sub)
        old._container.Visible = false
    end

    -- Select new
    self._activeTab = tabRef
    Tween(tabRef._btn, TweenInfo.new(0.2), {BackgroundColor3 = T.Glow:Lerp(Color3.new(0,0,0), 0.2)})
    tabRef._btn.TextColor3 = HexToColor3(T.Text)
    tabRef._container.Visible = true
    -- Slide in
    tabRef._container.Position = UDim2.new(0.05, 0, 0, 0)
    tabRef._container.BackgroundTransparency = 1
    Tween(tabRef._container, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    })
end

-- ============================================================
-- WINDOW (retorna objeto window para AddTab, AddConfig)
-- ============================================================
function Library:CreateWindow()
    -- Alias para compatibilidade
    return self
end

function Library:AddTab(name, icon)
    local T = self._theme
    icon = icon or "📄"

    -- TAB BUTTON
    local btn = Make("TextButton", {
        Size             = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = HexToColor3(T.Surface),
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 14,
        Text             = icon .. "  " .. name,
        TextXAlignment   = Enum.TextXAlignment.Left,
        AutoButtonColor  = false,
        ZIndex           = 13,
    }, self._tabList)
    MakeCorner(10, btn)
    MakePad(0, 0, 12, 0, btn)

    -- TAB CONTAINER
    local container = Make("ScrollingFrame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.Glow,
        ZIndex           = 12,
        Visible          = false,
        CanvasSize        = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, self._contentArea)
    MakePad(12, 12, 12, 12, container)
    MakeList(8, container)

    local tabRef = {
        _btn       = btn,
        _container = container,
        _name      = name,
        _library   = self,
        _T         = T,
    }
    setmetatable(tabRef, {__index = TabAPI})

    table.insert(self._tabs, tabRef)

    btn.MouseButton1Click:Connect(function()
        self:_SetActiveTab(tabRef)
    end)
    btn.MouseEnter:Connect(function()
        if self._activeTab ~= tabRef then
            Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = HexToColor3(T.Border)})
        end
    end)
    btn.MouseLeave:Connect(function()
        if self._activeTab ~= tabRef then
            Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = HexToColor3(T.Surface)})
        end
    end)

    -- Auto-select first tab
    if #self._tabs == 1 then
        self:_SetActiveTab(tabRef)
    end

    return tabRef
end

-- ============================================================
-- ADD CONFIG TAB
-- ============================================================
function Library:AddConfig()
    local tab = self:AddTab("Config", "⚙️")
    local T   = self._theme
    local lib  = self

    -- ─── Toggle Transparência ───────────────────────────────
    tab:AddToggle({
        Name    = "Fundo Transparente (50%)",
        Default = false,
        Callback = function(val)
            lib._transparent = val
            local alpha = val and 0.5 or 0
            if lib._mainWindow then
                Tween(lib._mainWindow, TweenInfo.new(0.3), {BackgroundTransparency = alpha})
            end
        end
    })

    -- ─── Dropdown de Tema ────────────────────────────────────
    local themeNames = {}
    for k in pairs(Themes) do table.insert(themeNames, k) end
    table.sort(themeNames)

    tab:AddDropdown({
        Name    = "Tema da UI",
        Options = themeNames,
        Default = lib.Config.Theme,
        Callback = function(val)
            lib:ApplyTheme(val)
        end
    })

    -- ─── Textbox nome do save ────────────────────────────────
    local saveNameValue = Make("StringValue", {Value = "save_01"})
    tab:AddTextbox({
        Name        = "Nome do Salvamento",
        Default     = "save_01",
        Placeholder = "Nome do arquivo JSON...",
        Callback    = function(val)
            saveNameValue.Value = val
        end
    })

    -- ─── Botão Salvar ────────────────────────────────────────
    tab:AddButton({
        Name     = "💾  Salvar Configurações",
        Callback = function()
            lib:SaveConfig(saveNameValue.Value)
        end
    })

    -- ─── Dropdown escolher save ──────────────────────────────
    local saveDropRef = {}
    local function RefreshSaves()
        local saves = lib:ListSaves()
        if saveDropRef._setOptions then
            saveDropRef._setOptions(saves)
        end
    end

    local saveDrop = tab:AddDropdown({
        Name    = "Carregar Salvamento",
        Options = lib:ListSaves(),
        Default = nil,
        Callback = function(val)
            saveDropRef._selected = val
        end
    })
    saveDropRef._setOptions = saveDrop._setOptions
    saveDropRef._selected   = nil

    -- ─── Botão Carregar ──────────────────────────────────────
    tab:AddButton({
        Name     = "📂  Carregar Selecionado",
        Callback = function()
            if saveDropRef._selected then
                lib:LoadConfig(saveDropRef._selected)
            end
            RefreshSaves()
        end
    })

    return tab
end

-- ============================================================
-- APPLY THEME
-- ============================================================
function Library:ApplyTheme(themeName)
    local T = Themes[themeName]
    if not T then return end
    self._theme = T

    local function ApplyRecursive(obj)
        for _, child in ipairs(obj:GetChildren()) do
            ApplyRecursive(child)
        end
    end
    ApplyRecursive(self._gui)

    -- Re-tint accent elements
    if self._mainWindow then
        Tween(self._mainWindow, TweenInfo.new(0.3), {BackgroundColor3 = HexToColor3(T.BG)})
    end
end

-- ============================================================
-- SAVE / LOAD CONFIG
-- ============================================================
function Library:SaveConfig(name)
    if not name or name == "" then name = "save_01" end
    name = name:gsub("[^%w_%-]", "_")
    local data = {}
    for _, e in ipairs(self._elements) do
        if e.valueObj then
            local ok, val = pcall(function()
                return e.valueObj.Value
            end)
            if ok then data[e.id] = val end
        end
    end
    local json = HttpService:JSONEncode(data)
    FS.MakeFolder(self._saveFolder)
    FS.Write(self._saveFolder .. "/" .. name .. ".json", json)
end

function Library:LoadConfig(name)
    local path = self._saveFolder .. "/" .. name .. ".json"
    local raw  = FS.Read(path)
    if not raw then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok then return end
    for _, e in ipairs(self._elements) do
        local val = data[e.id]
        if val ~= nil and e.valueObj and e.callback then
            pcall(function()
                e.valueObj.Value = val
                e.callback(val)
            end)
        end
    end
end

function Library:ListSaves()
    local list = {}
    local ok, files = pcall(function() return listfiles(self._saveFolder) end)
    if ok and files then
        for _, f in ipairs(files) do
            local name = f:match("[/\\]?([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
    end
    return list
end

-- ============================================================
-- TAB API
-- ============================================================
TabAPI = {}
TabAPI.__index = TabAPI

local function RegisterElement(lib, name, tabRef, obj, valueObj, callback)
    local id = RandomID()
    table.insert(lib._elements, {
        id       = id,
        name     = name,
        tabRef   = tabRef,
        obj      = obj,
        valueObj = valueObj,
        callback = callback,
    })
    lib._callbacks[id] = callback or function() end
    return id
end

-- ─── SECTION LABEL ────────────────────────────────────────
function TabAPI:AddSection(cfg)
    local T = self._T
    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        ZIndex           = 13,
    }, self._container)

    Make("Frame", {
        Size             = UDim2.new(0, 3, 1, -8),
        Position         = UDim2.new(0, 0, 0, 4),
        BackgroundColor3 = T.Glow,
        ZIndex           = 14,
    }, frame)

    Make("TextLabel", {
        Size             = UDim2.new(1, -12, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text             = (cfg.Name or "Seção"):upper(),
        TextColor3       = T.Glow,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        LetterSpacing    = 2,
        ZIndex           = 14,
    }, frame)
end

-- ─── BUTTON ───────────────────────────────────────────────
function TabAPI:AddButton(cfg)
    local T = self._T
    local frame = Make("TextButton", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = HexToColor3(T.Surface),
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 14,
        Text             = cfg.Name or "Button",
        AutoButtonColor  = false,
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)

    -- Ripple effect
    local function Ripple()
        local r = Make("Frame", {
            Size             = UDim2.new(0, 0, 0, 0),
            Position         = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = T.Glow,
            ZIndex           = 14,
        }, frame)
        MakeCorner(99, r)
        r.BackgroundTransparency = 0.6
        Tween(r, TweenInfo.new(0.5), {
            Size = UDim2.new(1.5, 0, 2.5, 0),
            Position = UDim2.new(-0.25, 0, -0.75, 0),
            BackgroundTransparency = 1,
        })
        task.delay(0.5, function() r:Destroy() end)
    end

    frame.MouseButton1Click:Connect(function()
        Ripple()
        pcall(cfg.Callback or function() end)
    end)
    frame.MouseEnter:Connect(function()
        Tween(frame, TweenInfo.new(0.15), {BackgroundColor3 = HexToColor3(T.Border)})
    end)
    frame.MouseLeave:Connect(function()
        Tween(frame, TweenInfo.new(0.15), {BackgroundColor3 = HexToColor3(T.Surface)})
    end)

    RegisterElement(self._library, cfg.Name or "Button", self, frame, nil, cfg.Callback)
    return frame
end

-- ─── TOGGLE ───────────────────────────────────────────────
function TabAPI:AddToggle(cfg)
    local T     = self._T
    local val   = BoolValue.new and Instance.new("BoolValue") or Instance.new("BoolValue")
    val.Value   = cfg.Default or false
    val.Parent  = self._container

    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)

    Make("TextLabel", {
        Size             = UDim2.new(1, -70, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Toggle",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 14,
    }, frame)

    -- Track
    local track = Make("Frame", {
        Size             = UDim2.new(0, 48, 0, 26),
        Position         = UDim2.new(1, -62, 0.5, -13),
        BackgroundColor3 = HexToColor3(T.Border),
        ZIndex           = 14,
    }, frame)
    MakeCorner(13, track)

    -- Knob
    local knob = Make("Frame", {
        Size             = UDim2.new(0, 20, 0, 20),
        Position         = UDim2.new(0, 3, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        ZIndex           = 15,
    }, track)
    MakeCorner(10, knob)

    local function Update(v)
        if v then
            Tween(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = T.Glow})
            Tween(knob,  TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 25, 0.5, -10)})
        else
            Tween(track, TweenInfo.new(0.2), {BackgroundColor3 = HexToColor3(T.Border)})
            Tween(knob,  TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -10)})
        end
        pcall(cfg.Callback or function() end, v)
    end

    if val.Value then Update(true) end

    local btn = Make("TextButton", {
        Size                = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text                = "",
        ZIndex              = 16,
    }, frame)
    btn.MouseButton1Click:Connect(function()
        val.Value = not val.Value
        Update(val.Value)
    end)

    RegisterElement(self._library, cfg.Name or "Toggle", self, frame, val, function(v)
        val.Value = v
        Update(v)
    end)
    return frame
end

-- ─── SLIDER ───────────────────────────────────────────────
function TabAPI:AddSlider(cfg)
    local T    = self._T
    local min  = cfg.Min or 0
    local max  = cfg.Max or 100
    local def  = cfg.Default or min
    local val  = Instance.new("NumberValue")
    val.Value  = def
    val.Parent = self._container

    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)
    MakePad(0, 0, 14, 14, frame)

    local header = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        ZIndex           = 14,
    }, frame)

    Make("TextLabel", {
        Size             = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Slider",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 14,
    }, header)

    local valLbl = Make("TextLabel", {
        Size             = UDim2.new(0.3, 0, 1, 0),
        Position         = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Text             = tostring(def) .. (cfg.Suffix or ""),
        TextColor3       = T.Glow,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Right,
        ZIndex           = 14,
    }, header)

    local track = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 6),
        Position         = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = HexToColor3(T.Border),
        ZIndex           = 14,
    }, frame)
    MakeCorner(3, track)

    local fill = Make("Frame", {
        Size             = UDim2.new((def - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = T.Glow,
        ZIndex           = 15,
    }, track)
    MakeCorner(3, fill)

    local knob = Make("Frame", {
        Size     = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((def - min) / (max - min), -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        ZIndex   = 16,
    }, track)
    MakeCorner(8, knob)

    local dragging = false
    knob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            rel = math.clamp(rel, 0, 1)
            local newVal = math.floor(min + rel * (max - min))
            if newVal ~= val.Value then
                val.Value = newVal
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -8, 0.5, -8)
                valLbl.Text = tostring(newVal) .. (cfg.Suffix or "")
                pcall(cfg.Callback or function() end, newVal)
            end
        end
    end)

    RegisterElement(self._library, cfg.Name or "Slider", self, frame, val, function(v)
        v = math.clamp(v, min, max)
        val.Value = v
        local rel = (v - min) / (max - min)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -8, 0.5, -8)
        valLbl.Text = tostring(v) .. (cfg.Suffix or "")
        pcall(cfg.Callback or function() end, v)
    end)
    return frame
end

-- ─── DROPDOWN ─────────────────────────────────────────────
function TabAPI:AddDropdown(cfg)
    local T    = self._T
    local opts = cfg.Options or {}
    local sel  = cfg.Default or (opts[1] or "")
    local val  = Instance.new("StringValue")
    val.Value  = sel
    val.Parent = self._container

    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 15,
        ClipsDescendants = false,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)

    Make("TextLabel", {
        Size             = UDim2.new(0.6, 0, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Dropdown",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 16,
    }, frame)

    local selLbl = Make("TextLabel", {
        Size             = UDim2.new(0.38, 0, 1, 0),
        Position         = UDim2.new(0.6, 0, 0, 0),
        BackgroundTransparency = 1,
        Text             = sel ~= "" and sel or "Selecionar",
        TextColor3       = T.Glow,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Right,
        ZIndex           = 16,
    }, frame)

    Make("TextLabel", {
        Size             = UDim2.new(0, 20, 1, 0),
        Position         = UDim2.new(1, -28, 0, 0),
        BackgroundTransparency = 1,
        Text             = "▾",
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize         = 16,
        ZIndex           = 16,
    }, frame)

    -- Dropdown list
    local list = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 0),
        Position         = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 30,
        Visible          = false,
        ClipsDescendants = true,
    }, frame)
    MakeCorner(10, list)
    MakeStroke(HexToColor3(T.Border), 1, list)

    local scroll = Make("ScrollingFrame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Glow,
        ZIndex           = 31,
        CanvasSize        = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, list)
    MakePad(4, 4, 0, 0, scroll)
    MakeList(2, scroll)

    local isOpen = false

    local function SetOptions(newOpts)
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, opt in ipairs(newOpts) do
            local item = Make("TextButton", {
                Size             = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = HexToColor3(T.BG),
                TextColor3       = HexToColor3(T.Text),
                Font             = Enum.Font.Gotham,
                TextSize         = 13,
                Text             = opt,
                AutoButtonColor  = false,
                ZIndex           = 32,
            }, scroll)
            MakeCorner(8, item)
            MakePad(0, 0, 10, 0, item)
            item.MouseEnter:Connect(function()
                Tween(item, TweenInfo.new(0.1), {BackgroundColor3 = HexToColor3(T.Border)})
            end)
            item.MouseLeave:Connect(function()
                Tween(item, TweenInfo.new(0.1), {BackgroundColor3 = HexToColor3(T.BG)})
            end)
            item.MouseButton1Click:Connect(function()
                val.Value = opt
                selLbl.Text = opt
                isOpen = false
                Tween(list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                task.wait(0.2)
                list.Visible = false
                pcall(cfg.Callback or function() end, opt)
            end)
        end
    end

    SetOptions(opts)

    local maxH = math.min(#opts * 34 + 8, 160)
    local openBtn = Make("TextButton", {
        Size                = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text                = "",
        ZIndex              = 17,
    }, frame)
    openBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            list.Visible = true
            list.Size = UDim2.new(1, 0, 0, 0)
            Tween(list, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, maxH)})
        else
            Tween(list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
            task.delay(0.2, function() list.Visible = false end)
        end
    end)

    local obj = {
        _setOptions = SetOptions,
        _selected   = sel,
    }

    RegisterElement(self._library, cfg.Name or "Dropdown", self, frame, val, function(v)
        val.Value = v
        selLbl.Text = v
        pcall(cfg.Callback or function() end, v)
    end)
    return obj
end

-- ─── TEXTBOX ──────────────────────────────────────────────
function TabAPI:AddTextbox(cfg)
    local T   = self._T
    local val = Instance.new("StringValue")
    val.Value = cfg.Default or ""
    val.Parent= self._container

    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)
    MakePad(0, 0, 14, 14, frame)

    Make("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Textbox",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.Gotham,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 14,
    }, frame)

    local box = Make("TextBox", {
        Size             = UDim2.new(1, 0, 0, 30),
        Position         = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = HexToColor3(T.BG),
        TextColor3       = HexToColor3(T.Text),
        PlaceholderText  = cfg.Placeholder or "",
        PlaceholderColor3= HexToColor3(T.Sub),
        Font             = Enum.Font.GothamMono,
        TextSize         = 13,
        ClearTextOnFocus = false,
        ZIndex           = 14,
        Text             = cfg.Default or "",
    }, frame)
    MakeCorner(8, box)
    MakeStroke(HexToColor3(T.Border), 1, box)
    MakePad(0, 0, 8, 8, box)

    box.FocusLost:Connect(function()
        val.Value = box.Text
        pcall(cfg.Callback or function() end, box.Text)
    end)

    RegisterElement(self._library, cfg.Name or "Textbox", self, frame, val, function(v)
        val.Value = v
        box.Text  = v
        pcall(cfg.Callback or function() end, v)
    end)
    return frame
end

-- ─── COLOR PICKER ─────────────────────────────────────────
function TabAPI:AddColorPicker(cfg)
    local T   = self._T
    local def = cfg.Default or Color3.fromRGB(255,255,255)
    local val = Instance.new("Color3Value")
    val.Value = def

    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)

    Make("TextLabel", {
        Size             = UDim2.new(1, -70, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Color Picker",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 14,
    }, frame)

    local preview = Make("Frame", {
        Size             = UDim2.new(0, 32, 0, 24),
        Position         = UDim2.new(1, -50, 0.5, -12),
        BackgroundColor3 = def,
        ZIndex           = 14,
    }, frame)
    MakeCorner(6, preview)
    MakeStroke(HexToColor3(T.Border), 1, preview)

    -- Simple HSV picker popup
    local pickerOpen = false
    local popup = Make("Frame", {
        Size             = UDim2.new(0, 220, 0, 180),
        Position         = UDim2.new(1, -230, 1, 4),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 40,
        Visible          = false,
    }, frame)
    MakeCorner(12, popup)
    MakeStroke(T.Glow, 1.5, popup)

    local function BuildHSVPicker()
        -- Hue bar
        local hueBar = Make("Frame", {
            Size     = UDim2.new(1, -20, 0, 16),
            Position = UDim2.new(0, 10, 0, 10),
            ZIndex   = 41,
        }, popup)
        MakeCorner(6, hueBar)

        local hueGrad = Make("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromHSV(0,1,1)),
                ColorSequenceKeypoint.new(1/6, Color3.fromHSV(1/6,1,1)),
                ColorSequenceKeypoint.new(2/6, Color3.fromHSV(2/6,1,1)),
                ColorSequenceKeypoint.new(3/6, Color3.fromHSV(3/6,1,1)),
                ColorSequenceKeypoint.new(4/6, Color3.fromHSV(4/6,1,1)),
                ColorSequenceKeypoint.new(5/6, Color3.fromHSV(5/6,1,1)),
                ColorSequenceKeypoint.new(1,   Color3.fromHSV(1,1,1)),
            }),
        }, hueBar)

        local h, s, v2 = Color3.toHSV(def)
        local hueCursor = Make("Frame", {
            Size     = UDim2.new(0, 4, 1, 4),
            Position = UDim2.new(h, -2, 0, -2),
            BackgroundColor3 = Color3.new(1,1,1),
            ZIndex   = 42,
        }, hueBar)
        MakeCorner(2, hueCursor)

        -- SV square
        local svSquare = Make("Frame", {
            Size     = UDim2.new(1, -20, 0, 100),
            Position = UDim2.new(0, 10, 0, 36),
            BackgroundColor3 = Color3.fromHSV(h, 1, 1),
            ZIndex   = 41,
        }, popup)
        MakeCorner(6, svSquare)

        local whiteGrad = Make("UIGradient", {
            Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
        }, svSquare)

        local blackOverlay = Make("Frame", {
            Size             = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0,0,0),
            ZIndex           = 42,
        }, svSquare)
        MakeCorner(6, blackOverlay)
        Make("UIGradient", {
            Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
            Rotation = 90,
        }, blackOverlay)

        local svCursor = Make("Frame", {
            Size     = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(s, -5, 1-v2, -5),
            BackgroundColor3 = Color3.new(1,1,1),
            ZIndex   = 43,
        }, svSquare)
        MakeCorner(5, svCursor)

        local function UpdateColor()
            local c = Color3.fromHSV(h, s, v2)
            val.Value = c
            preview.BackgroundColor3 = c
            svSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            pcall(cfg.Callback or function() end, c)
        end

        -- Hue drag
        local dragH = false
        hueBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragH = true end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragH = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragH and i.UserInputType == Enum.UserInputType.MouseMovement then
                h = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                hueCursor.Position = UDim2.new(h, -2, 0, -2)
                UpdateColor()
            end
        end)

        -- SV drag
        local dragSV = false
        svSquare.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragSV = true end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragSV = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragSV and i.UserInputType == Enum.UserInputType.MouseMovement then
                s  = math.clamp((i.Position.X - svSquare.AbsolutePosition.X) / svSquare.AbsoluteSize.X, 0, 1)
                v2 = 1 - math.clamp((i.Position.Y - svSquare.AbsolutePosition.Y) / svSquare.AbsoluteSize.Y, 0, 1)
                svCursor.Position = UDim2.new(s, -5, 1-v2, -5)
                UpdateColor()
            end
        end)

        -- Hex input
        local hexBox = Make("TextBox", {
            Size             = UDim2.new(1, -20, 0, 28),
            Position         = UDim2.new(0, 10, 1, -38),
            BackgroundColor3 = HexToColor3(T.BG),
            TextColor3       = HexToColor3(T.Text),
            PlaceholderText  = "#RRGGBB",
            PlaceholderColor3= HexToColor3(T.Sub),
            Font             = Enum.Font.GothamMono,
            TextSize         = 12,
            ZIndex           = 41,
            Text             = "",
        }, popup)
        MakeCorner(6, hexBox)
        hexBox.FocusLost:Connect(function()
            local ok2, c2 = pcall(function() return HexToColor3(hexBox.Text) end)
            if ok2 then
                val.Value = c2
                preview.BackgroundColor3 = c2
                h, s, v2 = Color3.toHSV(c2)
                UpdateColor()
            end
        end)
    end

    BuildHSVPicker()

    local openBtn2 = Make("TextButton", {
        Size                = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text                = "",
        ZIndex              = 15,
    }, frame)
    openBtn2.MouseButton1Click:Connect(function()
        pickerOpen = not pickerOpen
        popup.Visible = pickerOpen
    end)

    RegisterElement(self._library, cfg.Name or "ColorPicker", self, frame, val, function(v)
        val.Value = v
        preview.BackgroundColor3 = v
        pcall(cfg.Callback or function() end, v)
    end)
    return frame
end

-- ─── LABEL ────────────────────────────────────────────────
function TabAPI:AddLabel(cfg)
    local T     = self._T
    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(8, frame)

    local lbl = Make("TextLabel", {
        Size             = UDim2.new(1, -20, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "",
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        RichText         = true,
        ZIndex           = 14,
    }, frame)

    local obj = {
        Set = function(_, text)
            lbl.Text = text
        end,
    }
    RegisterElement(self._library, cfg.Name or "Label", self, frame, nil, nil)
    return obj
end

-- ─── KEYBIND ──────────────────────────────────────────────
function TabAPI:AddKeybind(cfg)
    local T    = self._T
    local val  = Instance.new("StringValue")
    val.Value  = cfg.Default and cfg.Default.Name or "None"
    val.Parent = self._container

    local listening = false
    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)

    Make("TextLabel", {
        Size             = UDim2.new(0.6, 0, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Keybind",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 14,
    }, frame)

    local keyBtn = Make("TextButton", {
        Size             = UDim2.new(0, 80, 0, 28),
        Position         = UDim2.new(1, -96, 0.5, -14),
        BackgroundColor3 = HexToColor3(T.BG),
        TextColor3       = T.Glow,
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        Text             = val.Value,
        ZIndex           = 14,
    }, frame)
    MakeCorner(8, keyBtn)

    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = HexToColor3(T.Sub)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if listening and not processed then
            listening = false
            if input.UserInputType == Enum.UserInputType.Keyboard then
                val.Value = input.KeyCode.Name
                keyBtn.Text = input.KeyCode.Name
                keyBtn.TextColor3 = T.Glow
                pcall(cfg.Callback or function() end, input.KeyCode)
            end
        elseif not listening and val.Value ~= "None" then
            if input.KeyCode.Name == val.Value then
                pcall(cfg.OnPress or function() end)
            end
        end
    end)

    RegisterElement(self._library, cfg.Name or "Keybind", self, frame, val, function(v)
        val.Value = v
        keyBtn.Text = v
    end)
    return frame
end

-- ─── INPUT (número) ───────────────────────────────────────
function TabAPI:AddInput(cfg)
    local T   = self._T
    local val = Instance.new("NumberValue")
    val.Value = tonumber(cfg.Default) or 0

    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakeStroke(HexToColor3(T.Border), 1, frame)
    MakePad(0, 0, 14, 14, frame)

    Make("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Input",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.Gotham,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 14,
    }, frame)

    local box = Make("TextBox", {
        Size             = UDim2.new(1, 0, 0, 30),
        Position         = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = HexToColor3(T.BG),
        TextColor3       = HexToColor3(T.Text),
        PlaceholderText  = cfg.Placeholder or "0",
        PlaceholderColor3= HexToColor3(T.Sub),
        Font             = Enum.Font.GothamMono,
        TextSize         = 14,
        ClearTextOnFocus = true,
        ZIndex           = 14,
        Text             = tostring(val.Value),
    }, frame)
    MakeCorner(8, box)
    MakeStroke(HexToColor3(T.Border), 1, box)
    MakePad(0, 0, 8, 8, box)

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            val.Value = n
            pcall(cfg.Callback or function() end, n)
        else
            box.Text = tostring(val.Value)
        end
    end)

    RegisterElement(self._library, cfg.Name or "Input", self, frame, val, function(v)
        val.Value = tonumber(v) or 0
        box.Text  = tostring(val.Value)
        pcall(cfg.Callback or function() end, val.Value)
    end)
    return frame
end

-- ─── MULTI-TOGGLE (checkbox) ──────────────────────────────
function TabAPI:AddMultiToggle(cfg)
    local T    = self._T
    local opts = cfg.Options or {}
    local sel  = cfg.Default or {}
    local val  = Instance.new("StringValue")
    val.Value  = HttpService:JSONEncode(sel)

    local outer = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 44 + #opts * 32),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, outer)
    MakeStroke(HexToColor3(T.Border), 1, outer)
    MakePad(0, 8, 14, 14, outer)
    MakeList(4, outer)

    Make("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text             = cfg.Name or "Multi Toggle",
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 14,
    }, outer)

    local states = {}
    for _, opt in ipairs(opts) do
        states[opt] = table.find(sel, opt) ~= nil

        local row = Make("Frame", {
            Size             = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            ZIndex           = 14,
        }, outer)

        Make("TextLabel", {
            Size             = UDim2.new(1, -40, 1, 0),
            BackgroundTransparency = 1,
            Text             = opt,
            TextColor3       = HexToColor3(T.Sub),
            Font             = Enum.Font.Gotham,
            TextSize         = 13,
            TextXAlignment   = Enum.TextXAlignment.Left,
            ZIndex           = 15,
        }, row)

        local cb = Make("Frame", {
            Size             = UDim2.new(0, 20, 0, 20),
            Position         = UDim2.new(1, -28, 0.5, -10),
            BackgroundColor3 = states[opt] and T.Glow or HexToColor3(T.Border),
            ZIndex           = 15,
        }, row)
        MakeCorner(5, cb)

        local check = Make("TextLabel", {
            Size                = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text                = states[opt] and "✓" or "",
            TextColor3          = Color3.new(1,1,1),
            Font                = Enum.Font.GothamBold,
            TextSize            = 14,
            ZIndex              = 16,
        }, cb)

        local function UpdateSel()
            local list = {}
            for k, v2 in pairs(states) do
                if v2 then table.insert(list, k) end
            end
            val.Value = HttpService:JSONEncode(list)
            pcall(cfg.Callback or function() end, list)
        end

        local btn2 = Make("TextButton", {
            Size                = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text                = "",
            ZIndex              = 17,
        }, row)
        btn2.MouseButton1Click:Connect(function()
            states[opt] = not states[opt]
            Tween(cb, TweenInfo.new(0.15), {BackgroundColor3 = states[opt] and T.Glow or HexToColor3(T.Border)})
            check.Text = states[opt] and "✓" or ""
            UpdateSel()
        end)
    end

    RegisterElement(self._library, cfg.Name or "MultiToggle", self, outer, val, function(v)
        local ok3, list = pcall(function() return HttpService:JSONDecode(v) end)
        if ok3 then
            for _, opt in ipairs(opts) do
                states[opt] = table.find(list, opt) ~= nil
            end
        end
    end)
    return outer
end

-- ─── PARAGRAPH ────────────────────────────────────────────
function TabAPI:AddParagraph(cfg)
    local T    = self._T
    local text = cfg.Content or cfg.Name or ""
    local lines = math.ceil(#text / 55) + 1
    local height = math.max(50, lines * 18 + 20)

    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 13,
    }, self._container)
    MakeCorner(10, frame)
    MakePad(10, 10, 14, 14, frame)

    Make("TextLabel", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text             = text,
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize         = 13,
        TextWrapped      = true,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextYAlignment   = Enum.TextYAlignment.Top,
        RichText         = true,
        ZIndex           = 14,
    }, frame)

    return frame
end

-- ─── NOTIFICATION ─────────────────────────────────────────
function Library:Notify(cfg)
    local T    = self._theme
    local title= cfg.Title    or "Notificação"
    local desc = cfg.Description or ""
    local dur  = cfg.Duration or 4
    local icon = cfg.Icon     or "ℹ️"

    local notif = Make("Frame", {
        Size             = UDim2.new(0, 300, 0, 70),
        Position         = UDim2.new(1, -310, 1, -80),
        BackgroundColor3 = HexToColor3(T.Surface),
        ZIndex           = 500,
    }, self._gui)
    MakeCorner(12, notif)
    MakeStroke(T.Glow, 1.5, notif)

    -- Accent bar
    Make("Frame", {
        Size             = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = T.Glow,
        ZIndex           = 501,
    }, notif)

    Make("TextLabel", {
        Size             = UDim2.new(1, -20, 0, 26),
        Position         = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text             = icon .. "  " .. title,
        TextColor3       = HexToColor3(T.Text),
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 501,
    }, notif)

    Make("TextLabel", {
        Size             = UDim2.new(1, -20, 0, 22),
        Position         = UDim2.new(0, 14, 0, 34),
        BackgroundTransparency = 1,
        Text             = desc,
        TextColor3       = HexToColor3(T.Sub),
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 501,
    }, notif)

    -- Progress bar
    local pb = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 3),
        Position         = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = T.Glow,
        ZIndex           = 501,
    }, notif)
    MakeCorner(2, pb)

    -- Slide in
    notif.Position = UDim2.new(1, 10, 1, -80)
    Tween(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 1, -80),
    })
    Tween(pb, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)})

    task.delay(dur, function()
        TweenWait(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 1, -80),
        })
        notif:Destroy()
    end)
end

-- ============================================================
-- RETURN
-- ============================================================
return Library

--[[
    ═══════════════════════════════════════════════════════════
    EXEMPLO DE USO:
    ═══════════════════════════════════════════════════════════

    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Elison999/Neon-Lira-V2-lib/7f9ca6d43d2588da20ca7f317667a2a46654ffe6/Library.Lua"))()

    local Window = Library.new({
        -- Key System
        KeySystem       = true,
        KeyName         = "LOH HUB | Key System",
        Key             = "LOH_HUB.GG",
        AutoSaveKey     = true,
        AutoLoadKey     = true,
        GetKeybyWebsite = true,
        WebSite         = "https://pastebin.com/SeuLink",
        -- Loading
        DecalId         = "7148140395",
        LoadingName     = "Welcome Back!!",
        -- UI
        Title           = "LOH HUB",
        SubTitle        = "LOH_HUB.GG",
        Theme           = "Neon Void",
    })

    -- Adiciona tabs
    local MainTab = Window:AddTab("Main", "🏠")
    local AimbotTab = Window:AddTab("Aimbot", "🎯")
    local VisualTab = Window:AddTab("Visuals", "👁")
    local MiscTab = Window:AddTab("Misc", "⚙")
    local ConfigTab = Window:AddConfig()

    -- Seção
    MainTab:AddSection({ Name = "Player" })

    -- Toggle
    MainTab:AddToggle({
        Name = "God Mode",
        Default = false,
        Callback = function(val)
            print("GodMode:", val)
        end
    })

    -- Slider
    MainTab:AddSlider({
        Name = "WalkSpeed",
        Min = 16, Max = 250, Default = 16,
        Suffix = " sp",
        Callback = function(val)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    })

    -- Dropdown
    MainTab:AddDropdown({
        Name = "Team",
        Options = {"Innocents", "Sheriffs", "Murderer"},
        Default = "Innocents",
        Callback = function(val)
            print("Team:", val)
        end
    })

    -- Color Picker
    MainTab:AddColorPicker({
        Name = "ESP Color",
        Default = Color3.fromRGB(255, 50, 50),
        Callback = function(col)
            print("Color:", col)
        end
    })

    -- Keybind
    MainTab:AddKeybind({
        Name = "Toggle Menu",
        Default = Enum.KeyCode.RightShift,
        OnPress = function()
            Window:Toggle()
        end,
        Callback = function(key)
            print("Key set:", key)
        end
    })

    -- MultiToggle
    MainTab:AddMultiToggle({
        Name = "ESP Options",
        Options = {"Names", "Health", "Distance", "Boxes"},
        Default = {"Names"},
        Callback = function(selected)
            print("Selected:", table.concat(selected, ", "))
        end
    })

    -- Button
    MainTab:AddButton({
        Name = "🚀  Executar Script",
        Callback = function()
            Window:Notify({
                Title = "Executado!",
                Description = "Script rodando com sucesso.",
                Duration = 3,
                Icon = "✅"
            })
        end
    })

    -- Textbox
    MainTab:AddTextbox({
        Name = "Player Alvo",
        Placeholder = "Nome do player...",
        Default = "",
        Callback = function(text)
            print("Alvo:", text)
        end
    })

    -- Label
    local lbl = MainTab:AddLabel({ Name = "Status: Inativo" })
    task.delay(2, function()
        lbl:Set("<font color='#22c55e'>Status: Ativo ✓</font>")
    end)

    -- Paragraph
    MainTab:AddParagraph({
        Content = "Bem-vindo ao LOH HUB! Use as abas para navegar pelas funcionalidades. Pressione RightShift para abrir/fechar a UI."
    })

    -- Input numérico
    MainTab:AddInput({
        Name = "Jump Power",
        Default = 50,
        Placeholder = "Digite o valor...",
        Callback = function(val)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
        end
    })

    -- Notificação inicial
    Window:Notify({
        Title = "LOH HUB Carregado!",
        Description = "Bem-vindo, " .. game.Players.LocalPlayer.Name,
        Duration = 5,
        Icon = "🎉"
    })
--]]
