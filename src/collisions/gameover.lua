local getGameOverState = require("states/gameoverstate")
local getExplosion = require("entity/explosion")

local function gameOverCollision(fixtureA, fixtureB, key)
    local objectA = fixtureA:getUserData()
    local objectB = fixtureB:getUserData()

    --print(objectA.name .. " colliding with " .. objectB.name)
    if objectA.name == "ground" and objectB.name == "player" or
        objectB.name == "ground" and objectA.name == "player" or
        objectA.name == "seagull" and objectB.name == "player" or
        objectB.name == "seagull" and objectA.name == "player" or
        objectA.name == "asteroid" and objectB.name == "player" or
        objectB.name == "asteroid" and objectA.name == "player" then

        local player
        if objectA.name == "player" then
            player = objectA
        else
            player = objectB
        end
        if player.dead == false then
            print("player dead")
            player.dead = true
            music.queueEvent("death")
            player.body:setLinearVelocity(0,10)
            player.body:setAngularVelocity(0,0)
        else 
            return
        end

        local positionX, positionY = player.body:getPosition()

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

return gameOverCollision
