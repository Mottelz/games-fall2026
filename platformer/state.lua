local State = { stack = {}, registry = {} }

function State.register(name, state)
    State.registry[name] = state
end

function State.push(name, ...)
    local s = State.registry[name]
    assert(s, "No state named " .. name)
    table.insert(State.stack, s)
    if s.enter then s.enter(...) end
end

function State.pop()
    local s = table.remove(State.stack)
    if s and s.leave then s.leave() end
    local below = State.top()
    if below and below.resume then below.resume() end
end

function State.top()
     return State.stack[#State.stack]
end

function State.switch(name, ...)
    while #State.stack > 0 do State.pop() end
    State.push(name, ...)
end

function State.update(dt)
    local s = State.top()
    if s and s.update then s.update(dt) end
end

function State.draw()
    for _, s in ipairs(State.stack) do
        if s.draw then s.draw() end
    end
end

function State.forward(event, ...)
    local s = State.top()
    if s and s[event] then s[event](...) end
end

return State