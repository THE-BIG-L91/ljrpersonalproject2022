
local Map = {}
local STI = require("sti")
local Coin = require("coin")
local Enemy = require("enemy")
local Player = require("player")

function Map:load()
   self.currentLevel = 1
   World = love.physics.newWorld(0,2000)
   World:setCallbacks(beginContact, endContact)

   self:init()
end
music = 0
function Map:init()
   self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})

   self.level:box2d_init(World)
   self.solidLayer = self.level.layers.solid
   self.groundLayer = self.level.layers.non_collision
   self.entityLayer = self.level.layers.entity

   self.solidLayer.visible = false
   self.entityLayer.visible = false
   music = love.audio.newSource("assets/sfx/"..self.currentLevel..".mp3", "stream")

   MapWidth = self.groundLayer.width * 16

   self:spawnEntities()
end

function Map:next()
   self:clean()
   self.currentLevel = self.currentLevel + 1

   self:init()
   Player:resetPosition()
end

function Map:clean()
   self.level:box2d_removeLayer("solid")
   self.level:box2d_removeLayer("entity")

   Coin.removeAll()
   Enemy.removeAll()
 --  Spike.removeAll()
end

function Map:update()
   if Player.x > MapWidth - 16 then
      self:next()
   end
end

function Map:spawnEntities()
      for i,v in pairs(self.entityLayer.objects) do
      if v.class == "enemy" then
            print("enemy")
         Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
      elseif v.class == "coin" then
         Coin.new(v.x, v.y)
      end
   end
   love.audio.stop()
   music = love.audio.newSource("assets/sfx/"..self.currentLevel..".mp3", "stream")
  music:setVolume(.5)
   music:play()
   print("init")

end

return Map
