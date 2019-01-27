local getGameWonState = require("states/gamewonstate")
local function portalPlayerCollision(fixtureA, fixtureB, key)
    local objectA = fixtureA:getUserData()
    local objectB = fixtureB:getUserData()

    print(objectA.name .. " colliding with " .. objectB.name)
    if objectA.name == "portal" and objectB.name == "player" or
        objectB.name == "portal" and objectA.name == "player" then
        local missile
        local player

        print("portal collision")
        if objectA.name == 'portal' then
            missile = objectA
            player = objectB
        else
            missile = objectB
            player = objectA
        end

        player.missileToConnect = missile
        vx, vy = player.body:getLinearVelocity()
        v = { a = vx, b = vy }
        local gameWonState = getGameWonState( v,
                    player.body:getAngularVelocity(), 
                    player.body:getAngle())
        print("before", stack:current())
        stack:push(gameWonState)
        print("after", stack:current())

    end
end

return portalPlayerCollision
