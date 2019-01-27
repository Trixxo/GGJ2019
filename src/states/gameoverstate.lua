local getExplosion = require("entity/explosion")

local function getGameOverState()
    local state = {}
    -- Constructor

    state.escapeHasBeenReleased = false
    state.canvas = love.graphics.newCanvas()
    state.explosions = {}
    state.explosionTimer = 0.2
    -- Constructor End


    function state:update(dt)
        -- Create explosions
        self.explosionTimer = self.explosionTimer - dt
        if self.explosionTimer <= 0 then 
            local x = math.random(0,settings.resolution.width)
            local y = math.random(0, settings.resolution.height)
            local newExplosion = getExplosion(x, y)
            table.insert(self.explosions, newExplosion)
            self.explosionTimer = 0.2
        end

        -- Remove destroyed Particle Systems 
        for i = #self.explosions, 1, -1 do
            if self.explosions[i].destroyed then
                self.explosions[i].particleSystem:stop()
                table.remove(self.explosions, i)
            end
        end

        -- Update explosions
        for index, explosion in pairs(self.explosions) do
            explosion:update(dt)
        end
    end

    function state:draw()
        local font = resources.fonts.swanky
        local text = love.graphics.newText(font, "You play like crab!")
        local x = settings.resolution.width/2 - text:getWidth()/2
        local y = settings.resolution.height/2 - text:getHeight()/2
        love.graphics.draw(text, x, y)

        -- Draw explosions
        for index, explosion in pairs(self.explosions) do
            local emitterX, emitterY = explosion:getEmitterPosition()
            love.graphics.draw(explosion.particleSystem, emitterX, emitterY)
        end
    end

    function state:shutdown() end

    -- Handle keypresses and send the event to all entities with a keypressed function
    function state:keypressed(key, scancode, isrepeat)
        world:destroy()
        stack:pop()
        stack:pop()

        local getGameState = require("states/gamestate")
        local gameState = getGameState()
        stack:push(gameState)
        music.load()
    end

    function state:keyreleased(key, scancode) end
    function state:mousepressed(x, y, button, istouch, presses) end

    function state:load()
        camera.x = 0
        camera.y = 0
    end

    return state
end

return getGameOverState
