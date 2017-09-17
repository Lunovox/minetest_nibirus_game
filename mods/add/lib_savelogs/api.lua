modSaveLogs.doSave = function()
	if modSaveLogs.txtIncrease~="" then
		local fileName = "log_"..os.date("%Y-%m-%d")..".txt"
		local logFile = minetest.get_worldpath().."/"..fileName
		if type(modSaveLogs.savePath)=="string" and modSaveLogs.savePath~="" then logFile = modSaveLogs.savePath.."/"..fileName end
		local file = io.open(logFile,"a+") --Registra no final do arquivo!!!
		if file then
			file:write(modSaveLogs.txtIncrease)
			file:flush() --<= Nao sei se esta linha esta ajudando!!!
			file:close()
			modSaveLogs.txtIncrease = ""
		else
			minetest.log('error',"[LIB_SAVELOGS] Nao foi possivel abrir o arquivo '"..logFile.."'!")
		end
	end
end

modSaveLogs.getPosResumed = function(pos)
	if pos and pos.x and pos.y and pos.z then
		local newPos = pos
		newPos.x = math.floor(newPos.x)
		newPos.y = math.floor(newPos.y)
		newPos.z = math.floor(newPos.z)
		return newPos
	end
	return pos	
end

modSaveLogs.addLog = function(message, noTime)
	if type(message)=="string" and message~="" then
		if type(modSaveLogs.txtIncrease)~="string" then 
			modSaveLogs.txtIncrease=""	
		end
		
		if type(noTime)=="boolean" and noTime==true then
			modSaveLogs.txtIncrease = modSaveLogs.txtIncrease .. "\n"..message
		else
			modSaveLogs.txtIncrease = modSaveLogs.txtIncrease .. "\n"..os.date("%Hh:%Mm:%Ss").." "..message
		end
	end
end

--[[
modSaveLogs.onSendWhisper = function(playername, param)
	if param~=nil and type(param)=="string" and param~="" then
		local fromPlayer = minetest.get_player_by_name(playername)
		if not fromPlayer then
			return true, "[WHISPER:ERROR] Erro desconhecido!!!"
		end
		local fromPos = modSaveLogs.getPosResumed(fromPlayer:getpos())
		
		local toName, message = string.match(param, "([%a%d_]+) (.+)")
	
		if not toName or not message then
			--minetest.chat_send_player(playername,"/mail <jogador> <mensagem>")
			return true, "/whisper <jogador> <mensagem> : Manda um sussurro (mensagem privada) para um jogador específico!"
		end

		local toPlayer = minetest.get_player_by_name(toName)
		if not toPlayer then
			return true, "[WHISPER:ERROR] O jogador '"..toName.."' não está online para receber o seu sussurro!"
		end
		local toPos = modSaveLogs.getPosResumed(toPlayer:getpos())
		
		
		if type(modSaveLogs.savePosOfSpeaker)=="boolean" and modSaveLogs.savePosOfSpeaker==true  then
			modSaveLogs.addLog(
				"<whisper:"
					..playername..minetest.pos_to_string(fromPos)
					.."→"
					..toName..minetest.pos_to_string(toPos)
				.."> "..message)
		else
			modSaveLogs.addLog("<whisper:"..playername.."→"..toName.."> "..message)
		end
		minetest.chat_send_player(toName,"Sussuro de '"..playername.."': "..message)
		--return true, "Sussuro de '"..playername.."': "..message
		return true
	end
	return true, "/whisper <jogador> <mensagem> : Manda um sussurro (mensagem privada) para um jogador específico!"
end
--]]

--[[
minetest.register_on_chat_message(function(playername, message)
	if type(message)=="string" and message~="" then
		local player = minetest.get_player_by_name(playername)
		if 
			type(modSaveLogs.savePosOfSpeaker)=="boolean" and modSaveLogs.savePosOfSpeaker==true 
			and player and player:is_player() --Verifica se o player ainda esta online!
		then
			local pos = player:getpos()
			modSaveLogs.addLog("<"..playername.."> "..message.." "..minetest.pos_to_string(modSaveLogs.getPosResumed(pos)))
		else
			modSaveLogs.addLog("<"..playername.."> "..message)
		end
	end
end)
--]]

minetest.register_globalstep(function(dtime)
	if type(modSaveLogs.timeLeft)~="number" then	modSaveLogs.timeLeft=0 end
	if modSaveLogs.timeLeft <= 0 then
		modSaveLogs.timeLeft = modSaveLogs.timeLeft + modSaveLogs.saveInterval
		modSaveLogs.doSave()
	else
		modSaveLogs.timeLeft = modSaveLogs.timeLeft - dtime
	end
end)

minetest.register_on_joinplayer(function(player)
	if type(modSaveLogs.savePosOfSpeaker)=="boolean" and modSaveLogs.savePosOfSpeaker==true  then
		modSaveLogs.addLog("<server:login> "..player:get_player_name().." entrou no servidor! "..minetest.pos_to_string(modSaveLogs.getPosResumed(player:getpos())))
	else
		modSaveLogs.addLog("<server:login> "..player:get_player_name().." entrou no servidor!")
	end
	modSaveLogs.doSave()
end)

minetest.register_on_leaveplayer(function(player)
	if type(modSaveLogs.savePosOfSpeaker)=="boolean" and modSaveLogs.savePosOfSpeaker==true  then
		modSaveLogs.addLog("<server:logout> "..player:get_player_name().." saiu do servidor! "..minetest.pos_to_string(modSaveLogs.getPosResumed(player:getpos())))
	else
		modSaveLogs.addLog("<server:logout> "..player:get_player_name().." saiu do servidor!")
	end
	modSaveLogs.doSave()
end)

minetest.register_on_shutdown(function()
	modSaveLogs.addLog("<server:shutdown> O servidor desligou!")
	modSaveLogs.doSave()
end)

modSaveLogs.addLog("--------------------------------------------------------------------------------------------------------------", true)
modSaveLogs.addLog("<server:activate> O servidor recem ativado!")
