minetest.register_node("lunosky:sakuraba_sapling", {
	description = "Muda de sakuraba",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"text_sakuraba_sapling.png"},
	inventory_image = "text_sakuraba_sapling.png",
	wield_image = "text_sakuraba_sapling.png",
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

minetest.register_alias("mudadesakuraba"		, "lunosky:sakuraba_sapling")

--#########################################################################################################

minetest.register_node("lunosky:sakuraba_leaves", {
	description = "Folhas de Sakuraba",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"text_sakuraba_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'lunosky:sakuraba_sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'lunosky:sakuraba_leaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

minetest.register_alias("folhadesakuraba"		, "lunosky:sakuraba_leaves")

--#########################################################################################################

treedef={
   axiom="FFFFFFccccA",
   rules_a = "[B]//[B]//[B]//[B]",
   rules_b = "&TTTT&TT^^G&&----GGGGGG++GGG++"   -- line up with the "canvas" edge
         .."fffffffGG++G++"               -- first layer, drawn in a zig-zag raster pattern
         .."Gffffffff--G--"
         .."ffffffffG++G++"
         .."fffffffff--G--"
         .."fffffffff++G++"
         .."fffffffff--G--"
         .."ffffffffG++G++"
         .."Gffffffff--G--"
         .."fffffffGG"
         .."^^G&&----GGGGGGG++GGGGGG++"      -- re-align to second layer canvas edge
         .."ffffGGG++G++"               -- second layer
         .."GGfffff--G--"
         .."ffffffG++G++"
         .."fffffff--G--"
         .."ffffffG++G++"
         .."GGfffff--G--"
         .."ffffGGG",
   rules_c = "/",
   trunk="default:tree",
   leaves="lunosky:sakuraba_leaves",
   angle=45,
   iterations=3,
   random_level=0,
   trunk_type="single",
   thin_branches=true,
   --fruit_chance=5,
   --fruit="default:apple",
}


--#########################################################################################################

minetest.register_abm({
	nodenames = {"lunosky:sakuraba_sapling"},
	interval = 10,
	chance = 50,
	action = function(pos, node)
		minetest.add_node(pos, {name = "air"} )
		minetest.spawn_tree(pos,treedef)
		--print("[lunosky] Nova arvore em ("..pos.x..", "..pos.y..", "..pos.z..")")
	end
})

--#########################################################################################################


minetest.register_craftitem("lunosky:spawner_sakuraba", {
	description = "Varinha de Sakuraba",
	inventory_image = "default_stick.png",
	on_use = function(itemstack, user, pointed_thing)
		local pos = pointed_thing.under
		minetest.spawn_tree(pos,treedef)
		print("[lunosky] Nova arvore em ("..pos.x..", "..pos.y..", "..pos.z..")")
	end
})

minetest.register_alias("geradordesakuraba"		, "lunosky:spawner_sakuraba")
minetest.register_alias("varinhadesakuraba"		, "lunosky:spawner_sakuraba")
