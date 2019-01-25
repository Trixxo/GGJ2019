local getResources = require("core/resources")
local getStackHelper = require("core/statestack")
local getGameState = require("states/gamestate")

world = love.physics.newWorld(10, 5, true)
resources = getResources()
stack = getStackHelper()

function love.load()
    resources:load()

    local gameState = getGameState()
    stack:push(gameState)
end

function love.update(dt)
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
end

function love.keypressed(key, scancode, isrepeat)
	stack:current():keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	stack:current():keyreleased(key, scancode)
end