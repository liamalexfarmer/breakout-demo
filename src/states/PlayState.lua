--[[
Used to define the state of the game where active play is occuring.

The player controls the paddle, using it to deflect the ball back towards the bricks in order to destroy them.

Player loses health if the ball passes behind the paddle, loses if their health reaches zero, and wins when they clear all the bricks.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.paddle = Paddle()

	--initialize the ball with a random skin option
	self.ball = Ball(math.random(7))

	--starting velocity for the ball
	self.ball.dx = math.random(-200, 200)
	self.ball.dy = math.random(-60, -40)
	--this is to impliment conservation of momentum later on, so when dx or dy are manipulated, their collective speed remains constant
	--unless of course we want it to conitnue to accelerate
	self.ball.m = math.abs(self.ball.dx) + math.abs(self.ball.dy)

	--init the ball in the center
	self.ball.x = VIRTUAL_WIDTH / 2 - 4
	self.ball.y = VIRTUAL_HEIGHT - 60

	--establishing the pause state as false until otherwise instantiated
	self.paused = false

	--map creation function
	self.bricks = LevelMaker.createMap()
end

function PlayState:update(dt)

	--implimenting pause feature and placing it ahead of all other updates
	if self.paused then
		if love.keyboard.wasPressed('space') then
			self.paused = false
			gSounds.pause:play()
		else
			return
		end
	elseif love.keyboard.wasPressed('space') then
		self.paused = true
		gSounds.pause:play()
		return
	end

	self.paddle:update(dt)
	self.ball:update(dt)

	if self.ball:collides(self.paddle) then
		--reset y position to make a collision FALSE (addressed in wall collision code comments more deeply)
		self.ball.y = self.paddle.y - 8
		--reverse y direction
		self.ball.dy = -self.ball.dy

		--implimentation of code that changes the x velocity of the ball depending on where on the paddle it's hit
		--allows strategy of intent on behalf of the player

		--if the ball is on the left side of the paddle and the paddle is moving left
		if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
			self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

--[[conserving momentum by recalculating dy; remove square brackets to enable
			self.ball.dy = 
			--returns 1 or -1 depending on direction of dy. purely to provide polarity
			(self.ball.dy/math.abs(self.ball.dy))
			--ball.dm is designed not to care about directionality, so we're basically subtracting the new dx from the previous collective speed
			--multiplied by the defined polarity by leveraging absolute value of ball.dy
			 * (self.ball.m - math.abs(self.ball.dx))
			--recalculate ball.m for future usage
			self.ball.m = (math.abs(self.ball.dx) + math.abs(self.ball.dy)) * 1.03
]]

		elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
			self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
			--self.ball.dy = (self.ball.dy / math.abs(self.ball.dy)) * (self.ball.m - math.abs(self.ball.dx))
			--self.ball.m = (math.abs(self.ball.dx) + math.abs(self.ball.dy)) * 1.03
		end

		gSounds.paddleHit:play()
	end

	--collision for all bricks with regard to the ball
	for k, brick in pairs(self.bricks) do

		--only care about collision for bricks in play
		if brick.inPlay and self.ball:collides(brick) then

			--trigger a collision
			brick:hit()

			--code that handles brick collisions
			--uses velocity as a check for whether collision could/may occur on a specific brick edge
			--defining the brick edge where collision occurs is necessary for determining the reflection pattern of the ball

			if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x - self.ball.width

			elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
				self.ball.dx = self.ball.dx
				self.ball.x = brick.x + brick.width

			elseif self.ball.y < brick.y then

				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y - 8
			else

				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y + 16
			end

			--make the ball go slightly faster
			self.ball.dy = self.ball.dy * 1.01
			self.ball.dx = self.ball.dx * 1.01

			--collide with one brick only (helps with corners)
			break
		end
	end


	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

end

function PlayState:render()

	for k, bricks in pairs(self.bricks) do
		bricks:render()
	end

	self.paddle:render()
	self.ball:render()

	if self.paused then
		love.graphics.setFont(gFonts.large)
		love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end