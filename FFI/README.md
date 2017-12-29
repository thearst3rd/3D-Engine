# **PSA: Don't use binary files in Lua 5.1**

## What the hell is all this crap?

### The Problem

It turns out, file IO in Lua is essentially only suitable for reading text. You can read numbers, but the numbers have to be in string format. So the number `1.0` needs to be represented as the bytes `31 2E 30` (the literal string "1.0") rather than the actual double-precision floating point bytes `00 00 00 00 00 00 F0 3F` (little-endian). In Lua, there is no file IO for reading the raw bytes as a double. Even though it would be trivial, since all numbers in Lua are (by default) doubles!

If I can write a function that takes in a string of 8 (binary) bytes and outputs the double it represents, then I am all set. Doing this is pure Lua would be absolutely horrific. I would need to:

* Decompose the string into the double's three components (sign, exp, mant)
* Perform the multiplication to turn those values back into the float it represents
* Potentially handle special cases like +/- Infinity and NaN?

And after all of this, the outputted number might not even be exactly correct because I need to represent the original 64 bit float by doing mathematically calculations that are all also only in the 64 bit space. There just has to be a better way.

Note: I also need to be able to read in unsigned ints, but those are a lot easier. I was even able to do all the math in Lua (which is just multiplying by powers of 0x100 and adding), but I still wanted a more fundamental solution.

### The Solution

LuaJIT's Foreign Function Interface (FFI) was the key to solving this puzzle. Pure Lua is not designed to handle low-level bitwise operations. But the FFI allows you to make calls to compiled C functions, and C is great at low-level bitwise calculations! My solution is as follows:

I wrote a very simple C function that casts a char * into a double * and dereferences it. Basically, you're telling the compiler that those bytes should be treated as a double, but doesn't actually change the contents of the bytes. Then the value is returned and Lua will understand the value as a double!

```c
double convertToDouble(const char str[])
{
	return *((double *) str);
}
```

Note that due to how the FFI handles conversions between Lua and C, the input parameter had to be `const char str[]` rather than just `char str[]`. I point this out because I didn't see that in the docs for a while and was pulling my hair out.

I also wrote an almost identical function for handling the unsigned ints, and after compiling them into a dll file and loading the library in the FFI, it works!

## How you can hope to get this running on your machine

If you're running on Windows, and you have an x86_64 processor (you probably do), then you can use the included dll file. If not though, you should compile the library yourself. I used gcc (MingW64) and my command line command was the following:

```
gcc -Wall -shared -o libReading.dll libReading.c
```

If you're not on Windows, note that the dll file extension will be different. And you will need to change the file name in `parseModel.lua`. 

If you don't have an x86_64 processor, be careful because the endian-ness of the floating points may be significant! I am assuming little-endian in the project because that is what x86 uses.

Once the dll is in place, running the program should work!