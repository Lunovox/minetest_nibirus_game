minetest.register_on_joinplayer(function(player)
	minetest.after(0, function()
		--FONTE: https://forum.minetest.net/viewtopic.php?f=5&t=7341&start=25&sid=8e2f32069d9dfbfc38084ca4a54fd5be
		local corDoReflexo = {r=0,g=0,b=0, a=255}
		local typesky = "skybox" --regular/plain/skybox
		player:set_sky(corDoReflexo,typesky, {
			"space_520x520.png", --> +Y(TOPO)
			"stars_500x500.png", --> -Y(FUNDO)
			"stars_500x500.png", --> +X(LESTE)
			"stars_500x500.png", --> -X(OESTE)
			"stars_500x500.png", --> -Z(SUL)
			"stars_500x500.png"  --> +Z(NORTE)
		})
	end)
end)


minetest.register_on_newplayer(function(player)
	give_initial_stuff.give(player)
end)

minetest.register_on_respawnplayer(function(player)
	give_initial_stuff.give(player)
end)
--[[ --]]
