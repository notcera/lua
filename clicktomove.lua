loadstring(game:HttpGet("https://raw.githubusercontent.com/notcera/lua/main/global.lua"))()

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

function PathFind(Position)
    local Character = GetCharacter()
    local Humanoid = GetHumanoid()
    if not Character or not Humanoid then return end

    local Extents = Character:GetExtentsSize()
    AgentRadius = 1 * 0.5 * math.sqrt(Extents.X * Extents.X + Extents.Z * Extents.Z)
    AgentHeight = 1 * Extents.Y
    
    local Path = PathfindingService:CreatePath({WaypointSpacing = 8, AgentCanJump = true, AgentRadius = AgentRadius, AgentHeight = AgentHeight, AgentCanClimb = true})
    local Humanoid = Character:WaitForChild("Humanoid")

    local Success, ErrorMessage = pcall(function()
        Path:ComputeAsync(Character:GetPivot().p, Position)
    end)

    if Path.Status == Enum.PathStatus.Success then
        local Waypoints = Path:GetWaypoints()

        for i, v in Waypoints do
            if i == 1 then continue end
            Humanoid:MoveTo(v.Position)
        end
    else
        warn("Path not computed!", ErrorMessage)
    end
end

if Button1DownSignal then Button1DownSignal:Disconnect() end
getgenv().Button1DownSignal = Mouse.Button1Down:Connect(function()
    PathFind(Mouse.Hit.p)
end)

