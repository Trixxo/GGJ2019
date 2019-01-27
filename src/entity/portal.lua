local function getPortal(x, y)
    local portal = {}

    portal.drawType = "rectangle"
    portal.dimension = {width = 100, height = 200}

    portal.shape = love.physics.newRectangleShape(portal.dimension.width, portal.dimension.height)

    portal.body = love.physics.newBody(world, x, y, "kinematic")
    portal.body:setGravityScale(0)

    portal.fixture = love.physics.newFixture(portal.body, portal.shape, 1)
    portal.fixture:setUserData(portal)
    portal.fixture:setCategory(6)
    portal.fixture:setMask(2, 3, 4, 5)

    return portal
end

return getPortal
