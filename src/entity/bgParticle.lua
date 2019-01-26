local function getBgParticle(x)
    local smoke = {}
    smoke.particleSystem = love.graphics.newParticleSystem(resources.images.softCircle)
    smoke.particleSystem:setEmissionRate(1)
    smoke.particleSystem:setDirection(-math.pi/2)
    smoke.particleSystem:setSpeed(10, 50)
    smoke.particleSystem:setParticleLifetime(1, 10)

    smoke.particleSystem:setSizes(0.1, 1.0)
    smoke.particleSystem:setSizeVariation(0.5)

    smoke.particleSystem:setColors(1, 1, 1, 0.2, 1, 1, 1, 0.5, 1, 1, 1, 0)
    smoke.particleSystem:start()

    smoke.body = love.physics.newBody(world, x, 800, "static")

    function smoke:update(dt)
        self.particleSystem:update(dt)
    end

    function smoke:getEmitterPosition()
        return x, 800
    end

    return smoke
end

return getBgParticle
