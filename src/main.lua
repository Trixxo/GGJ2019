require("core/resources")
require("core/stackhelper")
require("entity/player")

entities = {}
world = love.physics.newWorld(10, 5, true)

function love.load()
    resources = getResources()
    resources:load()

    stack = getStackHelper()

    player = getPlayer()
    table.insert(entities, player)
end

function love.update(dt)
end

function love.draw()
    for i, entity in pairs(entities) do
        entity:draw()
    end
end
