modAdminTag = {}
modAdminTag.player_invisible = { }
modAdminTag.nametagcolor_normal = { a=255, r=255, g=255, b=255 }
modAdminTag.nametagcolor_server = { a=255, r=255, g=0	 , b=0   }

minetest.register_privilege("nametaginvisible",  {
	description="Jogador deixar o nome do jogador invisivel", 
	give_to_singleplayer=false,
})

modAdminTag.setNametagColor = function(player)
	if player and player:is_player() then --Verifica se o player esta online
		local playername = player:get_player_name()
		if type(modAdminTag.player_invisible[playername])=="boolean" and modAdminTag.player_invisible[playername]==true then
			player:set_nametag_attributes({color={a=0,r=0,g=0,b=0}})
		else
			if minetest.get_player_privs(playername).server then
				player:set_nametag_attributes({color=modAdminTag.nametagcolor_server})
			else
				player:set_nametag_attributes({color=modAdminTag.nametagcolor_normal})
			end
		end
	end
end

modAdminTag.doChangeInvisible = function (playername)
	local player = minetest.get_player_by_name(playername)
	if player and player:is_player() then --Verifica se o player esta online
		modAdminTag.player_invisible[playername] = not modAdminTag.player_invisible[playername]
		modAdminTag.setNametagColor(player)
		if modAdminTag.player_invisible[playername] then
			minetest.chat_send_player(playername, "[ADMINTAG] O nametag de '"..playername.."' ficou invisivel!!")
		else
			minetest.chat_send_player(playername, "[ADMINTAG] O nametag de '"..playername.."' ficou visivel!")
		end
		return true
	else
		return false
	end
end

minetest.register_on_joinplayer(function(player)
	modAdminTag.setNametagColor(player)
end)

minetest.register_chatcommand("nametaginvisible", {
	params = "",
	description = "Deixa o nome do admin invisivel",
	privs = {nametaginvisible=true},
	func = function(playername, param)
		return modAdminTag.doChangeInvisible(playername)
	end,
})

minetest.register_chatcommand("nti", {
	params = "",
	description = "Deixa o nome do admin invisivel",
	privs = {nametaginvisible=true},
	func = function(playername, param)
		return modAdminTag.doChangeInvisible(playername)
	end,
})
