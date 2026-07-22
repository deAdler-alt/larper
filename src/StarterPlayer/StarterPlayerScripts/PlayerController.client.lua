local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("MeleeAttack")

local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local CanAttack = true
local AttackCooldown = 0.8
local Stamina = 100

local function performAttack()
    if not CanAttack or Stamina < 15 then return end
    CanAttack = false
    Stamina -= 15
    
    AttackEvent:FireServer()
    print("Swing!")
    
    task.wait(AttackCooldown)
    CanAttack = true
end

local function performParry()
    print("Parry window active!")
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        performAttack()
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        performParry()
    end
end)

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    if CanAttack and Stamina < 100 then
        Stamina = math.clamp(Stamina + (deltaTime * 20), 0, 100)
    end
end)