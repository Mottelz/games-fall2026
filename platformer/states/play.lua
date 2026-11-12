local Play = {}
local Player = require("player")

function Play.enter()
    Play.player = Player.new(100, 300)
    Play.solids = {  
        { x = 0, y = 560, w = 800, h = 40 },
        { x = 150, y = 450, w = 160, h = 20 },
        { x = 380, y = 370, w = 160, h = 20 },
        { x = 600, y = 290, w = 160, h = 20 },   
    }
end

function Play.update(dt)
    dt = math.min(dt, 1/30) 
    Player.update(Play.player, dt, Play.solids)
end

function Play.draw()
    love.graphics.setColor(0.4, 0.4, 0.5)
    for _, s in ipairs(Play.solids) do
        love.graphics.rectangle("fill", s.x, s.y, s.w, s.h)
    end
    Player.draw(Play.player)
    love.graphics.setColor(1, 1, 1)
end

function Play.keypressed(key)
    if key == "space" or key == "up" or key == "w" then
        Player.jump(Play.player)
    elseif key == "p" then
        State.push("pause")
    end
end

function Play.keyreleased(key)
    if key == "space" or key == "up" or key == "w" then
        Player.releaseJump(Play.player)
    end
end

return Play