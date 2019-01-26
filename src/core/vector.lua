local function getVector(x, y)
    vector = {}
    vector.isVector = true

    if y == nil then
        vector.x = x or 0
        vector.y = x or 0
    else
        vector.x = x
        vector.y = y
    end

    function vector:set(x, y)
        if type(x) == "number" and type(y) == "number" then
            self.x = x
            self.y = y
        elseif x.isVector then
            self.x = x.x
            self.y = x.y
        end
    end

    function vector:clone()
        return getVector(self.x,self.y)
    end

    function vector:getUnit()
        local length = self:length()
        return getVector(self.x/length, self.y/length)
    end

    function vector:sum()
        return math.abs(self.x) + math.abs(self.y)
    end

    function vector:length()
        return math.sqrt(self.x^2 + self.y^2)
    end

    function vector:distanceTo(other)
        return self:subtract(other):length()
    end

    function vector:getRadian()
        return math.atan2( self.y, self.x )
    end

    function vector:add(vector)
        if type(vector) == "number" then
            return getVector(self.x + vector, self.y + vector)
        elseif vector.isVector then
            return getVector(self.x + vector.x, self.y + vector.y)
        end
    end

    function vector:subtract(vector)
        if type(vector) == "number" then
            return getVector(self.x - vector, self.y - vector)
        elseif vector.isVector then
            return getVector(self.x - vector.x, self.y - vector.y)
        end
    end

    function vector:multiply(vector)
        if type(vector) == "number" then
            return getVector(self.x * vector, self.y * vector)
        elseif vector.isVector then
            return getVector(self.x * vector.x, self.y * vector.y)
        end
    end

    function vector:divide(vector)
        if type(vector) == "number" then
            return getVector(self.x / vector, self.y / vector)
        elseif vector.isVector then
            return getVector(self.x / vector.x, self.y / vector.y)
        end
    end

    function vector:modulo(vector)
        if type(vector) == "number" then
            return getVector(self.x % vector, self.y % vector)
        elseif vector.isVector then
            return getVector(self.x % vector.x, self.x % vector.y)
        end
    end

    function vector:abs()
        return getVector(math.abs(self.x), math.abs(self.y))
    end

    function vector:rotate(radian)
        local x, y
        x = self.x * math.cos(radian) - self.y * math.sin(radian)
        y = self.x * math.sin(radian) + self.y * math.cos (radian)
        return getVector(x, y)
    end

    function vector:eq(vector)
        if vector.isVector then
            return vector.x == self.x and vector.y == self.y
        end
    
        return false
    end

    function vector:print()
        print(self.x, self.y)
    end

    return vector
end

return getVector
