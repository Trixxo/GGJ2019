local function getPlayer()
    local player = {}
    player.name = 'player'
    player.drawType = 'rectangle'
    player.destroyed = false

    player.dimension = {width = 50, height = 50}
    player.shape = love.physics.newRectangleShape(player.dimension.width, player.dimension.height)

    player.body = love.physics.newBody(world, 100, 100, "dynamic")
    player.body:setMass(10)

    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.fixture:setUserData(player)

    function player:update(dt)
        local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
            local entity = fixture:getUserData()
            if entity.name == "missile" then
                player.body:applyLinearImpulse(0, -150)
                return 0
            end
            
            return 1 -- Continues with ray cast through all shapes.
        end
        local playerX, playerY = self.body:getPosition()
        local mouseX, mouseY = love.mouse.getPosition()

        if love.mouse.isDown(1) then
            world:rayCast(
                playerX,
                playerY,
                mouseX,
                mouseY,
                worldRayCastCallback
            )
        end

        if love.keyboard.isDown("a") then
            self.body:applyLinearImpulse(-50,0)
        end
        if love.keyboard.isDown("d") then
            self.body:applyLinearImpulse(50,0)
        end
    end

    function player:keypressed(key, scancode, isrepeat)
        if scancode == "w" then
            self.body:applyLinearImpulse(0,-2000)
        elseif scancode == "s" then
            self.body:applyLinearImpulse(0,2000)
        end
    end

    return player
end

return getPlayer
