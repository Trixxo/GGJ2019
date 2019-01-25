function getPlayer()
    player = {}

    player.position = {x = 100, y = 100}
    player.dimension = {width = 50, height = 50}
    local body = love.physics.newBody(world)
    body:setMass(50)
    local shape = love.physics.newRectangleShape(player.dimension.width, player.dimension.height)
    player.fixture = love.physics.newFixture(body, shape, 1)

    function player:update(dt)
    end

    function player:draw()
        love.graphics.setColor(255, 0, 0, 1)
        love.graphics.rectangle(
            'fill', 
            self.position.x,
            self.position.y,
            self.dimension.width,
            self.dimension.height
        )
    end

    return player
end
