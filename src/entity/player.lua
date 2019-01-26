local getVector = require("core/vector")

local function getPlayer()
    local player = {}
    local camera = require("core/camera")
    player.name = 'player'
    player.drawType = 'rectangle'
    player.destroyed = false

    player.dimension = {width = 50, height = 50}
    player.shape = love.physics.newRectangleShape(player.dimension.width, player.dimension.height)

    player.body = love.physics.newBody(world, 100, 100, "dynamic")
    player.body:setMass(11)

    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.fixture:setUserData(player)

    player.joint = nil

    function player:update(dt)
        local playerX, playerY = self.body:getPosition()
        local mouseX, mouseY = love.mouse.getPosition()
        local lvx, lvy = self.body:getLinearVelocity()
        mouseX = mouseX + camera.x
        local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
            local entity = fixture:getUserData()
            if entity.name == "missile" then
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

        if math.abs(lvx) < 100 then
            if love.keyboard.isDown("a") then
                self.body:applyLinearImpulse(-50,0)
            end
            if love.keyboard.isDown("d") then
                self.body:applyLinearImpulse(50,0)
            end
        end

    end

    function player:keypressed(key, scancode, isrepeat)
        if scancode == "w" then
            self.body:applyLinearImpulse(0,-2000)
            music.queueEvent("jump")
        elseif scancode == "s" then
            self.body:applyLinearImpulse(0,2000)
        elseif scancode == "space" and self.joint ~= nil then
            self.joint:destroy()
            self.joint = nil
        end
    end

    function player:connectToMissile(missile)
        if self.joint ~= nil then
            if not self.joint:isDestroyed() then
                self.joint:destroy()
            end
        end
        local joint = love.physics.newDistanceJoint(self.body, missile.body, self.body:getX(), self.body:getY(), missile.body:getX(), missile.body:getY())
        joint:setLength(50)
        joint:setDampingRatio(2)
        joint:setFrequency(1)
        self.joint = joint

    end

    function player:mousepressed(x, y, button , istouch, presses)
        if button == 1 then
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
