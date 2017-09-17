

--Equação da esfera
--(x-xo)² + (y-yo)² + (z-zo)² = R² 
--centro = {xo,yo,zo}

function add_copa(pos, esp, leave, fruit, tax)
	if pos~=nil and esp~=nil 
		and leave~=nil and leave~="" and minetest.registered_items[leave]~=nil
	then
		Perimetro = {x,y,z}
		local cent = pos
		--local esp = {x=4,y=2,z=4}
		local raio = (((esp.x-cent.x)^2)+((esp.y-cent.y)^2)+((esp.z-cent.z)^2))^0.5
		local min_x = cent.x - esp.x
		local max_x = cent.x + esp.x
		local pos.x = min_x
		while (pos.x>=min_x and pos.x<=max_x) do
			local min_y = cent.y - esp.y
			local max_y = cent.y + esp.y
			local pos.y = min_y
			while (pos.y>=min_y and pos.y<=max_y) do
				local min_z = cent.z - esp.z
				local max_z = cent.z + esp.z
				local pos.z = min_z
				while (pos.z>=min_z and pos.z<=max_z) do
					local newraio = (((pos.x-cent.x)^2)+((pos.y-cent.y)^2)+((pos.z-cent.z)^2))^0.5
					if newraio <= raio and minetest.env:get_node(pos).name == "air" then
						if fruit~=nil and fruit~="" and minetest.registered_items[fruit]~=nil and tax~=nil and type(tax)=="number" and tax>=1 math.random(tax)==tax then
							minetest.add_node(pos, { name = fruit, param2 = 0} )
						else
							minetest.add_node(pos, { name = leave, param2 = 0} )
						end
					end
					pos.z = pos.z + 1
				end
				pos.y = pos.y + 1
			end
			pos.x = pos.x + 1
		end
	end
end

function add_tronco(pos, esp, alt, prof, wood)
	if pos~=nil 
		and esp~=nil and type(esp)=="number" and esp>=1 --espessura
		and alt~=nil and type(alt)=="number" and alt>=1 --altura
		and prof~=nil and type(prof)=="number" and prof>=1 --profundidade
		and wood~=nil and wood~="" and minetest.registered_items[wood]~=nil
	then
		local base = pos
		--local raiobase = (((esp.x-base.x)^2)+((esp.y-base.y)^2)+((esp.z-base.z)^2))^0.5
		
		
		local min_y = base.y - prof
		local max_y = base.y + alt
		local pos.y = min_y
		while (pos.y>=min_y and pos.y<=max_y) do
			local min_x = base.x - esp
			local max_x = base.x + esp
			local pos.x = min_x
			while (pos.x>=min_x and pos.x<=max_x) do
				local min_z = base.z - esp
				local max_z = base.z + esp
				local pos.z = min_z
				while (pos.z>=min_z and pos.z<=max_z) do
					--local newraio = (((pos.x-base.x)^2)+((pos.y-base.y)^2)+((pos.z-base.z)^2))^0.5
					local newraio = (((pos.x-base.x)^2)+((pos.z-base.z)^2))^0.5
					if newraio <= esp then
						minetest.add_node(pos, { name = wood, param2 = 0} )
					end
					pos.z = pos.z + 1
				end
				pos.x = pos.x + 1
			end
			pos.y = pos.y + 1
		end
	end
end

function add_maciera(pos)
	if pos~=nil then
		add_tronco(
			pos, --pos
			1, --espessura
			5, --altura
			2, --profundidade
			"default:wood" --id do tronco
		)
		add_copa(
			pos, --pos
			{x=4,y=2z=4}, --espessura
			"default:leave", --id das folhas
			"default:apple", --id das frutas
			30 --taxa de frutas/folha (1:30)
		)
	end
end

function add_laranjeira(pos)
	if pos~=nil then
		add_tronco(
			pos, --pos
			2, --espessura
			7, --altura
			3, --profundidade
			"default:wood" --id do tronco
		)
		add_copa(
			pos, --pos
			{x=6,y=4z=6}, --espessura
			"default:leave", --id das folhas
			"default:apple", --id das frutas
			30 --taxa de frutas/folha (1:30)
		)
	end
end