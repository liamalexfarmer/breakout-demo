--[[
Code to define the paddle used to represent the player in Breakout.

It can move left and right, as well as deflect the ball back towards the brick.

If the ball passes the paddle, the player loses one heart.

Skindsfor the paddle will be available for the player can choose before playing.
]]

Paddle = Class{}

function Paddle:init(skin)
	self.skin = skin

	self.size = 2

	self.width = self.size * 32

	self.height = 16

	--places the paddle in the middle of the screen depending on it's size
	self.x = (VIRTUAL_WIDTH / 2) - (16 * self.size)
	--places the paddle slightly above the bottom of the screen
	self.y = VIRTUAL_HEIGHT - 32

	--no starting velocity
	self.dx = 0
end


function Paddle:update(dt)
	--keyboard controls
	if love.keyboard.isDown('left') then
		self.dx = -PADDLE_SPEED
	elseif love.keyboard.isDown('right') then
		self.dx = PADDLE_SPEED
	else
		self.dx = 0
	end

	if self.dx < 0 then
		self.x = math.max(0, self.x + self.dx * dt)
	else
		self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
	end
end

--render the paddle in it's calculated position, using the correct quad based on skin selection and size
function Paddle:render()
	love.graphics.draw(gTextures.main, gFrames.paddles[self.size + ( 4 * (self.skin - 1) ) ], self.x, self.y)
end



