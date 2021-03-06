startTime = os.clock()
math.randomseed(startTime)

settings = {
    resolution = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
    },
    scale = 1,
}

camera = require("core/camera")
local getResources = require("core/resources")
local getStackHelper = require("core/statestack")
local getGameState = require("states/gamestate")
require("system/music")

resources = getResources()
stack = getStackHelper()

function love.load()
    resources:addImage("missile", "data/missile.png")
    resources:addImage("exhaust", "data/FIRE.png")
    resources:addImage("explosion", "data/explosion.png")
    resources:addImage("softCircle", "data/soft_circle.png")
    resources:addImage("backgroundCity", "data/city_background_clean.png")
    resources:addImage("player", "data/player.png")
    resources:addImage("asteroid", "data/asteroid.png")
    resources:addImage("backgroundSpace", "data/spaaaaaaaaace.png")
    resources:addImage("backgroundBlend", "data/alphablend.png")
    resources:addImage("seagull", "data/seagull.png")
    resources:addImage("portal", "data/portal.png")
    resources:addImage("beach", "data/Beach.jpg")

    resources:addSound("kick", "data/audio/fantomenkick.wav")
    resources:addSound("hihat", "data/audio/hihat.wav")
    resources:addSound("cymbalCrash", "data/audio/cymbal_crash.wav")

    resources:addFont('swanky', "data/fonts/SwankyandMooMoo.ttf", 100)

    leadSamples = 6
    for i = 1, leadSamples, 1 do
        resources:addSound("lead" .. i, "data/audio/lead_" .. i .. ".wav")
    end

    bassSamples = 2
    for i = 1, bassSamples, 1 do
        resources:addSound("bass" .. i, "data/audio/bass_" .. i .. ".wav")
    end

    bassBSamples = 3
    for i = 1, bassBSamples, 1 do
        resources:addSound("bass_b" .. i, "data/audio/bass_b_" .. i .. ".wav")
    end

    resources:load()

    local gameState = getGameState()
    stack:push(gameState)

    music.load()
end

function love.update(dt)
    stack:update(dt)
    music.update(dt)
end

function love.draw()
    camera:set()
    stack:current():draw()
    camera:unset()

    love.graphics.print(love.timer.getFPS() .. " fps", 20, 20)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "q" then
        love.event.quit()
    end
    stack:current():keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    stack:current():keyreleased(key, scancode)
end

function collide(fixtureA, fixtureB, collision)
    if stack:current().collide then
        stack:current():collide(fixtureA, fixtureB, collision)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    stack:current():mousepressed(x, y, button, istouch, presses)
end
