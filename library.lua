--[[
    JOSIVANIA UI LIBRARY - V6 ULTRA PREMIUM
    ESTILO SIRIUS / RAYFIELD
    Accent: Azul Neon
    Melhor biblioteca já criada aqui.
    Feita para o josivania.
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

Library.Theme = {
    Background = Color3.fromRGB(18,18,18),
    Topbar = Color3.fromRGB(25,25,25),
    Accent = Color3.fromRGB(0,162,255),
    Text = Color3.fromRGB(255,255,255),
    Button = Color3.fromRGB(30,30,30),
    Component = Color3.fromRGB(35,35,35)
}

local function Tween(o,t,p) TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play() end

---------------------------------------------------------------------
--  DRAG COM FÍSICA
---------------------------------------------------------------------
local function MakeDraggable(frame, dragger)
    local dragging, dragInput, startPos, startInput

    dragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = frame.Position
            startInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    dragger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startInput.Position
            Tween(frame,0.12,{
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            })
        end
    end)
end

---------------------------------------------------------------------
--  NOTIFICAÇÕES RAYFIELD STYLE
---------------------------------------------------------------------
function Library:Notify(title, text, time)
    time = time or 3

    local sg = Instance.new("ScreenGui", game.CoreGui)
    sg.ResetOnSpawn = false

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0,260,0,80)
    box.Position = UDim2.new(1,-270,1,-100)
    box.BackgroundColor3 = Library.Theme.Topbar
    box.BorderSizePixel = 0
    box.Parent = sg
    box.BackgroundTransparency = 1

    Tween(box,0.3,{BackgroundTransparency = 0})

    local Title = Instance.new("TextLabel",box)
    Title.Size = UDim2.new(1,-20,0,25)
    Title.Position = UDim2.new(0,10,0,8)
    Title.Text = title
    Title.TextColor3 = Library.Theme.Accent
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    Title.TextSize = 18

    local Subtitle = Instance.new("TextLabel",box)
    Subtitle.Size = UDim2.new(1,-20,0,25)
    Subtitle.Position = UDim2.new(0,10,0,35)
    Subtitle.Text = text
    Subtitle.TextColor3 = Library.Theme.Text
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.BackgroundTransparency = 1
    Subtitle.TextSize = 15
    Subtitle.TextWrapped = true

    Tween(box,0.3,{Position = UDim2.new(1,-270,1,-170)})

    task.delay(time,function()
        Tween(box,0.3,{BackgroundTransparency=1,Position = UDim2.new(1,-270,1,-100)})
        task.wait(0.35)
        sg:Destroy()
    end)
end

---------------------------------------------------------------------
--  CRIAR JANELA PRINCIPAL
---------------------------------------------------------------------
function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Josivania Hub"
    local sx = cfg.SizeX or 520
    local sy = cfg.SizeY or 380

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0,sx,0,sy)
    Main.Position = UDim2.new(0.5,-sx/2,0.5,-sy/2)
    Main.BackgroundColor3 = Library.Theme.Background
    Main.Parent = ScreenGui
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true

    Main.Size = UDim2.new(0,sx,0,0)
    Tween(Main,0.3,{Size = UDim2.new(0,sx,0,sy)})

    local Top = Instance.new("Frame",Main)
    Top.Size = UDim2.new(1,0,0,42)
    Top.BackgroundColor3 = Library.Theme.Topbar
    Top.BorderSizePixel = 0

    MakeDraggable(Main,Top)

    local Title = Instance.new("TextLabel",Top)
    Title.Size = UDim2.new(1,-20,1,0)
    Title.Position = UDim2.new(0,10,0,0)
    Title.Text = title
    Title.TextColor3 = Library.Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 19
    Title.BackgroundTransparency = 1

    local Side = Instance.new("Frame",Main)
    Side.Size = UDim2.new(0,130,1,-42)
    Side.Position = UDim2.new(0,0,0,42)
    Side.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Side.BorderSizePixel = 0

    local PageHolder = Instance.new("Frame",Main)
    PageHolder.Size = UDim2.new(1,-130,1,-42)
    PageHolder.Position = UDim2.new(0,130,0,42)
    PageHolder.BackgroundTransparency = 1

    local pages = {}
    local buttons = {}

    -----------------------------------------------------------------
    -- NOVA PÁGINA
    -----------------------------------------------------------------
    function Library:CreatePage(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1,0,1,0)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarThickness = 4
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.Parent = PageHolder

        local Layout = Instance.new("UIListLayout",Page)
        Layout.Padding = UDim.new(0,10)

        Page.ChildAdded:Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+20)
        end)

        table.insert(pages,Page)

        local Btn = Instance.new("TextButton",Side)
        Btn.Size = UDim2.new(1,0,0,36)
        Btn.Text = name
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 15
        Btn.TextColor3 = Library.Theme.Text
        Btn.BackgroundColor3 = Library.Theme.Button
        Btn.BorderSizePixel = 0

        Btn.MouseButton1Click:Connect(function()
            for _,p in ipairs(pages) do p.Visible = false end
            Page.Visible = true

            for _,b in ipairs(buttons) do
                Tween(b,0.15,{BackgroundColor3 = Library.Theme.Button})
            end

            Tween(Btn,0.15,{BackgroundColor3 = Library.Theme.Accent})
        end)

        table.insert(buttons,Btn)

        if #pages == 1 then Btn:MouseButton1Click() end

        return Page
    end

    -----------------------------------------------------------------
    -- COMPONENTES: BOTÃO
    -----------------------------------------------------------------
    function Library:AddButton(parent,text,callback)
        local Btn = Instance.new("TextButton",parent)
        Btn.Size = UDim2.new(1,-10,0,38)
        Btn.BackgroundColor3 = Library.Theme.Component
        Btn.Text = text
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 15
        Btn.TextColor3 = Library.Theme.Text
        Btn.BorderSizePixel = 0

        Btn.MouseButton1Click:Connect(function()
            Tween(Btn,0.1,{BackgroundColor3=Library.Theme.Accent})
            task.wait(0.15)
            Tween(Btn,0.1,{BackgroundColor3=Library.Theme.Component})
            if callback then pcall(callback) end
        end)
    end

    -----------------------------------------------------------------
    -- TOGGLE 3.0
    -----------------------------------------------------------------
    function Library:AddToggle(parent,text,default,callback)
        local Holder = Instance.new("Frame",parent)
        Holder.Size = UDim2.new(1,-10,0,38)
        Holder.BackgroundColor3 = Library.Theme.Component
        Holder.BorderSizePixel = 0

        local Label = Instance.new("TextLabel",Holder)
        Label.Position = UDim2.new(0,10,0,0)
        Label.Size = UDim2.new(1,-60,1,0)
        Label.Text = text
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 15
        Label.TextColor3 = Library.Theme.Text
        Label.BackgroundTransparency = 1

        local Toggle = Instance.new("Frame",Holder)
        Toggle.Size = UDim2.new(0,40,0,20)
        Toggle.Position = UDim2.new(1,-50,0.5,-10)
        Toggle.BackgroundColor3 = Color3.fromRGB(55,55,55)
        Toggle.BorderSizePixel = 0

        local Knob = Instance.new("Frame",Toggle)
        Knob.Size = UDim2.new(0,18,0,18)
        Knob.Position = UDim2.new(0,1,0,1)
        Knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
        Knob.BorderSizePixel = 0

        local state = default or false

        local function Update()
            if state then
                Tween(Knob,0.15,{Position=UDim2.new(1,-19,0,1)})
                Tween(Toggle,0.15,{BackgroundColor3=Library.Theme.Accent})
            else
                Tween(Knob,0.15,{Position=UDim2.new(0,1,0,1)})
                Tween(Toggle,0.15,{BackgroundColor3=Color3.fromRGB(55,55,55)})
            end
        end

        Update()

        Holder.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                Update()
                if callback then pcall(callback,state) end
            end
        end)
    end

    -----------------------------------------------------------------
    -- SLIDER REAL
    -----------------------------------------------------------------
    function Library:AddSlider(parent,text,min,max,default,callback)
        local Holder = Instance.new("Frame",parent)
        Holder.Size = UDim2.new(1,-10,0,60)
        Holder.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel",Holder)
        Label.Size = UDim2.new(1,0,0,25)
        Label.Text = text.." : "..default
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 15
        Label.TextColor3 = Library.Theme.Text
        Label.BackgroundTransparency = 1

        local Bar = Instance.new("Frame",Holder)
        Bar.Size = UDim2.new(1,-10,0,6)
        Bar.Position = UDim2.new(0,5,0,35)
        Bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Bar.BorderSizePixel = 0

        local Fill = Instance.new("Frame",Bar)
        Fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        Fill.BackgroundColor3 = Library.Theme.Accent
        Fill.BorderSizePixel = 0

        local dragging = false
        Bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)

        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)

        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                local pos = (i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
                pos = math.clamp(pos,0,1)
                Tween(Fill,0.05,{Size = UDim2.new(pos,0,1,0)})
                local val = math.floor(min + (max-min)*pos)
                Label.Text = text.." : "..val
                if callback then pcall(callback,val) end
            end
        end)
    end

    -----------------------------------------------------------------
    -- DROPDOWN PREMIUM
    -----------------------------------------------------------------
    function Library:AddDropdown(parent,text,list,callback)
        local Holder = Instance.new("Frame",parent)
        Holder.Size = UDim2.new(1,-10,0,40)
        Holder.BackgroundColor3 = Library.Theme.Component
        Holder.BorderSizePixel = 0

        local Label = Instance.new("TextLabel",Holder)
        Label.Size = UDim2.new(1,-30,1,0)
        Label.Position = UDim2.new(0,10,0,0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 15
        Label.TextColor3 = Library.Theme.Text
        Label.Text = text

        local Arrow = Instance.new("TextLabel",Holder)
        Arrow.Size = UDim2.new(0,20,0,20)
        Arrow.Position = UDim2.new(1,-25,0.5,-10)
        Arrow.BackgroundTransparency = 1
        Arrow.TextColor3 = Library.Theme.Text
        Arrow.Font = Enum.Font.GothamBold
        Arrow.TextSize = 18
        Arrow.Text = ">"

        local Open = false
        local Menu

        Holder.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                Open = not Open
                Arrow.Rotation = Open and 90 or 0

                if Open then
                    if Menu then Menu:Destroy() end

                    Menu = Instance.new("Frame",parent)
                    Menu.Size = UDim2.new(1,-10,0,#list*32)
                    Menu.BackgroundColor3 = Color3.fromRGB(25,25,25)
                    Menu.BorderSizePixel = 0

                    local Layout = Instance.new("UIListLayout",Menu)
                    Layout.Padding = UDim.new(0,5)

                    for _,v in ipairs(list) do
                        local Opt = Instance.new("TextButton",Menu)
                        Opt.Size = UDim2.new(1,0,0,30)
                        Opt.BackgroundColor3 = Color3.fromRGB(40,40,40)
                        Opt.TextColor3 = Library.Theme.Text
                        Opt.Font = Enum.Font.Gotham
                        Opt.TextSize = 14
                        Opt.Text = v
                        Opt.BorderSizePixel = 0

                        Opt.MouseButton1Click:Connect(function()
                            Label.Text = text.." : "..v
                            if callback then pcall(callback,v) end
                            Open = false
                            Arrow.Rotation = 0
                            Menu:Destroy()
                        end)
                    end
                else
                    if Menu then Menu:Destroy() end
                end
            end
        end)
    end

    -----------------------------------------------------------------
    -- KEYBIND PREMIUM
    -----------------------------------------------------------------
    function Library:AddKeybind(parent,text,defaultKey,callback)
        local Btn = Instance.new("TextButton",parent)
        Btn.Size = UDim2.new(1,-10,0,38)
        Btn.BackgroundColor3 = Library.Theme.Component
        Btn.TextColor3 = Library.Theme.Text
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 15
        Btn.Text = text.." : ["..defaultKey.."]"
        Btn.BorderSizePixel = 0

        local waiting = false
        Btn.MouseButton1Click:Connect(function()
            waiting = true
            Btn.Text = text.." : [...]"
        end)

        UIS.InputBegan:Connect(function(i)
            if waiting and i.KeyCode ~= Enum.KeyCode.Unknown then
                waiting = false
                local key = tostring(i.KeyCode):gsub("Enum.KeyCode.","")
                Btn.Text = text.." : ["..key.."]"
                callback(i.KeyCode)
            end
        end)

        UIS.InputBegan:Connect(function(i)
            if i.KeyCode == Enum.KeyCode[defaultKey] then
                callback(i.KeyCode)
            end
        end)
    end

    return Library
end

return Library
