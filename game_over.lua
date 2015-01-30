local composer = require( "composer" )

local scene = composer.newScene()
local winCondition = composer.winCondition
local winner = composer.winner
local menuBackground
local menuText = composer.menuText

local textForGameOver = composer.textForGameOver
local button1
local pauseText

local function returnToMenu(event)
    
    local options = 
    {
        effect = "fade",
        time = 600
    }
    composer.gotoScene("menu",options)
    composer.hideOverlay()
end

function scene:create( event )

    local sceneGroup = self.view


    menuBackground = display.newImage("images/pause_menu_universal.png")
    menuBackground.x = display.contentCenterX
    menuBackground.y = display.contentCenterY
    
    sceneGroup:insert(menuBackground)

    pauseText = display.newText(sceneGroup,textForGameOver,0,0,native.systemFontBold,40)
    pauseText.x = display.contentCenterX
    pauseText.y = display.contentCenterY+60
    if winCondition=="atsyzkalu" then
        pauseText.text = pauseText.text .. " " .. composer.atsyzText .. " " .. composer.winner .. " " .. composer.hasWonText
    elseif winCondition=="draw" then
        pauseText.text = pauseText.text .. " " .. composer.drawText
    else
        pauseText.text = pauseText.text .. " " .. composer.winner .. " " .. composer.hasWonText
    end

    --button1 = display.newImage("images/menu_button.png")
    button1 = display.newText(sceneGroup,menuText,0,0,native.systemFontBold,40)
    button1.x = display.contentCenterX -150
    button1.y = display.contentCenterY + 150
    sceneGroup:insert(button1)
    button1:addEventListener("tap",returnToMenu)
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
            event.parent:resumeGame()
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