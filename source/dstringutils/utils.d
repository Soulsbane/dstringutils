module dstringutils.utils;

import std.regex;
import std.conv;
import std.string;

/**
	Formats a number using commas. Example 1000 => 1,000.

	Params:
		number = The number to format.

	Returns:
		The formatted number;
*/
string formatNumber(const string number)
{
	auto re = regex(r"(?<=\d)(?=(\d\d\d)+\b)","g");
	return number.replaceAll(re, ",");
}

///
unittest
{
	assert(formatNumber("100") == "100");
	assert(formatNumber("1000") == "1,000");
	assert(formatNumber("1000000") == "1,000,000");
}

/**
	Formats a number using commas. Example 1000 => 1,000.

	Params:
		number = The number to format.

	Returns:
		The formatted number;
*/
string formatNumber(const size_t number)
{
	return number.to!string.formatNumber;
}

///
unittest
{
	assert(formatNumber(100) == "100");
	assert(formatNumber(1000) == "1,000");
	assert(formatNumber(1000000) == "1,000,000");
}

/**
	Checks a string for the presense of only whitespace.

	Params:
		text = The string to check.

	Returns:
		True of the string only contains whitespaces false otherwise.
*/
bool hasOnlySpaces(const string text)
{
	return text.length == text.countchars(" ") ? true : false;
}

///
unittest
{
	immutable string spaces = "   ";
	immutable string spaces1 = "1   ";
	immutable string spacesx = "x   ";
	immutable string mixed = " xall   s";

	assert(spaces.hasOnlySpaces);
	assert(!spaces1.hasOnlySpaces);
	assert(!spacesx.hasOnlySpaces);
	assert(!mixed.hasOnlySpaces);
}