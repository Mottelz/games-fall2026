local Collision = {}

-- Squares Overlap
function Collision.overlap(a, b)
    return 
        a.x < b.x + b.w and 
        b.x < a.x + a.w and 
        a.y < b.y + b.h and 
        b.y < a.y + a.h
end

-- Circles Overlap
function Collision.circles(a, b)
    local dx, dy = a.cx - b.cx, a.cy - b.cy
    local r = a.r + b.r
    return dx * dx + dy * dy < r * r
end

return Collision