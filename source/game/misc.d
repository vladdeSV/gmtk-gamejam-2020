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
