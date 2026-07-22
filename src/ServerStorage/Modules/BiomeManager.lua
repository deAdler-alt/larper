local BiomeManager = {}

local crystalColors = {
    Color3.new(1, 0, 1),   -- Magenta
    Color3.new(0, 1, 1),   -- Cyan
    Color3.new(1, 1, 1),   -- White
    Color3.new(0, 0, 1),   -- Blue
    Color3.new(0.8, 0.4, 0.1) -- Orange
}

function BiomeManager.MutateIntoCrystal(stairPart)
    stairPart.Material = Enum.Material.Neon
    
    task.spawn(function()
        while stairPart.Parent do
            task.wait(math.random(1, 3)) 
            local randomColor = crystalColors[math.random(1, #crystalColors)]
            local tweenInfo = TweenInfo.new(1)
            local tween = game:GetService("TweenService"):Create(stairPart, tweenInfo, {Color = randomColor})
            tween:Play()
        end
    end)
end

return BiomeManager