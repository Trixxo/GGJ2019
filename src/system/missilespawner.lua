local getMissile = require("entity/missile")
local camera = require("core/camera")

local function getMissileSpawner()
    missileSpawner = {}

    missileSpawner.spawntime = 1
    missileSpawner.spawncounter = 0
    missileSpawner.missile_count = 0

    function missileSpawner:update(dt)
        -- Spawn random missiles.
        if self.spawncounter > self.spawntime then
            state = stack:current()
            local sw = settings.resolution.width
            local sh = settings.resolution.height
            local randomspawn = {
                x = camera.x + sw + math.random(sw * 0.1, sw * 0.3),
                y = math.max(-sh/2, camera.y + math.random(-sh/2, sh/2))
            }
            local new_missile = getMissile(randomspawn.x, randomspawn.y)
            -- print("Spawning missile at ", randomspawn.x, randomspawn.y)
            state.textGrapplingSystem:registerMissile(new_missile)
            table.insert(state.entities, new_missile)

            self.missile_count = self.missile_count + 1
            -- music.bpm = music.initial_bpm + self.missile_count
            self.spawncounter = 0

        else
            self.spawncounter = self.spawncounter + dt
        end
    end

    return missileSpawner
end

return getMissileSpawner
