local botao_img
JOGO_RODANDO = 'sim'



local physics = require('physics')
physics.start()
physics.setGravity( 0,0 )
--physics.setDrawMode( 'hybrid' )

local centro_x = display.contentCenterX
local centro_y = display.contentCenterY


local function jogar()
	local bk = display.newImage( 'bk.jpg', centro_x, centro_y )

	local grupo_jogo = display.newGroup()
	local grupo_Hud = display.newGroup()

	local vida = 50
	local pontos = 0

	local vida_texto = display.newText( {text = 'Vida: '.. vida, x = 60,y = 420,font = nil, fontSize = 20} )
	grupo_Hud:insert(vida_texto)

	-- solicita o player e suas funções
	local PlayerClasse = require('Player')
	local player = PlayerClasse.novo( vida, vida_texto, grupo_jogo, grupo_Hud, botao )

	-- solicita o inimigo e suas funções
	local InimigoClasse = require('Inimigo')
	InimigoClasse.nmr_inimigos = 9

	local Inimigo1 = InimigoClasse.novo( 85, 40, 50, grupo_jogo, botao)
	local inimigo2 = InimigoClasse.novo( 170, 40, 50, grupo_jogo, botao)	
	local inimigo3 = InimigoClasse.novo( 255, 40, 50, grupo_jogo, botao)

	local inimigo4 = InimigoClasse.novo( 85, 100, 50, grupo_jogo, botao)	
	local inimigo5 = InimigoClasse.novo( 170, 100, 50, grupo_jogo, botao)	
	local inimigo6 = InimigoClasse.novo( 255, 100, 50, grupo_jogo, botao )

	local inimigo4 = InimigoClasse.novo( 85, 160, 50, grupo_jogo, botao)	
	local inimigo5 = InimigoClasse.novo( 170, 160, 50, grupo_jogo, botao)	
	local inimigo6 = InimigoClasse.novo( 255, 160, 50, grupo_jogo, botao)



	local ItensClasse = require("Itens")


	timer.performWithDelay( 15000,function()

		coracao1 = ItensClasse.novo_coracao(grupo_jogo)
		
	end, 0, 'timer_coracao')

	timer.performWithDelay( 20000,function()

		bomba1 = ItensClasse.novo_bomba(grupo_jogo)
		
	end, 0, 'timer_bomba')

end


local function menu()

	if JOGO_RODANDO == 'sim' then
		botao_img = 'start-button.png'
	elseif JOGO_RODANDO == 'reiniciando' then
		botao_img = 'replay-button.png'
	end

	local bk_menu = display.newImageRect( 'menu_image.jpg',400, 800 )
	bk_menu.x = centro_x 
	bk_menu.y = centro_y
	local botao = display.newImageRect( botao_img, 150, 150 )
	botao.x = centro_x  
	botao.y = centro_y
	
	local function iniciar_jogo(event)
		
		if event.phase == 'began' then
			botao.xScale = 0.7
			botao.yScale = 0.7
		elseif event.phase == 'ended' then
			jogar()
			botao.xScale = 1
			botao.yScale = 1
			display.remove( botao )

		end
	end
	botao:addEventListener( 'touch', iniciar_jogo )
end
menu()

local function verifica_reinicio()
	if JOGO_RODANDO == 'reiniciando' then
		print( 'reiniciando' )
		JOGO_RODANDO = 'sim'
		menu()
	end
end
Runtime:addEventListener( 'enterFrame', verifica_reinicio )

