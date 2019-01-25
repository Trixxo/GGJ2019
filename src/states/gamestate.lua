local getPlayer = require("entity/player")

local function getGameState()
    state = {}

    state.renderBelow = false
    state.entities = {}

    -- Constructor
    player = getPlayer()
    table.insert(state.entities, player)
    -- Constructor End
    
    function state:update(dt)

    end

    function state:draw()
        for index, entity in pairs(self.entities) do
            if entity.drawType == 'rectangle' then 
                love.graphics.setColor(255, 0, 0, 1)
                love.graphics.rectangle(
                    'fill', 
                    entity.position.x,
                    entity.position.y,
                    entity.dimension.width,
                    entity.dimension.height
                )
            end
        end
    end

    function state:shutdown() end
    function state:keypressed(key, scancode, isrepeat) end
    function state:keyreleased(key, scancode) end
    function state:mousepressed(x, y, key) end
    function state:load() end

    return state
end

return getGameState
