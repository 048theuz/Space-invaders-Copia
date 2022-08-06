local Itens = {}


function Itens.novo_coracao(grupo_jogo)
	local coracao = display.newImageRect( 'coracao.png', 35, 35 )
	coracao.x = math.random( 35,320 )
	coracao.y = 0
	coracao.id = 'coracao'
	physics.addBody( coracao, 'kinematic', {isSensor=true})
	grupo_jogo:insert(coracao)
	transition.to(coracao, { y=480, time=10000, onComplete= function()
	display.remove( coracao ) 
	end})

	return coracao
end

function Itens.novo_bomba(grupo_jogo)
	local bomba = display.newImageRect('bomba.png',45,45 )
	bomba.x = math.random( 35,320 )
	bomba.y = 0
	bomba.id = 'bomba'
	physics.addBody( bomba, 'kinematic', {isSensor=true})
	grupo_jogo:insert(bomba)
	transition.to(bomba, { y=480, time=10000, onComplete= function()
	display.remove( bomba ) 
	end})

	return bomba
end


return Itens