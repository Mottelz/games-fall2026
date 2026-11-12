local Collision = require("collision")
local Player = {}

local SPEED = 250
local JUMP = -600
local GRAVITY = 1500

function Player.new(x, y)
  return {
    x = x, y = y, w = 24, h = 36, vx = 0, vy = 0,
    onGround = false, invulnerable = 0,
  }
end

function Player.update(p, dt, solids)
    local k = love.keyboard
    local move = 0

    if k.isDown("left", "a") then move = move - 1 end
    if k.isDown("right", "d") then move = move + 1 end
    p.vx = move * SPEED

    p.x = p.x + p.vx * dt
    for _, s in ipairs(solids) do
        if Collision.overlap(p, s) then
            if p.vx > 0 then
                p.x = s.x - p.w
            else
                p.x = s.x + s.w
            end
        end
    end

    p.vy = p.vy + GRAVITY * dt
    p.y = p.y + p.vy * dt
    p.onGround = false
    for _, s in ipairs(solids) do
        if Collision.overlap(p, s) then
            if p.vy > 0 then
                p.y = s.y - p.h
                -- landed on top
                p.onGround = true
            else
                p.y = s.y + s.h
                -- bumped the underside
            end
            p.vy = 0
        end
    end
end

function Player.jump(p)
    if p.onGround then p.vy = JUMP end
end

function Player.releaseJump(p)
    if p.vy < 0 then p.vy = p.vy * 0.5 end
end

function Player.draw(p)
    love.graphics.setColor(0.36, 0.84, 0.66)
    love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
end

return Player