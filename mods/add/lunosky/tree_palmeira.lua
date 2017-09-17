minetest.register_node("lunosky:coconut", {
	description = "Coco",
	drawtype = "plantlike",
	tiles = { "text_coconut.png" },
	inventory_image = "text_coconut.png^[transformR180",
	wield_image = "text_coconut.png^[transformR180",
	visual_scale = 1.0,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
			fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
		},
	groups = {fleshy=3,dig_immediate=3,flammable=2, attached_node=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("lunosky:palmeira_leaves", {
	description = "Folha de Palmeira",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = { "text_palm_leaves.png" },
	--inventory_image = moretrees_leaves_inventory_image,
	paramtype = "light",
	is_ground_content = false,
	--groups = {snappy=3, flammable=2, leaves=1, moretrees_leaves=1},
	groups = {snappy=3, leafdecay=8, flammable=2, leaves=1},
	sounds = default.node_sound_leaves_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {"lunosky:palmeira_sapling"}, rarity = 20 },
			{items = {"lunosky:palmeira_leaves"} }
		}
	},
})

local defPalmeira={
	axiom="FFcccccc&FFFFFddd[^&&&GR][^///&&&GR][^//////&&&GR][^***&&&GR]FA//A//A//A//A//A",
	rules_a="[&fb&bbb[++f--&ffff&ff][--f++&ffff&ff]&ffff&bbbb&b]",
	rules_b="f",
	rules_c="/",
	rules_d="F",
	trunk="default:tree",
	leaves="lunosky:palmeira_leaves",
	angle=30,
	iterations=2,
	random_level=0,
	trunk_type="single",
	thin_branches=true,
	fruit="lunosky:coconut",
	fruit_chance=0
}


--#########################################################################################################

--#########################################################################################################


minetest.register_craftitem("lunosky:spawner_palmeira", {
	description = "Gerador de Palmeira",
	inventory_image = "default_stick.png",
	on_use = function(itemstack, user, pointed_thing)
		local pos = pointed_thing.under
		if type(defPalmeira)=="table" then
			minetest.spawn_tree(pos,defPalmeira)
			print("[lunosky] Nova Palmeira em ("..pos.x..", "..pos.y..", "..pos.z..")")
		end
	end
})

minetest.register_alias("geradordepalmeira"		, "lunosky:spawner_palmeira")
minetest.register_alias("varinhadepalmeira"		, "lunosky:spawner_palmeira")

