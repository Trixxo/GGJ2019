local function getExplosion(x,y)
    local explosion = {} 

    explosion.dimension = {width = 100, height = 100}
    explosion.image = resources.images.explosion
    explosion.body = love.physics.newBody(world, x, y)
    explosion.drawType = 'image'
    explosion.lifetime = 1

    function explosion:update(dt)
        if self.lifetime < 0 then
            print("destroying explosion")
            self:destroy() 
        else
            self.lifetime = self.lifetime - dt
        end
    
    end

    function explosion:destroy() 
        for k, v in ipairs(state.entities) do 
            print("sasd")
            if v == self then 
                print("destroying explosion forreal")
                table.remove(state.entities, k) 
                self = nil 
                return 
            end 
        end 
    end

   return explosion

end

return getExplosion
