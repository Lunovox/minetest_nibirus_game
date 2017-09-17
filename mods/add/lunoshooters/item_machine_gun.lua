minetest.register_tool("lunoshooters:machine_gun", {
	description = "Metralhadora (UZI)",
	inventory_image = "shooter_smgun.png",
	--tool_capabilities = { },
	groups = { shooters=1 },
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		for i = 0, 0.45, 0.15 do
			minetest.after(i, function()
				lunoshooters:fire_weapon(user, pointed_thing, {
					name = name,
					range = 60,
					step = 20, --padrao: 20
					tool_caps = {
						full_punch_interval=0.1,  --[[ padrao: 0.1--]]
						damage_groups={fleshy=2} --padrao: fleshy=2
					},
					groups = {snappy=3, fleshy=3, oddly_breakable_by_hand=3},
					sound = "shooter_pistol",
					particle = "shooter_cap.png",
				})
			end)
			itemstack:add_wear(328) -- 4 x 200 Rounds
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "lunoshooters:machine_gun",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"", "default:bronze_ingot", "default:mese_crystal"},
		{"", "default:bronze_ingot", ""},
	},
})

minetest.register_alias("machine_gun",		"lunoshooters:machine_gun")
minetest.register_alias("metralhadora",	"lunoshooters:machine_gun")
minetest.register_alias("metrelhadora",	"lunoshooters:machine_gun")

