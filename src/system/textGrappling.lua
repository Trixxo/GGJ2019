local function getTextGrapplingSystem()
    local system = {}

    local availableKeys = {
        "h",
        "j",
        "k",
        "l",
        "u",
        "o",
        "p",
        "n",
        "m",
        "y",
        "b",
        "6",
        "7",
        "8",
        "9",
    }

    system.missiles = {}

    function system:registerMissile(missile)
        for _, key in ipairs(availableKeys) do
            if self.missiles[key] == nil then
                self.missiles[key] = missile
                missile.text = key
                return
            end
        end
        print("ERROR: no empty key available for new missile")
    end

    function system:removeMissile(missile)
        system.missiles[missile.text] = nil
    end

    function system:keypressed(key, player)
        local missile = self.missiles[key]
        if player:allowedToTryGrapple() then
            if missile and missile:isOnScreen() then
                player:connectToMissile(self.missiles[key])
            end
        end
    end

    return system
end

return getTextGrapplingSystem
