--[[
	State used to display recorded high-scores achieved in-game.
	Utilizes saved data--first time implementation.
]]

HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter( params )
	self.highScores = params.highScores
end

function HighScoreState:update( dt )
	if love.keyboard.wasPressed('escape') then
		gSounds.wallHit:play()

		gStateMachine:change('start', {
			highScores = self.highScores
		})
	end
end

function HighScoreState:render(  )
	love.graphics.setFont(gFonts.large)
	love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(gFonts.medium)

	for i = 1, 10 do
		local name = self.highScores[i].name or '---'
		local score = self.highScores[i].score or '---'

		--the score number (1. 2. 3. etc)
		love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4, 60 + i * 13, 50, 'left')

		--name of scorer
		love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 60 + i * 13, 50, 'right')

		--the score itself
		love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2, 60 + i * 13, 100, 'right')
	end

	love.graphics.setFont(gFonts.small)
	love.graphics.printf("Press ESCAPE to return to the Main Menu", 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end