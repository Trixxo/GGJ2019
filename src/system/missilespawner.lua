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

            local relativeHeight = math.random(camera.y - 200, camera.y - 50)

            -- Spawn missiles above camera in the middle of the x-axis if we aren't too high up in the sky
            if (relativeHeight < 0 and relativeHeight >= -sh * 0.5) or relativeHeight >= 0 then
                y = relativeHeight
                x = camera.x + sw/2 + math.random(sw * 0.1, sw * 0.3)
            -- Spawn missiles below between 1/2 of the screen and 1+1/3 of the screen, if we are too high up in the sky
            else
                x = camera.x + math.random(sw * 0.5, sw * 1.3)
                y = math.max(-sw*0.5, camera.y + sh)
            end

            local randomspawn = {
                x = x,
                y = y,
            }
            local new_missile = getMissile(randomspawn.x, randomspawn.y, math.random(5))
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
