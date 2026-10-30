local Player = {}
Player.sheet = {}
Player.quads = {}
Player.FRAME_TIME = 0.25

function Player.new()
    return { x = 380, y = 550, w = 40, h = 20, speed = 300, frame = 1, frameDir = 1, frameTimer = 0 }
end

function Player.load()
    Player.sheet = love.graphics.newImage("assets/player.png")
    local sw, sh = Player.sheet:getDimensions()
    for i = 1, 3 do
        local x = (i - 1) * 40
        Player.quads[i] = love.graphics.newQuad(x, 0, 40, 20, sw, sh)
    end
end

function Player.update(p, dt)
    if love.keyboard.isDown("left", "a") then
        p.x = p.x - p.speed * dt
    end

    if love.keyboard.isDown("right", "d") then
        p.x = p.x + p.speed * dt
    end

    p.frameTimer = p.frameTimer + dt
    if p.frameTimer >= Player.FRAME_TIME then
        p.frameTimer = p.frameTimer - Player.FRAME_TIME
        p.frame = p.frame + p.frameDir
        if p.frame == 1 or p.frame == #Player.quads then
            p.frameDir = -p.frameDir
        end
    end

    p.x = math.max(0, math.min(love.graphics.getWidth() - p.w, p.x))
end

function Player.draw(p)
    love.graphics.draw(Player.sheet, Player.quads[p.frame], p.x, p.y)
end


return Player