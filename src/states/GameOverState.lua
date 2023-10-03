--[[
	The state shown to the player when all health is lost and the game is over.

	It should transition into an enter high score state should the conditions be met to do so.

	If not, it returns to the menu.
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:enter( params )
	self.score = params.score
end

function GameOverState:update( dt )
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('start')
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function GameOverState:render(  )
	love.graphics.setFont(gFonts.large)
	love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(gFonts.medium)
	love.graphics.printf('Final Score: '..tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(gFonts.small)
	love.graphics.printf('Press Enter to Play Again', 0, VIRTUAL_HEIGHT * 3 / 4, VIRTUAL_WIDTH, 'center')
end