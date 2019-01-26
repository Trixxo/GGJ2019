local getPlayer = require("entity/player")
local getMissile = require("entity/missile")
local getGround = require("entity/ground")

-- Collisions
local missileGroundCollision = require("collisions/missileground")


local function getGameState()
    local state = {}

    math.randomseed(os.time())

    state.spawntime = 1
    state.spawncounter = 0

    state.renderBelow = false
    state.entities = {}
    state.entitiesToSpawn = {}

    -- Constructor
    local player = getPlayer()
    table.insert(state.entities, player)

    local ground = getGround()
    table.insert(state.entities, ground)
    -- Constructor End

    function state:update(dt)
        -- Add new entities from collision handlers to state
        for index, entity in pairs(self.entitiesToSpawn) do
            -- print("Adding new " .. entity.name .. " to state")
            entity:initialize()
            table.insert(self.entities, entity)
            table.remove(self.entitiesToSpawn, index)
        end

        -- Spawn random missiles (lets move this to a seperate file
        if self.spawncounter > self.spawntime then
            local randomspawn = {
                x = math.random() * love.graphics.getWidth(),
                y = 100
            }
            local new_missile = getMissile(randomspawn.x, randomspawn.y)
            -- print("Spawning missile at ", randomspawn.x, randomspawn.y)
            table.insert(self.entities, new_missile)
            self.spawncounter = 0

        else
            self.spawncounter = self.spawncounter + dt
        end

        -- Call update logic on entities
        for index, entity in ipairs(self.entities) do
            -- Remove all destroyed entities
            if entity.destroyed then
                -- print("Destroying " .. entity.name .. " with key " .. index)
                if entity.body ~= nil then
                    entity.body:destroy()
                end
                table.remove(self.entities, index)
            else
                -- Call update on all entities
                if entity.update ~= nil then 
                    entity:update(dt)
                end
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
