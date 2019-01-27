music = {}

local sounds = {}

local eventQueue = {}

music.initial_bpm = 128
music.bpm = music.initial_bpm
music.beatLength = 60 / music.bpm
music.tickFraction = 4
music.timeSinceLastTick = 0
music.currentTick = 0
music.energyLevel = 0

function music.load()
    sounds = {
        hihat = {
            beatFrequency = 2,
            soundData = love.sound.newSoundData("data/audio/hihat.wav"),
            enabled = true,
            energyLevel = 0
        },
        second_grappling = {
            sources = {
                base = "lead",
                count = 6
            },
            beatFrequency = 1 / 2,
            energyLevel = 0.2
        },
        jump = {
            sources = {
                base = "lead",
                count = 6
            },
            beatFrequency = 1 / 2,
            energyLevel = 0
        },
        kick = {
            beatFrequency = 1,
            soundData = love.sound.newSoundData("data/audio/fantomenkick.wav"),
            enabled = true,
            energyLevel = 0.15
        },
        tick_3 = {
            beatFrequency = 2,
            offset = 1/2,
            soundData = love.sound.newSoundData("data/audio/crab_tick_double.wav"),
            energyLevel = 0.3,
            enabled = true,
        },
        tick_1 = {
            beatFrequency = 2,
            offset = 1/2,
            soundData = love.sound.newSoundData("data/audio/crab_tick_single.wav"),
            energyLevel = 0.4,
            },
        tick_2 = {
            beatFrequency = 1,
            offset = 1/2,
            soundData = love.sound.newSoundData("data/audio/crab_tick_double.wav"),
            energyLevel = 0.5,
        },
        bass = {
            sources = {
                base = "bass",
                count = 2
            },
            enabled = true,
            beatFrequency = 1 / 2,
            energyLevel = 0.4
        },
        second_jump = {
            sources = {
                base = "lead",
                count = 6
            },
            beatFrequency = 1 / 2,
            energyLevel = 0.5
        },
        bass_b = {
            sources = {
                base = "bass_b",
                count = 3
            },
            beatFrequency = 1/2,
            enabled = true,
            energyLevel = 0.8
        },

        -- always on effects
        explosion = {
            soundData = love.sound.newSoundData("data/audio/cymbal_crash.wav"),
            beatFrequency = 1
        },
        swoosh = {
            beatFrequency = 1/2,
            source = love.audio.newSource("data/audio/3maze-cinematicswoosh_craft_med_C_001.wav", "static"),
        },
        death = {
            beatFrequency = 1/2,
            soundData = love.sound.newSoundData("data/audio/juhani_junkala_sfx_deathscream_alien4.wav"),
        },
        grapp_ready = {
            beatFrequency = 1/2,
            soundData = love.sound.newSoundData("data/audio/juhani_junkala_sfx_sounds_powerup6.wav"),
        },
        grappling = {
            beatFrequency = 1/4,
            soundData = love.sound.newSoundData("data/audio/grappling_sound.wav"),
        },
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

local function matchesEnergyLevel(sound, currentLevel)
    if sound.energyLevel then
        return currentLevel >= sound.energyLevel
    else
        return true
    end
end

function music.tick()
    local newQueue = {}

    music.currentTick = music.currentTick + 1

    for _, sound in pairs(sounds) do
        if sound.enabled and shouldSoundPlay(music.currentTick, sound.beatFrequency, sound) and
          matchesEnergyLevel(sound, music.energyLevel) then
            love.audio.play(sourceForSound(sound))
        end
    end

    local alreadyPlayed = {}

    for queueIndex, sound in ipairs(eventQueue) do
        if shouldSoundPlay(music.currentTick, sound.beatFrequency, sound) and
        not (sound.sources and alreadyPlayed[sound.sources.base]) then
            -- this is the correct tick to play the sound
            if matchesEnergyLevel(sound, music.energyLevel) then
                love.audio.play(sourceForSound(sound))
                if sound.sources then
                    alreadyPlayed[sound.sources.base] = true
                end
            end
        else
            -- play this sound later
            table.insert(newQueue, sound)
        end
    end

    eventQueue = newQueue
end

return music
