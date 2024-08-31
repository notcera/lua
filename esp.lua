loadstring(game:HttpGet("https://raw.githubusercontent.com/notcera/lua/main/global.lua"))()

getgenv().Lines = Lines or {}
getgenv().Texts = Texts or {}
getgenv().Enabled = not Enabled

local Toggle = {Line = true, Text = true}

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ViewportSize = Camera.ViewportSize

function OnScreen(x)
    local Point, Visible = Camera:WorldToViewportPoint(x)
    return Point, Visible
end

function DrawText(Textt, Position)
    local Text = Drawing.new("Text")
    Text.Text = Textt
    Text.Position = Position
    Text.Size = 20
    Text.Outline = true
    Text.Color = Color3.new(1, 1, 1)
    Text.Font = 3
    Text.Center = true
    return Text
end

function DrawLine(i, To, Color, Visible)
    local Line = Drawing.new("Line")
    Line.To = To
    Line.From = Vector2.new(ViewportSize.X / 2, ViewportSize.Y)
    Line.Color = Color
    Line.Thickness = 3
    Line.Transparency = Visible and 1 or 0
    return Line
end

if PlayerConnection then PlayerConnection:Disconnect() end
getgenv().PlayerConnection = Players.PlayerRemoving:Connect(function(v)
    if rawget(Lines, v.Name) then
        print(v, "is leaving")
        local q = Lines[v.Name]
        q.Transparency = 0
    end

    if rawget(Texts, v.Name) then
        print(v, "is leaving")
        local q = Texts[v.Name]
        q.Transparency = 0
    end
end)

while task.wait() and Enabled do
    for i, v in Players:GetPlayers() do
        local Char = v.Character
        local Noid = Char and Char:FindFirstChild("Humanoid")
        if not Noid then continue end
        if v.Name == Player.Name then continue end
        local Point, Visible = OnScreen(Char:GetPivot().p)
        local _Vector2 = Visible and Vector2.new(Point.X, Point.Y) or Vector2.new(ViewportSize.X / 2, ViewportSize.Y)

        if not rawget(Lines, v.Name) then
            Lines[v.Name] = DrawLine(v.Name, _Vector2, Color3.new(0, 1, 0), true)
        else
            Lines[v.Name].Transparency = Toggle.Line and Visible and 1 or 0
            Lines[v.Name].To = _Vector2
            Lines[v.Name].Color = v.TeamColor.Color
        end

        if not rawget(Texts, v.Name) then
            Texts[v.Name] = DrawText(GetDistance(Char:GetPivot().p), _Vector2)
        else
            Texts[v.Name].Text = ("%* [%*m]"):format(v.Name, math.floor(GetDistance(Char:GetPivot().p)))
            Texts[v.Name].Position = _Vector2 + Vector2.new(0, -30)
            Texts[v.Name].Transparency = Toggle.Text and Visible and 1 or 0
        end
    end
end
