local getResources = require("core/resources")
local getStackHelper = require("core/statestack")
local getGameState = require("states/gamestate")

world = love.physics.newWorld(10, 5, true)
resources = getResources()
stack = getStackHelper()

function love.load()
    resources:load()

    local gameState = getGameState()
    stateStack:push(gameState)
end

function love.update(dt)
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
end
