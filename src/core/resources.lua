local function getResources()
    resources = {}
        
    resources.imageQueue = {}
    resources.musicQueue = {}
    resources.soundQueue = {}
    resources.fontQueue= {}

    resources.images = {}
    resources.music = {}
    resources.sounds = {}
    resources.fonts = {}

    function resources:addImage(name, src)
        self.imageQueue[name] = src
    end

    function resources:addMusic(name, src)
        self.musicQueue[name] = src
    end

    function resources:addSound(name, src)
        self.soundQueue[name] = src
    end

    function resources:addFont(name, src, size)
        self.fontQueue[name] = {src, size}
    end

    function resources:load(threaded)

        for name, pair in pairs(self.fontQueue) do
            self.fonts[name] = love.graphics.newFont(pair[1], pair[2])
            self.fontQueue[name] = nil
        end
        for name, src in pairs(self.musicQueue) do
            self.music[name] = love.audio.newSource(src)
            self.musicQueue[name] = nil
        end

        for name, src in pairs(self.soundQueue) do
            self.sounds[name] = love.audio.newSource(src)
            self.soundQueue[name] = nil
        end

        for name, src in pairs(self.imageQueue) do
            self.images[name] = love.graphics.newImage(src)
            self.imageQueue[name] = nil
        end

    end

    return resources
end

return getResources
