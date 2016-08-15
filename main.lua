local keybinds
local bump
local player
local world
local level

function love.load ()
  -- set the background color to light grey
  love.graphics.setBackgroundColor(235, 235, 235)
  
  -- get the keybinds from the keybinds file
  keybinds = require 'keybinds'
  
  -- uses the bump.lua library
  bump = require 'bump'
  world = bump.newWorld()
  
  -- create the player
  player = {
    x = 0, y = 0, vx = 0, vy = 0, w = 40, h = 40,
    onGround = false,
    imagew = 40, imageh = 40, image = love.graphics.newImage('player.png'), 
    gravity = 1024, terminalVelocity = 512, jumpVelocity = -512, runSpeed = 128
  }
  
  world:add(player, player.x, player.y, player.w, player.h)
  
  -- create the level
  level = {
    startX = 20, startY = 0,
    walls = {
      {x=0, y=296, w=583, h=39}, 
      {x=608, y=262, w=36, h=36},
      {x=95, y=225, w=49, h=67},
      {x=209, y=173, w=74, h=45},
      {x=350, y=101, w=54, h=195},
      {x=533, y=335, w=50, h=80},
      {x=730, y=472, w=48, h=42},
      {x=267, y=555, w=321, h=41},
      {x=133, y=492, w=85, h=42}
    },
    image = love.graphics.newImage('level1.png')
  }
  
  for i, wall in ipairs(level.walls) do
    world:add(wall, wall.x, wall.y, wall.w, wall.h)
  end
  
  -- set the player's position to the start position of the level
  player.x, player.y = level.startX, level.startY
  world:update(player, level.startX, level.startY)
end -- love.load

function love.update (dt)
  -- process the keybinds for the player
  if love.keyboard.isDown(keybinds.moveLeft) then
    player.vx = -player.runSpeed
  elseif love.keyboard.isDown(keybinds.moveRight) then
    player.vx = player.runSpeed
  else
    player.vx = 0
  end -- l/r movement
  if love.keyboard.isDown(keybinds.jump) then
    if player.onGround then
      player.vy = player.jumpVelocity
    end
  end -- jump
  
  -- increases the player's falling speed up to a terminal velocity value
  player.vy = math.min(player.vy + player.gravity * dt, player.terminalVelocity)
  
  local goalX, goalY = player.x + player.vx * dt, player.y + player.vy * dt
  local actualX, actualY, cols, len = world:move(player, goalX, goalY)
  player.onGround = player.y == actualY
  player.x, player.y = actualX, actualY
  
  -- deal with the collisions
  for i=1,len do
    print('collided with ' .. tostring(cols[i].other))
  end
end

function love.draw ()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(level.image, 0, 0)
  love.graphics.draw(player.image, player.x, player.y)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 750, 10)
end