local keyboard = {}
local lovekey = love.keyboard
local keybinds = require 'keybinds'
local events = {}

function keyboard.bind (event, func)
  events[event] = func
end

function keyboard.update (dt)
  if lovekey.isDown(keybinds.moveLeft) then
    events.moveLeft()
  elseif lovekey.isDown(keybinds.moveRight) then
    events.moveRight()
  end
end

function keyboard.keypressed (k)
  if k == keybinds.jump then
    events.jump()
  end
end

return keyboard