minetest.register_tool("lunoshooters:pistol", {
	description = "Pistola",
	inventory_image = "shooter_pistol.png",
	groups = { shooters=1 },
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		lunoshooters:fire_weapon(user, pointed_thing, {
			name = name,
			range = 100,
			step = 20,
			tool_caps = {
				full_punch_interval=0.2,  --[[ padrao: 0.5--]]
				damage_groups={fleshy=2}
			},
			groups = {snappy=3, fleshy=3, oddly_breakable_by_hand=3},
			sound = "shooter_pistol",
			particle = "shooter_cap.png",
		})
		itemstack:add_wear(328) -- 200 Rounds
		return itemstack
	end,
})

minetest.register_craft({
	output = "lunoshooters:pistol",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"", "default:mese_crystal"},
	}
})

minetest.register_alias("pistol"	,			"lunoshooters:pistol")
minetest.register_alias("pistola",			"lunoshooters:pistol")

