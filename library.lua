--[[
    Library.lua (v4.0 ULTRA)
    Criado por josivania
    Framework estilo Rayfield/Kavo/Orion — 100% otimizado
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

Library.Theme = {
    Background = Color3.fromRGB(20,20,20),
    Sidebar = Color3.fromRGB(25,25,25),
    TopBar = Color3.fromRGB(30,30,30),
    Accent = Color3.fromRGB(0,170,255),
    Text = Color3.fromRGB(255,255,255)
}

-- Tween Shortcut
local function tween(o, t, p)
    TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad), p):Play()
end

-- Ripple Effect
local function ripple(btn)
    local r = Instance.new("Frame")
    r.BackgroundColor3 = Color3.fromRGB(255,255,255)
    r.BackgroundTransparency = 0.8
    r.Size = UDim2.new(0,0,0,0)
    r.Position = UDim2.new(0.5,0,0.5,0)
    r.AnchorPoint = Vector2.new(0.5,0.5)
    r.ZIndex = 10
    r.BorderSizePixel = 0
    r.Parent = btn

    tween(r,0.4,{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1})
    task.delay(0.45,function() r:Destroy() end)
end

------------------------------------------------------------
-- CRIAR JANELA
------------------------------------------------------------
function Library:CreateWindow(c)
    c = c or {}
    local title = c.Title or "Josivania Hub"
    local sx, sy = c.SizeX or 520, c.SizeY or 360

    local ui = Instance.new("ScreenGui")
    ui.Parent = game.CoreGui
    ui.Name = "JOSIVANIA_UI"

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,sx,0,sy)
    main.Position = UDim2.new(0.5,-sx/2,0.5,-sy/2)
    main.BackgroundColor3 = Library.Theme.Background
    main.BorderSizePixel = 0
    main.Parent = ui

    -- Animação
    main.Size = UDim2.new(0,sx,0,0)
    tween(main,0.3,{Size=UDim2.new(0,sx,0,sy)})

    -- Topbar
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1,0,0,45)
    top.BackgroundColor3 = Library.Theme.TopBar
    top.Parent = main

    local ttxt = Instance.new("TextLabel")
    ttxt.Size = UDim2.new(1,-20,1,0)
    ttxt.Position = UDim2.new(0,10,0,0)
    ttxt.Text = title
    ttxt.Font = Enum.Font.GothamBold
    ttxt.TextSize = 20
    ttxt.TextColor3 = Library.Theme.Text
    ttxt.BackgroundTransparency = 1
    ttxt.Parent = top

    -- Sidebar
    local side = Instance.new("Frame")
    side.Size = UDim2.new(0,135,1,-45)
    side.Position = UDim2.new(0,0,0,45)
    side.BackgroundColor3 = Library.Theme.Sidebar
    side.Parent = main

    -- Holder para páginas
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1,-135,1,-45)
    holder.Position = UDim2.new(0,135,0,45)
    holder.BackgroundTransparency = 1
    holder.Parent = main

    local pages = {}
    local buttons = {}

    -------------------------------------------------------
    -- Criar Página
    -------------------------------------------------------
    function Library:CreatePage(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,40)
        btn.BackgroundColor3 = Library.Theme.Sidebar
        btn.Text = name
        btn.TextColor3 = Library.Theme.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.Parent = side

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1,0,1,0)
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.ScrollBarThickness = 4
        page.Visible = false
        page.BackgroundTransparency = 1
        page.Parent = holder

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0,8)
        layout.Parent = page

        page.ChildAdded:Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
        end)

        btn.MouseButton1Click:Connect(function()
            ripple(btn)
            for _,p in ipairs(pages) do p.Visible = false end
            for _,b in ipairs(buttons) do b.BackgroundColor3 = Library.Theme.Sidebar end
            btn.BackgroundColor3 = Library.Theme.Accent
            page.Visible = true
        end)

        table.insert(pages,page)
        table.insert(buttons,btn)

        if #pages == 1 then btn:MouseButton1Click() end

        ---------------------------------------------------
        -- COMPONENTES
        ---------------------------------------------------

        function page:AddButton(text,callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,-10,0,36)
            b.BackgroundColor3 = Color3.fromRGB(40,40,40)
            b.Text = text
            b.TextColor3 = Library.Theme.Text
            b.Font = Enum.Font.GothamBold
            b.TextSize = 14
            b.Parent = page

            b.MouseButton1Click:Connect(function()
                ripple(b)
                tween(b,0.1,{BackgroundColor3 = Library.Theme.Accent})
                task.wait(0.15)
                tween(b,0.1,{BackgroundColor3 = Color3.fromRGB(40,40,40)})
                if callback then pcall(callback) end
            end)
        end

        function page:AddToggle(text,default,callback)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1,-10,0,36)
            f.BackgroundColor3 = Color3.fromRGB(40,40,40)
            f.Parent = page

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7,0,1,0)
            label.Text = text
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextColor3 = Library.Theme.Text
            label.BackgroundTransparency = 1
            label.Parent = f

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.3,-5,0,24)
            btn.Position = UDim2.new(0.7,5,0.5,-12)
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.Parent = f

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0,20,0,20)
            knob.Position = UDim2.new(0,2,0.5,-10)
            knob.BackgroundColor3 = Color3.fromRGB(150,150,150)
            knob.Parent = btn

            local state = default or false

            local function update()
                if state then
                    tween(btn,0.15,{BackgroundColor3=Library.Theme.Accent})
                    tween(knob,0.15,{Position=UDim2.new(1,-22,0.5,-10)})
                else
                    tween(btn,0.15,{BackgroundColor3=Color3.fromRGB(60,60,60)})
                    tween(knob,0.15,{Position=UDim2.new(0,2,0.5,-10)})
                end
            end

            update()

            btn.MouseButton1Click:Connect(function()
                state = not state
                update()
                if callback then pcall(callback,state) end
            end)
        end

        function page:AddDropdown(text,list,callback)
            local d = Instance.new("TextButton")
            d.Size = UDim2.new(1,-10,0,36)
            d.BackgroundColor3 = Color3.fromRGB(40,40,40)
            d.Text = text .. " ▼"
            d.TextColor3 = Library.Theme.Text
            d.Font = Enum.Font.GothamBold
            d.TextSize = 14
            d.Parent = page

            local open = false
            d.MouseButton1Click:Connect(function()
                if open then
                    open = false
                    for _,item in ipairs(d:GetChildren()) do
                        if item:IsA("TextButton") then item:Destroy() end
                    end
                else
                    open = true
                    for _,v in ipairs(list) do
                        local opt = Instance.new("TextButton")
                        opt.Size = UDim2.new(1,-10,0,30)
                        opt.Position = UDim2.new(0,0,0,36)
                        opt.BackgroundColor3 = Color3.fromRGB(50,50,50)
                        opt.Text = v
                        opt.TextColor3 = Library.Theme.Text
                        opt.Parent = d

                        opt.MouseButton1Click:Connect(function()
                            d.Text = text .. ": " .. v
                            open = false
                            for _,item in ipairs(d:GetChildren()) do
                                if item:IsA("TextButton") then item:Destroy() end
                            end
                            if callback then pcall(callback,v) end
                        end)
                    end
                end
            end)
        end

        return page
    end

    -------------------------------------------------------
    -- Sistema de Notificações
    -------------------------------------------------------
    function Library:Notify(msg,time)
        local n = Instance.new("TextLabel")
        n.Size = UDim2.new(0,280,0,40)
        n.Position = UDim2.new(1,-300,1,-50)
        n.Text = msg
        n.TextColor3 = Library.Theme.Text
        n.TextSize = 15
        n.Font = Enum.Font.GothamBold
        n.BackgroundColor3 = Library.Theme.TopBar
        n.Parent = ui

        tween(n,0.3,{Position=UDim2.new(1,-300,1,-120)})
        task.wait(time or 3)
        tween(n,0.3,{Position=UDim2.new(1,0,1,0)})
        task.wait(0.4)
        n:Destroy()
    end

    return Library
end

return Library
