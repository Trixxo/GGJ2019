local getMissile = require("entity/missile")
local camera = require("core/camera")

local function getMissileSpawner()
    missileSpawner = {}

    missileSpawner.spawntime = 1
    missileSpawner.spawncounter = 0
    missileSpawner.missile_count = 0

    function missileSpawner:update(dt)
        -- Spawn random missiles (lets move this to a seperate file
        if self.spawncounter > self.spawntime then
            state = stack:current()
            local randomspawn = {
                x = camera.x + math.random(settings.resolution.width/4, settings.resolution.width * 2),
                y = math.random(-30, -10)
            }
            local new_missile = getMissile(randomspawn.x, randomspawn.y)
            -- print("Spawning missile at ", randomspawn.x, randomspawn.y)
            state.textGrapplingSystem:registerMissile(new_missile)
            table.insert(state.entities, new_missile)

            self.missile_count = self.missile_count + 1
            music.bpm = music.initial_bpm + self.missile_count
            self.spawncounter = 0

        else
            self.spawncounter = self.spawncounter + dt
        end
    end

    return missileSpawner
end

return getMissileSpawner
