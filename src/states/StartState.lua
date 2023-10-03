--inherits the empty function from BaseState that can either be defined or left empty
StartState = Class{__includes = BaseState}

--used to detemine which option of our start state menu is currently selected, and whether it should switch
local highlighted = 1

function StartState:update(dt)
	--if the up or down button was pressed, then set highlighted to 2 if it's one, or otherwise set it to 1
	if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
		highlighted = highlighted == 1 and 2 or 1
		--gSounds.select:stop() added this line because if you swapped options too fast you didn't get the sound, but it made pops. need a shorter sound file.
		gSounds.select:play()
	end

	--start the game if you press enter on start game
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gSounds.confirm:play()

		if highlighted ==  1 then
			gStateMachine:change('serve', {
				paddle = Paddle(1),
				bricks = LevelMaker.createMap(1),
				health = 3,
				score = 0,
			})
		end
	end

	--exit the game at the startstate if escape is pressed (it's typically a back action elsewhere)
	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function StartState:render()

	--render the game title using the large font, fwiw gFonts.large == gFonts['large'] ...
	--... i simply prefer this way of writing it--it's faster & cleaner
	love.graphics.setFont(gFonts.large)

	love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

	--change font
	love.graphics.setFont(gFonts.medium)

	--if this menu option is selected, set it to blue
	if highlighted == 1 then
		love.graphics.setColor(103/255, 1, 1, 1)
	end
	--print "START" using the above parameters
	love.graphics.printf("START", 0, 2 * VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

	--reset color
	love.graphics.setColor(1, 1, 1, 1)

	--render second menu option blue if selected
	if highlighted == 2 then
		love.graphics.setColor(103/255, 1, 1, 1)
	end

	--print HIGH SCORES just below START
	love.graphics.printf("HIGH SCORES", 0, 2 * VIRTUAL_HEIGHT / 3 + 20, VIRTUAL_WIDTH, 'center')

	--reset color again
	love.graphics.setColor(1, 1, 1, 1)

end



