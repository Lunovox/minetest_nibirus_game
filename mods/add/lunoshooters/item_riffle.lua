minetest.register_tool("lunoshooters:riffle", {
	description = "Rifle Sniper (AK-45)",
	inventory_image = "shooter_sniper_rifle.png",
	groups = { shooters=1 },
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		lunoshooters:fire_weapon(user, pointed_thing, {
			name = name,
			range = 200,
			step = 200, --padrão:30
			tool_caps = {
				full_punch_interval=1.0, --padrao: 1.0
				damage_groups={fleshy=8}
			},
			--groups = {snappy=3, crumbly=3, choppy=3, fleshy=2, oddly_breakable_by_hand=2},
			groups = {snappy=3, crumbly=3, choppy=3, fleshy=8, oddly_breakable_by_hand=2},
			sound = "shooter_riffle",
			particle = "shooter_bullet.png",
		})
		itemstack:add_wear(656) -- 100 Rounds
		return itemstack
	end,
})

minetest.register_craft({
	output = "lunoshooters:riffle",
	recipe = {
		{"default:steel_ingot", "", ""},
		{"", "default:bronze_ingot", ""},
		{"", "default:mese_crystal", "default:bronze_ingot"},
	},
})

minetest.register_alias("riffle"	,			"lunoshooters:riffle")
minetest.register_alias("rifle",				"lunoshooters:riffle")
minetest.register_alias("AK45",				"lunoshooters:riffle")

