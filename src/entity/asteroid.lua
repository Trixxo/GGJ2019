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
    asteroid.body:setMass(99999999999)
    asteroid.body:setGravityScale(0)

    asteroid.fixture = love.physics.newFixture(asteroid.body, asteroid.shape, 1)
    asteroid.fixture:setUserData(asteroid)
    -- asteroid.fixture:setCategory(3)
    -- asteroid.fixture:setMask(3, 4)
    --
    -- function asteroid:update(dt)
    --     self.body:setLinearVelocity(0.0, 0.0)
    -- end

    return asteroid
end

return getAsteroid
