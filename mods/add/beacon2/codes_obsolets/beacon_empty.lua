--code for "unactivated beacon"
minetest.register_node("beacon:empty", {
	description = "Unactivated Beacon",
	tiles = {"emptybeacon.png"},
	light_source = 3,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	drop = "beacon:empty",
})

minetest.register_craft({
	output = 'beacon:empty',
	recipe = {
		{'default:steel_ingot', 'default:glass', 'default:steel_ingot'},
		{'default:mese_crystal_fragment', 'default:torch', 'default:mese_crystal_fragment'},
		{'default:obsidian', 'default:obsidian', 'default:obsidian'},
	}
})
