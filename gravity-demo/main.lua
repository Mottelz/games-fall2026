local Slider = require("slider")

-- Each scene has: load(), update(dt), draw(), spawn(spec), clear(), name.
local scenes = {
    require("scenes.manual"),
    require("scenes.physics"),
}
local current = 1

local sliders = {}

local PANEL_X, PANEL_Y = 10, 10
local PANEL_W, ROW_H = 300, 30

local function setting(name)
    return sliders[name].value
end

-- Build a new ball from the current slider values. Both scenes take the
-- same description, so a spawned ball looks the same in either one.
local function newBallSpec()
    local r = setting("size")
    local w = love.graphics.getWidth()
    return {
        x = r + love.math.random() * (w - 2 * r),
        y = r + 10,
        vx = love.math.random(-300, 300),
        r = r,
        gravity = setting("gravity"),
        bounce = setting("bounce"),
        friction = setting("friction"),
        color = {
            0.3 + love.math.random() * 0.7,
            0.3 + love.math.random() * 0.7,
            0.3 + love.math.random() * 0.7,
        },
    }
end

function love.load()
    local sx, sw = PANEL_X + 80, 150
    local function row(i) return PANEL_Y + 20 + (i - 1) * ROW_H end
    sliders.gravity  = Slider.new("Gravity",  0, 5000, 1500, sx, row(1), sw)
    sliders.bounce   = Slider.new("Bounce",   0, 1,    0.6,  sx, row(2), sw)
    sliders.size     = Slider.new("Size",     5, 100,  30,   sx, row(3), sw)
    sliders.friction = Slider.new("Friction", 0, 1,    0.3,  sx, row(4), sw)
    sliders.order = { "gravity", "bounce", "size", "friction" }

    for _, scene in ipairs(scenes) do
        scene:load()
        scene:spawn(newBallSpec())
    end
end

function love.update(dt)
    -- Only the visible scene moves; the other one is paused until you switch back.
    scenes[current]:update(dt)
end

function love.keypressed(key)
    if key == "tab" then
        current = current % #scenes + 1
    elseif key == "space" then
        scenes[current]:spawn(newBallSpec())
    elseif key == "c" then
        scenes[current]:clear()
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button ~= 1 then return end
    for _, name in ipairs(sliders.order) do
        if sliders[name]:mousepressed(x, y) then return end
    end
end

function love.mousemoved(x)
    for _, name in ipairs(sliders.order) do
        sliders[name]:mousemoved(x)
    end
end

function love.mousereleased()
    for _, name in ipairs(sliders.order) do
        sliders[name]:mousereleased()
    end
end

function love.draw()
    scenes[current]:draw()

    -- Settings panel
    local panelH = 20 + #sliders.order * ROW_H + 10
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", PANEL_X, PANEL_Y, PANEL_W, panelH, 6, 6)
    for _, name in ipairs(sliders.order) do
        sliders[name]:draw()
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Scene " .. current .. ": " .. scenes[current].name,
        PANEL_X, PANEL_Y + panelH + 6)
    love.graphics.print("Tab: switch scene   Space: spawn   C: clear   (sliders affect new balls)",
        PANEL_X, PANEL_Y + panelH + 24)
end
