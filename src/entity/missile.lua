local getVector = require("core/vector")

local function getMissile(x, y)
    local missile = {}
    missile.name = 'missile'
    missile.drawType = 'image'
    missile.destroyed = false

    missile.dimension = {width = 70, height = 20}
    missile.image = resources.images.missile
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)

    missile.body = love.physics.newBody(world, x, y, "dynamic")
    missile.body:setAngle(-math.pi/2)

    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.fixture:setUserData(missile)

    -- Particle emitter settings.
    missile.particleSystem = love.graphics.newParticleSystem(resources.images.exhaust)
    missile.particleSystem:setSizes(0.04, 0.04, 0.03, 0.03, 0.03, 0.02, 0.01, 0.01)
    missile.particleSystem:setRotation(math.pi / 2)

    missile.particleSystem:setParticleLifetime(0.03, 0.05)
    missile.particleSystem:setEmissionRate(200)

    missile.particleSystem:setAreaSpread('normal', 2, 3)

    missile.particleSystem:setDirection(math.pi)
    missile.particleSystem:setSpeed(500, 1000)
    missile.particleSystem:setSpread(math.pi / 6)


    -- missile.particleSystem:setRadialAcceleration(10, 1000)
    -- missile.particleSystem:setRelativeRotation(true)
    -- missile.particleSystem:setTangentialAcceleration(10, 1000)
    missile.particleSystem:start()

    function missile:getEmitterPosition()
        local positionX, positionY = self.body:getPosition()
        local angle = self.body:getAngle()
        local directionX = math.cos(angle)
        local directionY = math.sin(angle)
        local offsetX = positionX - 0.5 * directionX * self.dimension.width
        local offsetY = positionY - 0.5 * directionY * self.dimension.width
        return offsetX, offsetY
    end

    function missile:update(dt)
        self.particleSystem:update(dt)

        local angle = missile.body:getAngle()
        local acceleration = getVector(1000 * dt, 0):rotate(angle)
        self.body:applyLinearImpulse(acceleration.x, acceleration.y)
        self.body:applyTorque(700)
    end

    return missile
end

return getMissile
