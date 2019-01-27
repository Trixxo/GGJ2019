local getSeagull = require("entity/seagull")
local camera = require("core/camera")

local function getSeagullSpawner(player)
    seagullSpawner = {}

    seagullSpawner.spawncounter = 1
    seagullSpawner.player = player

    function seagullSpawner:update(dt)
        -- Spawn random seagulls.
        self.spawncounter = self.spawncounter - dt
        if self.spawncounter <= 0 then
            state = stack:current()
            local sw = settings.resolution.width
            local sh = settings.resolution.height

            local relativeHeight = math.random(camera.y - 200, camera.y - 50)
            if (relativeHeight < 0 and relativeHeight >= -sh * 0.5) or relativeHeight >= 0 then
                y = relativeHeight
                x = camera.x + sw/2 + math.random(sw * 0.1, sw * 0.3)
            else
                x = camera.x + sw + math.random(sw * 0.1, sw * 0.3)
                y = -sh * 0.5
            end

            local randomspawn = {
                x = x,
                y = y,
            }
            local new_seagull = getSeagull(randomspawn.x, randomspawn.y, player)
            print("Spawning seagull at ", randomspawn.x, randomspawn.y)
            table.insert(state.entities, new_seagull)

            self.spawncounter = math.random(8, 12)
        end
    end

    return seagullSpawner
end

return getSeagullSpawner
