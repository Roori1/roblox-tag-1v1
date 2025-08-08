--[[
    Roblox 1‑vs‑1 Tag Game Script

    This script implements a simple tag game in Roblox where one player takes
    on the role of a "Mom" who tries to catch the other player, the "Child".
    If the Mom touches the Child before the timer runs out, the Mom wins.  If
    the Child survives until the timer expires, the Child wins.

    To use this script:
      1. Create a new place in Roblox Studio and insert this script into
         ServerScriptService.  Ensure there are exactly two spawn locations,
         one for each player, or let Roblox handle spawning automatically.
      2. Publish your place and invite a friend to join.  When two players
         are present, a round will begin automatically.
      3. The script will assign one player to the Mom team (red) and the
         other to the Child team (blue), then start a countdown timer.
      4. If the Mom touches the Child’s HumanoidRootPart before the timer
         reaches zero, the Mom wins.  Otherwise, the Child survives and wins.

    You can adjust the roundTime variable near the top of the script to
    change how long each round lasts.  Feel free to expand this example by
    adding obstacles, multiple rounds, or a lobby system.

    Author: ChatGPT (OpenAI)
]]

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

-- Create teams for Mom and Child.  We set AutoAssignable to false to
-- prevent Roblox from automatically assigning new players to these teams.
local momTeam = Instance.new("Team")
momTeam.Name = "Mom"
momTeam.TeamColor = BrickColor.new("Bright red")
momTeam.AutoAssignable = false
momTeam.Parent = Teams

local childTeam = Instance.new("Team")
childTeam.Name = "Child"
childTeam.TeamColor = BrickColor.new("Bright blue")
childTeam.AutoAssignable = false
childTeam.Parent = Teams

-- Configuration: the length of each round in seconds.  Change this value
-- to make rounds longer or shorter.
local roundTime = 60

-- State variables used by the game logic.
local roundInProgress = false
local roundConnection

-- Helper function to announce the winner to all players.  It uses
-- StarterGui:SetCore to display a simple notification.  You can modify
-- this function to use your own UI instead.
local function announce(message)
    for _, plr in ipairs(Players:GetPlayers()) do
        -- Show a notification for five seconds on each player's screen.
        local success, result = pcall(function()
            plr:WaitForChild("PlayerGui")
            plr:WaitForChild("PlayerGui"):SetTopbarTransparency(0)
            plr:WaitForChild("PlayerGui"):SetCore("SendNotification", {
                Title = "Tag Game",
                Text = message,
                Duration = 5
            })
        end)
        -- Ignore errors; notifications are optional.
    end
end

-- Assign the first player who joins to be the Mom and the second to be the
-- Child.  If more than two players join, they will remain unassigned.
local function assignRoles()
    local allPlayers = Players:GetPlayers()
    if #allPlayers < 2 then
        return nil, nil
    end
    local momPlayer = allPlayers[1]
    local childPlayer = allPlayers[2]
    momPlayer.Team = momTeam
    childPlayer.Team = childTeam
    return momPlayer, childPlayer
end

-- Sets up a touched event so that if the Mom touches the Child, the Mom wins.
local function setupTouchListener(momPlayer, childPlayer)
    -- Wait for both characters to exist.
    local momChar = momPlayer.Character or momPlayer.CharacterAdded:Wait()
    local childChar = childPlayer.Character or childPlayer.CharacterAdded:Wait()
    local momRoot = momChar:WaitForChild("HumanoidRootPart")
    local childHumanoid = childChar:WaitForChild("Humanoid")

    -- If a previous listener exists, disconnect it to avoid duplicate logic.
    if roundConnection then
        roundConnection:Disconnect()
        roundConnection = nil
    end

    roundConnection = momRoot.Touched:Connect(function(otherPart)
        if not roundInProgress then
            return
        end
        local otherChar = otherPart and otherPart.Parent
        if not otherChar then
            return
        end
        local otherPlayer = Players:GetPlayerFromCharacter(otherChar)
        -- If the Mom touches the Child's character, end the round.
        if otherPlayer == childPlayer then
            roundInProgress = false
            announce("Mom caught the Child! Mom wins!")
            -- Respawn both players to reset positions for the next round.
            momPlayer:LoadCharacter()
            childPlayer:LoadCharacter()
        end
    end)
end

-- Starts a new round if there are at least two players in the game.  Assigns
-- roles, connects the touch listener, and runs a countdown.  If the timer
-- expires before the Mom catches the Child, the Child wins.
local function startRound()
    if roundInProgress then
        return
    end
    local momPlayer, childPlayer = assignRoles()
    if not momPlayer or not childPlayer then
        return
    end
    -- Ensure both players respawn so they start fresh each round.
    momPlayer:LoadCharacter()
    childPlayer:LoadCharacter()

    -- Connect touch detection between the Mom and the Child.
    setupTouchListener(momPlayer, childPlayer)
    roundInProgress = true
    announce("New round started! Mom vs. Child")

    -- Run the countdown timer.
    local timeRemaining = roundTime
    while roundInProgress and timeRemaining > 0 do
        wait(1)
        timeRemaining = timeRemaining - 1
        -- Optionally, broadcast the remaining time to the players here.
    end

    -- If the round hasn't been stopped by a touch event, the Child wins.
    if roundInProgress then
        roundInProgress = false
        announce("Time's up! The Child survived and wins!")
        -- Respawn both players for the next round.
        momPlayer:LoadCharacter()
        childPlayer:LoadCharacter()
    end
end

-- When a new player joins, try to start a round if we have at least two
-- players waiting.
Players.PlayerAdded:Connect(function(player)
    -- Connect a CharacterAdded handler to ensure future spawns behave
    -- correctly during rounds.
    player.CharacterAdded:Connect(function()
        -- If a round is already in progress, do nothing here.
    end)
    -- If there are now at least two players, start a new round after a short delay.
    if #Players:GetPlayers() >= 2 then
        -- Delay to allow the second player's character to spawn.
        delay(2, startRound)
    end
end)

-- If a player leaves and there aren't enough players for a round, stop
-- the current round.
Players.PlayerRemoving:Connect(function(player)
    if #Players:GetPlayers() - 1 < 2 then
        roundInProgress = false
        announce("A player left. Waiting for more players to start a round.")
        -- Disconnect any existing touch listener.
        if roundConnection then
            roundConnection:Disconnect()
            roundConnection = nil
        end
    end
end)
