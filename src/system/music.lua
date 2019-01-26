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
            enabled = true
        },
        hihat = {
            beatFrequency = 2,
            source = resources.sounds.hihat,
            enabled = true
        },
        jump = {
            sources = {
                base = "lead",
                count = 6
            },
            beatFrequency = 1 / 4
        },
        explosion = {
            soundData = love.sound.newSoundData("data/audio/cymbal_crash.wav"),
            beatFrequency = 1
        },
        moveLeft = {
            source = resources.sounds.bass1,
            beatFrequency = 1 / 2
        },
        moveRight = {
            source = resources.sounds.bass2,
            beatFrequency = 1 / 2
        }
    }
end

function music.queueEvent(name)
    if sounds[name] == nil then
        print("ERROR: trying to queue unknown music event", name)
    end

    table.insert(eventQueue, sounds[name])
end

function music.enableSound(name)
    if sounds[name] == nil then
        print("ERROR: trying to queue unknown music event", name)
    end

    sounds[name].enabled = true
end

function music.disableSound(name)
    if sounds[name] == nil then
        print("ERROR: trying to queue unknown music event", name)
    end

    sounds[name].enabled = false
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
    elseif sound.sources then
        local i = math.random(1, sound.sources.count)
        return resources.sounds[sound.sources.base .. i]
    elseif sound.soundData then
        return love.audio.newSource(sound.soundData)
    end
end

function music.tick()
    local soundsPlayed = {}
    local newSounds = {}

    currentTick = currentTick + 1

    for _, sound in pairs(sounds) do
        if sound.enabled and shouldSoundPlay(currentTick, sound.beatFrequency) then
            love.audio.play(sourceForSound(sound))
        end
    end

    for queueIndex, sound in ipairs(eventQueue) do
        if shouldSoundPlay(currentTick, sound.beatFrequency) then
            love.audio.play(sourceForSound(sound))

            table.insert(soundsPlayed, queueIndex)
        end
    end

    for _, queueIndex in ipairs(soundsPlayed) do
        table.remove(eventQueue, queueIndex)
    end
end

return music
