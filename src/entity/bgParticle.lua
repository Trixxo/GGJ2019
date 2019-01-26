local function getBgParticle(x)
    local smoke = {}
    smoke.x = x
    smoke.particleSystem = love.graphics.newParticleSystem(resources.images.softCircle)
    smoke.particleSystem:setEmissionRate(2)
    smoke.particleSystem:setDirection(-math.pi/2)
    smoke.particleSystem:setSpeed(40, 180)
    smoke.particleSystem:setParticleLifetime(3, 8)

    smoke.particleSystem:setSizes(1.4, 3.0)
    smoke.particleSystem:setSizeVariation(0.5)
    smoke.particleSystem:setEmissionArea("uniform", 200, 0)

    smoke.particleSystem:setColors(1, 0.8, 0.25, 0,
                                   1, 0.5, 0.1, 0.5,
                                   1, 0.3, 0.1, 0)
    smoke.particleSystem:start()

    smoke.body = love.physics.newBody(world, x, settings.resolution.height * 1.2, "static")

    function smoke:update(dt)
        self.particleSystem:update(dt)
    end

    function smoke:getEmitterPosition()
        return self.x, 900
    end

    return smoke
end

return getBgParticle
