/**
	Various string utility functions not found in Phobos.
*/
module dstringutils.utils;

import std.algorithm;
import std.regex;
import std.conv;
import std.array;
import std.traits;

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
string formatNumber(const string number) @safe
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
string formatNumber(T)(const T number) @safe
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
bool hasOnlySpaces(const string text) pure @safe
{
	return text.length == text.countChars(" ") ? true : false;
}

///
unittest
{
	"   ".hasOnlySpaces.should.equal(true);
	"1   ".hasOnlySpaces.should.equal(false);
	"x   ".hasOnlySpaces.should.equal(false);
	" xall   s".hasOnlySpaces.should.equal(false);
}

/**
	Counts the number of characters in a string.

	Params:
		value = The string to count.

	Returns:
		The number of characters in the string.
*/
size_t countChars(T)(const T value) pure @safe
{
	return count(value);
}

///
unittest
{
	"hello".countChars.should.equal(5);
	"今日は".countChars.should.equal(3);
	"Привет".countChars.should.equal(6);
}

/**
	Counts the number of characters in a string.

	Params:
		value = The string to count.
		charToFind = The character to find in the string.

	Returns:
		The number of characters in the string.
*/
size_t countChars(T, S)(const T value, const S charToFind) pure @safe
{
	return count(value, charToFind);
}

///
unittest
{
	";; this is a test;".countChars(";").should.equal(3);
	";; this is a test;".countChars(" ").should.equal(4);
	"今日は".countChars("は").should.equal(1);
	"Привет".countChars("П").should.equal(1);
}

/**
	Removes all specified characters from the string.

	Params:
		value = The string from which characters will be removed.
		charToRemove = The character to remove from value.

	Returns:
		The modified value that has the specified character removed.
*/
T removeChars(T, S)(const T value, const S charToRemove) pure @safe
{
	return value.replace(charToRemove, "");
}

unittest
{
	removeChars("hello world", "l").should.equal("heo word");
	removeChars("hello world", "d").should.equal("hello worl");
	removeChars("hah", "h").should.equal("a");
}

/**
	Removes all specified characters from the string.

	Params:
		value = The string from which characters will be removed.
		charToRemove = The character to remove from value.
*/
void removeCharsEmplace(T, S)(ref T value, const S charToRemove) pure @safe
{
	value = value.replace(charToRemove, "");
}

unittest
{
	string hellol = "hello world";
	string hellod = "hello world";
	string hah = "hah";

	hellol.removeCharsEmplace("l");
	hellod.removeCharsEmplace("d");
	hah.removeCharsEmplace("h");

	hellol.should.equal("heo word");
	hellod.should.equal("hello worl");
	hah.should.equal("a");
}

/**
	Removes the character from the beginning of a string.

	Params:
		str = The string to remove characters from.
		charToRemove = The character to remove.

	Returns:
		The modified string with all characters to be removed are removed.
*/
string removeLeadingChars(T)(string str, const T charToRemove) pure @safe
{
	while(!str.empty)
	{
		immutable auto c = str.front;

		if(c != charToRemove)
		{
			break;
		}

		str.popFront();
	}


	return str;
}

///
unittest
{
	"--help".removeLeadingChars('-').should.equal("help");
	"help-me".removeLeadingChars('-').should.equal("help-me");
	"--help-me".removeLeadingChars('-').should.equal("help-me");
}

/**
	Modifies the passed string by removing the character specified.

	Params:
		str = The string to remove characters from.
		charToRemove = The character to remove.
*/
void removeLeadingCharsEmplace(T)(ref string str, const T charToRemove) pure @safe
{
	while(!str.empty)
	{
		immutable auto c = str.front;

		if(c != charToRemove)
		{
			break;
		}

		str.popFront();
	}
}

///
unittest
{
	string value = "--help";
	string anotherValue = "--help-me";

	value.removeLeadingCharsEmplace('-');
	anotherValue.removeLeadingCharsEmplace('-');

	value.should.equal("help");
	anotherValue.should.equal("help-me");
}

/**
	Determines is a character is a vowel

	Params:
		vowelChar = The character to check.

	Returns:
		true if the character is a vowel false otherwise.
*/
bool isVowelChar(T)(const T vowelChar) pure @safe
	if(isSomeChar!T)
{
	immutable string vowels = "aeiouAEIOU";
	return vowels.canFind!(a => a == vowelChar);
}

///
unittest
{
	'a'.isVowelChar.should.equal(true);
	'e'.isVowelChar.should.equal(true);
	'i'.isVowelChar.should.equal(true);
	'o'.isVowelChar.should.equal(true);
	'u'.isVowelChar.should.equal(true);
	'b'.isVowelChar.should.equal(false);
	'z'.isVowelChar.should.equal(false);

	'A'.isVowelChar.should.equal(true);
	'E'.isVowelChar.should.equal(true);
	'I'.isVowelChar.should.equal(true);
	'O'.isVowelChar.should.equal(true);
	'U'.isVowelChar.should.equal(true);
	'B'.isVowelChar.should.equal(false);
	'Z'.isVowelChar.should.equal(false);
}

/**
	Determines is a character is a vowel

	Params:
		value = The character to check.

	Returns:
		true if the character is a vowel false otherwise. This function will also return false if
		the string length is 0 or greater than 1.
*/
bool isVowelChar(T)(const T value) pure @safe
	if(isSomeString!T)
{
	if(value.length == 1)
	{
		return isVowelChar(value[0]);
	}

	return false;
}

unittest
{
	"a".isVowelChar.should.equal(true);
	"e".isVowelChar.should.equal(true);
	"i".isVowelChar.should.equal(true);
	"o".isVowelChar.should.equal(true);
	"u".isVowelChar.should.equal(true);
	"b".isVowelChar.should.equal(false);
	"z".isVowelChar.should.equal(false);

	"A".isVowelChar.should.equal(true);
	"E".isVowelChar.should.equal(true);
	"I".isVowelChar.should.equal(true);
	"O".isVowelChar.should.equal(true);
	"U".isVowelChar.should.equal(true);
	"B".isVowelChar.should.equal(false);
	"Z".isVowelChar.should.equal(false);

	"Hello".isVowelChar.should.equal(false);
	"".isVowelChar.should.equal(false);
}

/**
	Converts each argument to a string.

	Params:
		args = The arguments to convert.

	Returns:
		A string array containing the arguments converted to a string.
*/
string[] toStringAll(T...)(T args) @safe
{
	string[] output;
	auto app = appender(output);

	foreach(arg; args)
	{
		app.put(to!string(arg));
	}

	return app.data;
}

///
unittest
{
	equal(toStringAll(10, 15), ["10", "15"]).should.equal(true);
	equal(toStringAll(4.1, true, "hah", 5000), ["4.1", "true", "hah", "5000"]).should.equal(true);
}

/**
	Converts an array to a string array.

	Params:
		values = The array to convert.

	Returns:
		A string array containing the arguments converted to a string.
*/
string[] toStringAll(T)(T[] values) @safe
{
	string[] output;
	auto app = appender(output);

	foreach(value; values)
	{
		app.put(to!string(value));
	}

	return app.data;
}

///
unittest
{
	equal(toStringAll([ 1, 2, 3, 4 ]), [ "1", "2", "3", "4" ]).should.equal(true);
}

/**
	Determines where a string is made up of multiple words. Note that using _ between words also counts.

	Params:
		value = The string to check for multiple words.

	Returns:
		True if the string contains multiple words false otherwise.
*/
bool hasMultipleWords(T)(const T value) pure @safe
	if(isSomeString!T)
{
	return value.canFind("_", " ") >= 1;
}

///
unittest
{
	hasMultipleWords("hello world").should.equal(true);
	hasMultipleWords("hello").should.equal(false);
}

/**
	Converts a boolean value to a Yes or No string.

	Params:
		value = The boolean value to convert.

	Returns:
		Either a Yes for a true value or No for a false value.
*/
string toYesNo(T)(const T value)
{
	import std.typecons : isIntegral, isBoolean;

	static if(isIntegral!T)
	{
		return (value == 1) ? "Yes" : "No";
	}
	else static if(isBoolean!T)
	{
		return value ? "Yes" : "No";
	}
	else
	{
		return "No";
	}
}

///
unittest
{
	true.toYesNo.should.equal("Yes");
	false.toYesNo.should.equal("No");
	1.toYesNo.should.equal("Yes");
	0.toYesNo.should.equal("No");
	"hellow world".toYesNo.should.equal("No");
}

/**
	Determines if a string is empty.

	Params:
		value = The value to test.

	Returns:
		True if the value is empty false otherwise.
*/
bool isEmpty(T)(T value)
	if(isSomeString!T)
{
	return value.length == 0;
}

unittest
{
	string zeroLength;
	string hasLength = "Hello World!";

	zeroLength.isEmpty.should.equal(true);
	hasLength.isEmpty.should.equal(false);
}

/**
	Sorts the passed string. Only string type is supported.

	Params:
		value = The value to sort.

	Returns:
		The sorted value.
*/
T sortString(T)(T value)
{
	return sort(value.to!(dchar[])).to!T;
}

unittest
{
	string hello = "hello";
	string japanese = "ういおえあ";
	string sortMe = "sortMe".sortString;

	sortString(hello).should.equal("ehllo");
	sortString(japanese).should.equal("あいうえお");
	sortMe.should.equal("Meorst");
}
