--Registry for the different dependencies required by the main game.

--Push enables virtual resolution and manipulations. Helps with retro aesthetic.
-- https://github.com/Ulydev/push
push = require 'lib/push'

--Class library being used to represent game components as code, rather than having excessive code nesting
-- https://github.com/vrld/hump/blob/master/class.lua

Class = require 'lib/class'


--store and reference for constant values that apply across multiple aspects of our game
require 'src/constants'


--basic state machine class that allows more established transitions between game states
--reduces code bloat
require 'src/StateMachine'



--individual states available to our game currently
--each state has enter, exit, update, and render functions
--that can be called upon limiting processing and code
require 'src/states/BaseState'
require 'src/states/StartState'