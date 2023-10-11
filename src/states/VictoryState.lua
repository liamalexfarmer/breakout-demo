--[[
	Gamestate for victory of a Breakout level before transitioning into
	the next level. Edited version of Serve State but with incrementing levels.
]]

VictoryState = Class{__includes = BaseState}

function VictoryState:enter( params )
	self.paddle = params.paddle
	self.ball = params.ball
	self.health = params.health
	self.score = params.score
	self.level = params.level
	self.highScores = params.highScores
	self.recoverPoints = params.recoverPoints
end

function VictoryState:update( dt )
	self.paddle:update(dt)

	self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
	self.ball.y = self.paddle.y - 8

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('serve', {
			level = self.level + 1,
			bricks = LevelMaker.createMap(self.level + 1),
			paddle = self.paddle,
			health = self.health,
			score = self.score,
			highScores = self.highScores,
			recoverPoints = self.recoverPoints
		})
	end
end

function VictoryState:render(  )
	self.paddle:render()
	self.ball:render()

	renderHealth(self.health)
	renderScore(self.score)

	love.graphics.setFont(gFonts.large)
	love.graphics.printf("Level: "..tostring(self.level).." complete!", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(gFonts.medium)
	love.graphics.printf("Press Enter to Advance", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end