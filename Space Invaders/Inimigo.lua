local Inimigo = {}
Inimigo.nmr_inimigos = 9
local centro_x = display.contentCenterX
local centro_y = display.contentCenterY

function Inimigo.novo( x, y, vida, grupo_jogo, botao )
	

		local direcao = 'direita'

		local nave_inimigo = display.newImageRect('nave_inimigo.png', 70, 70 )
		nave_inimigo.x = x
		nave_inimigo.y = y
		nave_inimigo.id = 'inimigo'
		physics.addBody(nave_inimigo,'dynamic', { isSensor=true} )
		grupo_jogo:insert(nave_inimigo)

		nave_inimigo.atirar = function ()
			if nave_inimigo.x ~= nil then
				local tiro_inimigo = display.newCircle( nave_inimigo.x, nave_inimigo.y, 5 )
				tiro_inimigo.id = 'tiro'
				physics.addBody( tiro_inimigo,'kinematic', { isSensor=true, isBullet=true, 5 })
				grupo_jogo:insert( tiro_inimigo )
				tiro_inimigo:setLinearVelocity( 0,300 )
			end
		end
		local sorteio_atraso_tiro = math.random( 3000, 5000 )

		nave_inimigo.timer_atirar = timer.performWithDelay(sorteio_atraso_tiro, nave_inimigo.atirar, 0, 'timer_tiro_inimigo')
		
		nave_inimigo.andar = function ()
			if nave_inimigo.x ~= nil then
		
			-- Verifica se a variável de direção do inimigo contem o valor "direita"
				if direcao == "direita" then
				nave_inimigo.x = nave_inimigo.x + 1
				nave_inimigo.y = nave_inimigo.y + 0.1

				-- se a posição x do inimigo for maior ou igual a 300
					if nave_inimigo.x >= 300  then
						direcao = "esquerda"
					end
				
			-- Verifica se a variável de direção do inimigo contem o valor "esquerda"
				elseif direcao == "esquerda" then
				
				  nave_inimigo.x = nave_inimigo.x - 1
				  nave_inimigo.y = nave_inimigo.y + 0.1

				-- se a posição x do inimigo for menor ou igual a 20
					if nave_inimigo.x <= 20 then
						direcao = "direita"
					end
				end
		
			else 
				Runtime:removeEventListener( 'enterFrame', nave_inimigo.andar )
			end
		end
		Runtime:addEventListener( "enterFrame", nave_inimigo.andar )

		local function Colisao_local(self, event)
			if ( event.phase == "began" ) then
	        print( "iniciou a colisão " )

	        	if  event.other.id == 'fire' then
	        		vida = vida - 10
	        		   display.remove(event.other)
	        		
	        		if vida < 5 then
		        	   timer.cancel(self.timer_atirar)
		        	   Runtime:removeEventListener( "enterFrame", self.andar )
		        	   display.remove(self)
					   Inimigo.nmr_inimigos = Inimigo.nmr_inimigos - 1

					   if Inimigo.nmr_inimigos <= 0 then
					   	  timer.cancel('timer_coracao')
					   	  timer.cancel('timer_bomba')
					   	  local win = display.newImageRect( 'win2.jpg', 400, 800 )
					   	  win.x = centro_x
					   	  win.y = centro_y
					   	  win.alpha = 0
					   	  transition.to( win, {time = 1000, alpha = 1} )
	        	    	  transition.to( botao_replay, {time = 2000, alpha = 1} ) 
	        	    	  transition.to( botao_replay, {time = 2000, alpha = 1} ) 
	        	    	  display.remove( grupo_jogo )
	        	    	  timer.performWithDelay( 7000, function() 

	        	    	  	JOGO_RODANDO = 'reiniciando'

	        	    	  end, 1 )
					   	 
					   end	  
					end
	        	end
	    
	    	elseif ( event.phase == "ended" ) then
	            print( "encerrou a colisão" )

	    	end
	    end


	 
	nave_inimigo.collision = Colisao_local
	nave_inimigo:addEventListener( "collision" )

	return nave_inimigo
end

-- Quem solicitar atraves do require recebe este script e acesso as funções
return Inimigo