

--Red Beam generation
minetest.register_abm({
	nodenames = {"beacon:red"},
	interval = 5,
	chance = 1,
	action = function(pos)
		pos.y = pos.y + 1
		if minetest.get_node(pos).name=="ignore" or minetest.get_node(pos).name=="air" then
			minetest.add_node(pos, {name="beacon:redbase"})
			for i=1,179 do
				minetest.add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="beacon:redbeam"})
			end
		end
	end,
})

--Green Beam generation
minetest.register_abm({
	nodenames = {"beacon:green"},
	interval = 5,
	chance = 1,
	action = function(pos)
		pos.y = pos.y + 1
		if minetest.get_node(pos).name=="ignore" or minetest.get_node(pos).name=="air" then
			minetest.add_node(pos, {name="beacon:greenbase"})
			for i=1,179 do
				minetest.add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="beacon:greenbeam"})
			end
		end
	end,
})

--Purple Beam Generation
minetest.register_abm({
	nodenames = {"beacon:purple"},
	interval = 5,
	chance = 1,
	action = function(pos)
		pos.y = pos.y + 1
		if minetest.get_node(pos).name=="ignore" or minetest.get_node(pos).name=="air" then
			minetest.add_node(pos, {name="beacon:purplebase"})
			for i=1,179 do
				minetest.add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="beacon:purplebeam"})
			end
		end
	end,
})


