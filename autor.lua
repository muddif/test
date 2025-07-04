local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local MaxMoveDistance = 50
local MinBallSpeed = 47
local Delay = 65
local AutoRecEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoRecMobileGUI"
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 50)
MainFrame.Position = UDim2.new(0.5, -100, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "autorec mobile xAmyddD"
TitleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Parent = MainFrame

local AutoRecButton = Instance.new("TextButton")
AutoRecButton.Name = "AutoRecButton"
AutoRecButton.Size = UDim2.new(1, -10, 0, 25)
AutoRecButton.Position = UDim2.new(0, 5, 0, 25)
AutoRecButton.Text = "autorec: OFF"
AutoRecButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AutoRecButton.TextColor3 = Color3.new(1, 1, 1)
AutoRecButton.Parent = MainFrame

AutoRecButton.MouseButton1Click:Connect(function()
    AutoRecEnabled = not AutoRecEnabled
    AutoRecButton.Text = AutoRecEnabled and "autorec: ON" or "autorec: OFF"
    AutoRecButton.BackgroundColor3 = AutoRecEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
end)


repeat wait() until workspace:FindFirstChild("Ball")

-- Constants
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Marker
local Marker = Instance.new("Part")
Marker.Name = "Marker"
Marker.Size = Vector3.new(2, 2, 2)
Marker.Shape = Enum.PartType.Ball
Marker.BrickColor = BrickColor.new("Bright violet")
Marker.CanCollide = false
Marker.Anchored = true
Marker.Parent = workspace
Marker.Transparency = 1
Marker.Material = Enum.Material.Neon

-- Physics
local function PHYSICS_STUFF(velocity, position)
    local acceleration = -workspace.Gravity
    local timeToLand = (-velocity.y - math.sqrt(velocity.y * velocity.y - 4 * 0.5 * acceleration * position.y)) / (2 * 0.5 * acceleration)
    local horizontalVelocity = Vector3.new(velocity.x, 0, velocity.z)
    local landingPosition = position + horizontalVelocity * timeToLand + Vector3.new(0, -position.y, 0)
    return landingPosition
end

-- Construct
RunService:BindToRenderStep("VisualizeLandingPosition", Enum.RenderPriority.Camera.Value, function()
    Marker.Transparency = 0.5
    for _, ballModel in ipairs(workspace:GetChildren()) do
        if ballModel:IsA("Model") and ballModel.Name == "Ball" then
            local ball = ballModel:FindFirstChild("BallPart")
            if ball then
                local initialVelocity = ballModel.Velocity
                local landingPosition = PHYSICS_STUFF(initialVelocity.Value, ball.Position)
                Marker.CFrame = CFrame.new(landingPosition)
            end
        end
    end
end

local function MoveToPosition(position)
    if not Character or not Humanoid then return end
    Humanoid:MoveTo(position)
end

local function CheckDistance(position)
    return (Character.HumanoidRootPart.Position - position).Magnitude <= MaxMoveDistance
end

local function CheckBallSpeed(ballModel)
    if not ballModel:FindFirstChild("Velocity") then return false end
    return ballModel.Velocity.Value.Magnitude >= MinBallSpeed
end

RunService.Heartbeat:Connect(function()
    if not AutoRecEnabled then return end
    local marker = workspace:FindFirstChild("Marker")
    if not marker then return end
    for _, ballModel in ipairs(workspace:GetChildren()) do
        if ballModel:IsA("Model") and ballModel.Name == "Ball" then
            if CheckBallSpeed(ballModel) and CheckDistance(marker.Position) then
                task.wait(Delay / 1000)
                MoveToPosition(marker.Position)
            end
        end
    end
end)
