-- Minetest 0.4 mod: easybones
-- See README.txt for licensing and other information.

local function is_owner(pos, name)
	local owner = minetest.get_meta(pos):get_string("owner")
	if owner == "" or owner == name or minetest.check_player_privs(name, "protection_bypass") then
		return true
	end
	return false
end

local easybones_formspec =
	"size[8,9]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[current_name;main;0,0.3;8,4;]" ..
	"list[current_player;main;0,4.85;8,1;]" ..
	"list[current_player;main;0,6.08;8,3;8]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0,4.85)

local share_easybones_time = tonumber(core.setting_get("share_easybones_time")) or 1200
local share_easybones_time_early = tonumber(core.setting_get("share_easybones_time_early")) or share_easybones_time / 4

local easybones = {}
easybones.waypoints = {}
easybones.waypoint_add = function(pos)
	local players = minetest.get_connected_players()
	for _, player in pairs(players) do
		--print("pos="..dump(pos))
		--print("easybones.waypoints="..dump(easybones.waypoints))
		easybones.waypoints[minetest.pos_to_string(pos)] = 
		player:hud_add({
			hud_elem_type = "waypoint",
			name = "Bones",
			number = "0X880088",
			world_pos = pos
		})
		--minetest.chat_send_player(player_name, "Add waypoint of new easybones!")
	end
	if minetest.get_modpath("lib_savevars") ~= nil then
		modsavevars.setGlobalValue("easybones_waypoints", easybones.waypoints)
		modsavevars.doSave()
	end
end
easybones.waypoint_remove = function(pos)
	local players = minetest.get_connected_players()
	for _, player in pairs(players) do
		if easybones.waypoints[minetest.pos_to_string(pos)] then 
			player:hud_remove(easybones.waypoints[minetest.pos_to_string(pos)])
			--easybones.pos = player:getpos()
			--minetest.chat_send_player(player:get_player_name(), "Remove waypoint of old easybones!")
			if minetest.get_modpath("lib_savelogs") ~= nil then
				modSaveLogs.addLog("[EASYBONES] The player '"..player:get_player_name().."' take of bones in "..minetest.pos_to_string(pos))
			end
		end
	end
	if minetest.get_modpath("lib_savevars") ~= nil then
		easybones.waypoints[minetest.pos_to_string(pos)] = nil
		modsavevars.setGlobalValue("easybones_waypoints", easybones.waypoints)
		modsavevars.doSave()
	end
end

if minetest.get_modpath("lib_savevars") ~= nil then
	modsavevars.doOpen()
	local waypoints = modsavevars.getGlobalValue("easybones_waypoints")
	--print("waypoints="..dump(waypoints))
	if waypoints~=nil then
		easybones.waypoints = waypoints
	end
	
	minetest.register_on_joinplayer(function(player)
		if easybones.waypoints~= nil then
			for postxt, waypoint in pairs(easybones.waypoints) do
				--print("postxt="..dump(postxt))
				easybones.waypoints[postxt] = player:hud_add({
					hud_elem_type = "waypoint",
					name = "Bones",
					number = "0X880088",
					world_pos = minetest.string_to_pos(postxt)
				})
			end
		end
	end)
end


minetest.register_node("easybones:easybones", {
	description = "Bones",
	tiles = {
		"easybones_top.png^[transform2",
		"easybones_bottom.png",
		"easybones_side.png",
		"easybones_side.png",
		"easybones_rear.png",
		"easybones_front.png"
	},
	paramtype2 = "facedir",
	groups = {dig_immediate = 2},
	sounds = default.node_sound_gravel_defaults(),

	can_dig = function(pos, player)
		local inv = minetest.get_meta(pos):get_inventory()
		local name = ""
		if player then
			name = player:get_player_name()
		end
		return is_owner(pos, name) and inv:is_empty("main")
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if is_owner(pos, player:get_player_name()) then
			return count
		end
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return 0
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if is_owner(pos, player:get_player_name()) then
			return stack:get_count()
		end
		return 0
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if meta:get_inventory():is_empty("main") then
			minetest.remove_node(pos)
			easybones.waypoint_remove(pos)
		end
	end,

	on_punch = function(pos, node, player)
		if not is_owner(pos, player:get_player_name()) then
			return
		end

		if minetest.get_meta(pos):get_string("infotext") == "" then
			return
		end

		local inv = minetest.get_meta(pos):get_inventory()
		local player_inv = player:get_inventory()
		local has_space = true

		for i = 1, inv:get_size("main") do
			local stk = inv:get_stack("main", i)
			if player_inv:room_for_item("main", stk) then
				inv:set_stack("main", i, nil)
				player_inv:add_item("main", stk)
			else
				has_space = false
				break
			end
		end

		-- remove easybones if player emptied them
		if has_space then
			if player_inv:room_for_item("main", {name = "easybones:easybones"}) then
				player_inv:add_item("main", {name = "easybones:easybones"})
			else
				minetest.add_item(pos,"easybones:easybones")
			end
			minetest.remove_node(pos)
		end
		
		easybones.waypoint_remove(pos)
	end,

	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local time = meta:get_int("time") + elapsed
		if time >= share_easybones_time then
			meta:set_string("infotext", meta:get_string("owner") .. "'s old easybones")
			meta:set_string("owner", "")
		else
			meta:set_int("time", time)
			return true
		end
	end,
	on_blast = function(pos)
	end,
})

local function may_replace(pos, player)
	local node_name = minetest.get_node(pos).name
	local node_definition = minetest.registered_nodes[node_name]

	-- if the node is unknown, we return false
	if not node_definition then
		return false
	end

	-- allow replacing air and liquids
	if node_name == "air" or node_definition.liquidtype ~= "none" then
		return true
	end

	-- don't replace filled chests and other nodes that don't allow it
	local can_dig_func = node_definition.can_dig
	if can_dig_func and not can_dig_func(pos, player) then
		return false
	end

	-- default to each nodes buildable_to; if a placed block would replace it, why shouldn't easybones?
	-- flowers being squished by easybones are more realistical than a squished stone, too
	-- exception are of course any protected buildable_to
	return node_definition.buildable_to and not minetest.is_protected(pos, player:get_player_name())
end

local drop = function(pos, itemstack)
	local obj = minetest.add_item(pos, itemstack:take_item(itemstack:get_count()))
	if obj then
		obj:setvelocity({
			x = math.random(-10, 10) / 9,
			y = 5,
			z = math.random(-10, 10) / 9,
		})
	end
end

minetest.register_on_dieplayer(function(player)

	local easybones_mode = core.setting_get("easybones_mode") or "easybones"
	if easybones_mode ~= "easybones" and easybones_mode ~= "drop" and easybones_mode ~= "keep" then
		easybones_mode = "easybones"
	end

	-- return if keep inventory set or in creative mode
	if easybones_mode == "keep" or (creative and creative.is_enabled_for
			and creative.is_enabled_for(player:get_player_name())) then
		return
	end

	local player_inv = player:get_inventory()
	if player_inv:is_empty("main") and
		player_inv:is_empty("craft") then
		return
	end

	local pos = vector.round(player:getpos())
	local player_name = player:get_player_name()

	-- check if it's possible to place easybones, if not find space near player
	if easybones_mode == "easybones" and not may_replace(pos, player) then
		local air = minetest.find_node_near(pos, 1, {"air"})
		if air and not minetest.is_protected(air, player_name) then
			pos = air
		else
			easybones_mode = "drop"
		end
	end

	if easybones_mode == "drop" then

		-- drop inventory items
		for i = 1, player_inv:get_size("main") do
			drop(pos, player_inv:get_stack("main", i))
		end
		player_inv:set_list("main", {})

		-- drop crafting grid items
		for i = 1, player_inv:get_size("craft") do
			drop(pos, player_inv:get_stack("craft", i))
		end
		player_inv:set_list("craft", {})

		drop(pos, ItemStack("easybones:easybones"))
		return
	end

	local param2 = minetest.dir_to_facedir(player:get_look_dir())
	minetest.set_node(pos, {name = "easybones:easybones", param2 = param2})

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("main", 8 * 4)
	inv:set_list("main", player_inv:get_list("main"))

	for i = 1, player_inv:get_size("craft") do
		local stack = player_inv:get_stack("craft", i)
		if inv:room_for_item("main", stack) then
			inv:add_item("main", stack)
		else
			--drop if no space left
			drop(pos, stack)
		end
	end

	player_inv:set_list("main", {})
	player_inv:set_list("craft", {})

	meta:set_string("formspec", easybones_formspec)
	meta:set_string("owner", player_name)

	if share_easybones_time ~= 0 then
		meta:set_string("infotext", player_name .. "'s fresh easybones")

		if share_easybones_time_early == 0 or not minetest.is_protected(pos, player_name) then
			meta:set_int("time", 0)
		else
			meta:set_int("time", (share_easybones_time - share_easybones_time_early))
		end

		minetest.get_node_timer(pos):start(10)
	else
		meta:set_string("infotext", player_name.."'s easybones")
	end
	
	--Add waypoint in easybones
	easybones.waypoint_add(pos)
end)
