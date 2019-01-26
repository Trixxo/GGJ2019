local getPlayer = require("entity/player")
local getGround = require("entity/ground")

-- Game logic 
local getMissileSpawner = require("system/missilespawner")

-- Collisions
local missileGroundCollision = require("collisions/missileground")


local function getGameState()
    local state = {}
    -- Constructor

    state.renderBelow = false

    state.entities = {} -- Contains all entities
    state.entitiesToSpawn = {} -- Add entities into this list that can't be instantly added (E.g. during collisions)

    -- Create game logic systems
    state.missileSpawner = getMissileSpawner()

    -- Create new entities
    local player = getPlayer()
    table.insert(state.entities, player)
    local ground = getGround()
    table.insert(state.entities, ground)

    -- Constructor End

    function state:update(dt)

        self.missileSpawner:update(dt)

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
    end

    function state:draw()
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
        end
    end

    function state:shutdown() end

    -- Handle keypresses and send the event to all entities with a keypressed function
    function state:keypressed(key, scancode, isrepeat)
        for index, entity in pairs(self.entities) do
            if entity.keypressed ~= nil then
                entity:keypressed(key, scancode, isrepeat)
            end
        end
    end

    function state:keyreleased(key, scancode) end

    function state:mousepressed(x, y, key) end

    function state:collide(fixtureA, fixtureB, key)
        missileGroundCollision(fixtureA, fixtureB, key)
    end

    function state:load() end

    return state
end

return getGameState
