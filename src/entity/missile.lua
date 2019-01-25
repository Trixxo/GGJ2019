local getVector = require("core/vector")

local function getMissile(x, y)
    local missile = {}

    missile.name = 'missile'
    missile.drawType = 'image'

    missile.dimension = {width = 100, height = 50}
    missile.image = resources.images.missile
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)

    missile.body = love.physics.newBody(world, x, y, "dynamic")
    missile.body:setAngle(-math.pi/2)

    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.fixture:setUserData(missile)

    function missile:update(dt)
        local angle = missile.body:getAngle()
        local acceleration = getVector(2700*dt, 0):rotate(angle)
        self.body:applyLinearImpulse(acceleration.x, acceleration.y)
        self.body:applyTorque(70)
    end

    return missile
end

return getMissile
