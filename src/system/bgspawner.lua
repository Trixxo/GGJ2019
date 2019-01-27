local getBgParticle = require("entity/bgParticle")

local function getBgSpawner()
    bgSpawner = {}

    bgSpawner.lastMovedIndex = 0
    bgSpawner.lastMovedX = 0

    local spawnerWidth = settings.resolution.width
    local spawnerCount = 3

    function bgSpawner:load()
        for i = 0, spawnerCount - 1, 1 do
            local entity = getBgParticle(i * spawnerWidth, spawnerWidth)

            table.insert(stack:current().bgEntities, entity)
        end
    end

    function bgSpawner:update(dt)
        if camera.x > self.lastMovedX + 400 then
            self.lastMovedIndex = (self.lastMovedIndex % #stack:current().bgEntities) + 1

            local particle = stack:current().bgEntities[self.lastMovedIndex]
            particle.x = particle.x + (spawnerCount * spawnerWidth)

            self.lastMovedX = self.lastMovedX + spawnerWidth
        end
    end

    return bgSpawner
end

return getBgSpawner
