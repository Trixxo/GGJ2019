local function getPlayer()
    player = {}

    player.dimension = {width = 50, height = 50}
    player.body = love.physics.newBody(world)
    player.body:setMass(50)
    player.body:setPosition(100,100)
    player.shape = love.physics.newRectangleShape(player.dimension.width, player.dimension.height)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.drawType = 'rectangle'

    function player:update(dt)
    end

    function player:keypressed(key, scancode, isrepeat)
        if scancode == "w" then
            self.body:applyForce(50,50)
        end
    end

    return player
end

return getPlayer
