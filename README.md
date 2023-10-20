# Breakout
Guided Programming &amp; Non-Guided Advancements of Breakout Game on LOVE2D

The program herein is based on the Harvard CS50 course Lecture 3: Flappy Bird.

The preliminary code was provided by Colton Ogden et al. as part of the course, with advancements and modifications made by myself.

Those advancements and modifications were done by myself (Liam Farmer) and are listed below:

1. PowerUps will now spawn at score benchmarks.

-The amount of score required to spawn a new power-up is defined by the BASE_RECOVERY constant.
-Red power ups spawn 2 extra balls, green spawns 3, and hearts heal you to full.
-PowerUps spawn based on a theoretical 12 sided dice roll. 
	-1 in 2 chance for red
	-1 in 3 chance for green
	-1 in 6 chance for full heal
-PowerUps spawn at a random point on the y = 0 axis, with 1/8th of the width of the screen buffer on either side.
-PowerUps move at a constant rate and direction on the y axis.
-Extra balls behave the same as the game ball, but are always gray and won't cause you to lose the game.

2. The paddle will grow and shrink based on game conditions.

-Colliding with a heart power-up will not only heal you to full, but grow your paddle one iteration when possible.
-If you lose a heart, the paddle will shrink one iteration when possible.

3. Locked Bricks will randomly be created no more than once in the level creation process.

-The presence of bricks will randomly flag regular bricks as "key" bricks.
-Destroying these bricks will generate a key that will unlock the locked brick.
-Unlocking the brick ass 50% of your current score, and causes up to 5 random power-ups to fall.
-Keys will stop spawning once the locked brick is unlocked.
-Destroying all the bricks except the locked brick and failing to unlock it will still result in victory.


Potential Future Improvements:

1. 	It's been suggested that there are better collision detection systems, and improving the present system
	would be wise. There are collision issues and instances where a ball moving fast enough will pass through 	multiple blocks.

2. 	It would be smart to define an intended "maximum score" amount for each level, and make adjustments
	on the brick arrangement to accommodate that. Each level can currently provide wildly varying scoring
	potential.

3.	There is a lot of sound re-use. Many opportunities for not only better sounds, but greater variety.


