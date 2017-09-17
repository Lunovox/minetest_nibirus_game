minetest.register_tool("lunoshooters:shotgun", {
	description = "Escopeta (12mm)",
	inventory_image = "shooter_shotgun.png",
	groups = { shooters=1 },
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		lunoshooters:fire_weapon(user, pointed_thing, {
			name = name,
			range = 16,
			step = 15,
			tool_caps = {full_punch_interval=1.5, damage_groups={fleshy=4}},
			groups = {cracky=3, snappy=2, crumbly=2, choppy=2, fleshy=1, oddly_breakable_by_hand=1},
			sound = "shooter_shotgun",
			particle = "smoke_puff.png",
		})
		itemstack:add_wear(1311) -- 50 Rounds
		return itemstack
	end,
})

minetest.register_craft({
	output = "lunoshooters:shotgun",
	recipe = {
		{"default:steel_ingot", "", ""},
		{"", "default:steel_ingot", ""},
		{"", "default:mese_crystal", "default:bronze_ingot"},
	},
})

minetest.register_alias("shotgun",		"lunoshooters:shotgun")
minetest.register_alias("espingarda",	"lunoshooters:shotgun")
minetest.register_alias("escopeta",		"lunoshooters:shotgun")
minetest.register_alias("12mm",			"lunoshooters:shotgun")
