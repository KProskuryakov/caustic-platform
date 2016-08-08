local level = {}

function level:load (filename)
  local currentLevel = require(filename)
  self.startPosition = currentLevel.startPosition
end

function level:update (dt)
  
end

function level:draw (g)
  
end

return level