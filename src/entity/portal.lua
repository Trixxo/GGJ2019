local function getPortal(x, y)
    local portal = {}

    portal.drawType = "image"
    portal.image = resources.images.portal
    portal.dimension = {width = 600, height = 600}

    portal.shape = love.physics.newCircleShape(portal.dimension.width / 2)

    portal.body = love.physics.newBody(world, x, y, "kinematic")
    portal.body:setGravityScale(0)
    portal.body:setAngularVelocity(50)

    portal.fixture = love.physics.newFixture(portal.body, portal.shape, 1)
    portal.fixture:setUserData(portal)
    portal.fixture:setCategory(6)
    portal.fixture:setMask(2, 3, 4, 5)

    return portal
end

return getPortal
