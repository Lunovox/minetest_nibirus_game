minetest.register_privilege("savevars", "Permite que o jogador edite variaveis por linha de comando.")

if not (core.setting_getbool("savevars_log")~=true) then 
	core.setting_setbool("savevars_log", false)
	core.setting_save() 
end

modsavevars = { }
modsavevars.fileVariables = minetest.get_worldpath().."/variables.tbl"
modsavevars.variables={  global={}, players={} 	}
modsavevars.doOpen = function()
	local file = io.open(modsavevars.fileVariables, "r")
	if file then
		local table = minetest.deserialize(file:read("*all"))
		file:close()
		if type(table) == "table" then
			modsavevars.variables = table
			return
		end
		--minetest.log('action',"[SAVEVARS] doOpen("..modsavevars.fileVariables.."')")
		minetest.log('action',"[SAVEVARS] Abrindo '"..modsavevars.fileVariables.."' !")
		if core.setting_getbool("savevars_log") then 
			minetest.log('action',"doOpen("..modsavevars.fileVariables.."')") 
		end
	end
end
modsavevars.doSave = function()
	--file = io.open(modsavevars.fileVariables,"a+")
	local file = io.open(modsavevars.fileVariables,"w")
	if file then
		file:write(minetest.serialize(modsavevars.variables))
		file:close()
	else
		minetest.log('error',"[SAVEVARS:ERROR] Não foi possivel salvar o arquivo '"..modsavevars.fileVariables.."'!")
	end
end

modsavevars.getAllDBChars = function() --Criado para o mod 'correio'
	return modsavevars.variables.players
end
modsavevars.setAllDBChars = function(tblPlayers) --Criado para o mod 'correio'
	modsavevars.variables.players = tblPlayers
end

modsavevars.setGlobalValue = function(variavel, valor)
	if modsavevars.variables.global==nil then
		modsavevars.variables.global = {}
	end
	if valor~=nil or modsavevars.variables.global[variavel]~=nil then --Verifica se nao ja estava apagada
		if type(valor)=="number" then valor = valor * 1 end --para transformar em numero
		modsavevars.variables.global[variavel] = valor
		if core.setting_getbool("savevars_log") then
			if valor~= nil then
				minetest.log('action',"modsavevars.setGlobalValue("..variavel.."='"..dump(valor).."')")
			else
				minetest.log('action',"modsavevars.setGlobalValue("..variavel.."=nil)")
			end
		end
	end
	--modsavevars.doSave() --Salva quando desliga o server ou quando sai o jogador
end
modsavevars.getGlobalValue = function(variavel)
	if modsavevars.variables.global~=nil and modsavevars.variables.global[variavel]~=nil then
		local valor = modsavevars.variables.global[variavel]
		if core.setting_getbool("savevars_log") then
			minetest.log('action',"modsavevars.getGlobalValue("..variavel..") = '"..dump(valor).."'")
		end
		return valor
	end
	return nil
end
modsavevars.setCharValue = function(charName, variavel, valor)
	if modsavevars.variables.players[charName] == nil then
		modsavevars.variables.players[charName] = {}
	end
	if valor~=nil or modsavevars.variables.players[charName][variavel]~=nil then --Verifica se nao ja estava apagada
		modsavevars.variables.players[charName][variavel] = valor
		if core.setting_getbool("savevars_log") then
			if valor~= nil then
				minetest.log('action',"modsavevars.setCharValue("..charName..":"..variavel.."='"..dump(valor).."')")
			else
				minetest.log('action',"modsavevars.setCharValue("..charName..":"..variavel.."=nil)")
			end
		end
	end
	--modsavevars.doSave() --Salva quando desliga o server ou quando sai o jogador
end

modsavevars.getCharValue = function(charName, variavel)
	if modsavevars.variables.players[charName]~=nil and modsavevars.variables.players[charName][variavel]~=nil then
		local valor = modsavevars.variables.players[charName][variavel]
		if core.setting_getbool("savevars_log") then
			minetest.log('action',"modsavevars.getCharValue("..charName..":"..variavel..") = '"..dump(valor).."'")
		end
		return valor
	end
	return nil
end

minetest.register_on_joinplayer(function(player)
	modsavevars.doSave()
end)

minetest.register_on_leaveplayer(function(player)
	modsavevars.doSave()
end)

minetest.register_on_shutdown(function()
	modsavevars.doSave()
	minetest.log('action',"[SAVEVARS] Salvando banco de dados de todos os jogadores em '"..modsavevars.fileVariables.."' !")
end)

modsavevars.doOpen()
