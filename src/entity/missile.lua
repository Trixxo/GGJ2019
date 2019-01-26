local getVector = require("core/vector")

local function getMissile(x, y)
    local missile = {}

    missile.dimension = {width = 50, height = 50}
    missile.image = resources.images.missile
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)
    missile.body = love.physics.newBody(world, x, y, "dynamic")
    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.drawType = 'image'
    missile.body:setAngle(-math.pi/2)

    missile.particleSystem = love.graphics.newParticleSystem(resources.images.exhaust)
    missile.particleSystem:setSizes(0.05)
    missile.particleSystem:setRotation(math.pi / 2)

    missile.particleSystem:setParticleLifetime(0.03, 0.05)
    missile.particleSystem:setEmissionRate(200)

    missile.particleSystem:setAreaSpread('normal', 5, 5)

    missile.particleSystem:setDirection(math.pi)
    missile.particleSystem:setSpeed(500, 1000)
    missile.particleSystem:setSpread(math.pi / 6)


    -- missile.particleSystem:setRadialAcceleration(10, 1000)
    -- missile.particleSystem:setRelativeRotation(true)
    -- missile.particleSystem:setTangentialAcceleration(10, 1000)
    missile.particleSystem:start()

    function missile:update(dt)
        self.particleSystem:update(dt)

        local angle = missile.body:getAngle()
        local acceleration = getVector(2700*dt, 0):rotate(angle)
        self.body:applyLinearImpulse(acceleration.x, acceleration.y)
        self.body:applyTorque(70)
    end

    return missile
end

return getMissile
