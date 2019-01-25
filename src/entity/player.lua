local function getPlayer()
    player = {}

    player.position = {x = 100, y = 100}
    player.dimension = {width = 50, height = 50}
    local body = love.physics.newBody(world)
    body:setMass(50)
    local shape = love.physics.newRectangleShape(player.dimension.width, player.dimension.height)
    player.fixture = love.physics.newFixture(body, shape, 1)
    player.drawType = 'rectangle'

    function player:update(dt)
    end
    
    return player
end

return getPlayer
