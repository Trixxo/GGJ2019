local function getStateStack()

    stateStack = {}

    stateStack.states = {}
    stateStack.backCounter = 0
    stateStack.stateChanged = false

    function stateStack:current()
        if #self.states == 0 then
            return nil
        elseif #self.states > 0 then
            return self.states[#self.states]
        end
    end

    function stateStack:push(element)
        table.insert(self.states, element)
        self.stateChanged = true
    end

    function stateStack:pop()
        if self:current() then
            table.remove(self.states, #self.states)
        end
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
        if self.stateChanged then
            print("load")
            self:current():load()
            self.stateChanged = false
        end

        print("update", #self.states)
        if self:current() then self:current():update(dt) end
    end

    return stateStack
end

return getStateStack
