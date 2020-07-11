import std.stdio;

import core.thread : Thread, msecs;
import game.folders.chapta.folder_chapta_1;
import game.folders.folder;
import game.misc;
import game.player : Player;
import std.array : join, split;
import std.experimental.logger;
import std.file : mkdirRecurse, DirEntry, rmdirRecurse, exists;
import std.string : toStringz;

void main()
{
	if (exists(".\\game"))
	{
		rmdirRecurse(".\\game");
		Thread.sleep(1000.msecs);
	}

	
	auto start = createGameFolder();
	createFolderStructure(start);

	auto player = new Player(start);

	bool run = true;
	while (run)
	{
		checkFolderRec(start);
		createFolderStructure(start);

		detectPlayer(start, player);
		//player.info();

		Thread.sleep(1000.msecs);
	}
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

void detectPlayer(Folder root, Player player)
{
	auto dirEntries = filesInFolder(".\\game");

	foreach (DirEntry dirEntry; dirEntries)
	{
		import std.stdio : readln;

		string fileData = File(dirEntry.name).readln;

		if (fileData == Player.data)
		{
			string physicalLocation = dirEntry.name.removeGamePath.removePlayerNameFromPath;
			string virtualLocation = player.currentlyInFolder.getFolderPath.removeGamePath;
			if (physicalLocation != virtualLocation)
			{
				writeln("physical location does not match virtual location");
				writeln("  phys: ", physicalLocation);
				writeln("  virt: ", virtualLocation);

				Folder sfolder = root.subfolder(physicalLocation);
				if (sfolder is null)
				{
					writeln("player is in illigal folder");
					writeln("moving player from '", dirEntry.name, "' to '",
							player.currentlyInFolder.getFolderPath, "'");
					import std.string : toStringz;

					int renameStatus = rename(dirEntry.name.toStringz(),
							(player.currentlyInFolder.getFolderPath ~ "\\" ~ Player.name).toStringz());
					writeln(renameStatus,
							": moving player from illigal folder back to current folder");
					continue;
				}

				writeln("moving player to ", sfolder.getFolderPath());
				player.moveToFolder(sfolder);
			}
		}
	}
}

Folder subfolder(Folder root, string path)
{
	Folder curr = root;
	foreach (string p; path.split("\\"))
	{
		if (!root.hasChildWithName(p))
			return null;

		curr = root.children[p];
	}

	return curr;
}

Folder createGameFolder()
{
	auto start = new Folder("game", true);

	auto chaptaFolder = new FolderChapta1();
	start.addChild(chaptaFolder);

	return start;
}

/+void initFolderRec(Folder folder)
{
	folder.onCreate();

	foreach (child; folder.children)
	{
		initFolderRec(child);
	}
}+/

void checkFolderRec(Folder folder)
{
	if (!folder.inited)
	{
		return;
	}

	folder.onUpdate();

	if (folder.isFolderCompleted())
	{
		folder.onFolderCompleted();
	}

	foreach (child; folder.children)
	{
		checkFolderRec(child);
	}
}

void createFolderStructure(Folder folder, string[] pathParts = ["."])
{
	string path = pathParts.join("\\") ~ "\\" ~ folder.name;
	mkdirRecurse(path);

	foreach (child; folder.children)
	{
		if (!child.visible)
		{
			continue;
		}

		createFolderStructure(child, pathParts ~ folder.name);
	}
}
