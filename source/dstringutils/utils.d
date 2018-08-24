/**
	Various string utility functions not found in Phobos.
*/
module dstringutils.utils;

import std.algorithm;
import std.regex;
import std.conv;
import std.array;
import std.traits;

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
	assert(formatNumber("100") == "100");
	assert(formatNumber("1000") == "1,000");
	assert(formatNumber("1000000") == "1,000,000");
	assert(formatNumber("-1000000") == "-1,000,000");
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
	assert(formatNumber(100) == "100");
	assert(formatNumber(1000) == "1,000");
	assert(formatNumber(1_000_000) == "1,000,000");
	assert(formatNumber(-1_000_000) == "-1,000,000");
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
	assert("   ".hasOnlySpaces == true);
	assert("1   ".hasOnlySpaces == false);
	assert("x   ".hasOnlySpaces == false);
	assert(" xall   s".hasOnlySpaces == false);
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
	assert("hello".countChars == 5);
	assert("今日は".countChars == 3);
	assert("Привет".countChars == 6);
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
	assert(";; this is a test;".countChars(";") == 3);
	assert(";; this is a test;".countChars(" ") == 4);
	assert("今日は".countChars("は") == 1);
	assert("Привет".countChars("П") == 1);
}

/**
	Removes all specified characters from the string.

	Params:
		value = The string from which characters will be removed.
		charToRemove = The character to remove from value.

	Returns:
		The modified value that has the specified character removed.
*/
T removeChars(T, S)(const T value, const S charToRemove) @safe
{
	auto re = regex("[" ~ charToRemove ~ "]", "g");
	return value.replaceAll(re, "");
}

///
unittest
{
	assert(removeChars("hello world", "l") == "heo word");
	assert(removeChars("hello world", "d") == "hello worl");
	assert(removeChars("hah", "h") == "a");
	assert(removeChars("hello world", "el") == "ho word");
	assert(removeChars("is this really a sentence", "li") == "s ths reay a sentence");
}

/**
	Removes all specified characters from the string.

	Params:
		value = The string from which characters will be removed.
		charToRemove = The character to remove from value.
*/
void removeCharsEmplace(T, S)(ref T value, const S charToRemove) @safe
{
	auto re = regex("[" ~ charToRemove ~ "]", "g");
	value = value.replaceAll(re, "");
}

///
unittest
{
	string hellol = "hello world";
	string hellod = "hello world";
	string hah = "hah";
	string hello2 = "hello world";
	string sentence = "is this really a sentence";

	hellol.removeCharsEmplace("l");
	hellod.removeCharsEmplace("d");
	hah.removeCharsEmplace("h");
	hello2.removeCharsEmplace("el");
	sentence.removeCharsEmplace("li");

	assert(hellol == "heo word");
	assert(hellod == "hello worl");
	assert(hah == "a");
	assert(hello2 == "ho word");
	assert(sentence == "s ths reay a sentence");
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
	assert("--help".removeLeadingChars('-') == "help");
	assert("help-me".removeLeadingChars('-') == "help-me");
	assert("--help-me".removeLeadingChars('-') == "help-me");
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

	assert(value == "help");
	assert(anotherValue == "help-me");
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
	assert('a'.isVowelChar == true);
	assert('e'.isVowelChar == true);
	assert('i'.isVowelChar == true);
	assert('o'.isVowelChar == true);
	assert('u'.isVowelChar == true);
	assert('b'.isVowelChar == false);
	assert('z'.isVowelChar == false);

	assert('A'.isVowelChar == true);
	assert('E'.isVowelChar == true);
	assert('I'.isVowelChar == true);
	assert('O'.isVowelChar == true);
	assert('U'.isVowelChar == true);
	assert('B'.isVowelChar == false);
	assert('Z'.isVowelChar == false);
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

///
unittest
{
	assert("a".isVowelChar == true);
	assert("e".isVowelChar == true);
	assert("i".isVowelChar == true);
	assert("o".isVowelChar == true);
	assert("u".isVowelChar == true);
	assert("b".isVowelChar == false);
	assert("z".isVowelChar == false);

	assert("A".isVowelChar == true);
	assert("E".isVowelChar == true);
	assert("I".isVowelChar == true);
	assert("O".isVowelChar == true);
	assert("U".isVowelChar == true);
	assert("B".isVowelChar == false);
	assert("Z".isVowelChar == false);

	assert("Hello".isVowelChar == false);
	assert("".isVowelChar == false);
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
	assert(equal(toStringAll(10, 15), ["10", "15"]) == true);
	assert(equal(toStringAll(4.1, true, "hah", 5000), ["4.1", "true", "hah", "5000"]) == true);
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
	assert(equal(toStringAll([ 1, 2, 3, 4 ]), [ "1", "2", "3", "4" ]) == true);
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
	assert(hasMultipleWords("hello world") == true);
	assert(hasMultipleWords("hello") == false);
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
	assert(true.toYesNo == "Yes");
	assert(false.toYesNo == "No");
	assert(1.toYesNo == "Yes");
	assert(0.toYesNo == "No");
	assert("hellow world".toYesNo == "No");
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

///
unittest
{
	string zeroLength;
	string hasLength = "Hello World!";

	assert(zeroLength.isEmpty == true);
	assert(hasLength.isEmpty == false);
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

///
unittest
{
	string hello = "hello";
	string japanese = "ういおえあ";
	string sortMe = "sortMe".sortString;

	assert(sortString(hello) == "ehllo");
	assert(sortString(japanese) == "あいうえお");
	assert(sortMe == "Meorst");
}
