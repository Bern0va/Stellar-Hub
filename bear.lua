local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

-- Prevent duplicate execution
if _G.AutoQuidzCollectorRunning then
    StarterGui:SetCore("SendNotification", {
        Title = "Script Already Running",
        Text = "The Auto Quidz Collector is already running!",
        Duration = 5
    })
    return
end
_G.AutoQuidzCollectorRunning = true

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false -- GUI persists after respawn
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 2
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "Auto Quidz Collector"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Title.Parent = MainFrame

local QuidzCounter = Instance.new("TextLabel")
QuidzCounter.Size = UDim2.new(1, 0, 0, 25)
QuidzCounter.Position = UDim2.new(0, 0, 0, 30)
QuidzCounter.Text = "Quidz Collected: 0"
QuidzCounter.TextColor3 = Color3.new(1, 1, 1)
QuidzCounter.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
QuidzCounter.Parent = MainFrame

local LevelCounter = Instance.new("TextLabel")
LevelCounter.Size = UDim2.new(1, 0, 0, 25)
LevelCounter.Position = UDim2.new(0, 0, 0, 60)
LevelCounter.Text = "Level: 1"
LevelCounter.TextColor3 = Color3.new(1, 1, 1)
LevelCounter.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
LevelCounter.Parent = MainFrame

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(1, 0, 0, 30)
StartButton.Position = UDim2.new(0, 0, 0, 90)
StartButton.Text = "Start"
StartButton.TextColor3 = Color3.new(1, 1, 1)
StartButton.BackgroundColor3 = Color3.new(0, 1, 0)
StartButton.Parent = MainFrame

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, 0, 0, 30)
StopButton.Position = UDim2.new(0, 0, 0, 120)
StopButton.Text = "Stop"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.BackgroundColor3 = Color3.new(1, 0, 0)
StopButton.Parent = MainFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 50, 0, 25)
MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.new(0.8, 0.5, 0)
MinimizeButton.Parent = MainFrame

-- Variables
local collecting = false
local quidzPosition = Vector3.new(408.13, 31.94, -26.91) -- Quidz position
local cooldown = 0.7 -- Cooldown
local quidzCollected = 0
local level = 1
local quidzPerLevel = 10
local quidzIncreaseAmount = 5
local interval = 9
local doubleQuidz = false  -- New variable for gamepass

-- Check for Double Quidz Gamepass
local function checkDoubleQuidz()
    local gamepassId = 12345678  -- Replace with your actual Double Quidz gamepass ID
    if LocalPlayer:HasPass(gamepassId) then
        doubleQuidz = true
    end
end

-- Teleport Function
local function teleportToQuidz()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        print("Teleporting to Quidz...") -- Debugging
        character.HumanoidRootPart.CFrame = CFrame.new(quidzPosition)
    end
end

-- Collection Function
local function startCollecting()
    if not collecting then
        collecting = true
        while collecting do
            teleportToQuidz()

            -- Adjust quidz increase based on the gamepass
            local quidzToAdd = doubleQuidz and quidzIncreaseAmount * 2 or quidzIncreaseAmount
            quidzCollected = quidzCollected + quidzToAdd
            QuidzCounter.Text = "Quidz Collected: " .. quidzCollected
            
            -- Level up
            if quidzCollected >= level * quidzPerLevel then
                level = level + 1
                LevelCounter.Text = "Level: " .. level
            end
            
            print("Quidz Collected: ", quidzCollected) -- Debugging
            wait(interval) -- Wait 9 secs before next collection
        end
    end
end

-- Stop Collecting
local function stopCollecting()
    collecting = false
    print("Stopped collecting.") -- Debugging
end

-- Minimize GUI
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child.Visible = not minimized
        end
    end
    MinimizeButton.Visible = true -- Keep minimize button visible
end)

-- Button Clicks
StartButton.MouseButton1Click:Connect(startCollecting)
StopButton.MouseButton1Click:Connect(stopCollecting)

-- Keep GUI on Respawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    MainFrame.Parent = ScreenGui
end)

-- Notice Message
StarterGui:SetCore("SendNotification", {
    Title = "AFK Mode Warning",
    Text = "Turn on AFK mode! If not, you'll get banned. If on, you're safe!",
    Duration = 9
})

-- Check for Double Quidz Gamepass at the start
checkDoubleQuidz()
