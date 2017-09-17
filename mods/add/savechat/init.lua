local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

modSaveChat = {}

modSaveChat.onSendWhisper = function(playername, param)
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

minetest.register_chatcommand("msg", {
	params = "",
	description = "/msg <jogador> <mensagem> : Manda um sussurro (mensagem privada) para um jogador específico!",
	func = function(playername, param)
		return modSaveChat.onSendWhisper(playername, param)
	end,
})

minetest.register_chatcommand("whisper", {
	params = "",
	description = "/whisper <jogador> <mensagem> : Manda um sussurro (mensagem privada) para um jogador específico!",
	func = function(playername, param)
		return modSaveChat.onSendWhisper(playername, param)
	end,
})

minetest.log('action',"["..modname:upper().."] Carregado!")
