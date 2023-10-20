--[[
Serve State Class enables the game to revert to a point where the ball is reset to the starting point
either to initiate play for the first time, following a level change, or following a health loss.
]]

ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
	--use params to define the current game state
	self.paddle = params.paddle
	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.level = params.level
	self.highScores = params.highScores
	self.recoverPoints = params.recoverPoints

	--generate a new ball
	self.ball = Ball()
	self.ball.skin = math.random(7) ~= 6 and self.ball.skin or 7
	--reserving the gray ball for powerups
	--pause
end


function ServeState:update(dt)
	-- have the ball move with the paddle
	self.paddle:update(dt)
	self.ball.x = self.paddle.x + (self.paddle.width / 2) -4
	self.ball.y = self.paddle.y - 8

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		-- store relevant variables in a table to pass the parameters on to the next state
		gStateMachine:change('play', {
			paddle = self.paddle,
			bricks = self.bricks,
			health = self.health,
			score = self.score,
			ball = self.ball,
			level = self.level,
			highScores = self.highScores,
			recoverPoints = self.recoverPoints
		})
	end

	for k, brick in pairs(self.bricks) do
		brick:update(dt)
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

end

function ServeState:render()
	-- render relevant gfx; similar for most states
	self.paddle:render()
	self.ball:render()

	for k, brick in pairs(self.bricks) do
		brick:render()
	end

	--added particle rendering for bricks to keep them from freezing during a transition
	for k, bricks in pairs(self.bricks) do
		bricks:renderParticles()
	end

	renderScore(self.score)
	renderHealth(self.health)

	love.graphics.setFont(gFonts.medium)
	love.graphics.printf('Press Enter to Serve', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end

