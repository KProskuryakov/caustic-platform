function love.load ()
  love.graphics.setBackgroundColor(235, 235, 235)
  
  keybinds = require 'keybinds'
  
  player = {
    x = 0, y = 0, velX = 0, velY = 0, w = 40, h = 40, 
    imagew = 40, imageh = 40, image = love.graphics.newImage('player.png'), 
    gravity = 20, terminalVelocity = 256, jumpVelocity = -6, runSpeed = 128
  }
  level1 = {
    walls = {
      {x=0, y=296, w=583, h=39}, 
      {x=608, y=262, w=36, h=36}
    },
    image = love.graphics.newImage('level1.png')
  }
end

function love.update (dt)
  if love.keyboard.isDown(keybinds.moveLeft) then
    player.velX = -player.runSpeed * dt
  elseif love.keyboard.isDown(keybinds.moveRight) then
    player.velX = player.runSpeed * dt
  end
  if love.keyboard.isDown(keybinds.jump) then
    if player.velY == 0 then
      player.velY = player.jumpVelocity
    end
  end
  
  player.velY = math.min(player.velY + player.gravity * dt, player.terminalVelocity * dt)
  
  player.x = player.x + player.velX
  player.y = player.y + player.velY
  player.velX = 0
  
  do -- collision for player
    local x = player.x + player.w / 2
    local lowery = player.y + player.h
    local uppery = player.y
    
    for _, wall in ipairs(level1.walls) do
      if x >= wall.x and x <= wall.x + wall.w then
        local isCollidingLower = lowery <= wall.y + wall.h and lowery >= wall.y
        local isCollidingUpper = uppery <= wall.y + wall.h and uppery >= wall.y
        if isCollidingLower then
          player.y = wall.y - player.h
          player.velY = 0
        end
      end
    end
  end -- end collision for player
end

function love.draw ()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(level1.image, 0, 0)
  love.graphics.draw(player.image, player.x, player.y)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 750, 10)
end