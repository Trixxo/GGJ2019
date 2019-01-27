local getPauseState = require("states/pausestate")
local getPlayer = require("entity/player")
local getGround = require("entity/ground")
local getMissile = require("entity/missile")
camera = require("core/camera")

-- Game logic
local getMissileSpawner = require("system/missilespawner")
local getAsteroidSpawner = require("system/asteroidspawner")
local getSeagullSpawner = require("system/seagullspawner")
local getBgSpawner = require("system/bgspawner")
local getTextGrapplingSystem = require("system/textGrappling")

-- Collisions
local missileGroundCollision = require("collisions/missileground")
local missileAsteroidCollision = require("collisions/missileasteroid")
local missilePlayerCollision = require("collisions/missileplayer")
local gameOverCollision = require("collisions/gameover")

world = nil

local function getGameState()
    local state = {}
    -- Constructor
    world = love.physics.newWorld(0, 981, true)
    world:setCallbacks(collide)
    camera.x = 0

    state.color = { r = 0, g = 0, b = 0 }

    state.canvas = love.graphics.newCanvas()

    -- This shader renders a shockwave for a max of 4 explosions.
    state.explosionWaveShader = love.graphics.newShader("shaders/explosionWaveShader.frag")
    state.impactTime = {} -- `float` array.
    state.impactCoords = {} -- coordinate tuple array.
    for i = 0, 4, 1 do
        table.insert(state.impactTime, -1)
        table.insert(state.impactCoords, {0.0, 0.0})
    end
    state.nextImpactIndex = 1

    state.renderBelow = false

    state.entities = {} -- Contains all entities
    state.bgEntities = {}
    state.entitiesToSpawn = {} -- Add entities into this list that can't be instantly added (E.g. during collisions)

    -- Create new entities
    local player = getPlayer()
    table.insert(state.entities, player)
    local ground = getGround()
    table.insert(state.entities, ground)
    local missile = getMissile()
    missile.falling = false

    -- Create game logic systems
    state.missileSpawner = getMissileSpawner()
    state.asteroidSpawner = getAsteroidSpawner()
    state.seagullSpawner = getSeagullSpawner(player)
    state.bgSpawner = getBgSpawner()
    state.textGrapplingSystem = getTextGrapplingSystem()

    state.pausedOnCurrentPress = false
    local distX, distY = player.body:getPosition()
    local dist = 0
    local targetX, targetY = nil, nil
    local percent = 0

    -- Constructor End

    function state:update(dt)
        local playerX, playerY = player.body:getPosition()
        local mouseX, mouseY = love.mouse:getPosition()

        self.missileSpawner:update(dt)
        self.asteroidSpawner:update(dt)
        self.bgSpawner:update(dt)
        self.seagullSpawner:update(dt)

        -- Add new entities from collision handlers to state
        for index, entity in pairs(self.entitiesToSpawn) do
            -- print("Adding new " .. entity.name .. " to state")
            entity:initialize()
            table.insert(self.entities, entity)
            table.remove(self.entitiesToSpawn, index)
        end

        -- Remove all destroyed entities
        for i = #self.entities, 1, -1 do
            if self.entities[i].destroyed then
                -- print("Destroying " .. entity.name .. " with key " .. index)
                if self.entities[i].body ~= nil then
                    self.entities[i].body:destroy()
                end
                table.remove(self.entities, i)
            end
        end

        -- Call update on all entities
        for index, entity in ipairs(self.entities) do
            if entity.update ~= nil then
                entity:update(dt)
            end
        end

        for _, entity in ipairs(self.bgEntities) do
            entity:update(dt)
        end

        local previousX = camera.x
        camera.x = math.max(playerX - 500, previousX)
        camera.y = math.min(playerY - 400, 0)

        -- update background color
        vx, vy = player.body:getLinearVelocity()
        --print(vx, vy)
        local colorupdate = math.min(2, math.abs((vx + vy) / 3000)) - 1
        --print("update", colorupdate)
        if math.sqrt(math.pow(vx + vy,2)) > 1500 then
            state.color.r = state.color.r + dt
        else
            state.color.r = state.color.r - dt/2
        end
        state.color.r = math.min(1, math.max(0, state.color.r))
        --print(state.color.r)

        state.color.b = math.min(0.25, state.color.b + math.sin(0.5*dt))

        world:update(dt)
    end

    function state:renderParallaxBackground(resource, scale, parallaxScale, posY)
        local resourceWidth = resource:getPixelWidth()
        local screenLeft, screenRight = camera.x, camera.x + settings.resolution.width
        local parallaxOffset = parallaxScale * screenLeft + math.sin(resourceWidth) * 1000
        local numIterations = math.floor((screenLeft - parallaxOffset) / (resourceWidth * scale))

        while parallaxOffset + numIterations * resourceWidth * scale < screenRight
        do
            love.graphics.draw(resource, parallaxOffset + numIterations * resourceWidth * scale, posY, 0, scale, scale)
            numIterations = numIterations + 1
        end
    end

    function state:drawBGLayer(resource, scale, parallaxScale, colorR, colorG, colorB, yPos)
        local resHeight = resource:getPixelHeight()
        local scrWidth = settings.resolution.width
        local scrHeight = settings.resolution.height

        love.graphics.setColor(colorR, colorG, colorB)
        self:renderParallaxBackground(resource, scale, parallaxScale, yPos)
        love.graphics.rectangle('fill', camera.x, yPos + resHeight * scale, scrWidth, scrHeight)
    end

    function state:draw()
        -- Render everything to the canvas.
        love.graphics.setCanvas(state.canvas)
        love.graphics.clear(0.0,0.0,0.0,1.0)

        -- Background
        local maxY = settings.resolution.height / 2

        local space = resources.images.backgroundSpace
        local alpha = resources.images.backgroundBlend
        local city = resources.images.backgroundCity

        self:drawBGLayer(space, 1.0, 0.5, state.color.r, state.color.g, state.color.b,
            maxY - 1500 - 0.5 * space:getPixelHeight())
        -- self:drawBGLayer(space, 0.5, 0.5, 1.0, 1.0, 1.0, maxY - 1500 - 0.5 * space:getPixelHeight())
        -- self:drawBGLayer(space, 0.5, 0.5, 1.0, 1.0, 1.0, maxY - 1500)

        self:drawBGLayer(city, 0.2, 0.9, 0.1, 0.1, 0.1, 0)
        self:drawBGLayer(city, 0.3, 0.8, 0.2, 0.2, 0.2, 0)
        self:drawBGLayer(city, 0.4, 0.7, 0.3, 0.3, 0.3, 0)
        self:drawBGLayer(city, 0.5, 0.6, 0.4, 0.4, 0.4, 0)
        self:drawBGLayer(city, 0.6, 0.5, 0.5, 0.5, 0.5, 0)
        self:drawBGLayer(city, 1.0, 0.6, 0.6, 0.6, 0.6, 0)

        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

        local mouseX, mouseY = love.mouse.getPosition()
        mouseX = mouseX + camera.x

        local playerX, playerY = player.body:getPosition()

        for _, entity in ipairs(self.bgEntities) do
            local emitterX, emitterY = entity:getEmitterPosition()
            love.graphics.draw(entity.particleSystem, emitterX, emitterY)
        end

        for index, entity in pairs(self.entities) do
            local positionX, positionY = entity.body:getPosition()
            local angle = entity.body:getAngle()

            if entity.particleSystem then
                local emitterX, emitterY = entity:getEmitterPosition()
                if entity.syncParticleAngle == false then
                    love.graphics.draw(entity.particleSystem, emitterX, emitterY)
                else
                    love.graphics.draw(entity.particleSystem, emitterX, emitterY, angle)
                end
            end

            -- Draw all debug rectangle entities
            if entity.drawType == 'rectangle' then
                love.graphics.setColor(255, 0, 0, 1)
                love.graphics.rectangle('fill',
                    positionX-entity.dimension.width/2,
                    positionY-entity.dimension.height/2,
                    entity.dimension.width,
                    entity.dimension.height
                )
                love.graphics.setColor(255, 255, 255)


            -- Draw all entities with images
            elseif entity.drawType == 'image' then
                if entity.color then
                    love.graphics.setColor(entity.color.r, entity.color.g, entity.color.b, entity.color.a)
                end

                love.graphics.draw(
                    entity.image,
                    positionX,
                    positionY,
                    angle,
                    entity.dimension.width / entity.image:getWidth(),
                    entity.dimension.height / entity.image:getHeight(),
                    entity.image:getWidth() / 2,
                    entity.image:getHeight() / 2
                )

                love.graphics.setColor(1, 1, 1, 1)
            end

            if entity.draw ~= nil then
                entity:draw()
            end
        end

        -- Apply the shader to the canvas.
        love.graphics.setCanvas()

        state.explosionWaveShader:send("display_size", {settings.resolution.width, settings.resolution.height})
        state.explosionWaveShader:send("camera_pos", {camera.x, camera.y})
        state.explosionWaveShader:send("time", os.clock())
        state.explosionWaveShader:send(
            "impact_time", state.impactTime[1], state.impactTime[2],
            state.impactTime[3], state.impactTime[4]
        )
        state.explosionWaveShader:send(
            "impact_coords", state.impactCoords[1], state.impactCoords[2],
            state.impactCoords[3], state.impactCoords[4]
        )
        love.graphics.setShader(state.explosionWaveShader)

        love.graphics.push()
        love.graphics.origin()
        love.graphics.draw(state.canvas)
        love.graphics.setShader()
        love.graphics.pop()
    end

    function state:addExplosionDistortion(posX, posY)
        state.impactTime[state.nextImpactIndex] = os.clock()
        state.impactCoords[state.nextImpactIndex] = {posX, posY}
        state.nextImpactIndex = state.nextImpactIndex % 4 + 1
    end

    function state:shutdown() end

    -- Handle keypresses and send the event to all entities with a keypressed function
    function state:keypressed(key, scancode, isrepeat)
        if key == "escape" and not self.pausedOnCurrentPress then
            self.pausedOnCurrentPress = true
            local pauseState = getPauseState()
            stack:push(pauseState)
        end

        for index, entity in pairs(self.entities) do
            if entity.keypressed ~= nil then
                entity:keypressed(key, scancode, isrepeat)
            end
        end

        self.textGrapplingSystem:keypressed(scancode, player)
    end

    function state:keyreleased(key, scancode)
        if key == "escape" then
            self.pausedOnCurrentPress = false
        end
    end

    function state:mousepressed(x, y, button, istouch, presses)
        for index, entity in pairs(self.entities) do
            if entity.mousepressed ~= nil then
                entity:mousepressed(x, y, button, istouch, presses)
            end
        end
    end

    function state:collide(fixtureA, fixtureB, key)
        missileAsteroidCollision(fixtureA, fixtureB, key)
        missileGroundCollision(fixtureA, fixtureB, key)
        missilePlayerCollision(fixtureA, fixtureB, key)
        gameOverCollision(fixtureA, fixtureB, key)
    end

    function state:load()
        self.bgSpawner:load()

        state.textGrapplingSystem:registerMissile(missile)
        table.insert(state.entities, missile)
        player:connectToMissile(missile)
    end

    return state
end

return getGameState
