-- Scene 1: hand-written physics (gravity, bouncing, friction, collisions).
local Manual = {
    name = "Hand-written physics",
    balls = {},
}

function Manual:load() end

-- spec = { x, y, vx, r, gravity, bounce, friction, color }
function Manual:spawn(spec)
    table.insert(self.balls, {
        x = spec.x,
        y = spec.y,
        vx = spec.vx,
        vy = 0,
        r = spec.r,
        gravity = spec.gravity,
        bounce = spec.bounce,
        friction = spec.friction,
        color = spec.color,
    })
end

function Manual:clear()
    self.balls = {}
end

local function updateBall(b, dt)
    b.vy = b.vy + b.gravity * dt
    b.x = b.x + b.vx * dt
    b.y = b.y + b.vy * dt

    -- Floor
    local floor = love.graphics.getHeight() - b.r
    if b.y >= floor then
        b.y = floor
        if b.vy > 0 then
            b.vy = -b.vy * b.bounce
            if math.abs(b.vy) < 5 then b.vy = 0 end
        end

        local slow = b.friction * b.gravity * dt
        if math.abs(b.vx) <= slow then
            b.vx = 0
        else
            b.vx = b.vx - slow * (b.vx > 0 and 1 or -1)
        end
    end

    -- Ceiling
    if b.y < b.r then
        b.y = b.r
        if b.vy < 0 then b.vy = -b.vy * b.bounce end
    end

    -- Walls
    local right = love.graphics.getWidth() - b.r
    if b.x < b.r or b.x > right then
        b.x = math.max(b.r, math.min(right, b.x))
        b.vx = -b.vx * b.bounce
    end
end

local function clampToScreen(b)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    b.x = math.max(b.r, math.min(w - b.r, b.x))
    b.y = math.max(b.r, math.min(h - b.r, b.y))
end

-- Bounce two balls off each other if they overlap.
-- Mass is based on area, so bigger balls push smaller ones around.
local function collide(a, b)
    local dx, dy = b.x - a.x, b.y - a.y
    local dist = math.sqrt(dx * dx + dy * dy)
    local minDist = a.r + b.r
    if dist >= minDist or dist == 0 then return end

    -- Unit vector pointing from a to b
    local nx, ny = dx / dist, dy / dist
    local ma, mb = a.r * a.r, b.r * b.r
    local total = ma + mb

    -- 1. Push them apart so they no longer overlap (lighter ball moves more)
    local overlap = minDist - dist
    a.x = a.x - nx * overlap * (mb / total)
    a.y = a.y - ny * overlap * (mb / total)
    b.x = b.x + nx * overlap * (ma / total)
    b.y = b.y + ny * overlap * (ma / total)

    -- 2. If they're moving towards each other, bounce them apart
    local closing = (b.vx - a.vx) * nx + (b.vy - a.vy) * ny
    if closing < 0 then
        local bounce = math.min(a.bounce, b.bounce)
        local impulse = -(1 + bounce) * closing / (1 / ma + 1 / mb)
        a.vx = a.vx - impulse / ma * nx
        a.vy = a.vy - impulse / ma * ny
        b.vx = b.vx + impulse / mb * nx
        b.vy = b.vy + impulse / mb * ny
    end
end

function Manual:update(dt)
    local balls = self.balls
    for _, b in ipairs(balls) do
        updateBall(b, dt)
    end

    -- Check every pair once. A few passes helps piles of balls settle.
    for _ = 1, 3 do
        for i = 1, #balls do
            for j = i + 1, #balls do
                collide(balls[i], balls[j])
            end
        end
    end

    for _, b in ipairs(balls) do
        clampToScreen(b)
    end
end

function Manual:draw()
    for _, b in ipairs(self.balls) do
        love.graphics.setColor(b.color)
        love.graphics.circle("fill", b.x, b.y, b.r)
    end
end

return Manual
