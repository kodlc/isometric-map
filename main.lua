--[[

KNOWN ISSUES:
	- the tile height on isometric projection can only be adjusted on the top view map because that's very intuitive
	- and mainly because I haven't figured it out yet
	- you'll get error when trying to adjust height of the map edges
	- also some other unimportant stuff

TODO: 
	- clean up the code in the draw method and make it more compact because this is painful to read
	- fix issues listed above

]]

lg = love.graphics
lm = love.mouse 

GRID = 40
WIDTH = lg.getWidth()
HEIGHT = lg.getHeight()

-- number of columns and rows of the map
SIZE = 10

function love.load()
	-- this is the base tile
	base = { x = WIDTH/2, y = GRID*4, d = GRID, h = 0 }


	map = {}
	isomap = {}

	-- create grid map
	for y = 0, SIZE-1 do
		map[y] = {}
		for x = 0, SIZE-1 do 
			-- adjust the points in the map for the isometric view
			local new = {
				x = base.x + base.d * x - base.d * y,
				y = base.y + base.d/2 * y + base.d/2 * x,
				d = base.d or GRID,
				h = base.h or 0
			}
			map[y][x] = new
		end
	end

end

function love.update(dt)
	mouse = {x = math.floor(lm.getX()/GRID), y = math.floor(lm.getY()/GRID)}

	-- update the tile heights
	for y = 0, #map do
		isomap[y] = {}
		for x = 0, #map[1] do
			local new = {
				map[y][x].x, map[y][x].y - map[y][x].h*map[y][x].d/4,
				map[y][x].x + map[y][x].d, map[y][x].y + map[y][x].d/2 - map[y][x].h*map[y][x].d/4,
				map[y][x].x, map[y][x].y + map[y][x].d- map[y][x].h*map[y][x].d/4,
				map[y][x].x - map[y][x].d, map[y][x].y + map[y][x].d/2 - map[y][x].h*map[y][x].d/4,
				h = map[y][x].h
			}
			isomap[y][x] = new
		end
	end


end

function love.draw()
	for y = 0, SIZE-1 do
		-- draw the isometric projection
		for x = 0, SIZE-1 do
			lg.setColor(1,0.5+isomap[y][x].h/10,0.5+isomap[y][x].h/10) -- this is my elaborate calculation for the tile color that I came up with at the time. not sure why exactly.
			lg.polygon("fill", isomap[y][x])

			if isomap[y][x].h > 0 then

				lg.setColor(1,0.3,0.3)
				lg.polygon("fill", isomap[y][x][3], isomap[y][x][4], 
					isomap[y][x+1][1], isomap[y][x+1][2], 
					isomap[y][x+1][7], isomap[y][x+1][8],
					isomap[y][x][5], isomap[y][x][6])

				lg.setColor(1,0.2,0.2,0.3)
				lg.polygon("line", isomap[y][x][3], isomap[y][x][4], 
					isomap[y][x+1][1], isomap[y][x+1][2], 
					isomap[y][x+1][7], isomap[y][x+1][8],
					isomap[y][x][5], isomap[y][x][6])

				lg.setColor(1,0.6,0.6)
				lg.polygon("fill", isomap[y][x][7], isomap[y][x][8], 
					isomap[y][x][5], isomap[y][x][6],
					isomap[y+1][x][3], isomap[y+1][x][4], 
					isomap[y+1][x][1], isomap[y+1][x][2])

				lg.setColor(1,0.2,0.2,0.3)
				lg.polygon("line", isomap[y][x][7], isomap[y][x][8], 
					isomap[y][x][5], isomap[y][x][6],
					isomap[y+1][x][3], isomap[y+1][x][4], 
					isomap[y+1][x][1], isomap[y+1][x][2])

			elseif isomap[y][x].h < 0 then

				if isomap[y][x].h < isomap[y][x-1].h then
					lg.setColor(1,0.3,0.3)
					lg.polygon("fill", isomap[y][x-1][3], isomap[y][x-1][4], 
						isomap[y][x][1], isomap[y][x][2], 
						isomap[y][x][7], isomap[y][x][8],
						isomap[y][x-1][5], isomap[y][x-1][6])

					lg.setColor(1,0.2,0.2,0.3)
					lg.polygon("line", isomap[y][x-1][3], isomap[y][x-1][4], 
						isomap[y][x][1], isomap[y][x][2], 
						isomap[y][x][7], isomap[y][x][8],
						isomap[y][x-1][5], isomap[y][x-1][6])
				end
					
				if isomap[y][x].h < isomap[y-1][x].h then
					lg.setColor(1,0.6,0.6)
					lg.polygon("fill", isomap[y-1][x][7], isomap[y-1][x][8], 
						isomap[y-1][x][5], isomap[y-1][x][6],
						isomap[y][x][3], isomap[y][x][4], 
						isomap[y][x][1], isomap[y][x][2])

					lg.setColor(1,0.2,0.2,0.3)
					lg.polygon("line", isomap[y-1][x][7], isomap[y-1][x][8], 
						isomap[y-1][x][5], isomap[y-1][x][6],
						isomap[y][x][3], isomap[y][x][4], 
						isomap[y][x][1], isomap[y][x][2])
				end
				
			end

			lg.setColor(1,0.2,0.2,0.3)
			lg.polygon("line", isomap[y][x])

			if mouse.y <= #map and mouse.x <= #map[1] then
				lg.setColor(1,0.2,0.2)
			  	lg.polygon("fill", isomap[mouse.y][mouse.x])
			end
			
			-- draw the normal grid on the left
			lg.setColor(1,0.2,0.2,0.1)
		  	lg.rectangle("line", x*GRID, y*GRID, GRID, GRID)
		  	lg.setColor(1,0.2,0.2,0.3)
		  	lg.print(map[y][x].h, x*GRID, y*GRID)
		end

	end

end

-- change the height of a tile
function love.wheelmoved(x, y)
	local mx, my = mouse.x, mouse.y
	if map[my] ~= nil then
		if map[my][mx] ~= nil then 
			if y > 0 then 
				map[my][mx].h = map[my][mx].h + 1
			elseif y < 0 then
				map[my][mx].h = map[my][mx].h - 1
			end
		end 
	end
end
