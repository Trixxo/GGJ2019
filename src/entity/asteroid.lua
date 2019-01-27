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
    asteroid.shape = love.physics.newCircleShape(asteroid.dimension.width / 2)
    asteroid.body = love.physics.newBody(world, x, y, "dynamic")

    asteroid.body:setGravityScale(0)
    asteroid.body:setMass(99999999999)
    asteroid.body:setAngularVelocity(math.random(-1,1))

    asteroid.fixture = love.physics.newFixture(asteroid.body, asteroid.shape, 1)
    asteroid.fixture:setUserData(asteroid)
    asteroid.fixture:setCategory(5)

    asteroid.particleSystem = love.graphics.newParticleSystem(resources.images.softCircle)
    asteroid.particleSystem:setEmissionRate(2)
    asteroid.particleSystem:setDirection(-math.pi/2)
    asteroid.particleSystem:setSpeed(100, 180)
    asteroid.particleSystem:setParticleLifetime(3, 4)

    asteroid.particleSystem:setSizes(1.4, 3.0)
    asteroid.particleSystem:setSizeVariation(0.5)

    asteroid.particleSystem:setColors(1, 0.8, 0.25, 0,
                                      1, 0.5, 0.1, 0.8,
                                      1, 0.3, 0.1, 0)
    asteroid.particleSystem:start()

    asteroid.color = {r = 1, g = 1, b = 1, a = 1}

    function asteroid:getEmitterPosition()
        local x, y = self.body:getPosition()
        return x, y
    end

    function asteroid:update(dt)
        self.particleSystem:update(dt)
    end

    return asteroid
end

return getAsteroid
