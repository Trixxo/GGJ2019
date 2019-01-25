function getState()
    state = {}

    state.renderBelow = false

    function state:update(dt) end
    function state:draw() end
    function state:shutdown() end
    function state:keypressed(key, isrepeat) end
    function state:keyreleased(key, isrepeat) end
    function state:mousepressed(x, y, key) end
    function state:load() end

    return state
end
