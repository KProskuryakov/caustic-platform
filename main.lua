local tactile, keybinds, control
local player
local bump, bumpWorld
local level
local graphics
local humpCamera, gameCamera

function love.load ()
  graphics = love.graphics
  graphics.setBackgroundColor(255, 255, 255) -- set the background color to white
  
  -- uses the bump.lua library for collision detection
  bump = require 'lib.bump.bump'
  bumpWorld = bump.newWorld()
  
  -- uses the HUMP camera module
  humpCamera = require 'lib.hump.camera'
  
  -- create the player
  player = {
    x = 0, y = 0, vx = 0, vy = 0, w = 40, h = 40,
    onGround = false,
    imagew = 40, imageh = 40, image = love.graphics.newImage('player.png'), 
    gravity = 1024, terminalVelocity = 512, jumpVelocity = -512, runSpeed = 128
  }
  
  bumpWorld:add(player, player.x, player.y, player.w, player.h)
  
  -- create the level
  level = {
    startX = 20, startY = 0,
    walls = {
      {x=0, y=296, w=583, h=39}, 
      {x=608, y=262, w=36, h=36},
      {x=95, y=228, w=49, h=67},
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
    bumpWorld:add(wall, wall.x, wall.y, wall.w, wall.h)
  end
  
  -- set the player's position to the start position of the level
  player.x, player.y = level.startX, level.startY
  bumpWorld:update(player, level.startX, level.startY)
  
  gameCamera = humpCamera(player.x, player.y)
  gameCamera.smoother = humpCamera.smooth.damped(5)
  
  tactile = require 'lib.tactile.tactile' -- tactile library for inputs
  keybinds = require 'keybinds' -- get the keybinds from the keybinds file
  control = {
    horizontal = tactile.newControl():addButtonPair(tactile.keys(keybinds.moveLeft), tactile.keys(keybinds.moveRight)),
    jump = tactile.newControl():addButton(tactile.keys(keybinds.jump))
  }
end -- love.load

function love.update (dt)
  control.horizontal:update()
  control.jump:update()
  
  -- process the keybinds for the player
  player.vx = player.runSpeed * control.horizontal() -- l/r movement
  if control.jump:isDown() and player.onGround then -- jump
    player.vy = player.jumpVelocity
  end -- jump
  
  -- increases the player's falling speed up to a terminal velocity value
  player.vy = math.min(player.vy + player.gravity * dt, player.terminalVelocity)
  
  local goalX, goalY = player.x + player.vx * dt, player.y + player.vy * dt
  local actualX, actualY, cols, len = bumpWorld:move(player, goalX, goalY)
  player.onGround = player.y == actualY
  player.x, player.y = actualX, actualY
  
  -- deal with the collisions
  for i=1,len do
    print('collided with ' .. tostring(cols[i].other))
  end
  
  gameCamera:lockPosition(player.x + player.imagew/2, player.y + player.imageh/2)
end

function love.draw ()
  gameCamera:attach()
  graphics.setColor(255, 255, 255)
  graphics.draw(level.image, 0, 0)
  graphics.draw(player.image, player.x, player.y)
  gameCamera:detach()
  
  graphics.setColor(0, 0, 0)
  graphics.print("FPS: " .. love.timer.getFPS(), 750, 10)
end