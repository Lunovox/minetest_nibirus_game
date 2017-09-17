local recipes = {"default:tree", "default:jungletree", "watershed:pinetree", "watershed:acaciatree"} --Materiais q deve ser queimados

--Faz carvao queimando lenhas!!!!

minetest.register_craftitem(":default:coal_lump", {
	description = "Pepita de Carvao",
	inventory_image = "default_coal_lump.png",
	liquids_pointable = true, -- Pode apontar para node de Liquidos (mais tarde podera coletar agua)
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under~=nil then
			local node = minetest.get_node(pointed_thing.under)
			--minetest.chat_send_player(user:get_player_name(), "Voce esta apontando para '".. node.name .."'!")
			if node.name == "default:water_source" or node.name == "default:water_flowing" then
				minetest.sound_play("sfx_water", {
					pos=user:getpos(),
					gain = 6.0,
					max_hear_distance = 5,
				})
				user:get_inventory():add_item("main", ItemStack("dye:dark_grey"))
				itemstack:take_item()
				return itemstack
			else
				minetest.chat_send_player(user:get_player_name(), "Voce nao pode molhar esse carvao aqui!")
				--minetest.sound_play("sound_healing", {pos=user.pos, max_hear_distance = 30}) --toca som "sound_healing".ogg a distancia de 30 blocos do usuario.
				return
			end
		end
	end,
})

for n, obj in pairs(recipes) do 
	minetest.register_craft({
		type = "cooking",
		output = "default:coal_lump",
		recipe = recipes[n],
		cooktime = 2, --2 segundos de queima
	})
end

minetest.log('action',"[MODIFY_COAL] Reinstanciando funcao 'on_use()' no 'carvao' do mod 'default'...")
