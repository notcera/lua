local G = getgenv()
local X = setmetatable({}, {__index = function(x, y) return game:GetService(y) end})

G.Players = X.Players
G.RunService = X.RunService
G.HttpService = X.HttpService
G.VirtualUser = X.VirtualUser
G.TweenService = X.TweenService
G.TeleportService = X.TeleportService
G.CollectionService = X.CollectionService
G.ReplicatedStorage = X.ReplicatedStorage
G.VirtualInputManager = X.VirtualInputManager

local Player = Players.LocalPlayer

G.GetCharacter = function()
    return Player.Character
end

G.GetHumanoid = function()
    return GetCharacter() and GetCharacter():FindFirstChild("Humanoid")
end

G.GetHumanoidRootPart = function()
    return GetCharacter() and GetCharacter():FindFirstChild("HumanoidRootPart")
end

G.Teleport = function(CFrame)
    return GetCharacter() and GetCharacter():PivotTo(CFrame)
end

G.GetDistance = function(Position)
    return GetCharacter() and Player:DistanceFromCharacter(Position) or math.huge
end

G.Float = function(Bool)
    local HumanoidRootPart = GetHumanoidRootPart()
    local Humanoid = GetHumanoid()
    if not HumanoidRootPart then return end
    if not Humanoid then return end
    if Bool and BodyVelocity then return end

    if not Bool and BodyVelocity then
        Humanoid.PlatformStand = false
        BodyVelocity:Destroy()
        G.BodyVelocity = false
        return 
    end

    Humanoid.PlatformStand = true
    G.BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Parent = HumanoidRootPart
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.P = 1250
    BodyVelocity.Velocity = Vector3.zero
end

G.Tween = function(CFrame, Speed)
    local HumanoidRootPart = GetHumanoidRootPart()
    if not HumanoidRootPart then return end
    local Time = (HumanoidRootPart.CFrame.p - CFrame.p).Magnitude / Speed
    local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(Time, Enum.EasingStyle.Linear), {CFrame = CFrame})
    Tween:Play()
end

G.UseTool = function(Name)
    local Character = GetCharacter()
    local Humanoid = GetHumanoid()
    if not Humanoid then return end
    local Tool = Player.Backpack:FindFirstChild(Name) or Character:FindFirstChild(Name)
    
    if Tool then
        if not Character:FindFirstChild(Tool.Name) then
            Humanoid:EquipTool(Tool)
        end
        Tool:Activate()
    end
end
