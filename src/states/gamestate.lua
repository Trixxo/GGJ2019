local getPauseState = require("states/pausestate")
local getPlayer = require("entity/player")
local getGround = require("entity/ground")
local camera = require("core/camera")

-- Game logic
local getMissileSpawner = require("system/missilespawner")
local getBgSpawner = require("system/bgspawner")

-- Collisions
local missileGroundCollision = require("collisions/missileground")
local missilePlayerCollision = require("collisions/missileplayer")
local playerGroundCollision = require("collisions/playerground")

world = nil
mode = "normal"
-- mode = "vim"
-- mode = "worms"


local function getGameState()
    local state = {}
    -- Constructor
    world = love.physics.newWorld(0, 981, true)
    world:setCallbacks(collide)

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

    -- Create game logic systems
    state.missileSpawner = getMissileSpawner()
    state.bgSpawner = getBgSpawner()

    -- Create new entities
    local player = getPlayer()
    table.insert(state.entities, player)
    local ground = getGround()
    table.insert(state.entities, ground)

    state.pausedOnCurrentPress = false
    local distX, distY = player.body:getPosition()
    local dist = 0
    local targetX, targetY = nil, nil
    local percent = 0

    -- Constructor End

    function state:update(dt)
        world:update(dt)

        local playerX, playerY = player.body:getPosition()
        local mouseX, mouseY = love.mouse:getPosition()

        self.missileSpawner:update(dt)
        self.bgSpawner:update(dt)

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
    end

    function state:renderParallaxBackground(resource, scale, parallaxScale, posY)
        local resourceWidth = resource:getPixelWidth()
        local screenLeft, screenRight = camera.x, camera.x + settings.resolution.width
        local parallaxOffset = parallaxScale * screenLeft
        local numIterations = math.floor((screenLeft - parallaxOffset) / (resourceWidth * scale))

        while parallaxOffset + numIterations * resourceWidth * scale < screenRight
        do
            love.graphics.draw(resources.images.backgroundCity, parallaxOffset + numIterations * resourceWidth * scale, posY, 0, scale, scale)
            numIterations = numIterations + 1
        end
    end

    function state:draw()
        -- Render everything to the canvas.
        love.graphics.setCanvas(state.canvas)
        love.graphics.clear(0.0,0.0,0.0,1.0)

        -- Background
        local posY, scale

        local resource = resources.images.backgroundCity
        local resourceHeight = resource:getPixelHeight()
        local screenWidth = settings.resolution.width
        local screenHeight = settings.resolution.height
        local maxY = screenHeight - resourceHeight

        scale = 0.4
        love.graphics.setColor(0.1, 0.1, 0.1)
        self:renderParallaxBackground(resource, scale, 0.8, maxY)
        love.graphics.rectangle(
            'fill', camera.x, maxY + resourceHeight * scale, screenWidth, screenHeight)

        scale = 0.65
        love.graphics.setColor(0.3, 0.3, 0.3)
        self:renderParallaxBackground(resource, scale, 0.4, maxY)
        love.graphics.rectangle(
            'fill', camera.x, maxY + resourceHeight * scale, screenWidth, screenHeight)

        scale = 1.0
        love.graphics.setColor(0.5, 0.5, 0.5)
        self:renderParallaxBackground(resource, scale, 0.0, maxY)
        love.graphics.rectangle(
            'fill', camera.x, maxY + resourceHeight * scale, screenWidth, screenHeight)

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
            end

            if entity.particleSystem then
                local emitterX, emitterY = entity:getEmitterPosition()
                love.graphics.draw(entity.particleSystem, emitterX, emitterY, angle)
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
        missileGroundCollision(fixtureA, fixtureB, key)
        missilePlayerCollision(fixtureA, fixtureB, key)
        playerGroundCollision(fixtureA, fixtureB, key)
    end

    function state:load()
        self.bgSpawner:load()
    end

    return state
end

return getGameState
