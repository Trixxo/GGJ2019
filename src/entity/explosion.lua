local function getExplosion(x,y)
    local explosion = {} 
    explosion.lifetime = 1
    explosion.name = 'explosion'
    explosion.drawType = 'image'
    explosion.deleted = false

    function explosion:initialize()
        explosion.body = love.physics.newBody(world, self.position.x, self.position.y)
    end

    explosion.position = {x = x, y = y}
    explosion.dimension = {width = 100, height = 100}
    explosion.image = resources.images.explosion

    function explosion:update(dt)
        if self.lifetime < 0 then
            self.destroyed = true
        else
            self.lifetime = self.lifetime - dt
        end
    
    end

--    function explosion:destroy() 
--        for k, v in ipairs(stack:current().entities) do 
--            print("sasd")
--            if v == self then 
--                print("destroying explosion forreal")
--                table.remove(state.entities, k) 
--                self = nil 
--                return 
--            end 
--        end 
--    end

   return explosion

end

return getExplosion
