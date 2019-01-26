music = {}

local sounds = {}

local eventQueue = {}

local bpm = 128
local beatLength = 60 / bpm
local tickFraction = 16
local timeSinceLastTick = 0
local currentTick = 0

function music.load()
    sounds = {
        kick = {
            beatFrequency = 1,
            source = resources.sounds.kick,
            alwaysOn = true
        },
        hihat = {
            beatFrequency = 2,
            source = resources.sounds.hihat,
            alwaysOn = true
        },
        jump = {
            sources = {
                base = "lead",
                count = 6
            },
            beatFrequency = 1 / 4
        }
    }

    for name, sound in pairs(sounds) do
        if sound.alwaysOn then
            music.queueEvent(name)
        end
    end
end

function music.queueEvent(name)
    if sounds[name] == nil then
        print("ERROR: trying to queue unknown music event", name)
    end

    table.insert(eventQueue, sounds[name])
end

function music.update(dt)
    timeSinceLastTick = timeSinceLastTick + dt
    if timeSinceLastTick >= beatLength / tickFraction then
        timeSinceLastTick = 0

        music.tick()
    end
end

local function shouldSoundPlay(currentTick, frequency)
    return currentTick % (frequency * tickFraction) == 0
end

local function sourceForSound(sound)
    if sound.source then
        return sound.source
    else
        local i = math.random(1, sound.sources.count)
        return resources.sounds[sound.sources.base .. i]
    end
end

function music.tick()
    local soundsPlayed = {}
    local newSounds = {}

    currentTick = currentTick + 1

    for queueIndex, sound in ipairs(eventQueue) do
        if shouldSoundPlay(currentTick, sound.beatFrequency) then
            love.audio.play(sourceForSound(sound))

            if not sound.alwaysOn then
                table.insert(soundsPlayed, queueIndex)
            end
        end
    end

    for _, queueIndex in ipairs(soundsPlayed) do
        table.remove(eventQueue, queueIndex)
    end
end

return music
