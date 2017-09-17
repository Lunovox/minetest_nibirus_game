local modname = minetest.get_current_modname()
local path = minetest.get_modpath(modname)

print(minetest.get_modpath('default'))

dofile(path.."/mapgen.lua")
dofile(path.."/new_sky.lua")

dofile(path.."/api_resttrees.lua")
dofile(path.."/drop_grass.lua")
--dofile(path.."/api_addtree.lua")
dofile(path.."/tree_sakuraba.lua")
dofile(path.."/tree_palmeira.lua")
dofile(path.."/tree_mangaranja.lua")


minetest.log('action',"["..modname:upper().."] Carregado!")

