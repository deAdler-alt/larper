local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local LevelGenerator = require(ServerStorage.Modules.LevelGenerator)

local GameState = "Lobby" -- States: Lobby, Ascent, Boss, Wipe
local CurrentTier = 0
local ActivePlayers = {}

local function startAscent()
    GameState = "Ascent"
    CurrentTier = 1
    print("The Ascent begins...")
    
    LevelGenerator.ClearSpire()
    LevelGenerator.GenerateSpire(CurrentTier)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            table.insert(ActivePlayers, player)
        end
    end
end

local function checkTeamWipe()
    local aliveCount = 0
    for _, player in ipairs(ActivePlayers) do
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            aliveCount += 1
        end
    end
    
    if aliveCount == 0 and GameState == "Ascent" then
        GameState = "Wipe"
        print("Team wiped! Returning to lobby.")
        task.wait(3)
        GameState = "Lobby"
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(checkTeamWipe)
    end)
end)

task.spawn(function()
    while true do
        if GameState == "Lobby" then
            task.wait(5)
            startAscent()
        elseif GameState == "Ascent" then
            task.wait(1)
        end
    end
end)