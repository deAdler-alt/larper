local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("MeleeAttack")

local MELEE_RANGE = 8
local BASE_DAMAGE = 25

AttackEvent.OnServerEvent:Connect(function(player)
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local overlapParams = OverlapParams.new()
    overlapParams.FilterDescendantsInstances = {character}
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local hitbox = workspace:GetPartBoundsInBox(rootPart.CFrame * CFrame.new(0, 0, -MELEE_RANGE/2), Vector3.new(6, 6, MELEE_RANGE), overlapParams)
    local damagedEntities = {}
    
    for _, part in ipairs(hitbox) do
        local enemyModel = part:FindFirstAncestorOfClass("Model")
        if enemyModel and not damagedEntities[enemyModel] then
            local enemyHumanoid = enemyModel:FindFirstChild("Humanoid")
            if enemyHumanoid and enemyHumanoid.Health > 0 then
                
                local distance = (rootPart.Position - enemyModel.PrimaryPart.Position).Magnitude
                if distance <= MELEE_RANGE + 2 then
                    enemyHumanoid:TakeDamage(BASE_DAMAGE)
                    damagedEntities[enemyModel] = true
                    
                    local knockbackForce = Instance.new("BodyVelocity")
                    knockbackForce.Velocity = rootPart.CFrame.LookVector * 50
                    knockbackForce.MaxForce = Vector3.new(100000, 0, 100000)
                    knockbackForce.Parent = enemyModel.PrimaryPart
                    game:GetService("Debris"):AddItem(knockbackForce, 0.1)
                end
            end
        end
    end
end)