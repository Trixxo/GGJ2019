local getGameOverState = require("states/gameoverstate")

local function playerGroundCollision(fixtureA, fixtureB, key)
    local objectA = fixtureA:getUserData()
    local objectB = fixtureB:getUserData()

    print(objectA.name .. " colliding with " .. objectB.name)
    if objectA.name == "ground" and objectB.name == "player" or
        objectB.name == "ground" and objectA.name == "player" then

        local gameoverstate = getGameOverState()
        stack:push(gameoverstate)
    end
end

return playerGroundCollision
