-- Attempt to parse my 3D model file
-- by Terry Hearst

-- ***** MAIN FUNCTION ***** --

function main()
	-- Open the file in "read binary" mode
	local file = io.open(arg[1] or "testbin.hthwr", "rb")
	
	-- Parse header
	assert(file:read(8) == "hth3wire", "Invalid .hthwr file")
	local nVertices = readUnsigned(file)
	local nEdges = readUnsigned(file)
	
	print("Number of vertices: ", nVertices)
	print("Number of edges: ", nEdges)
	
	-- Parse data
	for i = 1, nVertices do
		print("Vertex " .. i .. ": ", readDouble(file), readDouble(file), readDouble(file))
	end
	
	for i = 1, nEdges do
		print("Edge " .. i .. ": ", readUnsigned(file), readUnsigned(file))
	end
	
	-- Cleanup
	io.close(file)
end


-- ***** HELPER FUNCTIONS ***** --

function readUnsigned(file)
	local i = string.unpack("I", file:read(4))
	return i
end

function readDouble(file)
	local f = string.unpack("d", file:read(8))
	return f
end


-- ***** RUN MAIN ***** --
main()