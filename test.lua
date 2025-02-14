local player = game.Players.LocalPlayer

local function monitorHealth(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.HealthChanged:Connect(function(newHealth)
        if newHealth < 100 then
            humanoid.Health = 100
        end
    end)
end

local function onCharacterAdded(character)
    monitorHealth(character)
end

player.CharacterAdded:Connect(onCharacterAdded)

-- In case the character is already loaded
if player.Character then
    monitorHealth(player.Character)
end
