local getMissile = require("entity/missile")
local camera = require("core/camera")

local function getMissileSpawner()
    missileSpawner = {}

    missileSpawner.spawntime = 1
    missileSpawner.spawncounter = 0

    function missileSpawner:update(dt)
        -- Spawn random missiles (lets move this to a seperate file
        if self.spawncounter > self.spawntime then
            state = stack:current()
            local randomspawn = {
                x = camera.x - 100,
                y = math.random() * settings.resolution.height * 0.4
            }
            local new_missile = getMissile(randomspawn.x, randomspawn.y)
            -- print("Spawning missile at ", randomspawn.x, randomspawn.y)
            table.insert(state.entities, new_missile)
            self.spawncounter = 0

        else
            self.spawncounter = self.spawncounter + dt
        end
    end

    return missileSpawner
end

return getMissileSpawner
