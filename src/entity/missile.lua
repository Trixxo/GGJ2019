local getVector = require("core/vector")

local function getMissile(x, y)
    local missile = {}
    local missileVel = math.random(200, 500)

    missile.name = 'missile'
    missile.drawType = 'image'
    missile.categoryTimer = 2
    missile.resetCategory = false
    missile.destroyed = false
    missile.flightTime = math.random(7,10)

    missile.dimension = {width = 70, height = 20}
    missile.image = resources.images.missile
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)

    missile.body = love.physics.newBody(world, x, y, "kinematic")
    missile.body:setMass(10000)
    --missile.body:setInertia(1000)
    missile.body:setLinearDamping(0.3)


    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.fixture:setUserData(missile)
    missile.fixture:setCategory(3)
    missile.fixture:setMask(3, 4)

    -- Particle emitter settings.
    missile.particleSystem = love.graphics.newParticleSystem(resources.images.exhaust)
    missile.particleSystem:setSizes(0.04, 0.04, 0.03, 0.03, 0.03, 0.02)
    missile.particleSystem:setRotation(math.pi / 2)
    missile.particleSystem:setColors(1, 1, 1, 0.2, 1, 1, 1, 1, 1, 1, 1, 0)

    missile.particleSystem:setParticleLifetime(0.3, 0.5)
    missile.particleSystem:setEmissionRate(20)

    missile.particleSystem:setEmissionArea('normal', 2, 2)

    missile.particleSystem:setDirection(math.pi)
    missile.particleSystem:setSpeed(70, 150)
    missile.particleSystem:setSpread(math.pi / 6)

    missile.particleSystem:start()

    function missile:getEmitterPosition()
        local positionX, positionY = self.body:getPosition()
        local angle = self.body:getAngle()
        local directionX = math.cos(angle)
        local directionY = math.sin(angle)
        local offsetX = positionX - 0.6 * directionX * self.dimension.width
        local offsetY = positionY - 0.5 * directionY * self.dimension.width
        return offsetX, offsetY
    end

    function missile:update(dt)
        local missileX, missileY = self.body:getPosition()
        self.particleSystem:update(dt)
        self.flightTime = self.flightTime - dt

        if self.flightTime <= 0 then
            self.particleSystem:stop()
        elseif self.flightTime <= 0.3 then
            self.particleSystem:start()
        elseif self.flightTime <= 0.6 then
            self.particleSystem:stop()
        elseif self.flightTime <= 0.8 then
            self.particleSystem:start()
        elseif self.flightTime <= 1 then
            self.particleSystem:stop()
        elseif self.flightTime <= 1.3 then
            self.particleSystem:start()
        elseif self.flightTime <= 1.5 then
            self.particleSystem:stop()
        end

        if self.flightTime <= 0 then
            self.body:setType("dynamic")
            self.body:applyTorque(0.5)
            self.fixture:setCategory(4)
            self.fixture:setMask(1, 3, 4)
        else

        --local angle = missile.body:getAngle()
        --local acceleration = getVector(1000 * dt, 0):rotate(angle)
        --self.body:applyLinearImpulse(acceleration.x, acceleration.y)
        --self.body:applyTorque(700)
        --self.body:setPosition(missileX + acceleration.x, missileY)

           self.body:setAngularVelocity(0.06)
           local angle = self.body:getAngle()
           local velocity = getVector(missileVel, 0):rotate(angle)
           self.body:setLinearVelocity(velocity.x, velocity.y)

        --self.body:setAngle(math.pi)
        end

        if self.resetCategory then
            self.resetCategoryTimer = self.resetCategoryTimer - dt
            if self.resetCategoryTimer <= 0 then
                self.resetCategory = false
                self.fixture:setCategory(3)
                self.resetCategoryTimer = 2
                missile.fixture:setMask(3, 4)
            end
        end
    end

    return missile
end

return getMissile
