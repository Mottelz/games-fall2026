-- A tiny draggable slider, no libraries needed.
local Slider = {}
Slider.__index = Slider

local KNOB_R = 7
local LABEL_W = 70

function Slider.new(label, min, max, value, x, y, w)
    return setmetatable({
        label = label,
        min = min,
        max = max,
        value = value,
        x = x,
        y = y,
        w = w,
        dragging = false,
    }, Slider)
end

function Slider:knobX()
    return self.x + (self.value - self.min) / (self.max - self.min) * self.w
end

function Slider:setFromMouse(mx)
    local t = math.max(0, math.min(1, (mx - self.x) / self.w))
    self.value = self.min + (self.max - self.min) * t
end

function Slider:formatValue()
    if self.max - self.min > 10 then
        return string.format("%d", math.floor(self.value + 0.5))
    end
    return string.format("%.2f", self.value)
end

function Slider:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.label, self.x - LABEL_W, self.y - 7)

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.x, self.y, self.x + self.w, self.y)

    love.graphics.setColor(self.dragging and { 1, 1, 0 } or { 1, 1, 1 })
    love.graphics.circle("fill", self:knobX(), self.y, KNOB_R)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self:formatValue(), self.x + self.w + 12, self.y - 7)
end

-- Returns true if the click landed on this slider.
function Slider:mousepressed(mx, my)
    local hit = mx >= self.x - KNOB_R and mx <= self.x + self.w + KNOB_R
        and math.abs(my - self.y) <= KNOB_R + 3
    if hit then
        self.dragging = true
        self:setFromMouse(mx)
    end
    return hit
end

function Slider:mousemoved(mx)
    if self.dragging then self:setFromMouse(mx) end
end

function Slider:mousereleased()
    self.dragging = false
end

return Slider
