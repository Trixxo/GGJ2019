local function getPauseState()
    local state = {}
    -- Constructor

    state.escapeHasBeenReleased = false
    state.canvas = love.graphics.newCanvas()
    -- Constructor End

    function state:update(dt)
    end

    function state:draw()
        -- -- Render everything to the canvas.
        -- love.graphics.setCanvas(state.canvas)
        -- love.graphics.clear()
        --
        -- local mouseX, mouseY = love.mouse.getPosition()
        -- mouseX = mouseX + camera.x
        -- local playerX, playerY = player.body:getPosition()
        --
        -- if love.mouse.isDown(1) then
        --     love.graphics.setColor(0, 255, 0, 1)
        --     love.graphics.line(mouseX, mouseY, playerX, playerY)
        -- end
        --
        -- for _, entity in ipairs(self.bgEntities) do
        --     local emitterX, emitterY = entity:getEmitterPosition()
        --     love.graphics.draw(entity.particleSystem, emitterX, emitterY)
        -- end
        --
        -- for index, entity in pairs(self.entities) do
        --     local positionX, positionY = entity.body:getPosition()
        --     local angle = entity.body:getAngle()
        --
        --     -- Draw all debug rectangle entities
        --     if entity.drawType == 'rectangle' then
        --         love.graphics.setColor(255, 0, 0, 1)
        --         love.graphics.rectangle('fill',
        --             positionX-entity.dimension.width/2,
        --             positionY-entity.dimension.height/2,
        --             entity.dimension.width,
        --             entity.dimension.height
        --         )
        --     love.graphics.setColor(255, 255, 255)
        --
        --
        --     -- Draw all entities with images
        --     elseif entity.drawType == 'image' then
        --         love.graphics.draw(
        --             entity.image,
        --             positionX,
        --             positionY,
        --             angle,
        --             entity.dimension.width / entity.image:getWidth(),
        --             entity.dimension.height / entity.image:getHeight(),
        --             entity.image:getWidth() / 2,
        --             entity.image:getHeight() / 2
        --         )
        --     end
        --
        --     if entity.particleSystem then
        --         local emitterX, emitterY = entity:getEmitterPosition()
        --         love.graphics.draw(entity.particleSystem, emitterX, emitterY, angle)
        --     end
        -- end
        --
        -- -- Apply the shader to the canvas.
        -- love.graphics.setCanvas()
        --
        -- state.explosionWaveShader:send("camera_pos", {camera.x, camera.y})
        -- state.explosionWaveShader:send("time", os.clock())
        -- state.explosionWaveShader:send(
        --     "impact_time", state.impactTime[1], state.impactTime[2],
        --     state.impactTime[3], state.impactTime[4]
        -- )
        -- state.explosionWaveShader:send(
        --     "impact_coords", state.impactCoords[1], state.impactCoords[2],
        --     state.impactCoords[3], state.impactCoords[4]
        -- )
        -- love.graphics.setShader(state.explosionWaveShader)
        --
        -- love.graphics.push()
        -- love.graphics.origin()
        -- love.graphics.draw(state.canvas)
        -- love.graphics.setShader()
        -- love.graphics.pop()
    end

    function state:shutdown() end

    -- Handle keypresses and send the event to all entities with a keypressed function
    function state:keypressed(key, scancode, isrepeat)
        if key == "escape" and self.escapeHasBeenReleased then
            stack:pop()
        end
    end

    function state:keyreleased(key, scancode)
        if key == "escape" then
            self.escapeHasBeenReleased = true
        end

    end

    function state:load() end

    return state
end

return getPauseState
