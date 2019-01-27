local function getStateStack()

    stateStack = {}

    stateStack.states = {}
    stateStack.backCounter = 0

    function stateStack:current()
        if #self.states == 0 then
            return nil
        elseif #self.states > 0 then
            return self.states[#self.states]
        end
    end

    function stateStack:push(element)
        table.insert(self.states, element)
        self:current():load()
    end

    function stateStack:pop()
        if self:current() then
            table.remove(self.states, #self.states)
        end
    end

    function stateStack:popload()
        if self:current() then
            table.remove(self.states, #self.states)
        end
        self:current():load()
    end

    function stateStack:draw()
        for i = 0, #self.states-1 , 1 do
            if self.states[#self.states-i].renderBelow == false then
                break
            elseif self.states[#self.states-i].renderBelow == true then
                self.backCounter = i
            end
        end
        for i = self.backCounter, 0 , -1 do
            self.states[#self.states-i]:draw()
        end
    end

    function stateStack:update(dt)
        if self:current() then self:current():update(dt) end
    end

    return stateStack
end

return getStateStack
