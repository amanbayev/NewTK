local composer = require( "composer" )

local scene = composer.newScene()

local menuBackground
local player1Name = composer.player1Name or "Player 1"
local player2Name = composer.player2Name or "Player 2"
local lang = composer.lang or "kz"
local multiplayer,achievements,leaderboards,gpgs

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
    sceneGroup:insert(gpgs)
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