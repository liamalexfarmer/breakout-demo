--[[
Used to define the state of the game where active play is occuring.

The player controls the paddle, using it to deflect the ball back towards the bricks in order to destroy them.

Player loses health if the ball passes behind the paddle, loses if their health reaches zero, and wins when they clear all the bricks.
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
	self.paddle = params.paddle
	self.ball = params.ball
	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.level = params.level
	self.highScores = params.highScores

	self.paused = false

	--starting velocity for the ball
	self.ball.dx = math.random(-200, 200)
	self.ball.dy = math.random(-60, -50)
	--this is to impliment conservation of momentum later on, so when dx or dy are manipulated, their collective speed remains constant
	--unless of course we want it to conitnue to accelerate
	self.ball.m = math.abs(self.ball.dx) + math.abs(self.ball.dy)
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

												--[[trying to prevent wonky ball snapping when the corner is hit, doesn't work tho
		if self.paddle.y > self.ball.y + 8 then

			if self.ball.dx > 0 and self.ball.x + 8 >= self.paddle.x and self.paddle.dx < 0 then
				self.ball.x = self.paddle.x - 9
			end

			if self.ball.dx < 0 and self.ball.x <= self.paddle.x + self.paddle.width and self.paddle.dx > 0 then
				self.ball.x = self.paddle.x + self.paddle.width + 1
			end
		end
													]]

		self.ball.y = self.paddle.y - 8

		--reverse y direction
		self.ball.dy = -self.ball.dy

		--implimentation of code that changes the x velocity of the ball depending on where on the paddle it's hit
		--allows strategy of intent on behalf of the player

		--if the ball is on the left side of the paddle and the paddle is moving left
		if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
			self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

		--if the ball is on the right side and paddle moving right
		elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
			self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
		end

		gSounds.paddleHit:play()
	end

	--collision for all bricks with regard to the ball
	for k, brick in pairs(self.bricks) do

		--only care about collision for bricks in play
		if brick.inPlay and self.ball:collides(brick) then

			--add to your score
			self.score = self.score + (brick.tier * 200 + brick.color * 25)

			--trigger a collision
			brick:hit()

			if self:checkVictory() then
				gSounds.victory:play()

				gStateMachine:change('victory', {
				paddle = self.paddle,
				ball = self.ball,
				health = self.health,
				score = self.score,
				level = self.level,
				highScores = self.highScores
				})
			end


			--code that handles brick collisions
			--uses velocity as a check for whether collision could/may occur on a specific brick edge
			--defining the brick edge where collision occurs is necessary for determining the reflection pattern of the ball

			if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x - 8

			elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then

				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x + brick.width

			elseif self.ball.y < brick.y and self.ball.dy > 0 then

				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y - 8

			else

				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y + 16

			end

			--make the ball go slightly faster
			self.ball.dy = self.ball.dy * 1.02
			self.ball.dx = self.ball.dx * 1.01

			--collide with one brick only (helps with corners)
			break
		end
	end

	if self.ball.y >= VIRTUAL_HEIGHT then
		self.health = self.health - 1
		gSounds.hurt:play()

		if self.health == 0 then
			gStateMachine:change('gameOver', {
				score = self.score,
				highScores = self.highScores
			})
		else
			gStateMachine:change('serve', {
				paddle = self.paddle,
				bricks = self.bricks,
				health = self.health,
				score = self.score,
				level = self.level,
				highScores = self.highScores
			})
		end
	end

	--for updating rendered particle systems--doesn't animate without this
	for k, brick in pairs(self.bricks) do
		brick:update(dt)
	end


	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

end

function PlayState:render()

	for k, bricks in pairs(self.bricks) do
		bricks:render()
	end

	for k, bricks in pairs(self.bricks) do
		bricks:renderParticles()
	end

	self.paddle:render()
	self.ball:render()

	renderScore(self.score)
	renderHealth(self.health)

	if self.paused then
		love.graphics.setFont(gFonts.large)
		love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end

function PlayState:checkVictory()
	for k, brick in pairs(self.bricks) do
		if brick.inPlay then
			return false
		end
	end

	return true
end
