local getPlayer = require("entity/player")
local getMissile = require("entity/missile")


local function getGameState()
    state = {}

    state.renderBelow = false
    state.entities = {}

    -- Constructor
    player = getPlayer()
    table.insert(state.entities, player)
    -- Constructor End
    missile = getMissile(40,60) 
    table.insert(state.entities, missile)
    
    function state:update(dt)

    end

    function state:draw()
        for index, entity in pairs(self.entities) do
            local positionX, positionY = entity.fixture:getBody():getPosition()
            if entity.drawType == 'rectangle' then 
                love.graphics.setColor(255, 0, 0, 1)
                love.graphics.rectangle(
                    'fill', 
                    positionX,
                    positionY,
                    entity.dimension.width,
                    entity.dimension.height
                )
                love.graphics.setColor(255, 255, 255)
            elseif entity.drawType == 'image' then

                love.graphics.draw(entity.image, positionX, positionY)
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
