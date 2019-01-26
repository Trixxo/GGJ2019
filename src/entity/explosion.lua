local function getExplosion(x, y)
    local explosion = {}
    explosion.lifetime = 10
    explosion.name = 'explosion'
    explosion.deleted = false
    explosion.particleSystem = love.graphics.newParticleSystem(resources.images.explosion)
    explosion.particleSystem:setSpeed(70, 150)
    explosion.particleSystem:setParticleLifetime(1, 2)

    explosion.particleSystem:setSizes(0.3, 0.6, 0.7)
    explosion.particleSystem:setSizeVariation(0.7)
    explosion.particleSystem:setSpread(math.pi*2)
    explosion.particleSystem:setRotation(0, 2 * math.pi)
    explosion.particleSystem:setEmissionArea("uniform", 1, 1)

    explosion.particleSystem:setColors(1, 0.8, 0.45, 0.0,
                                   1, 0.5, 0.2, 0.6,
                                   1, 0.3, 0.1, 0)

    explosion.particleSystem:emit(10)

    function explosion:initialize()
        explosion.body = love.physics.newBody(world, x, y)
    end

    function explosion:getEmitterPosition()
        return x, y
    end

    function explosion:update(dt)
        if self.lifetime < 0 then
            self.destroyed = true
        else
            self.lifetime = self.lifetime - dt
        end

        self.particleSystem:update(dt)
    end

   return explosion

end

return getExplosion
