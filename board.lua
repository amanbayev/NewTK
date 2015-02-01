local composer = require( "composer" )

local scene = composer.newScene()

local checkGameConditions
local thisGroup

local board
local playPause
local lunkas = {}
local stones = {}
local forTuzdyk = false
local counter = {}
local cPlayerName
local tSP
local kazan1,kazan2
local turnText = composer.yourTurn
local lastUsedLunka
local texts = {}
local moveInProgressText = composer.moveInProgress
local collectingTuzdykText = composer.collectingTuzdykText
local counterTexts = {}
local lang = composer.lang
local kazan1collected,kazan2collected,movedToKazan
local ballsMoved = false
local statusText

local totalStones = {}
local gameOver = false
local tuzdyks = {0,0}

local player1Name = composer.player1Name
local player2Name = composer.player2Name

local p1turn = false
local startingPlayer = 0

--- 720 x 1280
local lunkaLeft = 73
local lunkaSpace = 119
local lunkaTop = display.contentCenterY - 223
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
local moveToKazanSpeed=100

local stoneSnd = audio.loadSound( "stone_single.wav") -- stone_single
local stonesSnd = audio.loadSound( "stone_group.wav") -- group stone audio
local soundPlaying = false 

---------------------------------------------------
checkGameConditions = function()
    local total = thisGroup.numChildren

    print(tostring(p1turn).." is p1turn")
    print(totalStones[1].." is total stones 1")
    if (totalStones[1]==0) and p1turn then
        moveCompleted=false

        composer.winner = player2Name
        composer.winCondition = "atsyzkalu"
        for i = 1, total do
            if thisGroup[i]~=nil then 
                thisGroup[i]:setFillColor(100/255,100/255,100/255)
            end
        end
        local options = {
            effect = "slideDown",
            time = 500,
            isModal = true
        }
        composer.showOverlay("game_over",options)
    elseif (totalStones[2]==0) and not p1turn then
        moveCompleted=false
        composer.winner=player1Name
        composer.winCondition = "atsyzkalu"
        for i = 1, total do
            if thisGroup[i]~=nil then 
                thisGroup[i]:setFillColor(100/255,100/255,100/255)
            end
        end
        local options = {
            effect = "slideDown",
            time = 500,
            isModal = true
        }
        composer.showOverlay("game_over",options)
    elseif tonumber(counterTexts.player1.text)>=82 then
        moveCompleted=false
        composer.winner = player2Name
        composer.winCondition = "regular win"
        for i = 1, total do
            if thisGroup[i]~=nil then 
                thisGroup[i]:setFillColor(100/255,100/255,100/255)
            end
        end
        local options = {
            effect = "slideDown",
            time = 500,
            isModal = true
        }
        composer.showOverlay("game_over",options)
    elseif tonumber(counterTexts.player2.text)>=82 then
        moveCompleted=false
        composer.winner = player1Name
        composer.winCondition = "regular win"
        for i = 1, total do
            if thisGroup[i]~=nil then 
                thisGroup[i]:setFillColor(100/255,100/255,100/255)
            end
        end
        local options = {
            effect = "slideDown",
            time = 500,
            isModal = true
        }
        composer.showOverlay("game_over",options)
    elseif tonumber(counterTexts.player1.text)==tonumber(counterTexts.player2.text) and tonumber(counterTexts.player1.text)==81 then
        moveCompleted=false
        composer.winner = ""
        composer.winCondition = "draw"
        for i = 1, total do
            if thisGroup[i]~=nil then 
                thisGroup[i]:setFillColor(100/255,100/255,100/255)
            end
        end
        local options = {
            effect = "slideDown",
            time = 500,
            isModal = true
        }
        composer.showOverlay("game_over",options)
    end
end
---------------------------------------------------
moveToKazan = function(playerId)
    local stonesToSteal = tonumber(counterTexts[lastUsedLunka].text)
    local tekStone
    local kazanX, kazanY, rowY, rowX, kazanPos
    local stonesInKazan
    local shifted = false
    local modX = 0
    --print("kazan last lunka "..lastUsedLunka)
    --print("trying to steal to kazan "..stonesToSteal)
    rowY = 0
    rowX = 0
    modX = 0
    for i=1, stonesToSteal do
        totalStones[3-playerId]=totalStones[3-playerId]-1

        if playerId==1 then 
            kazanY = display.contentCenterY - 80
            stonesInKazan = counter.player1
        elseif playerId==2 then 
            kazanY = display.contentCenterY + 80
            stonesInKazan = counter.player2
        end

        kazanX = 170
        local myNumber = stonesInKazan / 10
        local integralPart, fractionalPart = math.modf( myNumber )
        
        modX = integralPart * 20
        --print("mod 10 is "..modX)
        if stonesInKazan>59 then
            rowX = (stonesInKazan-60)*33
            rowY = -60
            modX = modX - 120
            --print(modX.." is modX after 60")
        elseif stonesInKazan>29 then
            rowX = (stonesInKazan-30)*33
            rowY = -30
            modX = modX - 60
            --print(modX.." is modX after 30")
        else
            rowX = stonesInKazan*33
            rowY = 0
        end
        if playerId==2 then
            rowY = -rowY
        end
        kazanX = rowX + kazanX + modX
        kazanY = kazanY - rowY
        
        tekStone = LK[lastUsedLunka][#LK[lastUsedLunka]]
        table.remove(LK[lastUsedLunka])
        -- if tekStone==nil then
        --     print("nil stone")
        -- else
        --     print("removing stone #"..tekStone)
        -- end
        transition.to( 
                       stones[tekStone], 
                       { 
                            time=1000, 
                            x=kazanX, 
                            y=kazanY 
                       }
                      )
        counterTexts[lastUsedLunka].text = stonesToSteal - i
        counter[lastUsedLunka]=counter[lastUsedLunka]-1
        if playerId==1 then
            counter.player1 = counter.player1 + 1
            counterTexts.player1.text = counter.player1
        else
            counter.player2 = counter.player2 + 1
            counterTexts.player2.text = counter.player2
        end
    end
    
    movedToKazan = true
    moveCompleted = true
    checkGameConditions()

    -- if  p1turn then 
    --     cPlayerName = player2Name
    --     statusText.rotation=180
    -- else
    --     cPlayerName = player1Name
    --     statusText.rotation=0
    -- end
    -- statusText.text = cPlayerName .. " "  .. turnText    
end
----------------------------------------------------
moveShar = function(origin,dest,sharId)
	local pos,ballX,ballY,rowX,rowY,xx,time
            if sharId==nil then
                --print("SHAR IS NIL!!! origing = "..origin.." and dest = "..dest)
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
			--print("inserting into "..dest.." to pos "..pos.." shar "..sharId)
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
            if origin>9 and dest<10 then
                totalStones[2]=totalStones[2]-1
                totalStones[1]=totalStones[1]+1
            elseif origin>0 and origin<10 and dest>9 then
                totalStones[2]=totalStones[2]+1
                totalStones[1]=totalStones[1]-1
            elseif origin==0 then
                if dest<10 then
                    totalStones[1]=totalStones[1]+1
                else
                    totalStones[2]=totalStones[2]+1
                end
            end
            print("totalstones 1 = "..totalStones[1])
            print("totalstones 2 = "..totalStones[2])
			transition.to(stones[sharId],{time,x=ballX, y=ballY})
            if origin > 0 then
                counter[origin]=#LK[origin]
                counterTexts[origin].text = counter[origin]
            end
            counter[dest]=#LK[dest]
            counterTexts[dest].text = counter[dest]
end
----------------------------------------------------
local function onKeyEvent(event)
    -- if (event.keyName == "back") then
    --     -- local platformName = system.getInfo( "platformName" )
    --     -- if ( platformName == "Android" ) then
    --     --     composer.gotoScene( "menu")
    --     --     return false
    --     -- end
        local total = thisGroup.numChildren
        for i = 1, total do
            if thisGroup[i]~=nil then 
                thisGroup[i]:setFillColor(100/255,100/255,100/255)
            end
        end
        --print("pausing")
        local options = {
            effect = "slideDown",
            time = 500,
            isModal = true
        }
        composer.showOverlay("pause_menu",options)
    -- end

    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false -- OK
end

local function goBack(event)
    local total = thisGroup.numChildren
    for i = 1, total do
        if thisGroup[i]~=nil then 
            thisGroup[i]:setFillColor(100/255,100/255,100/255)
        end
    end
    --print("pausing")
    local options = {
        effect = "slideDown",
        time = 500,
        isModal = true
    }
    composer.showOverlay("pause_menu",options)
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

local function collectTuzdyk2()
    --print("collecting 2")
    
    lastUsedLunka=tuzdyks[2]
    forTuzdyk = true
    moveToKazan(2)
    -- forTuzdyk = false
    print(tostring(p1turn))
    
    checkGameConditions()
        if  p1turn then 
            cPlayerName = player2Name
            statusText.rotation=180
        else
            cPlayerName = player1Name
            statusText.rotation=0
        end
        statusText.text = cPlayerName .. " "  .. turnText
        kazan2collected = true
end

local function collectTuzdyk1()
    --print("collecting 1")
    lastUsedLunka=tuzdyks[1]
    movedToKazan = false 
    moveToKazan(1)
    kazan1collected = true
        if tuzdyks[2]>0 then
            movedToKazan = false
            lastUsedLunka=tuzdyks[2]
            timer.performWithDelay(210,collectTuzdyk2)
        else
            kazan2collected =true
            lastUsedLunka = lastLunka
            checkGameConditions()
            --print(tostring(p1turn))
            if  p1turn then 
                cPlayerName = player2Name
                statusText.rotation=180
            else
                cPlayerName = player1Name
                statusText.rotation=0
            end
            statusText.text = cPlayerName .. " "  .. turnText
        end

end

local function driverForKazan()
    moveToKazan(startingPlayer)
end

local function moveBalls()
    local num,lastPlayer
    local stealStones = false
	-----------

    if countMoves>=currentStones-1 then
		countMoves = 0
        kazan1collected=false
        kazan2collected = false
		movedToKazan = true
        lastLunka = nextLunka
        if lastLunka<10 then
            lastPlayer = 1
        else 
            lastPlayer = 2
        end
        num = tonumber(counterTexts[lastLunka].text)
        startingPlayer = tSP
        if (num % 2==0) and (startingPlayer~=lastPlayer) then 
            movedToKazan = false
            -- for k, v in pairs( LK[lastLunka] ) do
            --     print("last lunka has: "..k, v)
            -- end
            lastUsedLunka = lastLunka
            --counterTexts[lastLunka].text = "0"
            timer.performWithDelay(800,driverForKazan)
        else
            movedToKazan=true
        end
        
        if (num == 3) and (startingPlayer ~= lastPlayer) then
            -- tuzdyk
            --print("tuzdyk")
            if (tuzdyks[startingPlayer]==0) and (lastLunka~=9) and (lastLunka~=18) then
                if startingPlayer==2 and ((tuzdyks[1]-9)~=lastLunka) then
                    --print("tuzdyk for player "..startingPlayer.." at lunka #"..lastLunka)
                    tuzdyks[startingPlayer] = lastLunka
                    thisGroup:remove(lunkas[lastLunka])
                    lunkas[lastLunka] = display.newImage("images/tuzdyk.png")
                    lunkas[lastLunka].rotation = 90
                    lunkas[lastLunka].x = lunkaLeft+lunkaSpace*(10-lastLunka)
                    lunkas[lastLunka].y = lunkaTop
                    lunkas[lastLunka].id = lastLunka
                    thisGroup:insert(2,lunkas[lastLunka])
                    lastUsedLunka = lastLunka
                    
                elseif startingPlayer==1 and (tuzdyks[2]~=lastLunka-9) then
                    --print("tuzdyk for player "..startingPlayer.." at lunka #"..lastLunka)
                    tuzdyks[startingPlayer] = lastLunka
                    thisGroup:remove(lunkas[lastLunka])
                    lunkas[lastLunka] = display.newImage("images/tuzdyk.png")
                    lunkas[lastLunka].rotation = -90
                    lunkas[lastLunka].x = lunkaLeft+lunkaSpace*(lastLunka-9)
                    lunkas[lastLunka].y = display.contentHeight - lunkaTop
                    lunkas[lastLunka].id = lastLunka
                    thisGroup:insert(2,lunkas[lastLunka])
                    lastUsedLunka = lastLunka
                    
                end

            end
        end
        if (tuzdyks[1]~=0) and (counter[tuzdyks[1]] ~= 0) then
            movedToKazan = false
            moveCompleted = false
            statusText.text = collectingTuzdykText
            timer.performWithDelay(800,collectTuzdyk1)
        elseif tuzdyks[2]~=0 and (counter[tuzdyks[2]] ~= 0) then
            kazan1collected = true
            statusText.text = collectingTuzdykText
            movedToKazan = false
            moveCompleted = false
            timer.performWithDelay(800,collectTuzdyk2)
        else
            kazan1collected=true
            kazan2collected=true
            if movedToKazan then
                if  p1turn then 
                    cPlayerName = player2Name
                    statusText.rotation=180
                else
                    cPlayerName = player1Name
                    statusText.rotation=0
                end
                statusText.text = cPlayerName .. " "  .. turnText
                moveCompleted = true
                checkGameConditions()
            end
        end
        ballsMoved = true
	else
		countMoves = countMoves + 1
		nextLunka = nextLunka+1
		if nextLunka>18 then 
            nextLunka = 1 
        end
		moveShar(selectedLunka,nextLunka,LK[selectedLunka][#LK[selectedLunka]])
        timer.performWithDelay(50,moveBalls)
	end
end

local function makeMove()
	
        ballsMoved = false
        movedToKazan = false
        kazan1collected = false
        kazan2collected = false
		nextLunka = selectedLunka
		currentStones = counter[selectedLunka]
        if soundPlaying == false then
            soundPlaying = true
            audio.play(stonesSnd,{ onComplete=soundFinished })
        end
        if currentStones==1 then
            currentStones=2
        end
		timer.performWithDelay(100,moveBalls)	
end

local function lunkaSelect(event)
    local notp1turn = false
    local cPlayerName = player1Name
    local lunkaId = event.target.id

    -- print("lunkaId = "..lunkaId)
    -- print("counter = "..counter[lunkaId])
    -- print("moveCompleted "..tostring(moveCompleted))
    -- print("ballsMoved "..tostring(ballsMoved))
    if kazan1collected and kazan2collected and moveCompleted then
        if tonumber(counter[lunkaId])>0 then
            if lunkaId<10 then 
                notp1turn=false 
            else
                notp1turn=true
            end
            if not p1turn == notp1turn then
                moveCompleted = false
                selectedLunka = event.target.id
                previousLunka = selectedLunka
                if selectedLunka<10 then
                    startingPlayer=1
                else
                    startingPlayer=2
                end
                if startingPlayer==2 then 
                    statusText.text = moveInProgressText
                    statusText.rotation=180
                else
                    statusText.text = moveInProgressText
                    statusText.rotation=0
                end
                tSP = startingPlayer
    			makeMove()
                p1turn = not p1turn
                previousLunka = 0
            end
    	end
    end
    print("before move")
    print("totalStones 1:"..totalStones[1])
    print("totalStones 2:"..totalStones[2])
end

local function initBoard (sceneGroup)
    local sPlayerName = player1Name
	board = display.newImage("images/board_wide.png")
    board.x = display.contentCenterX
    board.y = display.contentCenterY
    -- board.width = display.contentHeight
    -- board.height = display.contentWidth
    board.rotation = -90
    sceneGroup:insert(board)
    totalStones[1]=0
    totalStones[2]=0

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
    		lunkaTop-120,                                          -- lunka text Y
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
    		display.contentHeight - lunkaTop+120, 
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

    kazan1collected = true
    kazan2collected = true
    initShars()
    counter.player1 = 0
    counter.player2 = 0
    player2NameText = display.newText(sceneGroup,player2Name,10,50,native.systemFontBold,25)
    player2NameText.x = 90
    player2NameText.y = display.contentCenterY - 200
    player2NameText.rotation = -90

    player1NameText = display.newText(sceneGroup,player1Name,10,50,native.systemFontBold,25)
    player1NameText.x = 90
    player1NameText.y =  display.contentCenterY + 200
    player1NameText.rotation = -90
    if math.random(2)==1 then
        p1turn = true
    else
        p1turn = false
    end
    if p1turn then
        sPlayerName = player2Name
    end
   
    statusText = display.newText(sceneGroup,sPlayerName.." "..turnText,display.contentCenterX,display.contentCenterY,native.systemFontBold,25)
     if p1turn then 
                    
                    statusText.rotation=180
                else
                    
                    statusText.rotation=0
    end


    counterTexts.player1 = display.newText(sceneGroup, "0",0,0,native.systemFontBold,25)
    counterTexts.player2 = display.newText(sceneGroup, "0",0,0,native.systemFontBold,25)
    counterTexts.player1.x = 90
    counterTexts.player1.y = display.contentCenterY - 50
    counterTexts.player1.rotation = -90
    counterTexts.player2.x = 90
    counterTexts.player2.y = display.contentCenterY + 50
    counterTexts.player2.rotation = -90

    playPause = display.newImage("images/play_pause.png")
    playPause.rotation = -90
    playPause.x = 32
    playPause.y = display.contentHeight / 2
    sceneGroup:insert(playPause)
    playPause:addEventListener("tap",goBack)
    thisGroup = sceneGroup
end

----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view

    initBoard(sceneGroup)
    Runtime:addEventListener( "key", onKeyEvent )
end
-- "scene:show()"

function scene:resumeGame()
    local total = thisGroup.numChildren
        --print("about to show!")
        for i = 1, total do
            if thisGroup[i]~=nil then 
                --print("i'm here"..i)
                thisGroup[i]:setFillColor(1,1,1)
            end
        end
end

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
        composer.removeScene("boardSingle")
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