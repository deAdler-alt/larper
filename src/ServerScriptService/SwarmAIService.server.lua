local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SwarmAI = {}
local ACTIVE_MOBS = {}

function SwarmAI.SpawnFlyingHorror(spawnPosition)
    local mob = Instance.new("Part")
    mob.Size = Vector3.new(4, 4, 4)
    mob.Shape = Enum.PartType.Ball
    mob.Color = Color3.new(0, 0, 0)
    mob.Material = Enum.Material.Neon
    mob.Position = spawnPosition
    mob.Anchored = true 
    mob.Parent = workspace
    
    local isAlive = true 
    local timeAlive = 0
    
    table.insert(ACTIVE_MOBS, {part = mob, type = "Flying"})
    
    local connection
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not isAlive or not mob.Parent then
            connection:Disconnect()
            return
        end
        
        timeAlive += deltaTime
        local hoverOffset = math.sin(timeAlive * 3) * 2
        
        local target = nil
        local shortestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - mob.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    target = player.Character.HumanoidRootPart
                end
            end
        end
        
        if target then
            local direction = (target.Position - mob.Position).Unit
            local speed = 8
            
            local newPosition = mob.Position + (direction * speed * deltaTime)
            mob.CFrame = CFrame.new(newPosition.X, newPosition.Y + (hoverOffset * deltaTime), newPosition.Z)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(10)
        SwarmAI.SpawnFlyingHorror(Vector3.new(0, 150, 0))
    end
end)

return SwarmAI