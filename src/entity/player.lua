local getVector = require("core/vector")
local getGameOverState = require("states/gameoverstate")
local getPortal = require("entity/portal")

local function getPlayer()
    local player = {}
    local camera = require("core/camera")

    player.name = 'player'
    player.drawType = 'image'
    player.image = resources.images.player
    player.destroyed = false
    player.dead = false
    player.deadcountdown = 1.5
    player.missileToConnect = nil
    player.grapplingCooldown = 0
    player.grapplingTimeout = 1.5
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
    player.grapp_gotready = false
    player.grapplingPercent = 0
    player.grapplingTarget = nil

    player.joint = nil
    player.missile = nil
    player.grapplingToMissile = false -- New missile we just connected to. Needed for drawing the grappling hook
    player.jumpCd = 0
    player.missileCd = 0

    function player:draw()
        self:drawGrapplingHook()
        self:drawGrapplingUI()
    end

    function player:update(dt)

        local playerX, playerY = self.body:getPosition()
        local lvx, lvy = self.body:getLinearVelocity()
        local totalSpeed = getVector(lvx, lvy):length()

        music.energyLevel = playerX / 42000

        self.body:setAngularVelocity((self.body:getLinearVelocity() + math.abs(playerY)) * dt)

        if self:isConnectedToMissile() then
            if self.missile.explosive == 3 then
                self.missileCd = self.missileCd - dt
                if self.missileCd <= 0 then
                    self.missile:explode()
                    self.missileCd = 0
                end
            end
        end

        -- countdown before going to gameoverscreen
        if player.dead == true then
            if self.joint ~= nil then
                self:removeJoint()
            end
            player.drawType = nil
            music.disableSound("tick_3")
            music.disableSound("tick_2")
            music.disableSound("swoosh")
            if player.deadcountdown < 0 then
                local gameoverstate = getGameOverState()
                stack:push(gameoverstate)
            else
                player.deadcountdown = player.deadcountdown - dt
            end
            return
        end

        self:updateGrapplingAttempt(dt)

        if self.missileToConnect ~= nil then
            self:connectToMissile(self.missileToConnect)
            self.missileToConnect = nil
        end

        if player.jumpCd <= 0 then
            player.jumpCd = 0
        end
        if player.jumpCd > 1 then
            player.jumpCd = player.jumpCd - dt * 0.2
        end

        local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
            local entity = fixture:getUserData()
            if (entity.name == "missile" or entity.name == "asteroid") and entity ~= self.missile then
                self:connectToMissile(entity)
                return 0
            end

            return 1 -- Continues with ray cast through all shapes.
        end

        if self.isGrappling then
            world:rayCast(
                playerX,
                playerY,
                self.grapplingTarget.x,
                self.grapplingTarget.y,
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

        if math.abs(lvx) > 800 or math.abs(lvy) > 800 then
            music.enableSound("tick_3")
            music.enableSound("tick_2")

            if totalSpeed > 1200 and self:isConnectedToMissile() then
                music.enableSound('swoosh')
            end
            if not self.portalSpawned and (totalSpeed > 2000 and playerX > 42000) then
                -- this is so fast, spacetime cracks and a portal opens
                print("spawning portal")
                local portal = getPortal(playerX + 4000, 0)
                stack:current().portal = portal
                self.portalSpawned = true
                table.insert(stack:current().entities, portal)
            end
        else
            music.disableSound("tick_3")
            music.disableSound("tick_2")
            music.disableSound('swoosh')
        end

        if not self:isConnectedToMissile() then
            music.disableSound('swoosh')
        end
    end

    function player:isConnectedToMissile()
        return self.grapplingToMissile and self.missile ~= nil and not self.missile.body:isDestroyed()
    end

    ----- GrapplingHook -----
    function player:updateGrapplingAttempt(dt)
        local ready = true

        if self.grapplingCooldown > 0 then
           ready = false
        end

        self.grapplingCooldown = math.max(0, self.grapplingCooldown - dt)

        if self.grapplingCooldown == 0 and ready == false then
            self.grapp_gotready = true
        end

        if self.grapp_gotready == true then
            music.queueEvent('grapp_ready')
            self.grapp_gotready = false
        end

        if self.isGrappling then
            self.grapplingPercent = self.grapplingPercent + dt * 5
        end

        if self.grapplingPercent > 1 then
            self.grapplingPercent = 0
            self.isGrappling = false
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

        if self:isConnectedToMissile() then
            local playerX, playerY = self.body:getPosition()
            local missileX, missileY = self.missile.body:getPosition()
            love.graphics.setColor(1, 0.5, 0.2, 1)
            love.graphics.setLineWidth(3)
            love.graphics.line(playerX, playerY, missileX, missileY)
            love.graphics.setColor(1, 1, 1, 1)

        end
    end

    function player:drawGrapplingUI()
        love.graphics.rectangle("line", camera.x+100, camera.y+100,
            self.grappUiSize.x, self.grappUiSize.y)
        -- love.graphics.print("grappling hook", camera.x+100, camera.y+80)
        love.graphics.rectangle("fill", camera.x+100, camera.y+100,
            self.grappUiSize.x*(1 - self.grapplingCooldown / self.grapplingTimeout),
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

        music.queueEvent("grappling")
        music.queueEvent("second_grappling")

        local joint = love.physics.newDistanceJoint(self.body, missile.body, self.body:getX(), self.body:getY(), missile.body:getX(), missile.body:getY())
        joint:setLength(50)
        joint:setDampingRatio(5)
        joint:setFrequency(1)
        self.joint = joint
        self.missile = missile
        self.jumpCd = 0


        self.grapplingToMissile = true
        self.isGrappling = false
        self.grapplingCooldown = self.grapplingTimeout
    end

    function player:removeJoint()
        if self.joint and not self.joint:isDestroyed() then
            self.joint:destroy()
            self.joint = nil
            self.missile.resetCategoryTimer = 1
            self.missile.resetCategory = true
            self.missile = nil
            self.isGrappling = false
            self.grapplingToMissile = false
        end
    end

    ----- Event handlers -----

    function player:keypressed(key, scancode, isrepeat)
        if self.dead == false then
            if scancode == "w" or scancode == "space" then
                self:removeJoint()
                if self.jumpCd <= 1 then
                    xv, yv = self.body:getLinearVelocity()
                    self.body:setLinearVelocity(xv, math.min(-1000, yv))
                    player.jumpCd = player.jumpCd + 1
                end

                local x, y = self.body:getPosition()
                music.queueEvent("jump")
                music.queueEvent("second_jump")
            elseif scancode == "s" then
                self.body:applyLinearImpulse(0,2000)
                self:removeJoint()

                music.queueEvent("jump")
            elseif scancode == "tab" then
                -- worms mode.
                if self.joint and not self.joint:isDestroyed() then
                    self:removeJoint()
                else
                    self.isGrappling = true
                    self.grapplingPercent = 0.0
                    self.grapplingTarget = getVector(self.body:getPosition()):add(getVector(2000, -5000))
                end
            end
        end
    end

    function player:allowedToTryGrapple()
        return self.grapplingCooldown <= 0
    end

    function player:mousepressed(x, y, button , istouch, presses)
        if self.dead == false then
            if button == 1 and self:allowedToTryGrapple() then
                self.grapplingTarget = getVector(x, y):add(camera)
                self.isGrappling = true
            end
            if button == 2 then
                local mouseVector = getVector(x, y)
                local playerVector = getVector(self.body:getPosition())
                local playerToMouseVector = mouseVector:subtract(playerVector)
                local unitVector = playerToMouseVector:getUnit()
                local impulseVector = getVector(1000, 1000)
                impulseVector = unitVector:multiply(impulseVector)
                self.body:applyLinearImpulse(impulseVector.x, impulseVector.y)
            end
        end
    end

    return player
end

return getPlayer
