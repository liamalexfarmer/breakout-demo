--[[Uses a spritesheet (atlas) as well as denominations for the width and height 
of the 'tiles' in the spritesheet in order to divide it evenly into quads
]]

function GenerateQuads(atlas, tilewidth, tileheight)
	local sheetWidth = atlas:getWidth() / tilewidth
	local sheetHeight = atlas:getHeight() / tileheight

	local sheetCounter = 1 
	local spritesheet = {}

	for y = 0, sheetHeight - 1 do
		for x = 0, sheetWidth - 1 do
			spritesheet[sheetCounter] =
				love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
			sheetCounter = sheetCounter + 1
		end
	end

	return spritesheet

end

--[[
    Utility function for slicing tables, a la Python.

    https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice

    visiting this thread there may be syntax sugar for this:

for key, value in pairs({table.unpack({1, 2, 3, 4, 5}, 2, 4)}) do
    print(key, value)
end

returns:

1   2
2   3
3   4

so theoretically this function could be replaced by:

for key, value in pairs(table.unpack(tbl, first key, last key))

maybe I will test this later
]]

function table.slice(tbl, first, last, step)
	local sliced = {}

	for i = first or 1, last or #tbl, step or 1 do
		sliced[#sliced + 1] = tbl[i]
	end

	return sliced
end

--[[
    We have to piece out the paddles a little differently since they are all variable sizes,
    so this function has to be seperate from the one above.
]]

function GenerateQuadsPaddles(atlas)
	--coordinates of the first section of paddles on the sprite sheet
	local x = 0
	local y = 64

	local counter = 1
	local quads = {}

	for i = 0, 3 do
		--smallest paddle
		quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
		counter = counter + 1

		--medium paddle
		quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
		counter = counter + 1

		--large paddle
		quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
		counter = counter + 1

		--needlessly large paddle
		quads[counter] = love.graphics.newQuad(x, y, 128, 16, atlas:getDimensions())
		counter = counter + 1


		--reset x to the left side of the sprite sheet and y to the next row of paddles to repeat the process
		x = 0

		y = y + 32
	end

	return quads
end

--[[
	Generating quads for the different skins the player can choose for the ball.
	There are two rows at starting at 96, 48, but the first row has four options and the second only three,
	So there must be two seperate for loops to account for them all.
]]

function GenerateQuadsBall(atlas)
	local x = 96
	local y = 48

	local counter = 1
	local quads = {}

	for i = 0, 3 do
		quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
		x = x + 8
		counter = counter + 1
	end

	x = 96
	y = 56

	for i = 0, 2 do
		quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
		x = x + 8
		counter = counter + 1
	end

	return quads

end



