--[[

LevelMaker Class

Creates levels for the Breakout Game.

In this case, levels are created randomly, scaling with the difficulty level of the game.

]]

--patterns used to create different brick patterns
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

--patterns per row
SOLID = 1 					--all colors in the row are the same
ALTERNATE = 2 				--alternating colors
SKIP = 3 					--skip every other brick
NONE = 4 					--no bricks in this row

LevelMaker = Class{}

--[[
First a table of bricks must be defined and returned into the game,
with different possibilities for randomizing rows and columns of bricks.

Chooses colors and tier based on the difficulty level achieved so far.
]]


function LevelMaker.createMap(level)

	local bricks = {}

	--choose a random number of rows
	local numRows = level % 5 + 1

	--choose a random number of columns
	local numCols = 7 + (level - 1) % 5

	numCols = numCols % 2 == 0 and numCols + 1 or numCols

	--highest possible brick color; do not exceed 3
	local highestTier = math.floor(level / 5) % 5

	-- highest color of the highest tier
	local highestColor = math.min(1, 1 + level % 5)

	local keyFlag = true
	local keyBrick = nil

	local index = 1

	local locked = false


	--how to lay out the bricks to fill the space and not overlap
	for y = 1, numRows do

		--is skipping enabled for this row
		local skipPattern = math.random(1, 2) == 1 and true or false

		--is alternating colors enabled
		local alternatePattern = math.random(1, 2) == 1 and true or false

		--choosing two colors to alternate
		local alternateColor1 = math.random(1, highestColor)
		local alternateColor2 = math.random(1, highestColor)

		local alternateTier1 = math.random(0, highestTier)
		local alternateTier2 = math.random(1, highestTier)

		--used to skip a block for a skip patterns
		local skipFlag = math.random(2) == 1 and true or false

		--used to alternate a block for an alternate pattern
		local alternateFlag = math.random(2) == 1 and true or false

		--solid color used if not alternating
		local solidColor = math.random(1, highestColor)
		local solidTier = math.random(1, highestTier)





		for x = 1, numCols do
			--if skipping is on and we're on a skip iteration
			if skipPattern and skipFlag then
				--turn it off for the next iteration
				skipFlag = not skipFlag

				goto continue
			else
				skipFlag = not skipFlag
			end

			b = Brick(
				--x coord
				(x-1) * 32             --for each brick after one we need to add 32 (brick.width), returns 0 for the first field of the table 
				+ 8                    --screen can fit 13 cols + 16 pixel padding, so this is the left side padding
				+ (13 - numCols) * 16, --additional padding for fewer columns; for each one less than 13(max) we add 16 (half brick width)

				--y coord, simply creating a new row brick.height below, or in the case of the first row, 
				--a brick.height amount of padding from the top of the screen
				y * 16
				)

			if alternatePattern and alternateFlag then
				b.color = alternateColor1
				b.tier = alternateTier1
				alternateFlag = not alternateFlag
			else
				b.color = alternateColor2
				b.tier = alternateTier2
				alternateFlag = not alternateFlag
			end

			if not alternatePattern then
				b.color = solidColor
				b.tier = solidTier
			end

			if keyFlag and math.random(1, 6) == 6 then
				b.color = 6
				b.tier = 1
				b.locked = true
				keyFlag = false
				locked = true
				keyBrick = x * y
			end

			if locked then
				b.key = math.random(1, 2) == 1 and true or false
			end

			table.insert(bricks, index, b)

			--this index was added in order to iterate over the bricks easier and ensure numerical key
			--used elsewhere to scan tables for locked bricks or bricks containing keys
			index = index + 1

			::continue::

		end

	end

	--if no bricks were made, then try again
	if #bricks == 0 then
		return self.createMap(level)
	else
		--[[
		if locked == true then
			local brickAmt = #bricks
			local keyN = math.random(1, brickAmt)
			if keyN == keyBrick then
				keyN = keyBrick + math.random(1, brickAmt - keyBrick) - 1
			end

			for i, brick in ipairs(bricks) do
				if i == keyN then
					brick.key = true
				end
			end
		end
		]]

		return bricks
	end

end