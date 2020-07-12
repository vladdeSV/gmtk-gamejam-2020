module game.misc;

import std.algorithm : filter;
import std.file : DirEntry, dirEntries, SpanMode;
import std.array : array, split, join;
import game.player : Player;

DirEntry[] filesInFolder(string folder)
{
	return dirEntries(folder, SpanMode.breadth).filter!(a => a.isFile()).array();
}

DirEntry[] foldersInFolder(string folder)
{
	return dirEntries(folder, SpanMode.breadth).filter!(a => !a.isFile()).array();
}

string filenameFromFilePath(string fp)
{
	return fp.split("\\")[$ - 1];
}

void deleteFile(string path)
{
	import std.file : remove;
	import std.string : toStringz;
	remove(path);
}

string md5(string s)
{
	import std.conv : to;
	import std.digest.md;

	auto md5 = new MD5Digest();
    ubyte[] hash = md5.digest(s);

	return cast(string)(hash);
}


// removes ".\game" from a file path
string removeGamePath(string path)
{
	auto parts = path.split("\\");

	if (parts.length == 2)
	{
		if (parts == [".", "game"])
		{
			return "";
		}
	}
	else if (parts.length > 2)
	{
		if (parts[0 .. 2] == [".", "game"])
		{
			parts = parts[2 .. $];
		}
	}

	return parts.join("\\");
}

string removePlayerNameFromPath(string path)
{
	auto parts = path.split("\\");

	if (parts[$ - 1] == Player.name)
	{
		parts.length -= 1;
	}

	return parts.join("\\");
}
