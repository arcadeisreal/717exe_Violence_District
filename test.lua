--[[
    Modern UI Hub Library
    Style berbeda dari Rayfield dan WindUI
    Dibuat dengan sistem modular dan customizable
]]

local ModernUI = {}
ModernUI.__index = ModernUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Create Main Hub
function ModernUI:CreateHub(config)
    config = config or {}
    local hub = {
        Name = config.Name or "Modern UI Hub",
        KeySystem = config.KeySystem or false,
        Key = config.Key or "",
        Theme = config.Theme or "Dark",
        Windows = {}
    }
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernUIHub"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- Main Container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(80, 70, 150)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.5
    mainStroke.Parent = mainFrame
    
    -- Animate Open
    Tween(mainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back)
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundColor3 = Color3.fromRGB(100, 70, 200)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 16)
    topBarCorner.Parent = topBar
    
    local topBarGradient = Instance.new("UIGradient")
    topBarGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
    }
    topBarGradient.Rotation = 45
    topBarGradient.Parent = topBar
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 400, 1, 0)
    titleLabel.Position = UDim2.new(0, 60, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = hub.Name
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Parent = topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        screenGui:Destroy()
    end)
    
    closeButton.MouseEnter:Connect(function()
        Tween(closeButton, {BackgroundColor3 = Color3.fromRGB(220, 80, 80)}, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        Tween(closeButton, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}, 0.2)
    end)
    
    -- Make Draggable
    MakeDraggable(mainFrame, topBar)
    
    -- Content Container
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Tab Container (Sidebar)
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, 0)
    tabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tabContainer
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 8)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.Parent = tabContainer
    
    -- Main Content Container
    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.Size = UDim2.new(1, -170, 1, 0)
    mainContent.Position = UDim2.new(0, 160, 0, 0)
    mainContent.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    mainContent.BorderSizePixel = 0
    mainContent.Parent = contentFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 12)
    contentCorner.Parent = mainContent
    
    -- Hub Functions
    hub.ScreenGui = screenGui
    hub.MainFrame = mainFrame
    hub.TabContainer = tabContainer
    hub.MainContent = mainContent
    
    -- Create Window (Tab)
    function hub:CreateWindow(config)
        config = config or {}
        local window = {
            Name = config.Name or "Window",
            Icon = config.Icon or "🔷",
            Elements = {}
        }
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = window.Name
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        tabButton.Text = "  " .. window.Icon .. "  " .. window.Name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 160)
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Parent = tabContainer
        
        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 8)
        tabBtnCorner.Parent = tabButton
        
        -- Window Content
        local windowContent = Instance.new("ScrollingFrame")
        windowContent.Name = window.Name .. "Content"
        windowContent.Size = UDim2.new(1, -20, 1, -20)
        windowContent.Position = UDim2.new(0, 10, 0, 10)
        windowContent.BackgroundTransparency = 1
        windowContent.BorderSizePixel = 0
        windowContent.ScrollBarThickness = 6
        windowContent.ScrollBarImageColor3 = Color3.fromRGB(139, 92, 246)
        windowContent.Visible = false
        windowContent.Parent = mainContent
        
        local windowList = Instance.new("UIListLayout")
        windowList.Padding = UDim.new(0, 10)
        windowList.SortOrder = Enum.SortOrder.LayoutOrder
        windowList.Parent = windowContent
        
        -- Update canvas size when content changes
        windowList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            windowContent.CanvasSize = UDim2.new(0, 0, 0, windowList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Click
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all windows
            for _, child in pairs(mainContent:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            -- Reset all tab buttons
            for _, btn in pairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
                    btn.TextColor3 = Color3.fromRGB(150, 150, 160)
                end
            end
            
            -- Show selected window
            windowContent.Visible = true
            Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(100, 70, 200)}, 0.2)
            tabButton.TextColor3 = Color3.new(1, 1, 1)
        end)
        
        tabButton.MouseEnter:Connect(function()
            if not windowContent.Visible then
                Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not windowContent.Visible then
                Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
            end
        end)
        
        window.Content = windowContent
        
        -- Create Section
        function window:CreateSection(name)
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Name = "Section"
            sectionLabel.Size = UDim2.new(1, 0, 0, 30)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = "━━ " .. name .. " ━━"
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 14
            sectionLabel.TextColor3 = Color3.fromRGB(139, 92, 246)
            sectionLabel.Parent = windowContent
            
            return sectionLabel
        end
        
        -- Create Button
        function window:CreateButton(config)
            config = config or {}
            
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "ButtonFrame"
            buttonFrame.Size = UDim2.new(1, 0, 0, 40)
            buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Parent = windowContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = buttonFrame
            
            local btnGradient = Instance.new("UIGradient")
            btnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
            }
            btnGradient.Rotation = 45
            btnGradient.Enabled = false
            btnGradient.Parent = buttonFrame
            
            local button = Instance.new("TextButton")
            button.Name = "Button"
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = config.Name or "Button"
            button.Font = Enum.Font.GothamSemibold
            button.TextSize = 14
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Parent = buttonFrame
            
            button.MouseButton1Click:Connect(function()
                btnGradient.Enabled = true
                Tween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(100, 70, 200)}, 0.1)
                wait(0.1)
                Tween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
                btnGradient.Enabled = false
                
                if config.Callback then
                    config.Callback()
                end
            end)
            
            button.MouseEnter:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
            end)
            
            return button
        end
        
        -- Create Toggle
        function window:CreateToggle(config)
            config = config or {}
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "ToggleFrame"
            toggleFrame.Size = UDim2.new(1, 0, 0, 40)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = windowContent
            
            local togCorner = Instance.new("UICorner")
            togCorner.CornerRadius = UDim.new(0, 8)
            togCorner.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Position = UDim2.new(0, 15, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = config.Name or "Toggle"
            toggleLabel.Font = Enum.Font.GothamSemibold
            toggleLabel.TextSize = 14
            toggleLabel.TextColor3 = Color3.new(1, 1, 1)
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggleState = config.Default or false
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(0, 45, 0, 24)
            toggleButton.Position = UDim2.new(1, -55, 0.5, -12)
            toggleButton.BackgroundColor3 = toggleState and Color3.fromRGB(100, 70, 200) or Color3.fromRGB(50, 50, 60)
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            local togBtnCorner = Instance.new("UICorner")
            togBtnCorner.CornerRadius = UDim.new(1, 0)
            togBtnCorner.Parent = toggleButton
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Name = "Circle"
            toggleCircle.Size = UDim2.new(0, 18, 0, 18)
            toggleCircle.Position = toggleState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            toggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            toggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                
                Tween(toggleButton, {
                    BackgroundColor3 = toggleState and Color3.fromRGB(100, 70, 200) or Color3.fromRGB(50, 50, 60)
                }, 0.3)
                
                Tween(toggleCircle, {
                    Position = toggleState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                }, 0.3)
                
                if config.Callback then
                    config.Callback(toggleState)
                end
            end)
            
            toggleFrame.MouseEnter:Connect(function()
                Tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.2)
            end)
            
            toggleFrame.MouseLeave:Connect(function()
                Tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
            end)
            
            return {
                Frame = toggleFrame,
                SetValue = function(value)
                    toggleState = value
                    Tween(toggleButton, {
                        BackgroundColor3 = toggleState and Color3.fromRGB(100, 70, 200) or Color3.fromRGB(50, 50, 60)
                    }, 0.3)
                    Tween(toggleCircle, {
                        Position = toggleState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                    }, 0.3)
                end
            }
        end
        
        -- Create Slider
        function window:CreateSlider(config)
            config = config or {}
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "SliderFrame"
            sliderFrame.Size = UDim2.new(1, 0, 0, 60)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = windowContent
            
            local sldCorner = Instance.new("UICorner")
            sldCorner.CornerRadius = UDim.new(0, 8)
            sldCorner.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "Label"
            sliderLabel.Size = UDim2.new(1, -20, 0, 20)
            sliderLabel.Position = UDim2.new(0, 10, 0, 5)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = config.Name or "Slider"
            sliderLabel.Font = Enum.Font.GothamSemibold
            sliderLabel.TextSize = 14
            sliderLabel.TextColor3 = Color3.new(1, 1, 1)
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.Name = "Value"
            sliderValue.Size = UDim2.new(0, 50, 0, 20)
            sliderValue.Position = UDim2.new(1, -60, 0, 5)
            sliderValue.BackgroundTransparency = 1
            sliderValue.Text = tostring(default)
            sliderValue.Font = Enum.Font.GothamBold
            sliderValue.TextSize = 14
            sliderValue.TextColor3 = Color3.fromRGB(139, 92, 246)
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderBack = Instance.new("Frame")
            sliderBack.Name = "SliderBack"
            sliderBack.Size = UDim2.new(1, -20, 0, 6)
            sliderBack.Position = UDim2.new(0, 10, 1, -20)
            sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            sliderBack.BorderSizePixel = 0
            sliderBack.Parent = sliderFrame
            
            local sldBackCorner = Instance.new("UICorner")
            sldBackCorner.CornerRadius = UDim.new(1, 0)
            sldBackCorner.Parent = sliderBack
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "Fill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBack
            
            local fillGradient = Instance.new("UIGradient")
            fillGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))
            }
            fillGradient.Parent = sliderFill
            
            local sldFillCorner = Instance.new("UICorner")
            sldFillCorner.CornerRadius = UDim.new(1, 0)
            sldFillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Name = "SliderButton"
            sliderButton.Size = UDim2.new(1, 0, 1, 0)
            sliderButton.BackgroundTransparency = 1
            sliderButton.Text = ""
            sliderButton.Parent = sliderBack
            
            local currentValue = default
            local dragging = false
            
            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor((min + (max - min) * sizeX) / increment + 0.5) * increment
                currentValue = math.clamp(currentValue, min, max)
                
                sliderValue.Text = tostring(currentValue)
                Tween(sliderFill, {Size = UDim2.new(sizeX, 0, 1, 0)}, 0.1)
                
                if config.Callback then
                    config.Callback(currentValue)
                end
            end
            
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            sliderButton.MouseButton1Click:Connect(function()
                local mouse = game.Players.LocalPlayer:GetMouse()
                updateSlider(mouse)
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            sliderFrame.MouseEnter:Connect(function()
                Tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.2)
            end)
            
            sliderFrame.MouseLeave:Connect(function()
                Tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
            end)
            
            return {
                Frame = sliderFrame,
                SetValue = function(value)
                    currentValue = math.clamp(value, min, max)
                    sliderValue.Text = tostring(currentValue)
                    local sizeX = (currentValue - min) / (max - min)
                    Tween(sliderFill, {Size = UDim2.new(sizeX, 0, 1, 0)}, 0.3)
                end
            }
        end
        
        -- Create Dropdown
        function window:CreateDropdown(config)
            config = config or {}
            local options = config.Options or {}
            local default = config.Default or (options[1] or "None")
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "DropdownFrame"
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.ClipsDescendants = false
            dropdownFrame.Parent = windowContent
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 8)
            dropCorner.Parent = dropdownFrame
            
            local dropLabel = Instance.new("TextLabel")
            dropLabel.Name = "Label"
            dropLabel.Size = UDim2.new(1, -100, 1, 0)
            dropLabel.Position = UDim2.new(0, 15, 0, 0)
            dropLabel.BackgroundTransparency = 1
            dropLabel.Text = config.Name or "Dropdown"
            dropLabel.Font = Enum.Font.GothamSemibold
            dropLabel.TextSize = 14
            dropLabel.TextColor3 = Color3.new(1, 1, 1)
            dropLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropLabel.Parent = dropdownFrame
            
            local dropButton = Instance.new("TextButton")
            dropButton.Name = "DropButton"
            dropButton.Size = UDim2.new(0, 150, 0, 30)
            dropButton.Position = UDim2.new(1, -160, 0.5, -15)
            dropButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            dropButton.Text = default
            dropButton.Font = Enum.Font.Gotham
            dropButton.TextSize = 12
            dropButton.TextColor3 = Color3.new(1, 1, 1)
            dropButton.Parent = dropdownFrame
            
            local dropBtnCorner = Instance.new("UICorner")
            dropBtnCorner.CornerRadius = UDim.new(0, 6)
            dropBtnCorner.Parent = dropButton
            
            local dropIcon = Instance.new("TextLabel")
            dropIcon.Name = "Icon"
            dropIcon.Size = UDim2.new(0, 20, 1, 0)
            dropIcon.Position = UDim2.new(1, -25, 0, 0)
            dropIcon.BackgroundTransparency = 1
            dropIcon.Text = "▼"
            dropIcon.Font = Enum.Font.GothamBold
            dropIcon.TextSize = 10
            dropIcon.TextColor3 = Color3.fromRGB(139, 92, 246)
            dropIcon.Parent = dropButton
            
            local dropList = Instance.new("Frame")
            dropList.Name = "DropList"
            dropList.Size = UDim2.new(0, 150, 0, 0)
            dropList.Position = UDim2.new(1, -160, 1, 5)
            dropList.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            dropList.BorderSizePixel = 0
            dropList.Visible = false
            dropList.ClipsDescendants = true
            dropList.ZIndex = 10
            dropList.Parent = dropdownFrame
            
            local dropListCorner = Instance.new("UICorner")
            dropListCorner.CornerRadius = UDim.new(0, 6)
            dropListCorner.Parent = dropList
            
            local dropListStroke = Instance.new("UIStroke")
            dropListStroke.Color = Color3.fromRGB(80, 70, 150)
            dropListStroke.Thickness = 1
            dropListStroke.Parent = dropList
            
            local dropListLayout = Instance.new("UIListLayout")
            dropListLayout.Padding = UDim.new(0, 2)
            dropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropListLayout.Parent = dropList
            
            local dropListPadding = Instance.new("UIPadding")
            dropListPadding.PaddingTop = UDim.new(0, 5)
            dropListPadding.PaddingBottom = UDim.new(0, 5)
            dropListPadding.PaddingLeft = UDim.new(0, 5)
            dropListPadding.PaddingRight = UDim.new(0, 5)
            dropListPadding.Parent = dropList
            
            local expanded = false
            local currentValue = default
            
            for _, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option
                optionButton.Size = UDim2.new(1, -10, 0, 25)
                optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                optionButton.Text = option
                optionButton.Font = Enum.Font.Gotham
                optionButton.TextSize = 12
                optionButton.TextColor3 = Color3.new(1, 1, 1)
                optionButton.Parent = dropList
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    currentValue = option
                    dropButton.Text = option
                    expanded = false
                    Tween(dropList, {Size = UDim2.new(0, 150, 0, 0)}, 0.3)
                    Tween(dropIcon, {Rotation = 0}, 0.3)
                    wait(0.3)
                    dropList.Visible = false
                    
                    if config.Callback then
                        config.Callback(option)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    Tween(optionButton, {BackgroundColor3 = Color3.fromRGB(100, 70, 200)}, 0.2)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    Tween(optionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.2)
                end)
            end
            
            dropButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                dropList.Visible = true
                
                if expanded then
                    local listSize = #options * 27 + 10
                    Tween(dropList, {Size = UDim2.new(0, 150, 0, listSize)}, 0.3)
                    Tween(dropIcon, {Rotation = 180}, 0.3)
                else
                    Tween(dropList, {Size = UDim2.new(0, 150, 0, 0)}, 0.3)
                    Tween(dropIcon, {Rotation = 0}, 0.3)
                    wait(0.3)
                    dropList.Visible = false
                end
            end)
            
            dropButton.MouseEnter:Connect(function()
                Tween(dropButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}, 0.2)
            end)
            
            dropButton.MouseLeave:Connect(function()
                Tween(dropButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.2)
            end)
            
            return {
                Frame = dropdownFrame,
                SetValue = function(value)
                    if table.find(options, value) then
                        currentValue = value
                        dropButton.Text = value
                    end
                end
            }
        end
        
        -- Create Input (TextBox)
        function window:CreateInput(config)
            config = config or {}
            
            local inputFrame = Instance.new("Frame")
            inputFrame.Name = "InputFrame"
            inputFrame.Size = UDim2.new(1, 0, 0, 40)
            inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            inputFrame.BorderSizePixel = 0
            inputFrame.Parent = windowContent
            
            local inpCorner = Instance.new("UICorner")
            inpCorner.CornerRadius = UDim.new(0, 8)
            inpCorner.Parent = inputFrame
            
            local inputLabel = Instance.new("TextLabel")
            inputLabel.Name = "Label"
            inputLabel.Size = UDim2.new(0, 100, 1, 0)
            inputLabel.Position = UDim2.new(0, 15, 0, 0)
            inputLabel.BackgroundTransparency = 1
            inputLabel.Text = config.Name or "Input"
            inputLabel.Font = Enum.Font.GothamSemibold
            inputLabel.TextSize = 14
            inputLabel.TextColor3 = Color3.new(1, 1, 1)
            inputLabel.TextXAlignment = Enum.TextXAlignment.Left
            inputLabel.Parent = inputFrame
            
            local textBox = Instance.new("TextBox")
            textBox.Name = "TextBox"
            textBox.Size = UDim2.new(0, 250, 0, 30)
            textBox.Position = UDim2.new(1, -260, 0.5, -15)
            textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            textBox.BorderSizePixel = 0
            textBox.Text = config.Default or ""
            textBox.PlaceholderText = config.Placeholder or "Enter text..."
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 12
            textBox.TextColor3 = Color3.new(1, 1, 1)
            textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
            textBox.ClearTextOnFocus = false
            textBox.Parent = inputFrame
            
            local txtCorner = Instance.new("UICorner")
            txtCorner.CornerRadius = UDim.new(0, 6)
            txtCorner.Parent = textBox
            
            local txtStroke = Instance.new("UIStroke")
            txtStroke.Color = Color3.fromRGB(60, 60, 70)
            txtStroke.Thickness = 1
            txtStroke.Parent = textBox
            
            textBox.Focused:Connect(function()
                Tween(txtStroke, {Color = Color3.fromRGB(139, 92, 246)}, 0.2)
            end)
            
            textBox.FocusLost:Connect(function(enterPressed)
                Tween(txtStroke, {Color = Color3.fromRGB(60, 60, 70)}, 0.2)
                
                if enterPressed and config.Callback then
                    config.Callback(textBox.Text)
                end
            end)
            
            inputFrame.MouseEnter:Connect(function()
                Tween(inputFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.2)
            end)
            
            inputFrame.MouseLeave:Connect(function()
                Tween(inputFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
            end)
            
            return {
                Frame = inputFrame,
                SetValue = function(text)
                    textBox.Text = text
                end
            }
        end
        
        -- Create Keybind
        function window:CreateKeybind(config)
            config = config or {}
            
            local keybindFrame = Instance.new("Frame")
            keybindFrame.Name = "KeybindFrame"
            keybindFrame.Size = UDim2.new(1, 0, 0, 40)
            keybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            keybindFrame.BorderSizePixel = 0
            keybindFrame.Parent = windowContent
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 8)
            keyCorner.Parent = keybindFrame
            
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Name = "Label"
            keyLabel.Size = UDim2.new(1, -100, 1, 0)
            keyLabel.Position = UDim2.new(0, 15, 0, 0)
            keyLabel.BackgroundTransparency = 1
            keyLabel.Text = config.Name or "Keybind"
            keyLabel.Font = Enum.Font.GothamSemibold
            keyLabel.TextSize = 14
            keyLabel.TextColor3 = Color3.new(1, 1, 1)
            keyLabel.TextXAlignment = Enum.TextXAlignment.Left
            keyLabel.Parent = keybindFrame
            
            local currentKey = config.Default or Enum.KeyCode.F
            local listening = false
            
            local keyButton = Instance.new("TextButton")
            keyButton.Name = "KeyButton"
            keyButton.Size = UDim2.new(0, 80, 0, 30)
            keyButton.Position = UDim2.new(1, -90, 0.5, -15)
            keyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            keyButton.Text = currentKey.Name
            keyButton.Font = Enum.Font.GothamBold
            keyButton.TextSize = 12
            keyButton.TextColor3 = Color3.new(1, 1, 1)
            keyButton.Parent = keybindFrame
            
            local keyBtnCorner = Instance.new("UICorner")
            keyBtnCorner.CornerRadius = UDim.new(0, 6)
            keyBtnCorner.Parent = keyButton
            
            local keyStroke = Instance.new("UIStroke")
            keyStroke.Color = Color3.fromRGB(60, 60, 70)
            keyStroke.Thickness = 2
            keyStroke.Parent = keyButton
            
            keyButton.MouseButton1Click:Connect(function()
                listening = true
                keyButton.Text = "..."
                Tween(keyStroke, {Color = Color3.fromRGB(139, 92, 246)}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    keyButton.Text = input.KeyCode.Name
                    Tween(keyStroke, {Color = Color3.fromRGB(60, 60, 70)}, 0.2)
                    
                    if config.Callback then
                        config.Callback(input.KeyCode)
                    end
                end
                
                if not gameProcessed and input.KeyCode == currentKey and config.Callback and not listening then
                    config.Callback(input.KeyCode)
                end
            end)
            
            keyButton.MouseEnter:Connect(function()
                Tween(keyButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}, 0.2)
            end)
            
            keyButton.MouseLeave:Connect(function()
                Tween(keyButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.2)
            end)
            
            return {
                Frame = keybindFrame,
                SetValue = function(keyCode)
                    currentKey = keyCode
                    keyButton.Text = keyCode.Name
                end
            }
        end
        
        -- Create ColorPicker
        function window:CreateColorPicker(config)
            config = config or {}
            local defaultColor = config.Default or Color3.fromRGB(139, 92, 246)
            
            local colorFrame = Instance.new("Frame")
            colorFrame.Name = "ColorFrame"
            colorFrame.Size = UDim2.new(1, 0, 0, 40)
            colorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            colorFrame.BorderSizePixel = 0
            colorFrame.Parent = windowContent
            
            local colCorner = Instance.new("UICorner")
            colCorner.CornerRadius = UDim.new(0, 8)
            colCorner.Parent = colorFrame
            
            local colorLabel = Instance.new("TextLabel")
            colorLabel.Name = "Label"
            colorLabel.Size = UDim2.new(1, -60, 1, 0)
            colorLabel.Position = UDim2.new(0, 15, 0, 0)
            colorLabel.BackgroundTransparency = 1
            colorLabel.Text = config.Name or "Color"
            colorLabel.Font = Enum.Font.GothamSemibold
            colorLabel.TextSize = 14
            colorLabel.TextColor3 = Color3.new(1, 1, 1)
            colorLabel.TextXAlignment = Enum.TextXAlignment.Left
            colorLabel.Parent = colorFrame
            
            local colorDisplay = Instance.new("Frame")
            colorDisplay.Name = "ColorDisplay"
            colorDisplay.Size = UDim2.new(0, 35, 0, 25)
            colorDisplay.Position = UDim2.new(1, -45, 0.5, -12.5)
            colorDisplay.BackgroundColor3 = defaultColor
            colorDisplay.BorderSizePixel = 0
            colorDisplay.Parent = colorFrame
            
            local colDispCorner = Instance.new("UICorner")
            colDispCorner.CornerRadius = UDim.new(0, 6)
            colDispCorner.Parent = colorDisplay
            
            local colDispStroke = Instance.new("UIStroke")
            colDispStroke.Color = Color3.fromRGB(139, 92, 246)
            colDispStroke.Thickness = 2
            colDispStroke.Parent = colorDisplay
            
            local colorButton = Instance.new("TextButton")
            colorButton.Size = UDim2.new(1, 0, 1, 0)
            colorButton.BackgroundTransparency = 1
            colorButton.Text = ""
            colorButton.Parent = colorDisplay
            
            colorButton.MouseButton1Click:Connect(function()
                if config.Callback then
                    -- Simple color picker (you can expand this with a full picker UI)
                    local colors = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(255, 0, 255),
                        Color3.fromRGB(0, 255, 255),
                        Color3.fromRGB(139, 92, 246)
                    }
                    local randomColor = colors[math.random(1, #colors)]
                    colorDisplay.BackgroundColor3 = randomColor
                    config.Callback(randomColor)
                end
            end)
            
            colorFrame.MouseEnter:Connect(function()
                Tween(colorFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.2)
            end)
            
            colorFrame.MouseLeave:Connect(function()
                Tween(colorFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
            end)
            
            return {
                Frame = colorFrame,
                SetValue = function(color)
                    colorDisplay.BackgroundColor3 = color
                end
            }
        end
        
        -- Create Paragraph (Label)
        function window:CreateParagraph(config)
            config = config or {}
            
            local paragraphFrame = Instance.new("Frame")
            paragraphFrame.Name = "ParagraphFrame"
            paragraphFrame.Size = UDim2.new(1, 0, 0, 0)
            paragraphFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            paragraphFrame.BorderSizePixel = 0
            paragraphFrame.Parent = windowContent
            
            local paraCorner = Instance.new("UICorner")
            paraCorner.CornerRadius = UDim.new(0, 8)
            paraCorner.Parent = paragraphFrame
            
            local paragraphLabel = Instance.new("TextLabel")
            paragraphLabel.Name = "Paragraph"
            paragraphLabel.Size = UDim2.new(1, -30, 1, -20)
            paragraphLabel.Position = UDim2.new(0, 15, 0, 10)
            paragraphLabel.BackgroundTransparency = 1
            paragraphLabel.Text = config.Text or "Paragraph text here"
            paragraphLabel.Font = Enum.Font.Gotham
            paragraphLabel.TextSize = 13
            paragraphLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
            paragraphLabel.TextXAlignment = Enum.TextXAlignment.Left
            paragraphLabel.TextYAlignment = Enum.TextYAlignment.Top
            paragraphLabel.TextWrapped = true
            paragraphLabel.Parent = paragraphFrame
            
            -- Auto-size based on text
            local textSize = game:GetService("TextService"):GetTextSize(
                paragraphLabel.Text,
                paragraphLabel.TextSize,
                paragraphLabel.Font,
                Vector2.new(paragraphLabel.AbsoluteSize.X, math.huge)
            )
            paragraphFrame.Size = UDim2.new(1, 0, 0, textSize.Y + 20)
            
            return {
                Frame = paragraphFrame,
                SetText = function(text)
                    paragraphLabel.Text = text
                    local newSize = game:GetService("TextService"):GetTextSize(
                        text,
                        paragraphLabel.TextSize,
                        paragraphLabel.Font,
                        Vector2.new(paragraphLabel.AbsoluteSize.X, math.huge)
                    )
                    paragraphFrame.Size = UDim2.new(1, 0, 0, newSize.Y + 20)
                end
            }
        end
        
        table.insert(hub.Windows, window)
        
        -- Auto-select first window
        if #hub.Windows == 1 then
            wait(0.1)
            windowContent.Visible = true
            Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(100, 70, 200)}, 0.2)
            tabButton.TextColor3 = Color3.new(1, 1, 1)
        end
        
        return window
    end
    
    -- Create Notification System
    function hub:CreateNotification(config)
        config = config or {}
        
        local notifContainer = hub.ScreenGui:FindFirstChild("NotificationContainer")
        if not notifContainer then
            notifContainer = Instance.new("Frame")
            notifContainer.Name = "NotificationContainer"
            notifContainer.Size = UDim2.new(0, 300, 1, -20)
            notifContainer.Position = UDim2.new(1, -310, 0, 10)
            notifContainer.BackgroundTransparency = 1
            notifContainer.Parent = hub.ScreenGui
            
            local notifList = Instance.new("UIListLayout")
            notifList.Padding = UDim.new(0, 10)
            notifList.SortOrder = Enum.SortOrder.LayoutOrder
            notifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
            notifList.Parent = notifContainer
        end
        
        local notifFrame = Instance.new("Frame")
        notifFrame.Size = UDim2.new(1, 0, 0, 0)
        notifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        notifFrame.BorderSizePixel = 0
        notifFrame.Parent = notifContainer
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notifFrame
        
        local notifStroke = Instance.new("UIStroke")
        notifStroke.Color = Color3.fromRGB(139, 92, 246)
        notifStroke.Thickness = 2
        notifStroke.Parent = notifFrame
        
        local notifTitle = Instance.new("TextLabel")
        notifTitle.Size = UDim2.new(1, -20, 0, 25)
        notifTitle.Position = UDim2.new(0, 10, 0, 10)
        notifTitle.BackgroundTransparency = 1
        notifTitle.Text = config.Title or "Notification"
        notifTitle.Font = Enum.Font.GothamBold
        notifTitle.TextSize = 14
        notifTitle.TextColor3 = Color3.new(1, 1, 1)
        notifTitle.TextXAlignment = Enum.TextXAlignment.Left
        notifTitle.Parent = notifFrame
        
        local notifDesc = Instance.new("TextLabel")
        notifDesc.Size = UDim2.new(1, -20, 0, 0)
        notifDesc.Position = UDim2.new(0, 10, 0, 35)
        notifDesc.BackgroundTransparency = 1
        notifDesc.Text = config.Description or ""
        notifDesc.Font = Enum.Font.Gotham
        notifDesc.TextSize = 12
        notifDesc.TextColor3 = Color3.fromRGB(180, 180, 190)
        notifDesc.TextXAlignment = Enum.TextXAlignment.Left
        notifDesc.TextYAlignment = Enum.TextYAlignment.Top
        notifDesc.TextWrapped = true
        notifDesc.Parent = notifFrame
        
        local textSize = game:GetService("TextService"):GetTextSize(
            notifDesc.Text,
            notifDesc.TextSize,
            notifDesc.Font,
            Vector2.new(280, math.huge)
        )
        notifDesc.Size = UDim2.new(1, -20, 0, textSize.Y)
        
        local totalHeight = 45 + textSize.Y + 10
        
        Tween(notifFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.4, Enum.EasingStyle.Back)
        
        local duration = config.Duration or 3
        wait(duration)
        
        Tween(notifFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        wait(0.3)
        notifFrame:Destroy()
    end
    
    return hub
end

-- Example Usage
--[[
local UI = ModernUI:CreateHub({
    Name = "My Modern Hub",
    Theme = "Dark"
})

local MainWindow = UI:CreateWindow({
    Name = "Main",
    Icon = "🏠"
})

MainWindow:CreateSection("Combat")

MainWindow:CreateButton({
    Name = "Kill All",
    Callback = function()
        print("Button clicked!")
    end
})

MainWindow:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

MainWindow:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

MainWindow:CreateDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Gun", "Bomb"},
    Default = "Sword",
    Callback = function(option)
        print("Selected:", option)
    end
})

MainWindow:CreateInput({
    Name = "Player Name",
    Placeholder = "Enter name...",
    Callback = function(text)
        print("Input:", text)
    end
})

MainWindow:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("Keybind pressed:", key.Name)
    end
})

MainWindow:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(139, 92, 246),
    Callback = function(color)
        print("Color selected:", color)
    end
})

MainWindow:CreateParagraph({
    Text = "Ini adalah Modern UI Hub Library dengan style yang berbeda dari Rayfield dan WindUI. Fitur lengkap dan mudah digunakan!"
})

UI:CreateNotification({
    Title = "Welcome!",
    Description = "Modern UI Hub loaded successfully!",
    Duration = 5
})
]]

return ModernUI
