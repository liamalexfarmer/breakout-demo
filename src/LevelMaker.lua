--[[

LevelMaker Class

Creates levels for the Breakout Game.

In this case, levels are created randomly, scaling with the difficulty level of the game.

]]

LevelMaker = Class{}

--[[
First a table of bricks must be defined and returned into the game,
with different possibilities for randomizing rows and columns of bricks.

Chooses colors and tier based on the difficulty level achieved so far.
]]

function LevelMaker.createMap(level)

	local bricks = {}

	--choose a random number of rows
	local numRows = math.random(1,5)

	--choose a random number of columns
	local numCols = math.random(7, 13)

	--how to lay out the bricks to fill the space and not overlap
	for y = 1, numRows do
		for x = 1, numCols do
			b = Brick(
				--x coord
				(x-1) * 32             --for each brick after one we need to add 32 (brick.width), returns 0 for the first field of the table 
				+ 8                    --screen can fit 13 cols + 16 pixel padding, so this is the left side padding
				+ (13 - numCols) * 16, --additional padding for fewer columns; for each one less than 13(max) we add 16 (half brick width)

				--y coord, simply creating a new row brick.height below, or in the case of the first row, 
				--a brick.height amount of padding from the top of the screen
				y * 16
				)

			table.insert(bricks, b)

		end

	end

	return bricks

end