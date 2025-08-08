-- MapGenerator.lua
-- Generates different maps for the tag game. Each function clears existing
-- generated parts and builds a new terrain. You can add more maps by
-- following the same pattern.
--
-- Functions available:
--   GenerateJungle()   -- dense jungle with many trees
--   GenerateMeadow()   -- open grassy meadow with scattered rocks
--   GenerateDesert()   -- sandy desert with dunes
--   GenerateForest()   -- forest with pine trees and rocks
--   GenerateCave()     -- cave with stalagmites and boulders
--   GenerateRandomMap() -- chooses a random map to generate and returns its name
--
-- To use, require this module in a server script and call the desired
-- generator function. For example:
--   local MapGenerator = require(game.ServerScriptService.MapGenerator)
--   local mapName = MapGenerator.GenerateRandomMap()

local MapGenerator = {}

-- Utility function to clear any previously generated parts
local function clearMap()
  for _, obj in ipairs(workspace:GetChildren()) do
    if obj:IsA("BasePart") and obj.Name == "GeneratedPart" then
      obj:Destroy()
    end
  end
end

-- Jungle map: dense jungle with many trees
function MapGenerator.GenerateJungle()
  clearMap()
  -- Create base ground
  local ground = Instance.new("Part")
  ground.Name = "GeneratedPart"
  ground.Size = Vector3.new(500, 1, 500)
  ground.Position = Vector3.new(0, 0, 0)
  ground.Anchored = true
  ground.Color = Color3.fromRGB(34, 139, 34) -- forest green
  ground.Parent = workspace
  
  -- Create trees
  local treeCount = 60
  for i = 1, treeCount do
    local trunk = Instance.new("Part")
    trunk.Name = "GeneratedPart"
    trunk.Size = Vector3.new(2, 12, 2)
    trunk.Anchored = true
    trunk.Color = Color3.fromRGB(101, 67, 33)
    trunk.Position = Vector3.new(math.random(-240, 240), 6, math.random(-240, 240))
    trunk.Parent = workspace

    local leaves = Instance.new("Part")
    leaves.Name = "GeneratedPart"
    leaves.Shape = Enum.PartType.Ball
    leaves.Size = Vector3.new(12, 12, 12)
    leaves.Anchored = true
    leaves.Color = Color3.fromRGB(0, 153, 0)
    leaves.Position = trunk.Position + Vector3.new(0, trunk.Size.Y/2 + leaves.Size.Y/2, 0)
    leaves.Parent = workspace
  end
end

-- Meadow map: open grassy meadow with scattered rocks
function MapGenerator.GenerateMeadow()
  clearMap()
  local ground = Instance.new("Part")
  ground.Name = "GeneratedPart"
  ground.Size = Vector3.new(500, 1, 500)
  ground.Position = Vector3.new(0, 0, 0)
  ground.Anchored = true
  ground.Color = Color3.fromRGB(144, 238, 144) -- light green
  ground.Parent = workspace
  
  -- Add rocks
  for i = 1, 25 do
    local rock = Instance.new("Part")
    rock.Name = "GeneratedPart"
    rock.Size = Vector3.new(math.random(2, 6), math.random(2, 5), math.random(2, 6))
    rock.Anchored = true
    rock.Color = Color3.fromRGB(160, 160, 160)
    rock.Position = Vector3.new(math.random(-240, 240), rock.Size.Y/2, math.random(-240, 240))
    rock.Parent = workspace
  end
end

-- Desert map: sandy desert with dunes
function MapGenerator.GenerateDesert()
  clearMap()
  local ground = Instance.new("Part")
  ground.Name = "GeneratedPart"
  ground.Size = Vector3.new(500, 1, 500)
  ground.Position = Vector3.new(0, 0, 0)
  ground.Anchored = true
  ground.Color = Color3.fromRGB(237, 201, 175) -- sand color
  ground.Parent = workspace
  
  -- Create dunes
  for i = 1, 20 do
    local dune = Instance.new("Part")
    dune.Name = "GeneratedPart"
    dune.Size = Vector3.new(math.random(20, 40), math.random(3, 8), math.random(20, 40))
    dune.Anchored = true
    dune.Color = Color3.fromRGB(210, 180, 140)
    dune.Position = Vector3.new(math.random(-220, 220), dune.Size.Y/2, math.random(-220, 220))
    dune.Parent = workspace
  end
end

-- Forest map: pine trees and rocks on grassy ground
function MapGenerator.GenerateForest()
  clearMap()
  local ground = Instance.new("Part")
  ground.Name = "GeneratedPart"
  ground.Size = Vector3.new(500, 1, 500)
  ground.Position = Vector3.new(0, 0, 0)
  ground.Anchored = true
  ground.Color = Color3.fromRGB(80, 200, 120) -- grassy green
  ground.Parent = workspace
  
  -- Pine trees
  for i = 1, 50 do
    local trunk = Instance.new("Part")
    trunk.Name = "GeneratedPart"
    trunk.Size = Vector3.new(2, 12, 2)
    trunk.Color = Color3.fromRGB(101, 67, 33)
    trunk.Anchored = true
    trunk.Position = Vector3.new(math.random(-240, 240), 6, math.random(-240, 240))
    trunk.Parent = workspace

    local foliage = Instance.new("Part")
    foliage.Name = "GeneratedPart"
    foliage.Shape = Enum.PartType.Ball
    foliage.Size = Vector3.new(12, 12, 12)
    foliage.Color = Color3.fromRGB(34, 139, 34)
    foliage.Anchored = true
    foliage.Position = trunk.Position + Vector3.new(0, trunk.Size.Y/2 + foliage.Size.Y/2, 0)
    foliage.Parent = workspace
  end

  -- Rocks
  for i = 1, 20 do
    local rock = Instance.new("Part")
    rock.Name = "GeneratedPart"
    rock.Size = Vector3.new(math.random(3, 8), math.random(2, 4), math.random(3, 8))
    rock.Color = Color3.fromRGB(130, 130, 130)
    rock.Anchored = true
    rock.Position = Vector3.new(math.random(-240, 240), rock.Size.Y/2, math.random(-240, 240))
    rock.Parent = workspace
  end
end

-- Cave map: rocky floor with stalagmites and boulders
function MapGenerator.GenerateCave()
  clearMap()
  local ground = Instance.new("Part")
  ground.Name = "GeneratedPart"
  ground.Size = Vector3.new(500, 1, 500)
  ground.Position = Vector3.new(0, 0, 0)
  ground.Anchored = true
  ground.Color = Color3.fromRGB(80, 80, 80) -- dark stone
  ground.Parent = workspace
  
  -- Stalagmites
  for i = 1, 30 do
    local stalagmite = Instance.new("Part")
    stalagmite.Name = "GeneratedPart"
    stalagmite.Shape = Enum.PartType.Ball
    stalagmite.Size = Vector3.new(math.random(2, 5), math.random(8, 14), math.random(2, 5))
    stalagmite.Color = Color3.fromRGB(100, 100, 100)
    stalagmite.Anchored = true
    stalagmite.Position = Vector3.new(math.random(-240, 240), stalagmite.Size.Y/2, math.random(-240, 240))
    stalagmite.Parent = workspace
  end

  -- Boulders
  for i = 1, 15 do
    local boulder = Instance.new("Part")
    boulder.Name = "GeneratedPart"
    boulder.Shape = Enum.PartType.Ball
    local size = math.random(6, 12)
    boulder.Size = Vector3.new(size, size, size)
    boulder.Color = Color3.fromRGB(120, 120, 120)
    boulder.Anchored = true
    boulder.Position = Vector3.new(math.random(-220, 220), size/2, math.random(-220, 220))
    boulder.Parent = workspace
  end
end

-- Randomly choose and generate one of the available maps
function MapGenerator.GenerateRandomMap()
  local generators = {
    MapGenerator.GenerateJungle,
    MapGenerator.GenerateMeadow,
    MapGenerator.GenerateDesert,
    MapGenerator.GenerateForest,
    MapGenerator.GenerateCave
  }
  local names = {"Jungle", "Meadow", "Desert", "Forest", "Cave"}
  local index = math.random(1, #generators)
  generators[index]()
  return names[index]
end

return MapGenerator
