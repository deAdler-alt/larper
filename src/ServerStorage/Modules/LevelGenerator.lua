local TweenService = game:GetService("TweenService")
local LevelGenerator = {}

local TIER_HEIGHT = 40
local RADIUS = 25
local STAIRS_PER_TIER = 15

local BIOMES = {
    [1] = { 
        Name = "Root-Base",
        Material = Enum.Material.Cobblestone,
        Color = Color3.fromRGB(105, 96, 89)
    },
    [2] = { 
        Name = "Tangled Canopy",
        Material = Enum.Material.WoodPlanks,
        Color = Color3.fromRGB(86, 125, 70) 
    }
}

function LevelGenerator.GenerateSpire(tier)
    local currentBiomeIndex = math.clamp(math.ceil(tier / 5), 1, 2)
    local biomeData = BIOMES[currentBiomeIndex]
    
    print("Generowanie obszaru: " .. biomeData.Name)
    local baseY = (tier - 1) * TIER_HEIGHT
    
    for i = 1, STAIRS_PER_TIER do
        local angle = (i / STAIRS_PER_TIER) * math.pi * 2
        local heightOffset = (i / STAIRS_PER_TIER) * TIER_HEIGHT
        
        local x = math.cos(angle) * RADIUS
        local z = math.sin(angle) * RADIUS
        local y = baseY + heightOffset
        
        local stair = Instance.new("Part")
        stair.Size = Vector3.new(18, 2, 12)
        stair.Position = Vector3.new(x, y, z)
        stair.Anchored = true
        stair.CFrame = CFrame.lookAt(stair.Position, Vector3.new(0, y, 0))
        
        stair.Material = biomeData.Material
        stair.Color = biomeData.Color
        
        local environmentFolder = workspace:FindFirstChild("SpireEnvironment")
        if not environmentFolder then
            environmentFolder = Instance.new("Folder")
            environmentFolder.Name = "SpireEnvironment"
            environmentFolder.Parent = workspace
        end
        stair.Parent = environmentFolder
        
        task.spawn(function()
            while stair.Parent do
                task.wait(math.random(12, 25))
                local targetOffset = Vector3.new(math.random(-8, 8), math.random(-2, 2), math.random(-8, 8))
                local goal = {Position = stair.Position + targetOffset}
                local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true)
                
                local tween = TweenService:Create(stair, tweenInfo, goal)
                tween:Play()
            end
        end)
    end
end

function LevelGenerator.ClearSpire()
    local environmentFolder = workspace:FindFirstChild("SpireEnvironment")
    if environmentFolder then
        environmentFolder:ClearAllChildren()
    end
end

return LevelGenerator