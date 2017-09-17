--minetest.log('action',"[LUNOTREES] Adicionando 'farming:seed_cotton' e 'farming:seed_wheat' ao drop de 'default:grass_1'...")

for i = 1, 5 do		
	minetest.override_item("default:grass_"..i, {
		drop = {
			max_items = 1,
			items = {
				{items = {'farming:seed_wheat'},rarity = 5}, -- Raridade de 1 a cada 5
				{items = {'farming:seed_cotton'},rarity = 8}, -- Raridade de 1 a cada 8
				{items = {'default:grass_1'}},
			}
		}
	})
end


