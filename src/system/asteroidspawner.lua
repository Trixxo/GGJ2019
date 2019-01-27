local getAsteroid = require("entity/asteroid")
local camera = require("core/camera")

local function getAsteroidSpawner()
    asteroidSpawner = {}
    asteroidSpawner.asteroid = nil

    function asteroidSpawner:update(dt)
        -- As long as the asteroid is positive - ignore.

        if self.asteroid ~= nil then
            x, y = asteroidSpawner.asteroid.body:getPosition()
            if x > camera.x - 400 and x < camera.x + settings.resolution.width + 400 then
                return
            end
            self.asteroid.destroyed = true
        end

        local randomspawn = {
            x = camera.x + settings.resolution.width + 150 + math.random(0, 150),
            y = camera.y + math.max(math.random(-400, 400), -100),
        }
        self.asteroid = getAsteroid(randomspawn.x, randomspawn.y)
        table.insert(stack:current().entities, self.asteroid)
    end

    return asteroidSpawner
end

return getAsteroidSpawner
