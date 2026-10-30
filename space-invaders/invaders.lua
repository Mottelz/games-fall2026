local Invaders = {}
Invaders.dir = 1
Invaders.frame = 1
Invaders.frameTimer = 0
Invaders.FRAME_TIME = 0.5
Invaders.quads = {}
Invaders.list = {}


function Invaders.load()
    Invaders.sheet = love.graphics.newImage("assets/invaders.png")
    local sw, sh = Invaders.sheet:getDimensions()
    for i = 1, 2 do
        Invaders.quads[i] = love.graphics.newQuad((i - 1) * 40, 0, 40, 28, sw, sh) 
    end
end

function Invaders.spawn()
    for row = 1, 5 do
        for col = 1, 11 do
            table.insert(Invaders.list, {
                x = 60 + (col - 1) * 60,
                y = 60 + (row - 1) * 48,
                w = 40,
                h = 28
            })
        end
    end
end

function Invaders.update(dt)
    local function currentSpeed()
        local left = #Invaders.list
        return 30 + (55 - left) * 3
    end

    local hitEdge = false
    local dx = Invaders.dir * currentSpeed() * dt
    local rightEdge = love.graphics.getWidth() - 40
    
    for _, inv in ipairs(Invaders.list) do
        inv.x = inv.x + dx
        if inv.x < 10 or inv.x > rightEdge then
            hitEdge = true
        end
    end

    if hitEdge then
        Invaders.dir = -Invaders.dir
        for _, inv in ipairs(Invaders.list) do
            inv.x = inv.x - dx
            inv.y = inv.y + 28
        end
    end

    Invaders.frameTimer = Invaders.frameTimer + dt
    if Invaders.frameTimer >= Invaders.FRAME_TIME then
        Invaders.frameTimer = Invaders.frameTimer - Invaders.FRAME_TIME
        Invaders.frame = Invaders.frame % 2 + 1
    end
end

function Invaders.draw()
    for i, inv in ipairs(Invaders.list) do
        love.graphics.draw(Invaders.sheet, Invaders.quads[Invaders.frame], inv.x, inv.y)
    end
end

return Invaders