module game.misc;

import std.algorithm : filter;
import std.file : DirEntry, dirEntries, SpanMode;
import std.array : array, split;

DirEntry[] filesInFolder(string folder)
{
	return dirEntries(folder, SpanMode.breadth).filter!(a => a.isFile()).array();
}

/+
DirEntry[] foldersInFolder(string folder)
{
	return dirEntries(folder, SpanMode.breadth).filter!(a => !a.isFile()).array();
}
+/

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
