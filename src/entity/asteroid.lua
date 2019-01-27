local getVector = require("core/vector")

local function getAsteroid(x, y, text)
    local asteroid = {}

    asteroid.name = 'asteroid'
    asteroid.drawType = 'image'
    -- asteroid.categoryTimer = 2
    -- asteroid.resetCategory = false
    asteroid.destroyed = false

    asteroid.dimension = {width = 200, height = 200}
    asteroid.image = resources.images.asteroid
    asteroid.shape = love.physics.newCircleShape(asteroid.dimension.width/2)

    asteroid.body = love.physics.newBody(world, x, y, "dynamic")
    asteroid.body:setGravityScale(0.01)
    asteroid.body:setAngularVelocity(math.random(-1,1))

    asteroid.fixture = love.physics.newFixture(asteroid.body, asteroid.shape, 1)
    asteroid.fixture:setUserData(asteroid)
    asteroid.fixture:setCategory(5)

    asteroid.body:setMass(1000)

    asteroid.particleSystem = love.graphics.newParticleSystem(resources.images.softCircle)
    asteroid.particleSystem:setEmissionRate(4)
    asteroid.particleSystem:setEmissionArea("normal", 10, 10)
    asteroid.particleSystem:setParticleLifetime(0.5, 2)

    asteroid.particleSystem:setSizes(2.0, 1.5)
    asteroid.particleSystem:setRadialAcceleration(10)
    asteroid.particleSystem:setSizeVariation(0.5)

    asteroid.particleSystem:setColors(1, 0.5, 0.25, 0,
                                      1, 0.3, 0.1, 0.9,
                                      1, 0.1, 0.1, 0)
    asteroid.particleSystem:start()

    asteroid.syncParticleAngle = false

    asteroid.color = {r = 1, g = 0.3, b = 0.2, a = 1}

    function asteroid:getEmitterPosition()
        local x, y = self.body:getPosition()
        return x, y
    end

    function asteroid:update(dt)
        local xv, yv = self.body:getLinearVelocity()
        local speedVec = getVector(xv, yv)
        self.particleSystem:setDirection(speedVec:rotate(math.pi):getRadian())
        self.particleSystem:setSpeed(speedVec:length() * 0.5)
        self.particleSystem:update(dt)
        self.color.r = 0.8 + math.sin(love.timer.getTime() * 5) * 0.2
        self.color.g = 0.3 + math.sin(love.timer.getTime() * 2) * 0.1
    end

    return asteroid
end

return getAsteroid
