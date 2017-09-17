local restaurados = {"default:tree", "default:jungletree", "watershed:pinetree", "watershed:acaciatree"}

--self.selected_name = self.random_names[math.random(1, #self.random_names)]

minetest.register_abm({
	nodenames = restaurados,
	interval = 60, --padrao=60
	chance = 10, --padrao=10
	action = function(pos)
		for n, obj in pairs(restaurados) do 
			--print("[LUNOTREES] restaurados[n]="..restaurados[n])
			--print("[LUNOTREES] minetest.env:get_node(pos).name="..minetest.env:get_node(pos).name)
			if minetest.env:get_node(pos).name == restaurados[n] then
				local np1 = {x=pos.x,y=pos.y+1,z=pos.z}
				local np2 = {x=pos.x,y=pos.y-1,z=pos.z}
				if minetest.env:get_node(np2).name == "air" and minetest.env:get_node(np1).name == restaurados[n] then -- tem que haver duas madeiras(uma sobre a outra) para fazer crescer
					minetest.env:add_node(np2, {name=restaurados[n]})
				end
				break --isso poupa o "for" de fazer o restante das verificacoes.
			end
		end
	end,
})
