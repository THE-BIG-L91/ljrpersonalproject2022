love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("player")
local Coin = require("coin")
local GUI = require("gui")
local Camera = require("camera")
local Enemy = require("enemy")
local Map = require("map")
local Bullet = require("bullet")
local enemyBullet = require("enemyBullet")

function love.load()
	Enemy.loadAssets()
	Map:load()
	background = love.graphics.newImage("assets/background.png")
	GUI:load()
	Player:load()
end

local activeEnemies = {}

function love.update(dt)
	activeEnemies = Enemy.returnActive()
	World:update(dt)
	Player:update(dt)
	Coin.updateAll(dt)
	Enemy.updateAll(dt)
	Bullet.updateAll(dt,activeEnemies)
	enemyBullet.updateAll(dt)
	GUI:update(dt)
	Camera:setPosition(Player.x, 0)
	Map:update(dt)
end

function love.draw()
	love.graphics.draw(background)
	Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

	Camera:apply()
	Player:draw()
	Enemy.drawAll()
	Coin.drawAll()
	Bullet.drawAll(activeEnemies)
	enemyBullet.drawAll()

	Camera:clear()
	GUI:draw()

end

function love.keypressed(key)
	Player:jump(key)
end

function beginContact(a, b, collision)
	if Coin.beginContact(a, b, collision) then return end
	Enemy.beginContact(a, b, collision)
	Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
	Player:endContact(a, b, collision)
end
