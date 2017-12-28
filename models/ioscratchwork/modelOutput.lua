-- Outputs a valid hthwr file based on tables for vertices and edges
-- by Terry Hearst

-- ***** MAIN FUNCTION ***** --

function main()
	-- Open file in "write binary" mode
	local file = io.open("output_" .. os.time() .. ".hthwr", "wb")
	
	-- Write header
	file:write("hth3wire")
	writeUnsigned(file, #vertices)
	writeUnsigned(file, #edges)
	
	-- Dump vertices
	for i = 1, #vertices do
		writeDouble(file, vertices[i][1])
		writeDouble(file, vertices[i][2])
		writeDouble(file, vertices[i][3])
	end
	
	-- Dump edges
	for i = 1, #edges do
		writeUnsigned(file, edges[i][1])
		writeUnsigned(file, edges[i][2])
	end
	
	io.close(file)
end


-- ***** HELPER FUNCTIONS ***** --

function writeUnsigned(file, data)
	local str = string.pack("I", data)
	file:write(str)
end

function writeDouble(file, data)
	local str = string.pack("d", data)
	file:write(str)
end


-- ***** MODEL DEFINITION ***** --

vertices = {}
edges = {}

-- Init vertices {x, y, z}
vertices[1]  = { 1,  1,  1}
vertices[2]  = {-1,  1,  1}
vertices[3]  = { 1, -1,  1}
vertices[4]  = {-1, -1,  1}
vertices[5]  = { 1,  1, -1}
vertices[6]  = {-1,  1, -1}
vertices[7]  = { 1, -1, -1}
vertices[8]  = {-1, -1, -1}

local h = (math.sqrt(5) - 1) / 2
local h2 = h * h

vertices[9]  = {0,  1 + h,  1 - h2}
vertices[10] = {0, -1 - h,  1 - h2}
vertices[11] = {0,  1 + h, -1 + h2}
vertices[12] = {0, -1 - h, -1 + h2}

vertices[13] = { 1 + h,  1 - h2, 0}
vertices[14] = {-1 - h,  1 - h2, 0}
vertices[15] = { 1 + h, -1 + h2, 0}
vertices[16] = {-1 - h, -1 + h2, 0}

vertices[17] = { 1 - h2, 0,  1 + h}
vertices[18] = { 1 - h2, 0, -1 - h}
vertices[19] = {-1 + h2, 0,  1 + h}
vertices[20] = {-1 + h2, 0, -1 - h}

-- Init edges
edges[1]  = {11,  5}
edges[2]  = { 5, 18}
edges[3]  = {18, 20}
edges[4]  = {20,  6}
edges[5]  = { 6, 11}

edges[6]  = { 5, 13}
edges[7]  = {13, 15}
edges[8]  = {15,  7}
edges[9]  = { 7, 18}
--          {18,  5}

edges[10] = {11,  9}
edges[11] = { 9,  1}
edges[12] = { 1, 13}
--          {13,  5}
--          { 5, 11}

edges[13] = { 1, 17}
edges[14] = {17,  3}
edges[15] = { 3, 15}
--          {15, 13}
--          {13,  1}

edges[16] = { 9,  2}
edges[17] = { 2, 19}
edges[18] = {19, 17}
--          {17,  1}
--          { 1,  9}

edges[19] = { 2, 14}
edges[20] = {14, 16}
edges[21] = {16,  4}
edges[22] = { 4, 19}
--          {19,  2}

--          { 9, 11}
--          {11,  6}
edges[23] = { 6, 14}
--          {14,  2}
--          { 2,  9}

--          { 6, 20}
edges[24] = {20,  8}
edges[25] = { 8, 16}
--          {16, 14}
--          {14,  6}

--          {20, 18}
--          {18,  7}
edges[26] = { 7, 12}
edges[27] = {12,  8}
--          { 8, 20}

--          {17, 19}
--          {19,  4}
edges[28] = { 4, 10}
edges[29] = {10,  3}
--          { 3, 17}

edges[30] = {12, 10}


-- ***** RUN MAIN ***** --

main()