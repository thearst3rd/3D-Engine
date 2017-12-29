// Reading operations that can't (easily) be performed in Lua 5.1
// by Terry Hearst

#include <stdio.h>

double convertToDouble(const char str[])
{
	return *((double *) str);
}

unsigned convertToUnsigned(const char str[])
{
	return *((unsigned *) str);
}