--[[
Used to define the state of the game where active play is occuring.

The player controls the paddle, using it to deflect the ball back towards the bricks in order to destroy them.

Player loses health if the ball passes behind the paddle, loses if their health reaches zero, and wins when they clear all the bricks.
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
	self.paddle = params.paddle
	self.ball = {params.ball}
	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.level = params.level
	self.highScores = params.highScores
	self.recoverPoints = params.recoverPoints
	self.power = {}

	self.paused = false
	--self.live = true

	--starting velocity for the ball
	self.ball[1].dx = math.random(-200, 200)
	self.ball[1].dy = math.random(-60, -50)

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
	
	for k, balls in ipairs(self.ball) do
		balls:update(dt)
	end


	for k, balls in ipairs(self.ball) do
		if balls:collides(self.paddle) then
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

			balls.y = self.paddle.y - 8

			--reverse y direction
			balls.dy = -balls.dy

			--implimentation of code that changes the x velocity of the ball depending on where on the paddle it's hit
			--allows strategy of intent on behalf of the player

			--if the ball is on the left side of the paddle and the paddle is moving left
			if balls.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
				balls.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - balls.x))

			--if the ball is on the right side and paddle moving right
			elseif balls.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
				balls.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - balls.x))
			end

		gSounds.paddleHit:play()
		end
	end


	--collision for all bricks with regard to the ball
	for k, brick in pairs(self.bricks) do
		for v, balls in ipairs(self.ball) do
		--only care about collision for bricks in play
			if brick.inPlay and balls:collides(brick) then

				--add to your score
				if brick.locked == false then
					self.score = self.score + (brick.tier * 200 + brick.color * 25)
				end

				--trigger a collision
				brick:hit()

				if brick.key == true and brick.inPlay == false then
					if locked then
						PowerUps:keySpawn(self.power, brick)
					end
				end

				--if your score exeeds the recover points
				if self.score > self.recoverPoints then
					--set your health to the smaller value between 3 (max hp) and current hp + 1
					self.health = math.min(3, self.health + 1)

					--double the recovery point threshhold
					self.recoverPoints = BASE_RECOVERY * (1 + math.floor(self.score/BASE_RECOVERY))

					gSounds.recover:play()

					self.power = PowerUps:spawn(self.power)

					self.paddle.size = math.min(4, self.paddle.size + 1) 
				end

				if self:checkVictory() then
					gSounds.victory:play()

					gStateMachine:change('victory', {
					paddle = self.paddle,
					ball = self.ball[1],
					health = self.health,
					score = self.score,
					level = self.level,
					highScores = self.highScores,
					recoverPoints = self.recoverPoints
					})
				end


				--code that handles brick collisions
				--uses velocity as a check for whether collision could/may occur on a specific brick edge
				--defining the brick edge where collision occurs is necessary for determining the reflection pattern of the ball

				if balls.x + 2 < brick.x and balls.dx > 0 then
					balls.dx = -balls.dx
					balls.x = brick.x - 8

				elseif balls.x + 6 > brick.x + brick.width and balls.dx < 0 then

					balls.dx = -balls.dx
					balls.x = brick.x + brick.width

				elseif balls.y < brick.y and balls.dy > 0 then

					balls.dy = -balls.dy
					balls.y = brick.y - 8

				else

					balls.dy = -balls.dy
					balls.y = brick.y + 16

				end

				--make the ball go slightly faster
				balls.dy = balls.dy * 1.02
				balls.dx = balls.dx * 1.01

				--collide with one brick only (helps with corners)
				break
			end
		end
	end

	for i, balls in ipairs(self.ball) do
		if balls.y >= VIRTUAL_HEIGHT and i ~= 1 then
			table.remove(self.ball, i)
		elseif balls.y >= VIRTUAL_HEIGHT and i == 1 then
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
					highScores = self.highScores,
					recoverPoints = self.recoverPoints
				})
			end
		end
	end

	for v, powers in pairs(self.power) do
		--if any powers in the powers table collides with the paddle
		if powers:collides(self.paddle) then
			--type/skin 1 spawns 2 balls, type/skin 2 spawns 3 balls, type/skin 3 heals to full so
			--if type is less than 3
			powers:emit(32, powers.type)

			if powers.live then
				if powers.type < 3 then
					--spawn the correct amount of balls at a location based on the location of the powerup
					--Ball:spawn receives a table (self.ball), the x and y location of the powerup, and the amount of balls
					--it simply inserts a number of grey balls with random directionality at the point the powerup was
					Ball:spawn(self.ball, powers.x, powers.y, 1 + powers.type)

					gSounds.confirm:play()
					powers.live = false
					
				elseif powers.type == 3 then
					self.health = 3
					gSounds.recover:play()
					powers.live = false

				elseif powers.type == 10 then
					powers.live = false
					gSounds.select:play()
					--unlock the locked brick
					for k, bricks in pairs(self.bricks) do
						if bricks.locked then
							bricks.tier = bricks.tier - 1
							bricks.locked = false
							PowerUps:rain(self.power, self.score)
							self.score = self.score * 2
							locked = false
						end
					end
				else
					--table.remove(self.power, v)
					powers.live = false
				end
			end
		end
	end


	--for updating rendered particle systems--doesn't animate without this
	for k, brick in pairs(self.bricks) do
		brick:update(dt)
	end

	--if self.power then
		for k, powers in pairs(self.power) do
			powers:update(dt)

			if powers.y > (VIRTUAL_HEIGHT + powers.height) then
				powers.live = false
				--table.remove(self.power, k)
			end
		end
	--end


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

	for k, powers in pairs(self.power) do
		powers:renderParticles(powers.type)
	end

	self.paddle:render()

	for k, balls in ipairs(self.ball) do
		balls:render()
	end

	for k, powers in pairs(self.power) do
		powers:render()
	end




	renderScore(self.score)
	renderHealth(self.health)

	if self.paused then
		love.graphics.setFont(gFonts.large)
		love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end

function PlayState:checkVictory()
	for k, brick in pairs(self.bricks) do
		if brick.inPlay ~= brick.locked then
			return false
		end
	end

	return true
end
