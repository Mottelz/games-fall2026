-- Scene 2: the same balls, but simulated by LÖVE's built-in physics engine (Box2D).
local Physics = {
    name = "love.physics (Box2D)",
    balls = {},
}

-- Box2D has one gravity for the whole world. To keep "each ball keeps the
-- gravity it spawned with", the world gets a base gravity and each ball
-- scales it: gravityScale = ball gravity / BASE_GRAVITY.
local BASE_GRAVITY = 1000

function Physics:load()
    -- Measurements are in pixels; 64 px counts as 1 metre inside Box2D.
    love.physics.setMeter(64)
    self.world = love.physics.newWorld(0, BASE_GRAVITY, true)

    -- A static loop around the edge of the window: floor, walls and ceiling.
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local body = love.physics.newBody(self.world, 0, 0, "static")
    local shape = love.physics.newChainShape(true, 0, 0, w, 0, w, h, 0, h)
    local fixture = love.physics.newFixture(body, shape)
    -- Box2D combines bounce with max(a, b) and friction with sqrt(a * b).
    -- Bounce 0 and friction 1 on the walls let each ball's own values decide.
    fixture:setRestitution(0)
    fixture:setFriction(1)
end

-- spec = { x, y, vx, r, gravity, bounce, friction, color }
function Physics:spawn(spec)
    local body = love.physics.newBody(self.world, spec.x, spec.y, "dynamic")
    local shape = love.physics.newCircleShape(spec.r)
    local fixture = love.physics.newFixture(body, shape, 1) -- density 1: bigger = heavier

    fixture:setRestitution(spec.bounce)
    fixture:setFriction(spec.friction)
    body:setGravityScale(spec.gravity / BASE_GRAVITY)
    body:setLinearVelocity(spec.vx, 0)
    -- A perfectly round ball on a flat floor would roll forever in Box2D,
    -- so add a little rolling resistance.
    body:setAngularDamping(0.5)

    table.insert(self.balls, { body = body, shape = shape, color = spec.color })
end

function Physics:clear()
    for _, b in ipairs(self.balls) do
        b.body:destroy()
    end
    self.balls = {}
end

function Physics:update(dt)
    self.world:update(dt)
end

function Physics:draw()
    for _, b in ipairs(self.balls) do
        local x, y = b.body:getPosition()
        local r = b.shape:getRadius()
        local angle = b.body:getAngle()

        love.graphics.setColor(b.color)
        love.graphics.circle("fill", x, y, r)

        -- A line from the centre to the edge so you can see the ball spin.
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.setLineWidth(2)
        love.graphics.line(x, y, x + math.cos(angle) * r, y + math.sin(angle) * r)
    end
end

return Physics
