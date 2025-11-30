--[[
    Library.lua (v2.0 PRO)
    Criado por josivania

    UI Framework estilo Orion/Kavo
    Múltiplas Páginas + Botões + Toggles + Sliders
]]

local Library = {}
Library.Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    TopBar = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

local TweenService = game:GetService("TweenService")

--========================================================
-- Tween Shortcut
--========================================================
local function tween(object, time, props)
    TweenService:Create(object, TweenInfo.new(time, Enum.EasingStyle.Quad), props):Play()
end

--========================================================
-- Criar Janela
--========================================================
function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Mega Hub"
    local sizeX = config.SizeX or 500
    local sizeY = config.SizeY or 350

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, sizeX, 0, sizeY)
    Main.Position = UDim2.new(0.5, -sizeX/2, 0.5, -sizeY/2)
    Main.BackgroundColor3 = Library.Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    -- Animação de entrada
    Main.Size = UDim2.new(0, sizeX, 0, 0)
    tween(Main, 0.3, {Size = UDim2.new(0, sizeX, 0, sizeY)})

    -- Topbar
    local Top = Instance.new("Frame")
    Top.Size = UDim2.new(1, 0, 0, 45)
    Top.BackgroundColor3 = Library.Theme.TopBar
    Top.BorderSizePixel = 0
    Top.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = title
    Title.TextColor3 = Library.Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1
    Title.Parent = Top

    -- Aba lateral
    local Side = Instance.new("Frame")
    Side.Size = UDim2.new(0, 130, 1, -45)
    Side.Position = UDim2.new(0, 0, 0, 45)
    Side.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Side.BorderSizePixel = 0
    Side.Parent = Main

    local PageHolder = Instance.new("Frame")
    PageHolder.Size = UDim2.new(1, -130, 1, -45)
    PageHolder.Position = UDim2.new(0, 130, 0, 45)
    PageHolder.BackgroundTransparency = 1
    PageHolder.Parent = Main

    local pages = {}
    local buttons = {}

    -- Criar página
    local function newPage(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 4
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = PageHolder

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 8)
        Layout.Parent = Page

        Page.ChildAdded:Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
        end)

        table.insert(pages, Page)

        return Page
    end

    -- Criar botão de página
    function Library:CreatePage(name)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 36)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Btn.Text = name
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 15
        Btn.TextColor3 = Library.Theme.Text
        Btn.Parent = Side

        local Page = newPage(name)

        Btn.MouseButton1Click:Connect(function()
            for _, p in ipairs(pages) do p.Visible = false end
            Page.Visible = true

            for _, b in ipairs(buttons) do b.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end
            Btn.BackgroundColor3 = Library.Theme.Accent
        end)

        table.insert(buttons, Btn)
        if #pages == 1 then Btn:MouseButton1Click() end

        return Page
    end

    -- COMPONENTES UI
    function Library:AddButton(parent, text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Btn.Text = text
        Btn.TextColor3 = Library.Theme.Text
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 14
        Btn.Parent = parent

        Btn.MouseButton1Click:Connect(function()
            tween(Btn, 0.1, {BackgroundColor3 = Library.Theme.Accent})
            task.wait(0.15)
            tween(Btn, 0.1, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})

            if callback then pcall(callback) end
        end)
    end

    -- TOGGLE
    function Library:AddToggle(parent, text, default, callback)
        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(1, -10, 0, 35)
        Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Toggle.Text = text .. " : OFF"
        Toggle.TextColor3 = Library.Theme.Text
        Toggle.Font = Enum.Font.GothamBold
        Toggle.TextSize = 14
        Toggle.Parent = parent

        local state = default or false
        if state then Toggle.Text = text .. " : ON" end

        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = text .. (state and " : ON" or " : OFF")
            if callback then pcall(callback, state) end
        end)
    end

    return Library
end

return Library
