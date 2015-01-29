local composer = require( "composer" )

local scene = composer.newScene()

local menuBackground
local player1Name = composer.player1Name or "Player 1"
local player2Name = composer.player2Name or "Player 2"
local lang = composer.lang or "kz"
local multiplayer,achievements,leaderboards,gpgs
local menuItem1,menuItem2

local function startGame(event)
    -- composer.player1Name = "Талгат"
    -- composer.player2Name = "Естай"
    composer.player2Name = player2Name
    composer.player1Name = player1Name
    if lang=="ru" then
        composer.yourTurn = " ваш ход!"
        composer.collectingTuzdykText = "Собираем туздык"
        composer.moveInProgress = "Идет ход..."
        composer.textForPause = "Игра на паузе"
        composer.menuText = "Меню"
        composer.resumeText = "Продолжить"    
    elseif lang=="en" then
        composer.yourTurn = " your turn!"
        composer.collectingTuzdykText = "Collecting tuzdyk"
        composer.moveInProgress = "Move in progress..."
        composer.textForPause = "Game is paused"
        composer.menuText = "Menu"
        composer.resumeText = "Resume"
    elseif lang=="kz" then
        composer.yourTurn = " сен жүресін!"
        composer.collectingTuzdykText = "Тұздықтан құмалақ алуда"
        composer.moveInProgress = "Жүріс..."
        composer.textForPause = "Ойын паузаға қойылды"
        composer.menuText = "Меню"
        composer.resumeText = "Жалғастыру"
    end
    composer.gotoScene("board")
end

function scene:create( event )

    local sceneGroup = self.view
    local text1,text2

    menuBackground = display.newImage("images/menu_bg.png")
    menuBackground.x = display.contentCenterX
    menuBackground.y = display.contentCenterY
    menuBackground.width = display.contentWidth
    menuBackground.height = display.contentHeight
    sceneGroup:insert(menuBackground)
    menuBackground:addEventListener("tap",startGame)
   
    gpgs = display.newImage("images/gpgs.png") 
    gpgs.x = 1100
    gpgs.y = 500
    gpgs:setFillColor(255,0,0,1)
    sceneGroup:insert(gpgs)

    multiplayer = display.newImage("images/multiplayer.png")
    multiplayer.x = 795
    multiplayer.y = 500
    multiplayer:setFillColor(255,0,0,1)
    sceneGroup:insert(multiplayer)

    achievements = display.newImage("images/achievements.png")
    achievements.x = 505
    achievements.y = 500
    achievements:setFillColor(255,0,0,1)
    sceneGroup:insert(achievements)

    leaderboards = display.newImage("images/leaderboards.png")
    leaderboards.x = 245
    leaderboards.y = 500
    leaderboards:setFillColor(255,0,0,1)
    sceneGroup:insert(leaderboards)

    menuItem1 = display.newImage("images/menu_item.png")
    menuItem1.x = display.contentCenterX
    menuItem1.y = 200
    sceneGroup:insert(menuItem1)

    text1 = display.newText(sceneGroup, "1 Player", display.contentCenterX, 200, native.systemFontBold, 30)

    menuItem2 = display.newImage("images/menu_item.png")
    menuItem2.x = display.contentCenterX
    menuItem2.y = 280
    sceneGroup:insert(menuItem2)

    text2 = display.newText(sceneGroup, "2 Players", display.contentCenterX, 280, native.systemFontBold, 30)
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