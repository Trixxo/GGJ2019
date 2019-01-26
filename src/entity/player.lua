local getVector = require("core/vector")

local function getPlayer()
    local player = {}
    local camera = require("core/camera")
    player.name = 'player'
    player.drawType = 'image'
    player.image = resources.images.player
    player.destroyed = false
    player.missileToConnect = nil

    player.dimension = {width = 50, height = 60}
    player.shape = love.physics.newCircleShape(player.dimension.width / 2)

    player.body = love.physics.newBody(world, 100, 100, "dynamic")

    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.fixture:setUserData(player)
    player.fixture:setCategory(1)
    player.fixture:setMask(4)

    player.body:setMass(2)

    player.joint = nil
    player.joint = nil
    player.missile = nil

    function player:draw()
        if self.missile ~= nil then
            local playerX, playerY = self.body:getPosition()
            if not self.missile.body:isDestroyed() then
                local missileX, missileY = self.missile.body:getPosition()
                love.graphics.line(playerX, playerY, missileX, missileY)
            end
        end
    end

    function player:update(dt)
        if self.missileToConnect ~= nil then
            self:connectToMissile(self.missileToConnect)
            self.missileToConnect = nil
        end
        local playerX, playerY = self.body:getPosition()
        local mouseX, mouseY = love.mouse.getPosition()
        local lvx, lvy = self.body:getLinearVelocity()
        mouseX = mouseX + camera.x
        local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
            local entity = fixture:getUserData()
            if entity.name == "missile" and entity ~= self.missile then
                self:connectToMissile(entity)
                return 0
            end

            return 1 -- Continues with ray cast through all shapes.
        end

        if love.mouse.isDown(1) then
            world:rayCast(
                playerX,
                playerY,
                mouseX,
                mouseY,
                worldRayCastCallback
            )
        end

        local maxSpeed = 500
        if lvx > -maxSpeed then
            if love.keyboard.isDown("a") then
                self.body:applyLinearImpulse(-100, 0)
            end
        end

        if lvx < maxSpeed then
            if love.keyboard.isDown("d") then
                self.body:applyLinearImpulse(100, 0)
            end
        end

    end

    function player:keypressed(key, scancode, isrepeat)
        if scancode == "w" or scancode == "space" then
            self:removeJoint()

            xv, yv = self.body:getLinearVelocity()
            self.body:setLinearVelocity(xv, -600)
            music.queueEvent("jump")
        elseif scancode == "s" then
            self.body:applyLinearImpulse(0,2000)
        end
    end

    function player:connectToMissile(missile)
        if missile.fixture:isDestroyed() then
            return
        end
        self:removeJoint()

        missile.fixture:setCategory(4)
        missile.fixture:setMask(1, 3, 4)

        local joint = love.physics.newDistanceJoint(self.body, missile.body, self.body:getX(), self.body:getY(), missile.body:getX(), missile.body:getY())
        joint:setLength(50)
        joint:setDampingRatio(5)
        joint:setFrequency(1)
        self.joint = joint
        self.missile = missile
    end

    function player:removeJoint()
        if self.joint and not self.joint:isDestroyed() then
            self.joint:destroy()
            self.joint = nil
            self.missile.resetCategoryTimer = 1
            self.missile.resetCategory = true
            self.missile = nil
        end
    end

    function player:mousepressed(x, y, button , istouch, presses)
        if button == 2 then
            local mouseVector = getVector(x, y)
            local playerX, playerY = self.body:getPosition()
            local playerVector = getVector(playerX, playerY)
            local playerToMouseVector = mouseVector:subtract(playerVector)
            local unitVector = playerToMouseVector:getUnit()
            local impulseVector = getVector(1000, 1000)
            impulseVector = unitVector:multiply(impulseVector)
            self.body:applyLinearImpulse(impulseVector.x, impulseVector.y)
        end
    end

    return player
end

return getPlayer
