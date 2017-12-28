# .HTHWR 3D Model File Format

I have created a simple 3D model file format for use with my program. The file extension is `.hthwr`, for my initals (HTH) and wire (wr).

The basic idea behind the file structure is that we store a bunch of vertices at the beginning, then define the "edges" using pairs of vertex indexes.

## File Structure Details

The exact file structure maps onto the following.

**HEADER**
* Literal string `hth3wire` **(char array, 8 bytes)**
* Number of vertices **(unsigned int, 4 bytes)**
* Number of edges **(unsigned int, 4 bytes)**

**DATA**
* Vertex 1's x-coordinate **(double, 8 bytes)**
* Vertex 1's y-coordinate **(double, 8 bytes)**
* Vertex 1's z-coordinate **(double, 8 bytes)**
* ... (repeat for each vertex)

After all vertices are done,
* Edge 1's first vertex **(unsigned int, 4 bytes)**
* Edge 1's second vertex **(unsigned int, 4 bytes)**
* ... (repeat for each edge)

### NOTES

Since this was designed around the Lua programming language, the first vertex defined by the file will have an index of **1, not 0**! This means when declaring your edges, if you want to have an edge between your first and second vertices in the file, **the edge indexes have to be 1 and 2, NOT 0 and 1**!

# Extra Tools

I have supplied the scratchwork tools I used to make the output files (and make sure I'm reading the properly) in the folder `ioscratchwork`. It won't really be maintained, I just copied it from the other folder in My Documents that I was using to work on it. It will be useful for generating model files though. It also includes a file that I created from scratch with a hex editor (testbin.hthwr), as well as the output from running modelOutput.lua (output_1514444644.hthwr, which is the same as dodecahedron in the parent folder).