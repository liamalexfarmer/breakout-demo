--[[
	State used to select the color of your paddle for this Breakout game.
	Utilizes saved data--first time implementation.
]]

PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter( params )
	self.highScores = params.highScores
end

function PaddleSelectState:init(  )
	self.currentPaddle = 1
end

function PaddleSelectState:update( dt )
	if love.keyboard.wasPressed('left') then
		if self.currentPaddle == 1 then
			gSounds.noSelect:play()
		else
			gSounds.select:play()
			self.currentPaddle = self.currentPaddle - 1
		end

	elseif love.keyboard.wasPressed('right') then
		if self.currentPaddle == 4 then
			gSounds.noSelect:play()
		else
			gSounds.select:play()
			self.currentPaddle = self.currentPaddle + 1
		end
	end

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gSounds.confirm:play()

		gStateMachine:change('serve', {
			paddle = Paddle(self.currentPaddle),
			bricks = LevelMaker.createMap(32),
			health = 3,
			score = 0,
			highScores = self.highScores,
			level = 1,
			recoverPoints = BASE_RECOVERY
		})
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PaddleSelectState:render(  )
	love.graphics.setFont(gFonts.medium)
	love.graphics.printf("Select Your Paddle by Moving Left or Right", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(gFonts.small)
	love.graphics.printf("Press Enter to Start", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

	--left arrow, which is given a gray hue if no paddles are "left"
	if self.currentPaddle == 1 then
		love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
	end

	--draw an arrow on the left side
	love.graphics.draw(gTextures.arrows, gFrames.arrows[1], VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

	--reset the color
	love.graphics.setColor(1, 1, 1, 1)

	--right arrow, which is given a gray hue if no paddles are "right"
	if self.currentPaddle == 4 then
		love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
	end

	love.graphics.draw(gTextures.arrows, gFrames.arrows[2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

		--reset the color
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.draw(gTextures.main, gFrames.paddles[2 + 4 * (self.currentPaddle - 1)], VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

end