local getVector = require("core/vector")
local getExplosion = require("entity/explosion")

local function getMissile(x, y, explosive)
    local missile = {}
    missile.missileVel = math.random(200, 500)

    missile.name = 'missile'
    missile.drawType = 'image'
    missile.categoryTimer = 2
    missile.resetCategory = false
    missile.destroyed = false
    missile.flightTime = math.random(7, 10)
    missile.falling = true
    missile.explosive = explosive

    missile.dimension = {width = 70, height = 24}
    missile.image = resources.images.missile
    missile.shape = love.physics.newRectangleShape(missile.dimension.width, missile.dimension.height)

    missile.body = love.physics.newBody(world, x, y, "kinematic")
    missile.body:setMass(10000)
    missile.body:setLinearDamping(0.3)


    missile.fixture = love.physics.newFixture(missile.body, missile.shape, 1)
    missile.fixture:setUserData(missile)
    missile.fixture:setCategory(3)
    missile.fixture:setMask(3, 4)

    -- Particle emitter settings.
    missile.particleSystem = love.graphics.newParticleSystem(resources.images.exhaust)
    missile.particleSystem:setSizes(0.08, 0.12)
    missile.particleSystem:setSizeVariation(0.5)
    missile.particleSystem:setRotation(math.pi / 2)
    missile.particleSystem:setColors(1, 0.7, 0.5, 0.9,
                                     0.5, 0.2, 0.2, 0)

    missile.particleSystem:setParticleLifetime(0.4, 0.5)
    missile.particleSystem:setEmissionRate(10)

    missile.particleSystem:setDirection(math.pi)
    missile.particleSystem:setSpeed(120, 150)
    missile.particleSystem:setSpread(math.pi / 12)

    missile.particleSystem:start()

    missile.startTimer = 0.25

    function missile:getEmitterPosition()
        local positionX, positionY = self.body:getPosition()
        local offset = getVector(self.dimension.width * 0.7, -1)
            :rotate(self.body:getAngle())
        local particlePos = getVector(positionX, positionY)
            :subtract(offset)

        return particlePos.x, particlePos.y
    end

    function missile:update(dt)
        local missileX, missileY = self.body:getPosition()

        self.startTimer = self.startTimer - dt
        if self.startTimer <= 0 then
            self.startTimer = 0.25
        end
        --print(self.startTimer)
        -- Particlesystem logic
        self.particleSystem:update(dt)
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

        -- Flight time logic
        self.flightTime = self.flightTime - dt
        if self.flightTime <= 0 or
            missileY > settings.resolution.height - (25 * settings.scale) - (50 * settings.scale)  then
            self.body:setType("dynamic")
            self.body:applyTorque(0.5)
            self.fixture:setCategory(4)
            self.fixture:setMask(1, 3, 4)
        else
            -- local angle = missile.body:getAngle()
            -- local acceleration = getVector(1000 * dt, 0):rotate(angle)
            -- self.body:applyLinearImpulse(acceleration.x, acceleration.y)
            -- self.body:applyTorque(700)
            -- self.body:setPosition(missileX + acceleration.x, missileY)
            if missile.falling then
                -- Movement logic
                self.body:setAngularVelocity(0.06)
            end

            local angle = self.body:getAngle()
            local velocity = getVector(missile.missileVel, 0):rotate(angle)
            if not self:isOnScreen() then
                velocity = velocity:multiply(1.5)
            end
            self.body:setLinearVelocity(velocity.x, velocity.y)
            --self.body:setAngle(math.pi)

        end

        -- Reset category logic to handle new collision mask in
        -- case the missile was just grabbed on by the player
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

    function missile:draw()
        local x, y = self.body:getPosition()
        local offset = getVector((self.dimension.width / 2) - 10, 0):rotate(self.body:getAngle())
        --print (offset.y)
        if self.text then
            love.graphics.print(self.text,
                                x,
                                y - self.dimension.height * 1.5,
                                0,
                                1.5,
                                1.5
            )
        end
        if missile.explosive == 3 then
            if self.startTimer <= 0.125 then
               love.graphics.setColor(255, 0, 0, 0.8)
               love.graphics.circle("fill", x - offset.x, y - offset.y, 7)
            elseif self.startTimer >= 0.125 then
               love.graphics.setColor(1, 1, 1, 0)
               love.graphics.circle("fill", x - offset.x, y - offset.y, 7)
            end
        end
        love.graphics.setColor(255, 255, 255)
    end

    function missile:isOnScreen()
        local x, y = self.body:getPosition()
        return x > camera.x - 200 and x < camera.x + settings.resolution.width + 200 and
            y > camera.y - 200 and y < camera.y + settings.resolution.height + 200
    end

    function missile:explode()
        self.destroyed = true
        stack:current().textGrapplingSystem:removeMissile(self)
        state.missileSpawner.missile_count = state.missileSpawner.missile_count - 1

        local positionX, positionY = missile.body:getPosition()

        -- Spawning explosion
        local explosion = getExplosion(positionX, positionY)
        table.insert(stack:current().entitiesToSpawn, explosion)

        stack:current():addExplosionDistortion(positionX, positionY)
        if positionX > camera.x - 100 and
            positionX < camera.x + settings.resolution.width + 100 then
            music.queueEvent("explosion")
        end
    end
    return missile
end
return getMissile
