local function getPlayer()
    player = {}

    player.dimension = {width = 50, height = 50}
    player.shape = love.physics.newRectangleShape(player.dimension.width, player.dimension.height)
    player.body = love.physics.newBody(world, 100, 100, "dynamic")
    player.body:setMass(10)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.drawType = 'rectangle'

    function player:update(dt)
        
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
