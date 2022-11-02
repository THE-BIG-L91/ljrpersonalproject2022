
local Enemy = {}
Enemy.__index = Enemy
local Player = require("player")
local enemyBullet = require("enemyBullet")

local ActiveEnemies = {}

--private func
local function find(t, s, o)
  o = o or 1
  assert(s ~= nil, "second argument cannot be nil")
  for i = o, #t do
    if t[i] == s then
      return i
    end
  end
end

local function getDistance(x1,y1,x2,y2)
   local angle = (x2-x1)^2 + (y2-y1)^2
end

function Enemy.removeAll()
   for i,v in ipairs(ActiveEnemies) do
      v:remove()
   end
   index = 0
end

--- Finds the first occurrence in a list
--@param t Table
--@param s Search value
--@param o Starting index (optional)
--@return Numeric index or nil


function Enemy:remove(i)

   print(find(ActiveEnemies,self))
   table.remove(ActiveEnemies, find(ActiveEnemies,self))
   self.physics.body:destroy()
   collectgarbage("collect")
end

index = 1

function Enemy.new(x,y)
   local instance = setmetatable({}, Enemy)
   print("nnew ocelot")
   instance.x = x
   instance.y = y
   instance.offsetY = 0
   instance.r = 0

   instance.speed = 100
   instance.speedMod = 1
   instance.xVel = instance.speed

   instance.health = 3
   instance.damage = 1

   instance.hurtSound = love.audio.newSource("assets/sfx/enemy1Hurt.wav", "static")

   instance.state = "idle"
   instance.index  = index
   instance.animation = {timer = 0, rate = 0.1}
   instance.animation.run = {total = 2, current = 1, img = Enemy.runAnim}
   instance.animation.walk = {total = 2, current = 1, img = Enemy.walkAnim}
   instance.animation.idle = {total = 1, current = 1, img = Enemy.idleAnim}
   instance.animation.draw = instance.animation.walk.img[1]
   instance.direction = "right"


   instance.shotClock = os.time()
   instance.canShoot = true

   instance.physics = {}
   instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
   instance.physics.body:setFixedRotation(true)
   instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
   instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
   instance.physics.body:setMass(25)
   table.insert(ActiveEnemies, index,instance)
   index = index +1
end

function Enemy:dmg(dmg)
   self.hurtSound:play()
   if self.health - dmg > 1 or self.health - dmg == 1 then
       self.health = self.health - dmg
   else
      self:remove()
   end
end
function Enemy.loadAssets()
   Enemy.runAnim = {}
   for i=1,4 do
      Enemy.runAnim[i] = love.graphics.newImage("assets/enemy/run/"..i..".png")
   end

   Enemy.walkAnim = {}
   for i=1,4 do
      Enemy.walkAnim[i] = love.graphics.newImage("assets/enemy/walk/"..i..".png")
   end
   Enemy.idleAnim = {}
   for i=1,1 do
      Enemy.idleAnim[i] = love.graphics.newImage("assets/enemy/idle/"..i..".png")
   end
   Enemy.width = Enemy.runAnim[1]:getWidth()
   Enemy.height = Enemy.runAnim[1]:getHeight()
end

function Enemy:update(dt)
   self:syncPhysics()
   self:animate(dt)
   self:setDirection()
   self:computeAI()
end

function Enemy:setDirection()
   if self.xVel < 0 then
      self.direction = "left"
   elseif self.xVel > 0 then
      self.direction = "right"
   end
end

function Enemy:flipDirection()
   self.xVel = -self.xVel
end

function Enemy:animate(dt)
   self.animation.timer = self.animation.timer + dt
   if self.animation.timer > self.animation.rate then
      self.animation.timer = 0
      self:setNewFrame()
   end
end

function Enemy:setNewFrame()

   local anim = self.animation[self.state]
   if anim.current < anim.total then
      anim.current = anim.current + 1
   else

     anim.current = 1
   end
   self.animation.draw = anim.img[anim.current]
end

function Enemy:syncPhysics()
   if self.physics.body:isDestroyed() == true or self.health == 0 then return end
   self.x, self.y = self.physics.body:getPosition()
   --self.physics.body:setLinearVelocity(0, 100)
  -- print(Player.direction,self.direction)

end

function Enemy:shoot(targetx,targety)
   if self.shotClock == nil then self.shotClock = os.time() end
   if os.time() > self.shotClock + math.random(0.1,0.2) then
      self.shotClock = os.time()
      x,y = self.physics.body:getPosition()
      targetx,targety = Player.physics.body:getPosition()
      newbull = enemyBullet.new(x,y,targetx,targety,self.direction,4,enemy)
   end


end


function Enemy:computeAI()
   if Player.x > self.x then
    --  print("can  we get much higher")
            self.direction = "right"
      self.xVel = 1
   elseif  Player.x  < self.x then
            self.direction = "left"
      self.xVel = -1
    --  print("so high")
   end

   if love.physics.getDistance(self.physics.fixture, Player.physics.fixture) < 166 then
      self.state = "idle"
      self.physics.body:setLinearVelocity(0, 100)
      self:shoot()
   else
      self.state = "run"
      self.physics.body:setLinearVelocity(1 * self.speedMod, 100)
   end

end

function Enemy:draw()
   local scaleX = 1
   if self.xVel < 0 then
      scaleX = -1
   end
   love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r, scaleX, 1, self.width / 2, self.height / 2)
end

function Enemy.updateAll(dt)
   for i,instance in ipairs(ActiveEnemies) do
      instance:update(dt)
   end
end

function Enemy.drawAll()
   for i,instance in ipairs(ActiveEnemies) do
      instance:draw()
   end
end

function Enemy.beginContact(a, b, collision)
   for i,instance in ipairs(ActiveEnemies) do
      if a == instance.physics.fixture or b == instance.physics.fixture then
         if a == Player.physics.fixture or b == Player.physics.fixture then
            Player:takeDamage(instance.damage)
         end
         instance:flipDirection()
      end
   end
end

function Enemy.returnActive()
   return ActiveEnemies
end
return Enemy
