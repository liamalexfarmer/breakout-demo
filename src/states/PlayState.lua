--[[
Used to define the state of the game where active play is occuring.

The player controls the paddle, using it to deflect the ball back towards the bricks in order to destroy them.

Player loses health if the ball passes behind the paddle, loses if their health reaches zero, and wins when they clear all the bricks.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.paddle = Paddle()
	self.paused = false
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

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

end

function PlayState:render()

	self.paddle:render()

	if self.paused then
		love.graphics.setFont(gFonts.large)
		love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end