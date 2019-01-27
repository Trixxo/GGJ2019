local getVector = require("core/vector")

local function getSeagull(x, y, player)
    local seagull = {}
    seagull.name = 'seagull'
    seagull.drawType = 'image'
    seagull.destroyed = false
    seagull.text = text
    seagull.player = player

    seagull.seagullVel = math.random(100, 200)

    seagull.dimension = {width = 70, height = 70}
    seagull.image = resources.images.seagull
    seagull.shape = love.physics.newRectangleShape(seagull.dimension.width, seagull.dimension.height)

    seagull.body = love.physics.newBody(world, x, y, "kinematic")
    seagull.body:setMass(10000)
    seagull.body:setLinearDamping(0.3)

    seagull.fixture = love.physics.newFixture(seagull.body, seagull.shape, 1)
    seagull.fixture:setUserData(seagull)
    seagull.fixture:setCategory(15)
    seagull.fixture:setMask(3, 4)

    function seagull:update(dt)
        if self:isOffScreen() then
            self.destroyed = true
        end

        -- local angle = seagull.body:getAngle()
        -- local acceleration = getVector(1000 * dt, 0):rotate(angle)
        -- self.body:applyLinearImpulse(acceleration.x, acceleration.y)
        -- self.body:applyTorque(700)
        -- self.body:setPosition(seagullX + acceleration.x, seagullY)


        local playerVector = getVector(self.player.body:getX(), self.player.body:getY())
        local seagullVector = getVector(self.body:getX(), self.body:getY())
        local targetVector = playerVector:subtract(seagullVector)
        local angle = targetVector:getRadian()

        local velocity = getVector(seagull.seagullVel, 0):rotate(angle)
        self.body:setLinearVelocity(velocity.x, velocity.y)
    end

    function seagull:draw()
        local x, y = self.body:getPosition()
        local y = y - self.dimension.height * 1.5
        if self.text then
            love.graphics.print(self.text, x, y, 0, 1.5, 1.5)
        end
    end

    function seagull:isOffScreen()
        return self.body:getX() < camera.x - 100
    end

    return seagull
end

return getSeagull
