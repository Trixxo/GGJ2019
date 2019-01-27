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
    --asteroid.fixture:setMask(1)

    asteroid.body:setMass(1000)

    return asteroid
end

return getAsteroid
