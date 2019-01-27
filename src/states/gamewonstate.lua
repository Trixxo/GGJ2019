local getExplosion = require("entity/explosion")
local getPlayer = require("entity/player")

local function getGameWonState(playerlv,playerav,playerr)
    local state = {}
    -- Constructor
    state.playerlv = playerlv
    state.playerav = playerav 
    state.playerr = playerr

    state.entities = {}
    state.player = {}

    state.color = { r = 0, g = 0, b = 0 }

    state.canvas = love.graphics.newCanvas()



    function state:update(dt)

        print("stea", state)
        --print(state.player)
        --print(state.player.body)
        local playerX, playerY = state.player.body:getPosition()
        local mouseX, mouseY = love.mouse:getPosition()

        for index, entity in ipairs(self.entities) do
            if entity.update ~= nil then
                entity:update(dt)
            end
        end

        local previousX = camera.x
        camera.x = math.max(playerX - 500, previousX)
        camera.y = math.min(playerY - 400, 0)
        -- Create explosions
        --self.explosionTimer = self.explosionTimer - dt
        --if self.explosionTimer <= 0 then 
            --local x = math.random(0,settings.resolution.width)
            --local y = math.random(0, settings.resolution.height)
            --local newExplosion = getExplosion(x, y)
            --table.insert(self.explosions, newExplosion)
            --self.explosionTimer = 0.2
        --end

        -- Remove destroyed Particle Systems 
        for i = #self.explosions, 1, -1 do
            if self.explosions[i].destroyed then
                self.explosions[i].particleSystem:stop()
                table.remove(self.explosions, i)
            end
        end

        -- Update explosions
        --for index, explosion in pairs(self.explosions) do
            --explosion:update(dt)
        --end
    end

    function state:draw()
        --love.graphics.setCanvas(state.canvas)
        love.graphics.clear(state.color.r, state.color.g, state.color.b,1.0)
        local font = resources.fonts.swanky
        local text = love.graphics.newText(font, "You WIN")
        local x = camera.x + settings.resolution.width/2 - text:getWidth()/2
        local y = camera.y + settings.resolution.height/2 - text:getHeight()/2
        love.graphics.draw(text, x, y)

        -- Draw explosions
        --for index, explosion in pairs(self.explosions) do
            --local emitterX, emitterY = explosion:getEmitterPosition()
            --love.graphics.draw(explosion.particleSystem, emitterX, emitterY)
        --end

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
    end

    function state:shutdown() end

    -- Handle keypresses and send the event to all entities with a keypressed function
    function state:keypressed(key, scancode, isrepeat)
        if key == "r" then
            world:destroy()
            stack:pop()
            stack:pop()

            local getGameState = require("states/gamestate")
            local gameState = getGameState()
            stack:push(gameState)
            music.load()
        end
    end

    function state:keyreleased(key, scancode) end
    function state:mousepressed(x, y, button, istouch, presses) end

    function state:load()
        --camera.x = 0
        --camera.y = 0
        print(player)
        print("AAAAAAAAAAAAA")
        state.player = getPlayer()
        self.player.body:setLinearVelocity(state.playerlv.a, state.playerlv.b)
        self.player.body:setAngularVelocity(state.playerav)
        self.player.body:setAngle(state.playerr)

        world = love.physics.newWorld(0, 981, true)

        table.insert(self.entities, self.player)

        self.escapeHasBeenReleased = false
        self.canvas = love.graphics.newCanvas()
        self.explosions = {}
        self.explosionTimer = 0.2
        -- Constructor End
    end

    return state
end

return getGameWonState
