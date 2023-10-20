--[[
	Class used to represent and define powerups in the game. These powerups include:
	1. Double-Ball Bonus
	2. Triple-Ball Bonus
	3. Full Heal
]]

PowerUps = Class{}

local powerDice = {
	1,
	1,
	1,
	1,
	1,
	1,
	2,
	2,
	2,
	2,
	3,
	3
}

function PowerUps:init(x, y, type)
	self.x = x
	self.y = y
	self.width = 16
	self.height = 16

	self.dx = 0
	self.dy = 60

	self.type = type
	self.live = true

		--defining the reference image used for the particle system; second number is the max simultaneous amount
	self.pwrSystem = love.graphics.newParticleSystem(gTextures.particle, 64)

	--min/max of particle lifetime in seconds
	self.pwrSystem:setParticleLifetime(.25, 0.5)

	--x and y acceleration ranges (xmin, ymin, xmax, ymax)
	self.pwrSystem:setLinearAcceleration(-750, -1000, 750, -750)

	--particle emission behavior
	self.pwrSystem:setEmissionArea('normal', 0, 0, math.pi, true)

	self.pwrSystem:setColors(1, 215/255, 0, 0.1)

end

function PowerUps:collides(target)
	--[[
		Collision logic that will most likely only be used in conjunction with the paddle.
		Based on ball's collision detection behavior.
	]]
	if self.x > target.x + target.width or target.x > self.x + self.width then
		return false
	end
	--[[exact same concept as above but on the y axis]]
	if self.y > target.y + target.height or target.y > self.y + self.height / 2 then
		return false
	end
	--return true if the above conditions are not met
	return true

end

function PowerUps:spawn( powers )

		
	p = PowerUps(math.random(VIRTUAL_WIDTH / 8, 7 * VIRTUAL_WIDTH / 8), 0, powerDice[math.random(1, 12)])

	table.insert(powers, p)

	return powers
end

function PowerUps:rain( powers, score )
	local powerCounter = 0
	local powerAmt = math.min(math.floor(score / BASE_RECOVERY), 5)
	while powerCounter < powerAmt do
		PowerUps:spawn(powers)
		powerCounter = powerCounter + 1
	end
end

function PowerUps:keySpawn( powers, brick )

	p = PowerUps(brick.x + brick.width / 2, brick.y + brick.height / 2, 10)

	table.insert(powers, p)

	return powers
end


function PowerUps:update( dt )
	self.y = self.y + self.dy * dt

	self.pwrSystem:update(dt)
end

function PowerUps:render(  )
	if self.live then
		love.graphics.draw(gTextures.main, gFrames.power[self.type], self.x, self.y)
	end
end


function PowerUps:renderParticles( type )
	if type < 3 then		
		love.graphics.draw(self.pwrSystem, self.x + 8, math.min(self.y + 8, VIRTUAL_HEIGHT - 32))
	elseif type == 3 then
		love.graphics.draw(self.pwrSystem, VIRTUAL_WIDTH - 83, 4)
	elseif type == 10 then
		love.graphics.draw(self.pwrSystem, self.x + 8, math.min(self.y + 8, VIRTUAL_HEIGHT - 32))
	else

	end
end

function PowerUps:emit(number, type)
	if type < 3 then
		--particle emission behavior
		
		self.pwrSystem:setLinearAcceleration(-750, -1000, 750, -750)
		self.pwrSystem:setEmissionArea('normal', 0, 0, math.pi, true)
		self.pwrSystem:setColors(1, 215/255, 0, 0.1)
		self.pwrSystem:emit(number)

	elseif type == 3 then
		self.pwrSystem:setSpinVariation(1)
		self.pwrSystem:setLinearAcceleration(-750, 750, 750, 1000)
		self.pwrSystem:setEmissionArea('normal', 4, 0, 0, true)
		self.pwrSystem:setColors(220/255, 20/255, 60/225, 0.1)
		self.pwrSystem:emit(number)
		self.pwrSystem:setSpinVariation(0)

	elseif type == 10 then
		self.pwrSystem:setLinearAcceleration(-750, -1000, 750, -750)
		self.pwrSystem:setEmissionArea('normal', 8, 8, 0, false)
		self.pwrSystem:setColors(1, 215/255, 0, 0.1)
		self.pwrSystem:emit(number)
	else

	end
end