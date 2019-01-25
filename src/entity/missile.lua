local getVector = require("core/vector")

local function getMissile(x, y)
    missile = {}

    missile.dimension = {width = 50, height = 50}
    missile.image = resources.images.missile
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)
    missile.body = love.physics.newBody(world, x, y, "dynamic")
    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.drawType = 'image'
    missile.body:setAngle(-math.pi/2)

    function missile:update(dt)
        local angle = missile.body:getAngle()
        local acceleration = getVector(2700*dt, 0):rotate(angle)
        missile.body:applyLinearImpulse(acceleration.x, acceleration.y)
        missile.body:applyTorque(70)
    end

    return missile
end

return getMissile
