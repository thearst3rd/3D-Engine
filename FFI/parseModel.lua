-- Library for parsing the an hthwr file into vertices and edges

local ffi = require "ffi"
local lib = ffi.load(arg[1] .. "/FFI/libReading.dll")

ffi.cdef[[
double convertToDouble(const char[]);
unsigned convertToUnsigned(const char[]);
]]

local function readUnsigned(file)
	return lib.convertToUnsigned(file:read(4))
end

local function readDouble(file)
	return lib.convertToDouble(file:read(8))
end

-- Parses the hthwr file into lua tables for use by the program.
-- Takes: filename (string)
-- Returns: vertices, edges (both tables)
function parseModel(filename)
	-- Open the file in "read binary" mode
	local file = io.open(filename, "rb")
	assert(file, "Unable to open file '" .. filename .. "'")
	
	-- Parse header
	assert(file:read(8) == "hth3wire", "Invalid .hthwr file")
	
	local nVertices = readUnsigned(file)
	local nEdges = readUnsigned(file)
	
	-- Parse data
	local vertices = {}
	for i = 1, nVertices do
		vertices[i] = {}
		vertices[i][1] = readDouble(file)
		vertices[i][2] = readDouble(file)
		vertices[i][3] = readDouble(file)
	end
	
	local edges = {}
	for i = 1, nEdges do
		edges[i] = {}
		edges[i][1] = readUnsigned(file)
		edges[i][2] = readUnsigned(file)
	end
	-- Cleanup
	io.close(file)
	
	return vertices, edges
end