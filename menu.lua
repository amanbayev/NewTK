local composer = require( "composer" )

local scene = composer.newScene()

composer.gameNetwork = require( "gameNetwork" )
local gpgsInitCallback
local requestLoginCallback

local playerID
local alias

local menuBackground
local playerAlias = ""
local lang = composer.lang or "ru"
local multiplayer,achievements,leaderboards,gpgs
local menuItem1,menuItem2
local flags = {}
local flag_images = {"kz","ru","en"}
local text1,text2

local changeLang

local function startGame(event)
    -- composer.player1Name = "Талгат"
    -- composer.player2Name = "Естай"
    if lang=="ru" then
        composer.lang = "ru"
        composer.player2Name = "Игрок 2"
        composer.player1Name = "Игрок 1"
        composer.yourTurn = "ваш ход!"
        composer.collectingTuzdykText = "Собираем туздык"
        composer.moveInProgress = "Идет ход..."
        composer.textForPause = "Игра на паузе"
        composer.menuText = "Меню"
        composer.resumeText = "Продолжить"    
        composer.textForGameOver = "Игра окончена!"
        composer.atsyzText = "'Атсыз Қалу'!"
        composer.drawText = "Ничья!"
        composer.hasWonText = "победил!"
        
    elseif lang=="en" then
        composer.lang = "en"
        composer.drawText = "Draw!"
        composer.yourTurn = "your turn!"
        composer.player2Name = "Player 2"
        composer.player1Name = "Player 1"
        composer.collectingTuzdykText = "Collecting tuzdyk"
        composer.moveInProgress = "Move in progress..."
        composer.textForPause = "Game is paused"
        composer.menuText = "Menu"
        composer.resumeText = "Resume"
        composer.textForGameOver = "Game Over!"
        
        composer.atsyzText = "'Atsyz Kalu'!"
        composer.hasWonText = "has won!"
    elseif lang=="kz" then
        composer.lang = "kz"
        composer.drawText = "Тең ойын!"
        composer.yourTurn = "сен жүресін!"
        composer.player2Name = "Ойыншы 2"
        composer.player1Name = "Ойыншы 1"
        composer.collectingTuzdykText = "Тұздықтан құмалақ алуда"
        composer.moveInProgress = "Жүріс..."
        composer.textForPause = "Ойын паузаға қойылды"
        composer.menuText = "Меню"
        composer.resumeText = "Жалғастыру"
        composer.textForGameOver = "Ойын аяқталды!"
        composer.atsyzText = "'Атсыз Қалу'!"
        composer.hasWonText = "ұтты!"
    end
    if event.target.id==1 then
        composer.gotoScene("boardSingle")
    else
        print(composer.textForGameOver)
        composer.gotoScene("board")

    end
end

local function requestLoadLocalPlayerCallback (event)
    playerID = event.data.playerID
    alias = event.data.alias

    composer.playerID=playerID
    composer.alias=alias
    --drawWelcomeScreen()
end

requestLoginCallback = function(event)
    if composer.gameNetwork.request("isConnected") then
        composer.gameNetwork.request( "loadLocalPlayer", { listener = requestLoadLocalPlayerCallback } )
    else
        native.showAlert("You are not connected","!",{"OK"})
    end

end

local function showAchievements(event)
    composer.gameNetwork.show("achievements")
end

local function showLeaderboards(event)
    composer.gameNetwork.show("leaderboards")
end

local function gameNetworkLoginCallback( event )
   composer.gameNetwork.request( "loadLocalPlayer", { listener=requestLoadLocalPlayerCallback } )
   return true
end

gpgsInitCallback = function(event)
  if not event.isError then
        composer.gameNetwork.request( "login",
          {

            userInitiated = true,
            listener = requestLoginCallback
        }
        )
    else
        native.showAlert( "Failed!", event.errorMessage, { "OK" } )
    end
end

function scene:create( event )

    local sceneGroup = self.view


    menuBackground = display.newImage("images/menu_bg.png")
    menuBackground.x = display.contentCenterX
    menuBackground.y = display.contentCenterY
    menuBackground.width = display.contentWidth
    menuBackground.height = display.contentHeight
    sceneGroup:insert(menuBackground)
    -- menuBackground:addEventListener("tap",startGame)
   
    gpgs = display.newImage("images/gpgs.png") 
    gpgs.x = 1100
    gpgs.y = 640
    gpgs.xScale = 1.5
    gpgs.yScale = 1.5
    gpgs:setFillColor(255,0,0,1)
    sceneGroup:insert(gpgs)

    multiplayer = display.newImage("images/multiplayer.png")
    multiplayer.x = 795
    multiplayer.y = 640
    multiplayer:setFillColor(255,0,0,1)
    sceneGroup:insert(multiplayer)

    achievements = display.newImage("images/achievements.png")
    achievements.x = 505
    achievements.y = 640
    achievements:setFillColor(255,0,0,1)
    sceneGroup:insert(achievements)
    achievements:addEventListener("tap",showAchievements)

    leaderboards = display.newImage("images/leaderboards.png")
    leaderboards.x = 245
    leaderboards.y = 640
    leaderboards:setFillColor(255,0,0,1)
    leaderboards:addEventListener("tap",showLeaderboards)
    sceneGroup:insert(leaderboards)

    menuItem1 = display.newImage("images/menu_item.png")
    menuItem1.x = display.contentCenterX
    menuItem1.y = 400
    sceneGroup:insert(menuItem1)
    menuItem1.id = 1
    menuItem1:addEventListener("tap",startGame)

    text1 = display.newText(sceneGroup, "1 Игрок", display.contentCenterX, 400, native.systemFontBold, 30)

    menuItem2 = display.newImage("images/menu_item.png")
    menuItem2.x = display.contentCenterX
    menuItem2.y = 480
    menuItem2.id = 2
    sceneGroup:insert(menuItem2)
    menuItem2:addEventListener("tap",startGame)

    text2 = display.newText(sceneGroup, "2 Игрока", display.contentCenterX, 480, native.systemFontBold, 30)

    for i=1,3 do
        flags[i] = display.newImage("images/"..flag_images[i]..".png")
        flags[i].x = 100
        flags[i].y = 100+100*i
        flags[i].id = flag_images[i]
        sceneGroup:insert(flags[i])
        flags[i]:addEventListener("tap",changeLang)
    end
end

changeLang = function(event)
    local id = event.target.id
    lang = id
    print(id)
    composer.lang = id
    if id=="ru" then
        text1.text = "1 Игрок"
        text2.text = "2 Игрока"
    elseif id=="kz" then
        text1.text = "1 Ойыншы"
        text2.text = "2 Ойыншы"
    elseif id=="en" then
        text1.text = "1 Player"
        text2.text = "2 Players"
    end
end
-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- if ( system.getInfo("platformName") == "Android" ) then
            -- google game play services
            composer.gameNetwork.init( "google", gpgsInitCallback )
        -- else
        --     -- apple game center
        --     composer.gameNetwork.init( "gamecenter", gameNetworkLoginCallback )
        -- end
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