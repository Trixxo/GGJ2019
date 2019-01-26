local function getGameOverState()
    local state = {}
    -- Constructor

    state.escapeHasBeenReleased = false
    state.canvas = love.graphics.newCanvas()
    -- Constructor End


    function state:update(dt)
    end

    function state:draw()
        local font = resources.fonts.swanky
        local text = love.graphics.newText(font, "You play like crab!")
        local x = settings.resolution.width/2 - text:getWidth()/2
        local y = settings.resolution.height/2 - text:getHeight()/2
        love.graphics.draw(text, x, y)
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
    end

    return state
end

return getGameOverState
