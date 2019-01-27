local function getGround()
    local ground = {}

    ground.name = 'ground'
    ground.drawType = 'rectangle'
    ground.destroyed = false

    ground.dimension = {width = 500000, height = 50 * settings.scale}
    ground.body = love.physics.newBody(
        world,
        settings.resolution.width/2,
        settings.resolution.height - (25 * settings.scale),
        "static"
    )
    local shape = love.physics.newRectangleShape(ground.dimension.width, ground.dimension.height)

    ground.fixture = love.physics.newFixture(ground.body, shape, 1)
    ground.fixture:setUserData(ground)
    ground.fixture:setCategory(2)

    return ground
end

return getGround
