music = {}

local sounds = {}

local eventQueue = {}

music.initial_bpm = 128
music.bpm = music.initial_bpm
music.beatLength = 60 / music.bpm
music.tickFraction = 4
music.timeSinceLastTick = 0
music.currentTick = 0

function music.load()
    sounds = {
        kick = {
            beatFrequency = 1,
            soundData = love.sound.newSoundData("data/audio/fantomenkick.wav"),
            enabled = true
        },
        swoosh = {
            beatFrequency = 1/2,
            soundData = love.sound.newSoundData("data/audio/3maze-cinematicswoosh_craft_med_C_001.wav"),
        },
        tick_1 = {
            beatFrequency = 2,
            offset = 1/2,
            soundData = love.sound.newSoundData("data/audio/crab_tick_single.wav"),
            },
        tick_2 = {
            beatFrequency = 1,
            offset = 1/2,
            soundData = love.sound.newSoundData("data/audio/crab_tick_double.wav"),
        },
        tick_3 = {
            beatFrequency = 2,
            offset = 1/2,
            soundData = love.sound.newSoundData("data/audio/crab_tick_double.wav"),
            enabled = true
        },
        tick_triple = {
            beatFrequency = 1,
            soundData = love.sound.newSoundData("data/audio/crab_tick_triple.wav"),
        },
        grappling = {
            beatFrequency = 1/4,
            soundData = love.sound.newSoundData("data/audio/grappling_sound.wav"),
        },
        hihat = {
            beatFrequency = 2,
            soundData = love.sound.newSoundData("data/audio/hihat.wav"),
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
            soundData = love.sound.newSoundData("data/audio/bass_1.wav"),
            beatFrequency = 1 / 2
        },
        moveRight = {
            soundData = love.sound.newSoundData("data/audio/bass_2.wav"),
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
    --print("current bpm ", music.bpm)
    music.beatLength = 60 / music.bpm
    music.timeSinceLastTick = music.timeSinceLastTick + dt
    if music.timeSinceLastTick >= music.beatLength / music.tickFraction then
        music.timeSinceLastTick = 0

        music.tick()
    end
end

local function shouldSoundPlay(currentTick, frequency, sound)
    local offset = sound.offset or 0
    return (offset * music.tickFraction + currentTick) % ( frequency * music.tickFraction) == 0
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

    music.currentTick = music.currentTick + 1

    for _, sound in pairs(sounds) do
        if sound.enabled and shouldSoundPlay(music.currentTick, sound.beatFrequency, sound) then
            love.audio.play(sourceForSound(sound))
        end
    end

    for queueIndex, sound in ipairs(eventQueue) do
        if shouldSoundPlay(music.currentTick, sound.beatFrequency, sound) then
            love.audio.play(sourceForSound(sound))

            table.insert(soundsPlayed, queueIndex)
        end
    end

    for _, queueIndex in ipairs(soundsPlayed) do
        table.remove(eventQueue, queueIndex)
    end
end

return music
