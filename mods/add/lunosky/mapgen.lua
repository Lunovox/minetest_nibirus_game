minetest.clear_registered_biomes()
minetest.clear_registered_decorations()

--[[ --]]
minetest.register_on_mapgen_init(function(mgparams)
	
	--print(dump(mgparams))
	
	minetest.set_mapgen_params({
		seed="lunovox",
		water_level="1",
		--chunksize="5",
		--flags="nolight", --FONTE: http://dev.minetest.net/Mapgen_Parameters
		flags="trees, caves, dungeons, noflat, nolight, v6_jungles, v6_biome_blend, v7_mountains, v7_ridges",
		--flags="trees, caves, dungeons, noflat, light", 
		--mgname="singlenode",
		--mg_name = "indev",
		mgname="v7",  
		enable_floating_dungeons = false,
	})
end)
--[[ --]]


--
-- Biomes: 
--				glacier, glacier_ocean, tundra, tundra_ocean, taiga, taiga_ocean, 
--				stone_grassland, stone_grassland_ocean, coniferous_forest, coniferous_forest_ocean, 
--				sandstone_grassland, sandstone_grassland_ocean, deciduous_forest, deciduous_forest_ocean, 
--				desert, desert_ocean, savanna, savanna_ocean, 
--				rainforest, rainforest_swamp, rainforest_ocean, 
--				underground
--				
--

minetest.register_node("lunosky:dirt_poisoned", {
	description = "Luno Dirt",
	tiles = {"default_dirt.png"},
	is_ground_content = true,
	groups = {crumbly=3,soil=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("lunosky:dirt_with_poisongrass", {
	description = "Terra com Grama Venenosa",
	tiles = {"text_poisongrass_top.png", "default_dirt.png", "default_dirt.png^text_poisongrass_side.png"},
	is_ground_content = true,
	groups = {crumbly=3,soil=1},
	drop = 'lunosky:dirt_poisoned',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.25},
	}),
})

minetest.register_node("lunosky:poisongrass", {
	description = "Grama Venenosa",
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"text_poisongrass_item.png"},
	inventory_image = "text_poisongrass_item.png",
	wield_image = "text_poisongrass_item.png",
	paramtype = "light",
	light_source = 4, -- <-- Essa Linha faz brilhar no escuro.
	--light_source = LIGHT_MAX, -- <-- Essa Linha faz brilhar no escuro.
	walkable = false,
	buildable_to = true,
	is_ground_content = true,
	damage_per_second = 1 * 2, -- <-- Mesmo dano que a lava 
	post_effect_color = {a = 191, r = 255, g = 0, b = 255},
	groups = {snappy=3,flammable=2,flora=1,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})

minetest.register_biome({
	name = "lunoland",
	--node_dust = "",
	node_top = "lunosky:dirt_with_poisongrass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 6,
	y_max = 31000,
	heat_point = 45,
	humidity_point = 70,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"lunosky:dirt_with_poisongrass"},
	sidelen = 80,
	fill_ratio = 0.1,
	biomes = {"lunoland"},
	y_min = 1,
	y_max = 31000,
	decoration = "lunosky:poisongrass",
})


minetest.register_decoration({
	deco_type = "simple",
	place_on = {"lunosky:dirt_with_poisongrass"},
	sidelen = 16,
	noise_params = {
		--offset = -0.02, scale = 0.03,	spread = {x=100, y=100, z=100},
		offset = 0.04, scale = 0.02, spread = {x=250, y=250, z=250},
		seed = 777, --Padrão: 436
		octaves = 3,
		persist = 0.6
	},
	biomes = {"lunoland"},
	y_min = 6,
	y_max = 31000,
	decoration = "lunosky:mangaranja_sapling",
	flags = "place_center_x, place_center_z",
})

--[[
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0.04, scale = 0.02, spread = {x=250, y=250, z=250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"deciduous_forest"},
	y_min = 6,
	y_max = 31000,
	schematic = minetest.get_modpath("lunosky").."/schematics/appletree.mts", --Ok!
	flags = "place_center_x, place_center_z",
})
--]]


minetest.register_abm({
	nodenames = {"lunosky:dirt_poisoned"},
	interval = 2,
	chance = 200,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if nodedef and (nodedef.sunlight_propagates or nodedef.paramtype == "light")
				and nodedef.liquidtype == "none"
				and (minetest.get_node_light(above) or 0) >= 13 then
			if name == "default:snow" or name == "default:snowblock" then
				minetest.set_node(pos, {name = "default:dirt_with_snow"})
			else
				minetest.set_node(pos, {name = "lunosky:dirt_with_poisongrass"})
			end
		end
	end
})

--[[
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"lunosky:dirt_with_poisongrass"},
	sidelen = 16,
	noise_params = {
		offset = 0.04,
		scale = 0.02,
		spread = {x=250, y=250, z=250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"lunoland"},
	y_min = 6,
	y_max = 31000,
	schematic = minetest.get_modpath("lunosky").."/schematics/bananatree.mts",
	flags = "place_center_x, place_center_z",
})
]]--

--[[
minetest.register_node("lunosky:chest_quest", {
	description = "Bau de Calabouco",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		--meta:set_string("formspec", chest_formspec)
		meta:set_string("infotext", "Bau de Calabouco")
		--local inv = meta:get_inventory()
		--inv:set_size("main", 8*4)
	end,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:mossycobble", "default:cobble"},
	sidelen = 16,
	noise_params = {
		offset = -0.02,
		scale = 0.03,
		spread = {x=100, y=100, z=100},
		seed = 777, --Padrão: 436
		octaves = 3,
		persist = 0.6
	},
	biomes = {"dungeon","glacier","glacier_ocean","tundra","tundra_ocean","taiga","taiga_ocean",},
	y_min = 6,
	y_max = 31000,
	decoration = "lunosky:chest_quest",
	flags = "place_center_x, place_center_z, force_placement",
	--enable_floating_dungeons = false,
})
]]--

--#####################################################################################################################


-- Permanent ice

minetest.register_biome({
	name = "glacier",
	node_dust = "default:snowblock",
	node_top = "default:snowblock",
	depth_top = 1,
	node_filler = "default:snowblock",
	depth_filler = 3,
	node_stone = "default:ice",
	node_water_top = "default:ice",
	depth_water_top = 8,
	--node_water = "",
	y_min = -6,
	y_max = 31000,
	heat_point = -5,
	humidity_point = 50,
})

minetest.register_biome({
	name = "glacier_ocean",
	node_dust = "default:snowblock",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = -7,
	heat_point = -5,
	humidity_point = 50,
})

-- Cold

minetest.register_biome({
	name = "tundra",
	node_dust = "default:snow",
	node_top = "default:dirt_with_snow",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 0,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 2,
	y_max = 31000,
	heat_point = 20,
	humidity_point = 30,
})

minetest.register_biome({
	name = "tundra_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 1,
	heat_point = 20,
	humidity_point = 30,
})

minetest.register_biome({
	name = "taiga",
	node_dust = "default:snow",
	node_top = "default:snowblock",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 2,
	y_max = 31000,
	heat_point = 20,
	humidity_point = 70,
})

minetest.register_biome({
	name = "taiga_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 1,
	heat_point = 20,
	humidity_point = 70,
})

-- Cool

minetest.register_biome({
	name = "stone_grassland",
	--node_dust = "",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 0,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 6,
	y_max = 31000,
	heat_point = 45,
	humidity_point = 30,
})

minetest.register_biome({
	name = "stone_grassland_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 5,
	heat_point = 45,
	humidity_point = 30,
})

minetest.register_biome({
	name = "coniferous_forest",
	--node_dust = "",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 6,
	y_max = 31000,
	heat_point = 45,
	humidity_point = 70,
})

minetest.register_biome({
	name = "coniferous_forest_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 5,
	heat_point = 45,
	humidity_point = 70,
})

-- Warm

minetest.register_biome({
	name = "sandstone_grassland",
	--node_dust = "",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 0,
	node_stone = "default:sandstone",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 6,
	y_max = 31000,
	heat_point = 70,
	humidity_point = 30,
})

minetest.register_biome({
	name = "sandstone_grassland_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	node_stone = "default:sandstone",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 5,
	heat_point = 70,
	humidity_point = 30,
})

minetest.register_biome({
	name = "deciduous_forest",
	--node_dust = "",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 6,
	y_max = 31000,
	heat_point = 70,
	humidity_point = 70,
})

minetest.register_biome({
	name = "deciduous_forest_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 5,
	heat_point = 70,
	humidity_point = 70,
})

-- Hot

minetest.register_biome({
	name = "desert",
	--node_dust = "",
	node_top = "default:desert_sand",
	depth_top = 1,
	node_filler = "default:desert_sand",
	depth_filler = 1,
	node_stone = "default:desert_stone",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 1,
	y_max = 31000,
	heat_point = 95,
	humidity_point = 10,
})

minetest.register_biome({
	name = "desert_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	node_stone = "default:desert_stone",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 0,
	heat_point = 95,
	humidity_point = 10,
})

minetest.register_biome({
	name = "savanna",
	--node_dust = "",
	node_top = "default:dirt_with_dry_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 1,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 5,
	y_max = 31000,
	heat_point = 95,
	humidity_point = 50,
})

minetest.register_biome({
	name = "savanna_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = 4,
	heat_point = 95,
	humidity_point = 50,
})

minetest.register_biome({
	name = "rainforest",
	--node_dust = "",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 1,
	y_max = 31000,
	heat_point = 95,
	humidity_point = 90,
})

minetest.register_biome({
	name = "rainforest_swamp",
	--node_dust = "",
	node_top = "default:dirt",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 0,
	y_max = 0,
	heat_point = 95,
	humidity_point = 90,
})

minetest.register_biome({
	name = "rainforest_ocean",
	--node_dust = "",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 2,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -112,
	y_max = -1,
	heat_point = 95,
	humidity_point = 90,
})

-- Underground

minetest.register_biome({
	name = "underground",
	--node_dust = "",
	--node_top = "",
	depth_top = 0,
	--node_filler = "",
	depth_filler = -4,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = -31000,
	y_max = -113,
	heat_point = 50,
	humidity_point = 50,
})

--
-- Decorations
--

-- Apple tree
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0.04,
		scale = 0.02,
		spread = {x=250, y=250, z=250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"deciduous_forest"},
	y_min = 6,
	y_max = 31000,
	schematic = minetest.get_modpath("lunosky").."/schematics/appletree.mts", --Ok!
	flags = "place_center_x, place_center_z",
})

-- Jungle tree

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt"},
	sidelen = 80,
	fill_ratio = 0.09,
	biomes = {"rainforest", "rainforest_swamp"},
	y_min = 0,
	y_max = 31000,
	schematic = minetest.get_modpath("lunosky").."/schematics/jungletree.mts", --Ok!
	flags = "place_center_x, place_center_z",
})

-- Taiga and temperate forest pine tree

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:snowblock", "default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0.04,
		scale = 0.02,
		spread = {x=250, y=250, z=250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	--biomes = {"taiga", "coniferous_forest"},
	biomes = {"tundra", "taiga"},
	y_min = 2,
	y_max = 31000,
	schematic = minetest.get_modpath("lunosky").."/schematics/snowtree.mts", --Ok!
	flags = "place_center_x, place_center_z",
})

--[[
-- Acacia tree

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_dry_grass"},
	sidelen = 80,
	noise_params = {
		offset = 0.001,
		scale = 0.0015,
		spread = {x=250, y=250, z=250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"savanna"},
	y_min = 6,
	y_max = 31000,
	schematic = minetest.get_modpath("lunosky").."/schematics/acaciatree.mts", --bugado
	flags = "place_center_x, place_center_z",
	rotation = "random",
})
]]--


-- Large cactus

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:desert_sand"},
	sidelen = 80,
	noise_params = {
		offset = -0.0005,
		scale = 0.0015,
		spread = {x=200, y=200, z=200},
		seed = 230,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"desert"},
	y_min = 2,
	y_max = 31000,
	schematic = minetest.get_modpath("lunosky").."/schematics/large_cactus.mts",  --Ok!
	flags = "place_center_x",
	rotation = "random",
})

-- Cactus

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:desert_sand"},
	sidelen = 80,
	noise_params = {
		offset = -0.0005,
		scale = 0.0015,
		spread = {x=200, y=200, z=200},
		seed = 230,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"desert"},
	y_min = 2,
	y_max = 31000,
	decoration = "default:cactus",
	height = 2,
        height_max = 5,
})

-- Papyrus

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:sand"},
	sidelen = 16,
	noise_params = {
		offset = -0.3,
		scale = 0.7,
		spread = {x=200, y=200, z=200},
		seed = 354,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"savanna_ocean"},
	y_min = 0,
	y_max = 0,
	schematic = {
		size = {x = 1, y = 7, z = 1},
		data = {
			{name = "default:dirt", prob = 255, force_place = true},
			{name = "default:dirt_with_grass", prob = 255, force_place = true},
			{name = "default:papyrus", prob = 255},
			{name = "default:papyrus", prob = 255},
			{name = "default:papyrus", prob = 255},
			{name = "default:papyrus", prob = 255},
			{name = "default:papyrus", prob = 255},
		},
		yslice_prob = {
                	{ypos = 2, prob = 127},
                	{ypos = 3, prob = 127},
		},
	},
})

-- Flowers

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.02,
		scale = 0.03,
		spread = {x=200, y=200, z=200},
		seed = 436,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"stone_grassland", "sandstone_grassland"},
	y_min = 6,
	y_max = 31000,
	decoration = "flowers:rose",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.02,
		scale = 0.03,
		spread = {x=200, y=200, z=200},
		seed = 19822,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"stone_grassland", "sandstone_grassland"},
	y_min = 6,
	y_max = 31000,
	decoration = "flowers:tulip",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.02,
		scale = 0.03,
		spread = {x=200, y=200, z=200},
		seed = 1220999,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"stone_grassland", "sandstone_grassland"},
	y_min = 6,
	y_max = 31000,
	decoration = "flowers:dandelion_yellow",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.02,
		scale = 0.03,
		spread = {x=200, y=200, z=200},
		seed = 36662,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"deciduous_forest", "coniferous_forest"},
	y_min = 6,
	y_max = 31000,
	decoration = "flowers:geranium",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.02,
		scale = 0.03,
		spread = {x=200, y=200, z=200},
		seed = 1133,
		octaves = 3,
		persist = 0.6
	},
	biomes = {
		"stone_grassland",
		"sandstone_grassland",
		"deciduous_forest",
		"coniferous_forest"
	},
	y_min = 6,
	y_max = 31000,
	decoration = "flowers:viola",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.02,
		scale = 0.03,
		spread = {x=200, y=200, z=200},
		seed = 73133,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"stone_grassland", "sandstone_grassland"},
	y_min = 6,
	y_max = 31000,
	decoration = "flowers:dandelion_white",
})

-- Grasses

local function register_grass_decoration(noffset, nscale, length)
	minetest.register_decoration({
		deco_type = "simple",
		--place_on = {"default:dirt_with_grass", "default:sand"},
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = noffset,
			scale = nscale,
			spread = {x=200, y=200, z=200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {
			"stone_grassland", "stone_grassland_ocean",
			"sandstone_grassland", "sandstone_grassland_ocean",
			"deciduous_forest", "deciduous_forest_ocean",
			"coniferous_forest", "coniferous_forest_ocean",
		},
		y_min = 5,
		y_max = 31000,
		decoration = "default:grass_"..length,
	})
end

register_grass_decoration(-0.03,  0.09,  5)
register_grass_decoration(-0.015, 0.075, 4)
register_grass_decoration(0,      0.06,  3)
register_grass_decoration(0.015,  0.045, 2)
register_grass_decoration(0.03,   0.03,  1)

-- Dry grasses

local function register_dry_grass_decoration(length)
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_dry_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.04,
			scale = 0.02,
			spread = {x=200, y=200, z=200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"savanna"},
		y_min = 5,
		y_max = 31000,
		decoration = "default:dry_grass_"..length,
	})
end

register_dry_grass_decoration(5)
register_dry_grass_decoration(4)
register_dry_grass_decoration(3)
register_dry_grass_decoration(2)
register_dry_grass_decoration(1)

-- Junglegrass

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 80,
	fill_ratio = 0.1,
	biomes = {"rainforest"},
	y_min = 1,
	y_max = 31000,
	decoration = "default:junglegrass",
})

-- Dry shrub

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:desert_sand", "default:dirt_with_snow"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.02,
		spread = {x=200, y=200, z=200},
		seed = 329,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"desert", "tundra"},
	y_min = 2,
	y_max = 31000,
	decoration = "default:dry_shrub",
})

-- Mushrooms

local function register_mushroom_decoration(name)
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x=200, y=200, z=200},
			seed = 7133,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"deciduous_forest", "coniferous_forest"},
		y_min = 6,
		y_max = 31000,
		decoration = "flowers:"..name,
	})
end

register_mushroom_decoration("mushroom_brown")
register_mushroom_decoration("mushroom_red")

minetest.log('action','[lunosky] Carregado!')
