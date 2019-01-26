local getBgParticle = require("entity/bgParticle")

local function getBgSpawner()
    bgSpawner = {}

    bgSpawner.lastSpawnedX = 0

    function bgSpawner:update(dt)
        if camera.x + 1200 > self.lastSpawnedX + 400 then
            local newX = self.lastSpawnedX + 400
            print("bg at ", newX)
            local entity = getBgParticle(newX)

            table.insert(stack:current().entities, entity)

            self.lastSpawnedX = newX
        end
    end

    return bgSpawner
end

return getBgSpawner
