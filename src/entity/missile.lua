local function getMissile(x, y)
    missile = {}

    missile.dimension = {width = 50, height = 50}
    missile.image = resources.images.missile
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)
    missile.body = love.physics.newBody(world, x, y, "dynamic")
    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.drawType = 'image'

    function missile:update(dt)
        missile.body:applyLinearImpulse(2, -50)
    end

    return missile
end

return getMissile
