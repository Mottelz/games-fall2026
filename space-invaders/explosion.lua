local Explosion = {}
Explosion.list = {}
Explosion.quads = {}
Explosion.FRAME_TIME = 0.1


function Explosion.load()
    Explosion.sheet = love.graphics.newImage("assets/explosion.png")
    local sw, sh = Explosion.sheet:getDimensions()

    for i = 1, 4 do
        local x = (i - 1) * 40
        Explosion.quads[i] = love.graphics.newQuad(x, 0, 40, 40, sw, sh)
    end
end

function Explosion.spawn(x, y)
    table.insert(Explosion.list, {x = x, y = y, t = 0})
end

function Explosion.update(dt)
    for i = #Explosion.list, 1, -1 do
        local e = Explosion.list[i]
        e.t = e.t + dt
        if e.t >= Explosion.FRAME_TIME * #Explosion.quads then
            table.remove(Explosion.list, i)
        end
    end
end

function Explosion.draw()
    for i, e in ipairs(Explosion.list) do
        love.graphics.draw(Explosion.sheet, Explosion.quads[math.floor(e.t / Explosion.FRAME_TIME) + 1], e.x, e.y)
    end
end

return Explosion