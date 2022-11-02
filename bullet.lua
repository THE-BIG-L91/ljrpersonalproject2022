local bullet = {}
bullet.__index = bullet

local bullet_img = love.graphics.newImage("assets/bullet.png")

local activeBullets = {}
function bullet.removeAll()
   for i,v in ipairs(activeBullets) do
   	  activeBullets[i] = nil
   end

   activeBullets = {}
end

function bullet:remove(i)
		print(#activeBullets)

	table.remove(activeBullets, i) 
	collectgarbage("collect")
end

function bullet:checkColl()

end

function bullet:fire()
	local bulletSound = love.audio.newSource("assets/sfx/gunshot.wav", "static")
	bulletSound:play()
end

function colMulti(x1, y1, w1, h1,  x2, y2, w2, h2)

    return  (x2 <= x1 + w1) and (y2 <= y1 + h1) and (x2 + w2 >= x1) and (y2 + h2 >= y1)

end 


function bullet.updateAll(dt,activeEnemies)

	for i,v in pairs (activeBullets) do
		if v.dir == "right" then
			v.x = v.x + dt*300
		elseif v.dir == "left" then
			v.x = v.x - dt*300
		end
	end
	for i,v in pairs (activeBullets) do
		for itr,enemy in pairs (activeEnemies) do
			if enemy.physics.body:isDestroyed() ~= true and v ~= nil then
			x,y = enemy.physics.body:getPosition()

			if colMulti(x,y-16,enemy.width,enemy.height,v.x,v.y,4,4) then
				enemy:dmg(1)
				v:remove(i)
			end
		end
		if os.time() >  v.creationTime + 1 then 
			table.remove(activeBullets, v.index)
			v:remove() 
			print("removed") 
			return 
		end
	end
		--HORRIFICALLY inefficient

	end

end


function bullet:draw()
	if self == nil then return end
	love.graphics.draw(bullet_img, self.x,self.y,0)
end



index = 0
function bullet.new(x,y,dir,time,allegiance)
   local instance = setmetatable({}, bullet)

   instance.x =  x
   instance.y = y
   instance.dir = dir
   instance.deleteTime = time
   instance.allegiance = allegiance
   instance.creationTime = os.time()
   index = index + 1
   instance.index = index
	table.insert(activeBullets,instance)
	instance:fire()
   return instance
end

function bullet.drawAll(activeEnemies)
    for i,instance in ipairs(activeBullets) do
       instance:draw()
    end
end


return bullet