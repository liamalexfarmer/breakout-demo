require 'src/Dependencies'

function love.load()

	love.graphics.setDefaultFilter('nearest', 'nearest')

	math.randomseed(os.time())

	love.window.setTitle('Breakout')

	gFonts = {
		['small'] = love.graphics.newFont('fonts/font.ttf', 8),
		['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
		['large'] = love.graphics.newFont('fonts/font.ttf', 32)
	}

	love.graphics.setFont(gFonts.small)

	gTextures = {
		['background'] = love.graphics.newImage('graphics/background.png'),
		['main'] = love.graphics.newImage('graphics/breakout.png'),
		['arrows'] = love.graphics.newImage('graphics/arrows.png'),
		['hearts'] = love.graphics.newImage('graphics/hearts.png'),
		['particle'] = love.graphics.newImage('graphics/particle.png')
	}

	gFrames = {
		['paddles'] = GenerateQuadsPaddles(gTextures.main),
		['balls'] = GenerateQuadsBall(gTextures.main),
		['bricks'] = GenerateQuadsBricks(gTextures.main),
		['hearts'] = GenerateQuads(gTextures.hearts, 10, 9)
	}

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})


	gSounds = {
		['paddleHit'] = love.audio.newSource('sounds/paddlehit.wav', 'static'),
		['score'] = love.audio.newSource('sounds/score.wav', 'static'),
		['wallHit'] = love.audio.newSource('sounds/wallHit.wav', 'static'),
		['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
		['select'] = love.audio.newSource('sounds/select.wav', 'static'),
		['noSelect'] = love.audio.newSource('sounds/noselect.wav', 'static'),
		['brickHit1'] = love.audio.newSource('sounds/brickhit1.wav', 'static'),
		['brickHit2'] = love.audio.newSource('sounds/brickhit2.wav', 'static'),
		['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
		['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
		['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
		['highScore'] = love.audio.newSource('sounds/highscore.wav', 'static'),
		['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

		['music'] = love.audio.newSource('sounds/music.mp3', 'static'),

	}

	gStateMachine = StateMachine {
		['start'] = function() return StartState() end,
		['play'] = function() return PlayState() end,
		['serve'] = function() return ServeState() end,
		['gameOver'] = function() return GameOverState() end,
		['victory'] = function() return VictoryState() end,
	}

	gStateMachine:change('start')

	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
	push:resize(w, h)
end

function love.update(dt)
	gStateMachine:update(dt)

	love.keyboard.keysPressed = {}
end

function love.keypressed(key)
	--add keys pressed to the table
	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function love.draw()
	push:apply('start')

	local backgroundWidth = gTextures.background:getWidth()
	local backgroundHeight = gTextures.background:getHeight()

	love.graphics.draw(gTextures.background, 
		--draw at co-ordinates 0,0
		0, 0,
		--no rotation
		0, 
		--logic using scale factors to stretch the background to fill the screen
		VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

		gStateMachine:render()

		displayFPS()

		push:apply('end')
end

function renderHealth( health )
	-- used to help render hearts to be adjacent on screen
	local healthX = VIRTUAL_WIDTH - 100

	-- render remaining health
	for i = 1, health do 
		love.graphics.draw(gTextures.hearts, gFrames.hearts[1], healthX, 4)
		healthX = healthX + 11
	end

	for i = 1, 3 - health do
		love.graphics.draw(gTextures.hearts, gFrames.hearts[2], healthX, 4)
		healthX = healthX + 11
	end

end

function displayFPS()
	--displays FPS regardless of states
	love.graphics.setFont(gFonts.small)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function renderScore( score )
	love.graphics.setFont(gFonts.small)
	love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
	love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

