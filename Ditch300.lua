--[[
    Xeno GUI - Complete All-in-One Script
    Features: Blur Removal, Vision Fix, Time Lock, Freecam, Realistic Smoke, Name ESP, Teleport, Shift Lock (Ctrl), Infinite Yield
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Ditch300"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 580)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BackgroundTransparency = 0.95
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 80, 80)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.4
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BackgroundTransparency = 0.5
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Ditch 300"
titleText.TextColor3 = Color3.fromRGB(255, 100, 100)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -34, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab Buttons
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabs = {"Visuals", "Camera", "Effects", "ESP", "Graphics"}
local tabButtons = {}
local currentTab = "Visuals"

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #tabs, -6, 1, -6)
    btn.Position = UDim2.new((i - 1) / #tabs, 3, 0, 3)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(30, 30, 40)
    btn.Text = tabName:upper()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = tabContainer
    tabButtons[tabName] = btn
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        updateTabContent(tabName)
    end)
end

-- Content Container
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -90)
contentFrame.Position = UDim2.new(0, 10, 0, 85)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 3
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 6)
contentList.SortOrder = Enum.SortOrder.LayoutOrder
contentList.Parent = contentFrame

contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
end)

-- Create UI Elements Helper
function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 44, 0, 24)
    toggle.Position = UDim2.new(1, -52, 0, 4)
    toggle.BackgroundColor3 = default and Color3.fromRGB(80, 200, 140) or Color3.fromRGB(60, 60, 70)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 10
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggle
    
    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(80, 200, 140) or Color3.fromRGB(60, 60, 70)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return {frame = frame, toggle = toggle, setState = function(val) state = val; toggle.BackgroundColor3 = val and Color3.fromRGB(80, 200, 140) or Color3.fromRGB(60, 60, 70); toggle.Text = val and "ON" or "OFF"; callback(val) end}
end

function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. string.format("%.1f", default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 4)
    slider.Position = UDim2.new(0, 10, 0, 28)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 2)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill
    
    local value = default
    local dragging = false
    
    local function updateSlider(val)
        value = math.clamp(val, min, max)
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        label.Text = text .. ": " .. string.format("%.1f", value)
        callback(value)
    end
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            updateSlider(min + x * (max - min))
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            if input.Position.X >= slider.AbsolutePosition.X and input.Position.X <= slider.AbsolutePosition.X + slider.AbsoluteSize.X then
                local x = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
                updateSlider(min + x * (max - min))
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {frame = frame, setValue = updateSlider}
end

function createColorPicker(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 44, 0, 24)
    colorBtn.Position = UDim2.new(1, -52, 0, 8)
    colorBtn.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
    colorBtn.Text = ""
    colorBtn.Parent = frame
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 4)
    colorCorner.Parent = colorBtn
    
    local currentColor = default or Color3.fromRGB(255, 255, 255)
    
    colorBtn.MouseButton1Click:Connect(function()
        local colorPicker = Instance.new("Frame")
        colorPicker.Size = UDim2.new(0, 200, 0, 150)
        colorPicker.Position = UDim2.new(0.5, -100, 0.5, -75)
        colorPicker.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        colorPicker.BorderSizePixel = 0
        colorPicker.Parent = screenGui
        
        local pickerCorner = Instance.new("UICorner")
        pickerCorner.CornerRadius = UDim.new(0, 8)
        pickerCorner.Parent = colorPicker
        
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(128, 128, 128),
            Color3.fromRGB(255, 128, 0),
            Color3.fromRGB(128, 0, 128),
            Color3.fromRGB(0, 128, 128),
            Color3.fromRGB(128, 128, 0)
        }
        
        for i, color in ipairs(colors) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 40, 0, 40)
            btn.Position = UDim2.new(0, 10 + ((i-1) % 6) * 30, 0, 10 + math.floor((i-1) / 6) * 30)
            btn.BackgroundColor3 = color
            btn.Text = ""
            btn.Parent = colorPicker
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                currentColor = color
                colorBtn.BackgroundColor3 = color
                callback(color)
                colorPicker:Destroy()
            end)
        end
        
        local closePick = Instance.new("TextButton")
        closePick.Size = UDim2.new(0, 40, 0, 20)
        closePick.Position = UDim2.new(1, -50, 1, -25)
        closePick.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
        closePick.Text = "X"
        closePick.TextColor3 = Color3.fromRGB(255, 255, 255)
        closePick.Font = Enum.Font.GothamBold
        closePick.TextSize = 12
        closePick.Parent = colorPicker
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 4)
        closeCorner.Parent = closePick
        
        closePick.MouseButton1Click:Connect(function()
            colorPicker:Destroy()
        end)
    end)
    
    return {frame = frame, setColor = function(col) currentColor = col; colorBtn.BackgroundColor3 = col; callback(col) end}
end

function createButton(parent, text, color, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -6)
    btn.Position = UDim2.new(0, 5, 0, 3)
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 70, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- Tab Content
local tabContent = {}

function updateTabContent(tab)
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child ~= contentList then
            child:Destroy()
        end
    end
    
    if tabContent[tab] then
        tabContent[tab]()
    end
    task.wait()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
end

-- Visuals Tab
tabContent["Visuals"] = function()
    -- Blur Removal
    local blurToggle = createToggle(contentFrame, "Remove Blur Effects", true, function(state)
        if state then
            local function removeBlurs()
                for _, child in ipairs(Lighting:GetChildren()) do
                    if child:IsA("BlurEffect") or child:IsA("DepthOfFieldEffect") or child:IsA("SunRaysEffect") then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
            
            _G.blurConnection = Lighting.ChildAdded:Connect(function(child)
                if child:IsA("BlurEffect") or child:IsA("DepthOfFieldEffect") or child:IsA("SunRaysEffect") then
                    pcall(function() child:Destroy() end)
                end
            end)
            
            removeBlurs()
        else
            if _G.blurConnection then
                _G.blurConnection:Disconnect()
                _G.blurConnection = nil
            end
        end
    end)
    
    -- Vision Fix
    local visionToggle = createToggle(contentFrame, "Fix Vision (Brightness/Fog)", true, function(state)
        _G.visionEnabled = state
        
        local function fixVision()
            Lighting.Brightness = 2
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.Bloom.Intensity = 1
            Lighting.Bloom.Size = 24
            Lighting.Bloom.Threshold = 0.9
            Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.ExposureCompensation = 0
            
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("ColorCorrectionEffect") then
                    v:Destroy()
                end
            end
        end
        
        if state then
            _G.visionConnection = RunService.RenderStepped:Connect(function()
                if _G.visionEnabled then fixVision() end
            end)
            fixVision()
        else
            if _G.visionConnection then
                _G.visionConnection:Disconnect()
                _G.visionConnection = nil
            end
        end
    end)
    
    -- Time Lock
    local timeToggle = createToggle(contentFrame, "Lock Time", false, function(state)
        _G.timeLocked = state
        if state and _G.lockedTime then
            Lighting.ClockTime = _G.lockedTime
        end
    end)
    
    local timeSlider = createSlider(contentFrame, "Time", 0, 24, 14, function(value)
        _G.lockedTime = value
        if _G.timeLocked then
            Lighting.ClockTime = value
        end
    end)
    
    -- Reset button
    createButton(contentFrame, "Reset Lighting", Color3.fromRGB(255, 160, 40), function()
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.Bloom.Intensity = 0.5
        Lighting.Bloom.Size = 24
        Lighting.Bloom.Threshold = 0.9
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.ExposureCompensation = 0
        Lighting.ClockTime = 14
    end)
end

-- Camera Tab
tabContent["Camera"] = function()
    local cam = workspace.CurrentCamera
    
    -- Freecam variables
    local freecamState = false
    local freecam = false
    local speed = 1
    local zoomSpeed = 10
    local oldCamType = cam.CameraType
    local oldCamSubject = cam.CameraSubject
    local subject = Instance.new("Humanoid")
    subject.Parent = nil
    local pitch = 0
    local yaw = 0
    local mouseSensitivity = 0.5
    
    function startFreecam()
        freecam = true
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = subject
        subject.Parent = nil
    end
    
    function stopFreecam()
        freecam = false
        cam.CameraType = oldCamType
        cam.CameraSubject = oldCamSubject
    end
    
    -- Freecam Toggle
    local freecamToggle = createToggle(contentFrame, "Freecam (Shift+P)", false, function(state)
        freecamState = state
        if state then
            startFreecam()
        else
            stopFreecam()
        end
    end)
    
    -- Speed Slider
    local speedSlider = createSlider(contentFrame, "Freecam Speed", 0.5, 5, 1, function(value)
        speed = value
    end)
    
    -- Controls Info
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 70)
    infoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    infoFrame.BackgroundTransparency = 0.4
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = contentFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -10, 1, -6)
    infoText.Position = UDim2.new(0, 5, 0, 3)
    infoText.BackgroundTransparency = 1
    infoText.Text = "Freecam:\nWASD - Move | E/Q - Up/Down | Shift - Speed Boost\nMouse - Look Around | Scroll - Zoom"
    infoText.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 10
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.Parent = infoFrame
    
    -- Freecam Input Handling
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            if freecam then
                stopFreecam()
                freecamState = false
                freecamToggle.setState(false)
            else
                startFreecam()
                freecamState = true
                freecamToggle.setState(true)
            end
        end
        
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if freecam then
                local direction = input.Position.Z > 0 and 1 or -1
                cam.CFrame = cam.CFrame + cam.CFrame.LookVector * direction * zoomSpeed
            end
        end
    end)
    
    -- Freecam Movement
    RunService.RenderStepped:Connect(function(dt)
        if not freecam then return end
        
        local move = Vector3.zero
        
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0, 1, 0) end
        
        local currentSpeed = speed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then currentSpeed = currentSpeed * 2 end
        
        if move.Magnitude > 0 then
            cam.CFrame = cam.CFrame + move.Unit * currentSpeed * 0.5
        end
        
        local delta = UserInputService:GetMouseDelta()
        yaw = yaw - delta.X * mouseSensitivity * 0.01
        pitch = math.clamp(pitch - delta.Y * mouseSensitivity * 0.01, -1.5, 1.5)
        
        cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.fromOrientation(pitch, yaw, 0)
    end)
    
    -- Reset on respawn
    player.CharacterAdded:Connect(function()
        if freecam then
            stopFreecam()
            freecamState = false
            freecamToggle.setState(false)
        end
    end)
end

-- Effects Tab
tabContent["Effects"] = function()
    local smokeEnabled = false
    local smokeParts = {}
    local smokeColor = Color3.fromRGB(180, 180, 180)
    local smokeAmount = 40
    local smokeSize = 6
    local smokeOpacity = 0.5
    local smokeSpread = 20
    local smokeConnection = nil
    
    -- Create realistic smoke effect
    function createSmoke()
        if not smokeEnabled then return end
        
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Clear old smoke
        for _, data in ipairs(smokeParts) do
            pcall(function() 
                if data.part then data.part:Destroy() end
            end)
        end
        smokeParts = {}
        
        -- Create realistic smoke particles
        for i = 1, smokeAmount do
            local part = Instance.new("Part")
            part.Size = Vector3.new(smokeSize, smokeSize * 0.7, smokeSize)
            part.Shape = Enum.PartType.Ball
            part.Material = Enum.Material.Neon
            part.Color = smokeColor
            part.Transparency = 1 - smokeOpacity
            part.Anchored = true
            part.CanCollide = false
            part.Parent = workspace
            
            local angle = math.random() * math.pi * 2
            local radius = math.random(3, smokeSpread)
            local height = math.random(-2, 10)
            part.Position = root.Position + Vector3.new(
                math.cos(angle) * radius,
                height,
                math.sin(angle) * radius
            )
            
            part.Orientation = Vector3.new(math.random() * 360, math.random() * 360, math.random() * 360)
            
            local velocity = Vector3.new(
                (math.random() - 0.5) * 3,
                math.random() * 0.5 + 0.2,
                (math.random() - 0.5) * 3
            )
            
            table.insert(smokeParts, {
                part = part,
                velocity = velocity,
                floatOffset = math.random() * 100,
                lifeTime = math.random() * 15 + 10,
                age = 0,
                rotationSpeed = Vector3.new(
                    (math.random() - 0.5) * 2,
                    (math.random() - 0.5) * 2,
                    (math.random() - 0.5) * 2
                ),
                startSize = smokeSize * (0.5 + math.random() * 0.5),
                driftAngle = math.random() * math.pi * 2,
                driftSpeed = 0.2 + math.random() * 0.3
            })
        end
    end
    
    -- Update smoke with realistic movement
    function updateSmoke()
        if not smokeEnabled then return end
        
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for i, data in ipairs(smokeParts) do
            if data and data.part and data.part.Parent then
                local part = data.part
                data.age = data.age + 0.016
                
                data.driftAngle = data.driftAngle + data.driftSpeed * 0.02
                
                local pos = part.Position
                pos = pos + data.velocity * 0.3
                
                local drift = Vector3.new(
                    math.cos(data.driftAngle) * 0.08,
                    math.sin(data.driftAngle * 0.7) * 0.03,
                    math.sin(data.driftAngle) * 0.08
                )
                pos = pos + drift
                
                local turbulence = Vector3.new(
                    math.sin(tick() * 0.2 + data.floatOffset) * 0.05,
                    math.cos(tick() * 0.3 + data.floatOffset * 1.3) * 0.02,
                    math.cos(tick() * 0.2 + data.floatOffset * 0.7) * 0.05
                )
                pos = pos + turbulence
                
                local toRoot = pos - root.Position
                local distance = toRoot.Magnitude
                
                if distance > smokeSpread * 2.5 then
                    pos = root.Position + toRoot.Unit * (smokeSpread * 2)
                end
                
                if pos.Y - root.Position.Y > 12 then
                    data.velocity = data.velocity - Vector3.new(0, 0.05, 0)
                end
                if pos.Y - root.Position.Y < -4 then
                    data.velocity = data.velocity + Vector3.new(0, 0.05, 0)
                end
                
                part.Position = pos
                part.Orientation = part.Orientation + data.rotationSpeed * 0.5
                
                local sizePulse = math.sin(tick() * 0.3 + data.floatOffset) * 0.2 + 0.8
                local currentSize = data.startSize * sizePulse
                part.Size = Vector3.new(currentSize, currentSize * 0.7, currentSize)
                
                local ageFactor = math.min(data.age / 3, 1)
                local lifeFactor = math.max(1 - (data.age / data.lifeTime), 0)
                local breathe = math.sin(tick() * 0.2 + data.floatOffset) * 0.1
                
                local baseTransparency = 1 - smokeOpacity
                local ageFade = baseTransparency + (1 - ageFactor) * 0.3
                local lifeFade = ageFade + (1 - lifeFactor) * 0.4
                
                part.Transparency = math.clamp(lifeFade + breathe, 0.05, 0.95)
                
                data.velocity = data.velocity + Vector3.new(
                    (math.random() - 0.5) * 0.03,
                    (math.random() - 0.5) * 0.02,
                    (math.random() - 0.5) * 0.03
                )
                
                data.velocity = data.velocity * 0.995
                if data.velocity.Magnitude > 3 then
                    data.velocity = data.velocity.Unit * 2.5
                end
                
                if data.age > data.lifeTime then
                    local angle = math.random() * math.pi * 2
                    local radius = math.random(2, smokeSpread)
                    local height = math.random(-2, 8)
                    part.Position = root.Position + Vector3.new(
                        math.cos(angle) * radius,
                        height,
                        math.sin(angle) * radius
                    )
                    data.age = 0
                    data.lifeTime = math.random() * 15 + 10
                    data.startSize = smokeSize * (0.5 + math.random() * 0.5)
                    data.velocity = Vector3.new(
                        (math.random() - 0.5) * 3,
                        math.random() * 0.5 + 0.2,
                        (math.random() - 0.5) * 3
                    )
                    data.driftAngle = math.random() * math.pi * 2
                end
            end
        end
    end
    
    -- Smoke Toggle
    local smokeToggle = createToggle(contentFrame, "Realistic Smoke Effect", false, function(state)
        smokeEnabled = state
        if state then
            createSmoke()
            smokeConnection = RunService.RenderStepped:Connect(function()
                updateSmoke()
            end)
        else
            if smokeConnection then
                smokeConnection:Disconnect()
                smokeConnection = nil
            end
            for _, data in ipairs(smokeParts) do
                pcall(function() 
                    if data.part then data.part:Destroy() end
                end)
            end
            smokeParts = {}
        end
    end)
    
    -- Smoke Color Picker
    local colorPicker = createColorPicker(contentFrame, "Smoke Color", Color3.fromRGB(180, 180, 180), function(color)
        smokeColor = color
        for _, data in ipairs(smokeParts) do
            if data and data.part and data.part.Parent then
                data.part.Color = color
            end
        end
    end)
    
    -- Smoke Opacity Slider
    local opacitySlider = createSlider(contentFrame, "Smoke Opacity", 0.1, 1, 0.5, function(value)
        smokeOpacity = value
        for _, data in ipairs(smokeParts) do
            if data and data.part and data.part.Parent then
                local ageFactor = math.min(data.age / 3, 1)
                local lifeFactor = math.max(1 - (data.age / data.lifeTime), 0)
                local breathe = math.sin(tick() * 0.2 + data.floatOffset) * 0.1
                local baseTransparency = 1 - smokeOpacity
                local ageFade = baseTransparency + (1 - ageFactor) * 0.3
                local lifeFade = ageFade + (1 - lifeFactor) * 0.4
                data.part.Transparency = math.clamp(lifeFade + breathe, 0.05, 0.95)
            end
        end
    end)
    
    -- Smoke Size Slider
    local sizeSlider = createSlider(contentFrame, "Smoke Size", 2, 15, 6, function(value)
        smokeSize = value
        for _, data in ipairs(smokeParts) do
            if data and data.part and data.part.Parent then
                data.startSize = smokeSize * (0.5 + math.random() * 0.5)
                local sizePulse = math.sin(tick() * 0.3 + data.floatOffset) * 0.2 + 0.8
                local currentSize = data.startSize * sizePulse
                data.part.Size = Vector3.new(currentSize, currentSize * 0.7, currentSize)
            end
        end
    end)
    
    -- Smoke Amount Slider  
    local amountSlider = createSlider(contentFrame, "Smoke Amount", 10, 80, 40, function(value)
        smokeAmount = math.round(value)
        if smokeEnabled then
            createSmoke()
        end
    end)
    
    -- Smoke Spread Slider
    local spreadSlider = createSlider(contentFrame, "Smoke Spread", 5, 35, 20, function(value)
        smokeSpread = math.round(value)
        if smokeEnabled then
            createSmoke()
        end
    end)
    
    -- Regenerate Smoke Button
    createButton(contentFrame, "Regenerate Smoke", Color3.fromRGB(255, 160, 40), function()
        if smokeEnabled then
            createSmoke()
        end
    end)
    
    -- Clear Smoke Button
    createButton(contentFrame, "Clear Smoke", Color3.fromRGB(255, 60, 60), function()
        for _, data in ipairs(smokeParts) do
            pcall(function() 
                if data.part then data.part:Destroy() end
            end)
        end
        smokeParts = {}
        if smokeEnabled then
            createSmoke()
        end
    end)
end

-- ESP Tab
tabContent["ESP"] = function()
    local espList = {}
    local espHidden = false
    local saveFile = "DitchESP.json"
    local espListFrame = nil
    
    -- Load saved ESP
    local function loadSavedESP()
        local success, data = pcall(function() return readfile(saveFile) end)
        if success and data then
            local saved = HttpService:JSONDecode(data)
            for _, name in ipairs(saved) do
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and (plr.Name:lower() == name:lower() or plr.DisplayName:lower() == name:lower()) then
                        addESP(plr, true)
                        break
                    end
                end
            end
        end
    end
    
    -- Save ESP names
    local function saveESPNames()
        local names = {}
        for _, data in pairs(espList) do
            table.insert(names, data.player.Name)
        end
        pcall(function() writefile(saveFile, HttpService:JSONEncode(names)) end)
    end
    
    -- Add ESP
    function addESP(plr, silent)
        if espList[plr.UserId] then return end
        
        local char = plr.Character
        local highlight = nil
        local billboard = nil
        
        if char and not espHidden then
            highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 30, 30)
            highlight.FillTransparency = 0.3
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = char
            
            local head = char:FindFirstChild("Head")
            if head then
                billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 180, 0, 26)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.DisplayName
                label.TextColor3 = Color3.fromRGB(255, 80, 80)
                label.Font = Enum.Font.GothamBlack
                label.TextSize = 12
                label.TextStrokeTransparency = 0.6
                label.Parent = billboard
            end
        end
        
        espList[plr.UserId] = {player = plr, highlight = highlight, billboard = billboard}
        updateESPList()
        if not silent then saveESPNames() end
    end
    
    -- Remove ESP
    function removeESP(uid, silent)
        local data = espList[uid]
        if not data then return end
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
        espList[uid] = nil
        updateESPList()
        if not silent then saveESPNames() end
    end
    
    -- Update ESP List UI
    function updateESPList()
        if not espListFrame then return end
        for _, child in ipairs(espListFrame:GetChildren()) do
            if child ~= espListFrame:FindFirstChild("UIListLayout") then
                child:Destroy()
            end
        end
        
        for uid, data in pairs(espList) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 26)
            row.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            row.BackgroundTransparency = 0.5
            row.BorderSizePixel = 0
            row.Parent = espListFrame
            
            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 4)
            rowCorner.Parent = row
            
            local dot = Instance.new("Frame")
            dot.Size = UDim2.new(0, 6, 0, 6)
            dot.Position = UDim2.new(0, 8, 0, 10)
            dot.BackgroundColor3 = espHidden and Color3.fromRGB(255, 140, 30) or Color3.fromRGB(80, 255, 80)
            dot.BorderSizePixel = 0
            dot.Parent = row
            
            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(0, 3)
            dotCorner.Parent = dot
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -35, 1, 0)
            nameLabel.Position = UDim2.new(0, 18, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = data.player.DisplayName
            nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 11
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = row
            
            local removeBtn = Instance.new("TextButton")
            removeBtn.Size = UDim2.new(0, 20, 0, 18)
            removeBtn.Position = UDim2.new(1, -24, 0, 4)
            removeBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
            removeBtn.Text = "X"
            removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            removeBtn.Font = Enum.Font.GothamBold
            removeBtn.TextSize = 9
            removeBtn.Parent = row
            
            local removeCorner = Instance.new("UICorner")
            removeCorner.CornerRadius = UDim.new(0, 3)
            removeCorner.Parent = removeBtn
            
            removeBtn.MouseButton1Click:Connect(function()
                removeESP(uid)
            end)
        end
    end
    
    -- ESP Controls
    local addFrame = Instance.new("Frame")
    addFrame.Size = UDim2.new(1, 0, 0, 60)
    addFrame.BackgroundTransparency = 1
    addFrame.Parent = contentFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -10, 0, 24)
    inputBox.Position = UDim2.new(0, 5, 0, 2)
    inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    inputBox.BackgroundTransparency = 0.4
    inputBox.BorderSizePixel = 0
    inputBox.Text = ""
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 11
    inputBox.PlaceholderText = "Enter username..."
    inputBox.Parent = addFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = inputBox
    
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, 0, 0, 26)
    btnFrame.Position = UDim2.new(0, 0, 0, 30)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = addFrame
    
    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0.48, -6, 1, 0)
    addBtn.Position = UDim2.new(0, 6, 0, 0)
    addBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    addBtn.Text = "ADD"
    addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addBtn.Font = Enum.Font.GothamBold
    addBtn.TextSize = 11
    addBtn.Parent = btnFrame
    
    local addCorner = Instance.new("UICorner")
    addCorner.CornerRadius = UDim.new(0, 4)
    addCorner.Parent = addBtn
    
    addBtn.MouseButton1Click:Connect(function()
        local search = inputBox.Text:lower()
        if search == "" then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and (plr.Name:lower():find(search) or plr.DisplayName:lower():find(search)) then
                addESP(plr)
                inputBox.Text = ""
                return
            end
        end
    end)
    
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0.48, -6, 1, 0)
    hideBtn.Position = UDim2.new(0.52, 6, 0, 0)
    hideBtn.BackgroundColor3 = Color3.fromRGB(255, 160, 40)
    hideBtn.Text = "HIDE ALL"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 11
    hideBtn.Parent = btnFrame
    
    local hideCorner = Instance.new("UICorner")
    hideCorner.CornerRadius = UDim.new(0, 4)
    hideCorner.Parent = hideBtn
    
    hideBtn.MouseButton1Click:Connect(function()
        espHidden = not espHidden
        if espHidden then
            for _, data in pairs(espList) do
                if data.highlight then data.highlight:Destroy() data.highlight = nil end
                if data.billboard then data.billboard:Destroy() data.billboard = nil end
            end
            hideBtn.Text = "SHOW ALL"
            hideBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        else
            for _, data in pairs(espList) do
                local char = data.player.Character
                if char then
                    data.highlight = Instance.new("Highlight")
                    data.highlight.FillColor = Color3.fromRGB(255, 30, 30)
                    data.highlight.FillTransparency = 0.3
                    data.highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    data.highlight.OutlineTransparency = 0
                    data.highlight.Parent = char
                    
                    local head = char:FindFirstChild("Head")
                    if head then
                        data.billboard = Instance.new("BillboardGui")
                        data.billboard.Size = UDim2.new(0, 180, 0, 26)
                        data.billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                        data.billboard.AlwaysOnTop = true
                        data.billboard.Parent = head
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = data.player.DisplayName
                        label.TextColor3 = Color3.fromRGB(255, 80, 80)
                        label.Font = Enum.Font.GothamBlack
                        label.TextSize = 12
                        label.TextStrokeTransparency = 0.6
                        label.Parent = data.billboard
                    end
                end
            end
            hideBtn.Text = "HIDE ALL"
            hideBtn.BackgroundColor3 = Color3.fromRGB(255, 160, 40)
        end
        updateESPList()
    end)
    
    -- ESP List
    espListFrame = Instance.new("ScrollingFrame")
    espListFrame.Size = UDim2.new(1, 0, 0, 140)
    espListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    espListFrame.BackgroundTransparency = 0.4
    espListFrame.BorderSizePixel = 0
    espListFrame.ScrollBarThickness = 3
    espListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    espListFrame.Parent = contentFrame
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 6)
    espCorner.Parent = espListFrame
    
    local espLayout = Instance.new("UIListLayout")
    espLayout.Padding = UDim.new(0, 3)
    espLayout.SortOrder = Enum.SortOrder.LayoutOrder
    espLayout.Parent = espListFrame
    
    espLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        espListFrame.CanvasSize = UDim2.new(0, 0, 0, espLayout.AbsoluteContentSize.Y + 5)
    end)
    
    -- Load saved ESP
    task.wait(0.5)
    loadSavedESP()
end

-- Graphics Tab - Deep Graphics Hub + Teleport + Shift Lock + Infinite Yield
tabContent["Graphics"] = function()
    -- Deep Graphics Hub Button
    createButton(contentFrame, "Load Deep Graphics Hub", Color3.fromRGB(255, 70, 70), function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/gvb/refs/heads/main/DeepGraphicsHub.lua'))()
    end)
    
    -- Infinite Yield Button
    createButton(contentFrame, "Load Infinite Yield", Color3.fromRGB(255, 160, 40), function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    
    -- Shift Lock (Ctrl) - Integrated into Graphics Tab
    local shiftLockFrame = Instance.new("Frame")
    shiftLockFrame.Size = UDim2.new(1, 0, 0, 32)
    shiftLockFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    shiftLockFrame.BackgroundTransparency = 0.4
    shiftLockFrame.BorderSizePixel = 0
    shiftLockFrame.Parent = contentFrame
    
    local shiftCorner = Instance.new("UICorner")
    shiftCorner.CornerRadius = UDim.new(0, 6)
    shiftCorner.Parent = shiftLockFrame
    
    local shiftLabel = Instance.new("TextLabel")
    shiftLabel.Size = UDim2.new(0.7, 0, 1, 0)
    shiftLabel.Position = UDim2.new(0, 10, 0, 0)
    shiftLabel.BackgroundTransparency = 1
    shiftLabel.Text = "Shift Lock (Ctrl)"
    shiftLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    shiftLabel.Font = Enum.Font.GothamBold
    shiftLabel.TextSize = 12
    shiftLabel.TextXAlignment = Enum.TextXAlignment.Left
    shiftLabel.Parent = shiftLockFrame
    
    local shiftBtn = Instance.new("TextButton")
    shiftBtn.Size = UDim2.new(0, 44, 0, 24)
    shiftBtn.Position = UDim2.new(1, -52, 0, 4)
    shiftBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    shiftBtn.Text = "OFF"
    shiftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    shiftBtn.Font = Enum.Font.GothamBold
    shiftBtn.TextSize = 10
    shiftBtn.Parent = shiftLockFrame
    
    local shiftBtnCorner = Instance.new("UICorner")
    shiftBtnCorner.CornerRadius = UDim.new(0, 4)
    shiftBtnCorner.Parent = shiftBtn
    
    -- Shift Lock Logic
    local locked = false
    local lockAngle = nil
    
    local function toggleShiftLock()
        locked = not locked
        if locked then
            shiftBtn.Text = "ON"
            shiftBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 140)
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                lockAngle = char.HumanoidRootPart.CFrame.LookVector
            end
        else
            shiftBtn.Text = "OFF"
            shiftBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            lockAngle = nil
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.AutoRotate = true end
            end
        end
    end
    
    shiftBtn.MouseButton1Click:Connect(toggleShiftLock)
    
    -- Ctrl Keybind to toggle Shift Lock
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            toggleShiftLock()
        end
    end)
    
    -- Shift Lock Render Stepped
    RunService.RenderStepped:Connect(function()
        if not locked or not lockAngle then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        hum.AutoRotate = false
        root.CFrame = CFrame.new(root.Position, root.Position + lockAngle)
    end)
    
    -- Teleport System
    local teleportFrame = Instance.new("Frame")
    teleportFrame.Size = UDim2.new(1, 0, 0, 100)
    teleportFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    teleportFrame.BackgroundTransparency = 0.4
    teleportFrame.BorderSizePixel = 0
    teleportFrame.Parent = contentFrame
    
    local teleportCorner = Instance.new("UICorner")
    teleportCorner.CornerRadius = UDim.new(0, 6)
    teleportCorner.Parent = teleportFrame
    
    local teleportLabel = Instance.new("TextLabel")
    teleportLabel.Size = UDim2.new(1, -10, 0, 18)
    teleportLabel.Position = UDim2.new(0, 5, 0, 2)
    teleportLabel.BackgroundTransparency = 1
    teleportLabel.Text = "Teleport Locations"
    teleportLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    teleportLabel.Font = Enum.Font.GothamBold
    teleportLabel.TextSize = 12
    teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
    teleportLabel.Parent = teleportFrame
    
    -- Teleport paths
    local teleportPaths = {
        {name = "School", path = Workspace.school["Trash Can"].Container},
        {name = "Party", path = Workspace.Map.Partyhouse.fence.Fence},
        {name = "TrapHouse", path = Workspace.Map.casa["lving room"].Couch.Union}
    }
    
    local function teleportTo(path)
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if path then
            root.CFrame = path.CFrame + Vector3.new(0, 3, 0)
        end
    end
    
    local btnY = 22
    for _, data in ipairs(teleportPaths) do
        local teleportBtn = Instance.new("TextButton")
        teleportBtn.Size = UDim2.new(0.3, -6, 0, 22)
        teleportBtn.Position = UDim2.new(0, 6 + ((_ - 1) % 3) * 0.33, 0, btnY + math.floor((_ - 1) / 3) * 26)
        teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        teleportBtn.Text = data.name
        teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportBtn.Font = Enum.Font.GothamBold
        teleportBtn.TextSize = 10
        teleportBtn.Parent = teleportFrame
        
        local teleportBtnCorner = Instance.new("UICorner")
        teleportBtnCorner.CornerRadius = UDim.new(0, 4)
        teleportBtnCorner.Parent = teleportBtn
        
        teleportBtn.MouseButton1Click:Connect(function()
            teleportTo(data.path)
        end)
    end
    
    -- Info text
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 60)
    infoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    infoFrame.BackgroundTransparency = 0.4
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = contentFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -10, 1, -6)
    infoText.Position = UDim2.new(0, 5, 0, 3)
    infoText.BackgroundTransparency = 1
    infoText.Text = "Press Ctrl to toggle Shift Lock\nClick teleport buttons to travel to locations"
    infoText.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 10
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.Parent = infoFrame
end

-- Drag functionality
local dragging = false
local dragStart = nil
local dragFrameStart = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        dragFrameStart = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            dragFrameStart.X.Scale,
            dragFrameStart.X.Offset + delta.X,
            dragFrameStart.Y.Scale,
            dragFrameStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Initial tab load
updateTabContent("Visuals")

print("Ditch 300 GUI Loaded Successfully!")
