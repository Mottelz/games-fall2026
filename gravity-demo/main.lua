local ball = {}
local GRAVITY = 10000


function love.load()
    ball = {
        x = 25,
        y = 25,
        vx = 200,
        vy = 0,
        bounce = 0.1,
        r = 100
    }
end


function love.update(dt)
    ball.vy = ball.vy + GRAVITY * dt
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    local floor = love.graphics.getHeight() - ball.r
    if ball.y > floor then
        ball.y = floor
        ball.vy = -ball.vy * ball.bounce
        if math.abs(ball.vy) < 5 then ball.vy = 0 end
    end

    local w = love.graphics.getWidth() - ball.r
    if ball.x < ball.r or ball.x > w then
        ball.x = math.max(ball.r, math.min(w, ball.x))
        ball.vx = -ball.vx
    end
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", ball.x, ball.y, ball.r)
end