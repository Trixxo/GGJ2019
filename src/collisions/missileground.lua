local getExplosion = require("entity/explosion")

local function missileGroundCollision(fixtureA, fixtureB, key)
    local objectA = fixtureA:getUserData()
    local objectB = fixtureB:getUserData()

    print(objectA.name .. " colliding with " .. objectB.name)
    if objectA.name == "missile" and objectB.name == "ground" or
        objectB.name == "missile" and objectA.name == "ground" then
        local missile 
        if objectA.name == 'missile' then
            missile = objectA
        else
            missile = objectB
        end
        missile.destroyed = true

        local positionX, positionY = missile.body:getPosition()

        -- Spawning explosion
        local explosion = getExplosion(positionX, positionY)
        table.insert(stack:current().entitiesToSpawn, explosion)
    end
end

return missileGroundCollision
