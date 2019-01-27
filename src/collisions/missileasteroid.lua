local getExplosion = require("entity/explosion")

local function missileAsteroidCollision(fixtureA, fixtureB, key)
    local objectA = fixtureA:getUserData()
    local objectB = fixtureB:getUserData()

    -- print(objectA.name .. " colliding with " .. objectB.name)
    if objectA.name == "missile" and objectB.name == "asteroid" or
        objectB.name == "missile" and objectA.name == "asteroid" then
        local missile
        if objectA.name == 'missile' then
            missile = objectA
        else
            missile = objectB
        end
        missile.destroyed = true
        stack:current().textGrapplingSystem:removeMissile(missile)
        state.missileSpawner.missile_count = state.missileSpawner.missile_count - 1

        local positionX, positionY = missile.body:getPosition()

        -- Spawning explosion
        local explosion = getExplosion(positionX, positionY)
        table.insert(stack:current().entitiesToSpawn, explosion)

        stack:current():addExplosionDistortion(positionX, positionY)
        if positionX > camera.x - 100 and
            positionX < camera.x + settings.resolution.width + 100 then
            music.queueEvent("explosion")
        end
    end
end

return missileAsteroidCollision
