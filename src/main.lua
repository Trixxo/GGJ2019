local getResources = require("core/resources")
local getStackHelper = require("core/statestack")
local getGameState = require("states/gamestate")

world = love.physics.newWorld(10, 5, true)
stateStack = getStackHelper()
resources = getResources()

function love.load()
    resources:load()

    local gameState = getGameState()
    stateStack:push(gameState)
end

function love.update(dt)
    stateStack:current():draw()
end

function love.draw()
    stateStack:current():draw()
end
