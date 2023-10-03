--[[
	Functions to create bricks that define different levels in Breakout.
	The ball can collide with them, deflecting away, and we can assign seperate point values to different bricks.
	If they are all destroyed, the player should advance a level which should create a new layout of bricks.
]]

Brick = Class{}

function Brick:init(x, y)
	--variables for point values and coloration
	self.tier = 0
	self.color = 1

	self.x = x
	self.y = y

	self.width = 32
	self.height = 16

	--variable that answers the question: should this brick be rendered?
	self.inPlay = true

end


--function used to define a hit on the brick by the ball
--removes it if destroyed or changes is color if not

function Brick:hit()
	--sound for it being hit
	gSounds.brickHit1:play()

	self.inPlay = false
end

function Brick:render()

	if self.inPlay then
		love.graphics.draw(gTextures.main,
			--color offset
			gFrames.bricks[1 + ((self.color - 1) * 4) + self.tier], self.x, self.y)
	end
end

