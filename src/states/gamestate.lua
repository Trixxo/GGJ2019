local getPlayer = require("entity/player")
local getMissile = require("entity/missile")
local getGround = require("entity/ground")


local function getGameState()
    state = {}

    math.randomseed(os.time())

    spawntime = 1
    spawncounter = 0

    state.renderBelow = false
    state.entities = {}

    -- Constructor
    player = getPlayer()
    table.insert(state.entities, player)

    ground = getGround()
    table.insert(state.entities, ground)
    -- Constructor End

    function state:update(dt)
        if spawncounter > spawntime then
            randomspawn = {
                x = math.random() * love.graphics.getWidth(),
                y = math.random() * love.graphics.getHeight()
            }
            local new_missile = getMissile(randomspawn.x, 100)
            print("spawning missile at ", randomspawn.x, 0)
            table.insert(state.entities, new_missile)
            spawncounter = 0
        else
            spawncounter = spawncounter + dt
        end
        for index, entity in pairs(self.entities) do
            if entity.update ~= nil then 
                entity:update(dt)
            end
        end
    end

    function state:draw()
        for index, entity in pairs(self.entities) do
            local positionX, positionY = entity.body:getPosition()
            local angle = entity.body:getAngle()
            if entity.drawType == 'rectangle' then
                love.graphics.setColor(255, 0, 0, 1)
                love.graphics.rectangle('fill',
                    positionX-entity.dimension.width/2,
                    positionY-entity.dimension.height/2,
                    entity.dimension.width,
                    entity.dimension.height
                )
            love.graphics.setColor(255, 255, 255)
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
        end
    end

    function state:shutdown() end

    function state:keypressed(key, scancode, isrepeat)
        for index, entity in pairs(self.entities) do
            if entity.keypressed ~= nil then
                entity:keypressed(key, scancode, isrepeat)
            end
        end
    end

    function state:keyreleased(key, scancode) end

    function state:mousepressed(x, y, key) end

    function state:load() end

    return state
end

return getGameState
