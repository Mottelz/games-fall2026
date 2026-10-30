local Bullets = {}
Bullets.list = {}

function Bullets.fire(x, y)
    table.insert(Bullets.list, {
        x = x, y = y, w = 4, h = 12, speed = 500,
    })
end

function Bullets.update(dt)
    for i = #Bullets.list, 1, -1 do
        local b = Bullets.list[i]
        b.y = b.y - b.speed * dt
        if b.y < 0 then table.remove(Bullets.list, i) end
    end
end

function Bullets.draw()
    for _, b in ipairs(Bullets.list) do
        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
    end
end


return Bullets