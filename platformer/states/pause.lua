local Pause = {}

function Pause.draw()
    local w, h = love.graphics.getDimensions()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("PAUSED", 0, 280, w, "center")
end

function Pause.keypressed(key)
    if key == "p" then State.pop() end
end

return Pause