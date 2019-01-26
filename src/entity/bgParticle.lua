local function getBgParticle(x)
    local smoke = {}
    smoke.x = x
    smoke.particleSystem = love.graphics.newParticleSystem(resources.images.softCircle)
    smoke.particleSystem:setEmissionRate(3)
    smoke.particleSystem:setDirection(-math.pi/2)
    smoke.particleSystem:setSpeed(20, 150)
    smoke.particleSystem:setParticleLifetime(5, 8)

    smoke.particleSystem:setSizes(1.0, 1.5)
    smoke.particleSystem:setSizeVariation(0.5)
    smoke.particleSystem:setEmissionArea("uniform", 200, 0)

    smoke.particleSystem:setColors(1, 1, 1, 0, 1, 1, 1, 0.3, 1, 1, 1, 0)
    smoke.particleSystem:start()

    smoke.body = love.physics.newBody(world, x, 900, "static")

    function smoke:update(dt)
        self.particleSystem:update(dt)
    end

    function smoke:getEmitterPosition()
        return self.x, 900
    end

    return smoke
end

return getBgParticle
