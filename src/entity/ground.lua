local function getGround()
    ground = {}

    ground.name = 'ground'
    ground.drawType = 'rectangle'

    ground.dimension = {width = 1200, height = 50}
    ground.body = love.physics.newBody(world, 600, 750, "static")
    local shape = love.physics.newRectangleShape(ground.dimension.width, ground.dimension.height)

    ground.fixture = love.physics.newFixture(ground.body, shape, 1)
    ground.fixture:setUserData(ground)

    return ground
end

return getGround
