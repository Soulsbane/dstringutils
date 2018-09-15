module dstringutils.interpolate;

import std.string, std.regex, std.stdio;

/// Match a D identifier prefixed by a '$'
private enum matchVars = `\$[_a-zA-Z][_a-zA-Z0-9]*`;

/**
	Extracts the variables from the string and puts them into a comma-separated string.
 */
private string findVariables(const string value) pure nothrow @safe
{
	string variables = "";
	size_t position = 0;

	bool isIdentifierStart(char c)
	{
		return c == '_' || (c >= 'A' && c <= 'Z') ||
			(c >= 'a' && c <= 'z');
	}

	bool isIdentifierChar(char c)
	{
		return isIdentifierStart(c) || (c >= '0' && c <= '9');
	}

	while(position < value.length)
	{
		if(value[position] == '$')
		{
			position++;

			if(position < value.length)
			{
				if(isIdentifierStart(value[position]))
				{
					do
					{
						variables ~= value[position];
					}
					while(++position < value.length && isIdentifierChar(value[position]));
					variables ~= ',';
				}
			}
			else
			{
				break;
			}
		}
		else
		{
			position++;
		}
	}

	if(variables.length > 0)
	{
		return variables[0..$ - 1];
	}

	return variables;
}

template Format(string value)
{
	enum Format = `format(std.regex.replace("` ~ value ~ `", regex(matchVars, "g"), "%s"), `~
					findVariables(value) ~ ")";
}

string inContextFormat(string value, T)(T context) @safe
{
	with(context)
	{
		return mixin(Format!value);
	}
}

///
@("Interpolate Related Functions")
unittest
{
	immutable string hello = "Hello World!";
	immutable size_t date = 5081934;
	immutable double amount = 3.58;
	immutable string expanded = mixin(Format!("$hello I was born on $date and have $$amount for cash."));

	assert(expanded == "Hello World! I was born on 5081934 and have $3.58 for cash.");

	struct TestContext
	{
		string name;
		double amount;
	}

	auto context = TestContext("cake", 3.50);
	immutable string expandedContext = context.inContextFormat!("You only have $$amount dollars. My favorite food is $name.");

	assert(expandedContext == "You only have $3.5 dollars. My favorite food is cake.");

	struct MyTest
	{
		string hello = "Well hellow there.";

		string SayIt()
		{
			return this.inContextFormat!("$hello");
		}
	}

	MyTest my;
	immutable string say = my.SayIt();

	assert(say == "Well hellow there.");
}

