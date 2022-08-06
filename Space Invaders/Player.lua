local Player = {}
local centro_x = display.contentCenterX
local centro_y = display.contentCenterY
print('Script Player solicitado!')

function Player.novo(vida, vida_texto, grupo_jogo, grupo_Hud, botao)
	
	local nave = display.newImageRect('nave.png', 70, 70 )
	nave.x = centro_x
	nave.y = 420
	nave.direcao = 'parado'
	physics.addBody(nave,'dynamic')
	grupo_jogo:insert( nave )

	nave.andar = function(event)

		if (event.phase == 'began') then
			if (event.x > centro_x ) then
			    nave.direcao = 'direita'
			elseif (event.x < centro_x)	then
				nave.direcao = 'esquerda'
			end	

		elseif (event.phase == 'ended') then
			    nave.direcao = 'parado'
		end
	end
	Runtime:addEventListener( 'touch', nave.andar )

	nave.ciclo_jogo = function()
		if nave.x ~= nil and nave.direcao == 'direita' then
			nave.x = nave.x + 2
		elseif nave.x ~= nil and nave.direcao == 'esquerda' then
			   nave.x = nave.x - 2
		end

		
	end

	Runtime:addEventListener( 'enterFrame', nave.ciclo_jogo )

	botao_tiro = display.newImageRect( 'botao.png', 50, 50 )
	botao_tiro.x = 290
	botao_tiro.y = 420
	grupo_Hud:insert(botao_tiro)
	nave.atirar = function(event)

		-- simbolo de diferente de ~=
		if nave.x ~= nil and event.phase == 'began' then

			local tiro = display.newCircle( nave.x, nave.y - 40, 5 )
			tiro:setFillColor( 1 )
			tiro.id = 'fire'
			physics.addBody( tiro, 'kinematic',{ isSensor=true, isBullet=true, 5 })
			grupo_jogo:insert( tiro )
			tiro:setLinearVelocity( 0, -300 )
			botao_tiro.xScale = 0.7
			botao_tiro.yScale = 0.7
			
		elseif nave.x ~= nil and event.phase == 'ended'then
			botao_tiro.xScale = 1
			botao_tiro.yScale = 1	

		end
		return true -- fz o evento de toque servir só para oque for tocado
	end
	botao_tiro:addEventListener( 'touch', nave.atirar )



	local function onLocalCollision( self, event )
	 
	    if ( event.phase == "began" ) then
	        print( "iniciou a colisão " )

	        if event.other.id == 'tiro' then
	        	display.remove(event.other)

	        	vida = vida - 5
	        	vida_texto.text = 'vida: '..vida
	        	-- para remover ele msm: display.remove(self)
	        	if vida < 5 then
	        	   Runtime:removeEventListener( 'touch', nave.andar )
	        	   Runtime:removeEventListener( 'enterFrame', nave.ciclo_jogo )
	        	   botao_tiro:removeEventListener( 'touch', nave.atirar )
	        	   display.remove(self)
	        	   local game_over_image = display.newImageRect( 'gamer_over.jpg', 400, 800 )
	        	   game_over_image.x = centro_x 
	        	   game_over_image.y = centro_y
	        	   game_over_image.alpha = 0
	               transition.to( game_over_image, {time = 2000, alpha = 1} )
	        	   timer.cancel('timer_tiro_inimigo')
	        	   timer.cancel( 'timer_bomba')
	        	   timer.cancel( 'timer_coracao')
	        	   transition.to(grupo_jogo, {alpha=0.1, time=1000, onComplete= function()
	        	   	 display.remove(grupo_jogo)
	        	   	end })
	        	   transition.to(grupo_Hud, {alpha=0.1, time=1000, onComplete= function()
	        	   	 display.remove(grupo_Hud)
	        	   	end })
	        	   timer.performWithDelay( 7000, function() 
	        	   	JOGO_RODANDO = 'reiniciando'
	        	   end, 1)
	        	   
	        	end

	        elseif event.other.id == 'coracao' then
	        	vida = vida + 25
	        	vida_texto.text = 'vida: '.. vida
	        	display.remove(event.other)
	        	
	        elseif event.other.id == 'bomba' then
	        	vida = vida - 25
	        	vida_texto.text = 'vida: '.. vida
	        	display.remove(event.other)
	        	if vida < 5 then
	        	   Runtime:removeEventListener( 'touch', nave.andar )
	        	   Runtime:removeEventListener( 'enterFrame', nave.ciclo_jogo )
	        	   botao_tiro:removeEventListener( 'touch', nave.atirar )
	        	   display.remove(self)
	        	   local game_over_image = display.newImageRect( 'gamer_over.jpg', 400, 800 )
	        	   game_over_image.x = centro_x
	        	   game_over_image.y = centro_y
	        	   game_over_image.alpha = 0
	        	   transition.to( game_over_image, {time = 2000, alpha = 1} ) 
	        	   timer.performWithDelay( 7000, function() 
	        	   	JOGO_RODANDO = 'reiniciando'
	        	   end, 1)
	        	  
	        	end
	        end
	    
	    elseif ( event.phase == "ended" ) then
	        print( "encerrou a colisão" )
	    end

	end
	 
	nave.collision = onLocalCollision
	nave:addEventListener( "collision" )

	return nave
end


-- Quem solicitar atraves do require recebe este script e acesso as funções
return Player