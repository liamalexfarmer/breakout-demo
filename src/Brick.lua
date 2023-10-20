--[[
	Functions to create bricks that define different levels in Breakout.
	The ball can collide with them, deflecting away, and we can assign seperate point values to different bricks.
	If they are all destroyed, the player should advance a level which should create a new layout of bricks.
]]

Brick = Class{}

paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    },
    [6] = {
    	['r'] = 105,
    	['g'] = 105,
    	['b'] = 105
    }
}


function Brick:init(x, y)
	--variables for point values and coloration
	self.tier = 0
	self.color = 1

	self.x = x
	self.y = y

	self.width = 32
	self.height = 16

	--variable that answers the question: should this brick be rendered?
	self.inPlay = true

	--defining the reference image used for the particle system; second number is the max simultaneous amount
	self.pSystem = love.graphics.newParticleSystem(gTextures.particle, 64)

	--min/max of particle lifetime in seconds
	self.pSystem:setParticleLifetime(1, 1)

	--x and y acceleration ranges (xmin, ymin, xmax, ymax)
	self.pSystem:setLinearAcceleration(-15, 0, 15, 160)

	--particle emission behavior
	self.pSystem:setEmissionArea('normal', 10, 10)

	--used for lock and key function
	self.locked = false
	self.key = false
end

--function used to define a hit on the brick by the ball
--removes it if destroyed or changes is color if not

function Brick:hit()

	self.pSystem:setColors(
		paletteColors[self.color].r / 255,
		paletteColors[self.color].g / 255,
		paletteColors[self.color].b / 255,
		55 * (self.tier + 1) / 255,
		paletteColors[self.color].r / 255,
		paletteColors[self.color].g / 255,
		paletteColors[self.color].b / 255,
		0
	)


	self.pSystem:emit(64)

	--sound for it being hit
	gSounds.brickHit1:stop()
	gSounds.brickHit1:play()

	if self.tier > 0 then
		if self.color == 1 then
			self.tier = self.tier - 1
			self.color = 5
		elseif self.color == 6 then
			if self.tier == 0 then
				self.color = self.color - 1
			end
		else
			self.color = self.color - 1
		end
	else
		if self.color == 1 then
			self.inPlay = false
		else
			self.color = self.color - 1
		end
	end

	if not self.inPlay then 
		gSounds.brickHit2:stop()
		gSounds.brickHit2:play()
	end
end

function Brick:update(dt)
	self.pSystem:update(dt)
end


function Brick:render()

	if self.inPlay then
		love.graphics.draw(gTextures.main,
			--color offset
			gFrames.bricks[1 + ((self.color - 1) * 4) + self.tier], self.x, self.y)
	end
end

function Brick:renderParticles( )		
	love.graphics.draw(self.pSystem, self.x + 16, self.y + 8)
end


--function searches through the table of bricks and determines whether there is a locked brick
--used to prevent key powerups from bricks containing them if there is no key brick to unlock
function Brick:containsLock( table )
	local i = 1
	local contains = false
	local brickAmt = #table
	repeat
		if (table[i].locked == true) then 
			contains = true
		end

		i = i + 1

	until i == brickAmt

	return contains
end