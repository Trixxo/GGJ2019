local getVector = require("core/vector")

local function getPlayer()
    local player = {}
    local camera = require("core/camera")

    player.name = 'player'
    player.drawType = 'image'
    player.image = resources.images.player
    player.destroyed = false
    player.missileToConnect = nil
    player.grapplingCooldown = 0
    player.grapplingTimeout = 2
    player.grappUiSize = {x = 200, y = 10}

    player.dimension = {width = 50, height = 60}
    player.shape = love.physics.newCircleShape(player.dimension.width / 2)

    player.body = love.physics.newBody(world, 100, 100, "dynamic")

    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.fixture:setUserData(player)
    player.fixture:setCategory(1)
    player.fixture:setMask(4)

    player.body:setMass(2)
    player.body:setAngularVelocity(math.random(-10, 10))

    player.isGrappling = false
    player.grapplingPercent = 0
    player.grapplingTarget = nil

    player.joint = nil
    player.missile = nil
    player.grapplingToMissile = false -- New missile we just connected to. Needed for drawing the grappling hook
    player.jumpCd = 0

    function player:draw()
        self:drawGrapplingHook()
        self:drawGrapplingUI()
    end

    function player:update(dt)
        self:computeGrapplingHook(dt)
        print (self.jumpCd)

        if self.missileToConnect ~= nil then
            self:connectToMissile(self.missileToConnect)
            self.missileToConnect = nil
        end

        local playerX, playerY = self.body:getPosition()
        local mouseX, mouseY = love.mouse.getPosition()
        local lvx, lvy = self.body:getLinearVelocity()
        mouseX = mouseX + camera.x
        if player.jumpCd <= 0 then
            player.jumpCd = 0
        end
        if player.jumpCd > 1 then
            player.jumpCd = player.jumpCd - dt * 0.2
        end
        local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
            local entity = fixture:getUserData()
            if entity.name == "missile" and entity ~= self.missile then
                self.grapplingToMissile = true
                self:connectToMissile(entity)
                self.grapplingCooldown = self.grapplingTimeout
                return 0
            end

            return 1 -- Continues with ray cast through all shapes.
        end

        if self.grapplingCooldown <= 0 then
            if love.mouse.isDown(1) then
                world:rayCast(
                    playerX,
                    playerY,
                    mouseX,
                    mouseY,
                    worldRayCastCallback
                )
                if self.grapplingCooldown <= 0 then
                    self.grapplingCooldown = 0.5
                end
            end
        end

        local maxSpeed = 500
        if lvx > -maxSpeed then
            if love.keyboard.isDown("a") then
                self.body:applyLinearImpulse(-100, 0)
                music.enableSound("moveLeft")
            else
                music.disableSound("moveLeft")
            end
        end

        if lvx < maxSpeed then
            if love.keyboard.isDown("d") then
                self.body:applyLinearImpulse(100, 0)
                music.enableSound("moveRight")
            else
                music.disableSound("moveRight")
            end
        end

    end

    ----- GrapplingHook -----
    function player:computeGrapplingHook(dt)
        self.grapplingCooldown = math.max(0, self.grapplingCooldown - dt)

        if love.mouse.isDown(1) and not self.isGrappling and self.grapplingCooldown <= 0 then
            if self.grapplingToMissile and self.missile ~= nil then
                self.grapplingTarget = getVector(self.missile.body:getPosition())
            else
                self.grapplingTarget = getVector(love.mouse.getPosition()):add(camera)
            end
            self.isGrappling = true
        end

        if self.isGrappling and self.grapplingPercent < 1 then
            if self.grapplingToMissile then
                local x, y = self.missile.body:getPosition()
                self.grapplingTarget = getVector(x, y)
            end

            self.grapplingPercent = self.grapplingPercent + dt * 5
        end
        if self.grapplingPercent > 1 then
            self.grapplingPercent = 0
            self.isGrappling = false
            self.grapplingToMissile = false
        end
    end

    function player:drawGrapplingHook()
        if self.isGrappling then
            love.graphics.setColor(0.9, 0.3, 0.1, 1)
            love.graphics.setLineWidth(3)
            local playerPos = getVector(self.body:getPosition())
            local dist = self.grapplingTarget:subtract(playerPos)
            local ropeEnd = playerPos:add(dist:multiply(self.grapplingPercent))
            love.graphics.line(playerPos.x, playerPos.y, ropeEnd.x, ropeEnd.y)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.missile ~= nil and not self.grapplingToMissile then
            local playerX, playerY = self.body:getPosition()
            if not self.missile.body:isDestroyed() then
                local missileX, missileY = self.missile.body:getPosition()
                love.graphics.setColor(1, 0.5, 0.2, 1)
                love.graphics.line(playerX, playerY, missileX, missileY)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end

    function player:drawGrapplingUI()
        love.graphics.rectangle("line", camera.x+100, camera.y+100,
            self.grappUiSize.x, self.grappUiSize.y)
        love.graphics.print("grappling hook", camera.x+100, camera.y+80)
        love.graphics.rectangle("fill", camera.x+100, camera.y+100,
            self.grappUiSize.x*(1 - self.grapplingCooldown/self.grapplingTimeout),
            self.grappUiSize.y)
    end

    ----- Missiles and Joints-----

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
        self.jumpCd = 0
    end

    function player:removeJoint()
        if self.joint and not self.joint:isDestroyed() then
            self.joint:destroy()
            self.joint = nil
            self.missile.resetCategoryTimer = 1
            self.missile.resetCategory = true
            self.missile = nil
            self.grapplingToMissile = false
        end
    end

    ----- Event handlers -----

    function player:keypressed(key, scancode, isrepeat)
        if mode == "normal" then
            if scancode == "w" or scancode == "space" then
                if self.jumpCd <= 2 then
                    xv, yv = self.body:getLinearVelocity()
                    self.body:setLinearVelocity(xv, -600)
                    player.jumpCd = player.jumpCd + 1
                end
                self:removeJoint()

                music.queueEvent("jump")
            elseif scancode == "s" then
                self.body:applyLinearImpulse(0,2000)
            end
        elseif mode == "vim" then
        elseif mode == "worms" then
            if scancode == "space" then
                if self.joint and not self.joint:isDestroyed() then
                    self:removeJoint()
                end
            end
        end
    end

    function player:mousepressed(x, y, button , istouch, presses)
        if mode == "normal" then
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
        elseif mode == "vim" then
        elseif mode == "worms" then
        end
    end

    return player
end

return getPlayer
