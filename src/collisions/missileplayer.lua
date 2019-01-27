local function missilePlayerCollision(fixtureA, fixtureB, key)
    local objectA = fixtureA:getUserData()
    local objectB = fixtureB:getUserData()

    -- print(objectA.name .. " colliding with " .. objectB.name)
    if objectA.name == "missile" and objectB.name == "player" or
        objectB.name == "missile" and objectA.name == "player" then
        local missile
        local player
        if objectA.name == 'missile' then
            missile = objectA
            player = objectB
        else
            missile = objectB
            player = objectA
        end

        if love.keyboard.isDown("lshift") == false and love.keyboard.isDown("rshift") == false then
            player.missileToConnect = missile
        end
    end
end

return missilePlayerCollision
