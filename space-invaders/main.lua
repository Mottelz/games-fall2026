local Player = require("player")
local Bullets = require("bullets")
local Invaders = require("invaders")
local Explosion = require("explosion")
local player


local function overlap(a, b)
    return 
        a.x < b.x + b.w and 
        b.x < a.x + a.w and 
        a.y < b.y + b.h and 
        b.y < a.y + a.h
end 

local function checkHits()
    for bi = #Bullets.list, 1, -1 do
        local b = Bullets.list[bi]
        for ii = #Invaders.list, 1, -1 do
            local inv = Invaders.list[ii]
            if overlap(b, inv) then
                Explosion.spawn(inv.x, inv.y - 6)
                table.remove(Invaders.list, ii)
                table.remove(Bullets.list, bi)
                break
            end
        end
    end
end


function love.load()
    love.graphics.setBackgroundColor(0, 0, 0.2)
    player = Player.new()
    Player.load()
    Invaders.load()
    Invaders.spawn()
    Explosion.load()
end

function love.update(dt)
    Bullets.update(dt)
    Player.update(player, dt)
    Invaders.update(dt)
    Explosion.update(dt)
    checkHits()
end

function love.keypressed(key)
    if key == "space" then
        Bullets.fire(player.x + 18, player.y)
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    Player.draw(player)
    Bullets.draw()
    Invaders.draw()
    Explosion.draw()
end