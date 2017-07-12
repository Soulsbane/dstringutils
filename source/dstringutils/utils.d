module dstringutils.utils;

import std.algorithm;
import std.regex;
import std.conv;
import std.string;
import std.array;

version(unittest)
{
	import fluent.asserts;
}

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
	formatNumber("100").should.equal("100");
	formatNumber("1000").should.equal("1,000");
	formatNumber("1000000").should.equal("1,000,000");
	formatNumber("-1000000").should.equal("-1,000,000");
}

/**
	Formats a number using commas. Example 1000 => 1,000.

	Params:
		number = The number to format.

	Returns:
		The formatted number;
*/
string formatNumber(T)(const T number)
{
	return number.to!string.formatNumber;
}

///
unittest
{
	formatNumber(100).should.equal("100");
	formatNumber(1000).should.equal("1,000");
	formatNumber(1_000_000).should.equal("1,000,000");
	formatNumber(-1_000_000).should.equal("-1,000,000");
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
	"   ".hasOnlySpaces.should.equal(true);
	"1   ".hasOnlySpaces.should.equal(false);
	"x   ".hasOnlySpaces.should.equal(false);
	" xall   s".hasOnlySpaces.should.equal(false);
}

size_t countChars(T)(const T value) pure @safe
{
	return count(value);
}

///
unittest
{
	"hello".countChars.should.equal(5);
}

T removeChars(T, S)(const T value, const S charToRemove)
{
	return value.replace(charToRemove, "");
}

unittest
{
    removeChars("hello world", "l").should.equal("heo word");
    removeChars("hello world", "d").should.equal("hello worl");
    removeChars("hah", "h").should.equal("a");
}
