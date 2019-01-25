local function getMissile()
    missile = {}

    missile.position = {x = 50, y = 50}
    missile.dimension = {width = 50, height = 50}
    missile.image = resources.images.missile
    local body = love.physics.newBody(world)
    body:setMass(50)
    local shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)
    missile.fixture = love.physics.newFixture(body, shape, 1)
    missile.drawType = 'image'

    function missile:update(dt)
    end

    return missile
end

return getMissile
