--code for "Main blue source cube"
minetest.register_node("beacon:blue", {
	description = "Blue Beacon",
	tiles = {"bluebeacon.png"},
	light_source = 13,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	drop = "beacon:blue",
	on_destruct = function(pos) --remove the beam above a source when source is removed
		for i=1,180 do
			if minetest.get_node(pos.y+i).name=="beacon:bluebase" or minetest.get_node(pos.y+i).name=="beacon:bluebeam" then
				minetest.remove_node({x=pos.x, y=pos.y+i, z=pos.z}) --thanks Morn76 for this bit of code!
			end
		end
	end
})

--Blue Beam
minetest.register_node("beacon:bluebase", {
	visual_scale = 1.0,
	drawtype = "plantlike",
	tiles = {"bluebase.png"},
	paramtype = "light",
	walkable = false,
	diggable = false,
	pointable = true,
	buildable_to = true,	light_source = 13,
	groups = {not_in_creative_inventory=1}
})

minetest.register_node("beacon:bluebeam", {
	visual_scale = 1.0,
	drawtype = "plantlike",
	tiles = {"bluebeam.png"},
	paramtype = "light",
	walkable = false,
	diggable = false,
	pointable = true,
	buildable_to = true,
	light_source = 50,
	groups = {not_in_creative_inventory=1}
})

minetest.register_abm({
	nodenames = {"beacon:blue"},
	interval = 5,
	chance = 1,
	action = function(pos)
		pos.y = pos.y + 1
		if minetest.get_node(pos).name=="ignore" or minetest.get_node(pos).name=="air" then
			minetest.add_node(pos, {name="beacon:bluebase"})
			for i=1,179 do
				minetest.add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="beacon:bluebeam"})
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"beacon:bluebase"}, --makes small particles emanate from the beginning of a beam
	interval = 1,
	chance = 2,
	action = function(pos, node)
		minetest.add_particlespawner(
			32, --amount
			4, --time
			{x=pos.x-0.25, y=pos.y-0.25, z=pos.z-0.25}, --minpos
			{x=pos.x+0.25, y=pos.y+0.25, z=pos.z+0.25}, --maxpos
			{x=-0.8, y=-0.8, z=-0.8}, --minvel
			{x=0.8, y=0.8, z=0.8}, --maxvel
			{x=0,y=0,z=0}, --minacc
			{x=0,y=0,z=0}, --maxacc
			0.5, --minexptime
			1, --maxexptime
			1, --minsize
			2, --maxsize
			false, --collisiondetection
			"blueparticle.png" --texture
		)
	end,
})
