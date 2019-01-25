local function getMissile(x, y)
    missile = {}

    missile.position = {x = x, y = y}
    missile.dimension = {width = 50, height = 50}
    missile.image = resources.images.missile
    missile.body = love.physics.newBody(world)
    missile.body:setMass(50)
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)
    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.drawType = 'image'

    function missile:update(dt)
    end

    return missile
end

return getMissile
