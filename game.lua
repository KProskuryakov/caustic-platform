local game = {}
local player     = require 'player'
local level      = require 'level'
local camera     = require 'camera'
local keyboard   = require 'keyboard'

function game.load ()
  level:load('level1')
  player:load(level.startPosition)
  
  keyboard.bind("moveLeft", player:moveLeft())
  keyboard.bind("moveRight", player:moveRight())
  keyboard.bind("jump", player:jump())
end

function game.update (dt)
  player:update(dt)
  keyboard.update(dt)
  level:update(dt)
end

function game.draw ()
  camera:draw()
end

function game.keypressed (k)
  keyboard:keypressed(k)
end

return game