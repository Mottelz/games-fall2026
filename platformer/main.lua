State = require("state")


function love.load()
    State.register("menu", require("states.menu"))
    State.register("play", require("states.play"))
    State.register("pause", require("states.pause"))
    -- State.switch("menu")
    State.switch("play")
end

function love.update(dt) State.update(dt) end
function love.draw() State.draw() end

function love.keypressed(...)
    State.forward("keypressed", ...)
end

function love.keyreleased(...)
    State.forward("keyreleased", ...)
end
