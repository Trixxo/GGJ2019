local function getBgParticle(x, width)
    local smoke = {}
    smoke.x = x
    smoke.particleSystem = love.graphics.newParticleSystem(resources.images.softCircle)
    smoke.particleSystem:setEmissionRate(width * 0.005)
    smoke.particleSystem:setDirection(-math.pi/2)
    smoke.particleSystem:setSpeed(200, 400)
    smoke.particleSystem:setParticleLifetime(2, 3)

    smoke.particleSystem:setSizes(1.4, 3.0)
    smoke.particleSystem:setSizeVariation(0.5)
    smoke.particleSystem:setEmissionArea("uniform", width / 2, 0)

    smoke.particleSystem:setColors(1, 0.8, 0.25, 0,
                                   1, 0.5, 0.1, 0.8,
                                   1, 0.3, 0.1, 0)
    smoke.particleSystem:start()

    smoke.body = love.physics.newBody(world, x, settings.resolution.height * 1.2, "static")

    function smoke:update(dt)
        self.particleSystem:update(dt)
    end

    function smoke:getEmitterPosition()
        return self.x, settings.resolution.height
    end

    return smoke
end

return getBgParticle
