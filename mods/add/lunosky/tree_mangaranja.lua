minetest.register_node("lunosky:mangaranja", {
	description = "Mangaranja (Parece Manga por fora, mas eh Laranja por dentro)",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"text_mangaranja.png"},
	inventory_image = "text_mangaranja.png",
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 5, -- <-- Essa Linha faz brilhar no escuro.
	--light_source = LIGHT_MAX, -- <-- Essa Linha faz brilhar no escuro.
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
	on_use = minetest.item_eat(2),
	--[[
	on_use = function(itemstack, user, pointed_thing)
		if minetest.get_modpath("modhunger") ~= nil then
			return modhunger.doEat(user, itemstack, {add_stamin=2, eat_sound="obj_chew",})
		else
			return minetest.item_eat(2)
		end
	end,
	--]]
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name="lunosky:mangaranja", param2=1})
		end
	end,
})

--#########################################################################################################

minetest.register_node("lunosky:mangaranja_leaves", {
	description = "Folhas de Mangaranja",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"text_mangaranja_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'lunosky:mangaranja_sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'lunosky:mangaranja_leaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

--#########################################################################################################

minetest.register_node("lunosky:mangaranja_sapling", {
	description = "Muda de Mangaranja",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"text_mangaranja_sapling.png"},
	inventory_image = "text_mangaranja_sapling.png",
	wield_image = "text_mangaranja_sapling.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_alias("mudademangaranja"		, "lunosky:mangaranja_sapling")

--#########################################################################################################

mangaranja={
	--axiom="FFFFFAFFBF",
	axiom="FFFFFFFFFAFFBF",
	rules_a="[&&&FFFFF&&FFFF][&&&++++FFFFF&&FFFF][&&&----FFFFF&&FFFF]",
	rules_b="[&&&++FFFFF&&FFFF][&&&--FFFFF&&FFFF][&&&------FFFFF&&FFFF]",
	trunk="default:tree",
	leaves="lunosky:mangaranja_leaves",
	angle=30,
	iterations=2,
	random_level=0,
	trunk_type="single",
	thin_branches=true,
	--fruit_chance=50,
	fruit_chance=5,
	fruit="lunosky:mangaranja"
}

minetest.register_alias("mangaranja"		, "lunosky:mangaranja")

--#########################################################################################################

minetest.register_abm({
	nodenames = {"lunosky:mangaranja_sapling"},
	interval = 10,
	chance = 50,
	action = function(pos, node)
		minetest.add_node(pos, {name = "air"} )
		minetest.spawn_tree(pos,mangaranja)
		--print("[lunosky] Nova arvore em ("..pos.x..", "..pos.y..", "..pos.z..")")
	end
})

--#########################################################################################################

--[[ 
minetest.register_craftitem("lunosky:spawner", {
	description = "Treespawner",
	inventory_image = "default_stick.png",
	on_use = function(itemstack, user, pointed_thing)
		local pos = pointed_thing.under
		minetest.spawn_tree(pos,mangaranja)
		print("[lunosky] Nova arvore em ("..pos.x..", "..pos.y..", "..pos.z..")")
	end
})
--]]
