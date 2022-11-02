

local GUI = {}
local Player = require("player")

function GUI:load()
   self.coins = {}
   self.coins.img = love.graphics.newImage("assets/coin.png")
   self.coins.width = self.coins.img:getWidth()
   self.coins.height = self.coins.img:getHeight()
   self.coins.scale = 3
   self.coins.x = love.graphics.getWidth() - 100
   self.coins.y = 40

   self.hearts = {}
   self.hearts.img = love.graphics.newImage("assets/heart.png")
   self.hearts.bgimg = love.graphics.newImage("assets/heartbg.png")
   self.hearts.width = self.hearts.img:getWidth()
   self.hearts.height = self.hearts.img:getHeight()
   self.hearts.x = 0
   self.hearts.y = 30
   self.hearts.scale = 3
   self.hearts.spacing = self.hearts.width * self.hearts.scale

   self.font = love.graphics.newFont("assets/Contra.ttf", 36)
end

function GUI:update(dt)

end

function GUI:draw()
   self:displayCoinText()
   self:displayHearts()
end

function GUI:displayHearts()
      for i=1,3 do
            local x = self.hearts.x + self.hearts.spacing * i
         love.graphics.draw(self.hearts.bgimg, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
   end
   for i=1,Player.health.current do
      local x = self.hearts.x + self.hearts.spacing * i
      love.graphics.setColor(0,0,0,0.5)
      love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
   end

end

function GUI:displayCoinText()
   love.graphics.setFont(self.font)
   local x = self.coins.x + self.coins.width * self.coins.scale
   local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
   love.graphics.setColor(1,1,1,1)
   love.graphics.print(Player.coins, x, y)
end

return GUI
