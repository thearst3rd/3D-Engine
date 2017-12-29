-- Testing a quick 3D engine
-- by Terry Hearst

local camera = {}
local vertices = {}
local edges = {}

local config = {}

require "FFI/parseModel"

function love.load()
	-- Init config
	config.draw2D = false
	config.drawVertices = false
	config.numberVertices = false
	config.drawEdges = true
	
	-- Init camera
	camera.x = 0
	camera.y = 0
	camera.z = -3
	camera.ang = 0
	camera.pitch = 0
	
	-- Init 3D Model
	local filename = arg[2] and (arg[1] .. "/" .. arg[2]) or (arg[1] .. "/models/dodecahedron.hthwr")
	
	vertices, edges = parseModel(filename)
end

function love.update(dt)
	local scl = 5
	
	-- Move camera
	if love.keyboard.isDown("w") then
		camera.z = camera.z + (scl * dt * math.cos(camera.ang))
		camera.x = camera.x + (scl * dt * math.sin(camera.ang))
	end
	if love.keyboard.isDown("s") then
		camera.z = camera.z - (scl * dt * math.cos(camera.ang))
		camera.x = camera.x - (scl * dt * math.sin(camera.ang))
	end
	
	if love.keyboard.isDown("d") then
		camera.x = camera.x + (scl * dt * math.cos(-camera.ang))
		camera.z = camera.z + (scl * dt * math.sin(-camera.ang))
	end
	if love.keyboard.isDown("a") then
		camera.x = camera.x - (scl * dt * math.cos(-camera.ang))
		camera.z = camera.z - (scl * dt * math.sin(-camera.ang))
	end
	
	if love.keyboard.isDown("space") then
		camera.y = camera.y + scl * dt
	end
	if love.keyboard.isDown("lctrl") then
		camera.y = camera.y - scl * dt
	end
	
	-- Rotate camera
	if love.keyboard.isDown("right") then
		camera.ang = camera.ang + dt * math.pi
		if camera.ang >= 2 * math.pi then
			camera.ang = camera.ang - 2 * math.pi
		end
	end
	if love.keyboard.isDown("left") then
		camera.ang = camera.ang - dt * math.pi
		if camera.ang < 0 then
			camera.ang = camera.ang + 2 * math.pi
		end
	end
	if love.keyboard.isDown("up") then
		camera.pitch = camera.pitch + dt * math.pi
		if camera.pitch >= math.pi / 2 then
			camera.pitch = math.pi / 2
		end
	end
	if love.keyboard.isDown("down") then
		camera.pitch = camera.pitch - dt * math.pi
		if camera.pitch < -math.pi / 2 then
			camera.pitch = -math.pi / 2
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == '1' then
		config.draw2D = not config.draw2D
	elseif key == '2' then
		config.drawEdges = not config.drawEdges
	elseif key == '3' then
		config.drawVertices = not config.drawVertices
	elseif key == '4' then
		config.numberVertices = not config.numberVertices
	elseif key == 'r' then
		camera.x = 0
		camera.y = 0
		camera.z = -3
		camera.ang = 0
		camera.pitch = 0
	end
end

function love.draw()
	
	-- Draw a mock view of the camera in 2D
	if config.draw2D then
		for k, v in ipairs(edges) do
			v1x = vertices[v[1]][1] *  25 + 75
			v1y = vertices[v[1]][3] * -25 + 75
			
			v2x = vertices[v[2]][1] *  25 + 75
			v2y = vertices[v[2]][3] * -25 + 75
			
			love.graphics.line(v1x, v1y,  v2x, v2y)
		end
		local cx, cy
		cx = camera.x *  25 + 75
		cy = camera.z * -25 + 75
		love.graphics.circle("line", cx, cy, 4)
		love.graphics.line(cx, cy, cx + 16*math.sin(camera.ang), cy - 16*math.cos(camera.ang))
	end

	love.graphics.push()
		
		love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
		
		if config.drawEdges then
			for k, v in ipairs(edges) do
				drawEdge(v)
			end
		end
		
		if config.drawVertices then
			for k, vertex in ipairs(vertices) do
				local v = {x = vertex[1], y = vertex[2], z = vertex[3]}
				transformToCamera(v)
				if v.z > 0 then
					sx, sy = project3Dto2D(v)
					love.graphics.circle("fill", sx, sy, math.max(8 - 0.5*(v.z^2), 2))
					if config.numberVertices then
						love.graphics.print(k, sx, sy - 20)
					end
				end
			end
		end
		
	love.graphics.pop()
end

-- HIGH LEVEL FUNCTIONS --

function drawEdge(edge)
	local v1o = vertices[edge[1]]
	local v2o = vertices[edge[2]]
	
	-- Make copies (so we can transform them around the player)
	local v1 = {x = v1o[1], y = v1o[2], z = v1o[3]}
	local v2 = {x = v2o[1], y = v2o[2], z = v2o[3]}
	
	drawEdgeFromVertices(v1, v2)
end

function drawPoint(vertex)
	local v = {x = vertex[1], y = vertex[2], z = vertex[3]}
	transformToCamera(v)
	if v.z > 0 then
		sx, sy = project3Dto2D(v)
		love.graphics.circle("fill", sx, sy, math.max(8 - 0.5*(v.z^2), 2))
	end
end

-- LOWER LEVEL HELPER FUNCTIONS --

-- Takes in a table with two numbers, each indicating a vertex
function drawEdgeFromVertices(v1, v2)
	transformToCamera(v1)
	transformToCamera(v2)
	
	-- Make sure edge is visible
	if (v1.z > 0) or (v2.z > 0) then
		if v1.z < 0 then
			-- Calculate intersection with plane at z = 0
			local depth = v2.z - v1.z + 0.01
			local n = v2.z / depth
			v1.z = 0.01
			v1.x = lerp(n, v1.x, v2.x)
			v1.y = lerp(n, v1.y, v2.y)
		elseif v2.z < 0 then
			local depth = v1.z - v2.z + 0.01
			local n = -v2.z / depth
			v2.z = 0.01
			v2.x = lerp(n, v1.x, v2.x)
			v2.y = lerp(n, v1.y, v2.y)
		end
		
		-- Calculate vertices's on screen coords
		local v1ScreenX, v1ScreenY = project3Dto2D(v1)
		local v2ScreenX, v2ScreenY = project3Dto2D(v2)
		
		love.graphics.line(v1ScreenX, v1ScreenY, v2ScreenX, v2ScreenY)
	end
end

function transformToCamera(v)
	-- Translate based on position
	v.x = v.x - camera.x
	v.y = v.y - camera.y
	v.z = v.z - camera.z
	
	-- Rotate world based on angle
	-- Yaw
	local radius, angle
	radius = math.sqrt((v.x ^ 2) + (v.z ^ 2))
	angle = (math.pi / 2) - math.atan2(v.z, v.x)
	angle = angle - camera.ang
	v.x = radius * math.sin(angle)
	v.z = radius * math.cos(angle)
	
	-- Pitch
	radius = math.sqrt((v.y ^ 2) + (v.z ^ 2))
	angle = (math.pi / 2) - math.atan2(v.z, v.y)
	angle = angle - camera.pitch
	v.y = radius * math.sin(angle)
	v.z = radius * math.cos(angle)
	
	--return v
end

function project3Dto2D(v)
	local sx = v.x / v.z * 300
	local sy = -v.y / v.z * 300
	return sx, sy
end

-- Linearly interpolates from minval to maxval, where n is from 0 to 1
function lerp(n, minval, maxval)
	return (n * minval) + ((1 - n) * maxval)
end