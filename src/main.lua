require("core/resources")
require("core/stackhelper")
require("core/state")
require("entity/player")

entities = {}
world = love.physics.newWorld(10, 5, true)
stack = getStackHelper()

function love.load()
    resources = getResources()
    resources:load()

    local gameState = getState()
    stack:push(gameState)

    player = getPlayer()
    table.insert(entities, player)
end

function love.update(dt)
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
end
