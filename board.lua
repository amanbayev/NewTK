local composer = require( "composer" )

local scene = composer.newScene()

local board
local lunkas = {}
local stones = {}
local counter = {}
local kazan1,kazan2
local texts = {}
local counterTexts = {}
local tuzdyks = {}

local totalStones = {}
local gameOver = false
local tuzdyk1 = 0
local tuzdyk2 = 0

local player1Name 
local player2Name

local p1turn = true
local startingPlayer = 0

--- 720 x 1280
local lunkaLeft = 73
local lunkaSpace = 119
local lunkaTop = 137
---

local selectedLunka = 0
local previousLunka = 0
local nextLunka = 0
local countMoves = 0
local lastLunka = 0

local moveCompleted = false
local init = false
local sharId = 0
local currentStones = 0
local LK = {}

local moveShar
local moveToKazan

local stoneSnd = audio.loadSound( "stone_single.wav") -- stone_single
local stonesSnd = audio.loadSound( "stone_group.wav") -- group stone audio
local soundPlaying = false 

---------------------------------------------------
moveToKazan = function()
    local stonesToSteal = tonumber(#LK[lastLunka])
    local tekStone
    local kazanX, kazanY, rowY, rowX, kazanPos
    local stonesInKazan
    local shifted = false
    local modX = 0

    rowY = 0
    if stonesToSteal>0 then
        print("still stealing, now we have to steal "..stonesToSteal.." more stones from lunka "..lastLunka)
        moveCompleted = false
        if startingPlayer==1 then 
            kazanY = display.contentCenterY - 80
            stonesInKazan = counter.player1
        elseif startingPlayer==2 then 
            kazanY = display.contentCenterY + 80
            stonesInKazan = counter.player2
        end
        kazanX = 175
        local myNumber = stonesInKazan / 10
        local integralPart, fractionalPart = math.modf( myNumber )
        
        modX = integralPart * 10
        --print("mod 10 is "..modX)
        if stonesInKazan>59 then
            rowX = (stonesInKazan-60)*30
            rowY = -60
            modX = modX - 60
            print(modX.." is modX after 60")
        elseif stonesInKazan>29 then
            rowX = (stonesInKazan-30)*30
            rowY = -30
            modX = modX - 30
            print(modX.." is modX after 30")
        else
            rowX = stonesInKazan*30
        end
        if startingPlayer==2 then
            rowY = -rowY
        end
        kazanX = rowX + kazanX + modX
        kazanY = kazanY - rowY
        tekStone = LK[lastLunka][#LK[lastLunka]]
        table.remove(LK[lastLunka])
        print("removing stone #"..tekStone)
        transition.to(stones[tekStone],{time=1000,x=kazanX,y=kazanY})
        counterTexts[lastLunka].text = stonesToSteal - 1
        if startingPlayer==1 then
            counter.player1 = counter.player1 + 1
            counterTexts.player1.text = counter.player1
        else
            counter.player2 = counter.player2 + 1
            counterTexts.player2.text = counter.player2
        end
        timer.performWithDelay(100,moveToKazan)
    else
        moveCompleted = true
    end
end
----------------------------------------------------
moveShar = function(origin,dest,sharId)
	local pos,ballX,ballY,rowX,rowY,xx,time
            if sharId==nil then
                print("SHAR IS NIL!!! origing = "..origin.." and dest = "..dest)
            end
			if init then
				--print("removing "..LK[origin][#LK[origin]].." from "..origin)
				table.remove(LK[origin])
			else
				if LK[dest]==nil then 
					LK[dest]={}
                    --print("creating a group LK["..dest.."]")
				end
			end

			pos = #LK[dest]+1

			LK[dest][pos] = sharId
			print("inserting into "..dest.." to pos "..pos.." shar "..sharId)
			xx=dest
			if dest>9 then 
				xx=9-(18-dest)
			else
				xx=10-dest
			end
			ballX = lunkaLeft+(lunkaSpace*xx-20)
			ballY = (display.contentHeight - lunkaTop + 70)
			if dest<10 then
				ballY = lunkaTop-70
			end
			rowX = 0
			rowY = 0
			if pos>24 then 
				pos = pos - 24 
				rowY = rowY - 17
			end
			rowY = rowY + (pos-1)*34
			if pos>19 then
				rowX = 17 + 34
				rowY = rowY - 19.5*34
			elseif pos>14 then
				rowX = - 17
				rowY = rowY - 14.5*34
			elseif pos>10 then
				rowX = 17
				rowY = rowY - 9.5*34
			elseif pos>5 then
				rowX = 34
				rowY = rowY - 5*34
			end
			if dest>9 then
				rowY = -rowY
			end
			ballX = ballX + rowX
			ballY = ballY + rowY
            time = 300
            if not init then 
                time = 0
            end
			transition.to(stones[sharId],{time,x=ballX, y=ballY})
            if origin > 0 then
                counter[origin]=#LK[origin]
                counterTexts[origin].text = counter[origin]
            end
            counter[dest]=#LK[dest]
            counterTexts[dest].text = counter[dest]
end

local function onKeyEvent(event)
    if (event.keyName == "back") then
        local platformName = system.getInfo( "platformName" )
        if ( platformName == "Android" ) then
            composer.gotoScene( "menu")
            return false
        end
    end

    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false -- OK
end

local function initShars()
	local integralPart, fractionalPart = math.modf( sharId / 9 )
	selectedLunka = integralPart+1
	sharId = sharId + 1
	moveShar(0,selectedLunka,sharId)

	if sharId < 162 then
		--timer.performWithDelay(50, initShars)
        initShars()
	else
		selectedLunka = 0
		moveCompleted = true
		init = true
		sharId = 0
	end
end

local function soundFinished(event)
    
    soundPlaying = true
    if (event.completed) then
        soundPlaying = false
    end-- OK
end

local function moveBalls()
    local num,lastPlayer
    local stealStones = false
	
    if countMoves>=currentStones-1 then
		countMoves = 0
		moveCompleted = true
        lastLunka = nextLunka
        if lastLunka<10 then
            lastPlayer = 1
        else 
            lastPlayer = 2
        end
        num = counterTexts[lastLunka].text
        if (num % 2==0)and(startingPlayer~=lastPlayer) then 
            print("Stealing stones") 
            for k, v in pairs( LK[lastLunka] ) do
                print("last lunka has: "..k, v)
            end
            moveToKazan()
        end
	else
		countMoves = countMoves + 1
		nextLunka = nextLunka+1
		if nextLunka>18 then 
            nextLunka = 1 
        end
		moveShar(selectedLunka,nextLunka,LK[selectedLunka][#LK[selectedLunka]])
		
  --       counter[selectedLunka]=counter[selectedLunka] - 1
		-- counterTexts[selectedLunka].text = counter[selectedLunka]
		-- counter[nextLunka]=counter[nextLunka] + 1
		-- counterTexts[nextLunka].text = counter[nextLunka]
		
        timer.performWithDelay(50,moveBalls)
	end
end

local function makeMove()
	if moveCompleted then
		moveCompleted = false
		nextLunka = selectedLunka
		currentStones = counter[selectedLunka]
        if soundPlaying == false then
            soundPlaying = true
            audio.play(stonesSnd,{ onComplete=soundFinished })
        end
		timer.performWithDelay(100,moveBalls)
	end
end

local function lunkaSelect(event)
	if moveCompleted then
        if counter[event.target.id]~=0 then
            selectedLunka = event.target.id
            previousLunka = selectedLunka
            if selectedLunka<10 then
                startingPlayer=1
            else
                startingPlayer=2
            end
			makeMove()
            previousLunka = 0
        end
	end
end

local function initBoard (sceneGroup)
	board = display.newImage("images/board_bg.png")
    board.x = display.contentCenterX
    board.y = display.contentCenterY
    board.rotation = -90
    sceneGroup:insert(board)

    for i=1,9 do
    	lunkas[i]=display.newImage("images/lunka.png")
    	lunkas[i].rotation = 90
    	lunkas[i].x = lunkaLeft+lunkaSpace*(10-i)
    	lunkas[i].y = lunkaTop
    	lunkas[i].id = i
    	sceneGroup:insert(lunkas[i])
    	lunkas[i]:addEventListener("tap",lunkaSelect)

        

    	texts[i] = display.newText(i, 
    		lunkaLeft+lunkaSpace*(10-i),                 -- lunka text X
    		20,                                          -- lunka text Y
    		native.systemFontBold, 20)
    	texts[i].rotation = 180
    	sceneGroup:insert(texts[i])

    	counterTexts[i] = display.newText("9", 
    		lunkaLeft+lunkaSpace*(10-i),                 -- counter text X
    		lunkaTop+95,                                 -- counter text Y
    		native.systemFontBold, 20)
    	counterTexts[i].rotation = 180
    	sceneGroup:insert(counterTexts[i])

    	lunkas[i+9]=display.newImage("images/lunka.png")
    	lunkas[i+9].rotation = -90
    	lunkas[i+9].x = lunkaLeft+lunkaSpace*i
    	lunkas[i+9].y = display.contentHeight - lunkaTop
    	lunkas[i+9].id = i+9
    	sceneGroup:insert(lunkas[i+9])
    	lunkas[i+9]:addEventListener("tap",lunkaSelect)


    	texts[i+9] = display.newText(i, 
    		lunkaLeft+lunkaSpace*i, 
    		display.contentHeight - 20, 
    		native.systemFontBold, 20)
    	sceneGroup:insert(texts[i+9])

    	counterTexts[i+9] = display.newText("9", 
    		lunkaLeft+lunkaSpace*i, 
    		display.contentHeight-(lunkaTop+95), 
    		native.systemFontBold, 20)
    	sceneGroup:insert(counterTexts[i+9])
    end
    init = false

    for i = 1, 18 do
    	counter[i] = 9
    	c = 1
    	for j = 9*(i-1)+1, 9*i do
    		stones[j] = display.newImage("images/ball.png")
    		stones[j].id = j
            sceneGroup:insert(stones[j])
    	end
    end

    initShars()
    for i=1,9 do
    end
    counter.player1 = 0
    counter.player2 = 0
    player2Name = display.newText(sceneGroup,"Talgat",10,50,native.systemFontBold,25)
    player2Name.x = 90
    player2Name.y = 150
    player2Name.rotation = -90

    player1Name = display.newText(sceneGroup,"Timur",10,50,native.systemFontBold,25)
    player1Name.x = 90
    player1Name.y = display.contentHeight - 150
    player1Name.rotation = -90

    counterTexts.player1 = display.newText(sceneGroup, "0",0,0,native.systemFontBold,25)
    counterTexts.player2 = display.newText(sceneGroup, "0",0,0,native.systemFontBold,25)
    counterTexts.player1.x = 90
    counterTexts.player1.y = display.contentCenterY - 50
    counterTexts.player1.rotation = -90
    counterTexts.player2.x = 90
    counterTexts.player2.y = display.contentCenterY + 50
    counterTexts.player2.rotation = -90
end

----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view

    initBoard(sceneGroup)
    Runtime:addEventListener( "key", onKeyEvent )
end
-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end
-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end
-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene