local function getBgParticle(x)
    local smoke = {}
    smoke.x = x
    smoke.particleSystem = love.graphics.newParticleSystem(resources.images.softCircle)
    smoke.particleSystem:setEmissionRate(10)
    smoke.particleSystem:setDirection(-math.pi/2)
    smoke.particleSystem:setSpeed(20, 150)
    smoke.particleSystem:setParticleLifetime(30, 30)

    smoke.particleSystem:setSizes(0.3, 2.0)
    smoke.particleSystem:setSizeVariation(0.5)
    smoke.particleSystem:setEmissionArea("uniform", 200, 0)

    smoke.particleSystem:setColors(1, 1, 1, 0, 1, 1, 1, 0.5, 1, 1, 1, 0)
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
