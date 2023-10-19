--[[
	Governing functions for the Breakout ball.

	It should bounce off of the walls, player's paddle, and the bricks you destroy as a condition of victory.

	The ball has multiple skin possibilities chosen at random for the sake of variety.
]]

Ball = Class{}

function Ball:init(skin)
	--ball dimensions
	self.width = 8
	self.height = 8

	--variables that govern the x and y axis velocities
	self.dx = 0
	self.dy = 0

	self.skin = skin

	self.live = true

	if skin == 6 then
		self.main = false
	else
		self.main = true
	end

end


--[[
	Defining the conditions that satisfy collision, as well as what happens in response.
	Function expects some defined graphic or bounding box to check against the position of the ball.
]]

function Ball:collides(target)
	--[[
	is the balls x position greater than the target's x position plus it's width 
	or is the targets x position greater than the balls x position plus it's width
	Put Simply: is the ball's x position further to the right than the target's x position plus it's width OR
	Is the target's x position greater than the ball's x position plus it's width
	If so, it's NOT colliding.
	]]
	if self.x > target.x + target.width or target.x > self.x + self.width then
		return false
	end
	--[[exact same concept as above but on the y axis]]
	if self.y > target.y + target.height or target.y > self.y + self.height then
		return false
	end

	--return true if the above conditions are not met
	return true

end

--[[
	Function to reset the ball, whether new game or point conceded.
]]

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 4 
	self.y = VIRTUAL_HEIGHT / 2 - 4

	self.dx = 0
	self.dy = 0
end

--[[
	Definintions for how the ball behaves as time passes in the game, and in reaction to occurences such as collisions.
	Notes for myself:
	Usually while loops have crashed for me in the past, but using a for loop here either crashed the game or spawned 1 ball.
	Wasted a lot of time trying to pass the table back and forth to iterate over it like I did for the powerups.
	Rather than doing tabl = Ball:spawn(tabl, x, y amt) which crashed the game, the solution was so much simpler in just
	that triggering the Ball:spawn function is sufficient so long as I do the table iterations in that function.
	Might indicate that I can simplify the power-up spawns as well.
]]

function Ball:spawn( tabl, x, y, amt )
		count = amt
		while count > 0 do
			b = Ball(6)
			b.x = x
			b.y = y - b.height
			b.dx = math.random(-200, 200)
			b.dy = -100
			table.insert(tabl, b)
			count = count - 1
		end
end

function Ball:update(dt)
	--accounting for the movement of the ball as a function of velocity over time
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt


	--[[
		ball bouncing off of the left wall/side of the screen
		this self.x = 0 concept below is critical as it resets the position of the ball to the edge of the screen but with reversed x velocity,
		making sure that on the next frame the statement: if self.x <= 0 is FALSE.
		Without it, the ball could get stuck in a loop because the reversed x velocity might not move the ball far enough such that that 
		by the next frame self.x <= 0 becomes false, so it gets stuck reversing the dx value and the ball effectively rattles in place.
	]]--

	if self.x <= 0 then

		self.x = 0

		self.dx = -self.dx
		gSounds.wallHit:play()
	end

	if self.x >= VIRTUAL_WIDTH - 8 then

		self.x = VIRTUAL_WIDTH - 8
		self.dx = -self.dx

		gSounds.wallHit:play()

	end

	if self.y <= 0 then

		self.y = 0
		self.dy = -self.dy

		gSounds.wallHit:play()
	end

end

function Ball:render()
	--gTextures is the table of the available sprite sheets
	--gFrames is the table that contains quad derivative functions
	love.graphics.draw(gTextures.main, gFrames.balls[self.skin], 
		self.x, self.y)
end




