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
	self.ball.dy = math.random(-50, 60)

	--init the ball in the center
	self.ball.x = VIRTUAL_WIDTH / 2 - 4
	self.ball.y = VIRTUAL_HEIGHT - 42

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

		
		gSounds.paddleHit:play()
	end

	--collision for all bricks with regard to the ball
	for k, brick in pairs(self.bricks) do

		--only care about collision for bricks in play
		if brick.inPlay and self.ball:collides(brick) then

			--trigger a collision
			brick:hit()
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