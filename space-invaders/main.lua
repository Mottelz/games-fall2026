local Player = require("player")
local Bullets = require("bullets")
local Invaders = require("invaders")
local Explosion = require("explosion")
local Collision = require("collision")
local player
local state
local score
local hiScore

local function startGame()
    score = 0
    player = Player.new()
    Bullets.clear()
    Invaders.spawn()
    Explosion.list = {} 
    state = "playing"
end

local function endGame()
    if #Invaders.list == 0 then
        state = "win"
    elseif Invaders.lowest() > player.y then
        state = "gameOver"
    end

    if score > hiScore and not state == "playing" then
        hiScore = score
    end
end
 

local function checkHits()
    for bi = #Bullets.list, 1, -1 do
        local b = Bullets.list[bi]
        for ii = #Invaders.list, 1, -1 do
            local inv = Invaders.list[ii]
            if Collision.overlap(b, inv) then
                Explosion.spawn(inv.x, inv.y - 6)
                table.remove(Invaders.list, ii)
                table.remove(Bullets.list, bi)
                score = score + 10
                break
            end
        end
    end
end


function love.load()
    love.graphics.setBackgroundColor(0, 0, 0.2)
    Player.load()
    Invaders.load()
    Explosion.load()
    hiScore = 0
    startGame()
end

function love.update(dt)
    if state == "playing" then
        Bullets.update(dt)
        Player.update(player, dt)
        Invaders.update(dt)
        Explosion.update(dt)
        checkHits()
        endGame()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif state == "playing" then
        if key == "space" then
            Bullets.fire(player.x + 18, player.y)
        end
    elseif key == "return" then
        startGame()
    end
end

function love.draw()
    if state == "playing" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Hi Score: " .. hiScore .. "  Score: " .. score, 0, 0, 13 * 50, "left")
        Player.draw(player)
        Bullets.draw()
        Invaders.draw()
        Explosion.draw()
    elseif state == "gameOver" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("YOU LOST!!!\nScore: " .. score, 0, math.floor(love.graphics.getHeight() / 2), love.graphics.getWidth(), "center")
    elseif state == "win" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("YOU WON!!!\nScore: " .. score, 0, math.floor(love.graphics.getHeight() / 2), love.graphics.getWidth(), "center")
    end
end