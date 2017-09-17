local path = minetest.get_modpath(minetest.get_current_modname())

dofile(path.."/api.lua")
dofile(path.."/item_pistol.lua")
dofile(path.."/item_riffle.lua")
dofile(path.."/item_shotgun.lua")
dofile(path.."/item_machine_gun.lua")

minetest.log('action','[LUNOSHOOTERS] Carregado!')
