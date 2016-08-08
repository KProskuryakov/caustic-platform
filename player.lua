local player = {
  x = 0,
  y = 0,
  velX = 0,
  velY = 0
}

function player:load (startPos)
  self.image = love.graphics.newImage('player')
  self.x = startPos.x
  self.y = startPos.y
end

function player:update (dt)
end

function player:draw (g)
  g.draw(self.image)
end

function player:moveLeft ()
  
end
function player:moveRight ()
end
function player:jump ()
end

return player