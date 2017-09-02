local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local physics = require "physics"
physics.start()
physics.setGravity (0, 1)
system.activate( "multitouch" )

local score = 0

bg = display.newImage ("bg2.png")
bg.x = 500
bg.y = 540

droid = display.newImage ("droid.png")
droid.x = 500
droid.y = 1700
droidShape = {-100, -20, 100, -20, 100, 20, -100, 20}
droid.number = -1
physics.addBody (droid, "static", {density = 0.2, bounce = 1, friction = 0, shape = droidShape, filter = collisionFilter})

ball = display.newImage ("ball2.png")
ball.x = 500
ball.y = 1600
ball.number = 0
physics.addBody (ball, "dynamic", {density = 0.2, bounce = 1, friction = 0, radius = 20, filter = collisionFilter})
ball:applyForce (-150, -150, ball.x, ball.y)

border1 = display.newImage ("border1.png")
border1.x = 500
border1.y = 0
border1Shape = {-1000, -10, 1000, -10, 1000, 10, -1000, 10}
border1.number = -2
physics.addBody (border1, "static", {density = 0.2, bounce = 1, friction = 0, shape = border1Shape, filter = collisionFilter})

border2 = display.newImage ("border2.png")
border2.x = 0
border2.y = 1000
border1Shape = {-10, -1000, 10, -1000, 10, 1000, -10, 1000}
border2.number = -2
physics.addBody (border2, "static", {density = 0.2, bounce = 1, friction = 0, shape = border2Shape, filter = collisionFilter})

border3 = display.newImage ("border2.png")
border3.x = 1080
border3.y = 1000
border3.number = -2
physics.addBody (border3, "static", {density = 0.2, bounce = 1, friction = 0, shape = border2Shape, filter = collisionFilter})

local box = {}
boxShape = {-50, -35, 50, -35, 50, 35, -50, 35}

local function makeAll ()
	for x = 1, 8, 1 do
		for y = 1, 11, 1 do
			box [x + (y - 1) * 8] = display.newImage ("box2.png")
			box [x + (y - 1) * 8].x = 100 + x * 100
			box [x + (y - 1) * 8].y = 100 + y * 70
			box [x + (y - 1) * 8].number = x + (y - 1) * 8
			physics.addBody (box [x + (y - 1) * 8], "static", {density = 0.2, bounce = 1, friction = 0, shape = boxShape, filter = collisionFilter})
		end
	end
end

local function touchScreen( event )
    if ( event.phase == "moved" ) then
        local dX = event.x - event.xStart
        print( event.x, event.xStart, dX )

        droid.x = event.x
        --droid.y = event.y
    end

    if ( event.phase == "began" ) then
        droid.x = event.x
    end

    return true
end
 
Runtime:addEventListener ("touch", touchScreen)

function moveAll (self, event)
	if ball.y > 3000 then
		ball.x = 500
		ball.y = 1200
	end
end

--droid.enterFrame = moveAll
Runtime:addEventListener ("enterFrame", moveAll)

local function onGlobalCollision (event)
    if (event.phase == "began" ) then
    	 print( "began: ", event.object1.number, " and ", event.object2.number )
		audio.loadSound (lapkaSound)
    	score = score + 10

    	if event.object1.number >= 1 and event.object1.number <= 88 then
    		box [event.object1.number] : removeSelf ()
			box [event.object1.number] = nil
			audio.play ( boomSound )
		end
    end
end 

Runtime:addEventListener ("collision", onGlobalCollision)

makeAll ()

boomSound = audio.loadSound( "RS.wav" )