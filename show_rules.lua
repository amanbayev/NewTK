local composer = require( "composer" )
local widget = require ("widget")

local scene = composer.newScene()
local scrollView
local menuBackground

local function onKeyEvent (event)
	if (event.keyName == "back") then
        local platformName = system.getInfo( "platformName" )
        if ( platformName == "Android" ) then
            composer.gotoScene( "menu")
            return false
        end
    else 
    	return true
    end
end

local function handleBackBtn(event)
    if ("ended"==event.phase) then
        composer.gotoScene("menu")
    end
end

function scene:create( event )

    local sceneGroup = self.view
    Runtime:addEventListener( "key", onKeyEvent )

    menuBackground = display.newImage("images/rules_bg.png")
    menuBackground.x = display.contentCenterX
    menuBackground.y = display.contentCenterY
    menuBackground.width = display.contentWidth
    menuBackground.height = display.contentHeight
    sceneGroup:insert(menuBackground)


	local backBtn = widget.newButton{
        	top = 50,
        	left = 50,
        	defaultFile = "images/back1.png",
        	overFile = "images/back1.png",
        	onEvent = handleBackBtn
    	}
    	backBtn.x = 100
    	backBtn.y = 200
    	backBtn.width = 100
    	backBtn.height = 100
        sceneGroup:insert(backBtn)




end
-- "scene:show()"


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        local myTextEn = [[
Toguz Kumalak is played on a board, which consists of two rows of nine holes. Between 
these rows are two parallel furrows called kazan ("boilers") in the middle of the board 
to store the captures. The players own the kazan in the other half of the board. The 
holes are usually made in such a way that it is evident whether the contents are odd 
or even.

At the beginning there are nine balls in each hole, except the kazans, which are still 
empty. Players need a total of 162 balls.

Initial Position
On his turn, a player takes all the balls of one of his holes, which is not a tuzdik 
(see below) and distribute them anticlockwise, one by one, into the following holes. 
The first ball must be dropped into the hole, which was just emptied.
However, if the move began from a hole, which contained only one ball, this ball is 
put into the next hole.
If the last ball falls into a hole on the opponent's side, and this hole then 
contains an even number of balls, these balls are captured and stored in the 
player's kazan.
If the last ball falls into a hole of the opponent, which then has three balls, 
the hole is marked as a tuzdik ("sacred place" in Kazakh; or tuz in Kyrgyz, 
which means "salt").

There are a few restrictions:
A player may only create one tuzdik in each game.
The last hole of the opponent (his ninth or rightmost hole) cannot be turned into 
a tuzdik.
A tuzdik cannot be made if it is symmetrical to the opponent's one (for instance, 
if the opponent's third hole is a tuzdik, you cannot turn your third hole 
into one).
It is permitted to make such a move, but it wouldn't create a tuzdik.
The balls that fall into a tuzdik are captured by its owner. He may transfer its 
contents at any time to his kazan.
he game ends when a player can't move at his turn because all the holes on his 
side, which are not tuzdik, are empty.

When the game is over, the remaining balls, which are not yet in a kazan or in a 
tuzdik are won by the player on whose side they are.
The winner is the player who, at the end of the game, has captured more balls in 
their tuzdik and their kazan. When both players have 81 balls, the game is a draw.
]]

        local myTextKz = [[
Тоғызқұмалақ ойыны арнайы тақтада екі адам арасында ойналады. Ойын тақтасы  2 қазан, 
18 отау, 162 құмалақтан тұрады. Ойын басында әр ойыншыға бір қазан, тоғыз отауға 
тоғыз-тоғыздан салынған 81 құмалақ тиесілі. Алғашқы жүріс жасаған ойыншыны бастаушы, 
екінші жүріс жасаған ойыншыны қостаушы деп атайды.
Жүріс жасау үшін өз жағыңыздағы отаулардың бірінен сегізін алып, біреуін орнында 
қалдырып, қалған құмалақтарды қолға алып, солдан оңға қарай бір-бірлеп таратамыз. 
Тарату сәтінде құмалақтар өз отауларымыздан асып кететін болса, қарсыластың отауына 
таратамыз. Егер соңғы құмалақ қарсыластың тақ санды құмалағы бар отауына түсіп, 
ондағы құмалақтарды жұп қылса (2, 4, 6, 10, 12), сол отаудағы құмалақтар ұтып 
алынып, өз қазанымызға салынады. Егер соңғы құмалақ қарсыластың жұп санды құмалағы 
бар отауына түсіп (3 құмалақтан басқа), тақ қылса немесе өз отауымызға түссе, 
құмалақ ұтып алынбайды. Отаудағы жалғыз құмалақ көрші отауға жүргенде, орны бос 
қалады. Жүріс жасаған кезде отауларға құмалақ салмай немесе екі-үш құмалақ бөліп 
алып жүруге болмайды.

Атсырау ережесі:
Ойын аяқталуға жақындаған сайын әр ойыншының отауларындағы құмалақ кеми бастайды. 
Әр құмалақ ұтып алынған сайын немесе тұздыққа түскен сайын қарсыластардың жүріс 
мөлшері азая береді. Сондықтан ойын соңында қарсыластардың бірі өз отауларында 
жүріс жасай алмай қалатын жағдай да кездеседі. Ойыншылардың бірінің отауларындағы 
құмалақты бірінші тауысып алып, жүріссіз қалуы «атсырау» деп аталады. Мәселен, 
қостаушы атсырауға ұшыраса, бұл жағдайда бастаушы қосымша бір жүріс жасап, барлық 
құмалақтарды өз қазанына салып алады. Сөйтіп, бастаушы жеңімпаз атанады.
• Егер ойыншы ойын барысында 82 құмалақ жинаса, ойын бірден тоқтатылып, сол ойыншы 
жеңімпаз болып танылады.
			
Тұздық алу:
Тоғызқұмалақта құмалақтан басқа ойында бір рет қарсыластың отауын ұтып алуға 
да болады. Оны ежелде «тұзды үй» деп атаған. Бүгінде «тұздық» дейді. Тұздық 
алу үшін жүріс жасаған кезде қарсыластың екі құмалағы бар отауына сіз таратқан 
құмалақтардың соңғысы түсуі керек. Сонда сол отауда қалыптасқан үш құмалақпен 
бірге отау да ұтып алынып, сол отау ойынның соңына дейін сіздің меншігіңізге 
айналады. Яғни жүріс жасалған сайын тұздық алынған отауға түсетін бір құмалақ 
міндетті түрде сіздің қазаныңызға салынып отырады. Тұздық алынған отауға арнайы 
белгі қойылады. Жазбаша түрде «Х» деген шартты таңбамен белгіленеді. Тұздық 
ойында бір рет алынады және №9 отаудан ешқашан алынбайды. Сондай-ақ тұздық 
аттас отаулардан алынбайды. Мәселен, егер бастаушы сіздің №2 отауыңызға тұздық 
қойса, сіз оның №2 отауына тұздық сала алмайсыз.
Тоғызқұмалақ ойынының негізгі терминдері:
• Құмалақ
• Қазан
• Отау
• Бастаушы
• Қостаушы
• Тұздық
• Атсырау
]]

    	local myTextRu = [[
Правила игры «Тоғыз құмалақ»

Играют двое, у каждого по девять игровых и одна накопительная лунки. В начале 
игры каждый игрок имеет по 81-му камешку, которые лежат в девяти игровых лунках, 
по девять штук в каждой. Задача: перекладывая камушки в игровых лунках, собрать их 
как можно больше в свой «казан». Собранные камешки складываются в накопительную 
лунку. Игроки делают ходы поочерёдно. Делая ход, игрок берёт все шарики из любой 
непустой лунки на своей половине, и раскладывает их в лунки по одному против часовой 
стрелки. Если последняя лунка окажется «вражеской» и количество камешков в ней стало 
чётным, то камешки из этой лунки переходят в казан игроку, совершившему ход. После этого 
ход переходит к его сопернику. Игра ведётся до тех пор, пока один из двух игроков не наберёт 
в свой казан больше 81 камешка (этот игрок побеждает), либо они оба набирают 81 камешек 
(ничья).

Игровые ситуации
«Тұздық» ­ если после хода в какой-то лунке оказывается три камешка, то эта лунка 
объявляется «туздыком». В последующем каждый камешек, попавший в туздык, переходит в 
казан игрока, на чьей стороне расположен этот туздык, но игрок не может завести себе туздык 
на 9-ой, а также на лунке под той цифрой которой взял первым «туздык» соперник. У каждого 
игрока может быть не больше одного туздыка одновременно.
«Атсыз қалу» ­ Если после хода у одного из игроков все лунки оказываются пустыми, 
то он попадает в ситуацию «атсыз калу». В этом случае он не может ходить, пока будет 
оставаться «пешим». В этой ситуации игра заканчивается, камешки противника переходят в 
казан противника и производится подсчёт камешков в казанах.

Условия победы
• Если один из двух игроков наберёт в свой казан больше 81 камешка;
• Если у оппонента не осталось камешков;

Ничья
• Оба оппонента набрали по 81 камешку

]]
	
	local myText

	if composer.lang == "en" then
		myText = myTextEn
	elseif composer.lang == "kz" then
		myText = myTextKz
	else
		myText = myTextRu
	end

	local paragraphs = {}
	local paragraph
	local tmpString = myText
	

	scrollView = widget.newScrollView
	{
	    top = 250,
	    left = 55,
	    width = display.contentWidth-10,
	    height = display.contentHeight-450,
	    scrollWidth = display.contentWidth-200,
	    scrollHeight =1000,
	    hideBackground = true
	}

	local options = {
	    text = "",
	    width = display.contentWidth-20,
	    font = native.systemFontBold,
	    fontSize = 20,
	    align = "left"
	}

	local yOffset = 5

	repeat
	    paragraph, tmpString = string.match( tmpString, "([^\n]*)\n(.*)" )
	    options.text = paragraph
	    paragraphs[#paragraphs+1] = display.newText( options )
	    paragraphs[#paragraphs].anchorX = 0
	    paragraphs[#paragraphs].anchorY = 0
	    paragraphs[#paragraphs].x = 10
	    paragraphs[#paragraphs].y = yOffset
	    paragraphs[#paragraphs]:setFillColor( 1,1,1 )
	    scrollView:insert( paragraphs[#paragraphs] )
	    yOffset = yOffset + paragraphs[#paragraphs].height
	    print( #paragraphs, paragraph )
	until tmpString == nil or string.len( tmpString ) == 0


	sceneGroup:insert(scrollView)
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
    	sceneGroup:remove(scrollView)
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