# 3D Engine in Love2D

A little engine I made for fun to learn about perspective calculations. I thought it would be a fun little challenge making a 3D program with a game engine which only supports 2D. Nothing in here is optimized and I am taking the lazy route for most of the work. It works, though.

Right now, I have hard-coded the coordinates of a regular dodecahedron.

### Controls

The control scheme is the following, including some debug-ish commands.

| Key | Action |
| --- | --- |
| WASD | Move in the 2D plane |
| Space | Move upwards |
| Left control | Move downwards |
| Arrow keys | Rotate camera |
| 1 | Toggle rendering 2D projection |
| 2 | Toggle rendering edges |
| 3 | Toggle rendering vertices |
| 4 | Toggle vertex numbering (only if vertices are being rendered) |

## Running the Program

Open `main.lua` with [Love2D](https://love2d.org/wiki/Main_Page). I am using version 0.10.2, so to be safe you should use that verion.